global inherited sharing class AccrualApexBatchScheduler implements Schedulable,Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  String accrualTransactionQuery;
  String journalTypeName = 'Accrual';
  String loyaltyProgramName = 'Partner Extraa Program';
  public Integer recordsProcessed = 0;
  public Integer recordsFailed = 0;

  public void setLoyaltyTestData(
    String loyaltyProgramName,
    String journalTypeName
  ) {
    this.loyaltyProgramName = loyaltyProgramName;
    this.journalTypeName = journalTypeName;
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(this.accrualTransactionQuery);
  }

  global void execute(
    Database.BatchableContext BC,
    List<TransactionJournal> accrualTransactions
  ) {
    recordsProcessed += accrualTransactions.size();

    //Calling accrual logic on Pending accrual transactions
    AccrualApexImplementation accrualApex = new AccrualApexImplementation();
    recordsFailed += accrualApex.executeAccrualApex(accrualTransactions);
  }

  global void finish(Database.BatchableContext BC) {
    // Query the AsyncApexJob object to retrieve the current job's information.
    AsyncApexJob job = [
      SELECT
        Id,
        Status,
        NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems,
        CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
      WITH SECURITY_ENFORCED
    ];

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new List<String>{ job.CreatedBy.Email };
    mail.setToAddresses(toAddresses);
    mail.setSenderDisplayName('Accrual Batch Processing Status');
    mail.setSubject('Loyalty Sample App Accrual Batch Process Completed');
    mail.setPlainTextBody(
      'Batch Process has completed.\n Records Processed: ' +
      recordsProcessed +
      '\nRecords Failed : ' +
      recordsFailed +
      '\nThe batch Apex job processed ' +
      job.TotalJobItems +
      ' batches with ' +
      job.NumberOfErrors +
      ' batch failures.'
    );

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }

  global void execute(SchedulableContext sc) {
    //Query for all TransactionJournals which is of type Accrual and status is Pending
    this.accrualTransactionQuery =
      'SELECT Id, MemberId, Quantity, TransactionAmount, ProductId, ProductCategoryId,' +
      ' JournalType.Name, JournalSubType.Name, JournalSubType.RuleType__c, ActivityCategory__c ' +
      'FROM TransactionJournal ' +
      'WHERE LoyaltyProgram.Name = \'' +
      this.loyaltyProgramName +
      '\' AND JournalType.Name = \'' +
      this.journalTypeName +
      '\' AND Status = \'Pending\' WITH SECURITY_ENFORCED';

    //Parameters of ExecuteBatch(context,BatchSize)
    Database.executeBatch(this);
  }
}