public class LightningProjectServiceTargetsController {
    
    @AuraEnabled
    public static list<Object> GetTarget(String targetId, String projectServiceId) {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Target__c; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        
        List<ProjectServiceTarget__c> existingServiceTargets = [SELECT Id, Target__c FROM ProjectServiceTarget__c WHERE projectService__c =:projectServiceId];
        List<Id> existingIds = new List<Id>();
        for(ProjectServiceTarget__c pst :existingServiceTargets)
        {
            existingIds.add(pst.Target__c);                    
        }
        
        List<Target__c> targets = [select Name, Id, upc__c, description__c, ImageUrl__c, status__c, StockCode__c, AccountInfo__c From Target__c where Id =:targetId AND Status__c='Active'];
        List<ProjectServiceTargetWrapper> targetVMList = new List<ProjectServiceTargetWrapper>();
        
        
        for(Target__c target : targets)
        {
            
            targetVMList.add(new ProjectServiceTargetWrapper(target));
        }
        
        
        return targetVMList;        
        
    }
    
    
    @AuraEnabled
    public static list<Object> GetTargets(String searchText, String targetType,String projectServiceId) {
        String[] searchFilters = new String[]{'%' + searchText.trim() + '%'};
            
            Schema.DescribeSObjectResult d = Schema.SObjectType.Target__c; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(targetType);
        
        List<ProjectServiceTarget__c> existingServiceTargets = [SELECT Id, Target__c FROM ProjectServiceTarget__c WHERE projectService__c =:projectServiceId];
        List<Id> existingIds = new List<Id>();
        for(ProjectServiceTarget__c pst :existingServiceTargets)
        {
            existingIds.add(pst.Target__c);                    
        }
        
        List<Target__c> targets = [select Name, Id, upc__c, description__c, ImageUrl__c, status__c, StockCode__c, AccountInfo__c From Target__c 
                                   where (name like :searchFilters or UPC__c like :searchFilters or StockCode__c like :searchFilters) AND Status__c='Active'
                                   and RecordTypeId =:rtByName.getRecordTypeId() and Id NOT IN :existingIds order by Name LIMIT 25 ];
        
        List<ProjectServiceTargetWrapper> targetVMList = new List<ProjectServiceTargetWrapper>();
        
        for(Target__c target : targets)
        {
            targetVMList.add(new ProjectServiceTargetWrapper(target));
        }
        return targetVMList;        
        
    }  
    
    @AuraEnabled
    public static list<String> GetTargetTypes() {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Target__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();    
        
        Set<String> TargetRecordTypes = new Set<String>();
        for(Schema.RecordTypeInfo i : rtMapById.values())
        {
            if(!i.isMaster() & i.isAvailable())
            {
                TargetRecordTypes.Add(i.getName());
            }
        }
        //OH-2692 - make product default choice
        if(TargetRecordTypes.contains('Product')){
            TargetRecordTypes.remove('Product');
        }
        List<String> targetTypes = new List<String>();
        targetTypes.add('Product');
        targetTypes.addAll(TargetRecordTypes);
        return targetTypes;
    }
    @AuraEnabled
    public static List<String> GetTargetUseTypes(String projectServiceId) {
        
        List<string> lstUseTypes = new List<string>();
        List<ProjectService__c> existingServiceTargets = [SELECT Id, TargetUse__c FROM ProjectService__c WHERE Id = :projectServiceId];
        if(existingServiceTargets.size() > 0)
        {
            string targetuses  = string.ValueOf(existingServiceTargets[0].TargetUse__c);
            
            integer x = targetuses.indexOf(';');
            if(x != -1)
            {
                lstUseTypes.addAll(targetuses.split(';'));
            }
            else
            {
                lstUseTypes.add(targetuses);
            }
            
        }
        System.debug(lstUseTypes);
        return lstUseTypes;
        
    }
    
    
    
