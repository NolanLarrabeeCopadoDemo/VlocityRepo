public class Q2CGenerateQuickQuote {

    public static String mydomain = System.Url.getSalesforceBaseUrl().toExternalForm().substringBefore('.').substringBeforeLast('c');
    public static String instanceName = [SELECT InstanceName FROM Organization LIMIT 1].InstanceName;
    
    
// This is an Extension Controller. Thus, we must invoke the standard controller.
    public Q2CGenerateQuickQuote(ApexPages.StandardController controller) {
    }

// Method for creating Quote 
    public static PageReference genQuote() {
        
        Id acctId = ApexPages.currentPage().getParameters().get('id');
        
        //Revenue Cloud specific setup. If there's any error, check if someone renamed the Price Book and/or Opty Record Type ID
        List<RecordType> optyRecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType='Opportunity' AND RecordType.name = 'Revenue Cloud' LIMIT 1];
        List<PriceBook2> PBListId = [SELECT id FROM Pricebook2 WHERE Name = 'CPQ Products' LIMIT 1];

        if(optyRecordTypeId.size() > 0 && PBListId.size() > 0){
            Opportunity opp = new Opportunity(CloseDate = Date.today(), AccountId = acctId, StageName = 'Qualification', Name = 'New Opportunity', RecordTypeId = optyRecordTypeId.get(0).id, Pricebook2Id = PBListId.get(0).id);
            Database.insert(opp);
            Id oppId = opp.Id;
            SBQQ__Quote__c q = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Account__c = acctId, SBQQ__SubscriptionTerm__c = 12, SBQQ__Opportunity2__c = oppId, SBQQ__Status__c = 'Draft', SBQQ__Type__c = 'Quote', SBQQ__PricebookId__c = PBListId.get(0).id);
            List<Contact> ContactList = [SELECT Id FROM Contact WHERE AccountId = :acctId LIMIT 1];
            if (ContactList.size() > 0) {
                q.SBQQ__PrimaryContact__c = ContactList.get(0).Id;
            }
            Database.insert(q);
            String quoteId = q.Id;
            //Returns URL and redirects the Visualforce page
            // return new PageReference(mydomain + 'sbqq.' + instanceName + '.visual.force.com/apex/sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);

            return new PageReference('/apex/sbqq__sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);
        }
        else{
            return new PageReference('/lightning/r/Account/' + acctId + '/view');
        }
    }
    public static PageReference genQuoteFromOpty() {
        
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        Opportunity opty = [SELECT id, Pricebook2Id, AccountId FROM Opportunity WHERE id =: oppId LIMIT 1];
        List<PriceBook2> PBListId = [SELECT id FROM Pricebook2 WHERE id =: opty.Pricebook2Id LIMIT 1];

        SBQQ__Quote__c q = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Account__c = opty.AccountId, SBQQ__SubscriptionTerm__c = 12, SBQQ__Opportunity2__c = oppId, SBQQ__Status__c = 'Draft', SBQQ__Type__c = 'Quote', SBQQ__PricebookId__c = PBListId.get(0).id );
        List<Contact> ContactList = [SELECT Id FROM Contact WHERE AccountId = :opty.AccountId LIMIT 1];
        if (ContactList.size() > 0) {
            q.SBQQ__PrimaryContact__c = ContactList.get(0).Id;
        }
        Database.insert(q);
        String quoteId = q.Id;
        //Returns URL and redirects the Visualforce page
        // return new PageReference(mydomain + 'sbqq.' + instanceName + '.visual.force.com/apex/sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);

        return new PageReference('/apex/sbqq__sb?scontrolCaching=1&id=' + quoteId + '#quote/le?qId=' + quoteId);
    }

}