/*
* @author Salesforce.com
* @date 2020-12-11
*
* @description: Response for Enrollment API
*/
global with sharing class B2BManufacturingEnrollMemberResponse {  

    public String enrollmentStatus  {get;set;}
    public String enrollmentMessage {get;set;}
    public String memberId          {get;set;}

}