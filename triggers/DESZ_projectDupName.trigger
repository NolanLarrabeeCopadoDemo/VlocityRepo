trigger DESZ_projectDupName on Milestone1_Project__c (before insert,before update) {
    /*if(Trigger.New != Trigger.Old){
        for(Milestone1_Project__c proj : Trigger.new)
        {
            Integer i = [SELECT count() FROM Milestone1_Project__c where Name =: proj.Name];
            if(i>0){
                String ss= String.valueOf(Date.today());
                proj.Name = proj.Name + ss;
                
            }
            
        }
    }*/
}