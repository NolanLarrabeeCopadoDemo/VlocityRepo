/**
 * @description       : Wrapper class to construct Program Member Profile Details.
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-09-2021   Salesforce   Initial Version
**/
public with sharing class MemberProfile {
    
    @AuraEnabled
    public String memberId { get; set; }
    @AuraEnabled
    public String membershipNumber { get; set; }
    @AuraEnabled
    public Integer pointBalance { get; set; }
    @AuraEnabled
    public Integer tierBalance { get; set; }
    @AuraEnabled
    public String tier { get; set; }
    
}