<?xml version="1.0" encoding="UTF-8"?>
<OmniScript xmlns="http://soap.sforce.com/2006/04/metadata">
    <description>DONOT CHANGE - Debarshi - 06/29 - Updated for MFG</description>
    <elementTypeComponentMapping>{&quot;ElementTypeToHTMLTemplateList&quot;:[]}</elementTypeComponentMapping>
    <isActive>true</isActive>
    <isIntegrationProcedure>false</isIntegrationProcedure>
    <isMetadataCacheDisabled>false</isMetadataCacheDisabled>
    <isOmniScriptEmbeddable>true</isOmniScriptEmbeddable>
    <isTestProcedure>false</isTestProcedure>
    <isWebCompEnabled>true</isWebCompEnabled>
    <language>English</language>
    <lastPreviewPage>Newport</lastPreviewPage>
    <name>MatchorCreateAccountContacts</name>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>creatematchAccount</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;bundle&quot; : &quot;createBusinessAccountContacts&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;enableActionMessage&quot; : false,
  &quot;enableDefaultAbort&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : null
  },
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;failureGoBackLabel&quot; : &quot;Go Back&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;label&quot; : &quot;Create/Match Account&quot;,
  &quot;message&quot; : { },
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;postTransformBundle&quot; : &quot;&quot;,
  &quot;pubsub&quot; : false,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;remoteTimeout&quot; : 30000,
  &quot;sendJSONNode&quot; : &quot;&quot;,
  &quot;sendJSONPath&quot; : &quot;&quot;,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      }, {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddContact&quot;
      } ]
    }
  },
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : &quot;Submit&quot;,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>3.0</sequenceNumber>
        <type>DataRaptor Post Action</type>
    </omniProcessElements>
    <omniProcessElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>getAccounts</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;bundle&quot; : &quot;dcGetAllAccounts&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;dataRaptor Input Parameters&quot; : [ {
    &quot;element&quot; : &quot;AccountSearch&quot;,
    &quot;inputParam&quot; : &quot;LookupKey&quot;
  } ],
  &quot;disOnTplt&quot; : false,
  &quot;enableActionMessage&quot; : false,
  &quot;enableDefaultAbort&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : null
  },
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;failureGoBackLabel&quot; : &quot;Go Back&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;ignoreCache&quot; : false,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;label&quot; : &quot;getAccounts&quot;,
  &quot;message&quot; : { },
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;pubsub&quot; : false,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;remoteTimeout&quot; : 30000,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;responseJSONPath&quot; : &quot;&quot;,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;wpm&quot; : false
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>DataRaptor Extract Action</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>AccountSearch</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;callFrequency&quot; : 300,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;dataJsonPath&quot; : &quot;&quot;,
  &quot;dataProcessorFunction&quot; : &quot;&quot;,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;disableDataFilter&quot; : false,
  &quot;editMode&quot; : false,
  &quot;enableGoogleMapsAutocomplete&quot; : false,
  &quot;enableLookup&quot; : false,
  &quot;googleAddressCountry&quot; : &quot;all&quot;,
  &quot;googleMapsAPIKey&quot; : &quot;&quot;,
  &quot;googleTransformation&quot; : {
    &quot;administrative_area_level_1&quot; : &quot;&quot;,
    &quot;country&quot; : &quot;&quot;,
    &quot;locality&quot; : &quot;&quot;,
    &quot;postal_code&quot; : &quot;&quot;,
    &quot;street&quot; : &quot;&quot;
  },
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hideEditButton&quot; : true,
  &quot;hideMap&quot; : true,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Search for Account Name&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;newItemLabel&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : false,
  &quot;typeAheadKey&quot; : &quot;Account Name&quot;,
  &quot;useDataJson&quot; : false
}</propertySetConfig>
            <sequenceNumber>0.0</sequenceNumber>
            <type>Type Ahead Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>AddAccount</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;checkLabel&quot; : &quot;Can&apos;t find the account you are looking for? Check here to create a new one.&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;defaultValue&quot; : false,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;hide&quot; : false,
  &quot;label&quot; : null,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : null,
        &quot;field&quot; : &quot;AccountSearch-Block:AccountId&quot;
      } ]
    }
  }
}</propertySetConfig>
            <sequenceNumber>1.0</sequenceNumber>
            <type>Checkbox</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>AddContact</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;checkLabel&quot; : &quot;Can&apos;t find the Contact you are looking for? Check here to create a new Primary Contact.&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;defaultValue&quot; : false,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;label&quot; : null,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeatLimit&quot; : null,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;&lt;&gt;&quot;,
        &quot;data&quot; : null,
        &quot;field&quot; : &quot;AccountSearch-Block:AccountId&quot;
      }, {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : null,
        &quot;field&quot; : &quot;ContactId&quot;
      } ]
    }
  }
}</propertySetConfig>
            <sequenceNumber>3.0</sequenceNumber>
            <type>Checkbox</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>authEmail</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 6,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Email&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>20.0</sequenceNumber>
                <type>Email</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>authFirstName</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 6,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;First Name&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>18.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>authLastName</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 6,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Last Name&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>19.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>authMobilePhone</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 6,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Mobile Phone&quot;,
  &quot;mask&quot; : &quot;(999) 999-9999&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>21.0</sequenceNumber>
                <type>Telephone</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>hdlnContacts</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;disOnTplt&quot; : false,
  &quot;label&quot; : &quot;&lt;p&gt;&lt;/p&gt;\n&lt;h2&gt;&lt;strong&gt;Key Contacts&lt;/strong&gt;&lt;/h2&gt;&quot;,
  &quot;show&quot; : null
}</propertySetConfig>
                <sequenceNumber>17.0</sequenceNumber>
                <type>Headline</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>AddContactBlock</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;collapse&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;disOnTplt&quot; : false,
  &quot;hide&quot; : false,
  &quot;label&quot; : null,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;repeatLimit&quot; : null,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      }, {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddContact&quot;
      } ]
    }
  }
}</propertySetConfig>
            <sequenceNumber>7.0</sequenceNumber>
            <type>Block</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>DRGetContactDetails</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;controlWidth&quot; : 12,
  &quot;label&quot; : &quot;getContacts&quot;,
  &quot;bundle&quot; : &quot;dcGetAccountDetails&quot;,
  &quot;ignoreCache&quot; : false,
  &quot;dataRaptor Input Parameters&quot; : [ {
    &quot;element&quot; : &quot;ContactSearch&quot;,
    &quot;inputParam&quot; : &quot;LookupKey&quot;
  }, {
    &quot;element&quot; : &quot;AccountId&quot;,
    &quot;inputParam&quot; : &quot;AccountId&quot;
  } ],
  &quot;remoteTimeout&quot; : 30000,
  &quot;responseJSONPath&quot; : &quot;&quot;,
  &quot;responseJSONNode&quot; : &quot;&quot;,
  &quot;inProgressMessage&quot; : &quot;In Progress&quot;,
  &quot;postMessage&quot; : &quot;Done&quot;,
  &quot;failureNextLabel&quot; : &quot;Continue&quot;,
  &quot;failureAbortLabel&quot; : &quot;Abort&quot;,
  &quot;failureGoBackLabel&quot; : &quot;Go Back&quot;,
  &quot;failureAbortMessage&quot; : &quot;Are you sure?&quot;,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;redirectPageName&quot; : &quot;&quot;,
  &quot;redirectTemplateUrl&quot; : &quot;vlcAcknowledge.html&quot;,
  &quot;redirectNextLabel&quot; : &quot;Next&quot;,
  &quot;redirectNextWidth&quot; : 3,
  &quot;redirectPreviousLabel&quot; : &quot;Previous&quot;,
  &quot;redirectPreviousWidth&quot; : 3,
  &quot;showPersistentComponent&quot; : [ true, false ],
  &quot;show&quot; : null,
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : null
  },
  &quot;enableDefaultAbort&quot; : false,
  &quot;enableActionMessage&quot; : false,
  &quot;businessCategory&quot; : &quot;&quot;,
  &quot;businessEvent&quot; : &quot;&quot;
}</propertySetConfig>
                <sequenceNumber>0.0</sequenceNumber>
                <type>DataRaptor Extract Action</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>ContactSearch</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;controlWidth&quot; : 12,
  &quot;label&quot; : &quot;Search for Contact Name&quot;,
  &quot;showInputWidth&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;googleTransformation&quot; : {
    &quot;street&quot; : &quot;&quot;,
    &quot;locality&quot; : &quot;&quot;,
    &quot;administrative_area_level_1&quot; : &quot;&quot;,
    &quot;administrative_area_level_2&quot; : &quot;&quot;,
    &quot;country&quot; : &quot;&quot;,
    &quot;postal_code&quot; : &quot;&quot;
  },
  &quot;required&quot; : false,
  &quot;readOnly&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;helpTextPos&quot; : &quot;&quot;,
  &quot;minLength&quot; : 0,
  &quot;maxLength&quot; : 255,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : null,
        &quot;condition&quot; : &quot;&lt;&gt;&quot;,
        &quot;field&quot; : &quot;AccountSearch-Block:AccountId&quot;
      } ]
    }
  },
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;debounceValue&quot; : 0,
  &quot;typeAheadKey&quot; : &quot;Contact Name&quot;,
  &quot;dataProcessorFunction&quot; : &quot;&quot;,
  &quot;callFrequency&quot; : 300,
  &quot;editMode&quot; : false,
  &quot;newItemLabel&quot; : &quot;New&quot;,
  &quot;hideEditButton&quot; : false,
  &quot;enableGoogleMapsAutocomplete&quot; : false,
  &quot;enableLookup&quot; : false,
  &quot;disableDataFilter&quot; : false,
  &quot;googleMapsAPIKey&quot; : &quot;&quot;,
  &quot;hideMap&quot; : true,
  &quot;googleAddressCountry&quot; : &quot;all&quot;,
  &quot;useDataJson&quot; : false,
  &quot;dataJsonPath&quot; : &quot;&quot;,
  &quot;HTMLTemplateId&quot; : &quot;&quot;
}</propertySetConfig>
            <sequenceNumber>2.0</sequenceNumber>
            <type>Type Ahead Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>LineBreak1</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;disOnTplt&quot; : false,
  &quot;label&quot; : &quot;LineBreak1&quot;,
  &quot;padding&quot; : 0,
  &quot;show&quot; : null
}</propertySetConfig>
            <sequenceNumber>8.0</sequenceNumber>
            <type>Line Break</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>newAccountName</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 6,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Business Name&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : true,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      } ]
    }
  },
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
            <sequenceNumber>4.0</sequenceNumber>
            <type>Text</type>
        </childElements>
        <childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>newCity</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 4,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;City&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>12.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>newCountry</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 3,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Country&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>15.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>newPostalCode</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 3,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Postal Code&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>14.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>newState</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 2,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;State&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>13.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <childElements>
                <isActive>true</isActive>
                <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
                <level>2.0</level>
                <name>newStreet</name>
                <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
                <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Street&quot;,
  &quot;mask&quot; : &quot;&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;pattern&quot; : &quot;&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : null,
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
                <sequenceNumber>11.0</sequenceNumber>
                <type>Text</type>
            </childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>newAddress</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;callFrequency&quot; : 300,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;dataJsonPath&quot; : &quot;&quot;,
  &quot;dataProcessorFunction&quot; : &quot;&quot;,
  &quot;debounceValue&quot; : 0,
  &quot;disableDataFilter&quot; : false,
  &quot;editMode&quot; : false,
  &quot;enableGoogleMapsAutocomplete&quot; : true,
  &quot;enableLookup&quot; : false,
  &quot;googleAddressCountry&quot; : &quot;all&quot;,
  &quot;googleMapsAPIKey&quot; : &quot;AIzaSyDWLziF73XUtjB-WiMsIFqWx8-IuX8MbP8&quot;,
  &quot;googleTransformation&quot; : {
    &quot;administrative_area_level_1&quot; : &quot;newState&quot;,
    &quot;country&quot; : &quot;newCountry&quot;,
    &quot;locality&quot; : &quot;newCity&quot;,
    &quot;postal_code&quot; : &quot;newPostalCode&quot;,
    &quot;street&quot; : &quot;newStreet&quot;
  },
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hideEditButton&quot; : false,
  &quot;hideMap&quot; : true,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Mailing Address&quot;,
  &quot;maxLength&quot; : 255,
  &quot;minLength&quot; : 0,
  &quot;newItemLabel&quot; : &quot;New&quot;,
  &quot;readOnly&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      } ]
    }
  },
  &quot;showInputWidth&quot; : true,
  &quot;typeAheadKey&quot; : &quot;&quot;,
  &quot;useDataJson&quot; : false
}</propertySetConfig>
            <sequenceNumber>6.0</sequenceNumber>
            <type>Type Ahead Block</type>
        </childElements>
        <childElements>
            <isActive>true</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>newWebSite</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;accessibleInFutureSteps&quot; : false,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;controlWidth&quot; : 6,
  &quot;debounceValue&quot; : 0,
  &quot;disOnTplt&quot; : false,
  &quot;help&quot; : false,
  &quot;helpText&quot; : &quot;&quot;,
  &quot;hide&quot; : false,
  &quot;inputWidth&quot; : 12,
  &quot;label&quot; : &quot;Web Site&quot;,
  &quot;ptrnErrText&quot; : &quot;&quot;,
  &quot;readOnly&quot; : false,
  &quot;repeat&quot; : false,
  &quot;repeatClone&quot; : false,
  &quot;required&quot; : false,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;AND&quot;,
      &quot;rules&quot; : [ {
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      } ]
    }
  },
  &quot;showInputWidth&quot; : true
}</propertySetConfig>
            <sequenceNumber>5.0</sequenceNumber>
            <type>URL</type>
        </childElements>
        <childElements>
            <isActive>false</isActive>
            <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
            <level>1.0</level>
            <name>SetDemoValues</name>
            <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
            <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 3,
  &quot;disOnTplt&quot; : false,
  &quot;elementValueMap&quot; : {
    &quot;authFirstName2&quot; : &quot;Brian&quot;,
    &quot;authLastName2&quot; : &quot;Owens&quot;,
    &quot;authMobilePhone2&quot; : &quot;(603) 801-2640&quot;,
    &quot;authOfficePhone2&quot; : &quot;(603) 801-2640&quot;,
    &quot;authSalutation2&quot; : &quot;Mr.&quot;,
    &quot;authTitle2&quot; : &quot;Director&quot;,
    &quot;newAccountName2&quot; : &quot;ABC Company&quot;,
    &quot;newWebSite2&quot; : &quot;https://www.vlocity.com&quot;
  },
  &quot;label&quot; : &quot;Prefill&quot;,
  &quot;message&quot; : { },
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : &quot;Step&quot;,
  &quot;wpm&quot; : false
}</propertySetConfig>
            <sequenceNumber>9.0</sequenceNumber>
            <type>Set Values</type>
        </childElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>newAccount</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;allowSaveForLater&quot; : true,
  &quot;cancelLabel&quot; : &quot;Cancel&quot;,
  &quot;cancelMessage&quot; : &quot;Are you sure?&quot;,
  &quot;completeLabel&quot; : &quot;Complete&quot;,
  &quot;completeMessage&quot; : &quot;Are you sure you want to complete the script?&quot;,
  &quot;conditionType&quot; : &quot;Hide if False&quot;,
  &quot;errorMessage&quot; : {
    &quot;custom&quot; : [ ],
    &quot;default&quot; : null
  },
  &quot;instruction&quot; : &quot;&quot;,
  &quot;knowledgeOptions&quot; : {
    &quot;dataCategoryCriteria&quot; : &quot;&quot;,
    &quot;keyword&quot; : &quot;&quot;,
    &quot;language&quot; : &quot;English&quot;,
    &quot;publishStatus&quot; : &quot;Online&quot;,
    &quot;remoteTimeout&quot; : 30000,
    &quot;typeFilter&quot; : &quot;&quot;
  },
  &quot;label&quot; : &quot;Set Up Your Account&quot;,
  &quot;message&quot; : { },
  &quot;nextLabel&quot; : &quot;Next&quot;,
  &quot;nextWidth&quot; : 4,
  &quot;previousLabel&quot; : &quot;Previous&quot;,
  &quot;previousWidth&quot; : 3,
  &quot;pubsub&quot; : false,
  &quot;remoteClass&quot; : &quot;&quot;,
  &quot;remoteMethod&quot; : &quot;&quot;,
  &quot;remoteOptions&quot; : { },
  &quot;remoteTimeout&quot; : 30000,
  &quot;saveLabel&quot; : &quot;Save for later&quot;,
  &quot;saveMessage&quot; : &quot;Are you sure you want to save it for later?&quot;,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : true,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>0.0</sequenceNumber>
        <type>Step</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>setAccountandContact</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;disOnTplt&quot; : false,
  &quot;elementValueMap&quot; : {
    &quot;finalAcctName&quot; : &quot;=IF(%Account Name%=\&quot;\&quot;,%DRId_Account%,%newAccount:AccountSearch-Block:AccountSearch%)&quot;,
    &quot;AccountId&quot; : &quot;%newAccount:AccountSearch-Block:AccountId%&quot;,
    &quot;ContactId&quot; : &quot;%newAccount:ContactSearch-Block:ContactId%&quot;
  },
  &quot;label&quot; : null,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;true&quot;,
        &quot;condition&quot; : &quot;&lt;&gt;&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      }, {
        &quot;field&quot; : &quot;AddContact&quot;,
        &quot;condition&quot; : &quot;&lt;&gt;&quot;,
        &quot;data&quot; : &quot;true&quot;
      } ]
    }
  },
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>4.0</sequenceNumber>
        <type>Set Values</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>false</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>SetValueforAccountName</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;disOnTplt&quot; : false,
  &quot;elementValueMap&quot; : {
    &quot;acctNameForQuote&quot; : &quot;=IF(%newAccount2:newAccountName2%=null, %newAccount2:AccountSearch-Block:AccountSearch%, %newAccount2:newAccountName2%)&quot;
  },
  &quot;label&quot; : &quot;SetValuesForAcctName&quot;,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : null,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>1.0</sequenceNumber>
        <type>Set Values</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>SV2</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;wpm&quot; : false,
  &quot;ssm&quot; : false,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;show&quot; : {
    &quot;group&quot; : {
      &quot;operator&quot; : &quot;OR&quot;,
      &quot;rules&quot; : [ {
        &quot;data&quot; : &quot;true&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;field&quot; : &quot;AddAccount&quot;
      }, {
        &quot;field&quot; : &quot;AddContact&quot;,
        &quot;condition&quot; : &quot;=&quot;,
        &quot;data&quot; : &quot;true&quot;
      } ]
    }
  },
  &quot;pubsub&quot; : false,
  &quot;message&quot; : { },
  &quot;label&quot; : null,
  &quot;elementValueMap&quot; : {
    &quot;ContactId&quot; : &quot;%DRId_Contact%&quot;,
    &quot;AccountId&quot; : &quot;%DRId_Account%&quot;
  },
  &quot;disOnTplt&quot; : false,
  &quot;controlWidth&quot; : 12,
  &quot;HTMLTemplateId&quot; : &quot;&quot;
}</propertySetConfig>
        <sequenceNumber>5.0</sequenceNumber>
        <type>Set Values</type>
    </omniProcessElements>
    <omniProcessElements>
        <isActive>true</isActive>
        <isOmniScriptEmbeddable>false</isOmniScriptEmbeddable>
        <level>0.0</level>
        <name>transformSetValues</name>
        <omniProcessVersionNumber>0.0</omniProcessVersionNumber>
        <propertySetConfig>{
  &quot;HTMLTemplateId&quot; : &quot;&quot;,
  &quot;controlWidth&quot; : 12,
  &quot;disOnTplt&quot; : false,
  &quot;elementValueMap&quot; : {
    &quot;AccountName&quot; : &quot;%newAccount:newAccountName%&quot;,
    &quot;BillingCity&quot; : &quot;%newAccount:newAddress-Block:newCity%&quot;,
    &quot;BillingCountry&quot; : &quot;%newAccount:newAddress-Block:newCountry%&quot;,
    &quot;BillingState&quot; : &quot;%newAccount:newAddress-Block:newState%&quot;,
    &quot;BillingStreet&quot; : &quot;%newAccount:newAddress-Block:newStreet%&quot;,
    &quot;Email&quot; : &quot;%newAccount:AddContactBlock:authEmail%&quot;,
    &quot;FirstName&quot; : &quot;=%newAccount:AddContactBlock:authFirstName%&quot;,
    &quot;LastName&quot; : &quot;%newAccount:AddContactBlock:authLastName%&quot;,
    &quot;MobilePhone&quot; : &quot;%newAccount:AddContactBlock:authMobilePhone%&quot;,
    &quot;Website&quot; : &quot;=%newAccount:newWebSite%&quot;,
    &quot;Contact&quot; : &quot;%newAccount:ContactId%&quot;
  },
  &quot;label&quot; : &quot;Transform for common DR&quot;,
  &quot;message&quot; : { },
  &quot;pubsub&quot; : false,
  &quot;show&quot; : null,
  &quot;showPersistentComponent&quot; : [ false, false ],
  &quot;ssm&quot; : false,
  &quot;validationRequired&quot; : null,
  &quot;wpm&quot; : false
}</propertySetConfig>
        <sequenceNumber>2.0</sequenceNumber>
        <type>Set Values</type>
    </omniProcessElements>
    <omniProcessType>OmniScript</omniProcessType>
    <propertySetConfig>{&quot;allowCancel&quot;:true,&quot;allowSaveForLater&quot;:true,&quot;autoFocus&quot;:false,&quot;autoSaveOnStepNext&quot;:false,&quot;bLK&quot;:false,&quot;cancelRedirectPageName&quot;:&quot;OmniScriptCancelled&quot;,&quot;cancelRedirectTemplateUrl&quot;:&quot;vlcCancelled.html&quot;,&quot;cancelSource&quot;:&quot;%ContextId%&quot;,&quot;cancelType&quot;:&quot;SObject&quot;,&quot;consoleTabIcon&quot;:&quot;custom:custom18&quot;,&quot;consoleTabLabel&quot;:&quot;New&quot;,&quot;consoleTabTitle&quot;:null,&quot;currencyCode&quot;:&quot;&quot;,&quot;currentLanguage&quot;:&quot;en_US&quot;,&quot;disableUnloadWarn&quot;:true,&quot;elementTypeToHTMLTemplateMapping&quot;:{},&quot;enableKnowledge&quot;:false,&quot;errorMessage&quot;:{&quot;custom&quot;:[]},&quot;hideStepChart&quot;:false,&quot;knowledgeArticleTypeQueryFieldsMap&quot;:{},&quot;lkObjName&quot;:null,&quot;message&quot;:{},&quot;persistentComponent&quot;:[{&quot;id&quot;:&quot;vlcCart&quot;,&quot;itemsKey&quot;:&quot;cartItems&quot;,&quot;label&quot;:&quot;&quot;,&quot;modalConfigurationSetting&quot;:{&quot;modalController&quot;:&quot;ModalProductCtrl&quot;,&quot;modalHTMLTemplateId&quot;:&quot;vlcProductConfig.html&quot;,&quot;modalSize&quot;:&quot;lg&quot;},&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;,&quot;remoteClass&quot;:&quot;&quot;,&quot;remoteMethod&quot;:&quot;&quot;,&quot;remoteOptions&quot;:{&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;},&quot;remoteTimeout&quot;:30000,&quot;render&quot;:false,&quot;responseJSONNode&quot;:&quot;&quot;,&quot;responseJSONPath&quot;:&quot;&quot;,&quot;sendJSONNode&quot;:&quot;&quot;,&quot;sendJSONPath&quot;:&quot;&quot;},{&quot;id&quot;:&quot;vlcKnowledge&quot;,&quot;itemsKey&quot;:&quot;knowledgeItems&quot;,&quot;label&quot;:&quot;&quot;,&quot;modalConfigurationSetting&quot;:{&quot;modalController&quot;:&quot;&quot;,&quot;modalHTMLTemplateId&quot;:&quot;&quot;,&quot;modalSize&quot;:&quot;lg&quot;},&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;,&quot;remoteClass&quot;:&quot;&quot;,&quot;remoteMethod&quot;:&quot;&quot;,&quot;remoteOptions&quot;:{&quot;postTransformBundle&quot;:&quot;&quot;,&quot;preTransformBundle&quot;:&quot;&quot;},&quot;remoteTimeout&quot;:30000,&quot;render&quot;:false}],&quot;pubsub&quot;:false,&quot;rtpSeed&quot;:false,&quot;saveContentEncoded&quot;:false,&quot;saveExpireInDays&quot;:null,&quot;saveForLaterRedirectPageName&quot;:&quot;sflRedirect&quot;,&quot;saveForLaterRedirectTemplateUrl&quot;:&quot;vlcSaveForLaterAcknowledge.html&quot;,&quot;saveNameTemplate&quot;:null,&quot;saveObjectId&quot;:&quot;%ContextId%&quot;,&quot;saveURLPatterns&quot;:{},&quot;seedDataJSON&quot;:{},&quot;showInputWidth&quot;:false,&quot;ssm&quot;:false,&quot;stepChartPlacement&quot;:&quot;right&quot;,&quot;stylesheet&quot;:{&quot;lightning&quot;:&quot;&quot;,&quot;newport&quot;:&quot;&quot;},&quot;timeTracking&quot;:true,&quot;trackingCustomData&quot;:{},&quot;visualforcePagesAvailableInPreview&quot;:{},&quot;wpm&quot;:false}</propertySetConfig>
    <subType>EstablishAccount</subType>
    <type>Account</type>
    <uniqueName>Account_EstablishAccount_English_1</uniqueName>
    <versionNumber>1.0</versionNumber>
    <webComponentKey>2601f29e-744d-38a2-74bf-af8e3a5e4f49</webComponentKey>
</OmniScript>
