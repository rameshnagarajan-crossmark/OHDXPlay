({
    doInit : function(component, event, helper) {
        helper.Init(component, event, helper);
        //helper.getServiceQuestionRule(component, event, helper);        
    },
    
    
    saveChanges : function(component, event, helper) {
        console.log('Iam inside save changes++++++++++++');
        
        if ((component.find("minVal")!= undefined) && (component.find("MaxVal")!= undefined))
        {
            var minValue = component.find("minVal").get("v.value");
            var maxValue = component.find("MaxVal").get("v.value");
            if (isNaN(minValue))
            {
                var message = ' Please enter Numeric Value in min Value field';
                
                helper.showError(component,message)
                return;
            }
            if (isNaN(maxValue))
            {
                var message = ' Please enter Numeric Value in Max Value field';
                
                helper.showError(component,message)
                return;
            }
            
            if(parseInt(minValue) > parseInt(maxValue))
            {
                var message = ' Please enter  minimum  Value less then maximum value';
                helper.showError(component,message)
                return;
            }
            if(parseInt(maxValue) < parseInt(minValue))
            {
                var message = ' Please enter  maximum  Value greater then minimum value';
                helper.showError(component,message)
                return;
            }
        }                
        
        var editQuestionEvent = component.getEvent('editSurveyQuestion1');
        
        editQuestionEvent.setParams({ "question": component.get("v.question") });
        
        editQuestionEvent.fire();
        
    },
    saveRule: function(component, evt, helper)
    {
        var serviceQuestionEvent = component.getEvent('SQRule');
        serviceQuestionEvent.setParams({ "squestionRule": component.get("v.ServicequestionRule"),
                                        "serviceQuestion":component.get("v.recordid")
                                       });
        
        
        serviceQuestionEvent.fire();
    },
    
    closeDialog: function(cmp, evt, helper) {
        
        var dlgEvt = cmp.getEvent('closeDialogEvent');
        dlgEvt.fire();
    }    
})