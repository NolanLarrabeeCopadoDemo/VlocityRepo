@isTest
public class LoyaltyProgramEssentialsDataLoaderTests {
    
    @isTest
    public static void testLoadProgramEssentialsCreateData() {
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData programData = new LoyaltyData();
        programData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramTestData' LIMIT 1].Body.toString().split('\n');
        programData.csvLines.remove(0);
        programData.numberOfFields = programData.csvLines.size();
        dataMap.put('LoyaltyProgram', programData);
        
        LoyaltyData tierGroupData = new LoyaltyData();
        tierGroupData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyTierGroupTestData' LIMIT 1].Body.toString().split('\n');
        tierGroupData.csvLines.remove(0);
        tierGroupData.numberOfFields = tierGroupData.csvLines.size();
        dataMap.put('LoyaltyTierGroup', tierGroupData);
        
        LoyaltyData tierData = new LoyaltyData();
        tierData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyTierTestData' LIMIT 1].Body.toString().split('\n');
        tierData.csvLines.remove(0);
        tierData.numberOfFields = tierData.csvLines.size();
        dataMap.put('LoyaltyTier', tierData);
        
        LoyaltyData currencyData = new LoyaltyData();
        currencyData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramCurrencyTestData' LIMIT 1].Body.toString().split('\n');
        currencyData.csvLines.remove(0);
        currencyData.numberOfFields = currencyData.csvLines.size();
        dataMap.put('LoyaltyProgramCurrency', currencyData);
    
        LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
        lpedl.createData(dataMap);
        
        List<LoyaltyProgram> loyaltyPrograms = [Select Id from LoyaltyProgram];
        System.assertEquals(3, loyaltyPrograms.size());
        
        List<LoyaltyTierGroup> loyaltyTierGroups = [Select Id from LoyaltyTierGroup];
        System.assertEquals(2, loyaltyTierGroups.size());
        
        List<LoyaltyTier> loyaltyTiers = [Select Id from LoyaltyTier];
        System.assertEquals(5, loyaltyTiers.size());
        
        List<LoyaltyProgramCurrency> loyaltyCurrencies = [Select Id from LoyaltyProgramCurrency];
        System.assertEquals(1, loyaltyCurrencies.size());
    }
    
    @isTest
    static void testLoadProgramEssentialsCreateDataWithWrongProgramForCurrency() {
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData currencyData = new LoyaltyData();
        currencyData.csvLines = new String[]{'Test Currency 11,NonQualifying,Fixed,3,Years,None,Active,Program Name Test 1, '};
        currencyData.numberOfFields = currencyData.csvLines.size();
        dataMap.put('LoyaltyProgramCurrency', currencyData);
        
        try {
            LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
	        lpedl.createData(dataMap);
        } catch(ValidationException e) {
            System.assertEquals('No Program found named Program Name Test 1 for currency Test Currency 11', e.getMessage());
        }
    }
    
    @isTest
    static void testLoadProgramEssentialsCreateDataWithWrongTierGroupForTier() {
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData currencyData = new LoyaltyData();
        currencyData.csvLines = new String[]{'Silver,Test Tier Group 1,Program Name Test 1,10, '};
        currencyData.numberOfFields = currencyData.csvLines.size();
        dataMap.put('LoyaltyTier', currencyData);
        
        try {
            LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
	        lpedl.createData(dataMap);
        } catch(ValidationException e) {
            System.assertEquals('No tier group found named Test Tier Group 1 for tier Silver', e.getMessage());
        }
    }
    
    @isTest
    static void testLoadProgramEssentialsCreateDataWithExistingProgram() {
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData programData = new LoyaltyData();
        programData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramTestData' LIMIT 1].Body.toString().split('\n');
        programData.csvLines.remove(0);
        programData.numberOfFields = programData.csvLines.size();
        dataMap.put('LoyaltyProgram', programData);
        
        LoyaltyProgramEssentialsDataLoader lpedlFirst = new LoyaltyProgramEssentialsDataLoader();
        lpedlFirst.createData(dataMap);
        
        dataMap.clear();
        
        LoyaltyData tierGroupData = new LoyaltyData();
        tierGroupData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyTierGroupTestData' LIMIT 1].Body.toString().split('\n');
        tierGroupData.csvLines.remove(0);
        tierGroupData.numberOfFields = tierGroupData.csvLines.size();
        dataMap.put('LoyaltyTierGroup', tierGroupData);
        
        LoyaltyData tierData = new LoyaltyData();
        tierData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyTierTestData' LIMIT 1].Body.toString().split('\n');
        tierData.csvLines.remove(0);
        tierData.numberOfFields = tierData.csvLines.size();
        dataMap.put('LoyaltyTier', tierData);
        
        LoyaltyData currencyData = new LoyaltyData();
        currencyData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramCurrencyTestData' LIMIT 1].Body.toString().split('\n');
        currencyData.csvLines.remove(0);
        currencyData.numberOfFields = currencyData.csvLines.size();
        dataMap.put('LoyaltyProgramCurrency', currencyData);
    
        LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
        lpedl.createData(dataMap);
        
        List<LoyaltyProgram> loyaltyPrograms = [Select Id from LoyaltyProgram];
        System.assertEquals(3, loyaltyPrograms.size());
        
        List<LoyaltyTierGroup> loyaltyTierGroups = [Select Id from LoyaltyTierGroup];
        System.assertEquals(2, loyaltyTierGroups.size());
        
        List<LoyaltyTier> loyaltyTiers = [Select Id from LoyaltyTier];
        System.assertEquals(5, loyaltyTiers.size());
        
        List<LoyaltyProgramCurrency> loyaltyCurrencies = [Select Id from LoyaltyProgramCurrency];
        System.assertEquals(1, loyaltyCurrencies.size());
    }
}