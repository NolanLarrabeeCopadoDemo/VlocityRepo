({
	doInit : function(component, event, helper) {
        var action = component.get("c.BuildAssetOrderPartsLink");
       action.setParams({
           Community: component.get("v.Community"),
           Store: component.get("v.Store"),
           AssetId: component.get("v.recordId")
       });
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.URL',response.getReturnValue());
                console.log("URL: " + response.getReturnValue())
            }else{
                console.log("error");
            }
        });
		$A.enqueueAction(action);   
	},
    gotoURL : function(component, event, helper) {
        var url = component.get('v.URL');
		window.open(url,'_blank');
    }
})