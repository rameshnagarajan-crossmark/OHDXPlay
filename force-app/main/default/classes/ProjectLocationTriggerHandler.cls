public class ProjectLocationTriggerHandler extends TriggerHandler {
    static final Blob cryptoIv;
    static final Blob cryptoKey;
    static {
        SurveyPhotoViewerSetting__c setting  = SurveyPhotoViewerSetting__c.getOrgDefaults();
        cryptoIv = Blob.ValueOf(String.valueOf(setting.Iv__c == null? '': setting.Iv__c));
        cryptoKey = Blob.ValueOf(String.valueOf(setting.Key__c == null? '': setting.Key__c));
    }
    
    public override void afterUpdate() 
    {
        
        Map<String,Date> schedDateLocationMap = new Map<String,Date>();
        
        for(ProjectLocation__c current : (List<ProjectLocation__c >) trigger.new)
        {
            ProjectLocation__c old = getOld(current.Id);
            if (current.LocationScheduledDate__c != old.LocationScheduledDate__c)    
            {
                
                schedDateLocationMap.put(current.Id, current.LocationScheduledDate__c);    
            }
            
        }
        
        if (schedDateLocationMap.size() > 0)        
        {
            ProcessScheduledDateChanges(schedDateLocationMap);
        }
        
    }
    
    public override void beforeUpdate() {
        set<Id> projLocationIds = new set<Id>();
        for(ProjectLocation__c current : (List<ProjectLocation__c >) trigger.new)
        {
            ProjectLocation__c old = getOld(current.Id);
            if (current.BillingStatus__c != old.BillingStatus__c && 
                old.BillingStatus__c == CONSTANTS.BILLING_STATUS_NEEDSREVIEW)    
            {
            	current.BillingReviewed__c = true;	    
            }            
            
            if (String.isBlank(current.SurveyPhotoViewerEncodedId__c))
            	current.SurveyPhotoViewerEncodedId__c = processEncryption(current.Id);
            
        }
    }
    
    @TestVisible 
    private static string processEncryption(Id recId){
        Blob cipherText = Crypto.encrypt('AES128',cryptoIv, cryptoKey, Blob.valueOf(recId));
        
        string encodedrecId = EncodingUtil.base64Encode(cipherText); 
        return encodedrecId;
    }
    
    
    private static ProjectLocation__c getOld(Id plId) {
        return (ProjectLocation__c) Trigger.oldMap.get(plId);
    }    
    @TestVisible
    private static void ProcessScheduledDateChanges(Map<String, Date> schedDateLocationMap) 
    {
        
        Map<String, Date> jobsSchedMap = new Map<String, Date>();       
        List<Job__c> jobs = [Select Id, name, projectlocation__c from job__c WHERE projectlocation__c in :schedDateLocationMap.keySet()];
        for (Job__c job: jobs)
        {
            if (schedDateLocationMap.get(job.ProjectLocation__c) != null)
            {
                jobsSchedMap.put(job.Id,schedDateLocationMap.get(job.projectlocation__c));    
            }
        }
        
        if (!jobsSchedMap.isEmpty())
        {
            List<ActionResponse> jars = JobActionsHelper.setScheduledDate(jobsSchedMap);
        }
        
        
    }    
    
    
}