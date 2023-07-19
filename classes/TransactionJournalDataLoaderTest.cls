@isTest
public class TransactionJournalDataLoaderTest {
    
    @isTest
    public static void testTransactionJournalDataLoader(){
        
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyProgramMember lpm=new LoyaltyProgramMember();
        lpm.MembershipNumber='24345671';
        lpm.MemberStatus='Active';
        lpm.MemberType='Corporate';
        lpm.EnrollmentDate=Date.parse('6/6/2992');
        Account a=new Account(Name='Acme');
        LoyaltyProgram lp=new LoyaltyProgram(Name='Program Name Test 1');
        insert lp;
        insert a;
        lpm.AccountId=a.id;
        lpm.ProgramId=lp.id;
        insert lpm;
        
        ProductDataLoaderTests.testProductDataLoader();
        
        LoyaltyData transactionJournalData = new LoyaltyData();
        transactionJournalData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'TransactionJournalTestData' LIMIT 1].Body.toString().split('\n');
        transactionJournalData.csvLines.remove(0);
        transactionJournalData.numberOfFields = transactionJournalData.csvLines.size();
        dataMap.put('TransactionJournal', transactionJournalData);
        
        
        
        TransactionJournalDataLoader tjdl = new TransactionJournalDataLoader();
        tjdl.createData(dataMap);
        
        List<TransactionJournal> transactionJournal = [Select Id from TransactionJournal];
        
       
        System.assertEquals(7, transactionJournal.size());
        
    }

}