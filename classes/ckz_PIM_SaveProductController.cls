/**
 * Created by msobc on 2/5/2019.
 */

public with sharing class ckz_PIM_SaveProductController {

    @AuraEnabled
    public static Map<String, Object> putProductData(String productJson) {

        System.debug('begin putProductData');

        Map<String, Object> responseMap = new Map<String, Object>();

        responseMap.put('productDataSaved', false);

        Savepoint sp = Database.setSavepoint();

        try {

            Map<String, Object> productMap = (Map<String, Object>) Json.deserializeUntyped(productJson);

            // Product object

            Map<String, Object> productDetails = (Map<String, Object>) productMap.get('productDetails');

            String productName = (String) productDetails.get('name'); System.debug('productName: ' + productName);

            String productType = (String) productDetails.get('productType'); System.debug('productType: ' + productType);

            String product_sfid = (String) productDetails.get('sfid');

            List<Object> priceListEntries = (List<Object>) productMap.get('priceListEntries');
            List<Object> productMediaEntries = (List<Object>) productMap.get('productMediaEntries');
            List<Object> productCategoryEntries = (List<Object>) productMap.get('productCategoryEntries');
            List<Object> productSpecEntries = (List<Object>) productMap.get('productSpecEntries');
            List<Object> relatedProductEntries = (List<Object>) productMap.get('relatedProductEntries');

            if(product_sfid != null && product_sfid.equals('') == false) {

                // This is an existing product.
                // Get a map of all related objects
                Map<String, Object> childObjectMap = getChildObjectMap(product_sfid);

                // Look for stuff to delete

                Set<String> priceListItemSet = (Set<String>)childObjectMap.get('ccrz__E_PriceListItem__c');
                deleteChldObjects(priceListItemSet, priceListEntries, responseMap);

                Set<String> productSpecSet = (Set<String>)childObjectMap.get('ccrz__E_ProductSpec__c');
                deleteChldObjects(productSpecSet, productSpecEntries, responseMap);

                Set<String> relatedProductSet = (Set<String>)childObjectMap.get('ccrz__E_RelatedProduct__c');
                deleteChldObjects(relatedProductSet, relatedProductEntries, responseMap);

                Set<String> productMediaSet = (Set<String>)childObjectMap.get('ccrz__E_ProductMedia__c');
                deleteChldObjects(productMediaSet, productMediaEntries, responseMap);

                Set<String> productCategorySet = (Set<String>)childObjectMap.get('ccrz__E_ProductCategory__c');
                deleteChldObjects(productCategorySet, productCategoryEntries, responseMap);

            }

            String productId = saveProduct(productDetails, responseMap);

            System.debug('productId = ' + productId);

            // Price List Items

            savePriceListEntries(productId, priceListEntries, responseMap);

            // Product Media

            saveProductMediaEntries(productId, productMediaEntries, responseMap);

            // Product Categories

            saveProductCategoryEntries(productId, productCategoryEntries, responseMap);

            // Product Specs

            //processNewSpecs(productSpecEntries);

            saveProductSpecEntries(productId, productSpecEntries, responseMap);

            // Related Products

            saveRelatedProductEntries(productId, relatedProductEntries, responseMap);

            // Create Related Products back references
            createRelatedProductBackRefs(productId, relatedProductEntries, responseMap);

            // Delete Related Products back references
            deleteRelatedProductBackRefs(productId, relatedProductEntries, responseMap);

            // Wrap it up

            responseMap.put('productId', productId);
            responseMap.put('productDataSaved', true);
            responseMap.put('productDataSavedMsg', 'Product data saved successfully');

            // Update the various caches/indexes
            ckz_PIM_UpdateCacheService.doUpdate();

        }
        catch (Exception e) {

            System.debug('rolling back product transactions');
            Database.rollback(sp);

            responseMap.put('productDataSavedMsg', 'Error: ' + e.getMessage());
            System.debug('Error: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());
        }

        System.debug('end putProductData');

        return responseMap;
    }

    private static void savePriceListEntries(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin savePriceListEntries');

        List<ccrz__E_PriceListItem__c> objList = new List<ccrz__E_PriceListItem__c>();

        responseMap.put('priceListItemObjsSaved', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                if(entry.get('priceList') == null) {
                    continue;
                }

                ccrz__E_PriceListItem__c newObj = new ccrz__E_PriceListItem__c();

                newObj.ccrz__Pricelist__c = (String)entry.get('priceList');

                Object price = entry.get('price');

                if(price instanceof Double) {
                    newObj.ccrz__Price__c = (Double)price;
                }
                else {
                    newObj.ccrz__Price__c = Double.valueOf(price);
                }

                setObjStartEndDates(entry, newObj);

                newObj.ccrz__Product__c = productId;

                String sfid = (String)entry.get('sfid');

                if(sfid != null && sfid != '') {
                    System.debug('Existing product price list update');
                    newObj.Id = sfid;
                }
                else {
                    System.debug('New product price list entry');
                }

                objList.add(newObj);
            }

            if(objList.size() > 0) {
                upsert objList;
            }

            responseMap.put('priceListItemObjsSaved', true);
        }
        catch (Exception e) {
            responseMap.put('priceListItemObjsSavedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to save price list item objects');
        }

        System.debug('--- end savePriceListEntries');

    }

    private static void saveProductMediaEntries(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin saveProductMediaEntries');

        List<ccrz__E_ProductMedia__c> objList = new List<ccrz__E_ProductMedia__c>();

        responseMap.put('productMediaItemObjsSaved', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                if(entry.get('mediaType') == null) {
                    continue;
                }

                ccrz__E_ProductMedia__c newObj = new ccrz__E_ProductMedia__c();

                newObj.ccrz__Enabled__c = (Boolean)entry.get('enabled');
                newObj.ccrz__MediaType__c = (String)entry.get('mediaType');
                newObj.ccrz__ProductMediaSource__c = (String)entry.get('mediaSource');
                newObj.ccrz__Sequence__c = (Integer)entry.get('sequence');
                newObj.ccrz__Locale__c = (String)entry.get('locale');
                newObj.ccrz__URI__c = (String)entry.get('uri');
                newObj.ccrz__StaticResourceName__c = (String)entry.get('staticResourceName');
                newObj.ccrz__FilePath__c = (String)entry.get('filePath');

                setObjStartEndDates(entry, newObj);

                newObj.ccrz__Product__c = productId;

                String sfid = (String)entry.get('sfid');

                if(sfid != null && sfid != '') {
                    System.debug('Existing product media update');
                    newObj.Id = sfid;
                }
                else {
                    System.debug('New product media entry');
                }

                objList.add(newObj);

            }

        if(objList.size() > 0) {
            upsert objList;
        }

            responseMap.put('productMediaItemObjsSaved', true);
        }
        catch (Exception e) {
            responseMap.put('productMediaItemObjsSavedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to save product media objects');
        }

        System.debug('--- end saveProductMediaEntries');

    }

    private static void saveRelatedProductEntries(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin saveRelatedProductEntries');

        List<ccrz__E_RelatedProduct__c> objList = new List<ccrz__E_RelatedProduct__c>();

        responseMap.put('relatedProductObjsSaved', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                if(entry.get('relatedProductId') == null) {
                    continue;
                }

                ccrz__E_RelatedProduct__c newObj = new ccrz__E_RelatedProduct__c();

                newObj.ccrz__Enabled__c = (Boolean)entry.get('enabled');
                newObj.ccrz__RelatedProductType__c = (String)entry.get('productType');
                newObj.ccrz__Sequence__c = (Integer)entry.get('sequence');
                newObj.ccrz__RelatedProduct__c = (String)entry.get('relatedProductId');

                setObjStartEndDates(entry, newObj);

                newObj.ccrz__Product__c = productId;

                String sfid = (String)entry.get('sfid');

                if(sfid != null && sfid != '') {
                    System.debug('Existing related product update');
                    newObj.Id = sfid;
                }
                else {
                    System.debug('New related product entry');
                }

                objList.add(newObj);

            }

            if(objList.size() > 0) {
                upsert objList;
            }

            responseMap.put('relatedProductObjsSaved', true);
        }
        catch (Exception e) {
            responseMap.put('relatedProductObjsSavedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to save related product objects');
        }

        System.debug('--- end saveRelatedProductEntries');

    }

    private static void createRelatedProductBackRefs(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin createRelatedProductBackRefs');

        List<ccrz__E_RelatedProduct__c> objList = new List<ccrz__E_RelatedProduct__c>();

        responseMap.put('relatedProductBackRefsCreated', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                if(entry.get('relatedProductId') == null) {
                    continue;
                }

                Boolean hasBackRef = (Boolean)entry.get('hasBackRef');
                String backRefRelProdId = (String)entry.get('backRefRelProdId');

                // Has Back Reference not checked?
                if(hasBackRef == false) {
                    continue;
                }

                // Back Reference Id is not null?
                if(backRefRelProdId != null & backRefRelProdId != '') {
                    continue;
                }

                ccrz__E_RelatedProduct__c newObj = new ccrz__E_RelatedProduct__c();

                newObj.ccrz__Product__c = (String)entry.get('relatedProductId');
                newObj.ccrz__Enabled__c = true;
                newObj.ccrz__RelatedProductType__c = 'CrossSell';
                newObj.ccrz__Sequence__c = 500;
                newObj.ccrz__RelatedProduct__c = productId;

                setObjStartEndDates(entry, newObj);

                objList.add(newObj);

            }

            if(objList.size() > 0) {
                System.debug('relatedProductBackRefs to create = ' + objList.size());
                upsert objList;
            }

            responseMap.put('relatedProductBackRefsCreated', true);
        }
        catch (Exception e) {
            responseMap.put('relatedProductBackRefsCreatedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to create related product back refs');
        }

        System.debug('--- end createRelatedProductBackRefs');

    }

    private static void deleteRelatedProductBackRefs(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin deleteRelatedProductBackRefs');

        List<ccrz__E_RelatedProduct__c> objList = new List<ccrz__E_RelatedProduct__c>();

        responseMap.put('relatedProductBackRefsDeleted', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                if(entry.get('relatedProductId') == null) {
                    continue;
                }

                Boolean hasBackRef = (Boolean)entry.get('hasBackRef');
                String backRefRelProdId = (String)entry.get('backRefRelProdId');

                // Has Back Reference checked?
                if(hasBackRef == true) {
                    continue;
                }

                // Back Reference Id is null?
                if(backRefRelProdId == null | backRefRelProdId == '') {
                    continue;
                }

                ccrz__E_RelatedProduct__c newObj = new ccrz__E_RelatedProduct__c();

                newObj.Id = (String)entry.get('backRefRelProdId');

                objList.add(newObj);

            }

            if(objList.size() > 0) {
                System.debug('relatedProductBackRefs to delete = ' + objList.size());

                delete objList;
            }

            responseMap.put('relatedProductBackRefsDeleted', true);
        }
        catch (Exception e) {
            responseMap.put('relatedProductBackRefsDeletedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to delete related product back refs');
        }

        System.debug('--- end deleteRelatedProductBackRefs');

    }

    private static void saveProductCategoryEntries(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin saveProductCategoryEntries');

        List<ccrz__E_ProductCategory__c> objList = new List<ccrz__E_ProductCategory__c>();

        responseMap.put('productCategoryItemObjsSaved', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                if(entry.get('categoryId') == null) {
                    continue;
                }

                ccrz__E_ProductCategory__c newObj = new ccrz__E_ProductCategory__c();

                System.debug('categoryId = ' + (String)entry.get('categoryId'));

                newObj.ccrz__Category__c = (String)entry.get('categoryId');
                newObj.ccrz__Sequence__c = (Integer)entry.get('sequence');

                setObjStartEndDates(entry, newObj);

                newObj.ccrz__Product__c = productId;

                String sfid = (String)entry.get('sfid');

                System.debug('sfid = ' + sfid);

                if(sfid != null && sfid != '') {
                    System.debug('Existing product category update');
                    newObj.Id = sfid;
                }
                else {
                    System.debug('New product category entry');
                }

                objList.add(newObj);

            }

            if(objList.size() > 0) {
                upsert objList;
            }

            responseMap.put('productCategoryItemObjsSaved', true);
        }
        catch (Exception e) {
            responseMap.put('productCategoryItemObjsSavedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to save product category objects');
        }

        System.debug('--- end saveProductCategoryEntries');

    }

    private static void saveProductSpecEntries(String productId, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin saveProductSpecEntries');

        List<ccrz__E_ProductSpec__c> objList = new List<ccrz__E_ProductSpec__c>();

        responseMap.put('productSpecObjsSaved', false);

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                String sfid = (String)entry.get('sfid');
                
                String specName = (String)entry.get('specName');
                
                String specId = (String)entry.get('specId');

                if(specId != null && specId != '') {
                    
                    ccrz__E_ProductSpec__c newObj = new ccrz__E_ProductSpec__c();
                    
                    if(sfid == null || sfid == '') {
    
                        //String specName = (String)entry.get('specName');
                        System.debug('New product spec entry for: ' + specName);
    
                        newObj.ccrz__Spec__c = specId;
                        newObj.ccrz__Product__c = productId;
                    }
                    else {
                        System.debug('Existing product spec update');
                        newObj.Id = sfid;
                    }
                    
                    newObj.ccrz__SpecValue__c = (String)entry.get('productSpecValue');

                	objList.add(newObj);
                }

            }

            if(objList.size() > 0) {
                upsert objList;
            }

            responseMap.put('productSpecObjsSaved', true);
        }
        catch (Exception e) {
            responseMap.put('productSpecObjsSavedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to save product spec objects');
        }

        System.debug('--- end saveProductSpecEntries');

    }

    private static String saveProduct(Map<String, Object> entry, Map<String, Object> responseMap) {

        System.debug('--- begin saveProduct');

        String productId = null;

        responseMap.put('productObjSaved', false);

        try {

            ccrz__E_Product__c newObj = new ccrz__E_Product__c();
            newObj.Name = (String)entry.get('name');
            newObj.ccrz__SKU__c = (String)entry.get('sku');
            newObj.ccrz__ShortDescRT__c = (String)entry.get('shortDesc');
            newObj.ccrz__LongDescRT__c = (String)entry.get('longDesc');
            newObj.ccrz__ProductStatus__c = (String)entry.get('status');
            newObj.ccrz__SEOTitle__c = (String)entry.get('seoTitle');

            List<Object> selectedStorefronts = (List<Object>)entry.get('selectedStorefronts');
            String temp = '';
            for(Object storefront : selectedStorefronts) {
                if(temp != '') {
                    temp += ';';
                }
                temp += (String)storefront;
            }

            newObj.ccrz__Storefront__c = temp;

            newObj.ccrz__ProductType__c = (String)entry.get('productType');

            setObjStartEndDates(entry, newObj);

            newObj.ccrz__UnitOfMeasure__c = 'Each';
            newObj.ccrz__Quantityperunit__c = 1;

            String sfid = (String)entry.get('sfid');

            if(sfid != null && sfid.equals('') == false) {
                System.debug('Existing product update');
                newObj.Id = sfid;
            }
            else {
                System.debug('New product');
            }

            upsert newObj;

            productId = newObj.Id;

            responseMap.put('productObjSaved', true);
        }
        catch (Exception e) {
            responseMap.put('productObjSavedMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to save product object');
        }

        System.debug('--- end saveProduct');

        return productId;
    }

    private static void setObjStartEndDates(Map<String, Object> entry, sObject newObj) {
        String startDateFmt = (String)entry.get('startDate');  System.debug('startDateFmt: ' + startDateFmt);
        String endDateFmt = (String)entry.get('endDate');  System.debug('endDateFmt: ' + endDateFmt);

        Date startDate = null;

        if(startDateFmt != null && startDateFmt != '') {

            if(startDateFmt.contains('/')) {
                startDate = Date.parse(startDateFmt);
            }
            else {
                startDate = Date.valueOf(startDateFmt);
            }
        }

        Date endDate = null;

        if(endDateFmt != null && endDateFmt != '') {

            if(endDateFmt.contains('/')) {
                endDate = Date.parse(endDateFmt);
            }
            else {
                endDate = Date.valueOf(endDateFmt);
            }
        }

        newObj.put('ccrz__StartDate__c', startDate);
        newObj.put('ccrz__EndDate__c',  endDate);
    }

    private static Map<String, Object> getChildObjectMap(String recordId) {
        List<ccrz__E_Product__c> productList = [SELECT Id, Name,
                ccrz__SKU__c,
                ccrz__Storefront__c,
                ccrz__ShortDesc__c,
                ccrz__LongDesc__c,
                ccrz__SEOTitle__c,
        (SELECT Id, Name FROM ccrz__E_PriceListItems__r),
        (SELECT Id, Name FROM ccrz__Product_Specs__r),
        (SELECT Id, Name FROM ccrz__E_RelatedProducts__r),
        (SELECT Id, Name FROM ccrz__E_ProductMedias__r),
        (SELECT Id, Name FROM ccrz__Product_Categories__r)
        FROM ccrz__E_Product__c where Id = :recordId];

        ccrz__E_Product__c ccProduct = productList.get(0);

        Map<String, Object> productMap = new Map<String, Object>();

        // Stash the Product's Price List Items
        Set<String> priceListItemSet = new Set<String>();
        for(ccrz__E_PriceListItem__c pli : ccProduct.ccrz__E_PriceListItems__r) {
            priceListItemSet.add(pli.Id);
        }

        productMap.put('ccrz__E_PriceListItem__c', priceListItemSet);

        // Stash the Product's Specs
        Set<String> productSpecSet = new Set<String>();
        for(ccrz__E_ProductSpec__c ccProductSpec : ccProduct.ccrz__Product_Specs__r) {
            productSpecSet.add(ccProductSpec.Id);
        }

        productMap.put('ccrz__E_ProductSpec__c', productSpecSet);

        // Stash the Product's Related Products
        Set<String> relatedProductSet = new Set<String>();
        for(ccrz__E_RelatedProduct__c rp : ccProduct.ccrz__E_RelatedProducts__r) {
            relatedProductSet.add(rp.Id);
        }

        productMap.put('ccrz__E_RelatedProduct__c', relatedProductSet);

        // Stash the Product's Media
        Set<String> productMediaSet = new Set<String>();

        for(ccrz__E_ProductMedia__c mp : ccProduct.ccrz__E_ProductMedias__r) {
            productMediaSet.add(mp.Id);
        }

        productMap.put('ccrz__E_ProductMedia__c', productMediaSet);

        // Stash the Product Categories
        Set<String> productCategorySet = new Set<String>();
        for(ccrz__E_ProductCategory__c category : ccProduct.ccrz__Product_Categories__r) {
            productCategorySet.add(category.Id);
        }

        productMap.put('ccrz__E_ProductCategory__c', productCategorySet);
        
        return productMap;
    }
    
    private static void deleteChldObjects(Set<String> currentObjectIdSet, List<Object> entries, Map<String, Object> responseMap) {

        System.debug('--- begin deleteChldObjects');

        List<SObject> objList = new List<SObject>();

        responseMap.put('deleteChldObjects', false);

        Set<String> newObjectIdSet = new Set<String>();
        List<String> deleteObjectIdList = new List<String>();

        try {

            for(Object temp : entries) {

                Map<String, Object> entry = (Map<String, Object>)temp;

                String sfid = (String)entry.get('sfid');

                if(sfid != null && sfid != '') {
                    newObjectIdSet.add(sfid);
                }
                
            }

            for(String currentObjectId : currentObjectIdSet) {
                if(newObjectIdSet.contains(currentObjectId) == false) {
                    deleteObjectIdList.add(currentObjectId);
                }
            }

            if(deleteObjectIdList.size() > 0) {
                Database.delete(deleteObjectIdList, false);
            }

            responseMap.put('deleteChldObjects', true);
        }
        catch (Exception e) {
            responseMap.put('deleteChldObjectsMsg', e.getMessage());

            System.debug('Exception: ' + e.getMessage());
            System.debug('Line Number: ' + e.getLineNumber());

            throw new CustomException('Unable to delete child objects');
        }

        System.debug('--- end deleteChldObjects');

    }

    private static void processNewSpecs(List<Object> entries) {

        Map<String, String> specMap = getSpecs();

        List<ccrz__E_Spec__c> specObjList = new List<ccrz__E_Spec__c>();

        for(Object temp : entries) {

            Map<String, Object> entry = (Map<String, Object>) temp;

            String sfid = (String)entry.get('sfid');

            if(sfid != null && sfid != '') {
                continue;
            }

            String specName = (String)entry.get('specName');

            String specId = null;

            if(specMap.containsKey(specName.toLowerCase())) {
                specId = specMap.get(specName.toLowerCase());
            }

            if(specId != null) {
                entry.put('specId', specId);
            }
            else {
                ccrz__E_Spec__c newSpec = new ccrz__E_Spec__c();
                newSpec.Name = specName;
                newSpec.ccrz__DisplayName__c = specName;
                newSpec.ccrz__FilterDisplayName__c = specName;

                newSpec.ccrz__Locale__c = 'en_US';  // Required or won't show in site
                newSpec.ccrz__SelectType__c = 'Multiple';  // Picklist value
                newSpec.ccrz__SpecGroup__c = 'General';  // Picklist value
                newSpec.ccrz__Sequence__c = 500;

//                // If the Filter Type was not provided, default to Checkbox
//                if (spec.filterType != null && spec.filterType != '') {
//                    newSpec.ccrz__FilterType__c = spec.filterType;
//                }
//                else {
//                    newSpec.ccrz__FilterType__c = 'Checkbox';
//                }

                // 2018-08-29  msobczak:
                newSpec.ccrz__IsComparable__c = true;

            }

        }

    }

    private static Map<String, String> getSpecs() {
        Map<String, String> specMap = new Map<String, String>();

        List<ccrz__E_Spec__c> specObjList = [Select Id, Name from ccrz__E_Spec__c];

        for(ccrz__E_Spec__c specObj : specObjList) {
            specMap.put(specObj.Name.toLowerCase(), specObj.Id);
        }

        return specMap;
    }

    public class CustomException extends Exception {}

}