({
    changed: function(cmp, evt){
        var val = cmp.find('selState').get('v.value');
        cmp.set('v.value', val);
        this._onChanged(cmp, val);
    },

    _onChanged: function(cmp, value){
        var msg = cmp.getEvent('onStateChanged');
        msg.setParams({
            context: value
        });
        msg.fire();
    }
})