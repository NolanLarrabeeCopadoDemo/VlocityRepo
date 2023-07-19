/**
@author Salesforce.com
@Date 2020
@description IssueVoucherRESTCalloutMock mock class for IssueVoucherRESTUtil class
*/ 
@isTest
Global class IssueVoucherRESTCalloutMock implements HttpCalloutMock {
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"actionName":"issueVoucher","errors":null,"isSuccess":true,"outputValues":{"VoucherId":"0kDR000000000VnMAI"}},{"actionName":"issueVoucher","errors":null,"isSuccess":true,"outputValues":{"VoucherId":"0kDR000000000VoMAI"}}]');
        response.setStatusCode(200);
        return response; 
    }
}