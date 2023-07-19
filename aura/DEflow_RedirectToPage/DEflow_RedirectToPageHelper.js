({
    setFullUrl : function(component,rId) {
        var action = component.get("c.validateAndRedirect");
        action.setParams({ 
            idd : rId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('first obj id',component.get('v.recordId'));
                let urll = response.getReturnValue() + component.get('v.objAPI')+'/'+component.get('v.recordId')+'/view';
                console.log('first get url',urll);
                window.location.href = urll;   
            }
            else{
                console.log('failed');
            }
        });
        $A.enqueueAction(action);
    }
})