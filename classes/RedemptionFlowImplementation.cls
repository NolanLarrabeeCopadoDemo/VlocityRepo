public inherited sharing class RedemptionFlowImplementation {
    static final String REDEMPTION_FLOW_API_NAME = 'Deduct_Points_Based_on_Product_and_Vouchers';
    
    static final String INPUT_TRN_JOURNAL_RECORDS = 'TransactionJournals';
    static final String OUTPUT_POINTS_REQUIRED= 'PointsRequiredForEachRedemption';
    static final String OUTPUT_ISSUED_VOUCHER_IDS = 'IssuedVoucherIds'; 
    static final String OUTPUT_BALANCE_BEFORE_REDEMPTION = 'OldPointBalance';
    static final String OUTPUT_BALANCE_AFTER_REDEMPTION = 'NewPointsBalance';
    static final String OUTPUT_ANY_RULE_NO_MATCH = 'AnyRuleNotMatched'; 
    static final String OUTPUT_HAS_SUFFICIENT_BALANCE = 'HasSufficientBalance'; 
    
    public void executeRedemptionFlow(TransactionJournal[] redemptionTransactions,
                                      RedemptionRestResource.RedemptionResponseWrapper[] redemptionResponses)
    {
        Decimal[] pointsRequired;
        Decimal balanceBeforeRedemption;
        Decimal balanceAfterRedemption;
        List<Id> issuedVoucherIds;
        Boolean hasSufficientBalance = false;
        Map<String, Object> flowInputVariablesMap = new Map<String, Object>();
        flowInputVariablesMap.put(INPUT_TRN_JOURNAL_RECORDS, redemptionTransactions);
        //Interview Created Dynamically for a Local Flow
        Flow.Interview redemptionFlow = Flow.Interview.createInterview(REDEMPTION_FLOW_API_NAME, flowInputVariablesMap);
        redemptionFlow.start();
        Boolean anyRuleNoMatch = (Boolean) redemptionFlow.getVariableValue(OUTPUT_ANY_RULE_NO_MATCH);
        pointsRequired = (List<Decimal>) redemptionFlow.getVariableValue(OUTPUT_POINTS_REQUIRED);
        balanceBeforeRedemption = (Decimal) redemptionFlow.getVariableValue(OUTPUT_BALANCE_BEFORE_REDEMPTION);
        if(!anyRuleNoMatch){
            hasSufficientBalance = (Boolean) redemptionFlow.getVariableValue(OUTPUT_HAS_SUFFICIENT_BALANCE);
            if(hasSufficientBalance){
                balanceAfterRedemption = (Decimal) redemptionFlow.getVariableValue(OUTPUT_BALANCE_AFTER_REDEMPTION);
                issuedVoucherIds = (List<Id>) redemptionFlow.getVariableValue(OUTPUT_ISSUED_VOUCHER_IDS);
            }
        }
        for (Integer trnIndex = 0; trnIndex < redemptionTransactions.size(); trnIndex++){
            redemptionResponses[trnIndex].setPointsRequired(pointsRequired[trnIndex]);
            redemptionResponses[trnIndex].setCurrentPointsBalance(balanceBeforeRedemption);
            
            if (hasSufficientBalance){
                redemptionResponses[trnIndex].setCurrentPointsBalance(balanceAfterRedemption);
                redemptionResponses[trnIndex].isSuccess = true;
                redemptionResponses[trnIndex].setIsRedeemed(true);
                redemptionResponses[trnIndex].setPointsRedeemed(pointsRequired[trnIndex]);
                if (RedemptionConstants.VOUCHER_SUBTYPE_ID.equals(redemptionTransactions[trnIndex].JournalSubTypeId)){
                    redemptionResponses[trnIndex].setVoucherId(issuedVoucherIds[trnIndex]);
                }
            }else if (pointsRequired[trnIndex] == null){
                redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_NO_MATCH_RULE);
            }else {
                redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_INSUFFICIENT_BALANCE);
            }
        }
    }
}