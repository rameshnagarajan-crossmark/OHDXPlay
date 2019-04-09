global class BatchGetHistoryChanges implements Database.Batchable<Object> {
    
    String entityName;
    
    public static String getNAMESPACE() {
        return CONSTANTS.CURRENTNAMESPACEPREFIX;
    }
    
    Map<String,List<String>> entities = new Map<String,List<String>>();        
    Map<String,Map<String,String>> entitieFieldMap = new Map<String,Map<String,String>>();   
    Map<String,List<EntityChangeType__c>> entityChangeTypeMap = new Map<String,List<EntityChangeType__c>>();        
    
    public BatchGetHistoryChanges()
    {                      
        List<EntityChangeLogSetting__c> logSettings = [Select Entity__c, Field__c, FieldKey__c FROM EntityChangeLogSetting__c];
        
        for(EntityChangeLogSetting__c logSetting: logSettings){
            
            if (entities.containskey(logSetting.Entity__c)){
                
                List<String> newValue = entities.get(logSetting.Entity__c);
                newValue.add(logSetting.Field__c);
                
                // To make entities based SOQL Query
                entities.put(logSetting.Entity__c,newValue);
                
                //To build field map based on entity
                Map<String,String> fieldKeyMap = entitieFieldMap.get(logSetting.Entity__c);
                fieldKeyMap.put(logSetting.FieldKey__c,logSetting.Field__c);
                entitieFieldMap.put(logSetting.Entity__c,fieldKeyMap);                
            }
            else{
                
                List<String> newValue = new List<string>();
                newValue.add(logSetting.Field__c);
                entities.put(logSetting.Entity__c, newValue);                
                
                //To build field map based on entity
                Map<String,String> fieldKeyMap = new Map<String,String>();
                fieldKeyMap.put(logSetting.FieldKey__c,logSetting.Field__c);
                entitieFieldMap.put(logSetting.Entity__c,fieldKeyMap);
            }
        }
    }
    
    public List<Object> start(Database.BatchableContext context) {
        
        List<Object> entityList = new List<Object>();
        
        for (AggregateResult entity : [SELECT Entity__c, EntityHistoryObject__c FROM EntityChangeType__c GROUP BY Entity__c, EntityHistoryObject__c]) {            
            entityList.add(entity.get(getNAMESPACE() + 'Entity__c') + ',' + entity.get(getNAMESPACE() + 'EntityHistoryObject__c'));
        }
        
        return entityList;           
    }
    
    public void execute(Database.BatchableContext context, List<Object> scope) {        
        
        
        if(scope[0] == null){return;}
        Datetime MaxDateTime = system.now();
        
        String[] entityType = String.valueof(scope[0]).split(',');   
        entityName = entityType[0];
        String entityHistoryObjectName = entityType[1];
        
        if (entityHistoryObjectName == '') {return; }
        
        ProcessLastSyncTime__c lastSync = EntityHistoryActionHelper.GetLastSyncTime(entityName + 'ChangeTracking', context.getJobId());
        
        //If there's an existing process running, return
        if (lastSync == null) {return;}
        
        Datetime lastSyncDateTime = lastSync.SyncTime__c;    
        
        Map<String,String> fieldKey = new Map<String,String>();
        fieldKey = entitieFieldMap.get(entityName); 
        
        List<string> historyObjectFieldList = new List<String>{'Id', 'CreatedDate', 'Field', 'OldValue', 'NewValue'};                          
            List<String> extraFields = entities.get(entityName);
        
        if (extraFields != null){
            historyObjectFieldList.addAll(extraFields);
        }        
        
        //Get only changes that happened 15 seconds ago so we don't overlap or miss then the ones that are still running and inserting changes.
        //We need to process all the changes that happened at the same time as a group.
        DateTime upperDateTime = DateTime.Now().addSeconds(-15);   
        
        // Get record count limit from custom setting.
        Integer recordLimit = AppUtil.HistoryRecordLimit;
        
        String query = 'SELECT ' + String.Join(historyObjectFieldList,',') + '  FROM ' + entityHistoryObjectName + ' WHERE CreatedDate >: lastSyncDateTime and CreatedDate <= :upperDateTime ORDER BY CreatedDate Limit :recordLimit';
        system.debug('query::::' + query);
        List<SObject> historyLogList = Database.query(query);
        
        if (!historyLogList.isEmpty())
        {            
            EntityHistoryActionHelper.ProcessHistoryChanges(historyLogList, entityName , fieldKey);         
            MaxDateTime = datetime.valueOf(historyLogList[historyLogList.size()-1].get('CreatedDate'));
        }        
        
        //to get last sync time        
        EntityHistoryActionHelper.UpdateSyncTime(entityName + 'ChangeTracking', context.getJobId(),MaxDateTime);
        
    }
    
    public void finish(Database.BatchableContext BC) {                    
        system.debug(entityName + ' History Batch Finished');
    }
}