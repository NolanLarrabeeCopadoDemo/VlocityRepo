/**
 * @description       : Controller to fetch the Program Member details based on
 *             Logged In User in the community.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public without sharing class B2BManufacturingPointsController {
    
    /**
    * @description method to Loyalty Program Member Information based on
    * community Logged In user.
    * @return Wrapper with Loyalty Program Member details
    */
  @AuraEnabled(cacheable=true)
    public static MemberProfile getMemberDetails() {
        List<LoyaltyProgramMember> programMembers;
        MemberProfile profileDetails = new MemberProfile();
        
        List<User> users = [SELECT Id, ContactId FROM User
                            WHERE Id = :UserInfo.getUserId()
                            WITH SECURITY_ENFORCED
                            LIMIT 1];

        if (!users.isEmpty() && string.isNotBlank(users[0].ContactId)) {
            List<Contact> Contacts = [SELECT Id, AccountId FROM Contact
                                      WHERE Id = :users[0].ContactId
                                      WITH SECURITY_ENFORCED
                                      LIMIT 1];
            if(!Contacts.isEmpty() && string.isNotBlank(Contacts[0].AccountId)){
                programMembers = [SELECT Id, MembershipNumber FROM LoyaltyProgramMember
                                  WHERE AccountId = :Contacts[0].AccountId
                                  WITH SECURITY_ENFORCED
                                  LIMIT 1];
            }
        }
        
        if (!programMembers.isEmpty()) {
            profileDetails.memberId = programMembers[0].Id;
            profileDetails.membershipNumber = programMembers[0].MembershipNumber;
            
            for (LoyaltyMemberCurrency memberCurrency : [SELECT Name, PointsBalance FROM LoyaltyMemberCurrency
                                                         WHERE LoyaltyMemberId = :programMembers[0].Id
                                                         WITH SECURITY_ENFORCED]) 
            {
                profileDetails.pointBalance = integer.valueOf(memberCurrency.PointsBalance);
            }
            
            for ( LoyaltyMemberTier memberTier :[SELECT Name FROM LoyaltyMemberTier 
                                                 WHERE LoyaltyMemberId = :programMembers[0].Id
                                                 WITH SECURITY_ENFORCED
                                                 LIMIT 1]){
                profileDetails.tier = memberTier.Name;
            }
            
        }
            
        return profileDetails;
    }
}