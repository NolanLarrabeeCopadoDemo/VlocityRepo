({
	saveVal: function(component, event, helper) {
        var campaignId = component.get("v.campaignId");
        console.log('In modal--'+campaignId);
        
        var intro = component.get("v.introduction");
        console.log(intro);
        
        var conclusion = component.get("v.conclusion");
        console.log(conclusion);
        
        /*var headerURL = component.get("v.headerURL");
        console.log(headerURL);*/
        
        let action = component.get("c.savePersonalization");
        
        action.setParams({
            campaignId: campaignId,
            Introduction: intro,
            Conclusion: conclusion
        });
        
         action.setCallback(this, function(response) {
            let state = response.getState();
            console.log("state--"+state)
            if (state === "SUCCESS") {
                console.log("saved intro and conclu--");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Personalizations have been saved!",
                    "type": "Success"
                });
                toastEvent.fire();
            }
             else {
                 console.log("error in saving intro and conclu!");
             }
        });
        $A.enqueueAction(action);
    }
})