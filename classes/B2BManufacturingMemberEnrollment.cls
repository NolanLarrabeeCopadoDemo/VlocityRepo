/*
* @author Salesforce.com
* @date 2020-12-11
*
* @description: Rest API for enrolment process
*/
@RestResource(urlMapping='/Enrollment/*')
global with sharing class B2BManufacturingMemberEnrollment {
    global static B2BManufacturingEnrollMemberResponse objResponse ;
    global static boolean isNegativeTest = false;
    public static final string ERRORSTATUS = 'Error';
    public static final string SUCCESSSTATUS = 'Success';
    public static final string ERROR_BODYMISSING = 'JSON Body missing.';
    public static final string ERROR_EMAIL = 'Specify  email for contact and try again.';
    public static final string ERROR_ACCOUNTNAME = 'Specify  name for account and try again.';
    public static final string ERROR_BIRTHDATE = 'Date format should be YYYY-MM-DD.';
    public static final string ERROR_ALREADYENROLLED = 'Account is alreay enrolled.';
    public static final string SUCCESS_ENROLLED = 'Member enrolled successfully.';
    /**
    * @description Main method to accept JSON request and proceed to enroll member.
    * @return JSON String as response
    */
    @HttpPost
    global static B2BManufacturingEnrollMemberResponse enrolMember() {
        objResponse = new B2BManufacturingEnrollMemberResponse();
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;        
        
        if ((request.requestBody == null || string.isBlank(request.requestBody.toString()))) {
            objResponse.enrollmentStatus= ERRORSTATUS;
            objResponse.enrollmentMessage = ERROR_BODYMISSING;
            response.statusCode = 404;
            return objResponse; 
        }
            
        try { 
            string jsonBody = request.requestBody.toString();
            objResponse.enrollmentStatus=SUCCESSSTATUS;
            objResponse.enrollmentMessage = SUCCESSSTATUS;
      
            B2BManufacturingEnrollMemberRequest objMemberWrap = (B2BManufacturingEnrollMemberRequest) JSON.deserialize(jsonBody, B2BManufacturingEnrollMemberRequest.class);

            doProcess(objMemberWrap);

        } catch(exception ex){
            objResponse.enrollmentStatus=ERRORSTATUS;
            objResponse.enrollmentMessage = ex.getmessage();
        }

        return objResponse;
    }
    
    /**
    * @description Method to parse Json request and construct members to insert.
    * @param EnrollMemberRequest (request to create members )
    * @return Void
    */
    private static void doProcess(B2BManufacturingEnrollMemberRequest objMemberWrap){
        id accountId = doValidate(objMemberWrap);
        if(objResponse.enrollmentStatus == ERRORSTATUS){
           return;
        }
        
        id contactId;
       
        if(string.isBlank(accountId)){
            accountId = createAccount( objMemberWrap.member);
        }

        List<Contact> contacts = [SELECT Id FROM Contact WHERE email =:objMemberWrap.Member.contact.email
                                  AND AccountId=:accountId   WITH SECURITY_ENFORCED LIMIT 1];
        if(!contacts.isEmpty()){
            contactId = contacts[0].id;
        }
        else{
           contactId = createContact( objMemberWrap.member,accountId);
        }
        createProgramMember(contactId,accountId);
       
    }
    
    /**
    * @description Method to validate incoming request
    * @param EnrollMemberRequest (request payload )
    * @return Id (existing account Id)
    */
    private static Id doValidate(B2BManufacturingEnrollMemberRequest objMemberWrap){
        Id accountId;
        if(string.isBlank(objMemberWrap.Member.account.name)){
            objResponse.enrollmentStatus=ERRORSTATUS;
            objResponse.enrollmentMessage = ERROR_ACCOUNTNAME;
        }
        else{
            List<Account> accounts = [SELECT Id FROM Account WHERE name =:objMemberWrap.Member.account.name 
                                        WITH SECURITY_ENFORCED LIMIT 1];
            if(!accounts.isEmpty()){
                accountId = accounts[0].id;

                List<LoyaltyProgramMember> loyaltyProgramMembers = [SELECT Id FROM LoyaltyProgramMember WHERE AccountId =:accountId 
                                                                    WITH SECURITY_ENFORCED LIMIT 1];
                if(!loyaltyProgramMembers.isEmpty()){
                    objResponse.enrollmentStatus=ERRORSTATUS;
                    objResponse.enrollmentMessage = ERROR_ALREADYENROLLED;
                }
            }
        }
        if( objResponse.enrollmentStatus!=ERRORSTATUS){
            if(string.isBlank(objMemberWrap.member.contact.email)){
                objResponse.enrollmentStatus=ERRORSTATUS;
                objResponse.enrollmentMessage = ERROR_EMAIL;
            }
            else if(string.isNotBlank(objMemberWrap.member.contact.birthDate)){
                Try{
                    date birthDate= date.valueof(objMemberWrap.member.contact.birthDate);
                }
                catch( exception ex){
                    objResponse.enrollmentStatus=ERRORSTATUS;
                    objResponse.enrollmentMessage = ERROR_BIRTHDATE;
                }
            }
        }
        return accountId;

    }
    /**
    * @description Method to bind account fields and create account
    * @param B2CEnrollMemberRequest.Member (request to bind  account fields )
    * @return Id (Account Id)
    */
    private static Id createAccount( B2BManufacturingEnrollMemberRequest.Member objMember) {   
        Account acc = new Account(
            Name                 = objMember.account.name,
            billingStreet        = objMember.account.address.street,
            billingCity          = objMember.account.address.city,
            billingState         = objMember.account.address.state,
            billingPostalCode    = objMember.account.address.postalCode,
            billingCountry       = objMember.account.address.country
        );
        DMLManager.DBInsert(acc) ;
        return acc.id;
    } 

    /**
    * @description Method to bind Contact fields values and create contact
    * @param B2CEnrollMemberRequest.Member (Request Payload)
    * @return Id (Contact Id)
    */
    private static Id createContact( B2BManufacturingEnrollMemberRequest.Member objMember,id accountId) {
        Contact con = new Contact(
            AccountId            = accountId,
            FirstName            = objMember.contact.firstname,
            LastName             = objMember.contact.lastName,
            email                = objMember.contact.email,
            Phone                = objMember.contact.phone,                
            Birthdate            = date.valueof(objMember.contact.birthDate),//YYYY-MM-DD
            mailingStreet        = objMember.contact.address.street,
            mailingCity          = objMember.contact.address.city,
            mailingState         = objMember.contact.address.state,
            mailingPostalCode    = objMember.contact.address.postalCode,
            mailingCountry       = objMember.contact.address.country
        );
        DMLManager.DBInsert(con) ;
        return con.id;
    } 


 
    /**
    * @description Method to Insert Members and genrate final response
    * @param Map<id,id> mapAccoutContact  map of Account to contact 
    * @return void
    */ 
    private static void createProgramMember ( Id contactId, Id accountId) {

        List<LoyaltyProgram> programs = [SELECT Id FROM LoyaltyProgram WHERE Name = :Label.LoyaltyProgramName 
                                        WITH SECURITY_ENFORCED LIMIT 1];
        String programId = programs.isEmpty() ? '' : programs[0].Id;
        string memberID = Datetime.now().formatGMT('yyyyMMddHHmmss');


        LoyaltyProgramMember objProgramMember       = new LoyaltyProgramMember();
        objProgramMember.ContactId                  = contactId;
        objProgramMember.EnrollmentDate             = System.today();
        objProgramMember.ProgramId                  = programId;
        objProgramMember.MemberStatus               = 'Active';
        objProgramMember.MemberType                 = 'Corporate';
        objProgramMember.MembershipNumber           =  memberID;
        objProgramMember.AccountId                  = accountId;

        if(isNegativeTest){
            objProgramMember.ProgramId = accountId;
        } 

        DMLManager.DBInsert(objProgramMember) ;
        objResponse.enrollmentMessage = SUCCESS_ENROLLED;
        objResponse.memberId = objProgramMember.Id;
    }
   
}