public without sharing class Q2CAccountUtilitiesController {

    public Q2C_Demo_Settings__c settings { get; set; }
    public Id AccountId { get; set; }
    public Account ThisAccount { get; set; }
    public Contact ThisContact { get; set; }
    private ApexPages.StandardController Controller;
    private Id[] QuotesToDelete;

    //CONSTRUCTOR for VF Pages
    public Q2CAccountUtilitiesController(ApexPages.StandardController stdController) {
        this.AccountId = stdController.getId();
        Id acctId = this.AccountId;
        ThisAccount = [SELECT SBQQ__CoTermedContractsCombined__c, SBQQ__AssetQuantitiesCombined__c, SBQQ__RenewalModel__c,SBQQ__ContractCoTermination__c, ShippingAddress, BillingAddress,SBQQ__CoTerminationEvent__c,SBQQ__RenewalPricingMethod__c FROM Account where Id = :acctId];
        this.Controller = stdController;
        settings = Q2C_Demo_Settings__c.getOrgDefaults();
        IF([SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :acctId LIMIT 1].size()>0){
            ThisContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :acctId LIMIT 1];
        }
      
    }

    public PageReference insertContact() {
        Id acctId = this.AccountId;
        IF([SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :acctId LIMIT 1].size()>0){ThisContact.Email = 'steelbrick_demo@salesforce.com';
            update ThisContact;
        }
        return ApexPages.currentPage();
        
    }

    public PageReference updateAccount() {
        update ThisAccount;
        return ApexPages.currentPage();
    }

    public PageReference CloseRedirect() {
        return this.Controller.view();
    }

    public PageReference resetAccountQuickQuote() {
        resetAccount();
        return Q2CGenerateQuickQuote.genQuote();
    }
    /**public PageReference resetAccountQuickInvoice() {
        resetAccount();
        return Q2CGenerateQuickInvoice.genQuote();
    }
    **/
    public PageReference resetAccountMasterQuote() {
        Id a = this.AccountId;
        Id quotetocopy = settings.Master_Quote__c;
        String AcctName = [SELECT Name FROM Account WHERE Id = :a].Name;
        resetAccount();
        Opportunity NewOpp = new Opportunity(Name = 'New Opportunity for ' + AcctName, CloseDate = Date.today(), StageName = 'Qualification', AccountId = a);
        insert NewOpp;
        List<SBQQ__Quote__c> Myquote = new List <SBQQ__Quote__c>();
        SObjectType objToken = Schema.getGlobalDescribe().get('SBQQ__Quote__c');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        List<String> fieldslist = new List<String>();
        for (String s : fields.keySet()) {
            fieldslist.add(s);
        }
        String qq = 'SELECT ' + String.join(fieldslist, ',') + ' FROM SBQQ__Quote__c WHERE Id=:quotetocopy';
        System.debug(qq);
        Myquote = Database.query(qq);
        SBQQ__Quote__c Quote = Myquote.get(0).clone(false, true); //set new quotes
        Quote.SBQQ__StartDate__c = NewOpp.CloseDate.addDays(1);
        Quote.SBQQ__Opportunity2__c = NewOpp.Id;
        Quote.SBQQ__Account__c = NewOpp.Account.Id;
        Quote.SBQQ__Primary__c = true;
        insert Quote;

        List<SBQQ__QuoteLine__c> QLtoCopy = new List<SBQQ__QuoteLine__c>();

        SObjectType objToken1 = Schema.getGlobalDescribe().get('SBQQ__QuoteLine__c');
        DescribeSObjectResult objDef1 = objToken1.getDescribe();
        Map<String, SObjectField> fields1 = objDef1.fields.getMap();
        List<String> fieldslist1 = new List<String>();
        for (String s1 : fields1.keySet()) {
            fieldslist1.add(s1);
        }
        String q = 'SELECT ' + String.join(fieldslist1, ',') + ' FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c=:quotetocopy';
        System.debug(q);
        QLtoCopy = Database.query(q);


        List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>();
        
        Id newQuoteId=Quote.Id;
        SBQQ.TriggerControl.disable();
        for (Integer j = 0; j < QLtoCopy.size(); j++) { //through each quoteline (j)
            SBQQ__QuoteLine__c QuoteLine = QLtoCopy.get(j).clone(false, true);
            if (QLtoCopy.get(j).SBQQ__RequiredBy__c != null) {
                Id parent = QLtoCopy.get(j).SBQQ__RequiredBy__c;
                Decimal qlnumber = [SELECT SBQQ__Number__c FROM SBQQ__QuoteLine__c WHERE Id = :parent].SBQQ__Number__c;
                QuoteLine.SBQQ__RequiredBy__c = [SELECT Id FROM SBQQ__QuoteLine__c WHERE SBQQ__Number__c = :qlnumber AND SBQQ__Quote__c = :newQuoteId].Id;
            }
            QuoteLine.SBQQ__Group__c = null;
            QuoteLine.SBQQ__Quote__c = Quote.Id;

            insert QuoteLine;
            newQuoteLines.add(QuoteLine);
            
        }
        SBQQ.TriggerControl.enable();
        //insert newQuoteLines;

        return this.Controller.view();
    }
    //public PageReference quickInvoice() {
    //    resetAccount();
    //    return Q2CGenerateQuickInvoice.genQuote();
    //
    //}


    public PageReference resetAccountNewOpp() {
        Id a = this.AccountId;
        String AcctName = [SELECT Name FROM Account WHERE Id = :a].Name;
        resetAccount();
        Opportunity NewOpp = new Opportunity(Name = 'New Opportunity for ' + AcctName, CloseDate = Date.today(), StageName = 'Qualification', AccountId = a);
        insert NewOpp;
        return this.Controller.view();
    }

    public PageReference resetAccount() {
        updateCustomSettings();
        this.deleteDiscScheds();
        this.deleteQuotes();
        this.deleteOpportunities();
        this.deleteAssets();
        this.deleteSubscriptions();
        this.deleteContracts();
        this.deleteOrders();
        this.deleteContractedPrices();
        //this.deleteOrderConsumption();

        System.debug('Total Number of SOQL Queries in this apex code context: ' + Limits.getQueries());

        return this.Controller.view();
    }

    private Boolean updateCustomSettings() {
        try {
            update settings;

        } catch (Exception e) {
            return false;
        }
        return true;
    }


   

    private Boolean deleteDiscScheds() {
        Id a = this.AccountId;
        SBQQ__DiscountSchedule__c[] dsToDelete = [SELECT Id FROM SBQQ__DiscountSchedule__c WHERE SBQQ__Account__c = :a];
        if (!dsToDelete.isEmpty()) {
            Database.delete(dsToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteDiscScheds(): ' + Limits.getQueries());

        return true;
    }

    private Boolean deleteProcessInputValues(Set<Id> quotes) {
        Id a = this.AccountId;
        SBQQ__ProcessInputValue__c[] valuesToDelete = [SELECT Id FROM SBQQ__ProcessInputValue__c WHERE SBQQ__QuoteId__c IN :quotes];
        if (!valuesToDelete.isEmpty()) {
            Database.delete(valuesToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteProcessInputValues(): ' + Limits.getQueries());

        return true;
    }


  
    private Boolean deleteOrders() {
        Id a = this.AccountId;
        Order[] ordersToDelete = [SELECT Id FROM Order WHERE AccountId = :a];
        if (!ordersToDelete.isEmpty()) {
            Set<Id> orderIds = new Set<Id>();
            for (Order o : ordersToDelete) {
                orderIds.add(o.Id);
                //o.Status = 'Draft';
                //o.SBQQ__Contracted__c = false;
            }
            update ordersToDelete;
            OrderItem[] orderItems = getOrderItems(orderIds);
            if (!orderItems.isEmpty()) {
                for (OrderItem oi : orderItems) {
                    oi.SBQQ__Contracted__c = false;
                    oi.SBQQ__Status__c = 'Draft';
                    oi.SBQQ__Activated__c = false;
                    
                    System.debug(oi.OrderItemNumber + ' - ' + oi);
                }

                Database.update(orderItems);
                
            }
            for (Order o : ordersToDelete) {
                //orderIds.add(o.Id);
                o.Status = 'Draft';
                o.SBQQ__Contracted__c = false;
                System.debug(o.Name + ' - ' + o);
            }
            Database.update(ordersToDelete);
            Database.delete(ordersToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteOrders(): ' + Limits.getQueries());

        return true;
    }



   

    private Boolean deleteOpportunities() {
        Id a = this.AccountId;
        Opportunity[] opportinitiesToDelete = [SELECT Id FROM Opportunity WHERE AccountId = :a];
        if (!opportinitiesToDelete.isEmpty()) {
            Database.delete(opportinitiesToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteOpportunities(): ' + Limits.getQueries());

        return true;
    }

    private Boolean deleteAssets() {
        Id a = this.AccountId;
        Asset[] assetsToDelete = [SELECT Id FROM Asset WHERE AccountId = :a];
        if (!assetsToDelete.isEmpty()) {
            Database.delete(assetsToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteAssets(): ' + Limits.getQueries());

        return true;
    }

    private Boolean deleteSubscriptions() {
        Id a = this.AccountId;
        SBQQ__Subscription__c[] subscriptionsToDelete = [SELECT Id FROM SBQQ__Subscription__c WHERE SBQQ__Account__r.Id = :a];
        if (!subscriptionsToDelete.isEmpty()) {
            Database.delete(subscriptionsToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteSubscriptions(): ' + Limits.getQueries());

        return true;
    }

    private Boolean deleteContracts() {
        Id a = this.AccountId;
        Contract[] contractsToDelete = [SELECT Id, SBQQ__RenewalOpportunity__c FROM Contract WHERE AccountId = :a];
        if (!contractsToDelete.isEmpty()) {
            for (Contract c : contractsToDelete) {
                c.SBQQ__RenewalOpportunity__c = null;
            }
            Database.update(contractsToDelete);
            Database.delete(contractsToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteContracts(): ' + Limits.getQueries());

        return true;
    }

    private Boolean deleteQuotes() {
        Id a = this.AccountId;
        SBQQ__Quote__c[] quotesToDelete = [SELECT Id FROM SBQQ__Quote__c WHERE SBQQ__Account__r.Id = :a];
        if (!quotesToDelete.isEmpty()) {
            Set<Id> quoteIds = new Set<Id>();
            for (SBQQ__Quote__c q : quotesToDelete) {
                quoteIds.add(q.Id);
            }
            this.deleteProcessInputValues(quoteIds);
            Database.delete(quotesToDelete);
        }

        System.debug('Total Number of SOQL Queries after deleteQuotes(): ' + Limits.getQueries());

        return true;
    }



    private static List<OrderItem> getOrderItems(Set<Id> orderIds) {
        OrderItem[] orderItems = [SELECT Id FROM OrderItem WHERE OrderId IN :orderIds];
        return orderItems;
    }

   

    private Boolean deleteContractedPrices() {
        Id a = this.AccountId;
        if (settings.Delete_Contracted_Prices__c == true) {
            SBQQ__ContractedPrice__c[] cpToDelete = [SELECT Id FROM SBQQ__ContractedPrice__c WHERE SBQQ__Account__c = :a];
            if (!cpToDelete.isEmpty()) {
                Database.delete(cpToDelete);
            }
        }
        System.debug('Total Number of SOQL Queries after deletePaymentTransactions(): ' + Limits.getQueries());

        return true;
    }
   /** private Boolean deleteOrderConsumption() {
        Id a = this.AccountId;
        if (settings.Delete_Contracted_Prices__c == true) {
            SBQQ__OrderItemConsumptionSchedule__c[] ocToDelete = [SELECT Id FROM SBQQ__OrderItemConsumptionSchedule__c WHERE SBQQ__OrderItem__r.Order.AccountId = :a];
            if (!ocToDelete.isEmpty()) {
                Database.delete(ocToDelete);
            }
        }
        System.debug('Total Number of SOQL Queries after deletePaymentTransactions(): ' + Limits.getQueries());

        return true;
    }**/
   
}