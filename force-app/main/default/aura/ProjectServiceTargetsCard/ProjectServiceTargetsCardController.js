({	
    doInit : function(component, event, helper) {
        // component.set("v.securityelements", "ProjectTarget__c.Delete");
        helper.initSecurity(component,event,helper);
    },
    
    onMessageBoxEvent: function(component, evt, helper) {
        helper.handleMessageBoxEvent(component, evt);
    },
    
    onClickProjectServiceTarget: function(component, evt, helper) {
        helper.goToProjectServiceTarget(component, evt);
    },
    
    
    removeTargetClick : function(component, event, helper) {        
        helper.openMessageBox(component, event);
        var projectServiceTarget = component.get("v.projectServiceTarget"); 
        
        
    },
    
    
})