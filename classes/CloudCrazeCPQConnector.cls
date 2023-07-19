public class CloudCrazeCPQConnector{
    public Id quoteId {get; set;}
    public Id cartId {get; set;}
    public Id scId {get; set;}
    Schema.sObjectType type {get; set;}
    public SBQQ__Quote__c quote {get; set;}
    public ccrz__E_Cart__c cart {get; set;}
    public List<ccrz__E_CartItem__c> cartItems {get; set;}
    public List<SBQQ__QuoteLine__c> quoteLines {get; set;}
    
    public CloudCrazeCPQConnector(ApexPages.StandardController sc){
        system.debug('In the controller');
        this.scId = sc.getId();
        system.debug('Id was set to ' + this.scId);
        this.type = sc.getRecord().getSObjectType();
        
    }

    public void processCart(Id id){
        system.debug('Process Cart Called');
        this.cartId = id;
        system.debug('Set the cart ID to ' + this.cartId);
        fetchCart();
    }

    public void fetchCart(){
        system.debug('Fetching Cart...');
        this.cart = [SELECT Id, Quote__c, ccrz__Account__c, ccrz__Contact__c FROM ccrz__E_Cart__c WHERE Id = :this.cartId];
        if(this.cart.Quote__c != NULL){
            system.debug('Cart Already Had a quote');
            this.quoteId = this.cart.Quote__c;
        }
        else{
            system.debug('Cart has no quote.');
            createQuoteFromCart();
        }
    }

    public void createQuoteFromCart(){
        system.debug('createQuoteFromCart Method Invoked');
        String P_Id = [Select Id,Name FROM Pricebook2 WHERE NAME = 'Standard Price Book'].Id;
        this.quote = new SBQQ__Quote__c(SBQQ__Account__c = this.cart.ccrz__Account__c, SBQQ__PrimaryContact__c = this.cart.ccrz__Contact__c, SBQQ__PriceBook__c = P_Id, SBQQ__PricebookId__c = P_Id, Ecommerce_Cart__c = this.cartId);
        try{
            system.debug('Trying to Insert Quote ');
            database.insert(this.quote);    
        }
        catch(Exception e){
            system.debug('Insert Failed...');
            system.debug(e.getMessage());
        }
        
        this.quoteId = this.quote.Id;
        this.cart.Quote__c = this.quote.Id;
        database.update(this.cart);

        createQuoteLinesFromCartLines();


    }

    public void createQuoteLinesFromCartLines(){
        system.debug('Starting to Create Quote Lines');
        this.cartItems = [SELECT Name, Id, ccrz__Product__r.Product__c, ccrz__Quantity__c, ccrz__Price__c, Quote_Line__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c = :this.cartId and ccrz__Product__r.Product__c != null];
        this.quoteLines = new List<SBQQ__QuoteLine__c>();
        for(ccrz__E_CartItem__c cartItem : this.cartItems){
            system.debug('Found Cart Item ' + cartItem.Name);
            SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.SBQQ__Product__c = cartItem.ccrz__Product__r.Product__c;
            quoteLine.SBQQ__Quantity__c = cartItem.ccrz__Quantity__c;
            quoteLine.SBQQ__SpecialPrice__c = cartItem.ccrz__Price__c;
            quoteLine.SBQQ__SpecialPriceType__c = 'Custom';
            quoteLine.SBQQ__Quote__c = this.quoteId;
            quoteLine.Ecommerce_Cart_Item__c = cartItem.Id;
            quoteLine.SBQQ__Incomplete__c = true;
            //NEW
            quoteLine.SBQQ__ListPrice__c = cartItem.ccrz__Price__c;
            quoteLine.SBQQ__NetPrice__c = cartItem.ccrz__Price__c;
            this.quoteLines.add(quoteLine);
        }
        database.insert(this.quoteLines);

        Map<Id, Id> cartItem2quoteLineMap = new Map<Id, Id>();

        for(SBQQ__QuoteLine__c quoteLine : this.quoteLines){
            cartItem2quoteLineMap.put(quoteLine.Ecommerce_Cart_Item__c, quoteLine.Id);
        }

        for(ccrz__E_CartItem__c cartItem : this.cartItems){
            cartItem.Quote_Line__c = cartItem2quoteLineMap.get(cartItem.Id);
        }

        database.update(this.cartItems);

    }

    public ApexPages.PageReference goToQuoteLineEditor(){
        system.debug('In the Redirect');
        if(this.type == Schema.ccrz__E_Cart__c.getSObjectType()){
            system.debug('The VF Controller Thinks this is a Cart');
            processCart(this.scId);
        }

        return new ApexPages.PageReference('/apex/SBQQ__sb?scontrolCaching=1&id=' + quoteId);
    }

    public static void syncQuoteLinesToCartItems(List<SBQQ__QuoteLine__c> lines){
        List<Id> quoteLineIds = new List<Id>();
        Map<Id, Decimal> quoteLine2priceMap = new Map<Id, Decimal>();
        Map<Id, Decimal> quoteLine2quantityMap = new Map<Id, Decimal>();
        for(SBQQ__QuoteLine__c line : lines){
            quoteLineIds.add(line.Id);
            quoteLine2priceMap.put(line.Id, line.SBQQ__NetPrice__c);
            quoteLine2quantityMap.put(line.Id, line.SBQQ__Quantity__c);
        }

        List<ccrz__E_CartItem__c> affectedCartItems = [SELECT Id, Quote_Line__c, ccrz__Price__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE Quote_Line__c IN :quoteLineIds];

        for(ccrz__E_CartItem__c ci : affectedCartItems){
            ci.ccrz__Price__c = quoteLine2priceMap.get(ci.Quote_Line__c);
            ci.ccrz__Quantity__c = quoteLine2quantityMap.get(ci.Quote_Line__c);
        }

        database.update(affectedCartItems);
    }

}