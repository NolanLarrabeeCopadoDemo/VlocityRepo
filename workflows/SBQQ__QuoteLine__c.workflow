<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LeaseOption</fullName>
        <field>SBQQ__SubscriptionPricing__c</field>
        <literalValue>Fixed Price</literalValue>
        <name>LeaseOption</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LeaseOptionFalse</fullName>
        <field>SBQQ__SubscriptionPricing__c</field>
        <name>LeaseOptionFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LeaseOptionTrue</fullName>
        <field>SBQQ__SubscriptionPricing__c</field>
        <literalValue>Fixed Price</literalValue>
        <name>LeaseOptionTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_approval_level</fullName>
        <field>Approval_Level__c</field>
        <formula>IF( Discretionary_Discount__c &gt; Approval_Threshold__c , 1, 0)</formula>
        <name>set approval level</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LeaseOption</fullName>
        <actions>
            <name>LeaseOptionTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.LeaseOption__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LeaseOptionFalse</fullName>
        <actions>
            <name>LeaseOptionFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.LeaseOption__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set approval Level</fullName>
        <actions>
            <name>set_approval_level</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>sets approval level on each quote line item</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
