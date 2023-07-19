@isTest
public class OrderDataLoaderTest {
    
    @isTest
    static void testOrderDataLoader(){
        
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
        
        ProductDataLoader pdl = new ProductDataLoader();
        pdl.createData(dataMap);
        List<product2> product = [Select Id from product2];
        System.assertEquals(6, product.size());
        
        Account a=new Account(Name='Acme');
        insert a;
        
        LoyaltyData orderData = new LoyaltyData();
        orderData.csvLines = [SELECT Id, Body FROM StaticResource WHERE Name = 'OrderTestData' LIMIT 1].Body.toString().split('\n');
        orderData.csvLines.remove(0);
        orderData.numberOfFields = orderData.csvLines.size();
        dataMap.put('Order', orderData);
        
        OrderDataLoader odl = new OrderDataLoader();
        odl.createData(dataMap);
        List<Order> order = [Select Id from order];
        System.assertEquals(2, order.size());
    }


}