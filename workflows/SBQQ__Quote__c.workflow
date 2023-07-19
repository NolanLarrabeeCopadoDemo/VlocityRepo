<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Email</fullName>
        <description>Approval Email</description>
        <protected>false</protected>
        <recipients>
            <field>SBQQ__SalesRep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Processes/CPQ_Quote_Approved</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Email</fullName>
        <description>Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <field>SBQQ__SalesRep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Processes/CPQ_Quote_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Quote_Status_in_Review</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Quote Status in Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Expiration_Date</fullName>
        <field>SBQQ__ExpirationDate__c</field>
        <formula>BLANKVALUE( SBQQ__ExpirationDate__c, today()+7)</formula>
        <name>Set Expiration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Intro</fullName>
        <field>SBQQ__Introduction__c</field>
        <formula>&quot;Greetings &quot; + 
BLANKVALUE(SBQQ__PrimaryContact__r.FirstName, TRIM(SBQQ__Account__r.Name)) + 
&quot; &quot; + 
BLANKVALUE(SBQQ__PrimaryContact__r.LastName,&quot;&quot;)+&quot;,&quot; 
+br()+br()+br()+&quot;Enclosed is the proposal I promised you.&quot;+br()+br()+&quot;I also want to take this opportunity to thank you for all your help. Designing a suitable solution required that I become familiar with your products and your industry. As a result, your help and guidance proved to be invaluable and ultimately resulted in a better, more cost effective solution for your organization.&quot;+br()+br()+&quot;I will call you next week to discuss this proposal. As always, please don’t hesitate to call me if you have questions or if I can be of further assistance.&quot;+br()+br()+&quot;I hope we can continue working together into the future.&quot;+br()+br()+br()+&quot;With best regards,&quot; + br()+br() 
+$User.FirstName + &quot; &quot; + $User.LastName + br() + 
$User.Title + br() + $User.Email</formula>
        <name>Set Intro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Start_Date</fullName>
        <field>SBQQ__StartDate__c</field>
        <formula>BLANKVALUE( SBQQ__StartDate__c , today()+ 30)</formula>
        <name>Set Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Subscription_Term</fullName>
        <field>SBQQ__SubscriptionTerm__c</field>
        <formula>BLANKVALUE(SBQQ__SubscriptionTerm__c,12)</formula>
        <name>Set Subscription Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_Approved</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Quote Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_Draft</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Quote Status - Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_Rejected</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Denied</literalValue>
        <name>Update Quote Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Initialize Quote</fullName>
        <actions>
            <name>Set_Expiration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Intro</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Subscription_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Steelbrick: Populates new Quote with information needed for Quote generation.</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
