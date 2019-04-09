({	
 	notifyProjectUpdate: function(component,event,helper){
    	var action = component.get("c.GetProject");
        var projectId = component.get("v.recordId");
                
        action.setParams({
            "recordId": projectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var updatedProject = response.getReturnValue();
                //component.set("v.project",updatedProject);
                var appEvent = $A.get("e.c:EventProjectRefresh");
                appEvent.setParams({"project":updatedProject});
				appEvent.fire();
                
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);        
	},
    CloseActionModal : function(component, event, helper) {
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();        
    }
})