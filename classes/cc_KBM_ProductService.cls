/**
 * Created by BrandonRogers on 1/8/18.
 */

global with sharing class cc_KBM_ProductService extends ccrz.ccServiceProduct{

    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) {
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',KBM_Field_Name__c,KBM_Field_Value__c';

        return new Map<String, Object> {
                ccrz.ccService.OBJECTFIELDS => objectFields
        };
    }
}