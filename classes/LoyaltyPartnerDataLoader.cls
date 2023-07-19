/**
 *  Load Data for below Entities
 * 		1. LoyaltyProgramPartner
 * 		2. LoyaltyPartnerProduct
 **/
public inherited sharing class LoyaltyPartnerDataLoader {
    
    public Map<String, String> partnerIds = new Map<String, String>();

    public void createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramEssentialsDataLoader lpedl, 
                           AccountAndContactDataLoader accountContactDataLoader, ProductDataLoader pdl) {
        if(dataMap.get('LoyaltyProgramPartner') != null) {
            createLoyaltyProgramPartnerData(dataMap.get('LoyaltyProgramPartner'), lpedl, accountContactDataLoader, pdl);
        }
    }
    
    public void createLoyaltyProgramPartnerData(LoyaltyData partnerData, LoyaltyProgramEssentialsDataLoader lpedl, AccountAndContactDataLoader accountContactDataLoader, ProductDataLoader pdl) {
        
        Set<String> programNames = new Set<String>();
        Set<String> productAndProductCategoryNames = new Set<String>();
        Set<String> accountNames = new Set<String>();
        for(String csvLine : partnerData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            programNames.add(csvData[2]);
            if(!Utils.isEmptyOrNull(csvData[7])) {
                productAndProductCategoryNames.add(csvData[7]);
            }
            accountNames.add(csvData[3]);
        }
        
        // check program names exists
        Map<String, String> programIds = lpedl.retrieveProgramIds(programNames);
        for(String programName : programNames) {
            if(programIds.get(programName) == null) {
                throw new ValidationException('No Program with the name ' + programName + ' in LoyaltyProgramPartner Data');
            }
        }
        
        // check products exists
        Map<String, String> productIds = pdl.retrieveProductIds(productAndProductCategoryNames);
        Map<String, String> productCategoryIds = pdl.retrieveProductCategoryIds(productAndProductCategoryNames);
        for(String name : productAndProductCategoryNames) {
            if(productIds.get(name) == null && productCategoryIds.get(name) == null) {
                throw new ValidationException('No Product / Product Category with the name ' + name + ' in LoyaltyProgramPartner Data');
            }
        }
        
        // check Accounts
        Map<String, String> accountIds= accountContactDataLoader.upsertAccounts(accountNames);
        
        Map<String, LoyaltyProgramPartner> loyaltyPartners = new Map<String, LoyaltyProgramPartner>();
        List<LoyaltyProgramPartner> partners = new List<LoyaltyProgramPartner>();
        Integer count = 0;
        
        for(String csvLine : partnerData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            LoyaltyProgramPartner loyaltyPartner;
            if(loyaltyPartners.get(csvData[0]) != null) {
                loyaltyPartner = loyaltyPartners.get(csvData[0]);
            } else {
                loyaltyPartner = new LoyaltyProgramPartner(
                                                            Name = csvData[0],
                                                            PartnerType = csvData[1],
                                                            LoyaltyProgramId = programIds.get(csvData[2]),
                                                            LoyaltyPartnerId = accountIds.get(csvData[3]),
                                                            PartnershipStartDate = Utils.isEmptyOrNull(csvData[4]) ? null : Date.valueOf(csvData[4]),
                                                            PartnershipEndDate = Utils.isEmptyOrNull(csvData[5]) ? null : Date.valueOf(csvData[5]),
                                                            PartnerIndustry = csvData[6]);
                loyaltyPartners.put(loyaltyPartner.Name, loyaltyPartner);
                partners.add(loyaltyPartner);
                count++;
            }
            if(count == 200) {
                insert partners;
                for(LoyaltyProgramPartner partner : partners) {
                    partnerIds.put(partner.LoyaltyProgramId + '_' + partner.Name, partner.Id);
                }
                partners.clear();
                count = 0;
            }
            
        }
        if(count > 0) {
            insert partners;
        }
        
		for(LoyaltyProgramPartner partner : partners) {
			partnerIds.put(partner.LoyaltyProgramId + '_' + partner.Name, partner.Id);
		}
        partners.clear();
        
        List<LoyaltyPartnerProduct> products = new List<LoyaltyPartnerProduct>();
        count = 0;
        for(String csvLine : partnerData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(!Utils.isEmptyOrNull(csvData[7])) {
                LoyaltyPartnerProduct partnerProduct = new LoyaltyPartnerProduct();
                LoyaltyProgramPartner loyaltyPartner = loyaltyPartners.get(csvData[0]);
                partnerProduct.Name = csvData[7];
                if (loyaltyPartner.PartnershipStartDate != null) {
                    partnerProduct.StartDate = loyaltyPartner.PartnershipStartDate;
                }
                if (loyaltyPartner.PartnershipEndDate != null) {
                    partnerProduct.EndDate = loyaltyPartner.PartnershipEndDate;
                }
                partnerProduct.LoyaltyPartnerId = loyaltyPartner.Id;
                partnerProduct.ProductId = productIds.get(csvData[7]) != null ? 
                    productIds.get(csvData[7]) : productCategoryIds.get(csvData[7]);
                products.add(partnerProduct);
                count++;
                if(count == 200) {
                    insert products;
                    products.clear();
                    count = 0;
                }
            }
        }
        if(count > 0) {
            insert products;
        }
    }
    
    public Map<String, String> getPartnerIds(String programId, Set<String> partnerNames) {

        Set<String> namesToQuery = new Set<String>();
        for(String partnerName : partnerNames) {
            if(partnerIds.get(programId + '_' + partnerName) == null) {
                namesToQuery.add(partnerName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            LoyaltyProgramPartner[] lpps = [select Id, Name from LoyaltyProgramPartner where LoyaltyProgramId = :programId and Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(LoyaltyProgramPartner lpp : lpps) {
                partnerIds.put(programId + '_' + lpp.Name, lpp.Id);
            }
        }
        return partnerIds;
    }
}