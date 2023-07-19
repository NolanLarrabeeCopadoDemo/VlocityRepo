({
	doInit: function(component, event, helper) {
        var urlString = window.location.href;
 			//var baseURL = urlString.substring(0, urlString.indexOf("/s/"));
        var baseURL = urlString.substring(urlString.indexOf(".com/")+5,urlString.indexOf("/s/")+3);
 			//var baseURL = urlString.substring(urlString.indexOf("/s/"), urlString.length - urlString.indexOf("/s/"));
 		component.set("v.cbaseURL", baseURL);
        
        var recId = component.get("v.recordId");
        console.log("Record ID: " + recId);
        
		var action = component.get("c.getAssets"); 
        action.setParams({"recordId":recId})
        action.setCallback(this, function(a) {         
        	component.set("v.Assets", a.getReturnValue());
            console.log("Get Assets called with: " + component.get("v.Assets"));
        }); 
        $A.enqueueAction(action);
        
        var action2 = component.get("c.getAssetMetrics"); 
        action2.setParams({"recordId":recId});
        action2.setCallback(this, function(a) {            
            component.set("v.AssetMetrics", a.getReturnValue());
            console.log("Get AssetMetrics called with: " + component.get("v.AssetMetrics"));
        });
        $A.enqueueAction(action2);          
         
        var urlString = window.location.href;
 			//var baseURL = urlString.substring(0, urlString.indexOf("/s/"));
        var baseURL = urlString.substring(urlString.indexOf(".com/")+5,urlString.indexOf("/s/")+3);
 			//var baseURL = urlString.substring(urlString.indexOf("/s/"), urlString.length - urlString.indexOf("/s/"));
 			component.set("v.cbaseURL", baseURL);
    }       
 }
)