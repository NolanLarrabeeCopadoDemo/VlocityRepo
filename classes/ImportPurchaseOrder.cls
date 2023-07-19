/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-06-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class ImportPurchaseOrder {
    public ImportPurchaseOrder() {

    }
    

@InvocableMethod(label='Parse CSV/Excel' description='Parsing file and create PO lines' )
public static void parsePurchaseFile(List<Id> conDocId) {
    String PurchaseOrderId ;
    String fileToString;
    list<String> lines          = new list<String>();
    List<ContentVersion> cvList = new List<ContentVersion>();
    List<ContentDocumentlink> cdList = new list<ContentDocumentlink>();
    String[] lineValues; 
    List<Purchase_Order_Lines__c> polines_lst = new List<Purchase_Order_Lines__c>();
    cvList= [SELECT VersionData,Title,id FROM ContentVersion WHERE ContentDocumentId in:conDocId AND IsLatest = true];
    
    if (cvList.size()>0){
    System.debug(CvList[0].VersionData);
    
   
        cdList = [Select id,LinkedEntityId from ContentDocumentlink where contentdocumentid=:conDocId];
        System.debug(cdList[0].LinkedEntityId);
        If (cdList.size()>0){
            for(integer cnt=0; cnt< cdList.size();cnt++){
                if(!string.ValueOf(cdList[cnt].LinkedEntityId).startsWith('005'))
                PurchaseOrderId = cdList[cnt].LinkedEntityId;
            }
        }

    
    
    
    
    
    fileToString = CvList[0].VersionData.toString();
    lines = fileToString.split('\r');

    system.debug('#### file '+fileToString);
    for(Integer i=1; i< lines.size(); i++) {
                // Skip blank CSV lines (only commas)
                if (lines[i].replaceAll(',','').trim().length() == 0) break;
                lineValues = lines[i].split(',');
                if (lineValues.size()>0){
                Purchase_Order_Lines__c obj = new Purchase_Order_Lines__c();
                List<product2> prodlist = new list<product2>();
                prodlist= [Select id from Product2 where name =: lineValues[2]];
                if(prodlist.size()>0)
                obj.Product__c = prodlist[0].id;
                obj.List_Price__c = Decimal.valueOf(lineValues[4]);
                obj.Quantity__c = Decimal.valueOf(lineValues[3]);
                obj.Total_Price__c = Decimal.valueOf(lineValues[5]);
                obj.Purchase_Order__c = PurchaseOrderId;
                polines_lst.add(obj);
                }
                
    }
 
    if(polines_lst.size()>0)
    insert polines_lst;
    
    
    
}
   
    
    
    
}
    
   

//return polines_lst;
}