({
	doInit: function(component, event, helper) {
        
        var urlString = window.location.href;
 			//var baseURL = urlString.substring(0, urlString.indexOf("/s/"));
        var baseURL = urlString.substring(urlString.indexOf(".com/")+5,urlString.indexOf("/s/")+3);
 			//var baseURL = urlString.substring(urlString.indexOf("/s/"), urlString.length - urlString.indexOf("/s/"));
 		component.set("v.cbaseURL", baseURL);
        
        var recId = component.get("v.recordId");
        console.log("record id: " + recId);
        
        //var action = component.get("c.getAssetsAccount"); // method in the apex class
		var action = component.get("c.getAsset"); // method in the apex class
        action.setParams({"recordId":recId});
        action.setCallback(this, function(a) {  
            console.log("Asset Value: " + JSON.stringify(a.getReturnValue()));
        	component.set("v.Assets", a.getReturnValue());
            
        }); // variable in the component
        $A.enqueueAction(action);
        
        var action2 = component.get("c.getAssetMetrics"); // method in the apex class
        action2.setParams({"recordId":recId});
        action2.setCallback(this, function(a) {    
            console.log("AssetMetrics Value: " + JSON.stringify(a.getReturnValue()));
            component.set("v.AssetMetrics", a.getReturnValue())
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