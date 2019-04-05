({
	helperMethod : function() {
		
	},
    Init:function(component, event, helper){
        var questions = component.get("v.questions");
         var hiddenElement = component.get("v.hiddenElement"); 
         if(!!hiddenElement && hiddenElement["ProjectServiceQuestions__c.NoReadonly"])
            {
               
                component.set("v.securityDisabled", true);         
            }
            else
            {
                   component.set("v.securityDisabled", false);  
            }
		var psqid = component.get("v.recordid");     
        for (var i = 0; i < questions.length; i++) { 
            var question = questions[i];
            if (question.ProjectServiceQuestionId === psqid)
            {
                component.set("v.question",this.clone(question));
            }
        } 
    },
    clone: function(q){
        var obj = {};
        Object.keys(q).forEach(function(k){
            obj[k] = q[k];
        });
        return obj;
    },
    
    isempty:function(component,inputValue,message)
    {
        var isemptycheck;
        if(inputValue === "" ||inputValue === null)
            {
  
                 this.showError(component,message)
                 return isemptycheck = true;
                
            }
            else
            {
                return isemptycheck = false;
            }
    },
    showError:function(component,message){
       var self = this;
          self.showToast(message,'error');
        
    },
    
    showToast : function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type
        });
    	toastEvent.fire();
  },  
})