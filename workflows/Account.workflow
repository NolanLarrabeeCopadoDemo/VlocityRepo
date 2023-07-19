<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CKZ_Set_Account_Id18_value</fullName>
        <field>ckz_Id18__c</field>
        <formula>Casesafeid(Id)</formula>
        <name>CKZ Set Account Id18 value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Assign to Data%2Ecom Record Type</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.AccountSource</field>
            <operation>equals</operation>
            <value>Data.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Account_Source_Custom__c</field>
            <operation>contains</operation>
            <value>Data.com</value>
        </criteriaItems>
        <description>Used to change the record type to Data.com for Accounts imported from Data.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CKZ Set Id18 field</fullName>
        <actions>
            <name>CKZ_Set_Account_Id18_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.ckz_Id18__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Used by B2B Commerce to set hidden Id18 field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
