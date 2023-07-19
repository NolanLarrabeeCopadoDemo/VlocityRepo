@isTest
public class JournalTypeSubTypeDataLoaderTests {

    @isTest
    public static void testJournalTypeSubTypeCreateData() {
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
        
        List<JournalType> journalTypes = [Select Id from JournalType];
        System.assertEquals(2, journalTypes.size());
        
        List<JournalSubType> journalSubTypes = [Select Id from JournalSubType];
        System.assertEquals(13, journalSubTypes.size());
    }
    
    @isTest
    static void testJournalTypeSubTypeCreateDataWithExistingJournalType() {
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData journalTypeData = new LoyaltyData();
        journalTypeData.csvLines = new String[] {'Test Data Accrual Exists,Loyalty,Accrual Journal Type Exists'};
        journalTypeData.numberOfFields = journalTypeData.csvLines.size();
        dataMap.put('JournalType', journalTypeData);
        
        JournalTypeSubTypeDataLoader jtdl = new JournalTypeSubTypeDataLoader();
        jtdl.createData(dataMap);
        
        List<JournalType> journalTypes = [Select Id from JournalType];
        System.assertEquals(1, journalTypes.size());
        
        dataMap.clear();
        
        LoyaltyData journalSubTypeData = new LoyaltyData();
        journalSubTypeData.csvLines = new String[] {'Invoice,Test Data Accrual Exists,Invoice', 'Order,Test Data Accrual Exists,Order'};
        journalSubTypeData.numberOfFields = journalSubTypeData.csvLines.size();
        dataMap.put('JournalSubType', journalSubTypeData);
        
        JournalTypeSubTypeDataLoader jstdl = new JournalTypeSubTypeDataLoader();
        jstdl.createData(dataMap);
        
        List<JournalSubType> journalSubTypes = [Select Id from JournalSubType];
        System.assertEquals(2, journalSubTypes.size());
    }
}