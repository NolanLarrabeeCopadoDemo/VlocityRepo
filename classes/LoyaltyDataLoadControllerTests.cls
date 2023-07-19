@isTest
public class LoyaltyDataLoadControllerTests {

    @isTest
    public static void testDefaultLoadData() {
        Pricebook2 pricebook = new Pricebook2(Name = 'Sample App', Description = 'Sample App', IsActive = true );
        insert pricebook;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
		Update standardPricebook;
        
        LoyaltyProgramMemberDataLoader lpdl = new LoyaltyProgramMemberDataLoader();
        lpdl.check =false;
        LoyaltyDataLoadController ldlc = new LoyaltyDataLoadController();
        ldlc.loadDefaultData('Test');
        
        List<product2> product = [Select Id from product2];
        System.assertEquals(6, product.size());
        
        List<ProductCategory> productCategory = [Select Id from ProductCategory];
        System.assertEquals(10, productCategory.size());
        
        List<LoyaltyProgram> program = [Select Id from LoyaltyProgram];
        System.assertEquals(3, program.size());
        
        List<LoyaltyTierGroup> loyaltyTierGroups = [Select Id from LoyaltyTierGroup];
        System.assertEquals(2, loyaltyTierGroups.size());
        
        List<LoyaltyTier> loyaltyTiers = [Select Id from LoyaltyTier];
        System.assertEquals(5, loyaltyTiers.size());
        
        List<LoyaltyProgramCurrency> loyaltyCurrencies = [Select Id from LoyaltyProgramCurrency];
        System.assertEquals(1, loyaltyCurrencies.size());
        
        List<LoyaltyLedger> ledgers = [Select Id from LoyaltyLedger];
        System.assertEquals(9, ledgers.size());
        
    }
    
    
    @isTest 
    Public static void testRESTCallout(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IssueVoucherRESTCalloutMock());
        IssueVoucherRESTUtil.executeInvocableActionRestAPI('/services/data/v51.0/actions/standard/issueVoucher','{"inputs" : [ {"VoucherCode" : "1020301","ProgramName" : "NTO Insider","VoucherDefinitionName" : "Birthday Discount","EffectiveDate" : "2020-11-26", "LoyaltyProgramMemberId" : "0lMR000000002noMAA","JournalId" : "0lVR000000010umMAA","BenefitId" : "0jiR0000000003HIAQ","AdditionalNotes" : "Birthday Gift"}]}');
        IssueVoucherRESTUtil.sendEmail('Test', true);
        Test.stopTest();
    }
}