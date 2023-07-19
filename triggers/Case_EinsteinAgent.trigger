trigger Case_EinsteinAgent on Case (before insert, after insert, before update) {
    if(System.isBatch()) return;
    
    if(Trigger.isBefore){ 
        CaseClassificationHelper.helperConfig = [Select Id,Field__c,Comparator__c,Value__c,Confidence__c,
                        Recommendation_Field__c,Recommendation_Value__c,
                        Recommended_Article_Score__c
                        From Einstein_Agent_Helper__c 
                        Where Active__c = true];
        for(Case c: Trigger.New){
            System.debug(c);
            CaseClassificationHelper.createRecommendations(c);
        }
    }
    
    if(Trigger.isAfter){
        for(Case c: Trigger.new){
            if(Trigger.isAfter){
                EinsteinAgentTriggerHelper.createRecommendations(c.Id);
            }
        }
    }
}