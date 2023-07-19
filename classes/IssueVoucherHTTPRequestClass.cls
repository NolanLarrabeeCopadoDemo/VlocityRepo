/**
@author Salesforce.com
@Date 2021
@description IssueVoucherHTTPRequestClass wrapped used to store the Issue Voucher HTTP request
*/ 
public class IssueVoucherHTTPRequestClass {
    
    Public Class HTTPRequestClass {
       Public Inputs[] inputs;
    }
    Public Class Inputs {
        public String VoucherCode;
        public String ProgramName;
        public String EffectiveDate;
        public String ExpirationDate;
        public String LoyaltyProgramMemberId;
        public String VoucherDefinitionName;
        public String contactId;
        public String JournalId;
        public String BenefitId;
        public String AdditionalNotes;
    }    
}