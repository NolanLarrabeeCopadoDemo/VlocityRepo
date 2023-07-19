/**
* @author Salesforce.com
* @date 2021
*
* @description Utility class to perform Rest Call and return response
*/
public inherited sharing class RedemptionRestUtil {
   
   /**
    * @description perform Rest Call 
    * @param restEndPoint Rest action URL
    * @param httpBodyPayload Payload to be sent to action URL
    * @return Rest API call response body
    */
	public static HttpResponse executeInvocableActionRestAPI(String requestMethod, String restEndPoint, String httpBodyPayload){
        
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL + restEndPoint;
        
        HttpRequest httpRequest = new HttpRequest(); 
        httpRequest.setEndpoint(restAPIURL);  
        httpRequest.setMethod(requestMethod);   
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
        httpRequest.setBody(httpBodyPayload);
        Http http = new Http();   
        HttpResponse httpResponse = http.send(httpRequest);
        return httpResponse;  
    } 
    
    /**
    * @description 
    * @param requestMethod 'POST' for insert dml and 'PATCH' for update dml
    * @param actionUrl Rest action URL
    * @param actionPayloadString Payload to be sent to action URL
    * @return Output body of the executed action
    */
    public static String executeAction(String requestMethod, String actionUrl,String actionPayloadString)
    {
        HttpResponse actionHttpResponse = executeInvocableActionRestAPI(requestMethod, actionUrl, actionPayloadString);
        return actionHttpResponse.getBody();
    }
    
    /**
     * Custom Class to help in seriliasing Request Body for Inserting/Updating TransactionJournal,
     * VoucherCode__c, VoucherDefinition through SObject Collections REST endpoint to avoid Uncommited transaction
     * problem on httpcallout
     */
    private class SObjectCollectionWrapper {
        boolean allOrNone;
        SObject[] records;
        SObjectCollectionWrapper(SObject[] records ){
            this.allOrNone = true;
            this.records = records;
        }
    }
    
    /**
    * @description Performs bulk update/create of SObjects
    * @param requestMethod 'POST' for insert dml and 'PATCH' for update dml
    * @param records List of sObjects records for dml
    * @return List of Database.SaveResult after the dml operation
    */
    public static Database.SaveResult[] performBulksObjectOperation(String requestMethod, SObject[] records){
        /* BULK create/update SObject records using SObject Collections REST endpoint
        *  This POST request supports sObject Collections to add/update up to 200 records, returning a list of SaveResult objects 
        */	
        SObjectCollectionWrapper sObjectCollectionWrapper = new SObjectCollectionWrapper(records);
        String sObjectCollectionsPayloadRequest = JSON.serializePretty(sObjectCollectionWrapper);
        String sObjectCollectionsResponse = executeAction(requestMethod, 
                                                          RedemptionConstants.COMPOSITE_POST_URL,
                                                          sObjectCollectionsPayloadRequest);
        
        //Deserialise the SaveResult objects in response
        Database.SaveResult[] sObjectSaveResults = (List<Database.SaveResult>)JSON.deserializeStrict(sObjectCollectionsResponse,
                                                                                                List<Database.SaveResult>.class);
        return sObjectSaveResults;
        
    }
}