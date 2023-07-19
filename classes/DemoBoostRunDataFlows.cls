public class DemoBoostRunDataFlows{
    @AuraEnabled
    public static String runDataFlows(){
        String result;
        
        String endPoint = 'https://demo-boost-mq.herokuapp.com/api/demo-boost/action/run_dataflows';
        String username = UserInfo.getUserName();
        String email = UserInfo.getUserEmail();
        String orgId = QLabs__mdt.getInstance('Org_Identifier').Identifier__c;
        System.debug('username: ' + username + ' email: ' + email + ' orgId: ' + orgId);
        
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            req.setMethod('POST');
            
            Map<String,String> requestBody = new Map<String,String>();
            requestBody.put('username', username);
            requestBody.put('email', email);
            requestBody.put('organization_identifier', orgId);
            
            req.setBody(JSON.serialize(requestBody));
            
            Http http = new Http();
            HTTPResponse response = http.send(req);
            String responseString = response.getBody();
            // System.debug('responseString: ' + responseString);
            result = 'Run data flows is successful. You may close this tab. ' + responseString;
        } catch (Exception error){
            result = error.getMessage();
        }
        
        // System.debug('result: ' + result);
        return result;
    }
}