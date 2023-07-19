@isTest
public class RedemptionSurveyTestClass {
    
    public static testmethod void testSendSurveyInvitation(){
        
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyProgramMember lpm=new LoyaltyProgramMember();
        lpm.MembershipNumber='24345671';
        lpm.MemberStatus='Active';
        lpm.MemberType='Corporate';
        lpm.EnrollmentDate=Date.parse('6/6/2992');
        Account a=new Account(Name='Acme');
        LoyaltyProgram lp=new LoyaltyProgram(Name='Program Name Test 1');
        Contact con = new Contact(AccountId= a.Id, FirstName='Demo ',LastName='Contact1', Email='test@gmail.com');
        insert lp;
        insert a;
        Insert con;
        lpm.AccountId=a.id;
        lpm.ContactId=con.id;
        lpm.ProgramId=lp.id;
        insert lpm;
        
     
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
        List<JournalType> journalTypeList = new List<JournalType>();
        journalTypeList = [ SELECT Id,Name FROM JournalType WHERE Name = 'Redemption'];

      
        ProductDataLoaderTests.testProductDataLoader();
        
        TransactionJournal[] tj = new TransactionJournal[] {
            new TransactionJournal(Status='Processed',ActivityDate = System.Today(),LoyaltyProgramId =lp.Id,MemberId=lpm.Id,JournalTypeId=getJournalTypeId('Redemption'),PartnerId='0ldJ00000004C9cIAE',JournalDate=system.today(),ProductId='01tJ000000CH7YcIAL'),
            new TransactionJournal(Status='Processed',ActivityDate = System.Today(),LoyaltyProgramId =lp.Id,MemberId=lpm.Id,JournalTypeId=getJournalTypeId('Redemption'),PartnerId='0ldJ00000004C9cIAE',JournalDate=system.today(),ProductId='01tJ000000CE9rzIAD'),
            new TransactionJournal(Status='Processed',ActivityDate = System.Today(),LoyaltyProgramId =lp.Id,MemberId=lpm.Id,JournalTypeId=getJournalTypeId('Redemption'),PartnerId='0ldJ00000004C9cIAE',JournalDate=system.today(),ProductId='01tJ000000CE9s3IAD')
        };
        insert tj;
        
        
        RedemptionSurveyWrapperClass redemptionSurveyWrapper = new RedemptionSurveyWrapperClass();
        TransactionJournalDataLoader tjdl = new TransactionJournalDataLoader();
        tjdl.createData(dataMap);
        
        List<TransactionJournal> transactionJournal = [Select Id from TransactionJournal];
        System.assertEquals(3, transactionJournal.size());
        
      
        
    }
    public static String getJournalTypeId(String JournalTypeName) {
        Map<String,Id> journalTypeIdMap = new  Map<String,Id>();
        if( journalTypeIdMap.isEmpty()) {
            For( JournalType journalTypeRecord : [SELECT Id,Name FROM JournalType]) {
                journalTypeIdMap.put(journalTypeRecord.Name, journalTypeRecord.Id);
            } 
            return journalTypeIdMap.containsKey(JournalTypeName)? journalTypeIdMap.get(JournalTypeName) : NULL;
        } else {
            return journalTypeIdMap.containsKey(JournalTypeName)? journalTypeIdMap.get(JournalTypeName) : NULL;
        }
    }

}