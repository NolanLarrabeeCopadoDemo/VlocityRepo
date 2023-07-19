global with sharing class ckz_SaveCartLoadConfig {
    
    global void onInstall(InstallContext context) {
        if(context.previousVersion() == null) {
            addPageConfigSettings();
            addPageLabels();
        }
        if(context.isUpgrade()) {
            addPageConfigSettings();
            addPageLabels();
        }
    }

    // for use on dev orgs
    public static void runOnInstall() {
        ckz_SaveCartLoadConfig handler = new ckz_SaveCartLoadConfig();
        handler.addPageConfigSettings();
        handler.addPageLabels();
    }

    private void addPageConfigSettings() {
        String configJSON = '[{"ConfigurationMetas":[{"Name":"Ext Save Cart Button","APIName":"savecartbtn","Description":"TRUE/FALSE: show the [Save Cart] button","ExternallySafe":true,"Configurations":[{"TextValue":"TRUE","Storefront":"Global","PageName":"all","Name":"Global.all.c.savecartbtn"}]}],"APIName":"c","Name":"Cart"}]';
        Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccApi.API_VERSION => 1,
                ccrz.ccApiConfig.CONFIG_JSON => configJSON
        };

        ccrz.ccApiConfig.setBulk(inputData);
    }

    public void addPageLabels() {
        List<ccrz__E_PageLabel__c> newPageLabels = new List<ccrz__E_PageLabel__c>{

                crtPL('SaveCart_Title','All','Global','Save Cart')
                ,crtPL('SaveCart_Name','All','Global','Cart Name')
                ,crtPL('SaveCart_DialogButtonCancel','All','Global','Cancel')
                ,crtPL('SaveCart_DialogButtonSave','All','Global','Save')
                ,crtPL('SaveCart_ButtonSave','All','Global','Save Cart')

        };
        insertPageLabels(newPageLabels);
    }

    public static void insertPageLabels(List<ccrz__E_PageLabel__c> pageLabels) {
        Set<String> pageLabelNames = new Set<String>();
        Set<String> storefronts = new Set<String>();

        for(ccrz__E_PageLabel__c pl : pageLabels ) {
            pageLabelNames.add(pl.Name);
            storefronts.add(pl.ccrz__Storefront__c);
        }

        List<ccrz__E_PageLabel__c> pageLabelsRetrieved = [SELECT Name, ccrz__PageName__c, ccrz__Storefront__c FROM ccrz__E_PageLabel__c WHERE Name IN :pageLabelNames AND ccrz__Storefront__c IN :storefronts];

        Set<String> pageLabelSet = new Set<String>();

        for(ccrz__E_PageLabel__c pl : pageLabelsRetrieved ) {
            pageLabelSet.add(combName(pl));
        }

        List<ccrz__E_PageLabel__c> pageLabelInsert = new List<ccrz__E_PageLabel__c>();
        for(ccrz__E_PageLabel__c pl : pageLabels ) {
            if(!pageLabelSet.contains(combName(pl))){
                pageLabelInsert.add(pl);
                pageLabelSet.add(combName(pl));
            }
        }

        insert pageLabelInsert;
    }

    private static String combName(ccrz__E_PageLabel__c pl){
        return pl.Name+pl.ccrz__PageName__c+pl.ccrz__Storefront__c;
    }

    private static ccrz__E_PageLabel__c crtPL(String nm,String pg,String st,String val){
        return new ccrz__E_PageLabel__c(Name=nm,ccrz__PageName__c=pg,ccrz__Storefront__c=st,ccrz__Value__c=val,ccrz__ValueRT__c=val);
    }

}