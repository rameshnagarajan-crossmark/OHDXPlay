public with sharing class ProjectAccountModel {
    static final string OBJECT_TYPE = 'ProjectAccount__c';
    static final string FIELD_SET_NAME = 'default';

    String ProjectId {get;set;}

    FieldsetGetter  FieldsetGetterInstance {get;set;}

    private ProjectAccountModel(String id){
        FieldsetGetterInstance = FieldsetGetter.create(OBJECT_TYPE);
        this.ProjectId = id;
    }

    public static ProjectAccountModel create(string projectId){
        return new ProjectAccountModel(projectId);   
    }

    public List<Map<String,Object>> getList() {
        List<Map<String,Object>> rs = new List<Map<String,Object>>();
        Map<String,object> r;

        for(ProjectAccount__c acct: getAccounts()){
            r = new Map<String,Object>();
            r.put('id', acct.Id);
            r.put('accountId', acct.Account__c);
            r.put('isPrimary', acct.IsPrimary__c);
            r.put('projectStatus', acct.Project__r.Status__c);
            r.put('canSetPrimary', !UIConfig.checkFieldHidden(acct.Project__r.Status__c, 'ProjectAccount__c.Primary'));
            r.put('canDelete', !UIConfig.checkFieldHidden(acct.Project__r.Status__c, 'ProjectAccount__c.Delete'));
           r.put('title', FieldsetGetterInstance.getTitle(acct));
            r.put('fieldset', FieldsetGetterInstance.getNameValueList(acct));
            rs.add(r);
        }

        return rs;
    }

    List<ProjectAccount__c> getAccounts(){
        String id = this.ProjectId;
        String sql = FieldSetQueryBuilder.create(OBJECT_TYPE)
            .addAdditionalFields(new String[]{'Account__c','IsPrimary__c','Project__r.Status__c'})
            .addPredicates(new String[]{ 'Project__c=:id Order By IsPrimary__c DESC' })
            .build(FieldsetGetterInstance.getFieldsetDefinition(FIELD_SET_NAME));
        return Database.query(sql);
    }
}