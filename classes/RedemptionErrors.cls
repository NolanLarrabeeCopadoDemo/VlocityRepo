public inherited sharing class RedemptionErrors {
    
    public static final String ERROR_INVALID_EXECUTION_METHOD = 'Specify a valid Apex or Flow execution method and try again.';
    public static final String ERROR_TRN_LIMIT_EXCEEDED = 'You can include up to 10 redemption requests for a member. Remove some of the redemption requests and try again.';

    public static final String ERROR_MULTIPLE_PROGRAM = 'Specify only one LoyaltyProgramId and try again.';
    public static final String ERROR_MULTIPLE_MEMBER = 'Specify only one MemberId and try again.';
    public static final String ERROR_INVALID_PROGRAM = 'Specify a valid LoyaltyProgramId and try again.';
    public static final String ERROR_INVALID_MEMBER = 'Specify a valid LoyaltyProgramMemberId in the payload and try again.';
    public static final String ERROR_INVALID_PARTNER = 'Specify a valid PartnerId and try again.';
    public static final String ERROR_INVALID_CATEGORY = 'Specify a valid ProductCategoryId and try again.';
    public static final String ERROR_INVALID_PRODUCT = 'Specify a valid ProductId and try again';
    public static final String ERROR_INVALID_JOURNALSUB_TYPE = 'Specify a valid value for JournalSubTypeId in the payload and try again.';
    public static final String ERROR_INVALID_VOUCHER_DEFINITION = 'Specify a valid VoucherDefinitionId in the payload and try again.';
    public static final String ERROR_DATE_OUT_OF_RANGE_VOUCHER_DEFINITION = 'Specify an expiration date that is between the effective date and the expiration date of the voucher definition';
    
    public static final String ERROR_REDEMPTION_FLOW_INACTIVE = 'We can’t process this transaction because the redemption flow isn’t activated. Activate the flow and try again or ask your Salesforce admin for help.';
    
    public static final String ERROR_UNKNOWN_DT_EXCEPTION = 'Unknown DT exception';

    public static final String ERROR_MISSING_PRODUCT_QUERY = 'We could not find any of the PartnerId, ProductCategoryId and ProductId. Specify at least one valid PartnerId, ProductCategoryId and ProductId in the payload.';
    public static final String ERROR_MISSING_VOUCHER_QUERY = 'We could not find the VoucherDefinitionId. Specify a valid VoucherDefinitionId in the payload.';

    public static final String ERROR_NO_MATCH_RULE = 'We can’t process this transaction because the rule for the PartnerProductCategory isn’t defined in the Decision Table. Ask your Salesforce admin for help.';
    
    public static final String ERROR_INSUFFICIENT_BALANCE = 'We can’t process the transaction because the member doesn’t have a sufficient point balance.';
    public static final String ERROR_VOUCHER_CODE_UNAVAILABLE = 'Voucher Codes not available';
    
}