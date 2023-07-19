public class CampaignPersonalizationForUserCtrl {
	@AuraEnabled
    public static Campaign_Message__c getEmailInfo(Id campaignId){
        System.debug('campaignId');
        System.debug(campaignId);
        Campaign_Message__c c = [SELECT Id, Introduction__c , Conclusion__c FROM Campaign_Message__c WHERE Campaign__c =: campaignId];
        return c;
    }
}