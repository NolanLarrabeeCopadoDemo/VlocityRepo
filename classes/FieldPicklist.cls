/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   09-29-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class FieldPicklist extends VisualEditor.DynamicPickList {
    VisualEditor.DesignTimePageContext context;
	VisualEditor.DataRow none;
    
    global FieldPicklist(VisualEditor.DesignTimePageContext context) {
       	this.context = context;
        this.none = new VisualEditor.DataRow('--- None ---', 'NONE');    
    }
    
    global override VisualEditor.DynamicPickListRows getValues() {
       // if(context.pageType != 'RecordPage' || context.entityName == null) {
        //    return new VisualEditor.DynamicPickListRows();
        //}
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		Schema.SObjectType sot = gd.get('Purchase_Order_Lines__c');//context.entityName
        Schema.DescribeSObjectResult describe = sot.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describe.fields.getMap();
        System.debug(' ++++++fieldMap' + fieldMap);
		VisualEditor.DynamicPickListRows  values = new VisualEditor.DynamicPickListRows();		
		values.addRow(this.none);
        
        for(String field: fieldMap.keySet()) {
            String label = fieldMap.get(field).getDescribe().getLabel();
            String properFieldName = fieldMap.get(field).getDescribe().getName(); 
            System.debug(' ++++++label' + label);
            System.debug(' ++++++properFieldName' + properFieldName);
        	VisualEditor.DataRow value = new VisualEditor.DataRow(label, properFieldName);    
            values.addRow(value);
        }        

        return values;
    }

    global override VisualEditor.DataRow getDefaultValue(){
    	return this.none;
    }
}

/*global class FieldPicklist extends VisualEditor.DynamicPickList
{
	VisualEditor.DesignTimePageContext context;
    
	global FieldPicklist(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }
    global override VisualEditor.DataRow getDefaultValue(){
        
        return null;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        String currentPageObjectName = context.entityName;
        String fieldName = 'Industry';
        VisualEditor.DynamicPickListRows  picklistValues = new VisualEditor.DynamicPickListRows();
        Map<String, Schema.SObjectField> currPageObjectfieldsMap = Schema.getGlobalDescribe().get('Month_End_Financials__c').getDescribe().fields.getMap();
        
        for(Schema.SObjectField field : currPageObjectfieldsMap.values())
        {
            Schema.DescribeFieldResult descField = field.getDescribe();
            if(String.ValueOf(descField.type)=='PICKLIST' && descField.getName()==fieldName)
            {
                List<Schema.PicklistEntry> valuesList = new List<Schema.PicklistEntry>();
                valuesList = descField.getPicklistValues();
                
                for(Schema.PicklistEntry value : valuesList)
                {
                    VisualEditor.DataRow dataRow = new VisualEditor.DataRow(value.getLabel(), value.getValue());
                    picklistValues.addRow(dataRow);
                }
                break;
            }
            
        }
        
        return picklistValues;
    }
}*/