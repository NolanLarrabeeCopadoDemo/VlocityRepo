public without sharing class CampaignPendingApprovalsCtrl {
	@AuraEnabled
    public static List<PendingMembers> fetchCampaignMembers(Id campaignId) {
        List<PendingMembers> memberList = new List<PendingMembers>();
        
        //Getting all added leads and adding to member list
        List<CampaignMember> leadList = [SELECT Id, Name, Status, LeadId 
                                     	   FROM CampaignMember 
                                           WHERE CampaignId =: campaignId AND LeadId != null];
        for(CampaignMember l: leadList) {
           PendingMembers plead = new PendingMembers();
           plead.memberId = l.LeadId;
           plead.Name = l.Name;
           plead.Status = l.Status;
           memberList.add(plead);
        }
        
        //Getting all contacts and adding to member List
        List<CampaignMember> contactList = [SELECT Id, Name, Status, ContactId 
                                     	   FROM CampaignMember 
                                           WHERE CampaignId =: campaignId AND ContactId != null];
        for(CampaignMember c: contactList) {
           PendingMembers pcontact = new PendingMembers();
           pcontact.memberId = c.ContactId;
           pcontact.Name = c.Name;
           pcontact.Status = c.Status;
           memberList.add(pcontact);
        }
        
        return memberList;
    }
    
    //getting the number of approved members
    @AuraEnabled
    public static Campaign_Message__c saveApprovedMemberNo(Id campaignId, Integer appnum) {
        Campaign_Message__c c = [SELECT Id,Approved_Members__c FROM Campaign_Message__c WHERE Campaign__c =: campaignId];
        c.Approved_Members__c = Integer.valueOf(appnum);
        System.debug(c);
        try {
            update c;
        }
        catch(DMLException err){
            System.debug('Error Occured--'+err);
        }
        return c;
    }

    //getting the number of rejected members    
    @AuraEnabled
    public static Campaign_Message__c saveRejectedMemberNo(Id campaignId, Integer rejnum) {
        System.debug('rejnum');
        System.debug(rejnum);
        Campaign_Message__c c1 = [SELECT Id,Rejected_Members__c FROM Campaign_Message__c WHERE Campaign__c =: campaignId];
        c1.Rejected_Members__c = Integer.valueOf(rejnum);
        try {
            update c1;
        }
        catch(DMLException err){
            System.debug('Error Occured--'+err);
        }
        return c1;
    }
}