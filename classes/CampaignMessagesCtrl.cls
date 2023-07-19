public class CampaignMessagesCtrl {
	@AuraEnabled
    public static Campaign_Message__c  getCampaignMessageDetails(Id recordId) {
        Campaign_Message__c  message = [SELECT Id, Campaign_Message__c, Campaign_Subject__c, Approved_Members__c, Failed_Members__c, Rejected_Members__c    
                                      FROM Campaign_Message__c  
                                      WHERE Campaign__c =: recordId];
        System.debug('message details--'+message);
        return message;
    }
    
    @AuraEnabled
    public static Integer getPendingMembers(Id recordId) {
        AggregateResult pending = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: recordId];
        Integer count =(Integer)pending.get('cnt');
        return count;
    }
}