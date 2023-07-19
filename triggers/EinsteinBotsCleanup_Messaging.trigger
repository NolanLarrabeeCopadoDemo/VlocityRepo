trigger EinsteinBotsCleanup_Messaging on MessagingSession (after update) {
  for (MessagingSession ms : Trigger.New){
    if(ms.Status == 'Ended'){
      Case[] thisCase = [SELECT Id, Subject FROM Case WHERE Id = :ms.CaseId];
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