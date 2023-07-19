/**
 *  Load Data for below Entities
 * 		1. TierAssessmentRule__c
 * 		2. AccruePointsProductCategory__c 
 * 		3. LoyaltyActivity__c
 * 		4. RedeemPointsProductCategory__c
 **/
public inherited sharing class CustomObjectDataLoader {
    
    public void createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramEssentialsDataLoader lpedl, 
                           ProductDataLoader pdl, LoyaltyPartnerDataLoader lpdl, JournalTypeSubTypeDataLoader jtstdl, 
                           AccountAndContactDataLoader accountLoader, VoucherandDefinitionDataLoader vddl) {

        if(dataMap.get('TierAssessmentRule__c') != null) {
            createTierAssessmentRuleData(dataMap.get('TierAssessmentRule__c'));
        }
        
        if(dataMap.get('AccruePointsProductCategory__c') != null) {
            createAccruePointsProductCategoryData(dataMap.get('AccruePointsProductCategory__c'), lpedl, pdl);
        }
        
        if(dataMap.get('LoyaltyActivity__c') != null) {
            createLoyaltyActivityData(dataMap.get('LoyaltyActivity__c'), jtstdl);
        }
        
        if(dataMap.get('RedeemPointsProductCategory__c') != null) {
            createRedeemPointsProductCategoryData(dataMap.get('RedeemPointsProductCategory__c'), lpedl, pdl, lpdl, accountLoader, jtstdl,vddl);
        }
    }
    
    public void createTierAssessmentRuleData(LoyaltyData tierAssessmentRuleData) {
        List<TierAssessmentRule__c> tierAssessmentRules = new List<TierAssessmentRule__c>();
        Integer count = 0;
        for(String csvLine : tierAssessmentRuleData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            TierAssessmentRule__c tierAssessmentRule = new TierAssessmentRule__c(Name = csvData[0],
                                                                                LoyaltyTierName__c = csvData[0],
                                                                                SequenceNumber__c = Utils.isEmptyOrNull(csvData[1]) ? null : Integer.valueOf(csvData[1]),
                                                                                BrandingPercentage__c = Utils.isEmptyOrNull(csvData[2]) ? null : Double.valueOf(csvData[2]),
                                                                                PartnershipYears__c = Utils.isEmptyOrNull(csvData[3]) ? null : Integer.valueOf(csvData[3]),
                                                                                QuarterlyConferenceAttended__c = Utils.isEmptyOrNull(csvData[4]) ? null : Integer.valueOf(csvData[4]),
                                                                                SalesAcrossAllChannel__c = Utils.isEmptyOrNull(csvData[5]) ? null : Double.valueOf(csvData[5]),
                                                                                TeamTrainedPercentage__c = Utils.isEmptyOrNull(csvData[6]) ? null : Double.valueOf(csvData[6]));
            tierAssessmentRules.add(tierAssessmentRule);
            count++;
            if(count == 200) {
                insert tierAssessmentRules;
                tierAssessmentRules.clear();
                count = 0;
            }
        }
        insert tierAssessmentRules;
    }
    
    public void createAccruePointsProductCategoryData(LoyaltyData accrualData, LoyaltyProgramEssentialsDataLoader lpedl, ProductDataLoader pdl) {
        
        // check tier, tier group and program exists
        Map<String, Set<String>> tierGroupNames = new Map<String, Set<String>>();
        Map<String, String> tierGroupProgramMap = new Map<String, String>();
        Map<String, Set<String>> tierNames = new Map<String, Set<String>>();
        Set<String> productNames = new Set<String>();
        for(String csvLine : accrualData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(tierGroupNames.get(csvData[10]) == null) {
                tierGroupNames.put(csvData[10], new Set<String>());
            }
            tierGroupNames.get(csvData[10]).add(csvData[9]);
            
            if(tierNames.get(csvData[9]) == null) {
                tierNames.put(csvData[9], new Set<String>());
            }
            tierNames.get(csvData[9]).add(csvData[8]);
            productNames.add(csvData[2]);
            tierGroupProgramMap.put(csvData[9], csvData[10]);
        }
        
        lpedl.retrieveProgramIds(tierGroupNames.keySet());
        
        for(String programName : tierGroupNames.keySet()) {
            lpedl.retrieveTierGroupIds(lpedl.programIds.get(programName), tierGroupNames.get(programName));
        }
        
        for(String tierGroupName : tierNames.keySet()) {
            lpedl.retrieveTierIds(lpedl.tierGroupIds.get(lpedl.programIds.get(tierGroupProgramMap.get(tierGroupName)) + '_' + tierGroupName), 
                                  tierNames.get(tierGroupName));
        }
        
        // check products exists
        Map<String, String> productIds = pdl.retrieveProductIds(productNames);
        
        List<AccruePointsProductCategory__c> accrualPoints = new List<AccruePointsProductCategory__c>();
        Integer count = 0,rowId=0;
        for(String csvLine : accrualData.csvLines) {
            rowId++;
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(productIds.get(csvData[2]) == null && (csvData[3]==null  || csvData[3].length()==0) ) {
                throw new ValidationException('Product or Product Category must be provided in Accrue Points Product Category Data at Row='+rowId);
            }
            AccruePointsProductCategory__c accrualPoint = new AccruePointsProductCategory__c(
                                                                                            Accrued_Points__c = Utils.isEmptyOrNull(csvData[0]) ? null : Double.valueOf(csvData[0]),
                                                                                            AccruePointsBasedOn__c = csvData[1],
                                                                                            Product__c = productIds.get(csvData[2]),
                                                                                            ProductCategory__c = csvData[3],
                                                                                            MinimumPrice__c = Utils.isEmptyOrNull(csvData[4]) ? null : Double.valueOf(csvData[4]),
                                                                                            MaximumPrice__c = Utils.isEmptyOrNull(csvData[5]) ? null : Double.valueOf(csvData[5]),
                                                                                            MinimumQuantity__c = Utils.isEmptyOrNull(csvData[6]) ? null : Double.valueOf(csvData[6]),
                                                                                            MaximumQuantity__c = Utils.isEmptyOrNull(csvData[7]) ? null : Double.valueOf(csvData[7]),
                                                                                            LoyaltyTier__c = lpedl.getTierId(csvData[8], csvData[9], csvData[10]));
            accrualPoints.add(accrualPoint);
            count++;
            if(count == 200) {
                insert accrualPoints;
                accrualPoints.clear();
                count = 0;
            }
        }
        insert accrualPoints;
    }

    public void createLoyaltyActivityData(LoyaltyData activityData, JournalTypeSubTypeDataLoader jtstdl) {
        Set<String> journalSubTypeNames = LoyaltyDataLoadController.getFieldValues(activityData, 3);
        Map<String, String> journalSubTypeIds = jtstdl.retrievejournalSubTypeIds(journalSubTypeNames);
        List<LoyaltyActivity__c> activities = new List<LoyaltyActivity__c>();
        Integer count = 0,rowId=0;
        for(String csvLine : activityData.csvLines) {
            rowId++;
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(journalSubTypeIds.get(csvData[3]) == null) {
                throw new ValidationException('No Journal Subtype found named ' + csvData[3] + ' for Loyalty Activity ' + csvData[0]);
            }
            
            if(csvData[0].length()==0 && csvData[1].length()==0){
                throw new ValidationException('Activity Name or Categroy must be provided  for Loyalty Activity At Row= ' + rowId);   
            }            
            LoyaltyActivity__c activity = new LoyaltyActivity__c( Name = Utils.isEmptyOrNull(csvData[0])?csvData[1]:csvData[0],
                                                                  ActivityCategory__c = csvData[1],
                                                                  PointsAccrued__c = Utils.isEmptyOrNull(csvData[2]) ? null : Integer.valueOf(csvData[2]),
                												  JournalSubType__c = journalSubTypeIds.get(csvData[3]));
            activities.add(activity);
            count++;
            if(count == 200) {
                insert activities;
                activities.clear();
                count = 0;
            }
        }
        insert activities;
    }
    
    public void createRedeemPointsProductCategoryData(LoyaltyData redemptionData, LoyaltyProgramEssentialsDataLoader lpedl, 
                                                      ProductDataLoader pdl, LoyaltyPartnerDataLoader lpdl, AccountAndContactDataLoader accountLoader,
                                                      JournalTypeSubTypeDataLoader jtstdl, VoucherandDefinitionDataLoader vddl) {
        
        Set<String> productNames = new Set<String>();
		Set<String> accountNames = new Set<String>();
        Set<String> journalSubTypeNames = new Set<String>();  
        Set<String> voucherDefinitionNames = new Set<String>();                                                   
        Map<String, Set<String>> partnerNames = new Map<String, Set<String>>();
        for(String csvLine : redemptionData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            productNames.add(csvData[2]);
            if(partnerNames.get(csvData[5]) == null) {
                partnerNames.put(csvData[5], new Set<String>());
            }
            partnerNames.get(csvData[5]).add(csvData[4]);
            accountNames.add(csvData[4]);
            journalSubTypeNames.add(csvData[6]);
            if(csvData.size() >= 8 ) {
                voucherDefinitionNames.add(csvData[7]);
            }
            
        }
        // Retrieve Voucher Definition data
		Map<String,VoucherDefinition> voucherDefinitionRecordMap = vddl.retrieveVoucherDefinition(voucherDefinitionNames);       
                                                          
        // Retrieve Journal sub type
        Map<String, String> journalSubTypeIds = jtstdl.retrievejournalSubTypeIds(journalSubTypeNames);
        // check products exists
        Map<String, String> productIds = pdl.retrieveProductIds(productNames);
        for(String name : productNames) {
            if(productIds.get(name) == null) {
                throw new ValidationException('No Product with the name ' + name + ' in Redeem Points Product Category Data');
            }
        }
                                                         
		accountLoader.upsertAccounts(accountNames);
        
        // check program partners
        lpedl.retrieveProgramIds(partnerNames.keySet());
        for(String partnerName : partnerNames.keySet()) {
            lpdl.getPartnerIds(lpedl.programIds.get(partnerName), partnerNames.get(partnerName));
        }
		
		List<RedeemPointsProductCategory__c> redeemPointsList = new List<RedeemPointsProductCategory__c>();
		Integer count = 0;
        for(String csvLine : redemptionData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(lpedl.programIds.get(csvData[5]) == null) {
                throw new ValidationException('No Program Name found named ' + csvData[5] + ' in Redeem Points Product Category Data');
            }
            RedeemPointsProductCategory__c redeemPoints = new RedeemPointsProductCategory__c(
                                                                                                Name = csvData[0],
                                                                                                ProductCategory__c = csvData[1],
                                                                                                Product__c = productIds.get(csvData[2]),
                                                                                                Points__c = Utils.isEmptyOrNull(csvData[3]) ? null : Integer.valueOf(csvData[3]),
                                                                                                Partner__c = lpdl.partnerIds.get(lpedl.programIds.get(csvData[5]) + '_' + csvData[4]),
                																				RedemptionType__c = journalSubTypeIds.containsKey(csvData[6]) ? journalSubTypeIds.get(csvData[6]): null,
                																				VoucherDefinitionId__c  = csvData.size() >= 8 && voucherDefinitionRecordMap.containsKey(csvData[7]) ? voucherDefinitionRecordMap.get(csvData[7]).Id : null ,
                																				StartDate__c = csvData.size() >= 9 && !Utils.isEmptyOrNull(csvData[8])? Date.valueOf(csvData[8]): NULL,
                                                                                                EndDate__c = csvData.size() >= 10 && !Utils.isEmptyOrNull(csvData[9]) ? Date.valueOf(csvData[9]):NULL,
                                                                                                Product_Image_Name__c  = csvData.size() >= 11 && !Utils.isEmptyOrNull(csvData[10]) ? String.valueOf(csvData[10]):NULL

            																				);
            redeemPointsList.add(redeemPoints);
            count++;
            if(count == 200) {
                insert redeemPointsList;
                redeemPointsList.clear();
            }
        }
		insert redeemPointsList;
    }

}