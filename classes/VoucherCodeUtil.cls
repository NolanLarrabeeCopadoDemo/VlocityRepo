global without sharing class VoucherCodeUtil {
    
    @InvocableMethod(label='Get Voucher Code' description='Returns the voucher code of the any first record from list of VoucherCode__c')
    public static GetVoucherCodeActionResponse[] getVoucherCode(GetVoucherCodeActionRequest[] requests){
        GetVoucherCodeActionResponse[] responses = new List<GetVoucherCodeActionResponse>();
        for ( GetVoucherCodeActionRequest getCodeRequest : requests)
        {
            GetVoucherCodeActionResponse response = new GetVoucherCodeActionResponse();
            Integer voucherCodeRecordCount = [SELECT COUNT() FROM VoucherCode__c 
                                              WHERE VoucherDefinitionId__c = :getCodeRequest.VoucherDefinitionId AND VoucherCodeStatus__c = 'New'];
            
            if (voucherCodeRecordCount == 0){
                generateNewVoucherCodes(getCodeRequest.VoucherDefinitionId, RedemptionConstants.COUNT_NEW_VOUCHERS_CREATE, getCodeRequest.isFlowCall );
            }
            VoucherCode__c voucherCodeRecord = [SELECT Id FROM VoucherCode__c 
                                                          WHERE VoucherDefinitionId__c = :getCodeRequest.VoucherDefinitionId AND VoucherCodeStatus__c = 'New' 
                                                          Limit 1 FOR UPDATE];
            
            if (voucherCodeRecord != null){
                voucherCodeRecord.VoucherCodeCategory__c = getCodeRequest.VoucherCodeCategory;
                voucherCodeRecord.VoucherCodeCorrelationId__c = getCodeRequest.VoucherCodeCategoryId;
                voucherCodeRecord.LoyaltyProgramMember__c = getCodeRequest.MemberId;
                voucherCodeRecord.VoucherCodeStatus__c = 'Processed';
                
                performDML(new List<SObject>{voucherCodeRecord}, getCodeRequest.isFlowCall, false );
                response.VoucherCode = [SELECT Id,VoucherCode__c FROM VoucherCode__c 
                                                          WHERE Id = :voucherCodeRecord.Id].VoucherCode__c;
                responses.add(response);
            } else {
                throw new GetVoucherCodeException(RedemptionErrors.ERROR_VOUCHER_CODE_UNAVAILABLE);
            }
        }
        return responses;
    }
    
    static void generateNewVoucherCodes(String voucherDefinitionId, Decimal noOfNewVouchers, Boolean isFlowCall){
        VoucherDefinition voucherDefinition = [SELECT Id,StartingVoucherNumber__c FROM VoucherDefinition 
                                                      WHERE Id = :voucherDefinitionId 
                                                      Limit 1 FOR UPDATE];
        List<VoucherCode__c> newVoucherCodeRecords = new List<VoucherCode__c>();
        for(Integer i =1; i<=noOfNewVouchers; i++){
            VoucherCode__c newVoucherCode = new VoucherCode__c();
            newVoucherCode.VoucherCodeType__c = 'Voucher Code';
            newVoucherCode.SequentialCounterNumber__c = i+voucherDefinition.StartingVoucherNumber__c;
            newVoucherCode.VoucherCodeStatus__c = 'New';
            newVoucherCode.VoucherDefinitionId__c = voucherDefinition.Id;
            newVoucherCodeRecords.add(newVoucherCode);
        }
        voucherDefinition.StartingVoucherNumber__c += noOfNewVouchers;
        performDML(newVoucherCodeRecords, isFlowCall, true);
        performDML(new List<SObject>{voucherDefinition}, isFlowCall, false);
    }
    
    global class GetVoucherCodeActionRequest {
        @InvocableVariable(label='VoucherDefinitionId' description='The voucher definition associated with the voucher code.' required=true)
        public ID VoucherDefinitionId;
        @InvocableVariable(label='VoucherCodeCorrelationId' description='The correlation ID of the voucher code category.' required=false)
        public String VoucherCodeCategoryId;
        @InvocableVariable(label='VoucherCodeCategory' description='The category for which the voucher code is generated.' required=true)
        public String VoucherCodeCategory;
        @InvocableVariable(label='MemberId' description='The loyalty program member who has been issued the voucher.' required=true)
        public ID MemberId;
        @InvocableVariable(label='Calling from Flow' description='Set to true if using in flow' required=true)
        public Boolean isFlowCall;
    }
    
    global class GetVoucherCodeActionResponse {
        @InvocableVariable(label='Voucher Code' description='Generated voucher code')
        public String VoucherCode;
    }
    
    static void performDML(SObject[] records, Boolean isFlowCall, Boolean isInsertDML ){
        if (isFlowCall){
            upsert records;
        } else{
            //For apex execution
            String dmlMethod = isInsertDML?'POST':'PATCH';
            Database.SaveResult[] dmlResults = RedemptionRestUtil.performBulksObjectOperation(dmlMethod, records);
            for (Database.SaveResult dmlResult : dmlResults ){
                if (!dmlResult.isSuccess()){
                    throw new GetVoucherCodeException(RedemptionErrors.ERROR_VOUCHER_CODE_UNAVAILABLE);
                } 
            }
        } 
    }

    //Custom Exception class to throw errors occurred during GenerateVoucherCode action
    public class GetVoucherCodeException extends Exception {}

}