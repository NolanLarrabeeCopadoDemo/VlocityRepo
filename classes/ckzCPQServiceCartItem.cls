global with sharing class ckzCPQServiceCartItem extends ccrz.ccServiceCartItem {
    
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData)
    {
        ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQServiceCartItem', 'begin getFieldsMap');

        inputData = super.getFieldsMap(inputData);

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        
        // CPQ
        objectFields += ',Quote_Line__c,QuotedPrice__c,quotedQty__c';

        ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQServiceCartItem', 'exit getFieldsMap');

        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};
    }

}