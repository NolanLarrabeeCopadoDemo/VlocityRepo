trigger CPQTemplateOpportunityAfter on Opportunity (after insert) {
    List<Pricebook2> pricebook = new List<Pricebook2>();
    pricebook = [SELECT Id FROM Pricebook2 WHERE IsActive = true ORDER BY IsStandard LIMIT 1];
    if(pricebook.size() == 1){
        List<Opportunity> opps = [SELECT Id, SBQQ__QuotePricebookId__c FROM Opportunity WHERE SBQQ__QuotePricebookId__c = NULL AND Id IN :trigger.newMap.keySet()];
        for(Opportunity o : opps){
            o.SBQQ__QuotePricebookId__c = String.valueOf(pricebook.get(0).Id).substring(0, 15);
        }
        update opps;
    }
}