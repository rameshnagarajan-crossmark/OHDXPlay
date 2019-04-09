public class JobImageTriggerHandler extends TriggerHandler {


    boolean skipTrigger(){
        return TriggerUtil.skipJobImageTrigger;
    }

    public override void beforeInsert(){
        JobAttempt__c jobAttempt;
        if(this.skipTrigger()){return;}

        set<Id> jobAttemptIds = new set<Id>();
        for (JobImage__c ji :(List<JobImage__c> ) Trigger.new) {
             if(!(string.isEmpty(ji.JobAttempt__c)))
             {
                jobAttemptIds.add(ji.JobAttempt__c);
             }

        }

        Map<Id,JobAttempt__c> jobattemptMap = new Map<Id,JobAttempt__c>([Select Id,name, DateReported__c, DateOriginallyReported__c, Job__r.Location__r.Parent__c, Job__c,Job__r.ProjectLocation__c, job__r.Project__c, Job__r.ProjectService__c from JobAttempt__c where Id IN : jobAttemptIds]);

        for(JobImage__c ji :(List<JobImage__c> ) Trigger.new)
        {
            if(jobattemptMap.containsKey(ji.JobAttempt__c)){
                jobAttempt = jobattemptMap.get(ji.JobAttempt__c);
                ji.Job__c = jobAttempt.Job__c;
                ji.ProjectLocation__c = jobAttempt.Job__r.ProjectLocation__c;
                ji.Project__c = jobAttempt.Job__r.Project__c;
                ji.JobDateReported__c = jobAttempt.DateReported__c != null 
                    ? jobAttempt.DateReported__c
                    : jobAttempt.DateOriginallyReported__c;
                ji.ProjectService__c = jobAttempt.Job__r.ProjectService__c;
                ji.ParentLocation__c  = jobAttempt.Job__r.Location__r.Parent__c;
            }
        }
    }

}