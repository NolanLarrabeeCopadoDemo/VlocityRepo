({
    doinit : function(component, event, helper) {
        var action = component.get("c.getUsers");
        action.setCallback(this, function(response){
            var result =response.getReturnValue();
            console.log(result);
            component.set("v.Users",result);
            component.set("v.selected",result[0].Id);
        });
        $A.enqueueAction(action);
    },
    
    changeOwner: function (component, event, helper) {
        let selectedV = component.find("usr").get("v.value");
        component.set('v.selected',selectedV);
        console.log(component.get('v.selected'));
    }
})