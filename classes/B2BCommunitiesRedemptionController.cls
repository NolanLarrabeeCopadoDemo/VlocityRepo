public without sharing class B2BCommunitiesRedemptionController {
    @AuraEnabled(cacheable=true)
    public static List<RedeemPointsProductCategory__c > getRedeemPointsProductCategoriesList() {
        Set<String> resourceNameSet = new Set<String>();
        List<RedeemPointsProductCategory__c> RedeemPointsProductCategoryList = new List<RedeemPointsProductCategory__c>();
        For( RedeemPointsProductCategory__c redemptionCategory : [SELECT Id, Product_Image_Name__c, VoucherDefinitionId__c, Name, Partner__c, Points__c,ProductCategory__c,
                                                                 Product__c ,Product__r.Name , RedemptionType__c ,RedemptionType__r.Name,VoucherDefinitionId__r.Name  
                                                                 FROM RedeemPointsProductCategory__c where RedemptionType__c != null  ] ) {
            
            RedeemPointsProductCategoryList.add(redemptionCategory);
            resourceNameSet.add(redemptionCategory.Product_Image_Name__c.trim());
        }
        Map<String, String> resourceNameURLMap = new Map<String, String>();
        For ( StaticResource resource : [SELECT Id,Name, SystemModStamp
                                          FROM StaticResource 
                                          WHERE Name IN : resourceNameSet
                                        ]) {
             String resourceURL = '/resource/'
                                + String.valueOf(((DateTime)resource.get('SystemModStamp')).getTime())
                                + '/' 
                                + resource.get('Name');
             resourceNameURLMap.put(resource.Name, resourceURL); 
                                                    
        }
        for( RedeemPointsProductCategory__c redeemPointProductCategory : RedeemPointsProductCategoryList ) {
            if( resourceNameURLMap.containsKey(redeemPointProductCategory.Product_Image_Name__c) ) {
                redeemPointProductCategory.Product_Image_Name__c = resourceNameURLMap.get(redeemPointProductCategory.Product_Image_Name__c);
            }
        }
        return RedeemPointsProductCategoryList;
    }
     
    @AuraEnabled
    public static String redeemPoints(String productId , String partnerId , String journalsubtypeId, String voucherDefinitionId, String category ) {
        Savepoint sp = Database.setSavepoint();
        String httpBodyPayload = prepareRedemptionRequest(productId , partnerId , journalsubtypeId, voucherDefinitionId, category );

        RedemptionRestResource.RedemptionPayloadJsonToApex payloadApex = (RedemptionRestResource.RedemptionPayloadJsonToApex)JSON.deserializeStrict(httpBodyPayload,
                                                                                                                                                    RedemptionRestResource.RedemptionPayloadJsonToApex.class);
        TransactionJournal[] allTransactions = payloadApex.getInputs();

        insert allTransactions;

        RedemptionFlowImplementation redemptionApex = new RedemptionFlowImplementation();
        List<RedemptionRestResource.RedemptionResponseWrapper> redemptionResponses = new List<RedemptionRestResource.RedemptionResponseWrapper>();
        
        for (Integer i = 0; i<allTransactions.size();i++){
            redemptionResponses.add(new RedemptionRestResource.RedemptionResponseWrapper());
        }

        redemptionApex.executeRedemptionFlow( allTransactions, redemptionResponses);
        if(!redemptionResponses[0].outputValues.isRedeemed){
             Database.rollback( sp );
        }
        return Json.serialize(redemptionResponses[0].outputValues);

       
    }
    
    public static String prepareRedemptionRequest(String productId , String partnerid , String journalsubtypeid, String VoucherDefinitionId, String category ){
        DateTime todaysDate = System.Now();
        String todaysDateStr = todaysDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String journaltypeid = getJournalType(journalsubtypeid);
        Map<String, String> programMmeberDetails = getLoyaltyProgramMember();
        
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('ExecutionMethod', 'Flow');
        gen.writeBooleanField('isRedemptionOrEnquiry', true);
        gen.writeFieldName('inputs');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('JournalSubTypeId', journalsubtypeid);
        gen.writeStringField('JournalTypeId', journaltypeid);
        gen.writeStringField('LoyaltyProgramId',programMmeberDetails.get('programId'));
        gen.writeStringField('MemberId', programMmeberDetails.get('memberId'));
        gen.writeStringField('PartnerId', partnerid);
        gen.writeStringField('JournalDate', todaysDateStr );
        gen.writeStringField('ActivityDate', todaysDateStr);
        if( string.isNotBlank(VoucherDefinitionId)) {
            gen.writeStringField('VoucherDefinitionId__c', VoucherDefinitionId);           
        } 
        else{
            gen.writeNullField('VoucherDefinitionId__c');
        }
        if( string.isNotBlank(ProductId)) {
            gen.writeStringField('ProductId', ProductId);           
        }
        else{
            gen.writeNullField('ProductId');
        }
        if( string.isNotBlank(category)) {
            string categoryId = [ SELECT Id FROM ProductCategory WHERE Name =: category LIMIT 1 ].Id;
            gen.writeStringField('ProductCategoryId', categoryId);  
        }
        else{
            gen.writeNullField('ProductCategoryId');
        }

        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    } 
    
    public static  Map<String, String> getLoyaltyProgramMember(){
        String ContactRecordId = [SELECT Id, ContactId FROM User WHERE Id =:UserInfo.getUserId() WITH SECURITY_ENFORCED].ContactId;
        
        Contact contactRecord = [SELECT Id,AccountId,FirstName,LastName,Email,Phone,BirthDate FROM Contact WHERE id =:ContactRecordId WITH SECURITY_ENFORCED];
        List<LoyaltyProgramMember> programMembers = [SELECT Id,MembershipNumber , ProgramId  FROM LoyaltyProgramMember 
                                              WHERE  AccountId =:contactRecord.AccountId WITH SECURITY_ENFORCED  LIMIT 1];
                                      
        Map<String, String> programMmeberDetails = new Map<String, String>();
        programMmeberDetails.put('programId', programMembers[0].ProgramId); 
        programMmeberDetails.put('memberId', programMembers[0].ID);
        return programMmeberDetails;
    }
    
    public static String getJournalType(String journalsubtypeid){
        String journalTypeId = [SELECT JournalTypeId FROM JournalSubType WHERE Id =:journalsubtypeid][0].JournalTypeId;
        return journalTypeId;
    }
    
}