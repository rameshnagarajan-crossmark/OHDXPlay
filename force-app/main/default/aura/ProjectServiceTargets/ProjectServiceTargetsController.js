({
    openAddTargetModal: function(component, event, helper) {

        var projectServiceId = component.get("v.recordId");
        console.log(projectServiceId);
        var userevent = $A.get("e.c:EventDisplayModal");
        userevent.setParams({
            "modalComponentName": "c:TargetSearch",
            "modalComponentProperties": {
                "projectServiceId": projectServiceId
            },
            "modalProperties": {
                "title": "Add Targets",
                "height": "400px",
                "width": "600px",
                "offsetFromHeader": "false"
            }

        });
        userevent.fire();
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
        
        var message = cmp.get('v.activeSectionsMessage');
        console.log('message active: ', message);
    },

    onMessageBoxEvent: function(cmp, evt, helper) {
        helper.handleMessageBoxEvent(cmp, evt);
    },

    onTargetsChanged: function(component, event, helper){
        component.set("v.securityelements", "ProjectTarget__c.Add");
        var projectServiceId = component.get("v.recordId");
        helper.targetsChanges(component, event, projectServiceId);
    },

    doInit: function(component, event, helper) {
        component.set("v.securityelements", "ProjectTarget__c.Add");
        var projectServiceId = component.get("v.recordId");
        helper.refreshTargetList(component, event, projectServiceId);

    },

    onClickRemoveAll: function(cmp, evt, helper) {
        var projectServiceId = cmp.get("v.recordId");
        helper.handleRemoveAll(cmp, evt);

    },
    
     primarySection : function(component, event, helper) {
         //console.log(event.target);
         //console.log(event.currentTarget.parentNode);   
         
          var index = event.target.id;  
         console.log("index::"+index);
         //console.log("current value: " + evt.getParam("value"))
       helper.toggleContainer(component,event,'primary','iconPrimary' );
    },
    
   secondarySection : function(component, event, helper) {
      helper.toggleContainer(component,event,'Secondary', 'iconSecondary');
    },
   
   haloSection : function(component, event, helper) {
      helper.toggleContainer(component,event,'Halo', 'iconHalo');
   },
   
   ingredientSection : function(component, event, helper) {
      helper.toggleContainer(component,event,'Ingredient', 'iconIngredient');
   },

})