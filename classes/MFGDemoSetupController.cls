public with sharing class MFGDemoSetupController {
    public MFGDemoSetupController() {

    }

    public static Account createAccount(String name) {
        return (createAccounts(new List<String>{name})[0]);
    }
    public static List<Account> createAccounts(String[] names) {
        List<Account> accs = new List<Account>();
        for (String name : names) {
            accs.add( new Account(Name = name) );
        }
        insert accs;
        return accs;
    }

    @AuraEnabled
    public static void createOrders() {
        
    }

    @AuraEnabled
    public static List<ProductListOption> getProductOptions() {
        List<ProductListOption> productList = new List<ProductListOption>();
        List<Product2> products = [SELECT Id, Name FROM Product2];
        for (Product2 prod : products) {
            productlist.add(new ProductListOption(prod.Name, prod.Id));
        }
        return productList;
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


    @AuraEnabled(cacheable=true)
    //public static Result getSAData(String recordId, String numberOfSchedules) {
    public static Result getSAData(String recordId) {
        if (recordId == null) {
            System.debug('recordId is null');
            return null;
        }

        System.debug(' in getSAData for '+ recordId);
        SalesAgreement sa = [SELECT Id, AccountId, Name, StartDate, EndDate, PriceBookId, ScheduleFrequency, ScheduleCount FROM SalesAgreement WHERE Id =: recordId];
        
        String saProductFields = 'Id, SalesAgreementId, PricebookEntryId, ProductId, SalesPrice, ListPrice, InitialPlannedQuantity, Product.Name';
        String sapScheduleFields = '';
        for (String fieldName : Schema.getGlobalDescribe().get('SalesAgreementProductSchedule').getDescribe().fields.getMap().keyset()) {
            sapScheduleFields += String.isBlank(sapScheduleFields) ? fieldName : ',' + fieldName;
        }
        String queryEnd =  ' FROM SalesAgreementProductSchedules ORDER BY EndDate ASC) FROM SalesAgreementProduct WHERE SalesAgreementId = :recordId ORDER BY Product.Name ASC';
        String queryString = 'SELECT '+ saProductFields +', (SELECT '+ sapScheduleFields + queryEnd;

        return new Result(sa, Database.query(queryString));
    }

    // ed. note: wtf??
    public static Id id(String inputId) {
        if (inputId == null)
            return Id.valueOf(inputId);
        return null;
    }

    public class Result {
        @AuraEnabled public SalesAgreement sa;
        @AuraEnabled public List<SalesAgreementProduct> products;                               

        public Result(SalesAgreement sa, List<SalesAgreementProduct> products) {
            this.sa = sa;
            this.products = products;
        }
    }

}