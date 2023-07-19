/**
@author Salesforce.com
@Date 2021
@description IssueVoucherRESTUtil Util Class to make Voucher Callout
*/ 
Public Class IssueVoucherRESTUtil {
    
    /**
     * @description executeInvocableActionRestAPI methoed enables to make a callout issue voucher invokable action
     * @param  restEndPoint end of the Invokable action
     * @param  httpBodyPayload payload of the Invokable action
     * @return Nothing
    */
    @Future(callout=true)
    Public static void executeInvocableActionRestAPI(String restEndPoint, String httpBodyPayload){
        
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL + restEndPoint;  
        HttpRequest httpRequest = new HttpRequest(); 
        httpRequest.setEndpoint(restAPIURL);  
        httpRequest.setMethod('POST');   
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
        httpRequest.setTimeout(120000);
        httpRequest.setBody(httpBodyPayload);
        Http http = new Http();   
        try {
            
            IssueVoucherHTTPRequestClass.HTTPRequestClass httpReqClassList = (IssueVoucherHTTPRequestClass.HTTPRequestClass)JSON.deserializeStrict(httpBodyPayload, IssueVoucherHTTPRequestClass.HTTPRequestClass.class);
            HttpResponse httpResponse = http.send(httpRequest);            
            List<IssueVoucherHTTPResponseClass.HTTPResponseResult> httpResultList = (List<IssueVoucherHTTPResponseClass.HTTPResponseResult>)JSON.deserializeStrict(httpResponse.getBody(), List<IssueVoucherHTTPResponseClass.HTTPResponseResult>.class);
            Integer index = 0;
            String finalString;
            String header = 'Voucher Code, Status Code, Error Message \n';
            finalString = header ;
            for( IssueVoucherHTTPResponseClass.HTTPResponseResult httpResult : httpResultList) {
                
                if( !httpResult.isSuccess ) {
                    string recordString = httpReqClassList.inputs[index].VoucherCode+','+httpResult.errors[0].statusCode+','+httpResult.errors[0].message+'\n';
                    finalString = finalString +recordString;
                    system.debug('::finalString::'+finalString);
                } else {
                    break;
                }
                index++;
            }
            // Issue Voucher action process all or none hence, send email if there are any failure 
            If( !httpResultList[0].isSuccess ) {
            	IssueVoucherRESTUtil.sendEmail(finalString, httpResultList[0].isSuccess);    
            }
        } catch (Exception ex) {
            System.Debug(LoggingLevel.ERROR, 'Exception Occurred :: ' + ex.getMessage());
        }
    } 
    /**
     * @description sendEmail methoed enables to send status of the callout 
     * @param  finalString - Error data which need to be send in the email
     * @param  status - Denotes status of the callout
     * @return Nothing
    */
    Public static void sendEmail(String finalString, Boolean isSuccess) {
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        email.setTargetObjectId(UserInfo.getUserId());
        email.setSaveAsActivity(false);
        if( isSuccess == FALSE ) {
            email.setSubject('Voucher Import Failue!');
            email.setPlainTextBody('The file upload has failed and refer the csv attachment for more information.');
            blob csvBlob = Blob.valueOf(finalString);
            csvAttc.setFileName('Voucher error.csv');
            csvAttc.setBody(csvBlob);    
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        } else {
            email.setSubject('Voucher Import Success!');
            email.setPlainTextBody('The file has successfully uploaded into the system.');
        }
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});                
    }
}