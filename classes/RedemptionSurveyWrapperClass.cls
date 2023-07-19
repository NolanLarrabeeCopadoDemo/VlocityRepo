/**
@author Salesforce.com
@Date 2021
@description SurveyWrapperClass is a wrapper to send related information flow 
*/ 
public class RedemptionSurveyWrapperClass {
    @AuraEnabled
    public string contactId{ get; set; }
    @AuraEnabled
    public string surveyId{ get; set; }
    @AuraEnabled
    public string transactionJournalId{ get; set; } 
    
}