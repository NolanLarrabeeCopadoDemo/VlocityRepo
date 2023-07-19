({
    init : function(component, event, helper) {
        var action = component.get("c.GetSettings");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.DemoSettings",response.getReturnValue());
            }
        });
		$A.enqueueAction(action);
        
        var Start = component.get('c.BaseURL');
        $A.enqueueAction(Start);        
	}, 
    BaseURL : function(component, event, helper) {
        var action = component.get("c.getBaseURL");
		action.setCallback(this, function(response) {
			var SessionId= response.getReturnValue();
        	component.set("v.BaseURL", SessionId);
            var sid = component.get("v.BaseURL");
        });
		$A.enqueueAction(action);
    }, 
    checkValidity : function(component, event, helper) {
        var validity = event.getSource().get("v.validity");
    },
    toggleChange : function(component, event, helper) {
        var changedOne = event.currentTarget.id;
        /* Now that we know which was changed, call the helper function to handle the setup steps */
        helper.HandleEventFiring(component, event, helper, changedOne);
    },
})