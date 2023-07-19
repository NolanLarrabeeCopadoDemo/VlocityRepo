/**
* @author Salesforce.com
* @date 2021
*
* @description Apex implementation for Redemption/Quote request of valid Transaction Journals; 
*/
global inherited sharing class RedemptionApexImplementation {
    
    /**
    * @description  
    * @param isRedemption Boolean value specifying to redeem or just quote
    * @param redemptionTransactions Transaction Journal records to be processed for redemption
    * @param redemptionResponses RedemptionRestResource.RedemptionResponseWrapper objects to hold the output payload
    */
    public void executeRedemptionApex(Boolean isRedemption,
                                      TransactionJournal[] redemptionTransactions,
                                      RedemptionRestResource.RedemptionResponseWrapper[] redemptionResponses)
    {
        /* Query from DT created on Redemption catalog */
        String actionPayloadRequest = createActionJSON('Redemption DT Action', redemptionTransactions, null);
        String actionResponse = RedemptionRestUtil.executeAction('POST', RedemptionConstants.DT_REDEMPTION_ACTION_URL, actionPayloadRequest);
        //Deserialise the DT Action response payload
        DTResponseJsonToApex[] dtResponses = (List<DTResponseJsonToApex>) JSON.deserializeStrict(actionResponse, List<DTResponseJsonToApex>.class);
        
        /* Get points balance of particular NQP for the Members */
        actionPayloadRequest = createActionJSON('Get Points Balance Action', redemptionTransactions, null);
        actionResponse = RedemptionRestUtil.executeAction('POST',RedemptionConstants.GET_POINTS_BALANCE_ACTION_URL, actionPayloadRequest);
        //Deserialise the Get Points Balance Action response payload
        LoyaltyActionResponseJsonToApex[] pointsBalanceResponses = (List<LoyaltyActionResponseJsonToApex>) JSON.deserialize(actionResponse,
                                                                                                                            List<LoyaltyActionResponseJsonToApex>.class);
        Decimal[] pointsToRedeem = new List<Decimal>();
        
        //Check if all Transactions are valid for redemption and member has sufficient points balance to redeem all Transactions
        Boolean anyFailedRedemption = validateTransactionsForDebit(dtResponses, pointsBalanceResponses,
                                                                   redemptionTransactions, redemptionResponses,
                                                                   pointsToRedeem, isRedemption);
        
        /* If isRedemptionOrInquiry is true, will not proceed further
        *  If pointsRequired or currentPointsBalance is null for any input payload, No need for Debit Points Action and return
        */
        if (!isRedemption || anyFailedRedemption) {
            return;
        }
        
        /* Execute Debit Points Action for valid Redemption Transactions */
        actionPayloadRequest = createActionJSON('Debit Points Balance Action', redemptionTransactions, pointsToRedeem);
        actionResponse = RedemptionRestUtil.executeAction('POST', RedemptionConstants.DEBIT_POINTS_ACTION_URL, actionPayloadRequest);
        //Deserialise the Debit Points Action response payload
        LoyaltyActionResponseJsonToApex[] debitPointsResponses = (List<LoyaltyActionResponseJsonToApex>) JSON.deserialize(actionResponse,
                                                                                                                          List<LoyaltyActionResponseJsonToApex>.class);
        LoyaltyActionResponseJsonToApex debitPointsResponse;
        List<TransactionJournal> voucherTransactions = new List<TransactionJournal> ();
        List<Integer> voucherTxnIndexes = new List<Integer>();
        Boolean anyFailedDebitAction = false;
        for (Integer trnIndex = 0; trnIndex < redemptionTransactions.size(); trnIndex++){ 
            if (RedemptionConstants.VOUCHER_SUBTYPE_ID.equals(redemptionTransactions[trnIndex].JournalSubTypeId)) {
                voucherTxnIndexes.add(trnIndex);
                voucherTransactions.add(redemptionTransactions[trnIndex]);
            }
            debitPointsResponse = debitPointsResponses[trnIndex];
            
            if (debitPointsResponse.isSuccess) {
                //Setting the Redemption Response outputValues
                redemptionResponses[trnIndex].setIsRedeemed(true);
                redemptionResponses[trnIndex].setPointsRedeemed(redemptionResponses[trnIndex].outputValues.PointsRequired);
                redemptionResponses[trnIndex].setCurrentPointsBalance(debitPointsResponse.getPointsBalance());
            } else {
                anyFailedDebitAction = true;
                for (Database.Error debitPointsError : debitPointsResponse.errors) {
                    if ('UNKNOWN_EXCEPTION'.equals(debitPointsError.getStatusCode())){
                        redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_UNKNOWN_DT_EXCEPTION);
                    } else {
                        redemptionResponses[trnIndex].errors.add(String.valueOf(debitPointsError));
                    }
                }
            }
        }
        
        //IssueVoucher action to be performed if no DebitPointsAction failed and any redemption has "Voucher" RedemptionType
        if (!anyFailedDebitAction && voucherTransactions.size() != 0){
            Map<Id, String> voucherCodes = getVoucherCodes(voucherTransactions);
            
            /* Execute Issue Voucher Action for valid Voucher Redemption Transactions */
            actionPayloadRequest = createIssueVoucherJSON(voucherTransactions, voucherCodes);
            actionResponse = RedemptionRestUtil.executeAction('POST', RedemptionConstants.ISSUE_VOUCHER_ACTION_URL, actionPayloadRequest);
            //Deserialise the Issue Voucher Action response payload
            IssueVoucherResponseJsonToApex[] issueVoucherResponses = (List<IssueVoucherResponseJsonToApex>) JSON.deserialize(actionResponse,
                                                                                                                             List<IssueVoucherResponseJsonToApex>.class);
            IssueVoucherResponseJsonToApex issueVoucherResponse;
            for (Integer index = 0; index < voucherTransactions.size(); index++){
                issueVoucherResponse = issueVoucherResponses[index];
                
                //Will asssume IssueVoucher Action never fails, so no need to revert Debit Points Action
                if (issueVoucherResponse.isSuccess) {
                    //Setting the VoucherId in Redemption Response outputValue
                    redemptionResponses[voucherTxnIndexes[index]].setVoucherId(issueVoucherResponse.getVoucherId());
                } else {
                    for (Database.Error issueVoucherError : issueVoucherResponse.errors) {
                        redemptionResponses[voucherTxnIndexes[index]].errors.add(String.valueOf(issueVoucherError));
                    }
                }
            }
        }
    }
    
    private Map<Id, String> getProductCategoryNames(TransactionJournal[] redemptionTransactions)
    {
        Set<Id> redemptionProductCategoryIds = new Set<Id>();
        for (TransactionJournal redemptionTransaction : redemptionTransactions) {
            redemptionProductCategoryIds.add(redemptionTransaction.ProductCategoryId);
        }
        ProductCategory[] productCategories = [ SELECT Id, Name
                                               FROM ProductCategory
                                               WHERE Id IN :redemptionProductCategoryIds
                                               WITH SECURITY_ENFORCED];
        Map<Id, String> productCategoryNames = new Map<Id, String>();
        for (ProductCategory productCategory : productCategories) {
            productCategoryNames.put(productCategory.Id, productCategory.Name);
        }
        return productCategoryNames;
    }
    
    /**
    * @description Get Voucher Codes from GenerateVOucherCode flow if not present in with Voucher redemption payloads
    * @param redemptionTransactions List of Voucher Redemption transactions
    * @return List of Voucher Codes that will be used in Issue Voucher Action
    */
    private Map<Id, String> getVoucherCodes(TransactionJournal[] redemptionTransactions){
        Map<Id, String> voucherCodesMap = new Map<Id, String>();
        for (TransactionJournal redemptionTransaction : redemptionTransactions){
            VoucherCodeUtil.GetVoucherCodeActionRequest getCodeRequest = new VoucherCodeUtil.GetVoucherCodeActionRequest();
            getCodeRequest.MemberId = redemptionTransaction.MemberId;
            getCodeRequest.VoucherDefinitionId = redemptionTransaction.VoucherDefinitionId__c;
            getCodeRequest.VoucherCodeCategory = 'Redemption';
            getCodeRequest.VoucherCodeCategoryId = redemptionTransaction.Id;
            getCodeRequest.isFlowCall = false;
            
            VoucherCodeUtil.GetVoucherCodeActionResponse[] getCodeResponses = VoucherCodeUtil.getVoucherCode(new List<VoucherCodeUtil.GetVoucherCodeActionRequest> {getCodeRequest});
            voucherCodesMap.put(redemptionTransaction.Id, getCodeResponses[0].VoucherCode);
        }
        return voucherCodesMap;
    }
    
    /**
    * @description  
    * @param reference to list of DTResponseJsonToApex object obtained from DecisionTable Action
    * @param reference to list of RedemptionRestResource.RedemptionResponseWrapper object
    * @param redemptionTransactions Transaction Journal records to be processed for redemption
    * @param pointsToRedeem  Points required for redemption of each journals
    * @param isRedemption Boolean value specifying type of request - True for Redemption, False for Quote
    */
    private boolean validateTransactionsForDebit(DTResponseJsonToApex[] dtResponses,
                                                 LoyaltyActionResponseJsonToApex[] pointsBalanceResponses,
                                                 TransactionJournal[] redemptionTransactions,
                                                 RedemptionRestResource.RedemptionResponseWrapper[] redemptionResponses,
                                                 Decimal[] pointsToRedeem,
                                                 Boolean isRedemption)
    {
        DTResponseJsonToApex dtResponse;
        LoyaltyActionResponseJsonToApex pointsBalanceResponse;
        Decimal pointsRequired;
        Decimal pointsPerDollar;
        Decimal currentPointsBalance;
        Boolean anyFailedRedemption = false;
        
        for (Integer trnIndex = 0; trnIndex < redemptionTransactions.size(); trnIndex++) 
        {
            //Check for successful Redemption DTAction for each TransactionJournal details, otherwise we will skip processing it
            dtResponse = dtResponses[trnIndex];
            if (dtResponse.isSuccess){ 
                if (!'No Match'.equalsIgnoreCase(dtResponse.getOutcomeType())){
                    pointsRequired = ((RedeemPointsProductCategory__c) dtResponse.getsingleOutcome()).Points__c;
                } else {
                    redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_NO_MATCH_RULE);
                }
            } else {
                redemptionResponses[trnIndex].errors.add(String.valueOf(dtResponse.errors));
            }
            
            //Check for successful Get Points Balance Action for each TransactionJournal details, otherwise we will skip processing it
            pointsBalanceResponse = pointsBalanceResponses[trnIndex];
            if (pointsbalanceResponse.isSuccess) {
                currentPointsBalance = pointsBalanceResponse.getPointsBalance();
            } else {
                for (Database.Error pointsBalanceError : pointsBalanceResponse.errors) {
                    redemptionResponses[trnIndex].errors.add(String.valueOf(pointsBalanceError));
                }
            }
            
            //Check if Member has sufficient points balance to redeem, otherwise we will skip processing it
            if (isRedemption && currentPointsBalance !=null && pointsRequired != null) {
                if (currentPointsBalance >= pointsRequired) {
                    pointsToRedeem.add(pointsRequired);
                } else {
                    redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_INSUFFICIENT_BALANCE);
                }
            }
            
            //Setting the Redemption Response point values
            redemptionResponses[trnIndex].setPointsRequired(pointsRequired);
            redemptionResponses[trnIndex].setCurrentPointsBalance(currentPointsBalance);
            anyFailedRedemption = !(redemptionResponses[trnIndex].errors.size()==0) || anyFailedRedemption;
        }
        return anyFailedRedemption;
    }
    
    /*Custom Class to help in deseriliasing Get Points Balance and Debit Points Balance Action Response*/
    private class LoyaltyActionOutputValue {
        Id LoyaltyProgramMemberId;
        String ProgramCurrencyName;
        String ProgramName;
        Id JournalId; //Present in Debit Points Balance Action
        Double PointsBalance; //Present in Debit Points Balance Action
    }
    private class LoyaltyActionResponseJsonToApex {
        String actionName;
        Database.Error[] errors;
        boolean isSuccess;
        LoyaltyActionOutputValue outputValues;
        public Double getPointsBalance() { return outputValues.PointsBalance; }
    }
    
    /*Custom Class to help in deseriliasing DTAction Response*/
    private class DTOutputValue {
        String outcomeType;
        List<sObject> outcomeList;
        sObject singleOutcome;
    }
    private class DTResponseJsonToApex {
        String actionName;
        Database.Error[] errors;
        boolean isSuccess;
        DTOutputValue outputValues;
        public String getOutcomeType() { return outputValues.outcomeType; }
        public sObject getsingleOutcome() { return outputValues.singleOutcome; }
    }
    
    /*Custom Class to help in deseriliasing Issue Voucher Action Response*/
    private class IssueVoucherOutputValue {
        Id VoucherId;
    }
    private class IssueVoucherResponseJsonToApex {
        String actionName;
        Database.Error[] errors;
        boolean isSuccess;
        IssueVoucherOutputValue outputValues;
        public String getVoucherId() { return outputValues.VoucherId; }
    }
    
    /**
    * @description Builds action JSON to be sent to Rest End Point of respective Action
    * @param actionType CreditPoint or DebitPoint or DecisionTable Action
    * @param redemptionTransactions Transaction Journal records to be processed for redemption
    * @param pointsToRedeem  Points required for redemption of each journals
    * @return Created action JSON as a string
    */
    private String createActionJSON(String actionType, TransactionJournal[] redemptionTransactions, Double[] pointsToRedeem)
    {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('inputs');
        gen.writeStartArray();
        if ('Redemption DT Action'.equalsIgnoreCase(actionType)) {
            redemptionDTJSON(gen, redemptionTransactions);
        } else if ('Get Points Balance Action'.equalsIgnoreCase(actionType)) {
            loyaltyActionJSON(gen, redemptionTransactions, null);
        } else if ('Debit Points Balance Action'.equalsIgnoreCase(actionType)) {
            loyaltyActionJSON(gen, redemptionTransactions, pointsToRedeem);
        }
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
    
    /**
    * @description Helper to build Decision Table action JSON
    * @param reference to JSONGenerator object
    * @param redemptionTransactions Transaction Journal records to be processed for redemption
    */
    void redemptionDTJSON(JSONGenerator gen, TransactionJournal[] redemptionTransactions)
    {
        Map<Id, String> productCategoryNames = getProductCategoryNames(redemptionTransactions);
        
        for (TransactionJournal redemptionTransaction : redemptionTransactions) {
            gen.writeStartObject();
            gen.writeStringField(RedemptionConstants.REDEMPTION_CATALOG_PROGRAM, redemptionTransaction.LoyaltyProgramId);
            gen.writeStringField(RedemptionConstants.REDEMPTION_CATALOG_REDEMPTION_TYPE, redemptionTransaction.JournalSubTypeId);
            if (String.isNotBlank(redemptionTransaction.PartnerId)) {
                gen.writeIdField(RedemptionConstants.REDEMPTION_CATALOG_PARTNER, redemptionTransaction.PartnerId);
            }
            if (String.isNotBlank(redemptionTransaction.ProductId)) {
                gen.writeIdField(RedemptionConstants.REDEMPTION_CATALOG_PRODUCT, redemptionTransaction.ProductId);
            }
            if (String.isNotBlank(redemptionTransaction.ProductCategoryId) && productCategoryNames.get(redemptionTransaction.ProductCategoryId) != null)
            {    
                gen.writeStringField(RedemptionConstants.REDEMPTION_CATALOG_CATEGORY, productCategoryNames.get(redemptionTransaction.ProductCategoryId));
            }
            if (RedemptionConstants.VOUCHER_SUBTYPE_ID.equals(redemptionTransaction.JournalSubTypeId)){
                gen.writeIdField(RedemptionConstants.REDEMPTION_CATALOG_VOUCHER_DEFINITION, redemptionTransaction.VoucherDefinitionId__c);
            } else { 
                gen.writeNullField(RedemptionConstants.REDEMPTION_CATALOG_VOUCHER_DEFINITION);
            }
            if (redemptionTransaction.ActivityDate != null) {
                gen.writeNumberField(RedemptionConstants.REDEMPTION_CATALOG_START_DATE, redemptionTransaction.ActivityDate.getTime());
                gen.writeNumberField(RedemptionConstants.REDEMPTION_CATALOG_END_DATE, redemptionTransaction.ActivityDate.getTime());
            }
            gen.writeEndObject();
        }
    }
    
    /**
    * @description Helper to build Loyalty action JSON
    * @param reference to JSONGenerator object
    * @param redemptionTransactions Transaction Journal records to be processed for redemption
    * @param pointsToRedeem  Points to be redeemed for each journals
    */
    void loyaltyActionJSON(JSONGenerator gen, TransactionJournal[] redemptionTransactions, Double[] pointsToRedeem)
    {
        Integer pos = 0;
        for (TransactionJournal redemptionTransaction : redemptionTransactions) {
            gen.writeStartObject();
            gen.writeStringField('ProgramName', RedemptionConstants.PROGRAM_NAME);
            gen.writeStringField('ProgramCurrencyName', RedemptionConstants.NQP_CURRENCY);
            gen.writeIdField('LoyaltyProgramMemberId', redemptionTransaction.MemberId);
            if (pointsToRedeem != null) {
                if (String.isNotEmpty(redemptionTransaction.Id)) {
                    gen.writeIdField('JournalId', redemptionTransaction.Id);
                } else {
                    gen.writeNullField('JournalId');
                }
                gen.writeNumberField('Points', pointsToRedeem[pos]);
            }
            gen.writeEndObject();
            pos++;
        }
    }
    
    /**
    * @description Builds action JSON to be sent to Rest End Point of Issue Voucher Action
    * @param redemptionTransaction Transaction Journal record to be processed for issue voucher
    * @param voucherCode Generated voucher code from flow or from payload
    * @return Created action JSON as a string
    */
    private String createIssueVoucherJSON(TransactionJournal[] redemptionTransactions, Map<Id, String> voucherCodes)
    {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('inputs');
        gen.writeStartArray();
        Integer pos = 0;
        for (TransactionJournal redemptionTransaction : redemptionTransactions) {
            gen.writeStartObject();
            gen.writeStringField('ProgramName', RedemptionConstants.PROGRAM_NAME);
            gen.writeIdField('LoyaltyProgramMemberId', redemptionTransaction.MemberId);
            gen.writeIdField('JournalId', redemptionTransaction.Id);
            String voucherDefinitionName = [SELECT Id,Name FROM VoucherDefinition WHERE Id = :redemptionTransaction.VoucherDefinitionId__c WITH SECURITY_ENFORCED Limit 1].Name;
            gen.writeStringField('VoucherDefinitionName', voucherDefinitionName);
            gen.writeStringField('VoucherCode', voucherCodes.get(redemptionTransaction.Id));
            //gen.writeDateField('EffectiveDate', Date.valueOf(redemptionTransaction.ActivityDate));
            gen.writeEndObject();
            pos++;
        }
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
}