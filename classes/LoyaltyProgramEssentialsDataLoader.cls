/**
 *  Load Data for below Entities
 * 		1. LoyaltyProgram
 * 		2. LoyaltyProgramCurrency
 * 		3. LoyaltyTierGroup
 * 		4. LoyaltyTier
 **/
public inherited sharing class LoyaltyProgramEssentialsDataLoader {
    
    public Map<String, String> programIds = new Map<String, String>();
    public Map<String, String> tierGroupIds = new Map<String, String>();
    public Map<String, String> tierIds = new Map<String, String>();
    public Map<String, String> currencyIds = new Map<String, String>();
    
    public void createData(Map<String, LoyaltyData> dataMap) {
        if(dataMap.get('LoyaltyProgram') != null) {
            createLoyaltyProgramData(dataMap.get('LoyaltyProgram'));
        }

        // fetch programIds in bulk to reduce number of SOQL queries
        Set<String> programNames = new Set<String>();
        if(dataMap.get('LoyaltyTierGroup') != null) {
        	programNames.addAll(LoyaltyDataLoadController.getFieldValues(dataMap.get('LoyaltyTierGroup'), 2));
        }
        if(dataMap.get('LoyaltyTier') != null) {
            programNames.addAll(LoyaltyDataLoadController.getFieldValues(dataMap.get('LoyaltyTier'), 2));
        }
        if(dataMap.get('LoyaltyProgramCurrency') != null) {
        	programNames.addAll(LoyaltyDataLoadController.getFieldValues(dataMap.get('LoyaltyProgramCurrency'), 7));
        }
        
        retrieveProgramIds(programNames);
        
        if(dataMap.get('LoyaltyTierGroup') != null) {
            createLoyaltyTierGroupData(dataMap.get('LoyaltyTierGroup'));
        }
        
        if(dataMap.get('LoyaltyTier') != null) {
            createLoyaltyTierData(dataMap.get('LoyaltyTier'));
        }
        
        if(dataMap.get('LoyaltyProgramCurrency') != null) {
            createLoyaltyProgramCurrencyData(dataMap.get('LoyaltyProgramCurrency'));
        }

    }
    
    public void createLoyaltyProgramData(LoyaltyData programData) {
        List<LoyaltyProgram> loyaltyPrograms = new List<LoyaltyProgram>();
        Integer count = 0;
        for(String csvLine : programData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            LoyaltyProgram loyaltyProgram = new LoyaltyProgram(Name = csvData[0],
                                                               Status = csvData[1],
                                                               Description = csvData[2]);
            loyaltyPrograms.add(loyaltyProgram);
            count++;
            if(count == 200) {
                insert loyaltyPrograms;
                for(LoyaltyProgram lp : loyaltyPrograms) {
                    programIds.put(lp.Name, lp.Id);
                }
                loyaltyPrograms.clear();
                count = 0;
            }
        }
        if(count > 0) {
            insert loyaltyPrograms;
            for(LoyaltyProgram lp : loyaltyPrograms) {
                programIds.put(lp.Name, lp.Id);
            }
        }
    }
    
    public void createLoyaltyProgramCurrencyData(LoyaltyData currencyData) {
        // get tier group for Qualifying currency types
        retrieveProgramAndTierGroupIds(currencyData, 7, 8);
        
        List<LoyaltyProgramCurrency> loyaltyCurrencies = new List<LoyaltyProgramCurrency>();
        Integer count = 0;
        for(String csvLine : currencyData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if( programIds.get(csvData[7]) == null ) {
                throw new ValidationException('No Program found named ' + csvData[7] + ' for currency ' + csvData[0]);
            }

            LoyaltyProgramCurrency loyaltyCurrency = new LoyaltyProgramCurrency(
                                                                                Name = csvData[0],
                                                                                CurrencyType = csvData[1],
                                                                                ExpiryModel = csvData[2],
                                                                                ExpiryPeriodFrequency = Utils.isEmptyOrNull(csvData[3]) ? null : Integer.valueOf(csvData[3]),
                                                                                ExpiryPeriodUnit = csvData[4],
                                                                                ExtendExpiration = csvData[5],
                                                                                IsActive = csvData[6].equals('Active'),
                                                                                LoyaltyProgramId = programIds.get(csvData[7])
                                                                                );
             if( csvData[1] == 'Qualifying' && tierGroupIds.get(loyaltyCurrency.LoyaltyProgramId + '_' + csvData[8]) == null ) {
                throw new ValidationException('No Tier Group found named ' + csvData[8] + ' for currency ' + csvData[0]);
            }
            if (csvData[1] == 'Qualifying') {
                loyaltyCurrency.LoyaltyTierGroupId = tierGroupIds.get(loyaltyCurrency.LoyaltyProgramId + '_' + csvData[8]);
            }
            loyaltyCurrencies.add(loyaltyCurrency);
            count++;
            if( count == 200) {
                insert loyaltyCurrencies;
                for(LoyaltyProgramCurrency lpc : loyaltyCurrencies) {
                    currencyIds.put(lpc.LoyaltyProgramId + '_' + lpc.Name, lpc.Id);
                }
                loyaltyCurrencies.clear();
                count = 0;
            }
        }
        if(count > 0) {
        	insert loyaltyCurrencies;
            for(LoyaltyProgramCurrency lpc : loyaltyCurrencies) {
				currencyIds.put(lpc.LoyaltyProgramId + '_' + lpc.Name, lpc.Id);
            }
        }
    }
    
    public void createLoyaltyTierGroupData(LoyaltyData tierGroupData) {
        List<LoyaltyTierGroup> tierGroups = new List<LoyaltyTierGroup>();
        Integer count = 0;
        for(String csvLine : tierGroupData.csvLines) {
            String[] csvData = csvLine.split(',');
            if( programIds.get(csvData[2]) == null ) {
                throw new ValidationException('No program found named ' + csvData[2] + ' for tier group ' + csvData[0]);
            }
            LoyaltyTierGroup tierGroup = new LoyaltyTierGroup(
            Name = csvData[0],
            TierModel = csvData[1],
            LoyaltyProgramId = programIds.get(csvData[2]),
            TierPeriodUnit = csvData[3],
            TierPeriodQuantity = Utils.isEmptyOrNull(csvData[4]) ? null : Integer.valueOf(csvData[4]),
            QpResetPeriod = csvData[5],
            QpResetFrequency = Utils.isEmptyOrNull(csvData[6]) ? null : Integer.valueOf(csvData[6]),
            QpResetDate = Utils.isEmptyOrNull(csvData[7]) ? null : Date.valueOf(csvData[7]),
            IsActive = csvData[8].equals('Active'),
            ExtendExpiration = csvData[9],
            IsPrimary =  Boolean.valueOf(csvData[10]));
            tierGroups.add(tierGroup);
            count++;
            if( count == 200) {
                insert tierGroups;
                for(LoyaltyTierGroup ltg : tierGroups) {
                    tierGroupIds.put(ltg.LoyaltyProgramId + '_' + ltg.Name, ltg.Id);
                }
                tierGroups.clear();
                count = 0;
            }
        }
        if(count > 0) {
            insert tierGroups;
            for(LoyaltyTierGroup ltg : tierGroups) {
                tierGroupIds.put(ltg.LoyaltyProgramId + '_' + ltg.Name, ltg.Id);
            }
        }
    }
    
    public void createLoyaltyTierData(LoyaltyData tierData) {
        
        // check tier group and program exists
        retrieveProgramAndTierGroupIds(tierData, 2, 1);
        
        List<LoyaltyTier> tiers = new List<LoyaltyTier>();
        Integer count = 0;
        for(String csvLine : tierData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if( tierGroupIds.get(programIds.get(csvData[2]) + '_' + csvData[1]) == null ) {
                throw new ValidationException('No tier group found named ' + csvData[1] + ' for tier ' + csvData[0]);
            }
            LoyaltyTier tier = new LoyaltyTier(
                                                Name = csvData[0],
                                                LoyaltyTierGroupId = tierGroupIds.get(programIds.get(csvData[2]) + '_' + csvData[1]),
                                                SequenceNumber = Integer.valueOf(csvData[3]),
                                                Description = csvData[4]
            								  );
            tiers.add(tier);
            count++;
            if(count == 200) {
                insert tiers;
                for(LoyaltyTier lt : tiers) {
                    tierIds.put(lt.LoyaltyTierGroupId + '_' + lt.Name, lt.Id);
                }
                tiers.clear();
                count = 0;
            }
        }
        if(count > 0) {
            insert tiers;
            for(LoyaltyTier lt : tiers) {
                tierIds.put(lt.LoyaltyTierGroupId + '_' + lt.Name, lt.Id);
            }
        }
    }
    
    public Map<String, String> retrieveProgramIds(Set<String> programNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String programName : programNames) {
            if(programIds.get(programName) == null) {
                namesToQuery.add(programName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            LoyaltyProgram[] lps = [select Id, Name from LoyaltyProgram where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(LoyaltyProgram lp : lps) {
                programIds.put(lp.Name, lp.Id);
            }
        }
        
        return programIds;
    }
    
    public Map<String, String> retrieveTierGroupIds(String programId, Set<String> tierGroupNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String tierGroupName : tierGroupNames) {
            if(tierGroupIds.get(programId + '_' + tierGroupName) == null) {
                namesToQuery.add(tierGroupName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            LoyaltyTierGroup[] ltgs = [select Id, Name from LoyaltyTierGroup where LoyaltyProgramId = :programId and Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(LoyaltyTierGroup ltg : ltgs) {
                tierGroupIds.put(programId + '_' + ltg.Name, ltg.Id);
            }
        }
        
        return tierGroupIds;
    }
    
    public Map<String, String> retrieveTierIds(String loyaltyTierGroupId, Set<String> tierNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String tierName : tierNames) {
            if(tierIds.get(loyaltyTierGroupId + '_' + tierName) == null) {
                namesToQuery.add(tierName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            LoyaltyTier[] lts = [select Id, Name from LoyaltyTier where LoyaltyTierGroupId = :loyaltyTierGroupId and Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(LoyaltyTier lt : lts) {
                tierIds.put(loyaltyTierGroupId + '_' + lt.Name, lt.Id);
            }
        }
        
        return tierIds;
    }
    
    public String getTierId(String tierName, String tierGroupName, String programName) {
        return tierIds.get(tierGroupIds.get(programIds.get(programName) + '_' + tierGroupName) + '_' + tierName);
    }
    
    public void retrieveProgramAndTierGroupIds(LoyaltyData loyaltyData, Integer programIndex, Integer tierGroupIndex) {
        Map<String, Set<String>> tierGroupNames = new Map<String, Set<String>>();
        for(String csvLine : loyaltyData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(csvData.size()>=programIndex+1)
                if(tierGroupNames.get(csvData[programIndex]) == null) {
                    tierGroupNames.put(csvData[programIndex], new Set<String>());
                }
            if(csvData.size()>=tierGroupIndex+1)
              tierGroupNames.get(csvData[programIndex]).add(csvData[tierGroupIndex]);
        }
        
        retrieveProgramIds(tierGroupNames.keySet());
        
        for(String programName : tierGroupNames.keySet()) {
            retrieveTierGroupIds(programIds.get(programName), tierGroupNames.get(programName));
        }
    }
    
    public Map<String, String> retrieveCurrencyIds(String programId, Set<String> currencyNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String currencyName : currencyNames) {
            if(currencyIds.get(programId + '_' + currencyName) == null) {
                namesToQuery.add(currencyName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            LoyaltyProgramCurrency[] lpcs = [select Id, Name from LoyaltyProgramCurrency where LoyaltyProgramId = :programId and Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(LoyaltyProgramCurrency lpc : lpcs) {
                currencyIds.put(programId + '_' + lpc.Name, lpc.Id);
            }
        }
        
        return currencyIds;
    }
}