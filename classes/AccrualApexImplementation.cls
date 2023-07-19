public inherited sharing class AccrualApexImplementation {
    static String CURRENTCLASSNAME  = AccrualApexImplementation.class.getName();
    static Decimal APIVERSION = [SELECT ApiVersion FROM ApexClass WHERE Name = :CURRENTCLASSNAME WITH SECURITY_ENFORCED Limit 1].ApiVersion;
   
    static final String DT_PRODUCT_BASED_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/custom/decisionTableAction/Calculate_Points_Awarded_Based_on_Product_and_Tier_Default';
    static final String DT_ACCRUAL_BASED_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/custom/decisionTableAction/Calculate_Points_to_Credit_Based_on_Activity_Default';    
    static final String CREDIT_POINTS_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/standard/creditPoints';
    
    static final String PROGRAM_NAME = 'Partner Extraa Program';
    static final String NQP_CURRENCY = 'Points';
    
    //AccruePointsProductCategory Custom Object Developer Names
    static final String ACCRUAL_CATALOG = 'AccruePointsProductCategory__c';
    static final String ACCRUAL_LOYALTY_TIER = 'LoyaltyTier__c';
    static final String ACCRUAL_MINIMUM_PRICE = 'MinimumPrice__c';
    static final String ACCRUAL_MAXIMUM_PRICE = 'MaximumPrice__c';
    static final String ACCRUAL_MINIMUM_QUANTITY = 'MinimumQuantity__c';
    static final String ACCRUAL_MAXIMUM_QUANTITY = 'MaximumQuantity__c';
    static final String ACCRUAL_PRODUCT = 'Product__c';
    static final String ACCRUAL_CATEGORY = 'ProductCategory__c';
    
    //LoyaltyActivity Custom Object Developer Names
    static final String ACTIVITY_CATALOG = 'LoyaltyActivity__c';
    static final String ACTIVITY_CATEGORY = 'ActivityCategory__c';
    static final String ACTIVITY_JOURNALSUBTYPE = 'JournalSubType__c';
    static final String[] ACTIVITY_SUBTYPES = new List<String>{'Activity'};
    static final String[] PRODUCT_SUBTYPES = new List<String>{'Product'};
    
    public Integer executeAccrualApex(TransactionJournal[] accrualTransactions){
        TransactionJournal[] accrualsActivityBased = new List<TransactionJournal>();
        TransactionJournal[] accrualsProductBased = new List<TransactionJournal>();
        TransactionJournal[] accrualTransactionsMatched = new List<TransactionJournal>();
        TransactionJournal[] noMatchAccrualTransactions = new List<TransactionJournal>();
        Double[] pointsToAccrue = new List<Double>();

        for (TransactionJournal accrualTransaction : accrualTransactions){
            if (ACTIVITY_SUBTYPES.contains(accrualTransaction.JournalSubType.RuleType__c)){
                accrualsActivityBased.add(accrualTransaction);

            } else if (PRODUCT_SUBTYPES.contains(accrualTransaction.JournalSubType.RuleType__c)){
                accrualsProductBased.add(accrualTransaction);
            }
        }

        activityBasedProcess(accrualsActivityBased, accrualTransactionsMatched, noMatchAccrualTransactions, pointsToAccrue);
        productBasedProcess(accrualsProductBased, accrualTransactionsMatched, noMatchAccrualTransactions, pointsToAccrue);

        executeAction(CREDIT_POINTS_ACTION_URL,createActionJSON('Credit Action', null, null, accrualTransactionsMatched, pointsToAccrue));
        DMLManager.DBupdate(noMatchAccrualTransactions);
        return noMatchAccrualTransactions.size();
    }

    void activityBasedProcess(TransactionJournal[] accrualTransactions,
                              TransactionJournal[] accrualTransactionsMatched,
                              TransactionJournal[] noMatchAccrualTransactions,
                              Double[] pointsToAccrue){
        /*Get Accrual Rule from DT created on Loyalty Activity*/
        LoyaltyActivity__c[] matchedRules = getActivityBasedAccrualRulePoints(accrualTransactions);

        /*Get Points of Accrual Rule for all Accrual Activity based Transactions*/
        Integer pos = 0;
        for(LoyaltyActivity__c matchedRule : matchedRules){
            //Filtering Transactions with Any Match rules in Accrual DT
            if (matchedRule != null){
                pointsToAccrue.add(matchedRule.PointsAccrued__c);
                accrualTransactionsMatched.add(accrualTransactions[pos]);
            } else {
                accrualTransactions[pos].Status = 'Error';
                noMatchAccrualTransactions.add(accrualTransactions[pos]);
            }
            pos++;
        }
    }

    void productBasedProcess(TransactionJournal[] accrualTransactions,
                             TransactionJournal[] accrualTransactionsMatched,
                             TransactionJournal[] noMatchAccrualTransactions,
                             Double[] pointsToAccrue){
        /*Get ProductCategory Names from ProductCategory entity for all ProductIds in Accrual Transactions*/
        Map<Id, String> productCategoryNames = getProductCategoryNames(accrualTransactions);

        /*Get Accrual Rule from DT created on AccruePointsProductCategory*/
        AccruePointsProductCategory__c[] matchedRules = getProductBasedAccrualRulePoints(accrualTransactions, productCategoryNames);

        /*Get Points based on Reward Type of Accrual Rule for all Accrual Transactions*/
        Integer pos = 0;
        for(AccruePointsProductCategory__c matchedRule : matchedRules){
            //Filtering Transactions with Any Match rules in Accrual DT
            if (matchedRule != null){
                Double accruedPoints = 0; 
                if (matchedRule.AccruePointsBasedOn__c == 'Invoice Price' && accrualTransactions[pos].TransactionAmount != null){
                    accruedPoints = accrualTransactions[pos].TransactionAmount * matchedRule.Accrued_Points__c;
                } else if (matchedRule.AccruePointsBasedOn__c == 'Product Quantity' && accrualTransactions[pos].Quantity != null){
                    //AccruePoints based on 'Product Quantity'
                    accruedPoints = accrualTransactions[pos].Quantity * matchedRule.Accrued_Points__c;
                } else {
                    //TransactionAmount or Quantity not mentioned in TransactionJournal for points evaluation but Any Match exists in DT
                    accruedPoints = 0;
                }
                pointsToAccrue.add(accruedPoints);
                accrualTransactionsMatched.add(accrualTransactions[pos]);
                
                //Credit extra bonus points based on Promotion
                Boolean IsBonusEligible = checkPromotionReward(accrualTransactions[pos], productCategoryNames);
                if(IsBonusEligible){
                    accrualTransactionsMatched.add(accrualTransactions[pos]);
                    pointsToAccrue.add(accruedPoints * 0.5);
                }
                
            } else {
                accrualTransactions[pos].Status = 'Error';
                noMatchAccrualTransactions.add(accrualTransactions[pos]);
            }
            pos++;
        }
    }

    private Boolean checkPromotionReward(TransactionJournal accrualTransaction, Map<Id, String> productCategoryNames){
        String productCategoryName = productCategoryNames.get(accrualTransaction.ProductCategoryId);
        if(productCategoryName != null
           && productCategoryName.equals('Accessories')
           && accrualTransaction.ActivityDate >= date.newInstance(2021, 09, 01)
           && accrualTransaction.ActivityDate <= date.newInstance(2021, 12, 31)) {
            return true;
           } else {
            return false;
        }

    }

    LoyaltyActivity__c[] getActivityBasedAccrualRulePoints(TransactionJournal[] accrualTransactions){

        /*Calling Activity based DTAction to get Matched Rules and filtering all unmatched TransactionJournals*/
        String actionPayloadString = createActionJSON('Activity Based Accrual', null, null, accrualTransactions, null);
        String dtResponse = executeAction(DT_ACCRUAL_BASED_ACTION_URL, actionPayloadString);
        DTResponseJsonToApex dtResponseJsonToApex = new DTResponseJsonToApex();
        List<DTResponseJsonToApex> dtResponseApexList = dtResponseJsonToApex.parse(dtResponse);

        List<LoyaltyActivity__c> matchedRules = new List<LoyaltyActivity__c>();
        for (DTResponseJsonToApex dtResponseApex : dtResponseApexList ){
            if (dtResponseApex.isSuccess && !dtResponseApex.getOutcomeType().equalsIgnoreCase('No Match')){
                matchedRules.add((LoyaltyActivity__c)dtResponseApex.getsingleOutcome());
            } else {
                //If No Match found or any Error in DTAction for Accrual Catalog for a TransactionJournal details, We will skip processing it
                matchedRules.add(null);
            }
        }
        return matchedRules;
    }

    AccruePointsProductCategory__c[] getProductBasedAccrualRulePoints(TransactionJournal[] accrualTransactions, Map<Id, String> productCategoryNames){

        /*Get Member's Loyalty Tier for all Accrual Transactions*/
        Map<Id, Id> memberLoyaltyTierId = getMemberLoyaltyTierIds(accrualTransactions);
        
        /*Calling Product based DTAction to get Matched Rules and filtering all unmatched TransactionJournals*/
        String actionPayloadString = createActionJSON('Product Based Accrual', memberLoyaltyTierId, productCategoryNames, accrualTransactions, null);
        String dtResponse = executeAction(DT_PRODUCT_BASED_ACTION_URL, actionPayloadString);
        DTResponseJsonToApex dtResponseJsonToApex = new DTResponseJsonToApex();
        List<DTResponseJsonToApex> dtResponseApexList = dtResponseJsonToApex.parse(dtResponse);

        
        List<AccruePointsProductCategory__c> matchedRules = new List<AccruePointsProductCategory__c>();
        for (DTResponseJsonToApex dtResponseApex : dtResponseApexList ){
            if (dtResponseApex.isSuccess && !dtResponseApex.getOutcomeType().equalsIgnoreCase('No Match')){
                matchedRules.add((AccruePointsProductCategory__c)dtResponseApex.getsingleOutcome());
            } else {
                //If No Match found or any Error in DTAction for Accrual Catalog for a TransactionJournal details, We will skip processing it
                matchedRules.add(null);
            }
        }
        return matchedRules;
    }
    
    private Map<Id, Id> getMemberLoyaltyTierIds(TransactionJournal[] accrualTransactions){
        Set<Id> accrualsMemberIds = new Set<Id>();
        for(TransactionJournal accrualTransaction : accrualTransactions){
            accrualsMemberIds.add(accrualTransaction.MemberId);
        }
        LoyaltyMemberTier[] loyaltyMemberTiers = [SELECT LoyaltyMemberId,LoyaltyTierId FROM LoyaltyMemberTier WHERE LoyaltyMemberId in :accrualsMemberIds WITH SECURITY_ENFORCED];
        Map<Id, Id> memberLoyaltyTierId = new Map<Id, Id>();
        for (LoyaltyMemberTier loyaltyMemberTier : loyaltyMemberTiers){
            memberLoyaltyTierId.put(loyaltyMemberTier.LoyaltyMemberId, loyaltyMemberTier.LoyaltyTierId );
        }
        return memberLoyaltyTierId;
    }
    
    private Map<Id, String> getProductCategoryNames(TransactionJournal[] accrualTransactions){
        Set<Id> accrualsProductCategoryIds = new Set<Id>();
        for(TransactionJournal accrualTransaction : accrualTransactions){
            accrualsProductCategoryIds.add(accrualTransaction.ProductCategoryId);
        }
        ProductCategory[] productCategories = [SELECT Id,Name FROM ProductCategory WHERE Id in :accrualsProductCategoryIds WITH SECURITY_ENFORCED];
        Map<Id, String> productCategoryNames = new Map<Id, String>();
        for (ProductCategory productCategory : productCategories){
            productCategoryNames.put(productCategory.Id, productCategory.Name );
        }
        return productCategoryNames;
    }
    
    /*Custom Class to help in deseriliasing DTAction Response*/
    private class DTOutputValue{
        String outcomeType;
        List<sObject> outcomeList;
        sObject singleOutcome;    
    }
    
    private class DTResponseJsonToApex {
        String actionName;
        Object errors;
        boolean isSuccess;
        DTOutputValue outputValues;
        public List<DTResponseJsonToApex> parse(String jsonString) { 
            return (List<DTResponseJsonToApex>)JSON.deserialize(jsonString, List<DTResponseJsonToApex>.class);
        }
        public String getOutcomeType(){ return outputValues.outcomeType;} 
        public sObject getsingleOutcome(){ return outputValues.singleOutcome;}
    }
    
    private String executeAction(String actionUrl, String actionPayloadString){
        HttpResponse actionHttpResponse = RedemptionRestUtil.executeInvocableActionRestAPI('POST',actionUrl, actionPayloadString);
        return actionHttpResponse.getBody();
    }
    
    private String createActionJSON(String actionType,
                                    Map<Id, Id> memberLoyaltyTierId,
                                    Map<Id, String> productCategoryNames,
                                    TransactionJournal[] accrualTransactions,
                                    Double[] pointsToAccrue)
    {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('inputs'); 
        gen.writeStartArray();
        if (actionType.equalsIgnoreCase('Activity Based Accrual')){
            activityBasedDTJSON(gen,accrualTransactions );
        }  else if (actionType.equalsIgnoreCase('Product Based Accrual')) {
            productBasedDTJSON(gen, memberLoyaltyTierId, productCategoryNames, accrualTransactions );
        }  else if (actionType.equalsIgnoreCase('Credit Action')){
            creditActionJSON(gen, accrualTransactions, pointsToAccrue );
        }      
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
    
    void activityBasedDTJSON(JSONGenerator gen, TransactionJournal[] accrualTransactions){
        for(TransactionJournal accrualTransaction:accrualTransactions){
            gen.writeStartObject();
            if (accrualTransaction.ActivityCategory__c != null){ 
                gen.writeStringField(ACTIVITY_CATEGORY, accrualTransaction.ActivityCategory__c);
            }
            if (accrualTransaction.JournalSubTypeId != null){ 
                gen.writeIdField(ACTIVITY_JOURNALSUBTYPE, accrualTransaction.JournalSubTypeId);
            }
            gen.writeEndObject();
        } 
    }
    
    void productBasedDTJSON(JSONGenerator gen, 
                            Map<Id, Id> memberLoyaltyTierId,
                            Map<Id, String> productCategoryNames,
                            TransactionJournal[] accrualTransactions)
    {
        Integer pos = 0;
        for(TransactionJournal accrualTransaction:accrualTransactions){
            gen.writeStartObject();
            gen.writeFieldName(ACCRUAL_CATALOG);
            gen.writeStartObject();
            gen.writeIdField(ACCRUAL_LOYALTY_TIER, memberLoyaltyTierId.get(accrualTransaction.MemberId));
            if (accrualTransaction.TransactionAmount != null){ 
                gen.writeNumberField(ACCRUAL_MINIMUM_PRICE, accrualTransaction.TransactionAmount.doubleValue());
                gen.writeNumberField(ACCRUAL_MAXIMUM_PRICE, accrualTransaction.TransactionAmount.doubleValue());
            }
            if (accrualTransaction.Quantity != null){ 
                gen.writeNumberField(ACCRUAL_MINIMUM_QUANTITY, accrualTransaction.Quantity);
                gen.writeNumberField(ACCRUAL_MAXIMUM_QUANTITY, accrualTransaction.Quantity);
            }
            if (accrualTransaction.ProductId != null){ 
                gen.writeIdField(ACCRUAL_PRODUCT, accrualTransaction.ProductId);
            }
            if (productCategoryNames.get(accrualTransaction.ProductCategoryId) != null){ 
                gen.writeStringField (ACCRUAL_CATEGORY, productCategoryNames.get(accrualTransaction.ProductCategoryId));
            }
            gen.writeEndObject();
            gen.writeEndObject();
        } 
    }
    
    void creditActionJSON(JSONGenerator gen,
                          TransactionJournal[] accrualTransactions,
                          Double[] pointsToAccrue)
    {
        Integer pos = 0;
        for(TransactionJournal accrualTransaction:accrualTransactions){
            gen.writeStartObject();
            gen.writeStringField ('ProgramName', PROGRAM_NAME);
            gen.writeStringField ('ProgramCurrencyName', NQP_CURRENCY);
            gen.writeIdField('LoyaltyProgramMemberId', accrualTransaction.MemberId);
            gen.writeIdField('JournalId', accrualTransaction.Id);
            gen.writeNumberField('Points', pointsToAccrue[pos]);
            gen.writeEndObject();
            pos++;
        }
    }
}