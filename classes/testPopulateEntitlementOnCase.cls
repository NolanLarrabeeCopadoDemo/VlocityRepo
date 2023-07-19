/**
@author Salesforce.com
@Date 2021
@description test class for populateEntitlementOnCase trigger
*/ 
@isTest
public class testPopulateEntitlementOnCase {
	
    @isTest
    static void testCaseRecords() {
        
        Account account = new Account();
        account.Name = 'ABC Corporation';
        Insert account;
        
        Entitlement entitlement = new Entitlement();
        entitlement.AccountId = account.id;
        entitlement.Name = 'Premium Support';
        Insert entitlement;
        
        Case caseRecord = new Case();
        caseRecord.AccountId = account.Id;
        caseRecord.Origin ='Web';
        caseRecord.Status = 'New'; 
        Insert caseRecord;
        
        Case updatedCaseRecord = [SELECT Id,EntitlementId FROM Case WHERE Id =: caseRecord.Id];
        system.assertEquals(updatedCaseRecord.EntitlementId, entitlement.Id);
    }
}