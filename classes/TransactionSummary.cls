/**
 * @description       : Wrapper class to construct recent Transaction information
 * 						with Reward and Tier Points calculation.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public with sharing class TransactionSummary {
    
    @AuraEnabled
    public String transactionDate { get; set; }
    @AuraEnabled
    public String transactionDetails { get; set; }
    
    @AuraEnabled
    public Integer rewardPoints { 
        get {
            if (rewardPoints == null) {
                rewardPoints = 0;
            }
            return rewardPoints;
        } 
        set; 
    }

    
    public TransactionSummary(String transactionDate, String JournalType, Integer points, String currencyName, String eventType,
                              String voucherDefenation, String product, String journalSubType) {
        this.transactionDate = transactionDate;
        String detail = (JournalType.equalsIgnoreCase('Accrual') || JournalType.equalsIgnoreCase('Redemption')) ? 
                        (String.isNotBlank(voucherDefenation) ? voucherDefenation : (String.isNotBlank(product) ? product : journalSubType)) : JournalType;

        this.transactionDetails = detail.equalsIgnoreCase(JournalType) ? JournalType : (JournalType + ' for ' + detail);
        
        this.rewardPoints = (eventType == 'Credit' ?  points : (-1 * points)); 
        
    }
    
    public TransactionSummary(TransactionSummary summary, Integer points, String currencyName, String eventType) {
        this.transactionDate = summary.transactionDate;
        this.transactionDetails = summary.transactionDetails;
        
        this.rewardPoints = (eventType == 'Credit' ? (summary.rewardPoints + points) : ((-1 * points) + summary.rewardPoints)); 
    }
}