@isTest
public class ProductDataLoaderTests {
    
    @isTest
    public static void testProductDataLoader(){
        
        Pricebook2 pricebook = new Pricebook2(Name = 'Sample App', Description = 'Sample App', IsActive = true );
        insert pricebook;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
		Update standardPricebook;
        
        
        Map<String, LoyaltyData> dataMap = new Map<String, LoyaltyData>();
        LoyaltyData productData = new LoyaltyData();
        productData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'Product2TestData' LIMIT 1].Body.toString().split('\n');
        productData.csvLines.remove(0);
        productData.numberOfFields = productData.csvLines.size();
        dataMap.put('Product2', productData);
        
        LoyaltyData productCategoryData = new LoyaltyData();
        productCategoryData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'ProductCategoryTestData' LIMIT 1].Body.toString().split('\n');
        productCategoryData.csvLines.remove(0);
        productCategoryData.numberOfFields = productCategoryData.csvLines.size();
        dataMap.put('ProductCategory', productCategoryData);
        
        ProductDataLoader pdl = new ProductDataLoader();
        pdl.createData(dataMap);
        List<product2> product = [Select Id from product2];
        System.assertEquals(6, product.size());
        
        List<ProductCategory> productCategory = [Select Id from ProductCategory];
        System.assertEquals(10, productCategory.size());
    }

}