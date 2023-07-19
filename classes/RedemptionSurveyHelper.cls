/**
@author Salesforce.com
@Date 2021
@description Helper Class to handle the Redemption Survey
*/ 
public class RedemptionSurveyHelper {
	
    public static Map<String,Id> journalTypeIdMap = new Map<String,Id>();
     /**
     * @description sendSurveyInvitation method to send Survey Invitation to customer 
     * @param transactionJournalDataLoader is a collection of Transaction Journal record
     * @return Nothing
    */
    public static void sendSurveyInvitation(List<TransactionJournal> transactionJournalList) {
        
        List<Network> networkList = [SELECT Id FROM Network WHERE Name='Loyalty Management for Manufacturing'  LIMIT 1];
        List<Survey> surveyList = [SELECT Id,Name FROM Survey WHERE Name='Loyalty Redemption Survey' LIMIT 1 ];
        Set<Id> memberIdSet = new Set<Id>();
        Map<Id,Id> programMemberTransactionJournalIdMap = new Map<Id,Id>();
        List<RedemptionSurveyWrapperClass> SurveyWrapperClassList = new List<RedemptionSurveyWrapperClass>();
        Map<Id,LoyaltyProgramMember> loyaltyProgramMemberMap = new Map<Id,LoyaltyProgramMember>();
        List<Contact> contactList = new List<Contact>();
        
		For( TransactionJournal transactionJournal : transactionJournalList ){
    	
            if( transactionJournal.Status == 'Processed' && transactionJournal.JournalTypeId == RedemptionSurveyHelper.getJournalTypeId('Redemption')  ) {
                
                memberIdSet.add(transactionJournal.MemberId);
                programMemberTransactionJournalIdMap.put(transactionJournal.MemberId, transactionJournal.Id);
            }
    	}
        For(LoyaltyProgramMember loyaltyProgramMember : [SELECT Id, Most_Recent_Survey_Email_Date__c , Contact.Name, ContactId from LoyaltyProgramMember WHERE Id IN : memberIdSet ]) {
                
            loyaltyProgramMemberMap.put(loyaltyProgramMember.Id, loyaltyProgramMember);	  
        }
        for( Id memberId : memberIdSet) {
            Boolean createSurveyInvitation = false;
            if(loyaltyProgramMemberMap.containsKey(memberId)  ) {
                if(loyaltyProgramMemberMap.get(memberId).Most_Recent_Survey_Email_Date__c  == NULL ) {
                    createSurveyInvitation = true;
                } else {
                    Integer timeDiffernceIndays = loyaltyProgramMemberMap.get(memberId).Most_Recent_Survey_Email_Date__c.daysBetween(Date.today()) ;
                    if(Integer.valueOf( system.label.Redemption_Survey_Email_frequency_In_Days ) < timeDiffernceIndays ) {
                        createSurveyInvitation = true;
                    }
                }
                if(createSurveyInvitation && loyaltyProgramMemberMap.get(memberId).ContactId != NULL) {
                    
                    RedemptionSurveyWrapperClass surveyWrapperCls = new RedemptionSurveyWrapperClass();
                    surveyWrapperCls.contactId = loyaltyProgramMemberMap.get(memberId).ContactId;
                    if(!Test.isRunningTest()) {
                        surveyWrapperCls.surveyId = surveyList[0].Id;
                    } else {
                        surveyWrapperCls.surveyId= NULL;
                    }
                    surveyWrapperCls.transactionJournalId = programMemberTransactionJournalIdMap.get(memberId);
                    SurveyWrapperClassList.add(surveyWrapperCls);
                }
            }
        }  
        if( SurveyWrapperClassList.size() > 0) {
            Map<String,List<RedemptionSurveyWrapperClass>> flowRecordMap = new Map<String, List<RedemptionSurveyWrapperClass>>();
            flowRecordMap.put('surveyWrapperClassList', SurveyWrapperClassList);
            Flow.Interview.Send_Redemption_Survey_Email  flow1 = new Flow.Interview.Send_Redemption_Survey_Email(flowRecordMap);
            if(!Test.isRunningTest()) {
            	flow1.start();
            }
        }        
    }
       /**
     * @description getJournalTypeId method is to get JournalType Id 
     * @param JournalTypeName is a param for which you want Journal Type Id
     * @return Journal Type Id
    */
    public static String getJournalTypeId(String JournalTypeName) {
       
        if( journalTypeIdMap.isEmpty()) {
        	For( JournalType journalTypeRecord : [SELECT Id,Name FROM JournalType WITH SECURITY_ENFORCED ]) {
                journalTypeIdMap.put(journalTypeRecord.Name, journalTypeRecord.Id);
            } 
            return journalTypeIdMap.containsKey(JournalTypeName)? journalTypeIdMap.get(JournalTypeName) : NULL;
        } else {
            return journalTypeIdMap.containsKey(JournalTypeName)? journalTypeIdMap.get(JournalTypeName) : NULL;
        }
    }
   
}