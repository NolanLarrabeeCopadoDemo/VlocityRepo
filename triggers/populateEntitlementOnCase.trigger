/**
@author Salesforce.com
@Date 2021
@description populateEntitlementOnCase trigger to populate Entitlment on Case creation based on Account
*/ 
trigger populateEntitlementOnCase on Case (before insert) {
    // Variable declaration
    List<Case> CaseRecordList = new List<Case>(); 
    Map<Id,Id> accountEntitlmentIdMap = new Map<Id,Id>();
    Set<Id> accountIdsSet = new Set<Id>(); 
    for( Case caseRecord : Trigger.New ) {
    	// If Case is associated with Account
        if(caseRecord.AccountId != NULL ) {
        	CaseRecordList.add(caseRecord);
            accountIdsSet.add( caseRecord.AccountId );
        }
    }
    // Query Entitlment record by supplying Account Ids which is referred in incoming cases
    For(Entitlement entitlement : [SELECT Id, AccountId FROM Entitlement WHERE AccountId IN : accountIdsSet ]) {
    	
        accountEntitlmentIdMap.put( entitlement.AccountId, entitlement.Id );
    }
    // Iterating through new cases to populate Entitlement by matching with Account Id
    For(Case newCaseRecord : CaseRecordList ) {
    	
        if( accountEntitlmentIdMap.containsKey( newCaseRecord.AccountId )) {
            newCaseRecord.EntitlementId = accountEntitlmentIdMap.get( newCaseRecord.AccountId );
        }
    }

}