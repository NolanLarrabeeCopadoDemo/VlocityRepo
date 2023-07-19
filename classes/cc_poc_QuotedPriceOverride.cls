global without sharing class cc_poc_QuotedPriceOverride extends ccrz.cc_api_PriceAdjustment{
    
    global override Map<String, Object> computePricingCart(Map<String, Object> inputData){
        ccrz.cc_bean_CartSummary cartBean = (ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN);
        ccrz__E_Cart__c cartObj = [Select c.Use_Quote_Overrides__c, c.ccrz__EncryptedId__c,
                                (Select Id,quotedQty__c,QuotedPrice__c,ccrz__subAmount__c, ccrz__price__c, ccrz__quantity__c From ccrz__E_CartItems__r) 
                                From ccrz__E_Cart__c c
                                Where c.ccrz__EncryptedId__c =: cartBean.encryptedId][0];

        if(cartObj.Use_Quote_Overrides__c){
            Map<Id, ccrz__E_CartItem__c> cartItemObjMap = new Map<Id, ccrz__E_CartItem__c>();
            for(ccrz__E_CartItem__c cartItemObj : cartObj.ccrz__E_CartItems__r){
                if(cartItemObj.QuotedPrice__c != null){
                    cartItemObj.ccrz__Price__c = cartItemObj.QuotedPrice__c;
                    if(cartItemObj.quotedQty__c != null)
                        cartItemObj.ccrz__quantity__c = cartItemObj.quotedQty__c;
                    cartItemObj.ccrz__subAmount__c = cartItemObj.ccrz__price__c * cartItemObj.ccrz__quantity__c;
                }
                cartItemObjMap.put(cartItemObj.Id, cartItemObj);
            }
            
      for(ccrz.cc_bean_CartItem cartItem : cartBean.cartItems){
        if(cartItem.minorLines != null){
          for(ccrz.cc_bean_CartITem minorItem : cartItem.minorLines){
            ccrz__E_CartItem__c minorItemObj = cartItemObjMap.get(minorItem.itemID);

            if(minorItemObj != null){
              minorItem.price = minorItemObj.ccrz__Price__c;
              minorItem.quantity = Integer.valueOf(minorItemObj.ccrz__Quantity__c);
              minorItem.subAmount = minorItem.price * minorItem.quantity;
            }
          }
        } else {
          ccrz__E_CartItem__c cartItemObj = cartItemObjMap.get(cartItem.itemID);

                if(cartItemObj != null){
                    cartItem.price = cartItemObj.ccrz__Price__c;
                    cartItem.quantity = Integer.valueOf(cartItemObj.ccrz__Quantity__c);
                    cartItem.subAmount = cartItem.price * cartItem.quantity;
                }
            }
            }
            update cartObj.ccrz__E_CartItems__r;
            update cartObj;
            inputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN,cartBean);
        }
        return inputData;
    }
    
//    global override Map<String, Object> computePricingReview(Map<String, Object> inputData){
//        return computePricingCart(inputData);
//    }
}