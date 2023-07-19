public with sharing class LoyaltyDataLoadController {
    
    public Blob loyaltyProgramBlob{get;set;}
	public Blob loyaltyProgramCurrencyBlob{get;set;}
	public Blob loyaltyTierBlob{get;set;}
	public Blob loyaltyTierGroupBlob{get;set;}
	public Blob loyaltyProgramPartnerBlob{get;set;}
    public Blob loyaltyProgramMemberBlob{get;set;}
    public Blob journalTypeBlob{get;set;}
    public Blob journalSubTypeBlob{get;set;}
    public Blob productBlob{get;set;}
    public Blob productCategoryBlob{get;set;}
    public Blob orderBlob{get;set;}
    public Blob transactionJournalBlob{get;set;}
    public Blob tierAssessmentRuleBlob{get;set;}
    public Blob accruePointsProductCategoryBlob{get;set;}
    public Blob loyaltyActivityBlob{get;set;}
    public Blob redeemPointsProductCategoryBlob{get;set;}
    public Blob loyaltyLedgerBlob{get;set;}
    public Blob loyaltyBenefitTypeBlob{get;set;}
    public Blob loyaltyBenefitBlob{get;set;}
    public Blob loyaltyTierBenefitBlob{get;set;}
    public Blob accountAndContactBlob{get;set;}
    public Blob voucherBlob{get;set;}
    public Blob voucherDefBlob{get;set;}

	public string programFileName{get;set;}
	public string programCurrencyFileName{get;set;}
    public string tierGroupFileName{get;set;}
    public string tierFileName{get;set;}
    public string memberFileName{get;set;}
    public string journalTypeFileName{get;set;}
    public string journalSubTypeFileName{get;set;}
    public string productFileName{get;set;}
    public string loyaltyProgramMemberFileName{get;set;}
    public string productCategoryFileName{get;set;}
    public String orderFileName{get;set;}
    public string transactionJournalFileName{get;set;}  
    public string loyaltyProgramPartnerFileName{get;set;}  
    public String tierAssessmentRuleFileName{get;set;}
    public String accruePointsProductCategoryFileName{get;set;}
    public String loyaltyActivityFileName{get;set;}
    public String redeemPointsProductCategoryFileName{get;set;}
    public String loyaltyLedgerFileName{get;set;}
    public String loyaltyBenefitTypeFileName{get;set;}
    public String loyaltyBenefitFileName{get;set;}
    public String loyaltyTierBenefitFileName{get;set;}
    public String voucherFileName{get;set;}
    public String voucherDefFileName{get;set;}
    public String accountAndContactFileName{get;set;}
    
    Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
    public String docId {get; set;}
    public boolean check {get;set;}
    
    public void loadData() {
        Integer count=0;
        ApexPages.getMessages().clear();
        Savepoint sp = Database.setSavepoint();
        try{
            
            if(accountAndContactBlob!=null){
                dataMap.put('AccountAndContact',createLoyaltyData('AccountAndContact',accountAndContactBlob));
            }
            AccountAndContactDataLoader accountDataLoader=new AccountAndContactDataLoader();
            accountDataLoader.createData(dataMap);
               
             // load CommonData
           if( journalTypeBlob != null) {
                dataMap.put('JournalType', createLoyaltyData('JournalType', journalTypeBlob));
            }
            
            if( journalSubTypeBlob != null) {
                dataMap.put('JournalSubType', createLoyaltyData('JournalSubType', journalSubTypeBlob));
            }
            
            JournalTypeSubTypeDataLoader jtstdl = new JournalTypeSubTypeDataLoader();
            jtstdl.createData(dataMap);
            
            // load Product and ProductCategory
            if( productBlob != null ) {
                dataMap.put('Product2', createLoyaltyData('Product2', productBlob));
            }
            
            if( productCategoryBlob != null ) {
                dataMap.put('ProductCategory', createLoyaltyData('ProductCategory', productCategoryBlob));
            }
            ProductDataLoader pdl = new ProductDataLoader();
            pdl.createData(dataMap);

            // load Loyalty Program Data
            if( loyaltyProgramBlob != null ) {
                dataMap.put('LoyaltyProgram', createLoyaltyData('LoyaltyProgram', loyaltyProgramBlob));
            }
            
            if( loyaltyProgramCurrencyBlob != null ) {
                dataMap.put('LoyaltyProgramCurrency', createLoyaltyData('LoyaltyProgramCurrency', loyaltyProgramCurrencyBlob));
            }
            
            if( loyaltyTierBlob != null ) {
                dataMap.put('LoyaltyTier', createLoyaltyData('LoyaltyTier', loyaltyTierBlob));
            }
            
            if( loyaltyTierGroupBlob != null ) {
                dataMap.put('LoyaltyTierGroup', createLoyaltyData('LoyaltyTierGroup', loyaltyTierGroupBlob));
            }
            
            if( loyaltyProgramPartnerBlob != null ) {
                dataMap.put('LoyaltyProgramPartner', createLoyaltyData('LoyaltyProgramPartner', loyaltyProgramPartnerBlob));
            }
            
            if( loyaltyProgramMemberBlob !=null) {
                dataMap.put('LoyaltyProgramMember',createLoyaltyData('LoyaltyProgramMember',loyaltyProgramMemberBlob));
                loyaltyProgramMemberBlob=null;
            }
            
            LoyaltyProgramEssentialsDataLoader lpedl = new LoyaltyProgramEssentialsDataLoader();
            lpedl.createData(dataMap);
            
            LoyaltyProgramMemberDataLoader lpmdl = new LoyaltyProgramMemberDataLoader();
            lpmdl.check=check;
            lpmdl.createData(dataMap, lpedl,accountDataLoader);
            
            LoyaltyPartnerDataLoader lpdl = new LoyaltyPartnerDataLoader();
            lpdl.createData(dataMap, lpedl, accountDataLoader, pdl);
                        
            //Order Data
            if( orderBlob != null ) {
                dataMap.put('Order', createLoyaltyData('Order', orderBlob));
            }
            OrderDataLoader od = new OrderDataLoader();
            od.createData(dataMap);
            
            // TransactionJournal Data
            if( transactionJournalBlob != null ) {
                dataMap.put('TransactionJournal', createLoyaltyData('TransactionJournal', transactionJournalBlob));
            }
            
            TransactionJournalDataLoader tj = new TransactionJournalDataLoader();
            tj.createData(dataMap);
            
            // LoyaltyLedger Data
            if( loyaltyLedgerBlob != null ) {
                dataMap.put('LoyaltyLedger', createLoyaltyData('LoyaltyLedger', loyaltyLedgerBlob));
            }

            LoyaltyLedgerDataLoader lldl = new LoyaltyLedgerDataLoader();
            lldl.createData(dataMap, lpmdl, lpedl);

            LoyaltyBenefitTypeDataLoader lbtdl = new LoyaltyBenefitTypeDataLoader();
            if( loyaltyBenefitTypeBlob != null ) {
                dataMap.put('LoyaltyBenefitType', createLoyaltyData('LoyaltyBenefitType', loyaltyBenefitTypeBlob));
                lbtdl.createData(dataMap, lpedl);
            }

            LoyaltyBenefitDataLoader lbdl = new LoyaltyBenefitDataLoader();
            if( loyaltyBenefitBlob != null ) {
                dataMap.put('LoyaltyBenefit', createLoyaltyData('LoyaltyBenefit', loyaltyBenefitBlob));
                lbdl.createData(dataMap, lbtdl, lpedl);
            }

            LoyaltyTierBenefitDataLoader ltbdl = new LoyaltyTierBenefitDataLoader();
            if( loyaltyTierBenefitBlob != null ) {
                dataMap.put('LoyaltyTierBenefit', createLoyaltyData('LoyaltyTierBenefit', loyaltyTierBenefitBlob));
                ltbdl.createData(dataMap,  lpedl);
            }
            // Load Voucher Definition and Voucher object Data
			VoucherandDefinitionDataLoader vddl = new VoucherandDefinitionDataLoader();    
            if( voucherDefBlob != NULL) {
                dataMap.put('VoucherDefinition', createLoyaltyData('VoucherDefinition', voucherDefBlob));
            }
            if( voucherBlob != null ) {
                dataMap.put('Voucher', createLoyaltyData('Voucher', voucherBlob));
            }
            vddl.createData(dataMap, lpmdl,lbdl, tj, lpedl,pdl,accountDataLoader);
            
            // load Custom objects data
            if( tierAssessmentRuleBlob != null ) {
                dataMap.put('TierAssessmentRule__c', createLoyaltyData('TierAssessmentRule__c', tierAssessmentRuleBlob));
            }
            
            if( accruePointsProductCategoryBlob != null ) {
                dataMap.put('AccruePointsProductCategory__c', createLoyaltyData('AccruePointsProductCategory__c', accruePointsProductCategoryBlob));
            }
            
            if( loyaltyActivityBlob != null ) {
                dataMap.put('LoyaltyActivity__c', createLoyaltyData('LoyaltyActivity__c', loyaltyActivityBlob));
            }
            
            if( redeemPointsProductCategoryBlob != null ) {
                dataMap.put('RedeemPointsProductCategory__c', createLoyaltyData('RedeemPointsProductCategory__c', redeemPointsProductCategoryBlob));
            }
            
            CustomObjectDataLoader codl = new CustomObjectDataLoader();
            codl.createData(dataMap, lpedl, pdl, lpdl, jtstdl, accountDataLoader,vddl);
            
            RefreshDecisionTable.refreshAllTheDecisionTable();
            
        }
        catch(Exception e){
            System.debug(e.getStackTraceString());
            System.debug(e.getMessage());
            count=1;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
            ApexPages.addMessage(errorMessage);
            Database.rollback(sp);
        } finally {
              dataMap.clear();
              loyaltyProgramBlob=null;
              loyaltyProgramCurrencyBlob=null;
              loyaltyTierBlob=null;
              loyaltyTierGroupBlob=null;
              loyaltyProgramPartnerBlob=null;
              loyaltyProgramMemberBlob=null;
              journalTypeBlob=null;
              journalSubTypeBlob=null;
              productBlob=null;
              productCategoryBlob=null;
              orderBlob=null;
              transactionJournalBlob=null;
              tierAssessmentRuleBlob=null;
              accruePointsProductCategoryBlob=null;
              loyaltyActivityBlob=null;
              redeemPointsProductCategoryBlob=null;
              loyaltyLedgerBlob=null;
              loyaltyBenefitTypeBlob=null;
              loyaltyBenefitBlob=null;
              loyaltyTierBenefitBlob=null;
              check=false;
        }
        if(count==0) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.INFO,'Successfully Uploaded Csv');
            ApexPages.addMessage(errorMessage);            
        }
    }
    
    public void loadDefaultDataFromUI(){
        check=true;
        loadDefaultData('');
    }
    
    public void loadDefaultData(String executionMode) {

        if('Test'.equals(executionMode)) {
            String JournalTypeData = 'JournalType' + executionMode + 'Data';
            StaticResource jtsr = [SELECT Id, Body FROM StaticResource WHERE Name = :JournalTypeData WITH SECURITY_ENFORCED];
            journalTypeBlob = jtsr.Body;
        } else {
            executionMode = '';
        }
        
        String AccountContactData = 'AccountAndContact'+executionMode+ 'Data';
        StaticResource accountContact=[Select Id,Body From StaticResource WHERE Name= :AccountContactData WITH SECURITY_ENFORCED];
        accountAndContactBlob=accountContact.Body;
        
        String JournalSubTypeData = 'JournalSubType' + executionMode + 'Data';
        StaticResource jstsr = [SELECT Id, Body FROM StaticResource WHERE Name = :JournalSubTypeData WITH SECURITY_ENFORCED];
		journalSubTypeBlob = jstsr.Body;
        
        String Product2Data = 'Product2' + executionMode + 'Data';
        StaticResource prsr = [SELECT Id, Body FROM StaticResource WHERE Name = :Product2Data WITH SECURITY_ENFORCED];
		productBlob = prsr.Body;
        
        String ProductCategoryData = 'ProductCategory' + executionMode + 'Data';
        StaticResource pcsr = [SELECT Id, Body FROM StaticResource WHERE Name = :ProductCategoryData WITH SECURITY_ENFORCED];
		productCategoryBlob = pcsr.Body;
        
        
        String LoyaltyProgramData = 'LoyaltyProgram' + executionMode + 'Data';
        StaticResource lpdSr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyProgramData WITH SECURITY_ENFORCED];
		loyaltyProgramBlob = lpdSr.Body;

        String LoyaltyProgramCurrencyData = 'LoyaltyProgramCurrency' + executionMode + 'Data';
        StaticResource lpcsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyProgramCurrencyData WITH SECURITY_ENFORCED];
		loyaltyProgramCurrencyBlob = lpcsr.Body;
        
        String LoyaltyTierData = 'LoyaltyTier' + executionMode + 'Data';
        StaticResource ltsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyTierData  WITH SECURITY_ENFORCED];
		loyaltyTierBlob = ltsr.Body;
        
        String LoyaltyTierGroupData = 'LoyaltyTierGroup' + executionMode + 'Data';
        StaticResource ltgsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyTierGroupData  WITH SECURITY_ENFORCED];
		loyaltyTierGroupBlob = ltgsr.Body;

        String LoyaltyProgramPartnerData = 'LoyaltyProgramPartner' + executionMode + 'Data';
        StaticResource lppsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyProgramPartnerData WITH SECURITY_ENFORCED];
		loyaltyProgramPartnerBlob = lppsr.Body;
        
        String LoyaltyProgramMemberData = 'LoyaltyProgramMember' + executionMode + 'Data';
        StaticResource lpmsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyProgramMemberData WITH SECURITY_ENFORCED];
		loyaltyProgramMemberBlob = lpmsr.Body;
        
        String OrderData = 'Order' + executionMode + 'Data';
        StaticResource ordersr = [SELECT Id, Body FROM StaticResource WHERE Name = :OrderData WITH SECURITY_ENFORCED];
		orderBlob = ordersr.Body;
        
        
		String TierAssessmentRuleData = 'TierAssessmentRule' + executionMode + 'Data';
        StaticResource tarsr = [SELECT Id, Body FROM StaticResource WHERE Name = :TierAssessmentRuleData WITH SECURITY_ENFORCED];
		tierAssessmentRuleBlob = tarsr.Body;
        
        String AccruePointsProductCategoryData = 'AccruePointsProductCategory' + executionMode + 'Data';
        StaticResource appcsr = [SELECT Id, Body FROM StaticResource WHERE Name = :AccruePointsProductCategoryData WITH SECURITY_ENFORCED];
		accruePointsProductCategoryBlob = appcsr.Body;
        
        String LoyaltyActivityData = 'LoyaltyActivity' + executionMode + 'Data';
        StaticResource lasr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyActivityData WITH SECURITY_ENFORCED];
		loyaltyActivityBlob = lasr.Body;
        
        String RedeemPointsProductCategoryData = 'RedeemPointsProductCategory' + executionMode + 'Data';
        StaticResource rppcsr = [SELECT Id, Body FROM StaticResource WHERE Name = :RedeemPointsProductCategoryData WITH SECURITY_ENFORCED];
		redeemPointsProductCategoryBlob = rppcsr.Body;
        
        String TransactionJournalData = 'TransactionJournal' + executionMode + 'Data';
        StaticResource tjsr = [SELECT Id, Body FROM StaticResource WHERE Name = :TransactionJournalData WITH SECURITY_ENFORCED];
		transactionJournalBlob = tjsr.Body;
        
        String LoyaltyLedgerData = 'LoyaltyLedger' + executionMode + 'Data';
        StaticResource llsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyLedgerData WITH SECURITY_ENFORCED];
		loyaltyLedgerBlob = llsr.Body;

		String LoyaltyBenefitTypeData = 'LoyaltyBenefitType' + executionMode + 'Data';
        StaticResource lbtsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyBenefitTypeData WITH SECURITY_ENFORCED];
		loyaltyBenefitTypeBlob = lbtsr.Body;

	    String LoyaltyBenefitData = 'LoyaltyBenefit' + executionMode + 'Data';
        StaticResource lbsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyBenefitData WITH SECURITY_ENFORCED];
		loyaltyBenefitBlob = lbsr.Body;

		String LoyaltyTierBenefitData = 'LoyaltyTierBenefit' + executionMode + 'Data';
        StaticResource ltbsr = [SELECT Id, Body FROM StaticResource WHERE Name = :LoyaltyTierBenefitData WITH SECURITY_ENFORCED];
		loyaltyTierBenefitBlob = ltbsr.Body;
        
        String voucherDefinitionData = 'VoucherDefinition' + executionMode + 'Data';
        StaticResource vdst = [SELECT Id, Body FROM StaticResource WHERE Name = : voucherDefinitionData WITH SECURITY_ENFORCED];
		voucherDefBlob = vdst.Body;
		
        String voucherData = 'Voucher' + executionMode + 'Data';
        StaticResource vst = [SELECT Id, Body FROM StaticResource WHERE Name = : voucherData WITH SECURITY_ENFORCED];
		voucherBlob = vst.Body;
        
        loadData();
    }
    


    private static LoyaltyData createLoyaltyData(String name, Blob csv) {
        String[] csvLines = convertCsvStringToLines(csv.toString());
        if(csvLines.size() <= 1) {
            throw new ValidationException('No Data to load for : ' + name);
        }
        LoyaltyData loyaltyData = new LoyaltyData();
        loyaltyData.numberOfFields = csvLines.get(0).split(',').size();
        csvLines.remove(0);
        loyaltyData.csvLines = csvLines;
        return loyaltyData;
    }
    
    public static String[] convertCsvStringToLines(String csvString) {
		return csvString.split('\n');
    }
    
    public static String[] splitCsvLine(String csvLine) {
        String[] csvData = csvLine.split(',');
        for(Integer i = 0; i < csvData.size(); i++) {
            csvData[i] = csvData[i] != null ? csvData[i].trim() : csvData[i];
        }
        return csvData;
    }
    
    public static Set<String> getFieldValues(LoyaltyData loyaltyData, Integer index) {
        Set<String> values = new Set<String>();
        for(String csvLine : loyaltyData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(csvData.size()>=index+1){
                if (!Utils.isEmptyOrNull(csvData[index])) {
                    values.add(csvData[index]);
                }
            }
        }
        return values;
    }

    public void init(){
		docId=[Select Id from Document where Name='Sample Loyalty Data.zip' WITH SECURITY_ENFORCED].Id;
    }
}