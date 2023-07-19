@isTest
public class ctiApexControllerTest {

    @isTest
    static void testCreateCase(){
        
        ctiApexController apexController = new ctiApexController();
        List<RecordType> recordtype = [SELECT Id, DeveloperName FROM RecordType WHERE Name = 'Corporate'];
        Account account = new Account();
        account.Name = 'ABC Corporation';
        Insert account;
       
        Contact contact = new Contact();
        contact.FirstName = 'Demo';
        contact.LastName = 'Contact';
        contact.AccountId = account.Id;
        Insert contact;
        
        LoyaltyProgram loylatyProgram = new LoyaltyProgram();
        loylatyProgram.Name = 'Demo Program';
        Insert loylatyProgram;
        ctiApexController.LoyaltyProgramMemberInfoClass loyaltyProgramClass = new ctiApexController.LoyaltyProgramMemberInfoClass();
        LoyaltyProgramMember loyaltyProgramMember = new LoyaltyProgramMember();
        loyaltyProgramMember.AccountId = account.Id;
        loyaltyProgramMember.MemberStatus = 'Active';
        loyaltyProgramMember.MemberType = 'Corporate';
        loyaltyProgramMember.EnrollmentDate = Date.today();
        loyaltyProgramMember.MembershipNumber = '1000873';
        loyaltyProgramMember.ProgramId = loylatyProgram.Id;
        Insert loyaltyProgramMember;
        
        ctiApexController.getTheContacts('Demo');
        ctiApexController.createMyCase(account.Id);
        ctiApexController.createMyLead('5642876535');
        ctiApexController.createMyTask( contact.Id, 'Order Delivery Issue');
        ctiApexController.getLoyaltyProgramMemberInfo(contact.Id);
        ctiApexController.publishNotifications(new List<String>{'Order Delivery Issue'},contact.Id);
        ctiApexController.getAvailableStatusId();
        ctiApexController.getBusyStatusId();
        ctiApexController.getTheDomainName();
        ctiApexController.getSessionId();
        
        List<Case> caseRecord = [ SELECT Id, AccountId FROM Case WHERE AccountId =: account.Id ];
        system.assertEquals(caseRecord.size(), 1);
        
    }
    
}