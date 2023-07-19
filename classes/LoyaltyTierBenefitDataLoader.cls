/**

@author Salesforce.com
@Date 2020
@description LoyaltyTierBenefitDataLoader loads data for LoyaltyTierBenefit
*/ 
public inherited sharing class LoyaltyTierBenefitDataLoader {
   public void createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramEssentialsDataLoader LoyaltyProgramEssentialsDataLoader) {
        if(dataMap.get('LoyaltyTierBenefit') != null) {
            createLoyaltyTierBenefit(dataMap.get('LoyaltyTierBenefit'), LoyaltyProgramEssentialsDataLoader);
        }
    }

   /**
     * @description createLoyaltyTierBenefit method enables to call respective method to create entity records
     * @param  benefitTierData is a map which holds entity name and respective content as wrapper
     * @return Nothing
    */
    
    private void createLoyaltyTierBenefit(LoyaltyData benefitTierData, LoyaltyProgramEssentialsDataLoader LoyaltyProgramEssentialsDataLoader) {

        Set<String> programNames = new Set<String>();
        programNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitTierData, 0));
        Map<String, String> loyaltyPrograms = LoyaltyProgramEssentialsDataLoader.retrieveProgramIds(programNames);
        
        Set<String> tierGroupNames = new Set<String>();
        tierGroupNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitTierData, 4));
        Set<String> tierNames = new Set<String>();
        tierNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitTierData, 5));
        
        Map<String, Set<String>> tierGroupTierMap=new Map<String, Set<String>>(); 

        List<LoyaltyTierGroup> loyaltyTierGroups=[SELECT Id, Name,LoyaltyProgramId FROM LoyaltyTierGroup 
                                                  WHERE LoyaltyProgramId IN :loyaltyPrograms.values() 
                                                  AND Name IN :tierGroupNames WITH SECURITY_ENFORCED];
        for(LoyaltyTierGroup tierGroup:loyaltyTierGroups){
            LoyaltyProgramEssentialsDataLoader.tierGroupIds.put(tierGroup.LoyaltyProgramId+'_'+tierGroup.Name,tierGroup.Id);
        }
        List<LoyaltyTier> loyaltyTiers=[SELECT Id,LoyaltyTierGroupId, Name FROM LoyaltyTier 
                                        WHERE LoyaltyTierGroupId IN :LoyaltyProgramEssentialsDataLoader.tierGroupIds.values() 
                                        AND Name IN :tierNames WITH SECURITY_ENFORCED];
        for(LoyaltyTier tier:loyaltyTiers){
            LoyaltyProgramEssentialsDataLoader.tierIds.put(tier.LoyaltyTierGroupId+'_'+tier.Name,tier.Id);
        }  
                
        Set<String> benefitTypeNames = new Set<String>();
        benefitTypeNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitTierData, 1));
        LoyaltyBenefitTypeDataLoader loyaltyBenefitTypeDataLoader = new LoyaltyBenefitTypeDataLoader();
        Map<String, Map<String, String>> loyaltyProgramBenefitTypes = loyaltyBenefitTypeDataLoader.retrieveLoyaltyBenefitTypes(loyaltyPrograms.values(), benefitTypeNames);

        Set<String> benefitTypeIds = new Set<String>();
        for(String programId : loyaltyProgramBenefitTypes.keySet()) {
            Map<String, String> benefitTypes = loyaltyProgramBenefitTypes.get(programId);
            benefitTypeIds.addAll(benefitTypes.values());
        }
        
        Set<String> benefitNames = new Set<String>();
        benefitNames.addAll(LoyaltyDataLoadController.getFieldValues(benefitTierData, 2));
        Map<String, Map<String, String>> loyaltyProgramBenefits = LoyaltyBenefitDataLoader.retrieveLoyaltyBenefit(benefitTypeIds, benefitNames);

        List<LoyaltyTierBenefit> tierBenefits = new List<LoyaltyTierBenefit>();
        for(String csvLine : benefitTierData.csvLines) {
            String[] benefitTier = LoyaltyDataLoadController.splitCsvLine(csvLine);
            String loyaltyProgramId = loyaltyPrograms.get(benefitTier[0]);
            
            if (loyaltyProgramId == null) {
                throw new ValidationException('No Program found named ' + benefitTier[0] + ' in Loyalty Tier Benefit Data');
            }
            
            String loyaltyBenefitTypeId = loyaltyProgramBenefitTypes.get(loyaltyProgramId).get(benefitTier[1]);
            if (loyaltyBenefitTypeId == null) {
                throw new ValidationException('No Loyalty Program Benefit Type found named ' + benefitTier[1] + ' in Loyalty Tier Benefit Data');
            }
            
            String loyaltyBenefitId = loyaltyProgramBenefits.get(loyaltyBenefitTypeId).get(benefitTier[2]);
            if (loyaltyBenefitId == null) {
                throw new ValidationException('No Loyalty Program Benefit found named ' + benefitTier[2] + ' in Loyalty Tier Benefit Data');
            }
            
            String loyaltyTierId = LoyaltyProgramEssentialsDataLoader.tierIds.get(
                				LoyaltyProgramEssentialsDataLoader.tierGroupIds.get(loyaltyProgramId + '_' + benefitTier[4])+ '_' + benefitTier[5]);
            if (loyaltyTierId == null) {
                throw new ValidationException('No Loyalty Tier found named ' + benefitTier[5] + ' in Loyalty Tier Benefit Data');
            }
            LoyaltyTierBenefit tierBenefit = new LoyaltyTierBenefit(Name=benefitTier[3],
                                                                   BenefitId=loyaltyBenefitId,
                                                                   LoyaltyTierId=loyaltyTierId);
            tierBenefits.add(tierBenefit);
        
        }
          
         DMLManager.DBInsert(tierBenefits);    
          
    }
}