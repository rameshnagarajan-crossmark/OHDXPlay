global class BatchGetProjectHistoryChanges implements Database.Batchable<sObject>, Database.Stateful {
    
    DateTime LastSyncDateTime;
    DateTime MaxDateTime;

    global BatchGetProjectHistoryChanges(DateTime lastSyncDateTime) {
        
        this.LastSyncDateTime = lastSyncDateTime;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('Get Project Change History Batch Started');
        //Get only changes that happened 15 seconds ago so we don't overlap or miss then the ones that are still running and inserting changes.
        //We need to process all the changes that happened at the same time as a group.
        
        DateTime upperDateTime = DateTime.Now().addSeconds(-15);                        
        system.debug('BatchGetProjectHistoryChanges LastSyncDateTime::' + LastSyncDateTime);
        system.debug('BatchGetProjectHistoryChanges LastSyncDateTime::' + upperDateTime);                
                
		return Database.getQueryLocator([SELECT Id, ParentId, CreatedDate, Field, OldValue, NewValue FROM 
                                         Project__History WHERE CreatedDate > :LastSyncDateTime and CreatedDate <= :upperDateTime ORDER BY CreatedDate]);
        
    }
   
    global void execute(Database.BatchableContext BC, List<Project__History> scope) {    
        
        system.debug('BatchGetProjectHistoryChanges-execute::' + scope.size());
        
        if (!scope.isEmpty())
        {
            MaxDateTime = scope[scope.size()-1].CreatedDate;
            ProjectActionsHelper.ProcessProjectHistoryChanges(scope);

        }
   }
    
    global void finish(Database.BatchableContext BC) {
    

            
        TriggerUtil.SkipAllTriggers();
        List<ProcessLastSyncTime__c> plsts = [Select Id, CurrentProcessId__c, SyncTime__c from ProcessLastSyncTime__c WHERE ProcessName__c = 'ProjectChangeTracking' LIMIT 1];
    
    
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];    

        if (a.NumberOfErrors == 0 && MaxDateTime != null)
        {
            plsts[0].SyncTime__c = MaxDateTime;
        }
       
        plsts[0].CurrentProcessId__c = '';            
        update plsts [0];
        
        system.debug('Get Project Change History Batch Finished');
        
   }    
    
}