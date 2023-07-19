({
    //For getting all the added members
    onLoad: function(component, event) {
        console.log('Init from pending approvals');
        let campaignId = component.get("v.campaignId");
        
        console.log('first-'+campaignId);
        
        if(window.location.href.includes('campaign-pending-members')) {
            console.log('Inside community if--');
            var url = (new URL(window.location.href)).searchParams;
            console.log(url);
            campaignId = url.get('cId');
        } 
        
        console.log(campaignId);
        
        let action = component.get('c.fetchCampaignMembers');
        action.setParams({
            campaignId: campaignId
        })
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log("state--"+state)
            if (state === "SUCCESS") {
                component.set("v.campaignId", campaignId);
                console.log("member list--"+JSON.stringify(response.getReturnValue()));
                component.set('v.memberList', response.getReturnValue());
                component.set("v.selectedCount", 0);
                component.set("v.totalAddedMembers", response.getReturnValue().length)
                component.find("box3").set("v.value", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    //For getting all the approved members
    approveSelectedHelper: function(component, event, approveRecordsIds) {
        console.log('approve record ids reached in helper---'+approveRecordsIds);
        let campaignId = component.get("v.campaignId");
        var approvedMembers = approveRecordsIds.length;
        
        //call apex class method to do further processing
        let action = component.get('c.saveApprovedMemberNo');
        action.setParams({
            campaignId: campaignId,
            "appnum": approvedMembers
        })
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log("state--"+state)
            if (state === "SUCCESS") {
                console.log("campaign message from approve--"+JSON.stringify(response.getReturnValue()));
                component.set('v.campaignMsgApp', response.getReturnValue());
                component.set('v.approvedMemId', approveRecordsIds);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The members are accepted successfully.",
                    "type": "Success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    //Just rejecting some members
    rejectSelectedHelper: function(component, event, rejectRecordsIds) {
        console.log('rejected record ids reached in helper---'+rejectRecordsIds);
        let campaignId = component.get("v.campaignId");
        var rejectedMembers = rejectRecordsIds.length;
        
        //call apex class method to do further processing (TBD)
        let action = component.get('c.saveRejectedMemberNo');
        action.setParams({
            campaignId: campaignId,
            "rejnum": rejectedMembers
        })
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log("state--"+state)
            if (state === "SUCCESS") {
                console.log("campaign message from reject--"+JSON.stringify(response.getReturnValue()));
                component.set('v.campaignMsgRej', response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The members are rejected successfully.",
                    "type": "Success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
    
})