({
    //Showing all added members to campaign
    loadContactList: function(component, event, helper) {
        helper.onLoad(component, event);
    },
    
    //Counting the selected checkboxes. 
    checkboxSelect: function(component, event, helper) { 
        let selectedRec = event.getSource().get("v.value");
        let getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        component.set("v.selectedCount", getSelectedNumber);
    },
    
    //For select all functionality 
    selectAll: function(component, event, helper) {
        let selectedHeaderCheck = event.getSource().get("v.value");
        let getAllId = component.find("selRecord");
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                component.find("selRecord").set("v.value", true);
                component.set("v.selectedCount", 1);
            }else{
                component.find("selRecord").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        }else{ 
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("selRecord")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("selRecord")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            } 
        }  
        
    },
    
    //For Approving selected records 
    approveSelected: function(component, event, helper) {
        let approveId = [];
        
        let getAllId = component.find("selRecord");
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                approveId.push(getAllId.get("v.text"));
            }
        }
        else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    approveId.push(getAllId[i].get("v.text"));
                }
            }
        } 
        //Passing all approved record Ids to helper
        helper.approveSelectedHelper(component, event, approveId);
        
    },
    
    //For Rejecting selected record
    rejectSelected: function(component, event, helper) {
        let rejectId = [];
        
        let getAllId = component.find("selRecord");
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                rejectId.push(getAllId.get("v.text"));
            }
        }
        else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    rejectId.push(getAllId[i].get("v.text"));
                }
            }
        }  
        //Passing all rejected record Ids to helper
        helper.rejectSelectedHelper(component, event, rejectId);
        
    },
    
    //For opening Modal
    openPersonalizeModal: function(component, event, helper) {
        component.set("v.modOpen", true);
        console.log('opening model');
    },
    
    //For closing Modal
    closePersonalizeModal: function(component, event, helper) {  
        component.set("v.modOpen", false);
    },
    
    //For saving changes in Modal
    savePersonalization: function(component, event, helper) {
        component.set("v.modOpen", false);
    },
    
    submitMembers : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Campaign Members Approved Successfully.",
            "type": "Success"
        });
        toastEvent.fire();
    }
})