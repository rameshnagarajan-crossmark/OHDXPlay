global class BatchManageImportAttachments implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    Id projectId;
    String attachmentType;
    String[] IMPORT_ATTACHMENT_PATTERN;

    List<ActionResponse> errorresponses = new List<ActionResponse>();
    
    global BatchManageImportAttachments(Id projectId, String attachmentType){
        this.projectId = projectId;
        this.attachmentType =  attachmentType;
        if (attachmentType.toLowerCase() == 'jobs')
        {
            IMPORT_ATTACHMENT_PATTERN = new String[]{'%' + 'import_jobs' + '%'};
        }
        else if (attachmentType.toLowerCase() == 'locations')
        {
            IMPORT_ATTACHMENT_PATTERN = new String[]{'%' + 'import_locations' + '%'};
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
		return Database.getQueryLocator([SELECT Id, ParentId, Name, IsPrivate, ContentType, BodyLength, 
                                         Body, Description, IsDeleted
                                         FROM Attachment where ParentId =:projectId AND
                                         Name like :IMPORT_ATTACHMENT_PATTERN]);
    }
    
    global void execute(Database.BatchableContext BC, List<Attachment> scope) {
        List<String> data = new List<String>();
        
        Attachment attachment = ((List<Attachment>)scope)[0];
		
        if(attachment != null && attachment.BodyLength > 0){  
            data = (List<String>) JSON.deserialize(attachment.Body.toString(),List<String>.class);
            
            system.debug('data: ' + data);
            system.debug('attachmentType: ' + attachmentType);
            
            List<ActionResponse> batcherrorresponses;
            if (attachmentType.toLowerCase() == 'jobs')
            {
            	batcherrorresponses = JobActionsHelper.updateBulkJobsFromFile(data, String.valueOf(projectId));
            }
            else if (attachmentType.toLowerCase() == 'locations')
            {
            	batcherrorresponses = ProjectLocationActionsHelper.updateBulkLocationsFromFile(data, String.valueOf(projectId));
            }
            
            if (batcherrorresponses != null && !batcherrorresponses.isEmpty())
            	this.errorresponses.addAll(batcherrorresponses);
            
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        
        Savepoint sp = Database.setSavepoint();
        
        try
        {           
            String messageBody = '';
           
            Project__c project = [Select Id, Name, ProjectNumber__c, ApexJobName__c, BatchProcessId__c, RecordTypeId, 
                                  PendingBulkImport__c
                                  from Project__c WHERE Id =: this.projectId];
            string link = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + project.Id;
            
            TriggerUtil.SkipAllTriggers();    
            ProjectActionsHelper.UnlockProject(project);
            
            project.PendingBulkImport__c = '';
            update project;

            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, 
                              CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];    
            if (a.NumberOfErrors > 0 || (!this.errorresponses.isEmpty()))
            {
                messageBody = 'Your request to process ' + attachmentType + ' has one or more failures. Please see below for the list of failures. <br>Project Id: ' + project.ProjectNumber__c + '<br>Project Title: ' + project.Name;
                messageBody += '<br>List of Failed ' + attachmentType + ': <br>';
                for (ActionResponse response: this.errorresponses)
                {
                    messageBody += '<br>' + response.ResponseMessage;
                }
                
            }         
            else   
            {
                messageBody = 'Your request to process ' + attachmentType + ' has completed successfully.<br>Project Id: ' + project.ProjectNumber__c + '<br>Project Title: ' + project.Name;
                messageBody = messageBody + '<br><br><a href=' + link + '>Click here to directly access the project.</a>';            
            }
            
            removeImportAttachments();
            
            notifyUserByEmail(messageBody, project);
            
        }
        catch (Exception e)
        {
            Database.rollback(sp);

        }
    }
    
    private void removeImportAttachments()
    {
		delete [SELECT Id FROM Attachment 
                where ParentId =:projectId AND
                Name like :IMPORT_ATTACHMENT_PATTERN];
    }

    private void notifyUserByEmail(String messageBody, Project__c project)
    {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        User activeUser = [Select Email From User where Username = :UserInfo.getUserName() limit 1];        
        
        if (activeUser != null)
        {
            try{
                String[] toAddresses = new String[] {activeUser.Email};                
                String messageSubject = 'Import Request Status: ' + attachmentType + ' - ' + project.Name;
                EmailHelper.SendEmail(toAddresses,messageSubject,messageBody);
            }
            catch(Exception ex){
                system.debug('ERROR: Failed to send import success email. Details: ' + ex.getMessage());
            }
        }
        
        
    }
    
}