/**
@author Salesforce.com
@Date 2021
@description IssueVoucherHTTPResponseClass wrapped used to store the Issue Voucher HTTP Response Result
*/ 
public class IssueVoucherHTTPResponseClass {
	Public Class HTTPResponseResult {
        public String actionName;
        public Errors[] errors;
        public Boolean isSuccess;
        public outputValues outputValues;
    }
    Public Class outputValues {
        public String VoucherId;
    }
    public Class Errors {
        public string statusCode;
        public string message;
        public String[] fields;
    }
}