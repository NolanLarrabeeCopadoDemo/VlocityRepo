public class AccountAndContactDataLoader {

    public Map<String, String> accountIds = new Map<String, String>();
    public Map<String, String> contactIds = new Map<String, String>();
    public Map<String,Boolean> partnerValues=new Map<String,Boolean>();
    
    public void createData(Map<String, LoyaltyData> dataMap) {
        if(dataMap.get('AccountAndContact') != null) {
            createAccountAndContact(dataMap.get('AccountAndContact'));
        }
    }
    
    public void createAccountAndContact(LoyaltyData accountData) {
        Set<String> accountNames=LoyaltyDataLoadController.getFieldValues(accountData, 0);
        retrieveAccountIds(accountNames);
        List<Account> allAccounts=new List<Account>();
	    for(String csvLine : accountData.csvLines) {
			String[]  csvData=LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(Utils.isEmptyOrNull(csvData[0])){
                throw new ValidationException('Please provide a valid account name');
            }
            if(accountIds.containsKey(csvData[0])){
                continue;
            }
            Account account=new Account(Name=csvData[0]);
            if(csvData.size()>=5){
                account.IsProgramMember__c=Utils.isEmptyOrNull(csvData[4])?false:Boolean.valueOf(csvData[4]);
            }
            if(csvData.size()>=6){
                partnerValues.put(account.Name,Utils.isEmptyOrNull(csvData[5])?false:Boolean.valueOf(csvData[5]));
            }
            allAccounts.add(account);
			           
        }
        DMLManager.DBInsert(allAccounts);
        List<Account> enablePartnerAccounts=new List<Account>();
        for(Account account:allAccounts){
				accountIds.put(account.Name,account.Id);
            	if(partnerValues.containsKey(account.Name)){
                		account.IsPartner=partnerValues.get(account.Name);
              		    enablePartnerAccounts.add(account);
                    
        		}
        }
        
        DMLManager.DBUpdate(enablePartnerAccounts);
      
        
        for(String csvLine : accountData.csvLines) {
			String[]  csvData=LoyaltyDataLoadController.splitCsvLine(csvLine);
       		    if(csvData.size()>=3){
                if(Utils.isEmptyOrNull(csvData[2])){
                    throw new ValidationException('Please provide a valid contact last name');
                }
                if(contactIds.containsKey(csvData[1]+' '+csvData[2])){
                    continue;
                }
				Contact contact=new Contact();
				contact.AccountId=accountIds.get(csvData[0]);
                if(csvData.size()>=4)
					contact.Email=csvData[3];
				contact.LastName=csvData[2];
				contact.FirstName=csvData[1];
				DMLManager.DBInsert(contact);                
                }
       }

    }

	public Map<String, String> retrieveAccountIds(Set<String> accountNames){
        Set<String> namesToQuery = new Set<String>();
        for(String accountName : accountNames) {
            if(accountIds.get(accountName) == null) {
                namesToQuery.add(accountName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            Account[] accounts = [select Id, Name from Account where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(Account account : accounts) {
                accountIds.put(account.Name, account.Id);
            }
        }
        
        return accountIds;
    }
    
	public Map<String, String> retrieveContactIds(Set<String> contactNames){
        Set<String> namesToQuery = new Set<String>();
        for(String contactName : contactNames) {
            if(contactIds.get(contactName) == null) {
                namesToQuery.add(contactName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            Contact[] contacts = [select Id, Name from Contact where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(Contact contact : contacts) {
                contactIds.put(contact.Name, contact.Id);
            }
        }
        
        return contactIds;
    } 
    
    public Map<String, String> upsertAccounts(Set<String> accountNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String accountName : accountNames) {
            if(accountIds.get(accountName) == null) {
                namesToQuery.add(accountName);
            }
        }
        if(namesToQuery.size() > 0) {
            Account[] acs = [select Id, Name from Account where Name in :namesToQuery WITH SECURITY_ENFORCED];
            for(Account ac : acs) {
                accountIds.put(ac.Name, ac.Id);
            }
            
            List<Account> accounts = new List<Account>();
            Integer count = 0;
            for(String accountName : accountNames) {
                List<String> acctNames=new List<String>();
                acctNames.add(accountName);
                if(accountIds.get(accountName) == null) {
                    Account account = new Account(
                                                    Name = acctNames[0]
                        						 );
                    accounts.add(account);
                    count++;
                    if(count == 200) {
                        insert accounts;
                        for(Account ac : accounts) {
                            accountIds.put(ac.Name, ac.Id);
                        }
                        accounts.clear();
                        count = 0;
                    }
                }
            }
            if(count > 0) {
                insert accounts;
                for(Account ac : accounts) {
                    accountIds.put(ac.Name, ac.Id);
                }
            }
        }
        return accountIds;
    }
}