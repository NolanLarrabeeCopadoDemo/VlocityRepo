({
	init : function(component, event, helper) {
		var recid = component.get("v.recid");
		var endpoint = '/api/videos?id=' + recid ;
        var callout = component.get("c.getCalloutResponseContents");
        callout.setParams({
            endpoint: endpoint
        });
		callout.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.Data",JSON.parse(response.getReturnValue()));
                var res = JSON.parse(response.getReturnValue());  
                for(var i = 0; i < res.length; i++){
                    component.set("v.RecordName", res[i].name); 
                }
                helper.MixpanelCallout(component, event, helper);
            }
        });
		$A.enqueueAction(callout); 
	},
    back: function(component, event, helper) {
        component.set("v.recid",'');
    }, 
    toURL : function(component, event, helper) {
        var whichOne = event.currentTarget.id;
        window.open(whichOne);
    },
    ShareableURL: function(component, event, helper) {
        var ind = component.get("v.Industry");
        var page = component.get("v.ScreenChoice");
        var RecordId = event.currentTarget.id;
        component.set("v.ShareableURL",'/c/KnowtheIDO.app?Industry='+ind+'&ScreenChoice=Videos&recid=' + RecordId);
        
        var cmpTarget = component.find('ShareModal');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
		$A.util.removeClass(cmpTarget, 'slds-fade-in-closed');
        
        var cmpTarget2 = component.find('overlay');
        $A.util.addClass(cmpTarget2, 'slds-backdrop_open');
		$A.util.removeClass(cmpTarget2, 'slds-backdrop_closed');
    },
    CloseDialog : function(component, event, helper) {
        var cmpTarget = component.find('ShareModal');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpTarget, 'slds-fade-in-closed');
            
        var cmpTarget2 = component.find('overlay');
        $A.util.removeClass(cmpTarget2, 'slds-backdrop_open');
        $A.util.addClass(cmpTarget2, 'slds-backdrop_closed');
    },
})