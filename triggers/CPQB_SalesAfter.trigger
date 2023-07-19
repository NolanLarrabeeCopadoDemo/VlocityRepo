trigger CPQB_SalesAfter on SalesAgreement (after insert) {
  CPQB_CreateSalesAgreement.handleAfterInsert(Trigger.newMap);
}