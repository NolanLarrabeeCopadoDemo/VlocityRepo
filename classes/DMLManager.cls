/**
* @author Salesforce.com
* @date 2021
*
* @description Performs insert,update,delete operations on standard and custom salesforce objects.
*            Handles Security Check before performing any operation.DMLManager is Generic class 
*            that can be used in any apex classes.
*/
public class DMLManager {

    public enum DML_Operation_TYPE {SF_OBJ_INSERT,SF_OBJ_UPDATE,SF_OBJ_DELETE}
    
    //DBInsert to insert a single record
    public static void DBInsert(SObject obj){ DBInsert(new List<SObject>{obj});}
    //DBInsert to update a single record
    public static void DBUpdate(SObject obj){DBUpdate(new List<SObject>{obj});}
    //DBInsert to insert into DB
    public static void DBInsert(List<SObject> objList){ performsfops(objList,DML_Operation_TYPE.SF_OBJ_INSERT); }
    //DBUpdate to update any existing object
    public static void DBUpdate(List<SObject> objList){ performsfops(objList,DML_Operation_TYPE.SF_OBJ_UPDATE); }
    //DBDelete to remove from DB
    public static void DBDelete(List<SObject> objList){ performsfops(objList,DML_Operation_TYPE.SF_OBJ_DELETE); }
    
    
    private static void performsfops(List<SObject> objList,DML_Operation_TYPE operationType){
        
        
        if(objList==null || objList.size()==0)
            return;
        
        if((Limits.getLimitDMLRows() - Limits.getDMLRows()) >= objList.size() ) {
            
            DescribeSObjectResult describeObject = getDescribe(objList[0]);
            
            //Check for Accessibility && Also check whether object is creatable or not
            if(describeObject.isAccessible() && describeObject.isCreateable() && operationType==DML_Operation_TYPE.SF_OBJ_INSERT){
                insert objList;
            }
            //Check for Accessibility && Also check whether object is updatetable or not        
            else if(describeObject.isAccessible() && operationType==DML_Operation_TYPE.SF_OBJ_UPDATE){
                update objList;
            }
            //Check for Accessibility && Also check whether object is deleteable or not
            else if(describeObject.isAccessible() && describeObject.isDeletable() && operationType==DML_Operation_TYPE.SF_OBJ_DELETE ){
                delete objList;
            }
        } 
        
    }
    
    //Get the descriveSObject to check for necessary permissions
    private static DescribeSObjectResult getDescribe(SObject  sboj){
        return sboj.getSObjectType().getdescribe();
    }
}