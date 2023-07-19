<?xml version="1.0" encoding="UTF-8"?>
<OmniScript xmlns="http://soap.sforce.com/2006/04/metadata">
    <description>08/10 Update logic in the getTemplateDetails IP to handle omnistudio</description>
    <elementTypeComponentMapping>{&quot;ElementTypeToHTMLTemplateList&quot;:[]}</elementTypeComponentMapping>
    <isActive>true</isActive>
    <isIntegrationProcedure>false</isIntegrationProcedure>
    <isMetadataCacheDisabled>false</isMetadataCacheDisabled>
    <isOmniScriptEmbeddable>true</isOmniScriptEmbeddable>
    <isTestProcedure>false</isTestProcedure>
    <isWebCompEnabled>true</isWebCompEnabled>
    <language>Multi-Language</language>
    <lastPreviewPage>Lightning</lastPreviewPage>
    <name>Doc Gen Component</name>
    <omniProcessElements>
        <childElements>
            <description>context-id -- SObjectId like QuoteId, OpportunityId,OrderId &amp; ContractId
selected-template -- selected Template JSON node from previous step. 
debug -- optional for debugging
document-title  -- Overrides the Default Document Name/Title of your document</description>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>GenerateDocumentWord</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;bStandalone&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;customAttributes&quot; : [ {
    &quot;name&quot; : &quot;context-id&quot;,
    &quot;source&quot; : &quot;%SObjectId%&quot;
  }, {
    &quot;name&quot; : &quot;selected-template&quot;,
    &quot;source&quot; : &quot;%selectedTemplate%&quot;
  }, {
    &quot;name&quot; : &quot;debug&quot;,
    &quot;source&quot; : &quot;false&quot;
  }, {
    &quot;name&quot; : &quot;document-title&quot;,
    &quot;source&quot; : &quot;%docTitle%&quot;
  } ],
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;label&quot; : &quot;Generate_Document&quot;,
  &quot;lwcName&quot; : &quot;omnistudio__clmOsMultiDocxGenerateDocument&quot;,
  &quot;show&quot; : null
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Custom Lightning Web Component</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>generateDocument</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;allowSaveForLater&quot; : false,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;&quot;,
  &quot;chartLabel&quot; : &quot;Generate_Document&quot;,
  &quot;completeLabel&quot; : &quot;&quot;,
  &quot;completeMessage&quot; : &quot;&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;disOnTplt&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : &quot;&quot;
  },
  &quot;instruction&quot; : &quot;&quot;,
  &quot;instructionKey&quot; : &quot;&quot;,
  &quot;knowledgeOptions&quot; : {
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;remoteTimeout&quot; : 30000,
    &quot;typeFilter&quot; : &quot;&quot;
  },
  &quot;label&quot; : &quot;Generate_Document&quot;,
  &quot;message&quot; : { },
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : &quot;6&quot;,
  &quot;previousLabel&quot; : &quot;&quot;,
  &quot;previousWidth&quot; : &quot;0&quot;,
  &quot;pubsub&quot; : false,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;remoteOptions&quot; : { },
  &quot;remoteTimeout&quot; : 30000,
  &quot;saveLabel&quot; : &quot;&quot;,
  &quot;saveMessage&quot; : &quot;&quot;,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : true,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>3.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>CustomLWC1</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12,
  &quot;label&quot; : &quot;&quot;,
  &quot;show&quot; : null,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;hide&quot; : false,
  &quot;lwcName&quot; : &quot;omnistudio__clmOsGeneratePdfMergeDocument&quot;,
  &quot;bStandalone&quot; : false,
  &quot;customAttributes&quot; : [ {
    &quot;name&quot; : &quot;context-id&quot;,
    &quot;source&quot; : &quot;%SObjectId%&quot;
  }, {
    &quot;name&quot; : &quot;pdf-content-version-ids&quot;,
    &quot;source&quot; : &quot;%pdfContentVersionIds%&quot;
  } ]
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Custom Lightning Web Component</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>generateMergeDocument</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;label&quot; : &quot;Generate_Merge_Document&quot;,
  &quot;validationRequired&quot; : true,
  &quot;previousLabel&quot; : &quot;&quot;,
  &quot;previousWidth&quot; : &quot;0&quot;,
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : &quot;3&quot;,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;&quot;,
  &quot;saveLabel&quot; : &quot;&quot;,
  &quot;saveMessage&quot; : &quot;&quot;,
  &quot;completeLabel&quot; : &quot;&quot;,
  &quot;completeMessage&quot; : &quot;&quot;,
  &quot;instruction&quot; : &quot;&quot;,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;remoteTimeout&quot; : 30000,
  &quot;remoteOptions&quot; : { },
  &quot;knowledgeOptions&quot; : {
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;remoteTimeout&quot; : 30000,
    &quot;typeFilter&quot; : &quot;&quot;
  },
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;2&quot;,
        &quot;condition&quot; : &quot;&gt;=&quot;,
        &quot;field&quot; : &quot;countTemplates&quot;
      }, {
        &quot;field&quot; : &quot;FilesLength&quot;,
        &quot;condition&quot; : &quot;&gt;=&quot;,
        &quot;data&quot; : &quot;1&quot;
      } ]
    }
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;instructionKey&quot; : &quot;&quot;,
  &quot;chartLabel&quot; : &quot;Generate_Merge_Document&quot;,
  &quot;allowSaveForLater&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : &quot;&quot;
  },
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>5.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>IPCombainAllPdfVersionIds</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;controlWidth&quot; : 12,
  &quot;label&quot; : &quot;&quot;,
  &quot;integrationProcedureKey&quot; : &quot;Merge_VersionIds&quot;,
  &quot;useContinuation&quot; : false,
  &quot;remoteOptions&quot; : {
    &quot;preTransformBundle&quot; : &quot;&quot;,
    &quot;postTransformBundle&quot; : &quot;&quot;,
    &quot;useFuture&quot; : false,
    &quot;chainable&quot; : false
  },
  &quot;remoteTimeout&quot; : 30000,
  &quot;preTransformBundle&quot; : &quot;&quot;,
  &quot;postTransformBundle&quot; : &quot;&quot;,
  &quot;sendJSONPath&quot; : &quot;&quot;,
  &quot;sendJSONNode&quot; : &quot;&quot;,
  &quot;responseJSONPath&quot; : &quot;&quot;,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;extraPayload&quot; : { },
  &quot;inProgressMessage&quot; : &quot;&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;&quot;,
  &quot;failureGoBackLabel&quot; : &quot;&quot;,
  &quot;failureAbortMessage&quot; : &quot;&quot;,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;&quot;,
  &quot;redirectNextWidth&quot; : 3,
  &quot;redirectPreviousLabel&quot; : &quot;&quot;,
  &quot;redirectPreviousWidth&quot; : 3,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;1&quot;,
        &quot;condition&quot; : &quot;&gt;=&quot;,
        &quot;field&quot; : &quot;FilesLength&quot;
      } ]
    }
  },
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;svgSprite&quot; : &quot;&quot;,
  &quot;svgIcon&quot; : &quot;&quot;,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : &quot;&quot;
  },
  &quot;enableDefaultAbort&quot; : false,
  &quot;enableActionMessage&quot; : false,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>4.0</sequenceNumber>
        <type>Integration Procedure Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>IPgetTemplateDetailsForDocGen</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;enableActionMessage&quot; : false,
  &quot;enableDefaultAbort&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : &quot;&quot;
  },
  &quot;extraPayload&quot; : { },
  &quot;failureAbortLabel&quot; : &quot;&quot;,
  &quot;failureAbortMessage&quot; : &quot;&quot;,
  &quot;failureGoBackLabel&quot; : &quot;GoBack&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;inProgressMessage&quot; : &quot;InProgress&quot;,
  &quot;integrationProcedureKey&quot; : &quot;doc_Generation&quot;,
  &quot;label&quot; : &quot;&quot;,
  &quot;message&quot; : { },
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;postTransformBundle&quot; : &quot;&quot;,
  &quot;preTransformBundle&quot; : &quot;&quot;,
  &quot;pubsub&quot; : false,
  &quot;redirectNextLabel&quot; : &quot;&quot;,
  &quot;redirectNextWidth&quot; : 3,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectPreviousLabel&quot; : &quot;&quot;,
  &quot;redirectPreviousWidth&quot; : 3,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;remoteOptions&quot; : {
    &quot;useFuture&quot; : false,
    &quot;chainable&quot; : false,
    &quot;preTransformBundle&quot; : &quot;&quot;,
    &quot;postTransformBundle&quot; : &quot;&quot;,
    &quot;templateNames&quot; : &quot;%templateNames%&quot;
  },
  &quot;remoteTimeout&quot; : 30000,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;responseJSONPath&quot; : &quot;&quot;,
  &quot;sendJSONNode&quot; : &quot;&quot;,
  &quot;sendJSONPath&quot; : &quot;&quot;,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;ssm&quot; : false,
  &quot;svgIcon&quot; : &quot;&quot;,
  &quot;svgSprite&quot; : &quot;&quot;,
  &quot;useContinuation&quot; : false,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>1.0</sequenceNumber>
        <type>Integration Procedure Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>requiredInputs</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;controlWidth&quot; : 12,
  &quot;label&quot; : &quot;&quot;,
  &quot;elementValueMap&quot; : {
    &quot;attachFileFormat&quot; : &quot;%FileFormat%&quot;,
    &quot;docTitle&quot; : &quot;%documentTitle%&quot;,
    &quot;templateNames&quot; : &quot;%templateNames%&quot;,
    &quot;Files&quot; : &quot;=%Files%&quot;,
    &quot;SObjectId&quot; : &quot;%SObjectId%&quot;
  },
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;show&quot; : null,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false
}</propertySetConfig>
        <sequenceNumber>0.0</sequenceNumber>
        <type>Set Values</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>setGenerationOption</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;disOnTplt&quot; : false,
  &quot;elementValueMap&quot; : {
    &quot;docGenerationMechanism&quot; : &quot;ClientSide&quot;,
    &quot;documentViewer&quot; : &quot;PDF&quot;,
    &quot;downloadFileFormat&quot; : &quot;all&quot;,
    &quot;pdfGenerationSource&quot; : &quot;ClientSide&quot;,
    &quot;templateType&quot; : &quot;Microsoft Word .DOCX Template&quot;,
    &quot;useTemplateDRExtract&quot; : &quot;No&quot;,
    &quot;selectedTemplate&quot; : &quot;%selectedTemplate%&quot;,
    &quot;countTemplates&quot; : &quot;=COUNT(%selectedTemplate%)&quot;
  },
  &quot;label&quot; : null,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>2.0</sequenceNumber>
        <type>Set Values</type>
    </omniProcessElements>
    <omniProcessType>OmniScript</omniProcessType>
    <propertySetConfig>{&quot;allowCancel&quot;:true,&quot;allowSaveForLater&quot;:false,&quot;autoFocus&quot;:false,&quot;autoSaveOnStepNext&quot;:false,&quot;bLK&quot;:false,&quot;cancelRedirectPageName&quot;:&quot;OmniScriptCancelled&quot;,&quot;cancelRedirectTemplateUrl&quot;:&quot;vlcCancelled.html&quot;,&quot;cancelSource&quot;:&quot;%ContextId%&quot;,&quot;cancelType&quot;:&quot;SObject&quot;,&quot;consoleTabIcon&quot;:&quot;&quot;,&quot;consoleTabLabel&quot;:&quot;New&quot;,&quot;consoleTabTitle&quot;:&quot;&quot;,&quot;currencyCode&quot;:&quot;&quot;,&quot;currentLanguage&quot;:&quot;en_US&quot;,&quot;disableUnloadWarn&quot;:true,&quot;elementTypeToHTMLTemplateMapping&quot;:{},&quot;enableKnowledge&quot;:false,&quot;errorMessage&quot;:{&quot;custom&quot;:[]},&quot;hideStepChart&quot;:false,&quot;knowledgeArticleTypeQueryFieldsMap&quot;:{},&quot;lkObjName&quot;:null,&quot;message&quot;:{},&quot;persistentComponent&quot;:[{&quot;id&quot;:&quot;vlcCart&quot;,&quot;itemsKey&quot;:&quot;cartItems&quot;,&quot;label&quot;:&quot;&quot;,&quot;modalConfigurationSetting&quot;:{&quot;modalController&quot;:&quot;ModalProductCtrl&quot;,&quot;modalHTMLTemplateId&quot;:&quot;vlcProductConfig.html&quot;,&quot;modalSize&quot;:&quot;lg&quot;},&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;,&quot;remoteClass&quot;:&quot;&quot;,&quot;remoteMethod&quot;:&quot;&quot;,&quot;remoteOptions&quot;:{&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;},&quot;remoteTimeout&quot;:30000,&quot;render&quot;:false,&quot;responseJSONNode&quot;:&quot;&quot;,&quot;responseJSONPath&quot;:&quot;&quot;,&quot;sendJSONNode&quot;:&quot;&quot;,&quot;sendJSONPath&quot;:&quot;&quot;},{&quot;id&quot;:&quot;vlcKnowledge&quot;,&quot;itemsKey&quot;:&quot;knowledgeItems&quot;,&quot;label&quot;:&quot;&quot;,&quot;modalConfigurationSetting&quot;:{&quot;modalController&quot;:&quot;&quot;,&quot;modalHTMLTemplateId&quot;:&quot;&quot;,&quot;modalSize&quot;:&quot;lg&quot;},&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;,&quot;remoteClass&quot;:&quot;&quot;,&quot;remoteMethod&quot;:&quot;&quot;,&quot;remoteOptions&quot;:{&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;},&quot;remoteTimeout&quot;:30000,&quot;render&quot;:false}],&quot;pubsub&quot;:false,&quot;rtpSeed&quot;:false,&quot;saveContentEncoded&quot;:false,&quot;saveExpireInDays&quot;:null,&quot;saveForLaterRedirectPageName&quot;:&quot;sflRedirect&quot;,&quot;saveForLaterRedirectTemplateUrl&quot;:&quot;vlcSaveForLaterAcknowledge.html&quot;,&quot;saveNameTemplate&quot;:null,&quot;saveObjectId&quot;:&quot;%ContextId%&quot;,&quot;saveURLPatterns&quot;:{},&quot;seedDataJSON&quot;:{},&quot;showInputWidth&quot;:false,&quot;ssm&quot;:false,&quot;stepChartPlacement&quot;:&quot;right&quot;,&quot;stylesheet&quot;:{&quot;lightning&quot;:&quot;&quot;,&quot;newport&quot;:&quot;&quot;},&quot;timeTracking&quot;:false,&quot;trackingCustomData&quot;:{},&quot;visualforcePagesAvailableInPreview&quot;:{},&quot;wpm&quot;:false}</propertySetConfig>
    <subType>OmniStudioComponent</subType>
    <type>DocGen</type>
    <uniqueName>DocGen_OmniStudioComponent_multiLanguage_1</uniqueName>
    <versionNumber>3.0</versionNumber>
    <webComponentKey>6a6f466e-bca9-6a22-e2e0-f8ca44298b4e</webComponentKey>
</OmniScript>
