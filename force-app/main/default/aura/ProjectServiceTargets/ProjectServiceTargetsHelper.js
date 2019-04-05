({
    refreshTargetList: function(component, event, projectServiceId) {
        var self = this;
        self.showSpinner(component);
        function callback(cmp, response){
         self.hideSpinner(cmp);
         component.set("v.targets",response);
         let plus5 = response.map((r, i, arr) => {
  			return r.TargetUse;
		});
        var uniqueArray = Array.from(new Set(plus5));
        component.set("v.mapTargets",uniqueArray);
            console.log('response target: ', response);
        console.log('lstvalues++++++++++'+ uniqueArray);
        }
          var payload = {
            'action': 'GetProjectServiceTargets',
            'query': {
                "projectServiceId": projectServiceId
            },
            'callback': callback
        };
        self.dispatch(component, payload);
       
       
        //targets.forEach(function(obj) { obj.TargetUse == 'primary'; });
    },

    targetsChanges: function(component, event, projectServiceId) {
        var state = event.getParam('state'), msg = event.getParam('message');
        this.refreshTargetList(component, event, projectServiceId);
        this._msgBox(state === 'SUCCESS' ? 'success' : 'error',msg);
    },

    showSpinner: function(component) {
        var spinner = component.find("projectTargetSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function(component) {
        var spinner = component.find("projectTargetSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    removeAllTargets: function(cmp, evt) {

        var projectServiceId = cmp.get("v.recordId");
        var self = this;
        var payload = {
            'action': 'RemoveAllTargetsFromService',
            'query': {
                 'projectServiceId': projectServiceId
            },
            'callback': function(cmp, response){
                cmp.set("v.targets",[]);
                self._msgBox('success','The targets are removed successfully.');
            }
        };
        self.dispatch(cmp, payload);
    },

    handleMessageBoxEvent: function(cmp, evt) {

        var targetResult = {
            id: evt.getParam('id'),
            value: evt.getParam('context')
        };

        if (evt.getParam('context') !== 1) {
            return;
        }
        if (targetResult.id === 'removeAllTargets' && targetResult.value == 1) {
            this.removeAllTargets(cmp, evt);
        }



    },

    handleRemoveAll: function(cmp, evt) {
        var targets = cmp.get('v.targets') || [];
        if (targets.length === 0) {
            this.showToast('There are no targets to remove.', 'warning');
            return;
        }
        var prompt = cmp.find('messageBox');
        prompt && prompt.show({
            id: 'removeAllTargets',
            title: 'Remove All Targets',
            body: '<p>Are you sure that you want to remove all the targets from the service?</p>',
            positiveLabel: 'Confirm',
            negativeLabel: 'No',
            severity: 'error'
        });
    },

    dispatch: function(cmp, payload) {
        var request, errors, state, self = this;

        function handleResponse(response) {
            state = response.getState();
            if (!cmp.isValid()) {
                self._msgBox('error', 'The component is out of scope.');
                return;
            }
            switch (state) {
                case 'SUCCESS':
                    if (!!payload.callback) {
                        payload.callback(cmp, response.getReturnValue());
                        return;
                    }
                    break;
                case 'ERROR':
                    errors = response.getError();
                    if (!!errors && !!errors[0] && !!errors[0].message) {
                        self._msgBox('error', errors[0].message);
                    } else {
                        self._msgBox('error', 'The system run into an unknown error.');
                    }
                    break;
                case 'INCOMPLETE':
                    self._msgBox('error', 'The system run into an incomplete state.');
                    break;
                default:
                    self._msgBox('error', 'The system run into an unknown state.');
                    break;
            }
            self.hideSpinner(cmp);
        }

        try {
            request = cmp.get('c.' + payload.action);
            request.setParams(payload.query);
            request.setCallback(this, handleResponse);
            $A.enqueueAction(request);
        } catch (ex) {
            console.log(ex);
            self._msgBox('error', ex.getMessage());
        }
    },

    _msgBox: function(type, msg) {
        var notice = $A.get('e.force:showToast');

        notice.setParams({
            'mode': type === 'error' ? 'sticky' : 'dismissible',
            'type': type,
            'message': msg
        });
        notice.fire();
    },
    toggleContainer : function(component,event,aurId,iconId) {
	  /*var acc = component.find('primary');
        var elem = document.getElementById('primary');
        console.log(elem)
       //var icon = component.find(iconId);
       // $A.util.toggleClass(icon, 'rotate'); 
      for(var cmp in elem) {
        $A.util.toggleClass(elem[cmp], 'expandedSize');  
        $A.util.toggleClass(elem[cmp], 'hiddenSize');*/
        
        //var elem = document.getElementById('primary');
          var acc = component.find("primary");
       // console.log('hello'+ elem);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    
})