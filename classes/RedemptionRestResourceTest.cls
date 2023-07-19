@isTest
public class RedemptionRestResourceTest {
    static HttpCalloutMock multiCalloutMock = new MultiRequestMock();
    static String testProgramName = 'Program Name Test 1';
    static String testMemberName = '24345671';
    static String testPartnerName = 'Stellar PLC';
    static String testCategoryName = 'Electric appliances';
    static String testProductName = 'Light switches';
    
    class TestIdList{
        String programId, memberId, partnerId, categoryId, productId;
    }
    @testSetup
    static void loadDefaultTestData() {
        LoyaltyDataLoadControllerTests.testDefaultLoadData();
        
    }
    static void getIds(TestIdList testIdList){
        testIdList.programId = [SELECT Id,Name from LoyaltyProgram where Name = :testProgramName Limit 1].Id;
        testIdList.memberId = [SELECT Id,MembershipNumber from LoyaltyProgramMember where MembershipNumber = :testMemberName Limit 1].Id;
        testIdList.partnerId = [SELECT Id,Name from LoyaltyProgramPartner where Name = :testPartnerName Limit 1].Id;
        testIdList.categoryId = [SELECT Id,Name from ProductCategory where Name = :testCategoryName Limit 1].Id;
        testIdList.productId = [SELECT Id,Name from Product2 where Name = :testProductName Limit 1].Id;
        
    }
    @isTest 
    static void testSuccessApexRedemption() {
        try{
            /* Apex Redemption should not throw any error as HttpCalloutMock is defined for each rest post request
            */ 
            TestIdList testIdList = new TestIdList();
            getIds(testIdList);
            String transactionRequestString =
                '{"ExecutionMethod" : "Apex",'+
                '"IsQuote" : false,'+
                '"Inputs": [    { '+
                '"LoyaltyProgramId": "'+ testIdList.programId+ '",'+
                '"MemberId": "'+ testIdList.memberId+ '",'+
                '"PartnerId": "'+ testIdList.partnerId+ '",'+
                '"ProductCategoryId": "'+ testIdList.categoryId+ '",'+
                '"ProductId": "'+ testIdList.productId+ '",'+
                '"ActivityDate": "2020-0-18"}]}';
            Test.startTest();
            testRedemption('https://yourInstance.salesforce.com/services/apexrest/LoyaltySampleAppRedemption', transactionRequestString);
            Test.stopTest();
        }catch (Exception unexpectedException){
            System.AssertEquals(null, unexpectedException, unexpectedException.getMessage());
        }
    }
    
    @isTest 
    static void testFailInvalidIds() {
        try{
            TestIdList testIdList = new TestIdList();
            getIds(testIdList);
            String transactionRequestString =
                '{"ExecutionMethod" : "Apex",'+
                '"IsQuote" : false,'+
                '"Inputs": [    { '+
                '"LoyaltyProgramId": "'+ testIdList.programId+ '",'+
                '"MemberId": "'+ testIdList.memberId+ '",'+
                '"ActivityDate": ""}]}';
            Test.startTest();
            testRedemption('https://yourInstance.salesforce.com/services/apexrest/LoyaltySampleAppRedemption', transactionRequestString);
            Test.stopTest();
        }catch (Exception unexpectedException){
            System.AssertEquals(null, unexpectedException, unexpectedException.getMessage());
        }
    }
    
    @isTest 
    static void testFailCreateJournal() {
        try{
            TestIdList testIdList = new TestIdList();
            getIds(testIdList);
            String transactionRequestString =
                '{"ExecutionMethod" : "Apex",'+
                '"IsQuote" : false,'+
                '"Inputs": [    { '+
                '"LoyaltyProgramId": "'+ testIdList.programId+ '",'+
                '"MemberId": "'+ testIdList.memberId+ '",'+
                '"ActivityDate": "2020-0-18"}]}';
            Test.startTest();
            testRedemption('https://yourInstance.salesforce.com/services/apexrest/LoyaltySampleAppRedemption', transactionRequestString);
            Test.stopTest();
        }catch (Exception unexpectedException){
            System.AssertEquals(null, unexpectedException, unexpectedException.getMessage());
        }
    }
    
    
    @isTest 
    static void testFailureFlowRedemption() {
        try{
            /* Calling for flow redemption in test class should generate a DML exception as we can't mock flow response
            * and calling flow will raise an Exception in the org where the Redemption flow is not present and the created 
            * TransactionJournal will have to be reverted. As we are mocking creation of TransactionJournal through HttpCalloutMock,
            * deletion of it will throw DmlException.
            */
            TestIdList testIdList = new TestIdList();
            getIds(testIdList);
            String transactionRequestString =
                '{"ExecutionMethod" : "Flow",'+
                '"IsQuote" : false,'+
                '"Inputs": [    { '+
                '"LoyaltyProgramId": "'+ testIdList.programId+ '",'+
                '"MemberId": "'+ testIdList.memberId+ '",'+
                '"PartnerId": "'+ testIdList.partnerId+ '",'+
                '"ProductCategoryId": "'+ testIdList.categoryId+ '",'+
                '"ProductId": "'+ testIdList.productId+ '",'+
                '"ActivityDate": "2020-0-18"}]}';
            Test.startTest();
            testRedemption('https://yourInstance.salesforce.com/services/apexrest/LoyaltySampleAppRedemption', transactionRequestString);
            Test.stopTest();
        }catch (Exception unexpectedException){
            System.assertNotEquals(null, unexpectedException, unexpectedException.getMessage());
        }
    }
    
