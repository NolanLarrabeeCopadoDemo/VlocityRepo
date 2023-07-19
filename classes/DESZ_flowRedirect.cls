public class DESZ_flowRedirect {
    @AuraEnabled
    public Static String validateAndRedirect(String idd){
        //idd[0] = idd[0].replace('(','');
        //idd[0] = idd[0].replace(')','');
        String fUrl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug(fUrl);
        
        List<String> surl = fUrl.split('.my.');
        String finalUrl = surl[0]+'/lightning.force.com/lightning/r/';
        //PageReference retURL = new PageReference(fUrl);
        //retURL.setRedirect(true);
        
        return finalUrl;
        
    }
}