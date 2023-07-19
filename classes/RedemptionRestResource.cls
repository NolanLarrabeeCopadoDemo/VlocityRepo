@RestResource(urlMapping='/redemption')
global with sharing class RedemptionRestResource {
    //REST End Point for Redemption '/services/apexrest/redemption'
    
    @HttpPost
    global static RedemptionResponseWrapper[] loyaltySampleAppRedemption() {
        RestRequest req = RestContext.request;
        RedemptionPayloadJsonToApex payloadApex;
        TransactionJournal[] allTransactions;
        List<RedemptionResponseWrapper> redemptionResponses = new List<RedemptionResponseWrapper>();
        
        try{
            //Deserialise the Input payload
            payloadApex = (RedemptionPayloadJsonToApex)JSON.deserializeStrict(req.requestBody.toString(),
                                                                              RedemptionPayloadJsonToApex.class);
            allTransactions = payloadApex.getInputs();
            
            //Setting default API execution to Redemption if IsRedemptionEnquiry not specified
            if (payloadApex.isRedemption() == null){payloadApex.isRedemptionOrEnquiry = true;}
            
            for (Integer i = 0; i<payloadApex.getInputs().size();i++){
                redemptionResponses.add(new RedemptionResponseWrapper());
            }
            
            validatePayload(payloadApex, redemptionResponses);
            
            //Create TransactionJournals for the input payloads for Redeem only; Do not proceed further if any record creation fails
            if (payloadApex.isRedemption()){
                Boolean anyRecordError = createBulkTransactionJournals(allTransactions, redemptionResponses);
                //For Composite sObject creation request, allOrNone tag to true; if any fails all TJs will be rolled back automatically
                if (anyRecordError){ 
                    throw new RedemptionExecutionException();
                }
            }
            
            //For IsQuote, default execution will use APEX implementation to avoid unnecessary complexity of FLOW
            if (payloadApex.isRedemption() && 'Flow'.equalsIgnoreCase(payloadApex.getExecutionMethod())){
                RedemptionFlowImplementation redemptionFlow = new RedemptionFlowImplementation();
                redemptionFlow.executeRedemptionFlow(allTransactions,redemptionResponses);
            } else {
                RedemptionApexImplementation redemptionApex = new RedemptionApexImplementation();
                redemptionApex.executeRedemptionApex(payloadApex.isRedemption(), allTransactions, redemptionResponses);          
            }
        } catch (Exception e) {
            //If any payload exception like invalid ExecutionMethod,inactive flows,transaction limit exceeded or
            // invalid ProgramId and LoyaltyProgramMemberId in the first input payload is thrown, clear all the responses
            if (e.getTypeName().equals('RedemptionPayloadException')){
                redemptionResponses.clear();
            }
            else if (e.getTypeName().equals('RedemptionExecutionException')){}
            RedemptionResponseWrapper redemptionException = new RedemptionResponseWrapper();
            redemptionException.errors.add(String.valueOf(e));
            redemptionResponses.add(redemptionException);
        } 
        
        Boolean anyFailedRedemption = false;
        List<TransactionJournal> transactionsForRollback = new List<TransactionJournal>();
        for (RedemptionResponseWrapper redemptionResponse: redemptionResponses){
            if (redemptionResponse.errors.size() != 0){
                anyFailedRedemption = true;
                if (String.isNotBlank(redemptionResponse.getTransactionJournalId())){
                    TransactionJournal transactionForRollback = new TransactionJournal(Id = redemptionResponse.getTransactionJournalId());
                    transactionsForRollback.add(transactionForRollback);
                }
            }
            else {redemptionResponse.isSuccess = true;}
        }
        
        //Rollback the Transaction if any redemption fails in the list for !IsRedemptionEnquiry
        if (payloadApex.isRedemption() && anyFailedRedemption){
            //Delete the Transactions 
            DMLManager.DBDelete(transactionsForRollback);
            //Setting TransactionJournalId = null and isSuccess = false for all Responses 
            for (RedemptionResponseWrapper redemptionResponse: redemptionResponses){
                redemptionResponse.setTransactionJournalId(null);
                redemptionResponse.isSuccess = false;
            }
        }
        return redemptionResponses;
    }
    
    static void validatePayload(RedemptionPayloadJsonToApex payloadApex,
                               RedemptionResponseWrapper[] redemptionResponses){
        String payloadExecutionMethod = payloadApex.getExecutionMethod();
            
        if (!'Flow'.equalsIgnoreCase(payloadExecutionMethod) && !'Apex'.equalsIgnoreCase(payloadExecutionMethod)){
            throw new RedemptionPayloadException(RedemptionErrors.ERROR_INVALID_EXECUTION_METHOD);
        }
        
        //Validations for limit of transactions to be processed in single payload
        if (payloadApex.getInputs().size() > RedemptionConstants.TRN_LIMIT){
            throw new RedemptionPayloadException(RedemptionErrors.ERROR_TRN_LIMIT_EXCEEDED);
        }
        
        //Check if RedemptionFlow is activated
        Integer isRedemptionFlowActiveCount = [SELECT COUNT()
                                              FROM FlowDefinitionView
                                              WHERE ApiName = :RedemptionConstants.REDEMPTION_FLOW_API_NAME AND isActive=true
                                              WITH SECURITY_ENFORCED];
        if ('Flow'.equalsIgnoreCase(payloadExecutionMethod) && isRedemptionFlowActiveCount != 1) {
            throw new RedemptionPayloadException(RedemptionErrors.ERROR_REDEMPTION_FLOW_INACTIVE);
        }
        
        //Return if some payload has validation error; No need to proceed further
        Boolean anyValidationError = RedemptionJournalValidation.validateTransactionsPayload(payloadApex.getInputs(),
                                                                                             redemptionResponses );
        if (anyValidationError) {
            throw new RedemptionPayloadException();
        }
    }
    
    public static Boolean createBulkTransactionJournals(TransactionJournal[] transactionsToCreate,
                                                        RedemptionResponseWrapper[] redemptionResponses )
    {
        //Setting JournalType = 'Redemption' for valid Redemption Transactions
        String redemptionJournalId;
        JournalType[] redemptionJournal = [SELECT Id from JournalType WHERE Name = 'Redemption' WITH SECURITY_ENFORCED];
        
        //Setting ID for Test Data
        if (redemptionJournal.size() != 0 ){ 
            redemptionJournalId = redemptionJournal[0].Id;
         } else {
            redemptionJournalId = [SELECT Id from JournalType WHERE Name = 'Redemption Test' LIMIT 1].Id;
        }
        
        for (TransactionJournal transactionToCreate : transactionsToCreate ){
            transactionToCreate.JournalTypeId = redemptionJournalId;
            transactionToCreate.Id=null;
        }
        
        //Perform bulk save of TransactionJournals
        Database.SaveResult[] tjSaveResults = RedemptionRestUtil.performBulksObjectOperation('POST', transactionsToCreate);
        
        Boolean anyRecordError = false;
        Integer trnIndex = 0;
        for (Database.SaveResult tjSaveResult : tjSaveResults ){
            if (tjSaveResult.isSuccess()){
                transactionsToCreate[trnIndex].Id = tjSaveResult.getId();
                redemptionResponses[trnIndex].setTransactionJournalId(tjSaveResult.getId());   
            } else {
                anyRecordError = true;
                for (Database.Error tjSaveResultError : tjSaveResult.getErrors())
                    redemptionResponses[trnIndex].errors.add(String.valueOf(tjSaveResultError));
            }
            trnIndex++;
        }
        
        return anyRecordError;
    }
    
    global class OutputValues{
        global Id voucherId;
        global Id transactionJournalId;
        global Boolean isRedeemed;
        global Decimal pointsRequired;
        public Decimal pointsRedeemed;
        public Decimal currentPointsBalance;
        OutputValues(){
            IsRedeemed = false;
        }
    }
    
    /*Custom Class to help in seriliasing Redemption Response*/
    global class RedemptionResponseWrapper{
        global String[] errors;
        global Boolean isSuccess;
        global OutputValues outputValues;
        global RedemptionResponseWrapper(){
            isSuccess = false;
            errors = new List<String>();
            outputValues = new OutputValues();
        }
        global Id getTransactionJournalId(){ return outputValues.transactionJournalId; }
        global void setTransactionJournalId(Id transactionJournalId){ outputValues.transactionJournalId = transactionJournalId; }
        global void setVoucherId(Id voucherId){ outputValues.voucherId = voucherId; }
        global void setIsRedeemed(Boolean isRedeemed){ outputValues.isRedeemed = isRedeemed; }
        global void setPointsRequired(Decimal pointsRequired){ outputValues.pointsRequired = pointsRequired; }
        global void setPointsRedeemed(Decimal pointsRedeemed){ outputValues.pointsRedeemed = pointsRedeemed; }
        global void setCurrentPointsBalance(Decimal currentPointsBalance){ outputValues.currentPointsBalance = currentPointsBalance; }
    }
    
    /*Custom Class to help in deseriliasing Input Payload*/
    global class RedemptionPayloadJsonToApex {
        String executionMethod;
        boolean isRedemptionOrEnquiry;
        List<TransactionJournal> inputs;
        public String getExecutionMethod(){return this.executionMethod;}
        public boolean isRedemption(){return this.isRedemptionOrEnquiry;}
        public List<TransactionJournal> getInputs(){return this.inputs;}
    }
    
    /*Custom Class to help in seriliasing Request Body for creating multiple TransactionJournals through SObject Collections REST endpoint*/
    private class SObjectCollectionWrapper {
        boolean allOrNone;
        TransactionJournal[] records;
        SObjectCollectionWrapper(TransactionJournal[] records ){
            this.allOrNone = true;
            this.records = records;
        }
    }
    
    //Custom Exception class to show execution errors of Loyalty Sample App
    public class RedemptionPayloadException extends Exception {}
    public class RedemptionExecutionException extends Exception {}
}