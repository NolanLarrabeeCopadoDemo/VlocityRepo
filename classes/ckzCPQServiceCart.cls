global with sharing class ckzCPQServiceCart extends ccrz.ccServiceCart {

    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData)
    {
        inputData = super.getFieldsMap(inputData);

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        
        // CPQ
        objectFields += ',Use_Quote_Overrides__c,Quote_Needed__c';

        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};
    }

}