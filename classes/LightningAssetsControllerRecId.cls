public class LightningAssetsControllerRecId {
      
@AuraEnabled
public static String getBaseUrl () {
    if (Network.getNetworkId() != null) {
        return [SELECT Id, UrlPathPrefix FROM Network WHERE Id = :Network.getNetworkId()].UrlPathPrefix;
    }
    return '';
}

    
@AuraEnabled
public static String getUIThemeDescription() {
    return UserInfo.getUiThemeDisplayed();
}
  /*
   //Dan Shannon commented; if Asset Info is needed on the WorkOrder record
   
    @AuraEnabled
    public static List<Asset> getAssetDetailWO(String recordId){
    
        system.debug('WO RecId: ' + recordId);
        
            List<WorkOrder> woList = [SELECT Asset.Id FROM WorkOrder WHERE Id =: recordId];
            system.debug('wo RecId: ' + woList.Size());   
            for(WorkOrder w : woList){
            
                system.debug('return AssetId: ' + w.Asset.Id);  
                return [Select Id, Map__c,Coordinates__c,Location.Id,Location.Name, Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c , Warranty_Ind_URL_Public__c , AccountId,Community_Image_URL__c,SerialNumber,Name, Entitlement_Status__c, Operational_Status_Ind_URL__c, Operational_Status__c 
                   From Asset
                   Where id =: w.Asset.Id

                 ];
        }
        system.debug('return null');
        return null;

      }  
    
    */
    
    /*
     //Dan Shannon commented; if Asset Info is needed on the Oppty record
    @AuraEnabled
    public static List<Asset> getAssetDetailOppty(String recordId){
    
        system.debug('WO RecId: ' + recordId);
        
            List<Opportunity> opptyList = [SELECT Asset__r.Id FROM Opportunity WHERE Id =: recordId];
            system.debug('oppty RecId: ' + opptyList.Size());   
            for(Opportunity o : opptyList){
            
                system.debug('return AssetId: ' + o.Asset__r.Id);  
                return [Select Id, Map__c,Coordinates__c,Location.Id,Location.Name, Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c , Warranty_Ind_URL_Public__c , AccountId,Community_Image_URL__c,SerialNumber,Name, Entitlement_Status__c, Operational_Status_Ind_URL__c, Operational_Status__c 
                   From Asset
                   Where id =: o.Asset__r.Id

                 ];
        }
        system.debug('return null');
        return null;

      }  
    
    */
    
    
    
    @AuraEnabled
    public static List<Turbine_Metrics__c > getAssetMetrics(String recordId){
    
        system.debug('Turbine_Metrics__c RecId: ' + recordId);
        
            List<Asset> assetList = [SELECT Asset.Id FROM Asset WHERE Id =: recordId];
            //system.debug('wo RecId: ' + woList.Size());   
            for(Asset a : assetList){
            
                //system.debug('return AssetId: ' + w.Asset.Id);  
                return [Select Id,Asset__r.LocationId, Operational_Status_URL__c, Asset__r.Name, kW_Indicator_URL__c ,Date_Time_Reported__c,Direction__c,Hours__c,kW_Indicator__c,kW_Output_Current__c,Avg_kW_Output__c,kW_Output_Daily_High__c,kW_Output_Daily_Low__c,kW_Output_Monthly_Avg__c,LastModifiedById,Lifetime_Hours__c,Operational_Status__c,OwnerId,RPM__c
                   From Turbine_Metrics__c 
                   Where Asset__r.Id =: a.Id
                   ORDER BY Date_Time_Reported__c DESC

                 ];
        }
        system.debug('return null');
        return null;

      }  


    @AuraEnabled
    public static List<Asset> getAsset(String recordId){
    
        system.debug('RecId: ' + recordId);
//        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId() LIMIT 1];
                //orig: //return [Select Id, Map__c,Coordinates__c,Location.Id,Location.Name, Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c , Warranty_Ind_URL_Public__c , AccountId,Community_Image_URL__c,SerialNumber,Name, Entitlement_Status__c, Operational_Status_Ind_URL__c, Operational_Status__c 
                return [Select Id,Product2.MFG_Image_URL__c ,MFG_BaseUrl__c ,Product2.Image_URL__c,Map__c,MFG_IDO_IOT_Status__c ,Location.Id,Location.Name, Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c, AccountId, Product2.purl__c,SerialNumber,Name, Entitlement_Status__c
                        //, 
                        //Operational_Status_Ind_URL__c, 
                        //Operational_Status__c                         
                   From Asset
                   Where Asset.id =: recordId

                   //Limit 20 
                 ];
      }
    
    
                 @AuraEnabled
    public static List<Asset> getAssets(String recordId){
    
        	id userId = UserInfo.getUserId();
			User u = [select id, accountId, contactId from User where id = : userId];
			id getContactId = u.contactId;
            id acctId = u.accountId;
			system.debug('getContactId' + getContactId);
        
        system.debug('RecId: ' + recordId);
//        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId() LIMIT 1];
        //orig: //return   [Select Id, Map__c,Coordinates__c,Location.Id,Location.Name, Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c , Warranty_Ind_URL_Public__c , AccountId,Community_Image_URL__c,SerialNumber,Name, Entitlement_Status__c, Operational_Status_Ind_URL__c, Operational_Status__c 
        return   [Select Id,MFG_BaseUrl__c ,Product2.MFG_Image_URL__c ,Product2.Image_URL__c,Map__c,Location.Id,MFG_IDO_IOT_Status__c ,Location.Name, Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c, AccountId,Product2.purl__c,SerialNumber,Name, Entitlement_Status__c
                  //, 
                  //Operational_Status_Ind_URL__c, 
                  //Operational_Status__c  
                   From Asset
                   //Where Account.id =: recordId AND Asset_Status__c !=: ''
                   Where Account.id =: acctId AND Asset_Status__c != ''
                   ORDER BY SerialNumber ASC
                   //Limit 20 
                 ];
      }
    
 
    @AuraEnabled
    public static List<Asset> getAssetDetail(String recordId){
    
        system.debug('case RecId: ' + recordId);
        
            List<Case> caseList = [SELECT Asset.Id FROM Case WHERE Id =: recordId];
                  system.debug('case RecId: ' + caseList.Size());   
        for(Case c : caseList){
            
                system.debug('return AssetId: ' + c.Asset.Id);  
//orig://                return [Select Id, Map__c,Coordinates__c,Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c , Warranty_Ind_URL_Public__c , AccountId,Community_Image_URL__c,SerialNumber,Name, Entitlement_Status__c
                return [Select Id,MFG_BaseUrl__c ,Product2.MFG_Image_URL__c ,Product2.Image_URL__c,Map__c,MFG_IDO_IOT_Status__c ,Asset_Status__c ,Product2.Name,WarranyIndPublic__c,Status_Indicator_URL_Public__c, AccountId,Product2.purl__c,SerialNumber,Name, Entitlement_Status__c                        
                   From Asset
                   Where id =: c.Asset.Id 

                 ];
        }
        system.debug('return null');
        return null;

      }
    
    /*
      @AuraEnabled
    public static List<Asset> getAssets(String recordId){
    

        
//        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId() LIMIT 1];
        return   [Select Id, Name,Status1__c,Status2__c,Status3__c,Status1_Ind__c,Status2_Ind__c,Status3_Ind__c
                  From Asset
                   Where Account.id =: recordId
                  ORDER BY Status1__c ASC
                   Limit 10 ];
      }
    
             @AuraEnabled
    public static List<Asset> getAssetsAccount(String recordId){
    

//        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId() LIMIT 1];
        return   [Select Id, AccountId, ListImage_URL__c, Tail_Number__c,SerialNumber ,Name,Status1__c,Status2__c,Status3__c,Status1_Ind__c,Status2_Ind__c,Status3_Ind__c,Entitlement_Status__c 
                   From Asset
                   Where Account.id =: recordId AND Tail_Number__c !=: ''
                  ORDER BY Tail_Number__c ASC
                   //Limit 20 
                 ];
      }
*/    
    /*
        @AuraEnabled
    public static List<A_C_Relationship__c> getACRelationship(String recordId){
    
         system.debug('getting relationships:' + recordId);
//        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId() LIMIT 1];
        return   [Select Id, Aircraft__r.Product2.Name, Aircraft__r.ListImage_URL__c  ,  Aircraft_User__c, Aircraft_User__r.Name, Management_Co__c , Management_Co__r.Name,Owner__c,Owner__r.Name , Aircraft__c, Aircraft__r.Warranty_Ind_URL__c ,Aircraft__r.Warranty_Indicator__c,  Aircraft__r.Tail_Number__c,Aircraft__r.SerialNumber ,Aircraft__r.Name,Aircraft__r.Entitlement_Status__c 
                   From A_C_Relationship__c 
                   Where Owner__r.id =: recordId AND Aircraft__r.Tail_Number__c !=: ''
                  ORDER BY Aircraft__r.Tail_Number__c DESC
                   //Limit 20 
                 ];
      }    

            @AuraEnabled
    public static List<A_C_Relationship__c> getACRelationshipManagement(String recordId){
    
         system.debug('getting relationships:' + recordId);
//        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId() LIMIT 1];
        return   [Select Id, Aircraft__r.Product2.Name, Aircraft__r.Product2.Community_Image_URL__c  ,  Aircraft_User__c, Aircraft_User__r.Name, Management_Co__c , Management_Co__r.Name,Owner__c,Owner__r.Name , Aircraft__c, Aircraft__r.Warranty_Ind_URL__c ,Aircraft__r.Warranty_Indicator__c,  Aircraft__r.Tail_Number__c,Aircraft__r.SerialNumber ,Aircraft__r.Name,Aircraft__r.Entitlement_Status__c 
                   From A_C_Relationship__c 
                   Where Management_Co__r.id =: recordId AND Aircraft__r.Tail_Number__c !=: ''
                  ORDER BY Aircraft__r.Tail_Number__c DESC
                   //Limit 20 
                 ];
      } 
*/
}