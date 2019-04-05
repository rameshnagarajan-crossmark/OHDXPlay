public class ProjectAccountTriggerHandler extends TriggerHandler{
    
    public override void afterInsert(){
        if (TriggerUtil.skipProjectAccountTrigger) return;
        Map<Id,Id> mapPA = new Map<Id,Id>();
        for (ProjectAccount__c pa :(List<ProjectAccount__c> ) Trigger.new) {
            if(pa.IsPrimary__c)
            {
                mapPA.put(pa.project__c,pa.Id);
                
            }
            
        }
        
        List<Project__c> lstProj = [select Id,name,PrimaryAccount__c from Project__c where Id IN :mapPA.keySet()];
        List<project__c>lstprojupdates =new List<project__c>();
        for(project__c p:lstProj)
        {
            Id pa = mapPA.get(p.Id);
            p.PrimaryAccount__c = pa;
            lstprojupdates.add(p);
        }
        if(lstprojupdates.size()>0) 
        {
            update lstprojupdates;
        }
        
        
    }
    
    public override void afterUpdate()
    {
       if (TriggerUtil.skipProjectAccountTrigger) return;
        Map<Id,Id> mapPA = new Map<Id,Id>();
         for (ProjectAccount__c pa :(List<ProjectAccount__c> )Trigger.new) {
            
            if(pa.IsPrimary__c)
            {
                mapPA.put(pa.project__c,pa.Id);
                
            }
            
        }
        
        List<Project__c> lstProj = [select Id, PrimaryAccount__c from Project__c where Id IN :mapPA.keySet()];
        List<project__c>lstprojupdates =new List<project__c>();
        for(project__c p:lstProj)
        {
            Id pa = mapPA.get(p.Id);
            if (p.PrimaryAccount__c != pa){
            	p.PrimaryAccount__c = pa;
            	lstprojupdates.add(p);    
            }
            
        }
        if(lstprojupdates.size()>0) 
        {
            update lstprojupdates;
        }
        
        
    }
   
    
}