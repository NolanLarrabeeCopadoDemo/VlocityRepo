public class GetObjectType {

    public class GetRecordDataException extends Exception {}
    
    @InvocableMethod
    public static String[] returnObjectType (Id[] recordIds) {
        try {
            return new String[]{recordIds[0].getSobjectType().getDescribe().getName()};
        } catch (Exception e) {
            throw new GetRecordDataException('Error: invalid record ID');
        }
    }
}