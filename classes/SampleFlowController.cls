public class SampleFlowController {

    @InvocableMethod
    public static List<List<SObject>> getRecordsFromIds(List<GetRecordsRequest> reqs) {
        GetRecordsRequest req = reqs[0];
        List<String> ids = req.idString.replaceAll(' ','').split(';');
        String objectName = Id.valueOf(ids[0]).getSObjectType().getDescribe().getName();
        String fieldString = req.fieldString;
        List<SObject> records = Database.query('SELECT '+ fieldString +' FROM '+ objectName +' WHERE Id IN: ids');
        return new List<List<SObject>>{records};
    }
    
    public class GetRecordsRequest {   
        @InvocableVariable public String idString;
        @InvocableVariable public String fieldString;
    }
}