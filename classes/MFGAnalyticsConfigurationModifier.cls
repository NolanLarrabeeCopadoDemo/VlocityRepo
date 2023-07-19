/** ServiceWaveConfig
* Smart Wizard - Apex class to auto scan Manufacturing org and pre-poulate wizard Questions
* Developer: Ankit Gupta
* Date: Aug, 2019
* */

public with sharing class MFGAnalyticsConfigurationModifier extends wavetemplate.WaveTemplateConfigurationModifier{

    public override void onConfigurationRetrieval(wavetemplate.WaveTemplateInfo template)
    {

    }

    //*********************Validation Before APP Creation**************************************************
    // Executes when we click on Create-APP button
    public override void beforeAppCreate(wavetemplate.WaveTemplateInfo template, wavetemplate.Answers answers)
    {
    }

    //*********************Validation Before APP Update**************************************************
    // Executes when we click on Reset or Update button
     public override void beforeAppUpdate(wavetemplate.WaveTemplateInfo template, String previousAppVersion, wavetemplate.Answers answers)
     {}

    }