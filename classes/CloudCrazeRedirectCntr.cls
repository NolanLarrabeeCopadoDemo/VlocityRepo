public class CloudCrazeRedirectCntr {
    @AuraEnabled
    public Static List<String> commurl(String Community) {
        Network myCommunity = [SELECT Id FROM Network WHERE Name = :Community];
		ConnectApi.Community comm = ConnectApi.Communities.getCommunity(myCommunity.Id);
		List<String> BaseURL = comm.siteUrl.split('[/]');
        return BaseURL;
    }
    
    @AuraEnabled
    public static String BuildAssetOrderPartsLink(String Community,String Store, String AssetId){
        String url = '';
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'Professional Community'];
		ConnectApi.Community comm = ConnectApi.Communities.getCommunity(myCommunity.Id);
		List<String> BaseURL = comm.siteUrl.split('[/]');
        String AssetName = [SELECT Name FROM Asset WHERE Id = :AssetId].Name;
        String pid = [SELECT Product2Id from Asset WHERE Id = :AssetId].Product2Id ; 
        
        
        if(AssetName.Contains('Skid')){
            url = 'https://' + BaseURL[2] + '/DefaultStore/ccrz__ProductDetails?viewState=DetailView&cartID=&sku=93-00934';
        }else{
            /*String sku = [SELECT ccrz__SKU__c,Product__c from ccrz__E_Product__c WHERE Product__c = :pid].ccrz__SKU__c; 
        	/*url = 'https://' + BaseURL[2] + '/' + Store + '/ccrz__ProductDetails?viewState=DetailView&sku=' + sku; */
        	/*url = 'https://' + BaseURL[2] + '/' + Store + '/ccrz__ProductDetails?viewState=DetailView&sku=' + sku; */
            url = 'https://' + BaseURL[2] + '/' + Store + '/ccrz__Products?viewState=ListView'; 
            
        }
        return url; 
    }
	
}