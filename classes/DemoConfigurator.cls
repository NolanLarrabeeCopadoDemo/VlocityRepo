global class DemoConfigurator{
    /** Get All Demo Settings from Demo Settings Object **/
	@AuraEnabled
    global static List<DemoSettings__c> GetSettings() {
        return [SELECT Id, Name,Completed_Description__c ,DeveloperName__c ,Configuration_Name__c,Enablement_Description__c,Enabled__c FROM DemoSettings__c WHERE AllowEnable__c = true Order By Order__c ASC];
    }
    /** Update Demo Settings to Enabled **/ 
	@AuraEnabled
    global static List<DemoSettings__c> UpdateDemoSetting(String WhichSetting) { 
        DemoSettings__c[] demosetting = [SELECT Id FROM DemoSettings__c WHERE DeveloperName__c = :WhichSetting]; 
            for(DemoSettings__c ds: demosetting) {
                ds.Enabled__c = true;
            }
        /** Attempt to update the demo setting fields and throw error in debug log if it fails **/
        try{
        	update demosetting;
            return [SELECT Id, Name,Completed_Description__c ,DeveloperName__c ,Configuration_Name__c,Enablement_Description__c,Enabled__c FROM DemoSettings__c WHERE AllowEnable__c = true Order By Order__c ASC];
        }catch(exception e){
            System.debug('Update Demo Setting Error: ' + e);
            return null;
        }
    }
    
    /** Get Org Base URL **/
    @AuraEnabled
    public static String getBaseURL(){
        return URL.getSalesforceBaseUrl().toExternalForm(); 
    } 
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
      system.debug('objObject --->' + objObject);
      system.debug('fld --->' + fld);
      List < String > allOpts = new list < String > ();
      // Get the object type of the SObject.
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
     
      // Get the list of picklist values for this field.
      list < Schema.PicklistEntry > values =
       fieldMap.get(fld).getDescribe().getPickListValues();
     
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a: values) {
       allOpts.add(a.getValue());
      }
      system.debug('allOpts ---->' + allOpts);
      allOpts.sort();
      return allOpts;
     }
    /** Send Feedback to Demo Content Owner Via Email **/
    @AuraEnabled 
    public static void emailContentFeedback(String title, String reasonAttr, String unlineDescAttr,String email){
        Id userId = userInfo.getUserId();
        String OwnerEmail = email;
        String ContentTitle = title;
        String UserProfile = [SELECT ID FROM Profile WHERE Name = 'System Administrator'].Id;
        String UserEmail = [SELECT Email FROM User WHERE ProfileId = :UserProfile AND (UserRole.Name = 'CEO') LIMIT 1].Email;
        /* org information */
        String instanceName = [select InstanceName from Organization limit 1].InstanceName;
        Organization org = [SELECT id, Name, PrimaryContact  FROM Organization];
        Id orgId = org.Id;
        String Name = org.Name;
        String PrimContact = org.PrimaryContact;

        String EmailBody;
        String likedisliketext;
        EmailBody = '<h2>Content Feedback</h2>' +
                    '<strong>Demo Content</strong><br/>' +  ContentTitle + '<br/><br/>' + 
                    '<strong>Feedback Reason</strong><br/>' +  reasonAttr + '<br/><br/>' +
                    '<strong>Description</strong><br/>' +  unlineDescAttr + '<br/><br/><hr/>' + 
                    '<h2>Org Details</h2>' +
                    '<strong>Org Details</strong><br/>' +  instanceName + '<br/><br/>' + 
                    '<strong>Id: </strong>' +  orgId + ' | ' +
                    '<strong>Name: </strong>' +  Name + ' | ' +
                    '<strong>User: </strong> ' + PrimContact + ' | ' +  
                    '<strong>Email: </strong>' + UserEmail;
        
        String EmailSubj = 'Demo Content Feedback | ' + ContentTitle;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { OwnerEmail};
        message.optOutPolicy = 'FILTER';
        message.subject = EmailSubj;
        message.htmlBody = EmailBody;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    @AuraEnabled
    public static void RunRequiredSetup(){
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'Professional Community'];
		ConnectApi.Community comm = ConnectApi.Communities.getCommunity(myCommunity.Id);
		List<String> BaseURL = comm.siteUrl.split('[/]');
        /*Store URL : https://sdodemo-main-166ce2cf6b6-1698177dece.force.com/DefaultStore/ccrz__ProductDetails?sku=WTIN-ASMBLY*/
        
        MFG_Recommended_Part__c[] recparts = [SELECT Id, Name,MFG_PartName__r.ccrz__SKU__c ,MFG_Asset__c from MFG_Recommended_Part__c]; 
        for (MFG_Recommended_Part__c p : recparts) {
            p.MFG_Commerce_Link__c  = 'https://' + BaseURL[2] + '/DefaultStore/ccrz__ProductDetails?sku=' + p.MFG_PartName__r.ccrz__SKU__c ;
        }
        try{
        	update recparts;
        }catch(exception e){
            System.debug('Update Recommended Parts Object Error: ' + e);
        }
    }
    
    @AuraEnabled
    public static void BuildAssetURL(){
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'Professional Community'];
		ConnectApi.Community comm = ConnectApi.Communities.getCommunity(myCommunity.Id);
		List<String> BaseURL = comm.siteUrl.split('[/]');
        /*Store URL : https://sdodemo-main-166ce2cf6b6-1698177dece.force.com/DefaultStore/ccrz__ProductDetails?sku=WTIN-ASMBLY*/
        
        Asset[] assets = [SELECT Id from Asset]; 
        for (Asset a : assets) {
            a.MFG_Professional_Community_URL__c = 'https://' + BaseURL[2] + '/professional/';
            a.MFG_Partner_Central_Community_URL__c = 'https://' + BaseURL[2] + '/partnercentral/'; 
        }
        try{
        	update assets;
        }catch(exception e){
            System.debug('Update Recommended Parts Object Error: ' + e);
        }
    }
    
    @AuraEnabled
    public static void B2BSetup(){
    	/**
    	 * Updates all of the indexes 
		 */
        
        CkzUpdateCacheService.doUpdate();
        
        /**
         * Delete All Cloudcraze Carts
         */
        
        /*delete  [SELECT Id, ccrz__CartStatus__c, ccrz__ActiveCart__c FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true AND ccrz__CartStatus__c = 'Open'];*/
    }
    
    @RemoteAction
    global static Map<String,Object> DataConnectors() {
        string sessionId = UserInfo.getSessionId();
        string base = URL.getSalesforceBaseUrl().toExternalForm();
        String url = base + '/services/data/v47.0/wave/dataConnectors';  
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        String authorizationHeader = 'OAuth ' + sessionId;
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        return responseMap;
        
    }
    /** Run all Analytics Dataflows with this handy snippet **/
    @RemoteAction
    global static void RunDataConnector(String ConnectorId) {
        string sessionId = UserInfo.getSessionId();
        string base = URL.getSalesforceBaseUrl().toExternalForm();
        string ingest = '/services/data/v47.0/wave/dataConnectors/' + ConnectorId + '/ingest';
        String url = base + ingest;  
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        
        String authorizationHeader = 'OAuth ' + sessionId;
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        
    } 
    
}