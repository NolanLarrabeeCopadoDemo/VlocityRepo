public inherited sharing class TransactionJournalDataLoader {
    
    public Map<String, String> transactionJournalIds = new Map<String, String>();
    
    public void createData(Map<String, LoyaltyData> dataMap) {
        if(dataMap.get('TransactionJournal') != null) {
            createLoyaltyTransactionJournalData(dataMap.get('TransactionJournal'));
        }
    }
    
    public void createLoyaltyTransactionJournalData(LoyaltyData transactionJournalData){
        List<TransactionJournal> transactionJournals = new List<TransactionJournal>();
        Integer count = 0;
        
        
        Set<String> journalTypeNames = new Set<String>();
        Set<String> journalSubTypeNames = new Set<String>();
        Set<String> partnerNames = new Set<String>();
        Set<String> productCategoryNames = new Set<String>();
        Set<String> productNames = new Set<String>();
        Set<String> programNames = new Set<String>();
        Set<String> membershipNumbers = new Set<String>();
            
        Map<String, String> programIds = new Map<String, String>();
        Map<String, String> journalTypeIds = new Map<String, String>();
        Map<String, String> journalSubTypeIds = new Map<String, String>();
        Map<String, String> productCategoryIds = new Map<String, String>();
        Map<String, String> productIds = new Map<String, String>();
        Map<String, String> partnerIds = new Map<String, String>();
        Map<String, String> memberIds = new Map<String, String>();
        
        
        Map<String, Set<String>> programPartnerNames = new Map<String, Set<String>>();
        JournalTypeSubTypeDataLoader jtstdl=new JournalTypeSubTypeDataLoader();
		ProductDataLoader pdl=new ProductDataLoader();        
        LoyaltyProgramEssentialsDataLoader lpedl=new LoyaltyProgramEssentialsDataLoader();
		LoyaltyProgramMemberDataLoader lpmdl=new LoyaltyProgramMemberDataLoader();
        LoyaltyPartnerDataLoader lpdl = new LoyaltyPartnerDataLoader();
        
        for(String csvLine : transactionJournalData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            programNames.add(csvData[0]);
            membershipNumbers.add(csvData[1]);
            journalTypeNames.add(csvData[2]);
            journalSubTypeNames.add(csvData[3]);
            productCategoryNames.add(csvData[10]);
            productNames.add(csvData[11]);
            
            if(programPartnerNames.get(csvData[0]) != null){
                partnerNames = programPartnerNames.get(csvData[0]);
                partnerNames.add(csvData[5]);
            }else{
                Set<String> newPartnerNames = new Set<String>();
                newPartnerNames.add(csvData[5]);
                programPartnerNames.put(csvData[0] , newPartnerNames);
            }
        }
        
        programIds = lpedl.retrieveProgramIds(programNames);
                
        for(String programPartner : programPartnerNames.keySet()){
            partnerIds.putall(lpdl.getPartnerIds(programIds.get(programPartner) ,programPartnerNames.get(programPartner)));
        }
        journalTypeIds = jtstdl.retrievejournalTypeIds(journalTypeNames);
        journalSubTypeIds = jtstdl.retrievejournalSubTypeIds(journalSubTypeNames);   


        productIds = pdl.retrieveProductIds(productNames);
        productCategoryIds = pdl.retrieveProductCategoryIds(productCategoryNames);
        
        memberIds = lpmdl.retrieveLoyaltyProgramMemberIds(membershipNumbers);
        Map<String,String> cacheIds=fetchOrderData(transactionJournalData,productNames,productIds);
        
        for(String csvLine : transactionJournalData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            TransactionJournal txnJournal = new TransactionJournal();
            String f1,f2,f3,f4,f5,f8,f9,f10,f15,f16,f17,f18;
            DateTime f6,f7,f14;
            Decimal f11,f12;
            Date f13;
            f1=programIds.get(csvData[0]);
            f2=memberIds.get(csvData[1]);
            f3=journalTypeIds.get(csvData[2]);
            f4=journalSubTypeIds.get(csvData[3]);
            if(String.isNotBlank(csvData[5])){
                 f5=partnerIds.get(programIds.get(csvData[0])+'_'+csvData[5]);
            }
           
            if(String.isNotBlank(csvData[6])){
                Date dt=Date.valueOf(csvData[6]);
                f6=DateTime.newInstance(dt.year(),dt.month(),dt.day());
            }else{
                f6=system.now();
            }
            
            if(String.isNotBlank(csvData[7])){
                Date dt=Date.valueOf(csvData[7]);
                f7=DateTime.newInstance(dt.year(),dt.month(),dt.day());
             }
            
            if(String.isNotBlank(csvData[9])){
                f8=csvData[9];
            }else{
                f8='Pending';
            }
            
            if(String.isNotBlank(csvData[10])){
                f9=productCategoryIds.get(csvData[10]);
            }
            if(String.isNotBlank(csvData[11])){
                f10=productIds.get(csvData[11]);
            }
            if(String.isNotBlank(csvData[12])){
                f11=decimal.valueOf(csvData[12]);
            }
            if(String.isNotBlank(csvData[13])){
                f12=decimal.valueOf(csvData[13]);
            }
            
            if(csvData.size()>=15)
            if(String.isNotBlank(csvData[14])){
                f13=Date.valueOf(csvData[14]);
            }
            
            if(csvData.size()>=16)
            if(String.isNotBlank(csvData[15])){
                Date dt=Date.valueOf(csvData[15]);
                f14=DateTime.newInstance(dt.year(),dt.month(),dt.day());
            }
            if(csvData.size()>=17)
                f15=csvData[16];
            if(csvData.size()>=18)
                f16=csvData[17];
 			if(csvData.size()==19)
                f17=cacheIds.get(csvData[18]);
            f18=cacheIds.get(f17+'_'+f10);
            txnJournal = new TransactionJournal(LoyaltyProgramId =f1,
                                                MemberId=f2,
                                                JournalTypeId=f3,
                                                JournalSubTypeId=f4,
                                                Industry=csvData[4],
                                                PartnerId=f5,
                                                ActivityDate=f6,
                                                JournalDate=f7,
                                                ExternalTransactionNumber=csvData[8],
                                                Status=f8,
                                                ProductCategoryId=f9,
                                                ProductId=f10,
                                                Quantity=f11,
                                                TransactionAmount=f12,
                                                InvoiceDate=f13,
                                                EndDate=f14,
                                                ActivityCategory__c=f15,
                                                ActivityName__c=f16,
                                                OrderId=f17,
                                                OrderItemId=f18
                                               );
            transactionJournals.add(txnJournal);
            
            count++;
            if(count == 200) {
            	insert transactionJournals; 
                transactionJournals.clear();
                count = 0;
            } 
        }
        if(count > 0) {
            insert transactionJournals;
			transactionJournals.clear();
        }
    }
    
    Map<String,String> fetchOrderData(LoyaltyData transactionJournal,Set<String> productNames,Map<String,String> productIds){
        Map<String,String> cacheIds=new Map<String,String>();
        Set<String> orderIds=LoyaltyDataLoadController.getFieldValues(transactionJournal, 18);
        List<Order> orders=[Select Id,OrderIdReferenceNumber__c  from Order where OrderIdReferenceNumber__c in :orderIds WITH SECURITY_ENFORCED];
        Set<String> queryIds=new Set<String>();
        for(Order od:orders){
            cacheIds.put(od.OrderIdReferenceNumber__c,od.id);
            queryIds.add(od.id);
        }
        for(String productName:productNames){
            queryIds.add(productIds.get(productName));
        }
        List<OrderItem> orderItem=[Select Id,OrderId,Product2Id from OrderItem where OrderId in :queryIds and product2Id in :queryIds WITH SECURITY_ENFORCED];
        for(OrderItem oi:orderItem){
            cacheIds.put(oi.OrderId+'_'+oi.product2Id,oi.id);
        }        
		return cacheIds;
    }
	 /**
     * @description retrieveTransactionJournal method is used to retrieve Transaction Journal data
     * @param tranJrlNumbes contains list of Product Names
     * @returns map with TJ externaltransactionId as key and TJ Id as value
    */
    Public Map<String,String> retrieveTransactionJournal(Set<String> transactionJournalNumbers){
        
        for( TransactionJournal transactionJournal : [SELECT Id, ExternalTransactionNumber FROM TransactionJournal WHERE ExternalTransactionNumber IN : transactionJournalNumbers WITH SECURITY_ENFORCED ]) {
            
            if(!transactionJournalIds.containsKey(transactionJournal.ExternalTransactionNumber)) {
                transactionJournalIds.put(transactionJournal.ExternalTransactionNumber, transactionJournal.Id);
            }
        }
        return transactionJournalIds;
    }        
}