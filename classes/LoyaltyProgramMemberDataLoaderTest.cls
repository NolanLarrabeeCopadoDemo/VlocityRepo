@isTest
public  class LoyaltyProgramMemberDataLoaderTest {
   
        @isTest static void testCreateData(){
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData memberData = new LoyaltyData();
        memberData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramMemberTestData' LIMIT 1].Body.toString().split('\n');
        memberData.csvLines.remove(0);
        memberData.numberOfFields = memberData.csvLines.size();
        dataMap.put('LoyaltyProgramMember', memberData);

        LoyaltyProgramMemberDataLoader lpmd=new LoyaltyProgramMemberDataLoader();
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
        AccountAndContactDataLoader ac=    new AccountAndContactDataLoader();
        lpedl.createData(dataMap);
        lpmd.createData(dataMap, lpedl,ac);
        System.assertEquals(1, [Select Id from LoyaltyProgramMember].size());
    
    }
    
    
    @isTest static void testupdateTierFunction(){
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData memberData = new LoyaltyData();
        memberData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'LoyaltyProgramMemberTierTestData' LIMIT 1].Body.toString().split('\n');
        memberData.csvLines.remove(0);
        memberData.numberOfFields = memberData.csvLines.size();
        dataMap.put('LoyaltyProgramMember', memberData);
        LoyaltyProgramMemberDataLoader lpmd=new LoyaltyProgramMemberDataLoader();
        Map<String,String> memberIds=new Map<String,String>();
        LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
		LoyaltyProgramMember lpm=new LoyaltyProgramMember();
        lpm.MembershipNumber='test1234';
        lpm.MemberStatus='Active';
        lpm.MemberType='Corporate';
        lpm.EnrollmentDate=Date.parse('6/6/2992');
        Account a=new Account(Name='test');
        LoyaltyProgram lp=new LoyaltyProgram(Name='testProgram');
        insert lp;
        insert a;
        lpm.AccountId=a.id;
        lpm.ProgramId=lp.id;
        insert lpm;
        memberIds.put(lpm.MembershipNumber,lpm.Id);
        lpmd.updateTiers(memberIds,memberData.csvLines,lpedl);
        System.assertEquals(1, [Select Id from LoyaltyProgramMember].size());
    }
}