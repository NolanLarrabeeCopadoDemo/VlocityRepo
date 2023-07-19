@isTest
public class AccrualApexBatchSchedulerTest {
    
    static String CURRENTCLASSNAME  = AccrualApexBatchSchedulerTest.class.getName();
    static Decimal APIVERSION = [SELECT ApiVersion FROM ApexClass WHERE Name = :CURRENTCLASSNAME WITH SECURITY_ENFORCED Limit 1].ApiVersion;
    static HttpCalloutMock multiCalloutMock = new MultiRequestMock();
    
    @testSetup
    static void loadDefaultTestData() {
		LoyaltyDataLoadControllerTests.testDefaultLoadData();
    }
    
    @isTest
    static void testAccrual(){   
        Integer initialFailedTransactions = getFailedTransactions() ;
              
        Test.startTest();
        // Associate the callout with a multi mock response
        Test.setMock(HttpCalloutMock.class, multiCalloutMock); 
        AccrualApexBatchScheduler accrualApexBatchScheduler = new AccrualApexBatchScheduler();
        accrualApexBatchScheduler.setLoyaltyTestData('Program Name Test 1', 'Test Data Accrual');
        accrualApexBatchScheduler.execute(null);
        Test.stopTest();
        
        /* Test HttpCalloutMock will give No Match for 4 accrual transaction,
         * that transaction journal status will be set to 'Error'
         */
        Integer finalFailedTransactions = getFailedTransactions();
        System.assertEquals(initialFailedTransactions+4, finalFailedTransactions, 'Count of Error Transactions should be 4');
     
    }
    
    static Integer getFailedTransactions(){
        return [SELECT count() from TransactionJournal
                                             WHERE Status='Error' 
                                                   AND JournalType.Name = 'Test Data Accrual'
                                                   AND LoyaltyProgram.Name = 'Program Name Test 1'];
    }
    
    public class MultiRequestMock implements HttpCalloutMock {
        Map<String, HttpCalloutMock> requests;
        
        public MultiRequestMock() {
            requests = new Map<String, HttpCalloutMock>();
            String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
            String dtProductBasedActionURL = '/services/data/v'+ APIVERSION +'/actions/custom/decisionTableAction/Calculate_Points_Awarded_Based_on_Product_and_Tier_Default';
            String dtActivityBasedActionURL = '/services/data/'+ APIVERSION +'/actions/custom/decisionTableAction/Calculate_Points_to_Credit_Based_on_Activity_Default';    
			String creditPointsActionURL = '/services/data/'+ APIVERSION +'/actions/standard/creditPoints';
            
            String dtProductBasedActionResp = '[{ "actionName":"Calculate_Points_Awarded_Based_on_Product_and_Tier_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "SINGLE MATCH","singleOutcome":{"AccruePointsBasedOn__c":"Invoice Price", "Accrued_Points__c":6.0, "attributes":{"type":"AccruePointsProductCategory__c"}},"outcomeList" : [{"AccruePointsBasedOn__c":"Invoice Price", "Accrued_Points__c":6.0, "attributes":{"type":"AccruePointsProductCategory__c"}}]}}, '+
                                               '{ "actionName":"Calculate_Points_Awarded_Based_on_Product_and_Tier_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "NO MATCH","singleOutcome":null,"outcomeList" : null}}]';
            String dtActivityBasedActionResp = '[{ "actionName":"Calculate_Points_to_Credit_Based_on_Activity_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "SINGLE MATCH","singleOutcome":{"PointsAccrued__c":25.0, "attributes":{"type":"LoyaltyActivity__c"}},"outcomeList" : [{"Accrued_Points__c":6.0, "attributes":{"type":"LoyaltyActivity__c"}}]}}, '+
                                                '{ "actionName":"Calculate_Points_to_Credit_Based_on_Activity_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "NO MATCH","singleOutcome":null,"outcomeList" : null}}, ' +
                                                '{ "actionName":"Calculate_Points_to_Credit_Based_on_Activity_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "NO MATCH","singleOutcome":null,"outcomeList" : null}}, ' +
                                                '{ "actionName":"Calculate_Points_to_Credit_Based_on_Activity_Default", "errors":null, "isSuccess":true, "outputValues":{"outcomeType" : "NO MATCH","singleOutcome":null,"outcomeList" : null}}]';
            String creditPointsActionResp = '[{"actionName":"creditPoints", "errors":null, "isSuccess":true,"outputValues":{"JournalId":"0lVRM00000000Yf2AI", "LoyaltyProgramMemberId":"0lMR000000000KTMAY","ProgramCurrencyName":"Points","ProgramName":"partner extraa program"}},' +
                                             '{"actionName":"creditPoints", "errors":null, "isSuccess":true,"outputValues":{"JournalId":"0lVRM00000000Zf2AI", "LoyaltyProgramMemberId":"0lMR000000000KTMAY","ProgramCurrencyName":"Points","ProgramName":"partner extraa program"}}]';
            
            this.requests.put(sfdcURL+dtProductBasedActionURL,new RedemptionRestResourceTest.SingleRequestMock(200,'Complete',dtProductBasedActionResp,null));
            this.requests.put(sfdcURL+dtActivityBasedActionURL,new RedemptionRestResourceTest.SingleRequestMock(200,'Complete',dtActivityBasedActionResp,null));
            this.requests.put(sfdcURL+creditPointsActionURL,new RedemptionRestResourceTest.SingleRequestMock(200,'Complete',creditPointsActionResp,null));
            
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            if (mock != null) {
                return mock.respond(req);
            } else {
                throw new CalloutException('HTTP callout not supported for test methods');
            }
        } 
    }
}