/**
@author Salesforce.com
@Date 2020
@description VoucherandDefinitionDataLoader loads data for Voucher & Voucher Defenition
*/ 
public inherited sharing class VoucherandDefinitionDataLoader {
    
    // Variable declaration
    Map<String, String> transactionJournalIds = new Map<String, String>();
    Map<String, VoucherDefinition> voucherDefintionRecordMap = new Map<String, VoucherDefinition>();
    Map<String, String> programMemberIds = new Map<String, String>();
    Map<String, String> contactIds = new Map<String, String>();
    Map<String, String> benefitIds = new Map<String, String>();
    Set<String> partnerNames = new Set<String>();
    Set<String> programNames = new Set<String>();
    List<VoucherDefinition> voucherDefinitionList = new List<VoucherDefinition>();
    
    /**
     * @description createData creates the data for Voucher and Voucher Definition 
     * @param dataMap contains raw data of Voucher & Voucher Definition that needs to be processed
     * @param lpedl It is used to access some methods Program which will help to populate dependent fields 
     * @param loyaltyProgramMemberDataLoader It is used to access some methods of member loaders which will help to populate LoyaltyProgramMember related fields 
     * @param productDataLoader It is used to access some methods of product loaders which will help to populate Product2 related fields 
     * @param   loyaltyBenefitDataLoader It is used to access some methods of Benefit loaders which will help to populate Benefit related fields
     * @param transactionJournalDataLoader It is used to access some methods of Transaction Journal loaders which will help to populate Transaction Journal related fields
     * @return Nothing
    */
    public void  createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramMemberDataLoader loyaltyProgramMemberDataLoader, LoyaltyBenefitDataLoader loyaltyBenefitDataLoader, TransactionJournalDataLoader transactionJournalDataLoader, LoyaltyProgramEssentialsDataLoader loyaltyProgramEssentialsDataLoader, ProductDataLoader productDataLoader,AccountAndContactDataLoader accountContactLoader ){
        
        if(dataMap.get('VoucherDefinition') != null) {
             createVoucherDefinition(dataMap.get('VoucherDefinition'), loyaltyProgramEssentialsDataLoader, loyaltyProgramMemberDataLoader, productDataLoader,accountContactLoader);
        }
        if(dataMap.get('Voucher') != null) {
           createVoucher(dataMap.get('Voucher'), loyaltyProgramMemberDataLoader, transactionJournalDataLoader,loyaltyBenefitDataLoader );
        }
    }
    /**
     * @description createVoucherDefinition method creates Voucher Definition data
     * @param loyaltyProgramMemberDataLoader - It is used to access some methods of member loaders which will help to populate LoyaltyProgramMember related fields 
     * @param loyaltyEssentialsDataLoader - It is used to access some methods Program which will help to populate dependent fields
     * @param productDataLoader - It is used to access some methods of product loaders which will help to populate Product2 related fields  
     * @return Nothing
    */
    public void createVoucherDefinition(LoyaltyData VoucherDefinitionData, LoyaltyProgramEssentialsDataLoader loyaltyProgramEssentialsDataLoader,  LoyaltyProgramMemberDataLoader loyaltyProgramMemberDataLoader, ProductDataLoader productDataLoader ,AccountAndContactDataLoader accountContactLoader) {
        
        Set<String> productAndProductCategoryNames = new Set<String>();
        for(String csvLine : VoucherDefinitionData.csvLines) {
           
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            programNames.add(csvData[3]);
            if(!Utils.isEmptyOrNull(csvData[4]) )
                partnerNames.add(csvData[4]);
            
            if(!Utils.isEmptyOrNull(csvData[5])) 
                productAndProductCategoryNames.add(csvData[5]);
        }
        // Call specific loader to get the reference of parent entities
        Map<String, String> programIds = LoyaltyProgramEssentialsDataLoader.retrieveProgramIds(programNames);
        Map<String, String> productIds = productDataLoader.retrieveProductIds(productAndProductCategoryNames);
        Map<String, String> productCategoryIds = productDataLoader.retrieveProductCategoryIds(productAndProductCategoryNames);
        Map<String, String> partnerIds = accountContactLoader.retrieveAccountIds(partnerNames);
        for(String csvLine : VoucherDefinitionData.csvLines) {
            
            String expirationPeriodUnitValue;
            Integer expirationPeriodValue, discountPercentValue,startingVoucherNumber;
            Double faceValue;
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            String programId = programIds.get(csvData[3]);
            if(programId==null){
                throw new ValidationException('No Program with the name ' + csvData[3] + ' in Voucher Definition Data');
            }
            if(!Utils.isEmptyOrNull(csvData[5]) && productIds.get(csvData[5]) == null && productCategoryIds.get(csvData[5]) == null)      
                throw new ValidationException('No Product / Product Category with the name ' + csvData[5] + ' in Voucher Definition Data');  
            
            if( !Utils.isEmptyOrNull(csvData[8]) && !Utils.isEmptyOrNull(csvData[9]) && Date.valueOf(csvData[8]) > Date.valueOf(csvData[9]) ) {
                throw new ValidationException('Specify an expiration date greater than the effective date in Voucher Definition Name ' + csvData[0] + ' in Voucher Definition Data');
                
            } else if( Utils.isEmptyOrNull(csvData[8])) {
                throw new ValidationException('Effective Date is mandatory field for the Voucher Definition Name ' + csvData[0] + ' in Voucher Definition Data');
            }              
            if( csvData[1] == 'ProductorService' && ( !Utils.isEmptyOrNull(csvData[6]) || !Utils.isEmptyOrNull(csvData[7]))) {
                throw new ValidationException('Discount Percentage and Face Value is not applicable if Type is ProductorService for the Voucher Definition Name ' + csvData[0] + ' in Voucher Definition Data');
            } else if( csvData[1] == 'DiscountPercentage') {
                
                if( !Utils.isEmptyOrNull( csvData[6]) ) {
                    throw new ValidationException('Face Value is not applicable If Type is Discount Percentage for the Voucher Definition Name ' + csvData[0] + ' in Voucher Definition Data');
                } else {
                    discountPercentValue = Integer.valueOf(csvData[7]);
                    faceValue = NULL;
                }
            } else if( csvData[1] == 'FixedValue' ) {
            
                if( !Utils.isEmptyOrNull( csvData[7]) ) {
                    throw new ValidationException('Discount Percentage is not applicable If Type is Fixed Value for the Voucher Definition Name ' + csvData[0] + ' in Voucher Definition Data');
                } else {
                    discountPercentValue = NULL ;
                    faceValue = Double.valueOf(csvData[6]);    
                }
            }
            if( csvData[10] == 'Period' ) {
                if( Utils.isEmptyOrNull(csvData[11]) || Utils.isEmptyOrNull(csvData[12]) ) 
                    throw new ValidationException('Expiration Period Unit and Expiry Period is mandatory if Expiration Type is Period ' + csvData[0] + ' in Voucher Definition Data');
                else {
                    expirationPeriodUnitValue = csvData[12]; 
                    expirationPeriodValue = Integer.valueOf(csvData[11]);
                }
            } else {
                expirationPeriodUnitValue = NULL; 
                expirationPeriodValue = NULL;
            }
            system.debug('::::voucher Definition Name:'+csvData[0]);
            system.debug('::::csvData[14]:'+csvData[14]);
            if( Utils.isEmptyOrNull(csvData[14])  ) {
                    throw new ValidationException('Starting Voucher Number is mandatory field ' + csvData[0] + ' in Voucher Definition Data');
             } else {
                    startingVoucherNumber = Integer.valueOf(csvData[14]);
            }
            VoucherDefinition voucherDefinition = new VoucherDefinition( Name = csvData[0],
                                                                     LoyaltyProgramId  = programId,
                                                                     ProductId = productIds.get( csvData[5]),
                                                                     Type = csvData[1],
                                                                     IsActive = csvData[2] != NULL ? Boolean.valueOf(csvData[2]): NULL,
                                                                     EffectiveDate = Date.valueOf(csvData[8]),
                                                                     ExpirationDate = Utils.isEmptyOrNull(csvData[9])?null:Date.valueOf(csvData[9]),
                                                                     DiscountPercent  = discountPercentValue,
                                                                     FaceValue = faceValue,
                                                                     ExpirationType = csvData[10],
                                                                     ExpirationPeriod  = expirationPeriodValue,
                                                                     ExpirationPeriodUnit = expirationPeriodUnitValue,
                                                                     StartingVoucherNumber__c = startingVoucherNumber,
                                                                     VoucherCodePrefix__c= csvData[15],
                                                                     VoucherCodeSuffix__c=csvData[16]
                                                                     );
            if(String.isNotBlank(csvData[4])){
                 voucherDefinition.PartnerAccountId  = partnerIds.get(csvData[4]);
            }
            if( productIds.get( csvData[5]) != NULL ) {
                voucherDefinition.ProductId = productIds.get( csvData[5]);
            } else {
               voucherDefinition.ProductId = productCategoryIds.get( csvData[5]); 
            }
            voucherDefinitionList.add(voucherDefinition);
        }
        if(voucherDefinitionList.size() > 0) {
            DMLManager.DBInsert(voucherDefinitionList);
            for(VoucherDefinition voucherDefinitionRec : voucherDefinitionList) {
                
                voucherDefintionRecordMap.put(voucherDefinitionRec.Name, voucherDefinitionRec);
            }
            voucherDefinitionList.clear();
        }
    }
    /**
     * @description createVoucher method creates Voucher data
     * @param loyaltyProgramMemberDataLoader - It is used to access some methods of member loaders which will help to populate LoyaltyProgramMember related fields 
     * @param transactionJournalDataLoader - It is used to access some methods Transaction Journal which will help to populate Transaction Journal fields
     * @param loyaltyBenefitDataLoader - It is used to access some methods of Benefit loaders which will help to populate Benefit related fields  
     * @return Nothing
    */
    public void createVoucher(LoyaltyData voucherData, LoyaltyProgramMemberDataLoader loyaltyProgramMemberDataLoader, TransactionJournalDataLoader transactionJournalDataLoader, LoyaltyBenefitDataLoader loyaltyBenefitDataLoader) {
        
        Set<String> vouDefNames = LoyaltyDataLoadController.getFieldValues(voucherData, 3);
        retrieveVoucherDefinition(vouDefNames);
        Set<String> memberIds = LoyaltyDataLoadController.getFieldValues(voucherData, 4);
        programMemberIds = loyaltyProgramMemberDataLoader.retrieveLoyaltyProgramMemberIds( memberIds );
        Set<String> benefitNames = LoyaltyDataLoadController.getFieldValues(voucherData, 8);
        benefitIds = loyaltyBenefitDataLoader.retrieveLoyaltyBenefit( benefitNames );
        //Set<String> contactNames = LoyaltyDataLoadController.getFieldValues(voucherData, 5);
        //contactIds = loyaltyProgramMemberDataLoader.retrievePAContactIds( contactNames );
        Set<String> tranJrlNumbers = LoyaltyDataLoadController.getFieldValues(voucherData, 6);
        transactionJournalIds = transactionJournalDataLoader.retrieveTransactionJournal(tranJrlNumbers);
        // Calling the helper method
        generateJSON(voucherData);
        
    }
    /**
     * @description generateJSON method creates Voucher JSON array data with supported fields
     * Pre-validation handled in this method to avoid run time exception
     * IssueVoucher Invokable action only support maximum 200 records at a time hence, split the records into 200 then make a callout
     * Success or Failure email will be send send to each 200 records 
     * IssueVoucher action either process all or none 
     * @return Nothing
    */
    public void generateJSON(LoyaltyData voucherData ) {
        
        Integer count = 0;
        String CurrentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        Decimal apiVersion = [SELECT ApiVersion FROM ApexClass WHERE Name = :CurrentClassName WITH SECURITY_ENFORCED Limit 1].ApiVersion;
        String ISSUE_VOUCHER_ACTION_URL = '/services/data/v'+apiVersion+'/actions/standard/issueVoucher';
        JSONGenerator jsonGenerator;
        for(String csvLine : voucherData.csvLines) {
        
            if( count == 0 ) {
                jsonGenerator= JSON.createGenerator(true);
                jsonGenerator.writeStartObject();
                jsonGenerator.writeFieldName('inputs');
                jsonGenerator.writeStartArray();  
            }
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            jsonGenerator.writeStartObject();
            if(!Utils.isEmptyOrNull(csvData[0])) {
                jsonGenerator.writeStringField('VoucherCode', csvData[0]);
            } else {
                throw new ValidationException('Voucher code is required for Voucher Data'); 
            }
            system.debug('::csvData[3]::'+csvData[3]);
            system.debug('::voucherDefintionRecordMap[3]::'+voucherDefintionRecordMap);
            if(!Utils.isEmptyOrNull(csvData[3]) && voucherDefintionRecordMap.containsKey(csvData[3])) {
               jsonGenerator.writeStringField('VoucherDefinitionName',csvData[3]);
            } else {
                throw new ValidationException('Valid Voucher Definition Name is required for Voucher Code '+ csvData[0]+' in Voucher Data'); 
           }
            
           if(!Utils.isEmptyOrNull(csvData[1])) {
           
                Date effectiveDate = Date.valueOf( csvData[1]);
                if( voucherDefintionRecordMap.get(csvData[3]).ExpirationType == 'Period' ) {
                    
                    if(voucherDefintionRecordMap.get(csvData[3]).ExpirationPeriodUnit == 'Days') {
                        If( effectiveDate.addDays( voucherDefintionRecordMap.get(csvData[3]).ExpirationPeriod ) >  voucherDefintionRecordMap.get(csvData[3]).ExpirationDate ) 
                            throw new ValidationException('Auto calculated Voucher Expiration Date(VoucherDefinition.Effective date + VoucherDefinition.Expiration period) should be less than Voucher Definition Expiration date for Voucher Code '+ csvData[0]+' in Voucher Data.');                             
                    } else if( voucherDefintionRecordMap.get(csvData[3]).ExpirationPeriodUnit == 'Months') {
                       
                        If( effectiveDate.addMonths( voucherDefintionRecordMap.get(csvData[3]).ExpirationPeriod ) >  voucherDefintionRecordMap.get(csvData[3]).ExpirationDate ) {
                            throw new ValidationException('Auto calculated Voucher Expiration Date(VoucherDefinition.Effective date + VoucherDefinition.Expiration period) should be less than Voucher Definition Expiration date for Voucher Code '+ csvData[0]+' in Voucher Data.');                                 
                        }
                    } 
                } else if( voucherDefintionRecordMap.get(csvData[3]).ExpirationType == 'FixedDate' ) {
                    
                    if( voucherDefintionRecordMap.get(csvData[3]).EffectiveDate >= effectiveDate && voucherDefintionRecordMap.get(csvData[3]).ExpirationDate <= effectiveDate )   
                        throw new ValidationException('Voucher Effective Date should be in between with Voucher Defenition Effective Date and Expiration Date for Voucher Code '+ csvData[0]+' in Voucher Data'); 
                }
            }
            jsonGenerator.writeStringField('EffectiveDate',csvData[1] );
            if(!Utils.isEmptyOrNull(csvData[4]) && !Utils.isEmptyOrNull(csvData[5])){
                throw new ValidationException('Specify either a Loyalty Program Member ID or a Contact Name for Voucher Code '+ csvData[0]+' in Voucher Data');
            }
        
            if(!Utils.isEmptyOrNull(csvData[2])) {
                
                jsonGenerator.writeStringField('ProgramName',csvData[2] );
                if( !Utils.isEmptyOrNull(csvData[4])) 
                    jsonGenerator.writeIdField('LoyaltyProgramMemberId',programMemberIds.get(csvData[4]));
                else 
                    throw new ValidationException('Loyalty Program Member Id is required for Voucher Code '+ csvData[0]+' while Loyalty Program is populated in Voucher Data'); 
            } else {
                
                /*if(!Utils.isEmptyOrNull(csvData[5]) && contactIds.containsKey(csvData[5]) ) 
                    jsonGenerator.writeIdField('ContactId',contactIds.get(csvData[5]));
                else 
                   throw new ValidationException('Contact Name is required for Voucher Code '+ csvData[0]+' in Voucher Data'); 
				*/
            }
            if(!Utils.isEmptyOrNull(csvData[6]) && transactionJournalIds.containsKey(csvData[6]) ) {
                jsonGenerator.writeIdField('JournalId',transactionJournalIds.get(csvData[6]));
            }
            if(!Utils.isEmptyOrNull(csvData[8]) && benefitIds.containsKey(csvData[8]) ) {
                jsonGenerator.writeIdField('BenefitId',benefitIds.get(csvData[8]));
            }
            if(!Utils.isEmptyOrNull(csvData[9])) 
                jsonGenerator.writeStringField('AdditionalNotes',csvData[9]);
            
            jsonGenerator.writeEndObject();
            count++;
            if( count == 200 ) {
                jsonGenerator.writeEndArray();
                jsonGenerator.writeEndObject();
                count = 0;
                // Calling Util class to make callout
                If(!Test.isRunningTest()) {
                    IssueVoucherRESTUtil.executeInvocableActionRestAPI(ISSUE_VOUCHER_ACTION_URL, jsonGenerator.getAsString());   
                }
                
            }
        }
        if( count > 0 ) {
            jsonGenerator.writeEndArray();
            jsonGenerator.writeEndObject();
            // Calling Util class to make callout
            If(!Test.isRunningTest()) {
                IssueVoucherRESTUtil.executeInvocableActionRestAPI(ISSUE_VOUCHER_ACTION_URL, jsonGenerator.getAsString());   
            } 
        }
        
    }
    /**
     * @description retrieveVoucherDefinition method retrives Voucher Definition records
     * @param namesToQuery - It is used to pass Voucher Definition Name which is required to fetch from system
     * @return none
     **/
    public Map<String,VoucherDefinition> retrieveVoucherDefinition( Set<String> namesToQuery) {
       
        for(VoucherDefinition voucherDefinition : [SELECT Id, Name,ExpirationType, ExpirationPeriodUnit,ExpirationPeriod,  EffectiveDate, ExpirationDate FROM VoucherDefinition WHERE Name IN :namesToQuery WITH SECURITY_ENFORCED]) {
           
            if(!voucherDefintionRecordMap.containsKey( voucherDefinition.Name )) {
                voucherDefintionRecordMap.put(voucherDefinition.Name, voucherDefinition);     
            }
        }
        return voucherDefintionRecordMap;
    }
}