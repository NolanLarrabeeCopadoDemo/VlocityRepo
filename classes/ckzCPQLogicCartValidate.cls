global with sharing class ckzCPQLogicCartValidate extends ccrz.ccLogicCartValidate {

    global override Map<String, Object> processValidate(Map<String, Object> inputData) {

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'inside processValidate' );

        Map<String, Object> skipSz = new Map<String, Object>(inputData);
        skipSz.put(ccrz.ccApi.SIZING, new Map<String, Object>{
                ccrz.ccApiCart.ENTITYNAME=>new Map<String, Object>{
                        ccrz.ccApi.SZ_DATA=>ccrz.ccApi.SZ_L
                        ,ccrz.ccApi.SZ_ASSC=>TRUE
                        ,ccrz.ccApi.SZ_SKIPTRZ=>FALSE
                }});
        Map<String,Object> fetchRes = ccrz.ccApiCart.fetch(skipSz);

        Map<String,Object> inputDataAccount = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiAccount.ID => ccrz.cc_CallContext.effAccountId
        };


        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'ccrz.cc_CallContext.effAccountId: ' + ccrz.cc_CallContext.effAccountId);

        // 2018-10-17 msobczak: commented out due to error
        //ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'fetchRes: ' + JSON.serialize(fetchRes));

        Boolean isAllowCheckout = true;
        List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();

        List<Map<String, Object>> outputCartList = null;

        if (fetchRes.get(ccrz.ccAPICart.CART_OBJLIST) != null) {
            outputCartList = (List<Map<String, Object>>) fetchRes.get(ccrz.ccAPICart.CART_OBJLIST);   // "cartList"
        }
        
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'outputCartList.size = ' + outputCartList.size());

        Boolean check1 = validateCartCustomMessage(fetchRes, ccrz.cc_CallContext.effAccountId, retMessages);

        isAllowCheckout = check1;


		// CPQ message
        Boolean check2 = cpqMessage(outputCartList.get(0), retMessages);
        isAllowCheckout = isAllowCheckout && check2;
        
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'processValidate.retMessages: ' + retMessages);

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'processValidate.isAllowCheckout: ' + isAllowCheckout);

        inputData.put(ccrz.ccApiCart.ALLOW_CHECKOUT, isAllowCheckout);
        inputData.put(ccrz.ccApi.MESSAGES, retMessages);
        inputData.putAll(ccrz.ccApiCart.fetch(inputData));
        return inputData;

    }
    
    private Boolean cpqMessage(Map<String, Object> cartMap, List<ccrz.cc_bean_Message> messages) {
        
        Boolean isAllowCheckout = false;
        
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'inside cpqMessage()');
        
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'cpqMessage.cartMap: ' + cartMap);
        
        String encryptedId = null;
        Boolean useQuoteOverrides = null;
        Boolean quoteNeeded = null;
        
        
        if(cartMap.containsKey('encryptedId')) {
            encryptedId = (String)cartMap.get('encryptedId');
        }
        
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'cpqMessage.encryptedId: ' + encryptedId);
        
        if(cartMap.containsKey('useQuoteOverrides')) {
            useQuoteOverrides = (Boolean)cartMap.get('useQuoteOverrides');
        }
        if(cartMap.containsKey('quoteNeeded')) {
            quoteNeeded = (Boolean)cartMap.get('quoteNeeded');
        }
   
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'cpqMessage.useQuoteOverrides: ' + useQuoteOverrides);
        
        if(quoteNeeded == true){
            if(useQuoteOverrides == true) {
                ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
                msg.message  = 'The prices and quantities shown reflect quoted amounts provided by your service representative.';
               // msg.labelId              = 'ThePricesAndQuantitiesShown';
                msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msg.severity = ccrz.cc_bean_Message.MessageSeverity.INFO;
                msg.classToAppend= 'messagingSection-Info';
                messages.add(msg);
                
                isAllowCheckout = true;
            }else{
                ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
                msg.message  = 'Please request quote';
                //msg.labelId              = 'ThePricesAndQuantitiesShown';
                msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msg.severity = ccrz.cc_bean_Message.MessageSeverity.INFO;
                msg.classToAppend= 'messagingSection-Info';
                messages.add(msg);
            }
        }else{
            isAllowCheckout = true;
        }

		ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'exit cpqMessage()');
        
        return isAllowCheckout;
    }

    /*
        This method ensures that if the user wants to buy a product that has a dependent SKU,
        The dependent SKU either is in the cart, or is an active subscription.
     */
    private Boolean validateCartCustomMessage (Map<String,Object> fetchRes, String effectiveAccountId, List<ccrz.cc_bean_Message> messages) {

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'inside validateCartCustomMessage()');

        Boolean isAllowCheckout = true;

        // Get the product list from the cart object
        List<Map<String, Object>> cartList = (List<Map<String, Object>>) fetchRes.get('cartList');

        for(Object obj : cartList) {

            Map<String, Object> cartMap = (Map<String, Object>)obj;

            String messageType = null;

            if(cartMap.containsKey('customMessageType')) {
                messageType = (String)cartMap.get('customMessageType');
            }

            String messageText = null;

            if(cartMap.containsKey('customMessageText')) {
                messageText = (String)cartMap.get('customMessageText');
            }

            if(messageType != null && messageType == 'Info') {
                ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message(messageText, ccrz.cc_bean_Message.MessageSeverity.INFO);
                msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msg.classToAppend = 'messagingSection-Info';
                messages.add(msg);
            }

            if(messageType != null && messageType == 'Error') {
                isAllowCheckout = false;

                ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message(messageText, ccrz.cc_bean_Message.MessageSeverity.ERROR);
                msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msg.classToAppend = 'messagingSection-Error';
                messages.add(msg);
            }

        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzCPQLogicCartValidate', 'validateCartCustomMessage.isAllowCheckout: ' + isAllowCheckout);

        return isAllowCheckout;

    }




}