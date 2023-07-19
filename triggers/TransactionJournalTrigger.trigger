/**
@author Salesforce.com
@Date 2021
@description TransactionJournalTrigger to handle the DML event for Transaction Journal object
*/ 
trigger TransactionJournalTrigger on TransactionJournal (after insert,after Update) {
    
    // If it's after update event then call the method to send survey invitation 
    if( Trigger.isUpdate ) {
        RedemptionSurveyHelper.sendSurveyInvitation(Trigger.New);
    }
    
   
}