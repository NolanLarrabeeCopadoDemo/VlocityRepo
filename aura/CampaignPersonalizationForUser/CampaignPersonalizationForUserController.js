({
	doInit : function(component, event, helper) {
        var campId = component.get("v.campaignId");
        console.log('finally sent campaign id--'+campId);
        
        var memName = component.find("memName");
        var member = memName.get("v.value");
        var memFname = member.split(" ");
        
        component.set("v.selectedMember", memFname[0]);
        
        let action = component.get("c.getEmailInfo");
        action.setParams({
            campaignId: campId
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log("state--"+state)
            if (state === "SUCCESS") {
                console.log("campaign email details--"+JSON.stringify(response.getReturnValue()));
                component.set('v.campDet', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
	}
})