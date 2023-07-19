public class BOMContoller {
    public List<SBQQ__QuoteLine__c> bom { get; set; }
    public String quoteID = ApexPages.currentPage().getParameters().get('qid');
    public SBQQ__Quote__c quat { get; set; }
    
    public BOMContoller(){
        bom = [select Name, SBQQ__Quantity__c, SBQQ__ProductCode__c, SBQQ__Description__c, SBQQ__ProductName__c, SBQQ__ProductFamily__c, Inventory_Status__c, MFG_Site__c   FROM SBQQ__QuoteLine__c where SBQQ__Quote__c =: quoteID];
		// System.debug('BOM:' + bom); 
		quat = [select Name, SBQQ__Account__r.Name FROM SBQQ__Quote__c where Id =: quoteID];
    }
    
}