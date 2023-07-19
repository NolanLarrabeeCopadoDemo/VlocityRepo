public with sharing class CPQB_CreateSalesAgreement {

    // Step #2: Create Sales Agreement Products from Quote Lines
    public static void handleAfterInsert(Map<Id,SalesAgreement> newAgreements) {
        for(SalesAgreement sa : newAgreements.values()) {
            Map<Id, List<SBQQ__QuoteLine__c>> quoteLinesListByPBE  = getQLsByPBId(sa.Quote__c);

            List<SalesAgreementProduct> saProds = new List<SalesAgreementProduct>();
            for(Id pbe : quoteLinesListByPBE.keySet()) {
                List<SBQQ__QuoteLine__c> qlines = quoteLinesListByPBE.get(pbe);
                Decimal sumPrice = 0;
                Decimal sumQuantity = 0;
                for(SBQQ__QuoteLine__c ql : qlines) {
                    sumPrice = sumPrice + ql.SBQQ__NetPrice__c;
                    sumQuantity = sumQuantity + ql.SBQQ__Quantity__c;
                }
                Decimal avgPrice = sumPrice / qlines.size();

                saProds.add(new SalesAgreementProduct(
                                                    Name=qlines[0].SBQQ__ProductName__c,
                                                    InitialPlannedQuantity=Integer.valueOf(sumQuantity),
                                                    SalesAgreementId=sa.Id,
                                                    PricebookEntryId=pbe,
                                                    SalesPrice=avgPrice));
            }

            try {
                Database.insert(saProds);
            } catch (DmlException e) {
                System.debug(e);
            }

        }

    }

    public static Map<Id, List<SBQQ__QuoteLine__c>> getQLsByPBId(Id quoteId) {
        Map<Id, List<SBQQ__QuoteLine__c>> qlMap = new Map<Id, List<SBQQ__QuoteLine__c>>();
        
        // Should we filter out subscriptions?
        // Filters out lines marked optional currently
        List<SBQQ__QuoteLine__c> qlines = [SELECT 
                                                Id,
                                                SBQQ__Quote__c,
                                                SBQQ__ProductName__c,
                                                SBQQ__Product__c,
                                                SBQQ__Quantity__c,
                                                SBQQ__PricebookEntryId__c,
                                                SBQQ__NetPrice__c,
                                                SBQQ__Optional__c,
                                                SBQQ__Number__c
                                            FROM SBQQ__QuoteLine__c
                                            WHERE SBQQ__Quote__c = :quoteId
                                            AND SBQQ__Optional__c = false
                                            ORDER BY SBQQ__Number__c ASC];

        
        for(SBQQ__QuoteLine__c qline : qlines) {
            if(qlMap.containsKey(qline.SBQQ__PricebookEntryId__c)) {
                List<SBQQ__QuoteLine__c> qlList = qlMap.get(qline.SBQQ__PricebookEntryId__c);
                qlList.add(qline);
                qlMap.put(qline.SBQQ__PricebookEntryId__c, qlList);
            } else {
                qlMap.put(qline.SBQQ__PricebookEntryId__c, new List<SBQQ__QuoteLine__c> { qline });
            }
        }

        return qlMap;
    }

}