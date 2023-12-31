global with sharing class ckzPOCLogicCartValidate extends ccrz.ccLogicCartValidate {

    global override Map<String, Object> processValidate(Map<String, Object> inputData) {

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'inside processValidate' );

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


        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'ccrz.cc_CallContext.effAccountId: ' + ccrz.cc_CallContext.effAccountId);

        // 2018-10-17 msobczak: commented out due to error
        //ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'fetchRes: ' + JSON.serialize(fetchRes));

        Boolean isAllowCheckout = false;
        List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();

        List<Map<String, Object>> outputCartList = null;

        if (fetchRes.get(ccrz.ccAPICart.CART_OBJLIST) != null) {
            outputCartList = (List<Map<String, Object>>) fetchRes.get(ccrz.ccAPICart.CART_OBJLIST);   // "cartList"
        }

        Boolean check1 = validateCartCustomMessage(fetchRes, ccrz.cc_CallContext.effAccountId, retMessages);

        isAllowCheckout = check1;


        // User Roles validation
        Map<String,Object> inputConfigData = new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION
                ,ccrz.ccApiConfig.STORE_NAME => ccrz.cc_CallContext.storefront
                ,ccrz.ccApiConfig.PAGE_NAME => 'all'
                ,ccrz.ccApiConfig.USE_CACHE => TRUE
                ,ccrz.ccApiConfig.EXTERNALLY_SAFE => TRUE
                ,ccrz.ccApiConfig.RETURN_SERIAL => FALSE
        };

        Map<String, String> configMap = (Map<String, String>)ccrz.ccAPIConfig.fetch(inputConfigData).get(ccrz.ccAPIConfig.CONFIGURATIONS);

        String budlim = configMap.get('ma.budlim');

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'budlim: ' + budlim);

        if(budlim == 'TRUE') {
            isAllowCheckout = isAllowCheckout && validateUserRoles(outputCartList, retMessages);
        }


        // Credit Limit validation
        String credlim = configMap.get('ma.credlim');

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'credlim: ' + credlim);

        if(credlim == 'TRUE') {
            isAllowCheckout = isAllowCheckout && validateCreditLimit(outputCartList, retMessages);
        }


        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'processValidate.retMessages: ' + retMessages);

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'processValidate.isAllowCheckout: ' + isAllowCheckout);

        inputData.put(ccrz.ccApiCart.ALLOW_CHECKOUT, isAllowCheckout);
        inputData.put(ccrz.ccApi.MESSAGES, retMessages);
        inputData.putAll(ccrz.ccApiCart.fetch(inputData));
        return inputData;

    }

    /*
        This method ensures that if the user wants to buy a product that has a dependent SKU,
        The dependent SKU either is in the cart, or is an active subscription.
     */
    private Boolean validateCartCustomMessage (Map<String,Object> fetchRes, String effectiveAccountId, List<ccrz.cc_bean_Message> messages) {

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'inside validateCartCustomMessage()');

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


        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'validateCartCustomMessage.isAllowCheckout: ' + isAllowCheckout);

        return isAllowCheckout;

    }

    private Boolean validateUserRoles(List<Map<String, Object>> outputCartList, List<ccrz.cc_bean_Message> messages) {

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'inside validateUserRoles()');

        Boolean isAllowCheckout = false;

        Double totalAmount = 0.0;
        Double budgetLimit = 0.0;
        Double budgetOverride = 0.0;
        Boolean approvedForCheckout = false;
        Boolean approvalRequested = false;

        if(outputCartList[0].get('totalAmount') != null) {
            totalAmount = (Double) outputCartList[0].get('totalAmount');
        }
        if(outputCartList[0].get('budgetOverride') != null) {
            budgetOverride = (Double) outputCartList[0].get('budgetOverride');
        }

        if(outputCartList[0].get('budgetApprovedforCheckout') != null) {
            approvedForCheckout = (Boolean) outputCartList[0].get('budgetApprovedforCheckout');
        }

        if(outputCartList[0].get('budgetApprovalRequested') != null) {
            approvalRequested = (Boolean) outputCartList[0].get('budgetApprovalRequested');
        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'totalAmount: ' + totalAmount );
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'budgetOverride: ' + budgetOverride );
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'approvedForCheckout: ' + approvedForCheckout );
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'approvalRequested: ' + approvalRequested );

        ckz_bean_UserRoles userRoles = ckz_util_UserRoles.getUserRoles(ccrz.cc_CallContext.currContact.Id);

        if(userRoles.budgetLimit != null && userRoles.budgetLimit != 0) {
            budgetLimit = userRoles.budgetLimit;
        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'userRoles.budgetLimit: ' + userRoles.budgetLimit);
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'userRoles.canOrder: ' + userRoles.canOrder);
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'userRoles.requiresApproval: ' + userRoles.requiresApproval);

        if (!userRoles.canOrder) {
            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 1');

            isAllowCheckout = false;
            ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
            msgErr.message = 'You are not authorized to complete orders.';
            msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msgErr.classToAppend = 'messagingSection-Info';

            messages.add(msgErr);

            return false;
        }

        // User can order, has no budget limit and does not need approval
        if(budgetLimit == 0 && userRoles.requiresApproval == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 2');
            isAllowCheckout = true;
        }

        // User has requested approval, but the Case has not yet been approved.
        if(approvalRequested && approvedForCheckout == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 3');

            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
            msg.labelId              = 'BudgetOverrideRequested' ;
            msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM ;
            msg.severity             = ccrz.cc_bean_Message.MessageSeverity.INFO ;
            msg.classToAppend        = 'messagingSection-Info';

            messages.add(msg);

            return false;
        }

        // Case was approved and user has no budget limit.
        if(approvedForCheckout && budgetLimit == 0) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 4');
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
            msg.labelId              = 'BudgetOverrideApproved' ;
            msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM ;
            msg.severity             = ccrz.cc_bean_Message.MessageSeverity.INFO ;
            msg.classToAppend        = 'messagingSection-Info';

            messages.add(msg);

            return true;
        }

        // Approval required but not yet requested.
        if (userRoles.requiresApproval && approvalRequested == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 5');
            ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
            msgErr.message = 'This order will require approval before being finalized.';
            msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msgErr.classToAppend = 'messagingSection-Info';

            messages.add(msgErr);

            return false;
        }

        /* User has a budget limit, the total amount is less than the budget limit and approval is not required
         * OR
         * User has a budget limit, the total amount is less than the budget limit and approval is required and has been received.
         * 2018-10-19  msobczak: without this additional logic, all of the checks are bypassed and isAllowCheckout remains False.
        */
        if (budgetLimit > 0 && totalAmount <= budgetLimit && ( (userRoles.requiresApproval == false) || (userRoles.requiresApproval == true && approvedForCheckout) ) ) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 5.1');

            isAllowCheckout = True;

        }

        // User has a budget limit, but the total amount exceeds that and approval has not been requested.
        //if (budgetLimit > 0 && userRoles.requiresApproval == false && approvalRequested == false) {
        if (budgetLimit > 0 && totalAmount > budgetLimit && approvalRequested == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 5.2');
            ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
            msgErr.message = 'This order exceeds your available budget of ' + budgetLimit;
            msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msgErr.classToAppend = 'messagingSection-Info';

            messages.add(msgErr);

            return false;
        }

        if(approvedForCheckout && budgetLimit != 0 && totalAmount > budgetLimit && totalAmount > budgetOverride) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 6');
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
            msg.labelId              = 'BudgetOverrideInsufficient';
            msg.severity             = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msg.classToAppend        = 'messagingSection-Info';

            messages.add(msg);

            return false;
        }

        // User has not requested approval yet
        if (userRoles.budgetLimit > 0 && approvalRequested == false) {

            if (totalAmount > budgetLimit) {
                if(budgetOverride == null){

                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 7');
                    ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
                    msgErr.message = 'This order exceeds your available budget of ' + budgetLimit;
                    //msgErr.labelId = 'BudgetAmountExceededRequestApproval';
                    msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
                    msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                    msgErr.classToAppend = 'messagingSection-Info';

                    messages.add(msgErr);

                }
            }

        }

        if (approvedForCheckout == true) {
            if(budgetLimit == 0) {

                ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 8');
                isAllowCheckout = true;
                ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
                msgErr.message = 'Your cart has been approved!';
                msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.SUCCESS;
                msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msgErr.classToAppend = 'messagingSection-Info';

                messages.add(msgErr);
            }
            else {
                if (totalAmount <= budgetOverride) {

                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 9');
                    isAllowCheckout = true;
                    ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
                    msgErr.message = 'Your cart has been approved with a budget of: ' + budgetOverride;
                    msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.SUCCESS;
                    msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                    msgErr.classToAppend = 'messagingSection-Info';

                    messages.add(msgErr);
                }
            }

        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'validateUserRoles() result: isAllowCheckout: ' + isAllowCheckout);

        return isAllowCheckout;
    }

    private Boolean validateCreditLimit(List<Map<String, Object>> outputCartList, List<ccrz.cc_bean_Message> messages) {

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'inside validateCreditLimit()');

        Boolean isAllowCheckout = false;

        Double totalAmount = 0.0;
        Double creditLimit = 0.0;
        Double creditOverride = 0.0;
        Boolean approvedforCheckout = false;
        Boolean approvalRequested = false;

        if(outputCartList[0].get('totalAmount') != null) {
            totalAmount = (Double) outputCartList[0].get('totalAmount');
        }
        if(outputCartList[0].get('creditOverride') != null) {
            creditOverride = (Double) outputCartList[0].get('creditOverride');
        }

        if(outputCartList[0].get('creditOverrideApprovedforCheckout') != null) {
            approvedForCheckout = (Boolean) outputCartList[0].get('creditOverrideApprovedforCheckout');
        }

        if(outputCartList[0].get('creditOverrideRequested') != null) {
            approvalRequested = (Boolean) outputCartList[0].get('creditOverrideRequested');
        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'totalAmount: ' + totalAmount );
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'creditOverride: ' + creditOverride );
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'approvedForCheckout: ' + approvedForCheckout );
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'approvalRequested: ' + approvalRequested );

        String effectiveAccountId = ccrz.cc_CallContext.effAccountId;

        /*
        String effectiveAccountId = '';

        if(ctx.effAccountId != null && ctx.effAccountId != '') {
            effectiveAccountId = ctx.effAccountId;
        }
        else {
            effectiveAccountId = ccrz.cc_CallContext.effAccountId;
        }
        */

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'effectiveAccountId: ' + effectiveAccountId);

        Account account = [Select Id, Name, ckz_B2B_Credit_Limit__c from Account where Id = :effectiveAccountId];

        Boolean hasCreditLimit = false;

        if(account.ckz_B2B_Credit_Limit__c != null || account.ckz_B2B_Credit_Limit__c > 0) {
            hasCreditLimit = true;
            creditLimit = account.ckz_B2B_Credit_Limit__c;
        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'hasCreditLimit: ' + hasCreditLimit);
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'creditLimit: ' + creditLimit);

        // User can order, account has no credit limit and does not need approval
        if(hasCreditLimit == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 2');
            isAllowCheckout = true;
        }

        // User has requested approval, but the Case has not yet been approved.
        if(approvalRequested && approvedForCheckout == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 3');

            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
            msg.labelId              = 'CreditOverrideRequested' ;
            msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM ;
            msg.severity             = ccrz.cc_bean_Message.MessageSeverity.INFO ;
            msg.classToAppend        = 'messagingSection-Info';

            messages.add(msg);

            return false;
        }

        // Case was approved and user has no budget limit.
        if(approvedForCheckout && creditLimit == 0) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 4');
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
            msg.labelId              = 'CreditOverrideApproved' ;
            msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM ;
            msg.severity             = ccrz.cc_bean_Message.MessageSeverity.INFO ;
            msg.classToAppend        = 'messagingSection-Info';

            messages.add(msg);

            return true;
        }
        /*
        if (approvalRequested == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 5');
            ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
            msgErr.message = 'This order will require approval before being finalized.';
            msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msgErr.classToAppend = 'messagingSection-Info';

            messages.add(msgErr);

            return false;
        }

        if (creditLimit > 0 && approvalRequested == false) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 5.1');
            ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
            msgErr.message = 'This order will require approval before being finalized.';
            msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msgErr.classToAppend = 'messagingSection-Info';

            messages.add(msgErr);

            return false;
        }
        */
        if(approvedForCheckout && creditLimit != 0 && totalAmount > creditLimit && totalAmount > creditOverride) {

            ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 6');
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
            msg.labelId              = 'CreditOverrideInsufficient';
            msg.severity             = ccrz.cc_bean_Message.MessageSeverity.ERROR;
            msg.type                 = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msg.classToAppend        = 'messagingSection-Info';

            messages.add(msg);

            return false;
        }

        // User has not requested approval yet
        if (creditLimit > 0 && approvalRequested == false) {

            if (totalAmount > creditLimit) {
                if(creditOverride == null || creditOverride == 0){

                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 7');
                    ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
                    msgErr.message = 'This order exceeds your available credit limit of ' + creditLimit;
                    //msgErr.labelId = 'BudgetAmountExceededRequestApproval';
                    msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.ERROR;
                    msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                    msgErr.classToAppend = 'messagingSection-Info';

                    messages.add(msgErr);

                }
            }
            else {
                isAllowCheckout = true;
            }

        }

        if (approvedForCheckout == true) {
            if(creditLimit == 0) {

                ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 8');
                isAllowCheckout = true;
                ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
                msgErr.message = 'Your cart has been approved!';
                msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.SUCCESS;
                msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msgErr.classToAppend = 'messagingSection-Info';

                messages.add(msgErr);
            }
            else {
                if (totalAmount <= creditOverride) {

                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'check 9');
                    isAllowCheckout = true;
                    ccrz.cc_bean_Message msgErr = new ccrz.cc_bean_Message();
                    msgErr.message = 'Your cart has been approved with a credit override of: ' + creditOverride;
                    msgErr.severity = ccrz.cc_bean_Message.MessageSeverity.SUCCESS;
                    msgErr.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                    msgErr.classToAppend = 'messagingSection-Info';

                    messages.add(msgErr);
                }
            }

        }

        ccrz.ccLog.log(System.LoggingLevel.INFO, 'ckzPOCLogicCartValidate', 'validateCreditLimit - isAllowCheckout: ' + isAllowCheckout);

        return isAllowCheckout;
    }

}