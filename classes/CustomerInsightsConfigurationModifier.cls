public with sharing class CustomerInsightsConfigurationModifier extends wavetemplate.WavetemplateConfigurationModifier
{
    // *****  Main method upon wizard config retrieval ***** /
    public override void onConfigurationRetrieval(wavetemplate.WaveTemplateInfo template)
     {
         // Empty for now
     }
    
    private void setReconfigurePath(wavetemplate.WaveTemplateInfo template, wavetemplate.Answers answers)
    {
      
    }

    //*********************Validation Before APP Creation**************************************************
    // Executes when we click on Create-APP button
    public override void beforeAppCreate(wavetemplate.WaveTemplateInfo template, wavetemplate.Answers answers)
    {
        try {
            WaveAutoInstallRequest latestRequest = [Select Id, TemplateApiName, RequestStatus, CreatedDate From WaveAutoInstallRequest where TemplateApiName =: template.getApiName() order by CreatedDate desc Limit 1];
            if(latestRequest.RequestStatus == 'InProgress') {
                List<WaveCompatibilityCheckItem> checkListItems = this.getCompatibiltyCheckItems(template, false, true);
                // get the payloadFromTheApp
                String payload = '';
                for (WaveCompatibilityCheckItem objectToValidate : checkListItems) {
                    if(objectToValidate.taskResult == 'Completed'){
                        payload = objectToValidate.payload;
                    }
                }
                if(payload != ''){
                    Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(payload);
                    for (String key : payloadMap.keySet()) {
                        answers.put(key, payloadMap.get(key));
                    }
                }
                answers.put('autoInstall', true);
            }
        } catch(Exception e){
            // Could not find latest request continue as normal
        }
    }

    private List<WaveCompatibilityCheckItem> getCompatibiltyCheckItems(wavetemplate.WaveTemplateInfo waveTemplate, boolean thisVersionOnly, boolean includePayload){
        String versionCriteria = '';
        if (thisVersionOnly){
            versionCriteria = ' AND TemplateVersion = ' +
                            (null == waveTemplate.getReleaseInfo() || null == waveTemplate.getReleaseInfo().getTemplateVersion() ? 'null' : '\''+ waveTemplate.getReleaseInfo().getTemplateVersion() + '\'');
        }
        String query = 'SELECT Id, TaskName, TaskResult, TemplateApiName, TemplateVersion ' + (includePayload ? ', Payload' : '') +
                       ' FROM WaveCompatibilityCheckItem' +
                       ' WHERE TemplateApiName = \'' + waveTemplate.getApiName() + '\'' +
                        versionCriteria;
        return Database.query(query);
    }
}