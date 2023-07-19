public without sharing class DESZ_FlowCheckName {
    @InvocableMethod
    public static List<String> getAccountIds(List<String> pName) {
        String filter = '%' + pName[0] +'%';
        Integer i = [SELECT count() FROM Milestone1_Project__c where Name like: filter];
        if(i>0){
            String ss= String.valueOf(i);
            pName[0] = pName[0].replace('(','');
            pName[0] = pName[0].replace(')','');
            pName[0]=  pName[0] + ' '+ ss;
            
        }
        
        if(pName[0].Length()> 79){
            pName[0] = pName[0].substring(0, 79);
        }
        
        return pName;
    }
}