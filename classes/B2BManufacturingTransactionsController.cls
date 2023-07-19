/**
 * @description       : Controller class to retrieve recent Program Member Transactions
 *             and associated Loyalty Ledgers to be shown in the Member Profile Page.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public without sharing class B2BManufacturingTransactionsController {
    
    /**
    * @description method to fetch Transaction Journals and associated Loyalty Ledgers as 
    * pass them to datatable in community member Profile Page.
    * @param programMemberId Program Member Id
    * @return List<TransactionSummary> Summary details of Transaction Journals
    */
    @AuraEnabled()
    public  static List<TransactionSummary> getTransactionJournals() {
        List<LoyaltyProgramMember> programMembers;        
        List<User> users = [SELECT Id, ContactId FROM User
                            WHERE Id = :UserInfo.getUserId()
                            WITH SECURITY_ENFORCED
                            LIMIT 1];

        if (!users.isEmpty() && string.isNotBlank(users[0].ContactId)) {
            List<Contact> Contacts = [SELECT Id, AccountId FROM Contact
                                      WHERE Id = :users[0].ContactId
                                      WITH SECURITY_ENFORCED
                                      LIMIT 1];
            if(!Contacts.isEmpty() && string.isNotBlank(Contacts[0].AccountId)){
                programMembers = [SELECT Id, MembershipNumber FROM LoyaltyProgramMember
                                  WHERE AccountId = :Contacts[0].AccountId
                                  WITH SECURITY_ENFORCED
                                  LIMIT 1];
            }
        }
        Map<String, TransactionSummary> transactionSummaries = new Map<String, TransactionSummary>();
        if (!programMembers.isEmpty()) {
            for (LoyaltyLedger ledger : [SELECT LoyaltyProgramCurrency.Name, TransactionJournalId,TransactionJournal.JournalType.Name,
                                        ActivityDate, EventType, Points, TransactionJournal.ActivityDate,TransactionJournal.VoucherDefinitionId__r.Name,
                                        TransactionJournal.JournalSubType.Id, TransactionJournal.JournalSubType.Name,TransactionJournal.Product.Name
                                        FROM LoyaltyLedger
                                        WHERE TransactionJournal.MemberId = :programMembers[0].Id
                                        ORDER BY ActivityDate DESC ]) 
            {
                
                if (!transactionSummaries.containsKey(ledger.TransactionJournalId)) {
                    transactionSummaries.put(ledger.TransactionJournalId, new TransactionSummary(ledger.ActivityDate.format('MM/dd/yyyy'),
                                                                                                ledger.TransactionJournal.JournalType.Name,
                                                                                                Integer.valueOf(ledger.Points),
                                                                                                ledger.LoyaltyProgramCurrency.Name,
                                                                                                ledger.EventType,ledger.TransactionJournal.VoucherDefinitionId__r.Name,
                                                                                                ledger.TransactionJournal.Product.Name,
                                                                                                ledger.TransactionJournal.JournalSubType.Name));
                } else {
                    transactionSummaries.put(ledger.TransactionJournalId, new TransactionSummary(transactionSummaries.get(ledger.TransactionJournalId),
                                                                                                Integer.valueOf(ledger.Points),
                                                                                                ledger.LoyaltyProgramCurrency.Name,
                                                                                                ledger.EventType));
                }
            }
        } 
        return transactionSummaries.values();
    }    
}