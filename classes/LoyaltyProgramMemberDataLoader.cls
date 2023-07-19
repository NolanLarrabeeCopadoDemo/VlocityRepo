/**
 *  Load Data for below Entities
 * 		1. LoyaltyProgramMember
 * 		2. LoyaltyMemberCurrency
 * 		3. LoyaltyMemberTier
 **/
public inherited sharing class LoyaltyProgramMemberDataLoader {
    
    private final String MEMBER_TYPE = 'Corporate';
    public Map<String,String> pcurrency=new Map<String,String>();
    public Map<String, String> memberIds = new Map<String, String>();
    public boolean check=false;
    
    public LoyaltyProgramMemberDataLoader(){
        check=false;
    }
    public void createData(Map<String, LoyaltyData> dataMap, LoyaltyProgramEssentialsDataLoader lpedl,AccountAndContactDataLoader accountDataLoader) {
        if(dataMap.get('LoyaltyProgramMember') != null) {
            createLoyaltyProgramMember(dataMap.get('LoyaltyProgramMember'), lpedl,accountDataLoader);
        }
    }

    public void createLoyaltyProgramMember(LoyaltyData memberData, LoyaltyProgramEssentialsDataLoader lpedl,AccountAndContactDataLoader accountDataLoader) {
        Set<String> loyaltyMemberCurrency = LoyaltyDataLoadController.getFieldValues(memberData, 14);        
        lpedl.retrieveProgramAndTierGroupIds(memberData, 9, 10);
        Map<String,String> contactIds=accountDataLoader.retrieveContactIds(LoyaltyDataLoadController.getFieldValues(memberData, 19));
		Map<String, String> accountIds =accountDataLoader.retrieveAccountIds(LoyaltyDataLoadController.getFieldValues(memberData, 1));

        Map<String, Set<String>> tierGroupTierMap = new Map<String, Set<String>>();
        
        for(String csvLine : memberData.csvLines) {
			String[]  csvData=LoyaltyDataLoadController.splitCsvLine(csvLine);
            if (lpedl.programIds.get(csvData[9]) == null) {
                throw new ValidationException('No Program found named ' + csvData[9] + ' in Program Member Data');
            }
            String tierGroupId = lpedl.tierGroupIds.get(lpedl.programIds.get(csvData[9]) + '_' + csvData[10]);
            
            if (tierGroupId == null) {
                throw new ValidationException('No Tier Group found named ' + csvData[10] + ' in Program Member Data');
            }
            
            if (tierGroupTierMap.get(tierGroupId) == null) {
				tierGroupTierMap.put(tierGroupId, new Set<String>());
            }
			tierGroupTierMap.get(tierGroupId).add(csvData[11]);
        }
		
        for(String tierGroupId:tierGroupTierMap.keySet()) {
        	lpedl.retrieveTierIds(tierGroupId, tierGroupTierMap.get(tierGroupId));
        }
        tierGroupTierMap.clear();
        

        List<LoyaltyProgramMember> members = new List<LoyaltyProgramMember>();
        Integer count=0;
		
        for(String csvLine : memberData.csvLines) {
			String[]  csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(memberIds.get(csvData[0]) == null) {
                LoyaltyProgramMember member = new LoyaltyProgramMember(
                                                                        MembershipNumber = csvData[0],
                                                                        AccountId = accountIds.get(csvData[1]),
                                                                        MemberStatus = csvData[2],
                                                                        EnrollmentChannel = csvData[3],
                                                                        EnrollmentDate = Utils.isEmptyOrNull(csvData[4]) ? null : Date.valueOf(csvData[4]),
                                                                        PartnershipStartDate__c = Utils.isEmptyOrNull(csvData[5]) ? null : Date.valueOf(csvData[5]),
                                                                        TeamTrainedPercentage__c = Double.valueOf(csvData[6]),
                                                                        QuarterlyConferenceAttended__c = Integer.valueOf(csvData[7]),
                                                                        BrandingPercentage__c = Double.valueOf(csvData[8]),
                                                                        ProgramId = lpedl.programIds.get(csvData[9]),
                                                                        MemberType= MEMBER_TYPE,
                    													SeedData__c = true
                													);
                if(csvData.size()>=20){
                    member.ContactId=contactIds.get(csvData[19]);
                    System.debug(member.ContactId);
                }
                members.add(member);
                count++;
                if (count == 200) {
                    insert members;
                    for(LoyaltyProgramMember lpm : members) {
                        memberIds.put(lpm.MembershipNumber, lpm.Id);
                    }                    
                    count=0;
                    members.clear();             
                }
            }
        }
        
        if(count > 0) {
            insert members;
            for(LoyaltyProgramMember lpm : members) {
				memberIds.put(lpm.MembershipNumber, lpm.Id);
			}                    
            members.clear();
        }

         updateLoyaltyMemberCurrency(memberIds, memberData.csvLines, lpedl,memberData);
         updateTiers(memberIds,memberData.csvLines,lpedl);
        
    }
    public void updateTiers(Map<String,String> memberIds,String[] csvLines,LoyaltyProgramEssentialsDataLoader lpedl){
		Set<String> memIds=new Set<String>();
        for(String key:memberIds.keySet())
        {
            memIds.add(memberIds.get(key));
        }
        Map<String,LoyaltyMemberTier> mtiers=retriveMemberTierIds(memIds);
        Integer updateCount=0;
        Integer insertCount=0;
        List<LoyaltyMemberTier> insertTierList=new List<LoyaltyMemberTier>();        
        List<LoyaltyMemberTier> updateTierList=new List<LoyaltyMemberTier>();
        for(String csvLine:csvLines){
            String[] csvData=LoyaltyDataLoadController.splitCsvLine(csvLine);
            LoyaltyMemberTier lmt;
            if(mtiers.get(memberIds.get(csvData[0]))!=null){
				lmt=mtiers.get(memberIds.get(csvData[0]));
                lmt.Name = csvData[11];
                updateTierList.add(lmt);
                updateCount++;
            }
            else{
                lmt=new LoyaltyMemberTier(
                                            LoyaltyMemberId=memberIds.get(csvData[0]),
                                            LoyaltyTierGroupId=lpedl.tierGroupIds.get(lpedl.programIds.get(csvData[9])+'_'+csvData[10]),
                                            Name=csvData[11]
                						);
                insertTierList.add(lmt);
                insertCount++;
            }
				lmt.LoyaltyTierId=lpedl.getTierId(csvData[11], csvData[10], csvData[9]);
                lmt.EffectiveDate=Utils.isEmptyOrNull(csvData[12]) ? null : Date.valueOf(csvData[12]);
                lmt.TierExpirationDate=Utils.isEmptyOrNull(csvData[13]) ? null : Date.valueOf(csvData[13]);
            
            if(insertCount==200){
                insert insertTierList;
                insertCount=0;
                insertTierList.clear();
            }
            if(updateCount==1000){
                update updateTierList;
                updateCount=0;
                updateTierList.clear();
            }
        }
        
        
        if(insertCount!=0){
                insert insertTierList;
                insertTierList.clear();
            
        }
        if(updateCount!=0){
                update updateTierList;
                updateTierList.clear();
        }
        

    }
    private Map<String,LoyaltyMemberTier> retriveMemberTierIds(Set<String> memberIds){
        Map<String,LoyaltyMemberTier> ans=new Map<String,LoyaltyMemberTier>();
        List<LoyaltyMemberTier> tiers= [Select Id,Name,LoyaltyTierGroupId,LoyaltyTierId,LoyaltyMemberId,EffectiveDate,TierExpirationDate  From LoyaltyMemberTier where LoyaltyMemberId in :memberIds WITH SECURITY_ENFORCED];
        for(LoyaltyMemberTier tier:tiers){
            ans.put(tier.LoyaltyMemberId,tier);
        }
        
        return ans; 
    }
    private void updateLoyaltyMemberCurrency(Map<String, String> memberIds, String[] csvLines, LoyaltyProgramEssentialsDataLoader lpedl,LoyaltyData memberData) {
        Set<String> memIds=new Set<String>();
        for(String key:memberIds.keySet())
        {
            memIds.add(memberIds.get(key));
        }
        Map<String,LoyaltyMemberCurrency> mcurrencies=retriveMemberCurrencyIds(memIds);
        
        Map<String,String> pcid=retriveLoyaltyProgramCurrencyIds(LoyaltyDataLoadController.getFieldValues(memberData, 14));
		List<LoyaltyMemberCurrency> lmclistupdate=new List<LoyaltyMemberCurrency>();
        
        List<LoyaltyMemberCurrency> lmclistinsert=new List<LoyaltyMemberCurrency>();

        Integer updateCount=0;
        Integer insertCount=0;
        
        for(String csvLine:csvLines)
        {
           String[] csvData=LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(pcid.get(csvData[14])==null) {
                throw new ValidationException('No currency found for '+csvData[14]);
            }
            LoyaltyMemberCurrency lmc;
            if(mcurrencies.get(memberIds.get(csvData[0])) !=null){
               lmc= mcurrencies.get(memberIds.get(csvData[0]));
               if(csvData.size()>=16 &&  !Utils.isEmptyOrNull(csvData[15]))
                   lmc.TotalPointsAccrued=Double.valueOf(csvData[15]); 
               if(csvData.size()>=17 &&   !Utils.isEmptyOrNull(csvData[16])) 
                   lmc.TotalPointsRedeemed=Double.valueOf(csvData[16]);
               if(csvData.size()>=18 &&   !Utils.isEmptyOrNull(csvData[17])) 
                   lmc.TotalPointsExpired=Double.valueOf(csvData[17]); 
               if(csvData.size()>=19  && !Utils.isEmptyOrNull(csvData[18])) 
                   lmc.LastExpirationProcessRunDate=Date.valueOf(csvData[18]);
               if(check) 
               	   lmc.LastAccrualProcessedDate=Datetime.now(); 
			   lmclistupdate.add(lmc);
               updateCount++; 
            }else
            {
                 lmc=new LoyaltyMemberCurrency(
                                                 Name=csvData[14],
                                                 LoyaltyProgramCurrencyId=pcid.get(csvData[14]),
                                                 LoyaltyMemberId=memberIds.get(csvData[0])
                                             );
 
               if(csvData.size()>=16 &&  !Utils.isEmptyOrNull(csvData[15]))
                   lmc.TotalPointsAccrued=Double.valueOf(csvData[15]); 
               if(csvData.size()>=17 &&   !Utils.isEmptyOrNull(csvData[16])) 
                   lmc.TotalPointsRedeemed=Double.valueOf(csvData[16]);
               if(csvData.size()>=18 &&   !Utils.isEmptyOrNull(csvData[17])) 
                   lmc.TotalPointsExpired=Double.valueOf(csvData[17]); 
               if(csvData.size()>=19  && !Utils.isEmptyOrNull(csvData[18])) 
                   lmc.LastExpirationProcessRunDate=Date.valueOf(csvData[18]);
               if(check) 
               	   lmc.LastAccrualProcessedDate=Datetime.now();
                 lmclistinsert.add(lmc);
                 insertCount++;
            }
            
            if(updateCount==1000)
            {
                update lmclistupdate;
                updateCount=0;
                lmclistupdate.clear();
            }
            if(insertCount==200){
                insert lmclistinsert;
                insertCount=0;
                lmclistinsert.clear();
            }
                        
        }
        
        if(updateCount!=0)
        {
       		    update lmclistupdate;
                lmclistupdate.clear();   
        }
        
        if(insertCount!=0){
                insert lmclistinsert;
                lmclistinsert.clear();

        }
        
        
    }
    
    public Map<String,LoyaltyMemberCurrency> retriveMemberCurrencyIds(Set<String> memberList) {
        List<LoyaltyMemberCurrency> currencies= [Select Id,Name,TotalPointsAccrued,LoyaltyMemberId,LoyaltyProgramCurrencyId from LoyaltyMemberCurrency where LoyaltyMemberId in :memberList  WITH SECURITY_ENFORCED];
		Map<String,LoyaltyMemberCurrency> lmcsmap=new Map<String,LoyaltyMemberCurrency>();
        for(LoyaltyMemberCurrency lmc:currencies){
            lmcsmap.put(lmc.LoyaltyMemberId,lmc);
        }
        return lmcsmap;
    }


    public Map<String,String> retriveLoyaltyProgramCurrencyIds(Set<String> currencyName) {
        List<LoyaltyProgramCurrency> cl= [Select Name,Id  from LoyaltyProgramCurrency where Name in :currencyName  WITH SECURITY_ENFORCED];
		Map<String,String> mymap=new Map<String,String>();
        for(LoyaltyProgramCurrency lpc:cl)
            pcurrency.put(lpc.Name,lpc.id);
        return pcurrency;
    }

    
   
    
    public Map<String, String> retrieveLoyaltyProgramMemberIds(Set<String> membershipNumbers){
        Set<String> namesToQuery = new Set<String>();
        for(String membershipNumber : membershipNumbers) {
            if(memberIds.get(membershipNumber) == null) {
                namesToQuery.add(membershipNumber);
            }
        }
        
        if(namesToQuery.size() > 0) {
            LoyaltyProgramMember[] lpms = [select Id, MembershipNumber from LoyaltyProgramMember where MembershipNumber in :namesToQuery WITH SECURITY_ENFORCED];
            for(LoyaltyProgramMember lpm : lpms) {
                memberIds.put(lpm.MembershipNumber, lpm.Id);
            }
        }
        
        return memberIds;
    }
    
}