global with sharing class CloneSalesAgreementActuals {
    @InvocableMethod
    public static List<UpdateProductScheduleResult> CloneNewAgreementSchedule(List<UpdateProductScheduleParameters> newSAList) {
        Map<String,Map<String,Integer>> oldSchedule = new Map<String,Map<String,Integer>>();
        List<SalesAgreementProductSchedule> listUpdateSAPS = new List<SalesAgreementProductSchedule>();
        List<UpdateProductScheduleResult> results = new List<UpdateProductScheduleResult>();
        //
        //Loop through parameters list
        for(UpdateProductScheduleParameters parameters : newSAList) {
            UpdateProductScheduleResult result = new UpdateProductScheduleResult();
            String newSAId = parameters.newSAId;
            String oldSAId = parameters.oldSAId;
            //
            //Loop and get old SAPS records and add to Map
            for (SalesAgreementProductSchedule oldSAPS : [select Name,ActualQuantity, SalesAgreementProduct.ProductId from SalesAgreementProductSchedule where SalesAgreementProduct.SalesAgreementId=:oldSAId]) {
                if(!oldSchedule.containskey(oldSAPS.SalesAgreementProduct.ProductId)) {
                    oldSchedule.put(oldSAPS.SalesAgreementProduct.ProductId,new map<String,Integer>());
                }

                oldSchedule.get(oldSAPS.SalesAgreementProduct.ProductId).put(oldSAPS.Name,oldSAPS.ActualQuantity);
            }
            //
            //Loop and through new SAPS records
            for (SalesAgreementProductSchedule newSAPS : [select Id, Name,ActualQuantity, SalesAgreementProduct.ProductId from SalesAgreementProductSchedule where SalesAgreementProduct.SalesAgreementId=:newSAId]) {
                //Get matching value from old schedule based on ProductId and Name
                    SalesAgreementProductSchedule updateSAPs = new SalesAgreementProductSchedule();
                    updateSAPs.Id=newSAPS.Id;
                   // updateSAPs.PlannedQuantity = oldSchedule.get(newSAPS.SalesAgreementProduct.ProductId).get(newSAPS.Name);
                    updateSAPs.ActualQuantity = oldSchedule.get(newSAPS.SalesAgreementProduct.ProductId).get(newSAPS.Name);
                    listUpdateSAPS.add(updateSAPs); 
            }
            
            //Update new Sales Agreement Product Schedule records
            update listUpdateSAPS;
            //System.debug(listUpdateSAPS);
            
            result.message='Updated product schedules for Sales Agreement Id: ' + newSAId;
            results.add(result);
        }
        
        return results;
    }
    
    global class UpdateProductScheduleResult {
        @InvocableVariable
        global string message;
    }
    
    global class UpdateProductScheduleParameters {
        @InvocableVariable(required=true)
        global string newSAId;
        
        @InvocableVariable(required=true)
        global string oldSAId;
    }
}