/**
 * @description       : 
 * @author            : Salesforce
 * @group             : 
 * @last modified on  : 02-25-2021
 * @last modified by  : Salesforce
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   02-25-2021   Salesforce   Initial Version
**/
public without sharing class RedemptionConstants {
    
    public static String CURRENTCLASSNAME  = RedemptionConstants.class.getName();
    public static Decimal APIVERSION = [SELECT ApiVersion FROM ApexClass WHERE Name = :CURRENTCLASSNAME Limit 1].ApiVersion;
    
    //Action URLs
    public static final String COMPOSITE_POST_URL = '/services/data/v'+ APIVERSION +'/composite/sobjects';
    public static final String DT_REDEMPTION_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/custom/decisionTableAction/Points_to_Redeem_Based_on_Products_and_Vouchers_Default';
    public static final String GET_POINTS_BALANCE_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/standard/getPointsBalance';
    public static final String DEBIT_POINTS_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/standard/debitPoints';
    public static final String ISSUE_VOUCHER_ACTION_URL = '/services/data/v'+ APIVERSION +'/actions/standard/issueVoucher';
    
    //Flow names, input and output variables names which are used in Redemption Execution
    public static final String REDEMPTION_FLOW_API_NAME = 'Deduct_Points_Based_on_Product_and_Vouchers';
    
    public static final Decimal TRN_LIMIT = 10;
    public static final Decimal COUNT_NEW_VOUCHERS_CREATE = 10;
    
    public static final String CHANNEL_FIELD_NAME = 'Channel';
    
    //Loyalty Program specific values
    public static final String PROGRAM_NAME = 'Partner Extraa Program';
    public static final String NQP_CURRENCY = 'Points';
    
    //Field API names for RedeemPointsProductCategory Custom Object that is used in DT
    public static final String REDEMPTION_CATALOG = 'RedeemPointsProductCategory__c';
    public static final String REDEMPTION_CATALOG_CHANNEL = 'RedemptionChannel__c';
    public static final String REDEMPTION_CATALOG_PARTNER = 'Partner__c';
    public static final String REDEMPTION_CATALOG_CATEGORY = 'ProductCategory__c';
    public static final String REDEMPTION_CATALOG_PRODUCT = 'Product__c';
    public static final String REDEMPTION_CATALOG_PROGRAM = 'LoyaltyProgram__c';
    public static final String REDEMPTION_CATALOG_START_DATE = 'StartDate__c';
    public static final String REDEMPTION_CATALOG_END_DATE = 'EndDate__c';
    public static final String REDEMPTION_CATALOG_VOUCHER_DEFINITION = 'VoucherDefinitionId__c';
    public static final String REDEMPTION_CATALOG_REDEMPTION_TYPE = 'RedemptionType__c';
    public static final String REDEMPTION_CATALOG_POINTS = 'Points__c';
    
    enum REDEMPTION_TYPE {Product, Voucher}
    public static final Id PRODUCT_SUBTYPE_ID = [SELECT Id FROM JournalSubType WHERE Name = :REDEMPTION_TYPE.Product.name() LIMIT 1].Id;
    public static final Id VOUCHER_SUBTYPE_ID = [SELECT Id FROM JournalSubType WHERE Name = :REDEMPTION_TYPE.Voucher.name() LIMIT 1].Id;
  
}