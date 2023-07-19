/**
*  Load Data for below Entities
* 		1. Product2
* 		2. ProductCategory
**/
public inherited sharing class ProductDataLoader {
    
    public Map<String, String> productIds = new Map<String, String>();
    public Map<String, String> productCategoryIds = new Map<String, String>();
    public Map<String, String> priceBookIds = new Map<String, String>();
	private  List<boolean>  status=new List<Boolean>();
    
    public ProductDataLoader(){
        status.add(true);
        status.add(false);
    }
    public void createData(Map<String, LoyaltyData> dataMap) {
        

        if(dataMap.get('ProductCategory') != null) {
            createProductCategoryData(dataMap.get('ProductCategory'));
        }
        
        if(dataMap.get('Product2') != null) {
            createProduct2Data(dataMap.get('Product2'));
        }
        
    }
    
    public void createProduct2Data(LoyaltyData productData){
        
        Pricebook2 standardPb = [select id from Pricebook2 where isStandard = true  WITH SECURITY_ENFORCED];
        
        Set<String> priceBookNames = new Set<String>(); 
        Set<String> productCategoryNames = new Set<String>();
        for(String csvLine : productData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(csvData[3] != null && csvData[3] != ''){
                priceBookNames.add(csvData[3]);
            } 
            if( csvData[4] != null && csvData[4] != '') {
                productCategoryNames.add(csvData[4]);
            }
        }
        retrievePriceBookIds(priceBookNames);
        retrieveProductCategoryIds(productCategoryNames);
        List<Product2> products = new List<Product2>();
        Map<String, PricebookEntry> priceBookEntryMap = new Map<String, PricebookEntry>();
        
        Integer count = 0;
        for(String csvLine : productData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            Product2 product = new Product2(
                                            Name = csvData[0],
                                            Description = csvData[1],
                							IsActive = status[0]
            );
            List<String> ids=new List<String>();
            ids.add(standardPb.Id);
            ids.add(product.id);

            PricebookEntry standardPricebookEntry = new PricebookEntry(
                                                                        Pricebook2Id = ids[0],
                                                                        UnitPrice = Utils.isEmptyOrNull(csvData[2]) ? null : Double.valueOf(csvData[2]),
                                                                        IsActive = status[0],
                                                                        Product2Id = ids[1]);
            priceBookEntryMap.put(product.Name+'_standard' , standardPricebookEntry);
            if(csvData[3] != null && csvData[3] !='' ) {
                if(priceBookIds.get(csvData[3]) == null) {
                    throw new ValidationException('No Pricebook found named ---' + csvData[3]+'----'+priceBookIds);
                }
                ids.clear();
                ids.add(priceBookIds.get(csvData[3]));
                ids.add(product.id);
                PricebookEntry pbe = new PricebookEntry(
                                                        Pricebook2Id = ids[0],
                                                        UnitPrice = Utils.isEmptyOrNull(csvData[2]) ? null : Double.valueOf(csvData[2]),
                                                        IsActive = status[0],
                                                        Product2Id =ids[1]);
                priceBookEntryMap.put(product.Name+'_'+csvData[3] , pbe);
            } 
           
             
            products.add(product);
            count++;
            if(count == 200) {
                insert products;
                for(Product2 pr : products) {
                    productIds.put(pr.Name, pr.Id);
                }
                products.clear();
                count = 0;
            } 
        }
        
        if(count > 0) {
            insert products;
            for(Product2 pr : products) {
            	productIds.put(pr.Name, pr.Id);
			}
			products.clear();
        }
        count = 0;
        List<PricebookEntry>PriceBookEntries=new List<PricebookEntry>();
        for(String entry : priceBookEntryMap.keySet()){
            List<String> ids=new List<String>();
            ids.add(productIds.get(entry.split('_')[0]));
            PricebookEntry pricebook = priceBookEntryMap.get(entry);
            pricebook.Product2Id  = ids[0];
			PriceBookEntries.add(pricebook);
            count++;
            if(count == 200) {
                DMLManager.DBInsert(PriceBookEntries);
                PriceBookEntries.clear();
                count = 0;
            } 
        }
        DMLManager.DBInsert(PriceBookEntries);
        count=0;
        List<ProductCategoryProduct> productCategoryList=new List<ProductCategoryProduct>();
        for(String csvLine : productData.csvLines){
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(csvData.size()<5){
               continue; 
            }
             
            List<String> ids=new List<String>();
            ids.add(productIds.get(csvData[0]));
            if( !productCategoryIds.containsKey( csvData[4])) {
            	throw new ValidationException('No Product Category found named '+ csvData[4]+ ' in the system or as part of upload');    
            } 
            ids.add(productCategoryIds.get(csvData[4]));
            ProductCategoryProduct productsCategory=new ProductCategoryProduct(IsPrimaryCategory=status[0],
            																   ProductId=ids[0],
                                                                               ProductCategoryId=ids[1]);
            
            productCategoryList.add(productsCategory);
            count++;
            if(count==200){
                DMLManager.DBInsert(productCategoryList);
                productCategoryList.clear();
                count=0;
            }
        }
        if(count>0){
            DMLManager.DBInsert(productCategoryList);
        } 
    }
    
    public void createProductCategoryData(LoyaltyData productCategoryData) {
        
        Set<String> catalogNames = new Set<String>();
        for(String csvLine : productCategoryData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            if(csvData[1] != '' && csvData[1] != null) {
                catalogNames.add(csvData[1]);
            } else {
                catalogNames.add(csvData[0]);
            }
        }
        Map<String, String> catalogIds = createProductCatalogs(catalogNames);
        
        List<ProductCategory> categories = new List<ProductCategory>();
        Integer count = 0;
        for(String csvLine : productCategoryData.csvLines) {
            String[] csvData = LoyaltyDataLoadController.splitCsvLine(csvLine);
            ProductCategory category = new ProductCategory(Name = csvData[0]);
            if(csvData[1] != '' && csvData[1] != null) {
                category.CatalogId = catalogIds.get(csvData[1]);
            } else {
                category.CatalogId = catalogIds.get(csvData[0]);
            }
            categories.add(category);
            count++;
            if(count == 200) {
                insert categories;
                for(ProductCategory pc : categories) {
                    productCategoryIds.put(pc.Name, pc.Id);
                }
                categories.clear();
                count = 0;
            }
        }
        if(count > 0) {
            insert categories;
            for(ProductCategory pc : categories) {
            	productCategoryIds.put(pc.Name, pc.Id);
            }
        }
    }
    
    public Map<String, String> retrieveProductIds(Set<String> productNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String productName : productNames) {
            if(productIds.get(productName) == null) {
                namesToQuery.add(productName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            Product2[] product = [select Id, Name from Product2 where Name in :namesToQuery  WITH SECURITY_ENFORCED];
            for(Product2 p2 : product) {
                productIds.put(p2.Name, p2.Id);
            }
        }
        
        return productIds;
    }
    
    public Map<String, String> retrieveProductCategoryIds(Set<String> productCategoryNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String productCategoryName : productCategoryNames) {
            if(productCategoryIds.get(productCategoryName) == null) {
                namesToQuery.add(productCategoryName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            ProductCategory[] productCategory = [select Id, Name from ProductCategory where Name in :namesToQuery  WITH SECURITY_ENFORCED];
            for(ProductCategory pc : productCategory) {
                productCategoryIds.put(pc.Name, pc.Id);
            }
        }
        
        return productCategoryIds;
    }
    
    public Map<String, String> retrievePriceBookIds(Set<String> priceBookNames) {
        Set<String> namesToQuery = new Set<String>();
        for(String priceBookName : priceBookNames) {
            if(priceBookIds.get(priceBookName) == null) {
                namesToQuery.add(priceBookName);
            }
        }
        
        if(namesToQuery.size() > 0) {
            Pricebook2[] pricebook = [select Id, Name from Pricebook2 where Name in :namesToQuery   WITH SECURITY_ENFORCED];
            for(Pricebook2 pc : pricebook) {
                priceBookIds.put(pc.Name, pc.Id);
            }
        }
        List<Pricebook2> remaining=new List<Pricebook2>();
            Integer count=0;
            for(String priceBookName:priceBookNames){
                if(priceBookids.get(priceBookName)==null){
                   List<String> ids=new List<String>();
                    ids.add(priceBookName);
                   remaining.add(new PriceBook2(Name=ids[0], isActive = status[0])); 
                    count++;
                    if(count==200){
                        insert remaining;
                        count=0;
                    }
                    
                }
            }
            
            if(count>0)
                 insert remaining;
            for(PriceBook2 rem:remaining){
                priceBookIds.put(rem.Name,rem.Id);
            }         
        return priceBookIds;
    }
    
    public Map<String, String> createProductCatalogs(Set<String> catalogNames) {
        Map<String, String> catalogIds = new Map<String, String>();
        if(catalogNames.size() > 0) {
            ProductCatalog[] pcs = [select Id, Name from ProductCatalog where Name in :catalogNames  WITH SECURITY_ENFORCED];
            for(ProductCatalog pc : pcs) {
                catalogIds.put(pc.Name, pc.Id);
            }
            
            // create if not present
            List<ProductCatalog> catalogs = new List<ProductCatalog>();
            Integer count = 0;
            for(String catalogName : catalogNames) {
                if(catalogIds.get(catalogName) == null) {
                    ProductCatalog catalog = new ProductCatalog();
                    catalog.Name = catalogName;
                    catalogs.add(catalog);
                    count++;
                    if(count == 200) { 
                        insert catalogs;
                        for(ProductCatalog pc : catalogs) {
                            catalogIds.put(pc.Name, pc.Id);
                        }
                        catalogs.clear();
                        count = 0;
                    }
                }
            }
            if(count > 0) {
                insert catalogs;
                for(ProductCatalog pc : catalogs) {
                	catalogIds.put(pc.Name, pc.Id);
                }
            }
        }
        
        return catalogIds;
    }
}