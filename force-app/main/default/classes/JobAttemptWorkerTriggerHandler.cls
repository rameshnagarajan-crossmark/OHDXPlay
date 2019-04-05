public class JobAttemptWorkerTriggerHandler extends TriggerHandler {
    
    public override void beforeUpdate() {
        
        if (TriggerUtil.skipJobAttemptWorkerTrigger) return;
        TriggerUtil.skipJobAttemptWorkerTrigger = true;
        
        Map<String, JobAttemptWorker__c> leadJobAttemptWorkerMap = new Map<String, JobAttemptWorker__c>();
        Map<String, JobAttemptWorker__c> unassignedleadJobAttemptWorkerMap = new Map<String, JobAttemptWorker__c>();
        
        set<String> contactIds = new set<String>();
        
        for (JobAttemptWorker__c jaw: (List < JobAttemptWorker__c>) Trigger.new) {
            contactIds.add(jaw.ContactId__c);            
        }
        
        if (contactIds.size() == 0) {return;}
        
        //Gets contact object for contact id's
        Map<String,CONTACT> contactsMap = getContacts(contactIds);
        
        for (JobAttemptWorker__c jw: (List < JobAttemptWorker__c>) Trigger.new) {
            JobAttemptWorker__c oldjw = (JobAttemptWorker__c) System.Trigger.oldMap.get(jw.Id);
            
            //Assignment Logic
            if(oldjw.ContactId__c !=jw.ContactId__c && jw.ContactId__c != null)
            {
				AssignWorker(oldjw, jw, contactsMap, leadJobAttemptWorkerMap);                
            }
            
            //Unassignment Logic
            if(oldjw.Status__c == CONSTANTS.JOB_ATTEMPT_WORKER_STATUS_ASSIGNED  && 
               jw.Status__c == CONSTANTS.JOB_ATTEMPT_WORKER_STATUS_OPEN)
            {
				UnassignWorker(oldjw, jw, contactsMap, unassignedleadJobAttemptWorkerMap);                
            }
            
            
            //Update Supervisor Email everytime we capture an update for a JAW
            //This is to make sure we get supervisor changes if any.
            //Update Supervisor information 
			if (contactsMap.get(jw.ContactId__c) != null)
            {
				UpdateSupervisorInfo(jw, contactsMap);                
            }
            
            CalculateTimeAdjusted(oldjw, jw);
            
            
            
        }  
        
        // To update job attempt with assigned supervisor - OH-4607
        updateLeadContactInJobAttempt(leadJobAttemptWorkerMap);
        
        //Update Job Attempt when a Team Lead is unassigned
		unassignLeadContactInJobAttempt(unassignedleadJobAttemptWorkerMap);        
        
    }   
    
    //OH-4607 
    //Update the Job Attempt Status to assigned
    //and Assigned contact to Assigned COntact Id
    static void updateLeadContactInJobAttempt(Map<String, JobAttemptWorker__c> leadJobAttemptWorkerMap) {
        
        List<JobAttempt__c> jobAttempts =  [SELECT Id, AssignedContact__c, AssignedContactId__c FROM JobAttempt__c WHERE 
                                            ID IN :leadJobAttemptWorkerMap.keyset()];
        
        for(JobAttempt__c jobAttempt : jobAttempts){
            JobAttemptWorker__c jobAttemptWorker  = leadJobAttemptWorkerMap.get(jobAttempt.Id);            
            jobAttempt.AssignedContactId__c = jobAttemptWorker.ContactId__c;  
            jobAttempt.AssignedContact__c = jobAttemptWorker.Contact__c;  
            jobAttempt.AttemptStatus__c = CONSTANTS.JOB_ATTEMPT_STATUS_ASSIGNED;
        }                
        
        update jobAttempts;
    }
    
    static void unassignLeadContactInJobAttempt(Map<String, JobAttemptWorker__c> unassignedleadJobAttemptWorkerMap) {
        
        List<JobAttempt__c> jobAttempts =  [SELECT Id, AssignedContact__c, AssignedContactId__c FROM JobAttempt__c WHERE 
                                            ID IN :unassignedleadJobAttemptWorkerMap.keyset()];
        
        for(JobAttempt__c jobAttempt : jobAttempts){
            JobAttemptWorker__c jobAttemptWorker  = unassignedleadJobAttemptWorkerMap.get(jobAttempt.Id);            
            jobAttempt.AssignedContactId__c = null;  
            jobAttempt.AssignedContact__c = null;  
            jobAttempt.AttemptStatus__c = CONSTANTS.JOB_ATTEMPT_STATUS_OPEN;
        }                
        update jobAttempts;
    }    
    
    static Map<String,CONTACT> getContacts(Set<String> contactIdSet) {
        Map<String,CONTACT> result = new Map<String,CONTACT>();
        if (contactIdSet.size() == 0) {
            return result;
        }
        for(Contact person: [SELECT Id, ContactId__c, Email, FirstName, LastName, ReportsTo.Email, 
                             ReportsTo.FirstName, ReportsTo.LastName, ReportsTo.Phone
                             FROM CONTACT WHERE ContactId__c != '' AND ContactId__c IN :contactIdSet]) {
            result.put(person.ContactId__c, person);
        }
        return result;
    }
    
    
    private void AssignWorker(JobAttemptWorker__c oldjw, JobAttemptWorker__c jw, Map<String,CONTACT> contactsMap, Map<String, JobAttemptWorker__c> leadJobAttemptWorkerMap)
    {
        
        if (contactsMap.containsKey(jw.ContactId__c)) {
            jw.Contact__c  = contactsMap.get(jw.ContactId__c).Id ;
            jw.DateAssigned__c = DateTime.Now();
            
            //collect all lead contact info to update Job Attempt sObject - OH-4607
            if (jw.WorkerType__c == CONSTANTS.JOB_ATTEMPT_WORKER_WORKER_TYPE_TEAM_LEAD){
                leadJobAttemptWorkerMap.put(jw.JobAttempt__c, jw);
            }                    
        }
        else
        {
            jw.addError('ContactId: ' + jw.ContactId__c + ' not found in the system.');
        }
        
    }
    
    private void UnassignWorker(JobAttemptWorker__c oldjw, JobAttemptWorker__c jw, Map<String,CONTACT> contactsMap, Map<String, JobAttemptWorker__c> unassignedLeads)
    {

        jw.Contact__c  = null;
        jw.ContactId__c  = null;
        //collect all lead contact info to update Job Attempt sObject - OH-4607
        if (jw.WorkerType__c == CONSTANTS.JOB_ATTEMPT_WORKER_WORKER_TYPE_TEAM_LEAD){
            unassignedLeads.put(jw.JobAttempt__c, jw);
        }                    
        
    }    

    private void UpdateSupervisorInfo(JobAttemptWorker__c jw, Map<String,CONTACT> contactsMap)
    {
        
        if (contactsMap.get(jw.ContactId__c).ReportsTo.Email != null)
        {
            jw.SupervisorEmail__c = contactsMap.get(jw.ContactId__c).ReportsTo.Email;
            jw.SupervisorFirstName__c = contactsMap.get(jw.ContactId__c).ReportsTo.FirstName;
            jw.SupervisorLastName__c = contactsMap.get(jw.ContactId__c).ReportsTo.LastName;
            jw.SupervisorPhone__c = contactsMap.get(jw.ContactId__c).ReportsTo.Phone;
        }
        jw.ContactEmail__c = contactsMap.get(jw.ContactId__c).Email;            
       
    }
    
    private void CalculateTimeAdjusted(JobAttemptWorker__c oldjw, JobAttemptWorker__c jw)
    {
        
        if (oldjw.ECWorkerTime__c != jw.ECWorkerTime__c || oldjw.TotalInStoreTime__c != jw.TotalInStoreTime__c || 
            oldjw.TotalInStoreNonBillableTime__c != jw.TotalInStoreNonBillableTime__c)
        {
            //Update the time adjusted
            if (jw.TotalInStoreTime__c != null && jw.ECWorkerTime__c != null && 
                jw.ECWorkerTime__c > 0)
            {
                jw.TimeAdjusted__c = jw.ECWorkerTime__c - (jw.TotalInStoreTime__c - jw.TotalInStoreNonBillableTime__c);    
            }
            
        }
        
        
    }
    
}