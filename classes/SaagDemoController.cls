public class SaagDemoController {
    public SaagDemoController() {

    }

    @AuraEnabled
    public static SalesAgreement insertSAProds(String saveRequestString){
        System.debug('in insertSAProds');
        SaveRequest req = (SaveRequest)JSON.deserialize(saveRequestString, SaveRequest.class);
        System.debug('req = '+ req);
        SalesAgreement sa = [SELECT Id, AccountId, Name, PricebookId, Status FROM SalesAgreement WHERE Id =: req.saId];
        List<SalesAgreementProduct> prods = new List<SalesAgreementProduct>();
        Set<Order> orders = new Set<Order>();
        // Create a map between each PricebookEntryId and a nested map associating all of the Schedule Dates to the SAProdSchedule data (input from the LWC)
        Map<Id, Map<Date, SAProdSchedule>> productScheduleDateMap = new Map<Id, Map<Date, SAProdSchedule>>();
        Map<Date, List<OrderItem>> dateOrderItemMap = new Map<Date, List<OrderItem>>();
        //Map<Date, Order> dateOrderMap = new Map<Date, Order>();
        for (SAProd reqProd : req.saProds) {
            SalesAgreementProduct prod = new SalesAgreementProduct(SalesAgreementId = sa.Id, InitialPlannedQuantity = 1, 
                PricebookEntryId = reqProd.pricebookEntryId, Name = reqProd.productName);
            prods.add(prod);            
            Map<Date, SAProdSchedule> scheduleDateMap = new Map<Date, SAProdSchedule>();
            for (SAProdSchedule prodSchedule : reqProd.schedules) {
                Date scheduleDate = prodSchedule.startDate.dateGMT();
                System.debug('scheduleDate = '+ scheduleDate);
                //System.debug('scheduleDate = '+ scheduleDate);
                //System.debug('days between today = '+ scheduleDate.daysBetween(Date.today()));
                //System.debug('prodSchedule = '+ prodSchedule);
                scheduleDateMap.put(scheduleDate, prodSchedule);
                // if prodSchedule.startDate is in the past, create an OrderItem for it
                if (scheduleDate.daysBetween(Date.today()) >= 0) {
                    System.debug('scheduleDate is in the past');
                    List<OrderItem> orderItems = dateOrderItemMap.containsKey(scheduleDate) ? dateOrderItemMap.get(scheduleDate) : new List<OrderItem>();
                    System.debug('orderItems = '+ orderItems);
                    OrderItem newItem = new OrderItem(PricebookEntryId = prod.PricebookEntryId, Quantity = prodSchedule.metricValueMap.get('ActualQuantity'));
                    System.debug('newItem = '+ newItem);
                    if (newItem.Quantity != 0) {
                        orderItems.add(newItem);
                        dateOrderItemMap.put(scheduleDate, orderItems);
                        Order newOrder = new Order(AccountId = sa.AccountId, SalesAgreementId = sa.Id, EffectiveDate = scheduleDate, Status = 'Draft', Pricebook2Id = req.pricebookId);
                        System.debug('newOrder = '+ newOrder);
                        orders.add(newOrder);
                        System.debug('orders = '+ orders);
                    }
                }
            }
            productScheduleDateMap.put(prod.PricebookEntryId, scheduleDateMap);
        }
        insert prods;
        System.debug('Inserted sales agreement products = '+ prods);

        List<Id> saProductIds = new List<Id>();
        for (SalesAgreementProduct prod : prods) {
            saProductIds.add(prod.Id);
        }
        List<SalesAgreementProductSchedule> schedules = [SELECT SalesAgreementProductId, SalesAgreementProduct.PricebookEntryId, StartDate, EndDate, PlannedQuantity, ActualQuantity FROM SalesAgreementProductSchedule WHERE SalesAgreementProductId IN: saProductIds];

        for (SalesAgreementProductSchedule schedule : schedules) {
            System.debug('schedule = '+ schedule);
            Date startDate = schedule.startDate;
            Map<Date, SAProdSchedule> scheduleDateMap = productScheduleDateMap.get(schedule.SalesAgreementProduct.PricebookEntryId);
            for (Date dt : scheduleDateMap.keySet()) {
                System.debug('Date = '+ dt);
            }
            System.debug('scheduleDateMap = '+ scheduleDateMap);
            System.debug('startDate = '+ startDate);
            System.debug('scheduleDateMap contains schedule.startDate = '+ scheduleDateMap.containsKey(startDate));
            SAProdSchedule prodSchedule = scheduleDateMap.get(startDate);
            if(scheduleDateMap.containsKey(startDate)){
                for (String metric : prodSchedule.metricValueMap.keySet()) {
                    Double metricValue = prodSchedule.metricValueMap.get(metric);
                    String fieldType = SalesAgreementProductSchedule.getSObjectType().getDescribe().fields.getMap().get(metric).getDescribe().getType().name();
                    if (metric.startsWith('Actual')) {

                    } else {
                        if (fieldType == 'Integer') {
                            Integer intMetricValue = Integer.valueOf(metricValue);
                            schedule.put(metric, intMetricValue);
                        } else {
                            schedule.put(metric, metricValue);
                        }
                    }
                }
            }
        }
        update schedules;

        // Activate the salesagreement
        sa.Status = 'Approved';
        update sa;

        System.debug('SalesAgreement = '+ sa);

        if (!orders.isEmpty()) {
            //orders = dateOrderMap.values();
            List<Order> ordersToInsert = new List<Order>();
            ordersToInsert.addAll(orders);
            insert ordersToInsert;
            Map<Date, Id> orderDateIdMap = new Map<Date, Id>();
            for (Order o : ordersToInsert) {
                o.Status = 'Activated'; // soon, my precious
                o.Status__c = 'Activated';
                orderDateIdMap.put(o.EffectiveDate, o.Id);
            }
            System.debug('orders = '+ ordersToInsert);
            //Map<Id, Order> orderIdMap = new Map<Id, Order>([SELECT Id, Status FROM Order WHERE SalesAgreementId = :sa.Id]);
            Map<Id, PricebookEntry> pbeIdMap = new Map<Id, PricebookEntry>([SELECT UnitPrice FROM PricebookEntry WHERE Id IN: productScheduleDateMap.keySet()]);
            List<OrderItem> orderItemsToInsert = new List<OrderItem>();
            for (Date orderDate : dateOrderItemMap.keySet()) {
                
                //Id orderId = dateOrderMap.get(orderDate).Id;
                for (OrderItem item : dateOrderItemMap.get(orderDate)) {
                    System.debug('orderItem = '+ item);
                    item.OrderId = orderDateIdMap.get(orderDate);
                    item.UnitPrice = pbeIdMap.get(item.PricebookEntryId).UnitPrice;
                    orderItemsToInsert.add(item);
                    //item.OrderId = orderIdMap.get()
                }
            }
            insert orderItemsToInsert;
            update ordersToInsert;
        }

        return sa;
    }

    public class SaveRequest {
        @AuraEnabled public Id saId;
        @AuraEnabled public List<SAProd> saProds;
        @AuraEnabled public Id pricebookId;
    }

    public class SAProd {
        @AuraEnabled public Id pricebookEntryId;
        @AuraEnabled public String productName;
        @AuraEnabled public List<SAProdSchedule> schedules;
    }

    public class SAProdSchedule {
        @AuraEnabled public DateTime startDate;
        @AuraEnabled public DateTime endDate;
        @AuraEnabled public Map<String, Double> metricValueMap;
    }

    /* UNUSED CODE GRAVEYARD BELOW */

    /*
    @AuraEnabled
    public static List<ProductListOption> getProductOptions() {
        List<ProductListOption> productList = new List<ProductListOption>();
        List<Product2> products = [SELECT Id, Name FROM Product2];
        for (Product2 prod : products) {
            productlist.add(new ProductListOption(prod.Name, prod.Id));
        }
        return productList;
    }

    @AuraEnabled 
    public static List<ProductListOption> getPricebookEntryOptions(Id pb2Id) {
        List<ProductListOption> productList = new List<ProductListOption>();
        List<PricebookEntry> products = [SELECT Id, Name, ProductCode, UnitPrice FROM PricebookEntry WHERE Pricebook2Id =:pb2Id];
        for (PricebookEntry prod : products) {
            productlist.add(new ProductListOption(prod.Name, prod.Id));
        }
        return productList;
    }
    

    @AuraEnabled
    public static void saveRows(String rowsString) {
        Map<Id, SalesAgreementProduct> saProdMap = new Map<Id, SalesAgreementProduct>();
        Map<Id, SalesAgreementProductSchedule> saProdSchedMap = new Map<Id, SalesAgreementProductSchedule>();
        System.debug('in saveRows');
        System.debug('rowsString = '+ rowsString);
        List<RowToSave> rows = (List<RowToSave>)JSON.deserialize(rowsString, List<RowToSave>.class);
        System.debug('rows = '+ rows);
        for (RowToSave row : rows) {
            System.debug('row: '+ row);
            //List<SalesAgreementProduct> prods = saProdMap.containsKey(row.productId) ? saProdMap.get(row.productId) : new List<SalesAgreementProduct>();
            SalesAgreementProduct prod = saProdMap.get(row.productId);
            if (prod == null) {

            }



            for (RowValue val : row.vals) {
                System.debug('val: '+ val);
            }
        }
    }
    */

    /*
    public class RowToSave {
        @AuraEnabled public Id saId;
        @AuraEnabled public Id productId;
        @AuraEnabled public String metric;
        @AuraEnabled public List<RowValue> vals;
    }

    public class RowValue {
        @AuraEnabled public DateTime startDate;
        @AuraEnabled public DateTime endDate;
        @AuraEnabled public Integer value;
    }

    public class Period {
        @AuraEnabled public Date startDate;
        @AuraEnabled public Date endDate;
    }

    public class ProductListOption {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;

        public ProductListOption() {
        }

        public ProductListOption(String l, String v) {
            label = l;
            value = v;
        }
    }
    */

}