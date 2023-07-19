public class OrderStartDateController{
    @InvocableMethod(label='Get Order Start Date' description='Uses the Sales Agreement start and end dates as well as the old order start date to get the start date for the new order.')
    public static List<NewOrderDate> getOrderStartDate(List<InputDates> inputDates){
        List<NewOrderDate> orderStartDates = new List<NewOrderDate>();

        for(InputDates dates : inputDates){
            NewOrderDate newOrderDateClass = new NewOrderDate();

            Date saStartDate = dates.saStartDate;
            Date saEndDate = dates.saEndDate;
            Date oldOrderDate = dates.oldOrderDate;
            
            Date newOrderDate;
            
            if(saStartDate <= oldOrderDate && oldOrderDate <= saEndDate){
                newOrderDate = oldOrderDate;
            } else if(saEndDate < oldOrderDate) {  
                newOrderDate = saEndDate;
            } else {
                Integer startDateMonth = saStartDate.Month();
                Integer orderDateMonth = oldOrderDate.Month();
                Integer monthDifference;
                if(startDateMonth > orderDateMonth){
                    monthDifference = startDateMonth - orderDateMonth;
                } else if(startDateMonth < orderDateMonth){
                    monthDifference = orderDateMonth - startDateMonth;  
                } else {
                    monthDifference = 1;
                }
                
                newOrderDate = saStartDate.addMonths(monthDifference);  
                if(newOrderDate > saEndDate){
                    newOrderDate = saEndDate;
                }   
            }
            
            newOrderDateClass.newOrderDate = newOrderDate;
            orderStartDates.add(newOrderDateClass);
        }
        
        return orderStartDates; 
    }  

    public class InputDates{
        @InvocableVariable
        public Date saStartDate;

        @InvocableVariable
        public Date saEndDate;
        
        @InvocableVariable
        public Date oldOrderDate;
    }

    public class NewOrderDate{        
        @InvocableVariable
        public Date newOrderDate;
    }
}