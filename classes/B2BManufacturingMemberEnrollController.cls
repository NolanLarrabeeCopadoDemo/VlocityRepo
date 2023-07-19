/**
 * @description       : Controller to Create the Program Member  based on
 *             Logged In User in the community.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
 * 
**/
public without sharing class B2BManufacturingMemberEnrollController {
   
     /**
    * @description method to Create Loyalty Program Member  based on
    * community Logged In user.
    * @return newly created memberid
    */
    @AuraEnabled
    public static String createProgramMember() { 
        String ContactRecordId = [SELECT Id, ContactId FROM User 
                                  WHERE Id =:UserInfo.getUserId()
                                  WITH SECURITY_ENFORCED LIMIT 1].ContactId ;
        
        Contact contactRecord = [SELECT Id,AccountId,FirstName,LastName,Email,Phone,BirthDate FROM Contact 
                                 WHERE id =:ContactRecordId 
                                 WITH SECURITY_ENFORCED LIMIT 1];
        
        List<LoyaltyProgram> programs = [SELECT Id FROM LoyaltyProgram 
                                         WHERE Name = :Label.LoyaltyProgramName 
                                         WITH SECURITY_ENFORCED LIMIT 1];
        
        List<LoyaltyProgramMember> programMembers = [SELECT Id FROM LoyaltyProgramMember 
                                         WHERE AccountId = :contactRecord.AccountId 
                                         WITH SECURITY_ENFORCED LIMIT 1];  
        
        LoyaltyProgramMember objProgramMember ;
        If(programMembers.isEmpty()){                            
            String programId = programs.isEmpty() ? '' : programs[0].Id;            
            objProgramMember = new LoyaltyProgramMember(
                                ContactId                  = contactRecord.Id,
                                EnrollmentDate             = System.today(),
                                ProgramId                  = programId,
                                MemberStatus               = 'Active',
                                MemberType                 = 'Corporate',
                                MembershipNumber           = Datetime.now().formatGMT('yyyyMMddHHmmss'),
                                AccountId                  = contactRecord.AccountId  
            );
            Insert objProgramMember;
        }
        else{
            objProgramMember = programMembers[0];
        }
        Account acc = new Account(id=contactRecord.AccountId,IsProgramMember__c = true);
        DMLManager.DBUpdate(acc);
        return objProgramMember.id;
    }

}