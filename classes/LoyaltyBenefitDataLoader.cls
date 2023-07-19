/**

@author Salesforce.com
@Date 2020
@description LoyaltyBenefitDataLoader loads data for LoyaltyBenefit
*/ 

public inherited sharing class LoyaltyBenefitDataLoader {
   Map<String, String> loyaltyBenefitsIds = new Map<String, String>();
   public void createData(Map<String, LoyaltyData> dataMap, LoyaltyBenefitTypeDataLoader loyaltyBenefitTypeDataLoader, LoyaltyProgramEssentialsDataLoader LoyaltyProgramEssentialsDataLoader) {
        if(dataMap.get('LoyaltyBenefit') != null) {
            createLoyaltyBenefit(dataMap.get('LoyaltyBenefit'), loyaltyBenefitTypeDataLoader, LoyaltyProgramEssentialsDataLoader);
        }
    }

    /**
     * @description createLoyaltyBenefit method  to create entity records
     * @param  benefitData is a map which holds entity name and respective content as wrapper
     * @return Nothing
    */    
    private void createLoyaltyBenefit(LoyaltyData benefitData, LoyaltyBenefitTypeDataLoader loyaltyBenefitTypeDataLoader, LoyaltyProgramEssentialsDataLoader LoyaltyProgramEssentialsDataLoader) {
        Set<String> programNames = new Set<String>();
        programNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitData, 0));
        Map<String, String> loyaltyProgramIdByName = LoyaltyProgramEssentialsDataLoader.retrieveProgramIds(programNames);
        
        Set<String> benefitTypeNames = new Set<String>();
        benefitTypeNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitData, 2));
        Map<String, Map<String, String>> loyaltyProgramBenefitTypes = loyaltyBenefitTypeDataLoader.retrieveLoyaltyBenefitTypes(loyaltyProgramIdByName.values(), benefitTypeNames);
        
        Set<String> benefitActions=new Set<String>();
        benefitActions.addAll(LoyaltyDataLoadController.getFieldValues(benefitData, 6));
        Map<String,String>  benefitActionIds=retrieveBenefitAction(benefitActions);
        List<Benefit> benefits = new List<Benefit>();
        for(String csvLine : benefitData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            String loyaltyProgramId = loyaltyProgramIdByName.get(csvData[0]);
            if (loyaltyProgramId == null) {
                throw new ValidationException('No Program found named ' + loyaltyProgramId + ' in Loyalty Benefit Data');
            }
            Map<String, String> benefitTypeNamesIds = loyaltyProgramBenefitTypes.get(loyaltyProgramId);
            if (benefitTypeNamesIds.isEmpty()) {
                throw new ValidationException('No Loyalty Benefit Type found for ' + loyaltyProgramId);
            }
            Integer value = null;
            if(csvData.size() >= 6) {
                value = Utils.isEmptyOrNull(csvData[5]) ? null : Integer.valueOf(csvData[5]);
            }
            String benefitActionId=null;
            if(csvData.size()>=7){
                benefitActionId=benefitActionIds.get(csvData[6]);
            }
            
            Benefit benefit = new Benefit(                  Name=csvData[1],
                                                            BenefitTypeId=benefitTypeNamesIds.get(csvData[2]),
                                                            PrioritySequence=Utils.isEmptyOrNull(csvData[3]) ? null : Integer.valueOf(csvData[3]),
                                                            isActive=Boolean.valueOf(csvData[4]),
                                                            Value=value,
                                          					benefitActionId=benefitActionId);
           
            benefits.add(benefit);        
        }
            DMLManager.DBInsert(benefits);
        
    }

    /**
     * @description retrieveLoyaltyBenefit Method to retrieve Benefit Ids
     * @param  1. benefitTypeIds contains list of benefitType Ids
     *         2. namesToQuery contains set of benefit names 
     * @returns Map of Ids which is mapping of  loyalty benefit name  -> benefit  entitiy id
    */      
    public static Map<String, Map<String, String>> retrieveLoyaltyBenefit(Set<String> benefitTypeIds, Set<String> namesToQuery) {
        Map<String, Map<String, String>> loyaltyBenefits = new Map<String, Map<String, String>>();
        for(Benefit benefit : [SELECT Id, Name,BenefitTypeId FROM Benefit 
                                         WHERE BenefitTypeId  IN :benefitTypeIds AND Name IN :namesToQuery 
                                         WITH SECURITY_ENFORCED]){
            if(loyaltyBenefits.containsKey(benefit.BenefitTypeId)){
                 loyaltyBenefits.get(benefit.BenefitTypeId).put(benefit.Name,benefit.Id);
            }
            else{
                loyaltyBenefits.put(benefit.BenefitTypeId, new Map<String, String>{benefit.Name => benefit.Id});
            }
        }
        return loyaltyBenefits;
    }
    
    /**
     * @description To retrieve Loyalty Benefit records for dependent entities for Voucher
     * @param  1. namesToQuery contains Set of benefit Names
     * @returns Map of Ids which is mapping of  loyalty benefit name  -> benefit  entitiy id
    */  
    public Map<String, String> retrieveLoyaltyBenefit( Set<String> namesToQuery) {
       
        for(Benefit benefit : [SELECT Id, Name FROM Benefit WHERE Name IN :namesToQuery WITH SECURITY_ENFORCED]) {
            loyaltyBenefitsIds.put(benefit.Name, benefit.Id);                  
        }
        return loyaltyBenefitsIds;
    }
    
    public Map<String, String> retrieveBenefitAction( Set<String> namesToQuery) {
        system.debug(namesToQuery);
        Map<String,String>  benefitActionIds=new Map<String,String>();
        for(BenefitAction benefit : [SELECT Id, MasterLabel FROM BenefitAction WHERE MasterLabel IN :namesToQuery WITH SECURITY_ENFORCED]) {
            benefitActionIds.put(benefit.MasterLabel, benefit.Id);                  
        }
        return benefitActionIds;
    }
}