@isTest
public class LoyaltyPartnerDataLoaderTests {

    @isTest
    static void testLoadProgramPartnerCreateData() {
        
        // create Partner Industry Picklist values
        
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData programData = new LoyaltyData();
        programData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramTestData' LIMIT 1].Body.toString().split('\n');
        programData.csvLines.remove(0);
        programData.numberOfFields = programData.csvLines.size();
        dataMap.put('LoyaltyProgram', programData);
        
        LoyaltyData partnerData = new LoyaltyData(); 
        partnerData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramPartnerTestData' LIMIT 1].Body.toString().split('\n');
        partnerData.csvLines.remove(0);
        partnerData.numberOfFields = partnerData.csvLines.size();
        dataMap.put('LoyaltyProgramPartner', partnerData);
        
        LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
        lpedl.createData(dataMap);
        AccountAndContactDataLoader lpmdl = new AccountAndContactDataLoader();
        ProductDataLoader pdl = new ProductDataLoader();
        LoyaltyPartnerDataLoader lpdl = new LoyaltyPartnerDataLoader();
        lpdl.createData(dataMap, lpedl, lpmdl, pdl);
        
        List<LoyaltyProgramPartner> programPartners = [Select Id from LoyaltyProgramPartner];
        System.assertEquals(2, programPartners.size());
    }
}