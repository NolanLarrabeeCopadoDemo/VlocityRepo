trigger EinsteinBotsCleanup_Chat on LiveChatTranscript (after update) {
  for (LiveChatTranscript lct : Trigger.New){
    if(lct.Status == 'Completed' || lct.Status == 'Missed'){
      Case[] thisCase = [SELECT Id, Subject FROM Case WHERE Id = :lct.CaseId];
      if(thisCase[0].Subject.Contains('No, it\'s something else') || thisCase[0].Subject == null || thisCase[0].Subject =='Bot Case'){
        try {
          delete thisCase;
        } catch (DmlException e) {
          system.debug('Case delete error: ' + e);
        }
      }
    }
  }
}