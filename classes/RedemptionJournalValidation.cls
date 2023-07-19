/**
* @author Salesforce.com
* @date 2021
*
* @description Apex implementation for Journal validation for Redemption/Quote request payload 
*/
public inherited sharing class RedemptionJournalValidation {
        
    /** Validate valid IDs for foreign keys to LoyaltyProgram, Member, Partner
     *  For "Product" RedemptionType validate IDs for foreign keys to ProductCategory, Product
     *  For "Voucher" RedemptionType validate IDs for foreign key to VoucherDefinition
     */
    public static Boolean validateTransactionsPayload(TransactionJournal[] inputs,
                                                      RedemptionRestResource.RedemptionResponseWrapper[] redemptionResponses)
    {
        Boolean anyValidationError = false;
        //Validate for valid LoyaltyProgramId and LoyaltyProgramMemberId in the first input payload
        String loyaltyProgramId = inputs[0].LoyaltyProgramId;
        String memberId = inputs[0].MemberId;
        if([SELECT Id from LoyaltyProgram where Id = :loyaltyProgramId WITH SECURITY_ENFORCED].size() == 0)
        {
            throw new RedemptionRestResource.RedemptionPayloadException(RedemptionErrors.ERROR_INVALID_PROGRAM);
        }
        if([SELECT Id from LoyaltyProgramMember where Id = :memberId WITH SECURITY_ENFORCED].size() == 0 )
        {
            throw new RedemptionRestResource.RedemptionPayloadException(RedemptionErrors.ERROR_INVALID_MEMBER);
        }
        
        Integer trnIndex = 0;
        Set<Id> partnerIds = new Map<Id, LoyaltyProgramPartner>([SELECT Id FROM LoyaltyProgramPartner WITH SECURITY_ENFORCED]).keySet();
        Set<Id> productCategoryIds = new Map<Id, ProductCategory>([SELECT Id FROM ProductCategory WITH SECURITY_ENFORCED]).keySet();
        Set<Id> productIds = new Map<Id, Product2>([SELECT Id FROM Product2 WITH SECURITY_ENFORCED]).keySet();
        Set<Id> voucherDefinitionIds = new Map<Id, VoucherDefinition>([SELECT Id FROM VoucherDefinition WHERE IsActive=true WITH SECURITY_ENFORCED]).keySet();
        for (TransactionJournal input : inputs)
        {   
            //Validate if different LoyaltyProgramId or MemberId present in input payload
            if (!loyaltyProgramId.equals(input.LoyaltyProgramId))
            {
                redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_MULTIPLE_PROGRAM);
            } else if(!memberId.equals(input.MemberId))
            {
                redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_MULTIPLE_MEMBER);
            }
            
            //Validation for valid PartnerId, ProductCategoryId and ProductId
            if (String.isNotBlank(input.PartnerId) && !partnerIds.contains(input.PartnerId)){
                redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_INVALID_PARTNER);
            }
    
            if(String.isBlank(input.JournalSubTypeId) 
              || !RedemptionConstants.PRODUCT_SUBTYPE_ID.equals(input.JournalSubTypeId)
              || !RedemptionConstants.VOUCHER_SUBTYPE_ID.equals(input.JournalSubTypeId)) {
                redemptionResponses[trnIndex].errors.add(RedemptionErrors.ERROR_INVALID_JOURNALSUB_TYPE);
            }
            
            validateProductRedemptionType(input, redemptionResponses[trnIndex], productCategoryIds, productIds );
            if (String.isNotBlank(input.VoucherDefinitionId__c)){
                validateVoucherDefinition(input, redemptionResponses[trnIndex], voucherDefinitionIds );
            }
            
            setNullValuesIfBlank(input);
            if (redemptionResponses[trnIndex].errors.size() != 0) { anyValidationError = true; }
            trnIndex++;
        }
        return anyValidationError;
    }
    
    static void setNullValuesIfBlank(TransactionJournal input){
        if (String.isBlank(input.PartnerId)){input.PartnerId = null;}
        if (String.isBlank(input.ProductCategoryId)){input.ProductCategoryId = null;} 
        if (String.isBlank(input.ProductId)){input.ProductId = null;} 
        if (String.isBlank(input.VoucherDefinitionId__c)){input.VoucherDefinitionId__c = null;} 
    }
    
    static set<Id> getInvalidExpirationDateVouchersIdFromToday(){
        Set<Id> invalidExpirationDateVouchersId = new Set<Id>();
        VoucherDefinition[] voucherDefinitionsWithPeriodExpirationType = [SELECT Id,ExpirationType,ExpirationDate,ExpirationPeriod,ExpirationPeriodUnit
                                                                          FROM VoucherDefinition
                                                                          WHERE ExpirationType='Period' AND ExpirationDate != null
                                                                          WITH SECURITY_ENFORCED];
        for (VoucherDefinition voucherDefinition : voucherDefinitionsWithPeriodExpirationType){
            if ('Days'.equals(voucherDefinition.ExpirationPeriodUnit) 
                && voucherDefinition.ExpirationDate < Date.today().addDays(voucherDefinition.ExpirationPeriod)){
                invalidExpirationDateVouchersId.add(voucherDefinition.Id);
            } else if ('Months'.equals(voucherDefinition.ExpirationPeriodUnit) 
                       && voucherDefinition.ExpirationDate < Date.today().addMonths(voucherDefinition.ExpirationPeriod)){
                invalidExpirationDateVouchersId.add(voucherDefinition.Id);
        	}
        }
        return invalidExpirationDateVouchersId;
    }
    
    static void validateVoucherDefinition(TransactionJournal input,
                                       RedemptionRestResource.RedemptionResponseWrapper redemptionResponse,
                                       Set<Id> voucherDefinitionIds)
    {
        Set<Id> invalidExpirationDateVouchersIdFromToday = getInvalidExpirationDateVouchersIdFromToday();
        
        if (RedemptionConstants.VOUCHER_SUBTYPE_ID.equals(input.JournalSubTypeId) 
            && String.isBlank(input.VoucherDefinitionId__c)){
            redemptionResponse.errors.add(RedemptionErrors.ERROR_MISSING_VOUCHER_QUERY);
        } else if (!voucherDefinitionIds.contains(input.VoucherDefinitionId__c)){
            redemptionResponse.errors.add(RedemptionErrors.ERROR_INVALID_VOUCHER_DEFINITION);
        } else if (invalidExpirationDateVouchersIdFromToday.contains(input.VoucherDefinitionId__c)){
            redemptionResponse.errors.add(RedemptionErrors.ERROR_DATE_OUT_OF_RANGE_VOUCHER_DEFINITION);
        }
    }
    
    static void validateProductRedemptionType(TransactionJournal input,
                                              RedemptionRestResource.RedemptionResponseWrapper redemptionResponse,
                                              Set<Id> productCategoryIds,
                                              Set<Id> productIds)
    {
        if (String.isNotBlank(input.ProductCategoryId) && !productCategoryIds.contains(input.ProductCategoryId)){
            redemptionResponse.errors.add(RedemptionErrors.ERROR_INVALID_CATEGORY);
        }
        if (String.isNotBlank(input.ProductId) && !productIds.contains(input.ProductId)){
            redemptionResponse.errors.add(RedemptionErrors.ERROR_INVALID_PRODUCT);
        }
        //Any of Partner or ProductCategory or ProductId is mandatory in payload
        if (String.isBlank(input.PartnerId) && String.isBlank(input.ProductCategoryId) && String.isBlank(input.ProductId)){
            redemptionResponse.errors.add(RedemptionErrors.ERROR_MISSING_PRODUCT_QUERY);
        } 
    }
}