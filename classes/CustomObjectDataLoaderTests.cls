@isTest
public class CustomObjectDataLoaderTests {

    @isTest
    static void testLoadCustomObjectCreateData() {
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData journalTypeData = new LoyaltyData();
        journalTypeData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'JournalTypeTestData' LIMIT 1].Body.toString().split('\n');
        journalTypeData.csvLines.remove(0);
        journalTypeData.numberOfFields = journalTypeData.csvLines.size();
        dataMap.put('JournalType', journalTypeData);
        
        LoyaltyData journalSubTypeData = new LoyaltyData();
        journalSubTypeData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'JournalSubTypeTestData' LIMIT 1].Body.toString().split('\n');
        journalSubTypeData.csvLines.remove(0);
        journalSubTypeData.numberOfFields = journalSubTypeData.csvLines.size();
        dataMap.put('JournalSubType', journalSubTypeData);
        
        JournalTypeSubTypeDataLoader jtstdl = new JournalTypeSubTypeDataLoader();
        jtstdl.createData(dataMap);

        dataMap.clear();

        LoyaltyData loyaltyActivityData = new LoyaltyData();
        loyaltyActivityData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyActivityTestData' LIMIT 1].Body.toString().split('\n');
        loyaltyActivityData.csvLines.remove(0);
        loyaltyActivityData.numberOfFields = loyaltyActivityData.csvLines.size();
        dataMap.put('LoyaltyActivity__c', loyaltyActivityData);
        
        LoyaltyData tierAssessmentRuleData = new LoyaltyData();
        tierAssessmentRuleData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'TierAssessmentRuleTestData' LIMIT 1].Body.toString().split('\n');
        tierAssessmentRuleData.csvLines.remove(0);
        tierAssessmentRuleData.numberOfFields = tierAssessmentRuleData.csvLines.size();
        dataMap.put('TierAssessmentRule__c', tierAssessmentRuleData);
        
        // test Accrue Points Product Category
        LoyaltyProgramEssentialsDataLoaderTests.testLoadProgramEssentialsCreateData();
        ProductDataLoaderTests.testProductDataLoader();
        
        LoyaltyData accruePointsProductCategoryData = new LoyaltyData();
        accruePointsProductCategoryData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'AccruePointsProductCategoryTestData' LIMIT 1].Body.toString().split('\n');
        accruePointsProductCategoryData.csvLines.remove(0);
        accruePointsProductCategoryData.numberOfFields = accruePointsProductCategoryData.csvLines.size();
        dataMap.put('AccruePointsProductCategory__c', accruePointsProductCategoryData);
        
        LoyaltyData redeemPointsProductCategoryData = new LoyaltyData();
        redeemPointsProductCategoryData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'RedeemPointsProductCategoryTestData' LIMIT 1].Body.toString().split('\n');
        redeemPointsProductCategoryData.csvLines.remove(0);
        redeemPointsProductCategoryData.numberOfFields = redeemPointsProductCategoryData.csvLines.size();
        dataMap.put('RedeemPointsProductCategory__c', redeemPointsProductCategoryData);
        
        
        
        LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
        LoyaltyPartnerDataLoader lpdl = new LoyaltyPartnerDataLoader();
        ProductDataLoader pdl = new ProductDataLoader();
        CustomObjectDataLoader codl = new CustomObjectDataLoader();
        AccountAndContactDataLoader lpmdl = new AccountAndContactDataLoader();
        VoucherandDefinitionDataLoader vddl = new VoucherandDefinitionDataLoader();
        codl.createData(dataMap, lpedl, pdl, lpdl, jtstdl, lpmdl, vddl);
        
        List<LoyaltyActivity__c> activities = [Select Id from LoyaltyActivity__c];
        System.assertEquals(2, activities.size());
        
        List<TierAssessmentRule__c> tierAssessmentRules = [Select Id from TierAssessmentRule__c];
        System.assertEquals(2, tierAssessmentRules.size());
        
        List<AccruePointsProductCategory__c> accruePointsProductCategories = [Select Id from AccruePointsProductCategory__c];
        System.assertEquals(2, accruePointsProductCategories.size());
        
        List<RedeemPointsProductCategory__c> redeemPointsProductCategories = [Select Id from RedeemPointsProductCategory__c];
        System.assertEquals(1, redeemPointsProductCategories.size());
    }
}