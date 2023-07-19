({
	doInit: function(component, event, helper) {
         //var url = $A.get('$Resource.Manufacturing');
		//	url =url+'/Manufacturing/img/Signup.png'; 
       	//	component.set('v.bgImageURL', url);
         
    },
    createMembership: function(component, event, helper) {
        // Create the action
        var action = component.get("c.createProgramMember");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                window.location.reload()
            }
            
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
     Showhide : function(component, event, helper) {
        let checkBoxState = component.get("v.termsandConditionflag");
         console.log('::::'+!checkBoxState);
         console.log('::::compone:::'+component.get("v.termsandConditionflag"));
        component.find("joinMembershipBtn").set("v.disabled", !checkBoxState);
    }
    
    

})