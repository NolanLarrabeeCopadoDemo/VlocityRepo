/**
 *  Load Data for below Entities
 * 		1. LoyaltyLedger
 **/
public inherited sharing class LoyaltyLedgerDataLoader {

    public void createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramMemberDataLoader lpmdl, LoyaltyProgramEssentialsDataLoader lpedl) {
        if(dataMap.get('LoyaltyLedger') != null) {
            createLoyaltyLedgerData(dataMap.get('LoyaltyLedger'), lpmdl, lpedl);
        }
    }
    
    public void createLoyaltyLedgerData(LoyaltyData ledgerData, LoyaltyProgramMemberDataLoader lpmdl, LoyaltyProgramEssentialsDataLoader lpedl) {
        Map<String, Set<String>> currencyNames = new Map<String, Set<String>>();
        Set<String> programNames = new Set<String>();
        Set<String> membershipNumbers = new Set<String>();
        Set<String> externalTransactionNumbers = new Set<String>();
        
        for(String csvLine : ledgerData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            programNames.add(csvData[10]);
            externalTransactionNumbers.add(csvData[9]);
            membershipNumbers.add(csvData[7]);
            
            if(currencyNames.get(csvData[10]) == null) {
                currencyNames.put(csvData[10], new Set<String>());
            }
            currencyNames.get(csvData[10]).add(csvData[6]);
        }
        
        lpedl.retrieveProgramIds(programNames);
        Map<String, String> memberIds = lpmdl.retrieveLoyaltyProgramMemberIds(membershipNumbers);
        
        for(String programName : currencyNames.keySet()) {
            lpedl.retrieveCurrencyIds(lpedl.programIds.get(programName), currencyNames.get(programName));
        }
        Map<String, String> transactionIds = retrieveTransactionJournalIds(externalTransactionNumbers);
        
        List<LoyaltyLedger> ledgers = new List<LoyaltyLedger>();
        Integer count = 0;
        for(String csvLine : ledgerData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(lpedl.programIds.get(csvData[10]) == null) {
                throw new ValidationException('No program found named ' + csvData[10] + ' for Loyalty Ledger data');
            }
            if(lpedl.currencyIds.get(lpedl.programIds.get(csvData[10]) + '_' + csvData[6]) == null) {
                throw new ValidationException('No currency found named ' + csvData[6] + ' for Loyalty Ledger data');
            }
            if(transactionIds.get(csvData[9]) == null) {
                throw new ValidationException('No Transaction found with ETR ' + csvData[9] + ' for Loyalty Ledger data');
            }
            LoyaltyLedger ledger = new LoyaltyLedger(
                                                    ActivityDate = Utils.isEmptyOrNull(csvData[0]) ? null : Date.valueOf(csvData[0]),
                                                    AdditionalNotes = csvData[1],
                                                    Correlation = csvData[2],
                                                    EventType = csvData[3],
                                                    ExpiryDate = Utils.isEmptyOrNull(csvData[4]) ? null : Date.valueOf(csvData[4]),
                                                    Flow = csvData[5],
                                                    LoyaltyProgramCurrencyId = lpedl.currencyIds.get(lpedl.programIds.get(csvData[10]) + '_' + csvData[6]),
                                                    LoyaltyProgramMemberId = memberIds.get(csvData[7]),
                                                    Points = Utils.isEmptyOrNull(csvData[8]) ? null : Double.valueOf(csvData[8]),
                                                    TransactionJournalId = transactionIds.get(csvData[9])
            										);
            ledgers.add(ledger);
            count++;
            if(count == 200) {
                insert ledgers;
                ledgers.clear();
            }
            
        }
        if(count > 0) {
            insert ledgers;
        }
    }
    
    public Map<String, String> retrieveTransactionJournalIds(Set<String> externalTransactionNumbers) {
        TransactionJournal[] tjs = [select Id, ExternalTransactionNumber from TransactionJournal where ExternalTransactionNumber in :externalTransactionNumbers WITH SECURITY_ENFORCED];
        Map<String, String> transactionIds = new Map<String, String>();
        for(TransactionJournal tj : tjs) {
            transactionIds.put(tj.ExternalTransactionNumber, tj.Id);
        }
        return transactionIds;
    }
}