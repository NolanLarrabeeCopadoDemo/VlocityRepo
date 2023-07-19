/*
* @author Salesforce.com
* @date 2021-02-11
*
* @description: Response for Enrollment API
*/
public without sharing class B2BManufacturingBenefitAndVouchers {
    @AuraEnabled()
    public static List<Voucher> getVouchers() {
        List<LoyaltyProgramMember> programMembers;        
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
        if (programMembers.isEmpty()) {
            return null;
        }   
        List<Voucher> voucherList = [SELECT Id,  VoucherDefinition.NAME,VoucherDefinition.Type, VoucherCode, ExpirationDate FROM Voucher WHERE Status = 'Issued' AND 
                                    LoyaltyProgramMemberId=:programMembers[0].id ORDER BY ExpirationDate DESC];
        return voucherList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<LoyaltyTierBenefit> getBenefits(final String memberId) {
        if(memberId == null) {
            return null;
        }
        
        List<LoyaltyMemberTier> loyaltyMemberTier = [select loyaltytierid from loyaltymembertier where loyaltymemberid=:memberId WITH SECURITY_ENFORCED LIMIT 1];
        if(loyaltyMemberTier == null || loyaltyMemberTier.size() == 0 || loyaltyMemberTier.get(0) == null) { // It should return only one row.
            return null;
        }
        LoyaltyMemberTier memberTier = loyaltyMemberTier.get(0);
        String memberTierId = memberTier.LoyaltyTierId;
            
        List<LoyaltyTierBenefit> loyaltyTierBenefits = [SELECT Benefit.Name FROM LoyaltyTierBenefit Where LoyaltyTier.Id=:memberTierId WITH SECURITY_ENFORCED
                                                        ORDER BY Benefit.Name];
        if(loyaltyTierBenefits == null || loyaltyTierBenefits.size() == 0) {
            return null;
        }

        return loyaltyTierBenefits;
    }
}