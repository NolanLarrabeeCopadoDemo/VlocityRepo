public without sharing class CampaignPersonalizationCtrl {
	@AuraEnabled
    public static void savePersonalization(Id campaignId, String Introduction, String Conclusion) {
        Campaign_Message__c c = [SELECT Id, Introduction__c, Conclusion__c FROM Campaign_Message__c WHERE Campaign__c =: campaignId];
        c.Introduction__c = Introduction;
        c.Conclusion__c = Conclusion;
        
        try {
            upsert c;
        }
        catch(DMLException err) {
            System.debug('problem saving intro and conclusion--'+err);
        }
    }
}