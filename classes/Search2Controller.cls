public class Search2Controller {

    public static String getSublabelDelimiter() {
        return ' - ';
    }

    public static String comma() {
        return ',';
    }

    public class SearchException extends Exception {}

    @AuraEnabled
    public static List<SearchItem> getItemsFromStrings(List<String> strings) {
        List<SearchItem> options = new List<SearchItem>();
        for (String str : strings) {
            options.add(new SearchItem(str));            
        }
        return options;
    }

    public static boolean doesntEndWith(String initialString, List<String> searchStrings) {
        for (String searchString : searchStrings) {
            if (initialString.endsWithIgnoreCase(searchString)) {
                return false;
            }
        }
        return true;
    }

    @AuraEnabled(cacheable=true)
    public static List<SearchItem> getStandardSearch(String standardSearchName, String objectName/*, List<String> validFieldTypes*/) {
        System.debug('in getStandardSearch, standardSearchName = '+ standardSearchName);
        List<SearchItem> items = new List<SearchItem>();
        if (standardSearchName == 'sobjectList') {
            Map <String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
            List<String> sortedObjects = new List<String>();
            sortedObjects.addAll(objectMap.keySet());
            sortedObjects.sort();
            //for (String objectName : objectMap.keySet()) {
            for (String sortedObjectName : sortedObjects) {
                List<String> ancillaryObjectNames = new List<String>{'share', 'history', 'tag', 'changeevent', 'feed'};
                if (doesntEndWith(sortedObjectName, ancillaryObjectNames)) {
                //if (!sortedObjectName.endsWithIgnoreCase('share') && !sortedObjectName.endsWithIgnoreCase('history') && !sortedObjectName.endsWithIgnoreCase('tag') && !sortedObjectName.endsWithIgnoreCase('changeevent') && !sortedObjectName.endsWithIgnoreCase('feed')) {
                    SearchItem newItem = new SearchItem(objectMap.get(sortedObjectName).getDescribe().getLabel(), objectMap.get(sortedObjectName).getDescribe().getName(), objectMap.get(sortedObjectName).getDescribe().getName());
                    items.add(newItem);
                }
            }
        }
        if (standardSearchName == 'objectFields' && objectName != null) {
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<String> sortedFields = new List<String>();
            sortedFields.addAll(fieldMap.keySet());
            sortedFields.sort();
            
            for (String fieldName : sortedFields) {                
                DescribeFieldResult fieldRes = fieldMap.get(fieldName).getDescribe();
                String t = String.valueOf(fieldRes.getType()).toLowerCase();
                /*
                // Filter by field type, if provided
                if (validFieldTypes != null && validFieldTypes.size() > 0) {
                    boolean isValidFieldType = false;
                    for (String fieldType : validFieldTypes) {
                        if (fieldType.toLowerCase() == t) {
                            isValidFieldType = true;
                            break;
                        }
                    }        
                    if (!isValidFieldType)
                        continue;
                }
                */

                List<SearchItemField> itemFields = new List<SearchItemField>();
                itemFields.add(new SearchItemField('fieldLabel', 'Field Label', fieldRes.getLabel(), 'text', false));
                itemFields.add(new SearchItemField('fieldApiName', 'Field API Name', fieldRes.getName(), 'text', false));
                itemFields.add(new SearchItemField('fieldType', 'Field Type', t, 'text', false));
                //System.debug('itemFields = '+ itemFields);
                SearchItem newItemFromFields = new SearchItem(fieldRes.getName(), itemFields);
                //System.debug('newItemFromFields = '+ newItemFromFields);
                items.add(newItemFromFields);
            }
        }
        System.debug('items = '+items);
        return items;
    }

    // 10/24/2020: thought about breaking up StandardSearch into separate methods
    // but realized that will make it more difficult in builder UI
    /*
    @AuraEnabled
    public static List<SearchItem> getSObjectList() {
        System.debug('in getSObjectList');
        List<SearchItem> items = new List<SearchItem>();
        Map <String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        List<String> sortedObjects = new List<String>();
        sortedObjects.addAll(objectMap.keySet());
        sortedObjects.sort();
        //for (String objectName : objectMap.keySet()) {
        for (String objectName : sortedObjects) {
            if (!objectName.endsWithIgnoreCase('share') && !objectName.endsWithIgnoreCase('history') && !objectName.endsWithIgnoreCase('tag') && !objectName.endsWithIgnoreCase('changeevent') && !objectName.endsWithIgnoreCase('feed')) {
                SearchItem newItem = new SearchItem(objectMap.get(objectName).getDescribe().getLabel(), objectMap.get(objectName).getDescribe().getName(), objectMap.get(objectName).getDescribe().getName());
                items.add(newItem);
            }
        }
        System.debug('items = '+items);
        return items;
    }

    @AuraEnabled
    public static List<SearchItem> getSObjectFields(String objectName) {
        System.debug('in getSObjectList');
        List<SearchItem> items = new List<SearchItem>();
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        List<String> sortedFields = new List<String>();
        sortedFields.addAll(fieldMap.keySet());
        sortedFields.sort();
        
        for (String fieldName : sortedFields) {                
            DescribeFieldResult fieldRes = fieldMap.get(fieldName).getDescribe();
            String t = String.valueOf(fieldRes.getType()).toLowerCase();
            List<SearchItemField> itemFields = new List<SearchItemField>();
            itemFields.add(new SearchItemField('fieldLabel', 'Field Label', fieldRes.getLabel(), 'text', false));
            itemFields.add(new SearchItemField('fieldApiName', 'Field API Name', fieldRes.getName(), 'text', false));
            itemFields.add(new SearchItemField('fieldType', 'Field Type', t, 'text', false));
            SearchItem newItemFromFields = new SearchItem(fieldRes.getName(), itemFields);
            items.add(newItemFromFields);
        }
        return items;
    }
    */




    // Don't overload @AuraEnabled methods: https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.apex
	@AuraEnabled(cacheable=true)
    public static List<SearchItem> getItemsFromSObject(String objectName, List<String> fieldNames, String whereClause, String orderByClause) {
        System.debug('in final call'); //?
        System.debug('fieldNames = '+ fieldNames);
        // Check for valid SObject name
        if (objectName == null || !Schema.getGlobalDescribe().containsKey(objectName)) {
            System.debug('Fatal error: object '+ objectName +' not found');
            throw new SearchException('Fatal error: object '+ objectName +' not found');
        }
        String objectNameField = getSObjectNameField(objectName);
        List<SearchItem> searchItems = new List<SearchItem>();
        // Get all fields for the given object
        Map<String, SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        // Set to store unique values of valid field names
        Set<String> validFieldNames = new Set<String>();
        // Since we need to query Id field regardless, track whether or not the user specificied Id as a field to make visible to end users
        boolean includeIdInLabels = false;
        // Loop through all the user-specified field names, filter out any that aren't valid fields, add the rest to the set
        if (fieldNames != null) {
            for (String fieldName : fieldNames) {
                System.debug('looping through fieldnames');
                System.debug('fieldName = '+ fieldName);
                if (!fieldMap.containsKey(fieldName)) {
                    System.debug('Error: label field '+ fieldName+' does not exist on object '+ objectName);                    
                } else {
                    validFieldNames.add(fieldName);
                }
            }
        }
        // If no valid field names were entered, we rather charitably go ahead and get the object's name field
        if (validFieldNames.isEmpty()) {
            validFieldNames.add(objectNameField);
        }
        // If Id was specified, update includeIdInLabels. If it wasn't, add it to list of fields to query
        if (validFieldNames.contains('Id')) {
            includeIdInLabels = true;
        } else {
            validFieldNames.add('Id');
        }
        System.debug('valid field names: '+ validFieldNames);
        System.debug('includeIdInLabels: '+ includeIdInLabels);
        // Create comma-separated string from the field names and build a query string around it
        String queryFieldsString = String.join(new List<String>(validFieldNames), comma());
        String queryString = 'SELECT '+ queryFieldsString +' FROM '+ objectName;
        // Add 'where' clause if supplied
        if (!String.isBlank(whereClause)) {
            queryString += ' WHERE '+ whereClause;
            System.debug('whereClause = '+ whereClause);
        }
        if (String.isBlank(orderByClause)) {
            orderByClause = objectNameField;            
        }
        queryString += ' ORDER BY '+ orderByClause;
        System.debug('orderByClause = \''+ orderByClause +'\'');
        // Query object records
        System.debug('queryString: '+ queryString);
        //List<SObject> records = Database.query('SELECT '+ queryFieldsString +' FROM '+ objectName);
        List<SObject> records = Database.query(queryString);
        for (SObject record : records) {
            //SearchItem item = new SearchItem(record, new List<String>(validFieldNames), includeIdInLabels);
            //System.debug('Search Item: '+ item.label+', '+item.value+', '+item.sublabel);
            searchItems.add(new SearchItem(record, new List<String>(validFieldNames), includeIdInLabels));
        }
        System.debug('returning searchItems: ' + searchItems);
        //System.debug('searchItems[0]: '+ searchItems[0]);
        return searchItems;
        
    }

    /* commented out on 8/16/2020, I don't know how this was supposed to work without any parameters
    @AuraEnabled
    public static List<SearchItem> getItemsFromObjectList() {
        List<SearchItem> items = new List<SearchItem>();
        Map <String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
        // Sort objects by name
        List<String> objectNames = new List<String>{objectMap.keySet()};
        objectNames.sort();
        for (String objectName : objectNames) {
            if (!objectName.endsWithIgnoreCase('share') && !objectName.endsWithIgnoreCase('history') && !objectName.endsWithIgnoreCase('tag') && !objectName.endsWithIgnoreCase('changeevent') && !objectName.endsWithIgnoreCase('feed')) {
                DescribeSObjectResult objResult = objectMap.get(objectName).getDescribe();
                SearchItem newItem = new SearchItem(objResult.getName(), objResult.getLabel(), objResult.getName(), null);
                items.add(newItem);
            }
        }
        System.debug('items = '+items);
        return items;
    }
    */

    // Given the name of an SObject as a string, returns the string of the API name of the object's Name field
    public static String getSObjectNameField(String sobjName) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if (!gd.containsKey(sobjName)) {
            // Error, object name not found
            throw new SearchException('Fatal error: object '+ sobjName +' not found');
        }
        Map<String, Schema.SObjectField> sobjFields = gd.get(sobjName).getDescribe().fields.getMap();
        // Most objects' name field is simply "Name"
        String n = 'Name';
        if (sobjFields.containsKey(n) && sobjFields.get(n).getDescribe().isNameField())
            return n;
        // If it isn't "Name", search through the rest of the fields to find the name field
        for (Schema.SObjectField sobjField : sobjFields.values()) {
            if (sobjField.getDescribe().isNameField()) {
                return sobjField.getDescribe().getName();
            }
        }
        // Something's gone wrong, there should be a name field
        throw new SearchException('Fatal error: could not find a valid name field for object '+ sobjName);
    }

    public class SearchItem {
        @AuraEnabled public String label;
        @AuraEnabled public String sublabel;
        @AuraEnabled public String value;
        @AuraEnabled public List<SearchItemField> fields;
        //@AuraEnabled public boolean userSpecifiedIdField;

        public SearchItem() {            
        }

        public SearchItem(String itemValue, List<SearchItemField> fields) {
            this.fields = fields;
            value = itemValue;
            label = String.valueOf(fields[0].value);
            List<String> sublabels = new List<String>();
            for (Integer i=1; i<fields.size(); i++) {
                sublabels.add(String.valueOf(fields[i].value));
            }
            sublabel = String.join(sublabels, getSublabelDelimiter());
        }

        public SearchItem(List<SearchItemField> fields) {
            this(String.valueOf(fields[0].value), fields);
        }        

        public SearchItem(String onlyString) {
            label = onlyString;
            value = onlyString;
            fields = new List<SearchItemField>{new SearchItemField(onlyString)};
            //fields.add(new SearchItemField(onlyString));
        }

        public SearchItem(String label, Object value) {
            this(label, value, null);
        }

        public SearchItem(String label, Object value, String sublabel) {
            System.debug('in SearchItem constructor: l:'+ label+', v:'+ value +', s:'+ sublabel);
            this.label = label;
            this.value = String.valueOf(value);
            this.sublabel = sublabel;
            SearchItemField labelField = new SearchItemField(label);
            SearchItemField sublabelField = new SearchItemField(sublabel);
            fields = new List<SearchItemField>{labelField, sublabelField};
            //fields = new List<SearchItemField>{new SearchItemField(label), new SearchItemField(sublabel)};
            System.debug('this: '+ this);
        }

        /*
        public SearchItem(List<Object> fieldValues, Object value) {
            if (fieldValues.size() > 0) {
                value = String.valueOf(value);
                label = String.valueOf(fieldValues.remove(0)); // Return the value of the first field and remove it from the list of fields
                sublabel = String.join(fieldValues, getSublabelDelimiter()); // Get fields[1-n], if present    
                fields = new List<SearchItemField>();
                for (Object fieldValue : fieldValues) {
                    fields.add(new SearchItemField(fieldValue));
                }
            }
        }
        */
        

        public SearchItem(SObject record, List<String> fieldNames, boolean includeIdInLabels) {
            if (record == null || !fieldNames.contains('Id')) {
                return;
            }            
            
            System.debug('creating searchItem - '+ record +', '+ fieldNames);

            // To be able to determine field labels and types
            Map<String, SObjectField> fieldMap = record.getSObjectType().getDescribe().fields.getMap();
            List<Object> labelValues = new List<Object>();
            fields = new List<SearchItemField>();
            for (String fieldName : fieldNames) {
                String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                Object fieldValue = record.get(fieldName);
                String fieldType = getColumnTypeFromEnum(fieldMap.get(fieldName).getDescribe().getType());
                boolean invisibleField = fieldName == 'Id' ? !includeIdInLabels : false;  // Eventually may be more specificity around included as labels, such as fields we just want to query but not display
                SearchItemField newField = new SearchItemField(fieldName, fieldLabel, fieldValue, fieldType, invisibleField);
                fields.add(newField);
                //if (fieldValue != null && (fieldName != 'Id' || includeIdInLabels))
                if (fieldValue != null && !invisibleField)
                    labelValues.add(fieldValue);
            }

            value = String.valueOf(record.get('Id'));
            label = String.valueOf(labelValues.remove(0)); // Return the value of the first field and remove it from the list of fields
            sublabel = String.join(labelValues, getSublabelDelimiter()); // Get fields[1-n], if present
            //userSpecifiedIdField = includeIdInLabels;
        }
    }
    
    public class SearchItemField {
        @AuraEnabled public String fieldName;
        @AuraEnabled public String label;
        @AuraEnabled public Object value;
        @AuraEnabled public String type;
        @AuraEnabled public boolean isIdField;
        @AuraEnabled public boolean invisibleField;
        //@AuraEnabled public boolean hidden;

        public SearchItemField() {            
        }

        public SearchItemField(String str) {
            //System.debug('in searchItemField constructor, str='+ str);
            this(str, (Object) str);
        }

        public SearchItemField(String fieldLabel, Object fieldValue) {            
            this(fieldLabel, fieldValue, 'text');
        }

        public SearchItemField(String fieldLabel, Object fieldValue, String fieldDataType) {
            this(fieldLabel, fieldValue, fieldDataType, false);
        }

        public SearchItemField(String fieldLabel, Object fieldValue, String fieldDataType, boolean invisibleField) {
            this(null, fieldLabel, fieldValue, fieldDataType, invisibleField);            
            //label = fieldLabel;            
            //value = fieldValue;
            //type = fieldDataType;            
            //this.invisibleField = invisibleField;
        }

        public SearchItemField(String fieldApiName, String fieldLabel, Object fieldValue, String fieldDataType, boolean invisibleField) {
            fieldName = fieldApiName;
            label = fieldLabel;            
            value = fieldValue;
            type = fieldDataType;            
            this.invisibleField = invisibleField;
            //this.hidden = hidden;
        }

        /*
        public SearchItemField(String fieldApiName, String fieldLabel, Object fieldValue, String fieldDataType, boolean isIdField, boolean includedInSearch) {
            fieldName = fieldApiName;
            label = fieldLabel;            
            value = fieldValue;
            type = fieldDataType;            
            this.isIdField = isIdField;
            //this.hidden = hidden;
        }
        */

    }

    private static String getColumnTypeFromEnum(Schema.DisplayType typeEnum) {
        String type = typeEnum.name().toLowerCase();
        if (type == 'email' || type == 'percent' || type == 'phone' || type == 'boolean' || type == 'url' || type == 'id') {
            return type;
        }
        if (type == 'integer' || type == 'long' || type == 'double') {
            return 'number';
        }
        if (type == 'date' || type == 'datetime' || type == 'time') {
            return 'date';
        }
        return 'text';
    }

    /* learned that String.join() does this natively
    public static String arrayToString(List<Object> values, String delimiter) {
        if (delimiter == null)
            delimiter = comma();
        String returnString = '';
        for (Object item : values) {
            returnString += (String.isBlank(returnString) ? '' : delimiter) + String.valueOf(item);
        }
        return returnString;
    } */
}