({
    doInit : function(component,evt,helper) {                        
        var vfOrigin = "https://" + window.location.hostname;
        var action = component.get("c.getNamespaceApex");
        var self = this;
        
        var abc = component.find("vfFrame");
        action.setCallback(self, function(result) {
            var url = vfOrigin + '/apex/' + result.getReturnValue() + 'SubmitLightningProject?Id=' + component.get("v.recordId");
            component.set("v.vfURL",url);
            
            window.addEventListener("message", function(event) {                          
                // Handle the message				             
                var btn = component.find('Submit');
                
                
                var pageRequest = event.data.split(',');
                if(pageRequest[0]===component.get("v.recordId") && pageRequest[1]==='true')
                {
                    $A.util.removeClass(btn,'slds-hidden');				
                    $A.util.addClass(btn,'slds-visible');                
                }                   
            }, false);
        });
        $A.enqueueAction(action); 
    },
    
    submitProject: function(component,event,helper)
    {        
        var vfOrigin = "https://" + window.location.hostname;
        var action = component.get("c.getNamespaceApex");
        var btn = component.find('Submit');
        
        
        var self = this;
        action.setCallback(self, function(result) {
            var url = vfOrigin + '/apex/' + result.getReturnValue() + 'SubmitLightningProject?Id=' + component.get("v.recordId") + '&stage=submit';
        	component.set("v.vfURL",url);
            
            $A.util.removeClass(btn,'slds-visible');				
            $A.util.addClass(btn,'slds-hidden');
            
            component.set("v.reloadPage",true);
           	helper.notifyProjectUpdate(component,event,helper);
            
        });
        $A.enqueueAction(action);    
    },
    hideModalWindow:function(component,event,helper){
        if(component.get("v.reloadPage")===true){
        	window.location.reload();
        }
    }
})