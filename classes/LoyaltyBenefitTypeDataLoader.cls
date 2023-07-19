/**

@author Salesforce.com
@Date 2020
@description LoyaltyBenefitTypeDataLoader loads data for LoyaltyBenefitType
*/ 
public inherited sharing class LoyaltyBenefitTypeDataLoader {
    
   	/**
	* @description createData method enables to call respective method to create entity records
	* @param  dataMap is wrapper holding LoyaltyBenefitType Raw Data
	* @return Nothing
	*/
    public void createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramEssentialsDataLoader LoyaltyProgramEssentialsDataLoader) {
        if(dataMap.get('LoyaltyBenefitType') != null) {
            createLoyaltyBenefitType(dataMap.get('LoyaltyBenefitType'), LoyaltyProgramEssentialsDataLoader);
        }
    }  
    
    /**
	* @description createLoyaltyBenefitType method creates BenefitType Data
	* @param  1. dataMap is wrapper holding LoyaltyBenefitType Raw Data
	*         2. LoyaltyProgramEssentialsDataLoader Program Essential Data Loader used to populate program related fields
	* @return Nothing
	*/    
    private void createLoyaltyBenefitType(LoyaltyData benefitData, LoyaltyProgramEssentialsDataLoader LoyaltyProgramEssentialsDataLoader) {
        Set<String> programNames = new Set<String>();
        programNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitData, 2));
        Map<String, String> loyaltyPrograms = LoyaltyProgramEssentialsDataLoader.retrieveProgramIds(programNames);
        List<BenefitType> benefitTypes = new List<BenefitType>();
        for(String csvLine : benefitData.csvLines) {
            String[] benefitTypeData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            String loyaltyProgramId = loyaltyPrograms.get(benefitTypeData[2]);
            if (loyaltyProgramId == null) {
                throw new ValidationException('No Program found named ' + benefitTypeData[2] + ' in Loyalty Benefit Type Data');
            }
            if(benefitTypeData.size()<=4 || Utils.isEmptyOrNull(benefitTypeData[4])==true){
                throw new ValidationException('Process Type Cannot Be Empty in Loyalty Benefit Type Data');
            }
            BenefitType benefitType = new BenefitType(Name=benefitTypeData[0],
                                                      Category=benefitTypeData[1],
                                                      LoyaltyProgramId=loyaltyProgramId,
                                                      Description=benefitTypeData[3],
                                                      ProcessType= benefitTypeData[4] );
            benefitTypes.add(benefitType);
            
        }
        
        DMLManager.DBInsert (benefitTypes);    
        
    }
    
    /**
	* @description retrieveLoyaltyBenefitTypes Method to retrieve BenefitType Ids
	* @param  promotionNames containing list of promotion name
	* @returns Map of Ids which is mapping of  custom id -> entitiy id
	*/     
    public  Map<String, Map<String, String>> retrieveLoyaltyBenefitTypes(List<String> loyaltyProgramIds, Set<String> namesToQuery) {
        Map<String, Map<String, String>> loyaltyBenefitTypes = new Map<String, Map<String, String>>();
        
        for(BenefitType benefitType : [SELECT Id, Name,LoyaltyProgramId FROM BenefitType 
                                       WHERE LoyaltyProgramId in :loyaltyProgramIds AND Name in :namesToQuery 
                                       WITH SECURITY_ENFORCED]  ){
                                           if(loyaltyBenefitTypes.containsKey(benefitType.LoyaltyProgramId)){
                                               loyaltyBenefitTypes.get(benefitType.LoyaltyProgramId).put(benefitType.Name,benefitType.id);
                                           }
                                           else{
                                               loyaltyBenefitTypes.put(benefitType.LoyaltyProgramId, new Map<String, String>{benefitType.Name => benefitType.id});
                                           }
                                       }
        return loyaltyBenefitTypes;
    }
    
}