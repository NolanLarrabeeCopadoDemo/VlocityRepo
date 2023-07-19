trigger EinsteinBotsInit_Chat on LiveChatTranscript (before insert) {
  for (LiveChatTranscript lct : Trigger.New){
    if(lct.ChatEndUserId__c != null){
    List<User> thisUser = [SELECT Id, ContactId FROM User WHERE Id = :lct.ChatEndUserId__c];
      if(thisUser.size() > 0){
        lct.ContactId = thisUser[0].ContactId;
        List<Contact> thisContact = [SELECT Id, AccountId FROM Contact WHERE Id = :lct.ContactId];
        if(thisContact.size() > 0){
          lct.AccountId = thisContact[0].AccountId;
          Case newCase = new Case();
          newCase.subject = 'No, it\'s something else';
          newCase.Origin = 'Chat';
          newCase.contactId = thisContact[0].Id;
          try{
              insert newCase;
              lct.CaseId = newCase.Id;
          } catch(dmlexception e){
              system.debug('Case creation error: ' + e);
          }  
        }   
      }
    }            
  }
}