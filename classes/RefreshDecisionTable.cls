global with sharing class RefreshDecisionTable {

    @future(callout=true)
    static public void refreshAllTheDecisionTable(){
        //get class name
        String className   = RefreshDecisionTable.class.getName();
        //set default value for api version
        Decimal APIVERSION = 48.0;
        try {
             //fetch api value from class version
             APIVERSION = [SELECT ApiVersion FROM ApexClass WHERE Name = :className WITH SECURITY_ENFORCED Limit 1].ApiVersion; 
        }
        catch(Exception e){
            throw new ValidationException('Invalid Class Name');
        }
        //declare payload
        String decisionTablePayload='{ "inputs": [ {"decisionTableApiName": "Calculate_Points_Awarded_Based_on_Product_and_Tier"},'+
        						   '{"decisionTableApiName": "Calculate_Points_to_Credit_Based_on_Activity"},'+
        						   '{"decisionTableApiName": "Evaluate_Target_Member_Tier"},'+        
                                   '{"decisionTableApiName": "Points_to_Redeem_Based_on_Products_and_Vouchers"}]}';
        //set actionn URL
        String actionURL = '/services/data/v'+APIVERSION+'/actions/standard/refreshDecisionTable';
        
        //Set of Decision Table API Name
        String[] apiNames=new String[]{'Calculate_Points_Awarded_Based_on_Product_and_Tier','Calculate_Points_to_Credit_Based_on_Activity','Evaluate_Target_Member_Tier','Points_to_Redeem_Based_on_Products_and_Vouchers'};
        
        // Call DT refresh action
        String dtResponse = executeAction(actionURL,decisionTablePayload);
        List<Object>  response = (List<Object> ) JSON.deserializeUntyped(dtResponse);
        
        for(integer i=0;i<response.size();i++){

            Map<String,Object> singleResponseMap=(Map<String, Object>)response.get(i);
            //in case of any error in refreshing decision table, throw exception.
            if(((boolean)singleResponseMap.get('isSuccess'))==false){
                throw new ValidationException('Issue in Refreshing '+apiNames[i]+' Decision Table');
            }  
        
        }
    }
            
    private static String executeAction(String actionUrl, String actionPayloadString){
        HttpResponse actionHttpResponse = RedemptionRestUtil.executeInvocableActionRestAPI('POST',actionUrl, actionPayloadString);
       return actionHttpResponse.getBody();
    }
}