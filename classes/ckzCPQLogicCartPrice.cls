global with sharing class ckzCPQLogicCartPrice extends ccrz.ccLogicCartPrice {
    
    global virtual override Map<String, Object> applyPricing(Map<String, Object> inputData) {

        ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'begin applyPricing');

        // invoke out-of-box pricing to prevent duplicating work
        super.applyPricing(inputData);

        ccrz__E_Cart__c cartObj = (ccrz__E_Cart__c)inputData.get('cartToPrice');
        List<ccrz__E_CartItem__c> cartItems = (List<ccrz__E_CartItem__c>) inputData.get('cartItemsToPrice');

        //ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', JSON.serialize(cartItems));
        ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', cartItems);

        ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'cartItems size = ' + cartItems.size());

        // Adjust items here
        if(cartObj.Use_Quote_Overrides__c){

            ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'use quote override in effect');

            Map<Id, ccrz__E_CartItem__c> cartItemObjMap = new Map<Id, ccrz__E_CartItem__c>();

            for(ccrz__E_CartItem__c cartItemObj : cartItems) {

                ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'quoted price: ' + cartItemObj.QuotedPrice__c);
                ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'quoted qty: ' + cartItemObj.quotedQty__c);

                if(cartItemObj.QuotedPrice__c != null) {

                    cartItemObj.ccrz__Price__c = cartItemObj.QuotedPrice__c;

                    if(cartItemObj.quotedQty__c != null) {
                        cartItemObj.ccrz__quantity__c = cartItemObj.quotedQty__c;
                    }

                    cartItemObj.ccrz__subAmount__c = cartItemObj.ccrz__price__c * cartItemObj.ccrz__quantity__c;

                    ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'new sub amount: ' + cartItemObj.ccrz__subAmount__c);
                }

                cartItemObjMap.put(cartItemObj.Id, cartItemObj);
            }
            
        }

        ccrz.ccLog.log(LoggingLevel.DEBUG, 'ckzCPQLogicCartPrice', 'exit applyPricing');
        return inputData;
    }

}