    @AuraEnabled
    public static list<ProjectServiceTargetWrapper> GetTargetsCSV(String searchTextCSV, String projectServiceId) {
        
        searchTextCSV = searchTextCSV.replace('\r\n', ',');
        searchTextCSV = searchTextCSV.replace('\n', ',');
        searchTextCSV = searchTextCSV.replace('\r', ',');  
        Set<string> ids = new  Set<string>();
        ids.addAll(searchTextCSV.split(','));
        
        map<integer,string> targetMap = new map<integer,string>();
        integer i=1;
        for(String temp:searchTextCSV.split(',')){
            targetMap.put(i,temp);
            i++;
        }
        
        
        List<ProjectServiceTarget__c> existingServiceTargets = [SELECT Id, Target__c FROM ProjectServiceTarget__c WHERE projectService__c = :projectServiceId];
        List<Id> existingTargets = new List<Id>();
        for(ProjectServiceTarget__c pst :existingServiceTargets)
        {
            existingTargets.add(pst.Target__c);                    
        }
        
        list<Target__c> targets = [SELECT Name, Id, upc__c, description__c, ImageUrl__c, status__c, 
                                   StockCode__c, AccountInfo__c FROM Target__c WHERE 
                                   (UPC__c in :ids or StockCode__c in :ids)
                                   AND Id not in :existingTargets AND Status__c='Active'];
        
        List<ProjectServiceTargetWrapper> targetVMList = new List<ProjectServiceTargetWrapper>();
        
        for (String temp : targetMap.values()){ 
            for(Target__c target : targets)
            {
                //if(target.upc__c==temp)    
                if(target.name==temp ||target.upc__c==temp || target.StockCode__c==temp )
                {
                    ProjectServiceTargetWrapper foundTarget = new ProjectServiceTargetWrapper(target);
                    foundTarget.Selected = true;
                    targetVMList.add(foundTarget);
                }
            }
        }
        return targetVMList;        
    }
    
    @AuraEnabled
    public static List<ProjectServiceTargetWrapper> GetProjectServiceTargets(String projectServiceId) {
        //public static string GetProjectServiceTargets(String projectServiceId) {
        List<ProjectServiceTarget__c> targets = [SELECT Name, Id, ProjectService__c, target__r.AccountInfo__c, 
                                                 TargetName__c, target__r.ImageURL__c, Quantity__c,Visibility__c,TargetDescription__c, 
                                                 TargetUPC__c, Target__r.StockCode__c, TargetStockCode__c,Type__c, 
                                                 ProjectService__r.Project__r.Status__c, ProjectService__r.TargetType__c,
                                                 ProjectAccount__r.Account__r.Name                 
                                                 FROM ProjectServiceTarget__c
                                                 WHERE projectService__c = :projectServiceId Order by Name];
        system.debug(targets.size());
        
        List<ProjectServiceTargetWrapper> projectServiceTargetsVM = new List<ProjectServiceTargetWrapper>();
        for(ProjectServiceTarget__c serviceTarget : targets)
        {
            projectServiceTargetsVM.add(new ProjectServiceTargetWrapper(serviceTarget));            
        }   
        
        
        return projectServiceTargetsVM;
    }
    
