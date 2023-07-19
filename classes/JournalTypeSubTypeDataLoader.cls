/**
 *  Load Data for below Entities
 * 		1. JournalType
 * 		2. JournalSubType
 * */
public inherited sharing class JournalTypeSubTypeDataLoader {

    public Map<String, String> journalTypeIds = new Map<String, String>();
    public Map<String, String> journalSubTypeIds = new Map<String, String>();
    
    public void  createData(Map<String, LoyaltyData> dataMap){
        if(dataMap.get('JournalType') != null) {
             createJournalType(dataMap.get('JournalType'));
        }
        
        if(dataMap.get('JournalSubType') != null) {
            createJournalSubTypes(dataMap.get('JournalSubType'));
        }
    }
    
    public void createJournalType(LoyaltyData journalTypeData) {
        Set<String> journalTypeNames=LoyaltyDataLoadController.getFieldValues(journalTypeData, 0);
        retrievejournalTypeIds(journalTypeNames);
        List<JournalType> journalTypes = new List<JournalType>();
        Integer count = 0;
        for(String csvLine : journalTypeData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(journalTypeIds.get(csvData[0]) == null) {
                JournalType journalType = new JournalType(Name = csvData[0],
                                                          ProcessType = csvData[1]);
                if(csvData.size()==3)
                journalType.Description = csvData[2];
                journalTypes.add(journalType);
                count++;
                if(count == 200) {
                    insert journalTypes;
                    for(JournalType jt : journalTypes) {
                        journalTypeIds.put(jt.Name, jt.Id);
                    }
                    journalTypes.clear();
                    count = 0;
                }
            }
        }
        if(count > 0) {
            insert journalTypes;
            for(JournalType jt : journalTypes) {
            	journalTypeIds.put(jt.Name, jt.Id);
            }
            journalTypes.clear();
        }
    }
    
    public void createJournalSubTypes(LoyaltyData journalSubTypeData) {
        // check for Journal Types
        Set<String> journalTypeNames = LoyaltyDataLoadController.getFieldValues(journalSubTypeData, 1);
        Set<String> namesToQuery = new Set<String>();
        for(String journalTypeName : journalTypeNames) {
            if(journalTypeIds.get(journalTypeName) == null) {
                namesToQuery.add(journalTypeName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            JournalType[] jts = [select Id, Name from JournalType where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(JournalType jt : jts) {
                journalTypeIds.put(jt.Name, jt.Id);
            }
        }
        Set<String> journalSubTypeNames=LoyaltyDataLoadController.getFieldValues(journalSubTypeData, 0);
        retrievejournalSubTypeIds(journalSubTypeNames);

        
        List<JournalSubType> journalSubTypes = new List<JournalSubType>();
        Integer count = 0;
        for(String csvLine : journalSubTypeData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(journalSubTypeIds.get(csvData[0])==null) {
                if(journalTypeIds.get(csvData[1]) == null) {
                    throw new ValidationException('No Journal Type found named ' + csvData[1] + ' in Journal Sub Type data');
                }
                List<String> ids=new List<String>();
                ids.add(journalTypeIds.get(csvData[1]));
                JournalSubType journalSubType = new JournalSubType(
                                                                    Name = csvData[0],
                                                                    JournalTypeId = ids[0]);
                if(csvData.size()==3)
                journalSubType.Description = csvData[2];
                if(csvData.size()==4)
                journalSubType.RuleType__c = csvData[3];
                journalSubTypes.add(journalSubType);
                count++;
                if(count == 200) {
                    DMLManager.DBInsert(journalSubTypes);
                    for(JournalSubType jst : journalSubTypes) {
                        journalSubTypeIds.put(jst.Name, jst.Id);
                    }
                    journalSubTypes.clear();
                    count = 0;
                }
            }    
        }
        if(count > 0) {
            DmlManager.DBInsert(journalSubTypes);
            for(JournalSubType jst : journalSubTypes) {
            	journalSubTypeIds.put(jst.Name, jst.Id);
            }
        }
    }
    
    public Map<String, String> retrievejournalTypeIds(Set<String> journalTypeNames){
        Set<String> namesToQuery = new Set<String>();
        for(String journalTypeName : journalTypeNames) {
            if(journalTypeIds.get(journalTypeName) == null) {
                namesToQuery.add(journalTypeName);
            }
        }

        if(namesToQuery.size() > 0) {
            JournalType[] journalType = [select Id, Name from JournalType where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(JournalType jt : journalType) {
                journalTypeIds.put(jt.Name, jt.Id);
            }
        }
        
        return journalTypeIds;
    }
    
    public Map<String, String> retrievejournalSubTypeIds(Set<String> journalSubTypeNames){
        Set<String> namesToQuery = new Set<String>();
        for(String journalSubTypeName : journalSubTypeNames) {
            if(journalSubTypeIds.get(journalSubTypeName) == null) {
                namesToQuery.add(journalSubTypeName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            JournalSubType[] jsts = [select Id, Name from JournalSubType where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(JournalSubType jst : jsts) {
                journalSubTypeIds.put(jst.Name, jst.Id);
            }
        }
        
        return journalSubTypeIds;
    }
}