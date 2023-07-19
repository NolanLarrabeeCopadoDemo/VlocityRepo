<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>et4ae5__MobileSendFailed</fullName>
        <description>Send Email Notification of Failed Mobile Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>et4ae5__ExactTarget/et4ae5__ETMobileSendDone</template>
    </alerts>
    <alerts>
        <fullName>et4ae5__MobileSendStatus</fullName>
        <description>Send Email Notification of Completed Mobile Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>et4ae5__ExactTarget/et4ae5__ETMobileSendDone</template>
    </alerts>
    <fieldUpdates>
        <fullName>et4ae5__DelayedMobileSend</fullName>
        <field>et4ae5__TriggerDelayedSend__c</field>
        <literalValue>1</literalValue>
        <name>DelayedMobileSend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__FailBackupSMSWorkflowM</fullName>
        <field>et4ae5__Messages__c</field>
        <formula>$Label.et4ae5__errorNoRes</formula>
        <name>FailBackupSMSWorkflowM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__FailBackupSmsWorkflow</fullName>
        <field>et4ae5__SendStatus__c</field>
        <literalValue>Failed</literalValue>
        <name>FailBackupSmsWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__MobileSendStatusDateTime</fullName>
        <field>et4ae5__Status_Date_Time__c</field>
        <formula>now()</formula>
        <name>MobileSendStatusDateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__PopulateBackupSmsWorkflow</fullName>
        <field>et4ae5__BackupWorkflow__c</field>
        <formula>IF(
et4ae5__HasEnteredRetry__c ,
IF(
OR(ISBLANK(et4ae5__Scheduled_Date_Time__c),et4ae5__Scheduled_Date_Time__c &lt; now()),
now()+(1/48),
et4ae5__Scheduled_Date_Time__c+(1/48)
),
IF(
OR(ISBLANK(et4ae5__Scheduled_Date_Time__c),et4ae5__Scheduled_Date_Time__c &lt; now()),
now()+(1/288),
et4ae5__Scheduled_Date_Time__c+(1/288)
))</formula>
        <name>PopulateBackupSmsWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SetMobileConversationId</fullName>
        <field>et4ae5__ConversationId__c</field>
        <formula>$Organization.Id+Id</formula>
        <name>SetMobileConversationId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__UnpopulateBackupSmsWorkflow</fullName>
        <field>et4ae5__BackupWorkflow__c</field>
        <name>UnpopulateBackupSmsWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>et4ae5__FailBackupSmsWorkflow</fullName>
        <actions>
            <name>et4ae5__FailBackupSMSWorkflowM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>et4ae5__FailBackupSmsWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>! CONTAINS( et4ae5__Send_Status_View__c , &quot;Fail&quot;) &amp;&amp; ! CONTAINS( et4ae5__Send_Status_View__c , &quot;Complete&quot;) &amp;&amp; ! CONTAINS( et4ae5__Send_Status_View__c , &quot;Cancel&quot;) &amp;&amp; ! et4ae5__TrackingOnly__c &amp;&amp; ISBLANK( et4ae5__BackupWorkflow__c ) &amp;&amp; IF( ISBLANK(et4ae5__Scheduled_Date_Time__c) , ( NOW()-(1/2) ) &gt;= et4ae5__Created_Date_Time__c , ( NOW()-(1/2) ) &gt;= et4ae5__Scheduled_Date_Time__c ) &amp;&amp; ! et4ae5__HasBeenQueued__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__MobileSendComplete</fullName>
        <actions>
            <name>et4ae5__MobileSendStatus</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>et4ae5__SMSDefinition__c.et4ae5__SendStatus__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__MobileSendFailed</fullName>
        <actions>
            <name>et4ae5__MobileSendFailed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>et4ae5__Send_Status_View__c = &apos;Fail&apos; || et4ae5__Send_Status_View__c = &apos;Failed&apos; || et4ae5__Send_Status_View__c = &apos;Error&apos; || et4ae5__Send_Status_View__c = &apos;Errored&apos; || et4ae5__Send_Status_View__c = &apos;Canceled&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__MobileSendStatusDateTime</fullName>
        <actions>
            <name>et4ae5__MobileSendStatusDateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( et4ae5__SendStatus__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__PopulateBackupSmsWorkflow</fullName>
        <actions>
            <name>et4ae5__PopulateBackupSmsWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>! CONTAINS( et4ae5__Send_Status_View__c , &quot;Fail&quot;) &amp;&amp; ! CONTAINS( et4ae5__Send_Status_View__c , &quot;Complete&quot;) &amp;&amp; ! CONTAINS( et4ae5__Send_Status_View__c , &quot;Cancel&quot;) &amp;&amp; ! et4ae5__TrackingOnly__c &amp;&amp; ISBLANK( et4ae5__BackupWorkflow__c ) &amp;&amp; ( IF( ISBLANK(et4ae5__Scheduled_Date_Time__c) , ( NOW()-(1/2) ) &lt; et4ae5__Created_Date_Time__c , ( NOW()-(1/2) ) &lt; et4ae5__Scheduled_Date_Time__c ) || et4ae5__HasBeenQueued__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SetMobileConversationId</fullName>
        <actions>
            <name>et4ae5__SetMobileConversationId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISNULL( et4ae5__ConversationId__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