    @AuraEnabled
    public static void AddServiceTargets(List<ProjectServiceTargetWrapper> targetArray, string projectServiceId) {       
        
		string projectid = '';
        List<ProjectService__c>  pss = [SELECT Id, Project__c FROM ProjectService__c WHERE id = :projectServiceId LIMIT 1];
        if (pss.size() > 0)
        {
            projectid = pss[0].Project__c;
        }
        
        
        List<ProjectServiceTarget__c> projectServiceTargetList = new List<ProjectServiceTarget__c>();
        System.debug(targetArray);
        for(ProjectServiceTargetWrapper targetVM : targetArray)
        {
            System.debug(targetVM.Selected);
            if(targetVM.Selected == true) 
            {
                ProjectServiceTarget__c newProjectServiceTarget = new ProjectServiceTarget__c(Project__c = projectid, ProjectService__c = projectServiceId, Target__c = targetVM.TargetId);               
                newProjectServiceTarget.Type__c='Primary';
                projectServiceTargetList.add(newProjectServiceTarget);      
            }
        }      
        
        insert projectServiceTargetList;          
        
    }
    
    
    @AuraEnabled
    public static string AddTargets(List<String> targetArray, string projectServiceId,string targetUserType) {       
        ResponseWrapper rw;
        List<ProjectServiceTarget__c> projectServiceTargetList = new List<ProjectServiceTarget__c>();
        System.debug('target Array: ' + targetArray);
        integer cntStarter;
        cntStarter=0;
        List<AggregateResult> res = [select max(sortorder__c) maxval from ProjectServiceTarget__c where ProjectService__c=:projectServiceId];
        if(res!= null) 
            cntStarter= res[0].get('maxval')!=null ? Integer.valueof(res[0].get('maxval')) : 0;

		string projectid = '';
        List<ProjectService__c>  pss = [SELECT Id, Project__c FROM ProjectService__c WHERE id = :projectServiceId LIMIT 1];
        if (pss.size() > 0)
        {
            projectid = pss[0].Project__c;
        }
        
        
        for(string targetVM : targetArray)
        {            
            cntStarter=cntStarter+1;
            ProjectServiceTarget__c newProjectServiceTarget = new ProjectServiceTarget__c(Project__c = projectid, ProjectService__c = projectServiceId, Target__c = targetVM,sortorder__c = cntStarter,Type__c = targetUserType); 
            system.debug('newProjectServiceTarget++++'+ newProjectServiceTarget);
            projectServiceTargetList.add(newProjectServiceTarget);   
        }      
        try{
            insert projectServiceTargetList;          
            rw = ResponseWrapper.getInstance(CONSTANTS.RESPONSE_STATE_SUCCESS, 'Successfully added target(s) to project', 'SUCCESS');
            System.debug('Successfully added target Array: ' + projectServiceTargetList);
        }
        catch(System.DmlException e) {
            System.debug(e);
            String dmlMessage = e.getDmlMessage(0);
            if(e.getDmlType(0) == StatusCode.DUPLICATE_VALUE){
                dmlMessage = 'Target is already added';
            }
            rw = ResponseWrapper.getInstance(CONSTANTS.RESPONSE_STATE_ERROR, 'Unable to add target - ' + dmlMessage, 'error');
        }
        catch(Exception e){
            System.debug(e);
            rw = ResponseWrapper.getInstance(CONSTANTS.RESPONSE_STATE_ERROR, 'Unable to add target. ' + e.getMessage(), 'ERROR'); 
        }
        
        
        return JSON.serialize(rw);
        
    }
    
    
    @AuraEnabled
    public static string RemoveTargetFromService(string projectServiceTargetId) {
        ResponseWrapper rw;
        ProjectServiceTarget__c projectServiceTarget = [Select name from ProjectServiceTarget__c where id =: projectServiceTargetID ];
        
        try{
            delete projectServiceTarget;
            rw = ResponseWrapper.getInstance(CONSTANTS.RESPONSE_STATE_SUCCESS, 'Successfully deleted target from project', 'SUCCESS');
        }
        catch(DmlException dmlEx){
            throw new AuraHandledException('Unable to delete target. ' + dmlEx.getDmlMessage(0)); 
        }
        catch(Exception e){
            throw new AuraHandledException('Unable to delete target. ' + e.getMessage());
        }
        
        return JSON.serialize(rw); 
    }
    
    @AuraEnabled
    public static string RemoveAllTargetsFromService(string projectServiceId) {
        System.debug('projectServiceId'+ projectServiceId);
        integer numberofTargets = 0;
        ResponseWrapper rw;
        TriggerUtil.skipProjectServiceTargetTrigger = true;
        List<ProjectServiceTarget__c> projectServiceTarget = [Select name from ProjectServiceTarget__c where projectService__c =: projectServiceId ];
        numberofTargets =  projectServiceTarget.size();
        
        try{
            
            delete projectServiceTarget;
            rw = ResponseWrapper.getInstance(CONSTANTS.RESPONSE_STATE_SUCCESS, 'Successfully deleted ' + numberofTargets + ' Target(s) from the service ', 'SUCCESS');
        }
        catch(DmlException dmlEx){
            throw new AuraHandledException('Failed to remove all targets. ' + dmlEx.getDmlMessage(0)); 
        }
        catch(Exception e){
            rw = ResponseWrapper.getInstance(CONSTANTS.RESPONSE_STATE_ERROR, 'Unable to delete Targets from the service ' + e.getMessage(), 'ERROR'); 
        }
        System.debug('rw'+rw);
        
        return JSON.serialize(rw); 
    }
    
    @AuraEnabled
    public static String getNamespaceApex() {
        return CONSTANTS.CURRENTNAMESPACEPREFIX;
    }        
    
}