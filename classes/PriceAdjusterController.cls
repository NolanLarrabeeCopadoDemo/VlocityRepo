public with sharing class PriceAdjusterController {

    @AuraEnabled
    public static Contract[] getActiveContracts(){
        // System.debug('getAccountContracts accountId' + accountId);
        Contract[] contracts = [
            SELECT Id, AccountId, Account.Name, Account.BillingAddress, ContractNumber, StartDate, EndDate, ContractTerm, Status 
            FROM Contract 
            WHERE Status = 'Activated'];
        System.debug(contracts);
        return contracts;
    }


    @AuraEnabled
    public static void submitForPriceAdjustment(String productFamily, String billingCountry, Decimal adjustment){
        try {
            Contract[] contracts = [
            SELECT Id, AccountId, Account.Name, Account.BillingAddress, ContractNumber, StartDate, EndDate,
                    ContractTerm, Status, SBQQ__Quote__c, Don_Total__c
            FROM Contract
            WHERE Status = 'Activated' AND Account.BillingCountry = :billingCountry AND (NOT Account.Name like 'Acme%')];

            SBQQ__Subscription__c[] subscriptions = new List<SBQQ__Subscription__c>();

            for(Contract contract : contracts){
                subscriptions = [
                    SELECT Id, SBQQ__Product__c, SBQQ__NetPrice__c, SBQQ__Product__r.family 
                    FROM SBQQ__Subscription__c
                    Where SBQQ__Contract__c = :contract.Id
                ];

                for(SBQQ__Subscription__c subscription : subscriptions)
                {
                    if(subscription.SBQQ__Product__r.family == productFamily)
                    {
                        subscription.SBQQ__NetPrice__c = subscription.SBQQ__NetPrice__c + (subscription.SBQQ__NetPrice__c * (adjustment/100));
                        update subscription;
                        System.debug('updated Sub : ' + subscription);
                    }
                }
                if(contract.Don_Total__c != null)
                {
                    contract.Don_Total__c = contract.Don_Total__c + (contract.Don_Total__c * (adjustment/100));    
                    update contract;
                    System.debug('updated Contract : ' + contract.Don_Total__c);    
                }
            }
            return;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}