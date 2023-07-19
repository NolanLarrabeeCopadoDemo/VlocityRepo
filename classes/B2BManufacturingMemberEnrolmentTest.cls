/*
* @author Salesforce.com
* @date 2020-12-11
* @description: Test class for B2BManufacturingMemberEnrolment
*/
@isTest
public with sharing class B2BManufacturingMemberEnrolmentTest {
    /**
    * @description : method to setup test data
    * @return  : Void
    */
    @testSetup
    static void loadDefaultTestData() {
        LoyaltyProgram objProgram = new LoyaltyProgram(Name=Label.LoyaltyProgramName);
        insert objProgram;
    }
    
    /**
    * @description : Test enrollment with out request
    * @return  : Void
    */
    static testMethod void testenrolMemberWithoutRequest(){
        
        RestRequest req = genrateRestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        B2BManufacturingEnrollMemberResponse  results = B2BManufacturingMemberEnrollment.enrolMember();
        Test.stopTest();
        System.assert( results.enrollmentMessage.contains(B2BManufacturingMemberEnrollment.ERROR_BODYMISSING));        

    } 
    
    /**
    * @description : Test enrollment with wrong request
    * @return  : Void
    */
    static testMethod void testenrolMemberWithWrongRequest(){        
        RestRequest req = genrateRestRequest(); 
        RestResponse res = new RestResponse();         
        req.requestBody = Blob.valueof('This is sample Request for negative test');
        RestContext.request = req;
        RestContext.response = res;        
        Test.startTest();
        B2BManufacturingEnrollMemberResponse  results = B2BManufacturingMemberEnrollment.enrolMember();
        Test.stopTest();
        system.assertEquals(true, results.enrollmentStatus.contains(B2BManufacturingMemberEnrollment.ERRORSTATUS));
    }
    
    /**
    * @description : Test enrollment with valid request
    * @return  : Void
    */
    static testMethod void testenrolMemberWithValidRequest(){        
        RestRequest req = genrateRestRequest(); 
        RestResponse res = new RestResponse(); 
        B2BManufacturingEnrollMemberRequest objRequest = genrateRequest();
        String JsonMsg=JSON.serialize(objRequest);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response = res;        

        B2BManufacturingEnrollMemberResponse  results = B2BManufacturingMemberEnrollment.enrolMember();

        List<LoyaltyProgramMember> lstMember =[SELECT id FROM LoyaltyProgramMember];
        system.assertEquals(1, lstMember.size());
        
        B2BManufacturingEnrollMemberResponse  results1 = B2BManufacturingMemberEnrollment.enrolMember();

        system.assertEquals(true, results1.enrollmentMessage.contains(B2BManufacturingMemberEnrollment.ERROR_ALREADYENROLLED)); 

        objRequest.member.account.name = '';
        String JsonMsg1=JSON.serialize(objRequest);

        req.requestBody = Blob.valueof(JsonMsg1);
        RestContext.request = req;       
        B2BManufacturingEnrollMemberResponse  results2 = B2BManufacturingMemberEnrollment.enrolMember();
        system.assertEquals(true, results2.enrollmentMessage.contains(B2BManufacturingMemberEnrollment.ERROR_ACCOUNTNAME)); 

    }
    
   
    
    /**
    * @description : method to bind attributes in RestRequest
    * @return  : RestRequest
    */
    private static RestRequest genrateRestRequest(){
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/Enrollment/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        B2BManufacturingMemberEnrollment.isNegativeTest = false;
        return req;
    }
    
    /**
    * @description : method to method to genrate Request body
    * @return  : B2CRetailEnrollMemberRequest
    */
    private static B2BManufacturingEnrollMemberRequest genrateRequest(){
        B2BManufacturingEnrollMemberRequest objRequest = new B2BManufacturingEnrollMemberRequest();

        B2BManufacturingEnrollMemberRequest.Address objAddress = new  B2BManufacturingEnrollMemberRequest.Address();
        objAddress.street = 'TestStreet';
        objAddress.city = 'TestCity';
        objAddress.state = 'TestState';
        objAddress.postalCode = '1234567';
        objAddress.country = 'TestCountry';
      
        B2BManufacturingEnrollMemberRequest.Contact objContact = new B2BManufacturingEnrollMemberRequest.Contact();
        objContact.phone ='1234567890';
        objContact.firstName ='Raj';
        objContact.lastName ='Kumar';
        objContact.email = Datetime.now().formatGMT('yyyyMMddHHmmss')+'@kumar.com';
        objContact.birthDate ='2000-01-01';
        objContact.address = objAddress;
       
        B2BManufacturingEnrollMemberRequest.Account objAccount = new B2BManufacturingEnrollMemberRequest.Account();
        objAccount.name= Datetime.now().formatGMT('yyyyMMddHHmmss');
        objAccount.address = objAddress;

        objRequest.member = new B2BManufacturingEnrollMemberRequest.Member();
        objRequest.member.account = objAccount;
        objRequest.member.contact = objContact;
        return objRequest;
    }
}