public class Q2CBillNow {

    public Id OrderId { get; set; }
    private ApexPages.StandardController Controller;

// This is an Extension Controller. Thus, we must invoke the standard controller.
    public Q2CBillNow(ApexPages.StandardController controller) {
        this.OrderId = controller.getId();
        this.Controller = controller;
    }

// Method for creating Quote 
    public PageReference billNow() {
        Id a = this.OrderId;
        Order thisOrder = [SELECT blng__BillNow__c FROM Order WHERE Id = :a];
        thisOrder.blng__BillNow__c = true;
        update thisOrder;
        return this.Controller.view();
    }
    
    public PageReference ActivateAndContracted() {
        Id a = this.OrderId;
        Order thisOrder = [SELECT blng__BillNow__c, Status, SBQQ__Contracted__c FROM Order WHERE Id = :a];
        thisOrder.blng__BillNow__c = true;
        thisOrder.Status = 'Activated';
        thisOrder.SBQQ__Contracted__c = TRUE;
        update thisOrder;
        return this.Controller.view();
    }
}