    static void testRedemption(String requestUri, String transactionRequestString) {
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = requestUri;
        request.httpMethod = 'POST';
        
        request.requestBody = Blob.valueOf(transactionRequestString);

        RestContext.request = request;
        
        // Associate the callout with a multi mock response
        Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
        
        RedemptionRestResource.loyaltySampleAppRedemption();
        
        
    }
    public class MultiRequestMock implements HttpCalloutMock {
        Map<String, HttpCalloutMock> requests;
        
        public MultiRequestMock() {
            requests = new Map<String, HttpCalloutMock>();
            String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
            String tjBulkPostURL = '/services/data/v50.0/composite/sobjects';
            String dTActionURL = '/services/data/v50.0/actions/custom/decisionTableAction/Points_to_Redeem_Based_on_Product_Default';
            String getPointsBalanceActionURL = '/services/data/v50.0/actions/standard/getPointsBalance';
            String debitPointsActionURL = '/services/data/v50.0/actions/standard/debitPoints';
            String jtBulkPostResp = '[{"id" : "0lVRM00000000Yf2AI", "success" : true, "errors" : [ ] }]';
            String dtActionResp = '[{ "actionName":"Points_to_Redeem_Based_on_Product_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "SINGLE MATCH","singleOutcome":{"Points__c":21.0, "attributes":{"type":"RedeemPointsProductCategory__c"}},"outcomeList" : [{"Points__C": 100, "attributes":{"type":"RedeemPointsProductCategory__c"}}]}}]';
            String getPointsBalanceActionResp = '[{ "actionName":"getPointBalanceAction", "errors":null, "isSuccess":true, "outputValues":{ "LoyaltyprogramMemberId":"0lMRM00000028I72AI", "PogramCurrencyName":"points", "ProgramName":"partner extraa program","PointsBalance":500.0}}]';
            String debitPointsActionResp = '[{"actionName":"debitPoints","isSuccess":true,"outputValues":{"JournalId":"0lVRM00000000Yf2AI","PointsBalance":300.0,"ProgramCurrencyName":"points","LoyaltyProgramMemberId":"0lMRM00000028I72AI","ProgramName":"partner extraa program"}}]';
            
            this.requests.put(sfdcURL+tjBulkPostURL,new SingleRequestMock(201,'Complete',jtBulkPostResp,null));

            this.requests.put(sfdcURL+dTActionURL,new SingleRequestMock(200,'Complete',dtActionResp,null));
            this.requests.put(sfdcURL+getPointsBalanceActionURL,new SingleRequestMock(200,'Complete',getPointsBalanceActionResp,null));
            this.requests.put(sfdcURL+debitPointsActionURL,new SingleRequestMock(200,'Complete',debitPointsActionResp,null));
            
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            
            if (mock != null) {
                return mock.respond(req);
            } else {
                throw new CalloutException('HTTP callout not supported for test methods');
            }
        }
        
        public void addRequestMock(String url, HttpCalloutMock mock) {
            requests.put(url, mock);
        }
    }
    
    public class SingleRequestMock implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String bodyAsString;
        protected Map<String, String> responseHeaders;
        
        public SingleRequestMock(Integer code, String status, String body,
                                 Map<String, String> responseHeaders) {
                                     this.code = code;
                                     this.status = status;
                                     this.bodyAsString = body;
                                     this.responseHeaders = responseHeaders;
                                 }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(code);
            resp.setStatus(status);
            resp.setBody(bodyAsString);
            if (responseHeaders != null) {
                for (String key : responseHeaders.keySet()) {
                    resp.setHeader(key, responseHeaders.get(key));
                }
            }
            return resp;
        }
    }
    
}