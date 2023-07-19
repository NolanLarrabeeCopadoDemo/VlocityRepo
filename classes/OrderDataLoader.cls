public inherited sharing class OrderDataLoader {
    
    public Map<String, String> priceBookIds = new Map<String, String>();
    public Map<String, String> accountIds = new Map<String, String>();
    public Map<Integer, Order> ordersObjects = new Map<Integer, Order>();
    public Map<String, String> priceBookEntryIds = new Map<String, String>();
    
    Pricebook2 standardPB;
    
    public void createData(Map<String, LoyaltyData> dataMap) {
        if(dataMap.get('Order') != null) {
            getstandardPB();
            createOrderData(dataMap.get('Order'));
            createOrderItemData(dataMap.get('Order'));
            activateOrder();
        }
    }
    
    public void createOrderData(LoyaltyData orderData){
        
        List<Order> orders=new List<Order>();
        Set<String> pricebookNames = new Set<String>();
        Set<String> productNames = new Set<String>();
        Set<String> accountNames = new Set<String>();
        
        for(String csvLine : orderData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            accountNames.add(csvData[1]);
            if(csvData[5]!=null && csvData[5].length()!=0 && csvData[5]!='')
            pricebookNames.add(csvData[5]);
            productNames.add(csvData[2]);
        }
        
        ProductDataLoader pd = new ProductDataLoader();
        system.debug(pricebookNames);
        priceBookIds = pd.retrievePriceBookIds(pricebookNames);
        priceBookIds.put(standardPB.Name , standardPB.Id);
        priceBookEntryIds = retrievepricebookEntry(productNames);
        
        AccountAndContactDataLoader accountLoader = new AccountAndContactDataLoader();
        accountIds = accountLoader.upsertAccounts(accountNames);
        for(String csvLine : orderData.csvLines) {
            List<String> ids=new List<String>();
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            Integer count = 0;
            if(ordersObjects.get(Integer.valueOf(csvData[0])) == null) {
                Order order=new Order(  OrderIdReferenceNumber__c =csvData[0],
                                        AccountId = accountIds.get(csvData[1]),
                                        Status = 'Draft',
                                        EffectiveDate = System.today(),
                                        CopyOrderStatus__c ='Pending'
                					 );
                if(csvData.size()>=7){
                    if(Utils.isEmptyOrNull(csvData[6])==false){
                        Date dt=Date.valueOf(csvData[6]);
                        order.ActivatedDate=DateTime.newInstance(dt.year(),dt.month(),dt.day());
                    }
                    else{
                        order.ActivatedDate=DateTime.now();
                    }
                    if(csvData.size()==8 && Utils.isEmptyOrNull(csvData[7])==false){
                        order.EffectiveDate=Date.valueOf(csvData[7]);
                    }
                }
                if(csvData[5] == null || csvData[5] ==''){
                    ids.add(standardPB.ID);
                }else if(priceBookIds.get(csvData[5]) != null){
                    ids.add(priceBookIds.get(csvData[5])); 
                }
                else{
                    throw new ValidationException('No Pricebook found named ==' + csvData[5] + '== in Order data');
                }
                order.priceBook2id=ids[0];
                ordersObjects.put(Integer.valueOf(csvData[0]) , order);
                orders.add(order);
                count++;
                if(count == 200) {
                	DMLManager.DBInsert(orders);
                	orders.clear();
                	count = 0;
            	}
            }
        }
         DMLManager.DBInsert(orders);
    }
     
    public void createOrderItemData(LoyaltyData orderData){
        List<OrderItem> orderItems=new List<OrderItem>();
        String orderItemPriceBookId;
        Integer count = 0;
        for(String csvLine : orderData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            Order draftOrder = ordersObjects.get(Integer.valueOf(csvData[0]));
            if(csvData[5] == null || csvData[5] ==''){
                orderItemPriceBookId =  priceBookEntryIds.get(csvData[2] + '_' + standardPB.Id);
            }else{
                orderItemPriceBookId =  priceBookEntryIds.get(csvData[2] + '_' + priceBookIds.get(csvData[5]));  
            }
            if(orderItemPriceBookId == null){
                throw new ValidationException('No Pricebook found named =' + csvData[5] + '= for the product '+ csvData[2]);
            }  
            List<String> ids=new List<String>();
            ids.add(draftOrder.id);
            ids.add(orderItemPriceBookId);
            List<Decimal> valL=new List<Decimal>();
            valL.add(decimal.valueOf(csvData[3]));
            valL.add(decimal.valueOf(csvData[4]));
            OrderItem item=new OrderItem(
                                            OrderId = ids[0],            
                                            PricebookEntryId  = ids[1] ,
                                            Quantity = valL[0], 
                                            UnitPrice = valL[1]
            							); 
            orderItems.add(item);
            count++;
            if(count == 200) {
                DMLManager.DBInsert(orderItems);
                orderItems.clear();
                count = 0;
            }
        }
                DMLManager.DBInsert(orderItems);
    }
    
    public void activateOrder(){
        List<Order> activateOrders=new List<Order>();
        List<String> status=new List<String>();
        status.add('Activated');
        Integer count = 0;
        for(Integer orders : ordersObjects.keySet()) {
            Order draftOrder =ordersObjects.get(orders);
            draftOrder.Status = status[0];
            activateOrders.add(draftOrder);
            count++;
            if(count == 200) {
                DMLManager.DBUpdate(activateOrders);
                activateOrders.clear();
                count = 0;
            }
        }
        if(count>0)
        DMLManager.DBUpdate(activateOrders); 
    }
    
    public Map<String, String> retrievepricebookEntry(Set<String> productNames) {
        Set<String> productNamesToQuery = new Set<String>();
        Set<String> pricebookNamesToQuery = new Set<String>();
        for(String pricebook : priceBookIds.keySet()) {
            pricebookNamesToQuery.add(priceBookIds.get(pricebook));
        }
        
        for(String productName : productNames) {
            if(priceBookEntryIds.get(productName) == null) {
                productNamesToQuery.add(productName);
            }
        }
        
        if(productNamesToQuery.size() > 0) {
            PricebookEntry[] entry = [select Id, Name ,Pricebook2id  from PricebookEntry where Name in :productNamesToQuery and  Pricebook2Id  in :pricebookNamesToQuery  WITH SECURITY_ENFORCED];
            for(PricebookEntry pe : entry) {
                priceBookEntryIds.put(pe.Name + '_' + pe.Pricebook2id, pe.Id);
            }
        }
        
        return priceBookEntryIds;
    }
    
    public void getstandardPB(){
        standardPB = [select id , Name from Pricebook2 where isStandard=true WITH SECURITY_ENFORCED];
    }
    
    
}