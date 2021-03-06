({
    SPINNER_ID: 'addSurveyQuestion_busyIndicator',

    getQuestions: function(component) {

        this.showSpinner(component);
        var questiontext = component.get("v.questiontext");
        var questiontype = component.get("v.questiontype");
        var targetquestion = component.get("v.targetquestion");
        var recordid = component.get("v.recordId");
        
        var action = component.get("c.getAvailableSurveyQuestions", []);
        action.setParams({
            "questiontext": questiontext,
            "questiontype": questiontype,
            "targetquestion": targetquestion,
            "recordid": recordid
        });
        var self = this;
        action.setCallback(self, function(result) {
            var questions = JSON.parse(result.getReturnValue());
            
            component.set("v.questions", self._sortOutAddableQuestions(component, questions));
            this.hideSpinner(component);

        });
        $A.enqueueAction(action);
    },

    _sortOutAddableQuestions: function(cmp, questions) {
        var added = cmp.get('v.addedQuestions') || [];
        var fromProjectBuilder = cmp.get('v.fromProjectBuilder');

        (questions || []).forEach(function(e) {
            if (!!fromProjectBuilder) {
                if (!!e.IsExceptionQuestion) {
                    e['_message'] = 'This is an exception question and can not be added into the survey.';
                    e['_canAdd'] = false;
                    e['_class'] = 'fa fa-money';
                    return;
                }
                e['_isAdded'] = added.some(function(id) {
                    return e.QuestionId === id;
                });

                if (!!e['_isAdded']) {
                    e['_message'] = 'This question is already added.';
                    e['_canAdd'] = false;
                    e['_class'] = 'fa fa-ban';
                    return;
                }
            }

            e['_canAdd'] = true;
            switch (e.QuestionType) {
                case 'Yes/No':
                    e['_class'] = 'fa fa-balance-scale';
                    break;
                case 'Number':
                    e['_class'] = 'fa fa-calculator';
                    break;
                case 'Text':
                    e['_class'] = 'fa fa-edit';
                    break;
                case 'Single-Select List':
                    e['_class'] = 'fa fa-check-square-o';
                    break;
                case 'Multi-Select List':
                    e['_class'] = 'fa fa-list-ul';
                    break;
                case 'Photo':
                    e['_class'] = 'fa fa-camera-retro fa-lg';
                    break;
                case 'Time':
                    e['_class'] = 'fa fa-clock-o fa-lg';
                    break;
                case 'Currency':
                    e['_class'] = 'fa fa-dollar';
                    break;
                case 'Date':
                    e['_class'] = 'fa fa-calendar';
                    break;
                case 'Barcode':
                    e['_class'] = 'fa fa-barcode';
                    break;
                default:
                    e['_class'] = 'fa fa-leaf';
                    break;
            }
        });
        
        return questions;
    },

    showSpinner: function(component) {
        component.find(this.SPINNER_ID).show();
    },
    hideSpinner: function(component) {
        component.find(this.SPINNER_ID).hide();
    }
})