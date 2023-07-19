({
    HandleEventFiring : function(component, event, helper,whichone) { 
        console.log("whichone: " + whichone);
        if(whichone == 'Required_Setup'){
        	helper.RequiredSetup(component, event, helper);
            helper.UpdateEnabledField(component, event, helper, whichone);
        }else if(whichone == 'B2B_Commerce_Setup'){
        	helper.B2BVFURL(component, event, helper);
            helper.RunB2BSetup(component, event, helper);
            helper.UpdateEnabledField(component, event, helper, whichone); 
        }else if(whichone == 'IoT_Setup'){
        	helper.runIot(component, event, helper);
            helper.UpdateEnabledField(component, event, helper, whichone); 
        }else{
            helper.ToastNotification('No Method Found', 'Have you setup your methods?', 'error');
        }
    },
    
    /** Run all B2B Setup steps **/
    RunB2BSetup : function(component, event, helper){
        var action = component.get("c.B2BSetup");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.ToastNotification('B2B Setup Finished!', 'Finished Setting Update B2B', 'success');
            }
        });
		$A.enqueueAction(action);
    },
    /** Create Base URL For VF Iframe **/
    B2BVFURL : function(component, event, helper){
        var action = component.get("c.B2BUrl");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.ToastNotification('B2B URL Updated!', 'Updated Visualforce page URL', 'success');
            }
        });
		$A.enqueueAction(action);
    },
    /** Update Kenandy Setup Config Values */
	RequiredSetup : function(component, event, helper){ 
        var action = component.get("c.RunRequiredSetup");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.ToastNotification('Required Setup Complete!', 'We have ran the required Setup Steps', 'success');
            }else{
                console.log("error")
            }
        });
		$A.enqueueAction(action);
        
        helper.StartDataFlow(component, event, helper);
    },
    /** EA - Run Data Sync for Dataflows **/
    StartDataFlow : function(component, event, helper){ 
        window.setTimeout(
            $A.getCallback(function() {
                var iframe = document.createElement('iframe');
                var base = component.get("v.BaseURL");
                iframe.src = base + '/apex/DemoSetupWaveAcc';
                document.getElementById('iframe_dataflow').appendChild(iframe);
        	}), 500
        );
    },
    /** Update Demo Setting to enabled **/
    UpdateEnabledField  : function(component, event, helper,whichone) { 
       var action = component.get("c.UpdateDemoSetting");
        action.setParams({
            WhichSetting: whichone,
        });
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.DemoSettings",response.getReturnValue());
            }
        });
		$A.enqueueAction(action);
    },
    runIot : function(component, event, helper,whichone) { 
       var action = component.get("c.IoTSetup");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.ToastNotification('IoT Setup Complete!', 'We have ran the required IoT Setup Steps', 'success');
            }else{
                helper.ToastNotification('IoT Setup Failed', 'Please let us know that this failed.', 'error');
            }
        });
		$A.enqueueAction(action);
    },
    ToastNotification : function(Title,Message,Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        	title : Title,
            message: Message,
            duration:' 5000',
            type: Type,
            mode: 'pester'
        });
        toastEvent.fire(); 
    },
})