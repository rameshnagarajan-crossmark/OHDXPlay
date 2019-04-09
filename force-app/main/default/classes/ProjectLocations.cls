public without sharing class ProjectLocations extends LightningRequestBase {
  static final Integer MAX_ROW_SIZE;
  static {
    MAX_ROW_SIZE = 9500;
  }

  //api: modify
    
  public override Object modify(Object parameters) {
    Map<String,Object> query = (Map<String,Object>)parameters;
    String action = LightningRequestHelper.parseString(query.get('action'));
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));
    List<String> locations = LightningRequestHelper.parseArrayOfString(query.get('locations'));
    if (action == 'cancelLocations'){
      return handleCancelLocations(projectId, locations, query);
    }
    if (action == 'reattemptLocations'){
      return handleReattemptLocations(projectId, locations);
    }
      
    
    Date scheduleDate = LightningRequestHelper.parseDate(query.get('scheduleDate'));
    validateScheduleLocations(projectId, scheduleDate, locations);
    return scheduleLocations(projectId, scheduleDate, locations);
  }

  Map<String,Object> handleCancelLocations(String projectId, List<String> locations, Map<String,Object>query){
    LightningRequestHelper.checkStringValueRequired(projectId, 'The Project Id is required when cancelling the project locations.');
    LightningRequestHelper.checkStringArrayRequired(locations,'There are no selected project Locations to cancel');

    String reason = LightningRequestHelper.parseString(query.get('reason'));
    String comment = LightningRequestHelper.parseString(query.get('comment'));

    String sql = 'SELECT Id FROM ProjectLocation__c WHERE Project__c=:projectId AND Id In :locations';
    List<Id> idSet = new List<Id>();
    for(ProjectLocation__c p: Database.query(sql)) {
      idSet.add(p.Id);
    }
    List<ActionResponse> responses = ProjectLocationActionsHelper.CancelProjectLocation(idSet, reason,comment);
    if(responses[0].IsSuccessful){
        return LightningRequestHelper.createResponseWithData('success',
          locations.size() + ' Project Location(s) have been cancelled successfully.',responses[0].IsBatched);
    }
    throw new AuraHandledException('The system fails to cancel the project locations.');
  }
    
  Map<String,Object> handleReattemptLocations(String projectId, List<String> locations){

    String sql = 'SELECT Id FROM ProjectLocation__c WHERE Project__c=:projectId AND Id In :locations';
    system.debug('handle RA Locs: ' + locations);  
    List<Id> idSet = new List<Id>();
    for(ProjectLocation__c p: Database.query(sql)) {
      idSet.add(p.Id);
    }
      
    system.debug('handle RA calling RA PLS: ');    
    List<ActionResponse> responses = ProjectLocationActionsHelper.ReattemptProjectLocations(idSet);
      
      
    if(responses[0].IsSuccessful){
        return LightningRequestHelper.createResponseWithData('success',
          locations.size() + ' Reattempt(s) have been scheduled successfully.',responses[0].IsBatched);
    }
    throw new AuraHandledException('The system failed to reattempt the project locations.');
  }    

  private void validateScheduleLocations(String projectId, Date scheduleDate, List<String> locations){
    LightningRequestHelper.checkStringValueRequired(projectId, 'The Project Id is required when scheduling locations.');
    checkIfProjectAllowToReschedule(projectId);
    if(LightningRequestHelper.isDateNull(scheduleDate)){
      throw new AuraHandledException('The schedule date must be specified when scheduling locations.');
    }
    LightningRequestHelper.checkStringArrayRequired(locations,'There are no selected project Locations to schedule');
  }

  private void checkIfProjectAllowToReschedule(string projectId){
    Project__c p = [SELECT ProjectScheduleOption__r.Code__c FROM Project__c WHERE Id=:projectId];
    if(p.ProjectScheduleOption__r != null && p.ProjectScheduleOption__r.Code__c != CONSTANTS.SCHEDULE_OPTION_USER) {
      throw new AuraHandledException('The project is not allowed to reschedule.');
    }
  }

  private Map<String,Object> scheduleLocations(String projectId, Date scheduleDate, List<String> locations){
        string msg = '';

        Id[] allIds = new Id[]{};
        for(string item : locations)
        {
          allIds .add(item);
        }
        
        List<ActionResponse> responses = ProjectLocationActionsHelper.setScheduleDates(allIds, scheduleDate);
        
        if (responses[0].IsBatched)
        {
          return LightningRequestHelper.createResponse('info', 'Schedule dates in progress.');
        }
        
        if(responses[0].IsSuccessful){
          return LightningRequestHelper.createResponse('success', 'The Set Schedule Request is processed successfully.');
        }

        throw new AuraHandledException('The system failed to process the request. ' + responses[0].ResponseMessage);
  }

  //api: remove
  public override Object remove(Object parameters){
    Map<String,Object> query = (Map<String,Object>)parameters;
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));
    String action = LightningRequestHelper.parseString(query.get('action'));
    LightningRequestHelper.checkStringValueRequired(projectId,'The Project Id is required when removing the project locations.');
    List<Id> locations;
    Boolean isRemovallAll = action == 'removeAll' ? true: false;

    if(isRemovallAll){
      locations =getProjectLocationIds(projectId);
    } else {
      locations = getProjectLocationIdsWithProvidedIds(projectId,LightningRequestHelper.parseArrayOfId(query.get('locations')));
    }

    if(locations.size() == 0) {
      throw new AuraHandledException('There are no project locations to remove.');
    }
    
    List<ActionResponse> responses = ProjectLocationActionsHelper.DeleteProjectLocations(locations);
    if(responses[0].IsSuccessful){
      if(responses[0].IsBatched){
        return LightningRequestHelper.createResponseWithData('success', 
          'Your location removal request has started. Please allow a few minutes to process your request. You will receive an email notification once request is processed.', 
        'isBatchJob');
      }
      return LightningRequestHelper.createResponse('success', 
        locations.size() + ' Project Location(s) have been removed successfully.');
    }
    throw new AuraHandledException('The system fails to remove the project location. ' + responses[0].ResponseMessage);
  } 

  List<Id> getProjectLocationIds(string projectId){
    List<id> locations =new List<Id>();
      for(ProjectLocation__c pLoc: [SELECT Id FROM ProjectLocation__c WHERE Project__c=:projectId]){
        locations.add(Id.valueOf(pLoc.Id));
      }
      return locations;
  }

  List<Id> getProjectLocationIdsWithProvidedIds(string projectId, List<Id> idSet){
    List<id> locations =new List<Id>();
    if(idSet.size() == 0){
      return locations;
    }

    for(ProjectLocation__c pLoc: [SELECT Id FROM ProjectLocation__c WHERE Project__c=:projectId AND Id IN :idSet]){
      locations.add(Id.valueOf(pLoc.Id));
    }
    return locations;
  }

  //api: add
  public override Object add(Object parameters) {
    Map<String,Object> query = (Map<String,Object>)parameters;
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));
    String action = LightningRequestHelper.getRequestAction1(query);
    LightningRequestHelper.checkStringValueRequired(projectId,'The Project Id is required when adding the project locations.');

    List<Map<String,Object>> locations = LightningRequestHelper.parseMapList(query.get('locations'));
    if (locations.size() ==0){
      throw new AuraHandledException('There are no locations to add to this project.');
    }
    return addLocationsWithSchedule(projectId, locations); 
  }

  void checkMaximumNotReached(String projectId, Integer numberOfRecordsToAdd){
    Integer existedCount = countExistedProjectLocations(projectId);
    if((numberOfRecordsToAdd + existedCount) > MAX_ROW_SIZE){
      throw new AuraHandledException('The maximum of 9500 Locations has been reached.');
    }
  }

  Map<String,Object> addLocationsWithSchedule(string projectId, List<Map<String,Object>> locations){
    Map<String, ProjectLocation__c> recordSet= getLocationsToInsert(locations, projectId);
    Map<String, Map<String,Object>> data = getValidLocations(projectId, locations);
    Map<String,Object> rec;
    List<String> keySet;
    Integer i=0;
    Integer success = 0;
    Integer fails = 0;
    Integer invalids = 0;
    String status = '';
    List<String> messages = new List<String>();

    if (recordSet.size() > 0) {
      checkMaximumNotReached(projectId, recordSet.size());
      keySet = new List<String>(recordSet.keySet());

      for(Database.SaveResult sr: tryToAddLocations(recordSet.values())){
        if(sr.isSuccess()){
          rec = data.get(keySet.get(i));
          if(rec != null){
            rec.put('status', 'added');
            success++;
          }
        } else {
           rec = data.get(keySet.get(i));
          if(rec != null){
            rec.put('status', 'failed');
            fails++;
          }
        }
        i++;
      }
      if(success > 0){
        messages.add(success + ' locations are added successfully.');
        status = 'success';
      }
      if(fails > 0){
        messages.add(fails + ' locations failed to be inserted.');
        status = 'error';
      }
     } else {
      for(Map<String,Object> d: data.values()){
        d.put('status','duplicated');
      }
      status = 'error';
      if (data.size() > 0){
        messages.add(String.valueOf(data.size()) + ' location(s) are duplicates.');
      }
   }

   if(data.size() != locations.size()){
      Set<String> idSet = getSearchLocationIdSet(data);
      for(Map<String,Object> loc: locations){
        String uid = String.valueOf(loc.get('uid'));
        if(String.isBlank(uid) || !idSet.contains(uid.toUpperCase())){
          invalids++;
          rec = new Map<String,Object>();
          rec.put('uid', uid);
          rec.put('schedule', loc.get('schedule'));
          rec.put('name','');
          rec.put('num','');
          rec.put('status', 'invalid');
         
          
          data.put(uid, rec);
        }
      }
      if(invalids > 0){
        status = 'error';
        //sankar added
       // messages.add(invalids + ' Unique Identifiers are invalid.');
       messages.add(invalids + ' location(s) do not exist in the system');
      } 
   }
   return LightningRequestHelper.createResponseWithData(status, String.join(messages, ' '), data.values());
  }

  static Set<String> getSearchLocationIdSet(Map<String,Map<String,Object>> validData){
    Set<String> idSet = new Set<String>();
    if(ProjectLocationSettings.isSearchLocationByOneHubId()){
      for(String key: validData.keyset()) {
        Map<String,Object> kvp = validData.get(key);
       idSet.add(String.valueOf(kvp.get('uid')).toUpperCase());
      }
      } else {
        for(String key: validData.keyset()){
          Map<String,Object> kvp = validData.get(key);
          idSet.add(String.valueOf(kvp.get('num')).toUpperCase());
        }
      }
      return idSet;
  }

  static Database.SaveResult[] tryToAddLocations(List<ProjectLocation__c> dbRecords){
    String error;
    try{
      return Database.insert(dbRecords);
      } catch(DmlException ex){
        error = ex.getMessage();
        if(error.indexOf('9,500 locations') != -1){
          throw new AuraHandledException('A project can not have more than 9500 locations.');
        }
        throw new AuraHandledException('Failed to add the project locations: ' + ex.getDmlMessage(0));
      }
  }

  static Map<String,Object> getUidMap(List<Map<String,Object>> locations){
    String uid;
    Map<String,Object> result= new Map<String,Object>();
    for(Map<String,Object> locMap: locations){
      uid = String.valueOf(locMap.get('uid'));
      if(!String.isBlank(uid)){
        result.put(uid.toUpperCase(), locMap.get('schedule'));
      }
    }
    return result;
  }

  Map<String,Map<String,Object>> getValidLocations(String projectId, List<Map<String,Object>> locations){
    Map<String, Map<String,Object>> data = new Map<String, Map<String,Object>>();
    Map<String,Object> uidMap = getUidMap(locations);

    set<String> locList = uidMap.keyset();
    List<String> sql = new List<String>();
    List<String> sql1 = new List<String>();
    sql1.add('SELECT Location__c, Location__r.OneHubLocationID__c from projectLocation__c where project__c=:projectId');
    sql.add('SELECT Id, OneHubLocationID__c, Name, LocationNumber__c From Location__c WHERE IsActive__c=true AND Type__c=\'Location\'');
    sql.add('AND OneHubLocationId__c <> null');
    if(ProjectLocationSettings.isSearchLocationByOneHubId()){
        sql.add('AND OneHubLocationID__c In :locList');
        sql1.add('AND Location__r.OneHubLocationID__c in :locList');
      } else {
        sql.add('AND LocationNumber__c In :locList');
        sql1.add('AND Location__r.LocationNumber__c In :locList');
      }
    // get already added locations
    Set<String> dups = new Set<String>();
    for(ProjectLocation__c pl: database.query(String.join(sql1,' '))){
      if (pl.Location__c != null) {
          dups.add(String.valueOf(pl.Location__r.OneHubLocationID__c));
      }
    }

    //get valid locations;
    for(Location__c location: database.query(String.join(sql, ' '))){
      Map<String,String> rec = new Map<String,String>();
      rec.put('uid', location.OneHubLocationID__c);
      rec.put('name', location.Name);
      rec.put('num', location.LocationNumber__c);
      rec.put('status', dups.contains(location.OneHubLocationID__c) ? 'duplicated': 'valid');
      data.put(String.valueOf(location.OneHubLocationID__c), rec);
    }
    return data;
  }

   Map<String, ProjectLocation__c> getLocationsToInsert(List<Map<String,Object>>locations, String projectId){
    ProjectLocation__c  projectLocation;
    Set<String> locationIds = new Set<String>();   
    Map<String, ProjectLocation__c> recordSet= new Map<String, ProjectLocation__c>();
    Project__c project = [SELECT Id,Status__c,AllowTeamManagement__c, ProjectType__c FROM Project__c WHERE Id =:projectId];
    Boolean isNewLocation = CONSTANTS.PROJECT_STATUS_PLANNING.equalsIgnoreCase(project.Status__c)?false: true; 
    Map<String,Object> uidMap = getUidMap(locations);
    set<String> locSet = uidMap.keyset();
    String uid;
    Date schedule;

    List<String> sql = new List<String>();
    sql.add('SELECT Id, OneHubLocationID__c, Name, LocationNumber__c From Location__c WHERE IsActive__c=true AND Type__c=\'Location\'');
    sql.add('AND OneHubLocationID__c <> null');
     if(ProjectLocationSettings.isSearchLocationByOneHubId()){
        sql.add('AND OneHubLocationID__c In :locSet');
      } else {
        sql.add('AND LocationNumber__c In :locSet');
      }
    sql.add('AND Id Not In (Select Location__c FROM ProjectLocation__c Where Project__c=:projectId AND Status__c != \'Canceled\')');
       
    List<Location__c> locs =  database.query(String.join(sql, ' '));  
    for (Location__c loc : locs)   
    {
        locationIds.add(loc.Id);
    }
    
    String ec = '';   
    Map<String, String> locExecutionCompanies = getLocationExecutionCompanies(locs, project);
	if (locExecutionCompanies.containskey('All'))
    {
        ec = locExecutionCompanies.get('All');
    }
        
    for(Location__c location:locs){
      string executioncompany = '';  
      uid = (ProjectLocationSettings.isSearchLocationByOneHubId()) ? String.valueOf(location.OneHubLocationID__c).toUpperCase(): String.valueOf(location.LocationNumber__c);
      schedule = LightningRequestHelper.parseDate(uidMap.get(uid));
      projectLocation = new ProjectLocation__c();
      projectLocation.Location__c = location.id;
      projectLocation.Project__c = projectId;
      if(project!=null)
      {
        projectLocation.AllowTeamManagement__c =project.AllowTeamManagement__c;
      }
      projectLocation.IsNewLocation__c = isNewLocation;
      if(!LightningRequestHelper.isDateNull(schedule)){
        projectLocation.LocationScheduledDate__c = schedule;
      }
       
      if (ec.Trim().length() > 0)  
      {
          executioncompany = ec;
      }
      else
      {
          if (locExecutionCompanies.get(location.id) != null)
          	executioncompany = locExecutionCompanies.get(location.id);    
      }
      projectLocation.ExecutionCompany__c =  executioncompany;

      recordSet.put(String.valueOf(location.OneHubLocationID__c),projectLocation);
    }

    return recordSet;
   }
    
  Map<String, String> getLocationExecutionCompanies(List<Location__c> locs, Project__c project)  
  {
      Map<String, String> locExecutionCompanies = new Map<String, String>();

      List<Account> ecList = [select Id from Account where type = 'Execution Company' LIMIT 2];
	  if (ecList.size() == 1) 	      
      {
          locExecutionCompanies.put('All',ecList[0].Id);
          return locExecutionCompanies;
      }
      
      for (LocationAssignment__c assignment : [SELECT Location__c, AccountableExecutionCompany__c FROM LocationAssignment__c WHERE ProjectType__c =: project.ProjectType__c AND AccountableExecutionCompany__c != NULL AND Location__c IN :locs]) {
          system.debug('NOT in locExecutionCompany: ');
          if(!locExecutionCompanies.containsKey(assignment.Location__c)){
              locExecutionCompanies.put(assignment.Location__c, assignment.AccountableExecutionCompany__c);
          }
      }      
      
      return locExecutionCompanies;
      
      
  }

  Integer[] analyzeResults(Database.SaveResult[] results){
    Integer ok =0, wrong=0;
    for(Database.SaveResult r: results){
      if (r.isSuccess()) {
        ok++;
      } else {
        wrong++;
      }
    }
    return new Integer[]{
      ok, wrong
    };
  }

  //api: search
  public override Object search(object parameters) {
    string keyword;
    List<ProjectLocation__c> projectLocations;
    Map<String,Object> query = (Map<String,Object>) parameters;
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));
    List<String> keywords = query.get('keyword') != null ? LightningRequestHelper.parseArrayOfString(query.get('keyword')) : new String[]{};
    LightningRequestHelper.checkStringValueRequired(projectId,'The Project Id is required when searching project locations.');
    Integer size = keywords.size();
    Map<String,Object> result = new Map<String,Object>();

    if(size > 1)
    {
      projectLocations = getProjectLocationsByKeywordArray(projectId, keywords);
    } else {
      keyword = (size == 1) ? keywords[0] : '';
      projectLocations = getProjectLocationsByKeyword(projectId, keyword);
    }

    if(projectLocations.size() == 0) {
      return null;
    } 
    result.put('rowCount', calculateRowCountByKeywords(projectId, keywords));
    result.put('data',buildFilterResponse(projectId, projectLocations));
    return result;
  }

  Integer calculateRowCountByKeywords(String projectId, List<String> keywords){
    List<String> sql= genSelectCountBaseSoql();
    string keyword;
    Integer size = keywords.size();
    if(size > 1){
      sql.add('AND LocationNumber__c IN :keywords');
    } else if (size == 1){
      keyword = keywords[0] + '%';
      sql.add('AND (Location__r.OneHubLocationId__c Like :keyword OR LocationName__c Like :keyword)');
    }
    AggregateResult[] results = Database.query(String.join(sql, ' '));
    return Integer.valueOf(results[0].get('total'));
  }

  List<Map<String,Object>> buildFilterResponse(string projectId, List<ProjectLocation__c> projectLocations){
    List<Id> idSet = mapIdSet(projectLocations);
    List<Map<String,Object>> result = new List<Map<String,Object>>();
    string company, id;

    for(ProjectLocation__c pl: projectLocations){
      company = pl.ExecutionCompany__r != null ? pl.ExecutionCompany__r.name : '';
      result.add(transformProjectLocation(pl,company));
    }
    return result;
  }

  List<ProjectLocation__c> getProjectLocationsByKeyword(String projectId, String keyword){
    List<String> sql = genSelectBaseSoql();
    if(!String.isBlank(keyword)){
      keyword = keyword + '%';
      sql.add('AND (Location__r.OneHubLocationId__c Like :keyword OR LocationName__c Like :keyword)');
    }
    sql.Add('Order By SystemModStamp DESC LIMIT ' + LightningRequestHelper.PAGE_SIZE);
    return Database.query(String.join(sql, ' '));
  }

  List<ProjectLocation__c> getProjectLocationsByKeywordArray(String projectId, String[] keywords){
    List<String> sql = genSelectBaseSoql();
    if(keywords.size() > 0){
      sql.add('AND LocationNumber__c IN :keywords');
    }
    sql.Add('Order By SystemModStamp DESC LIMIT ' + LightningRequestHelper.PAGE_SIZE);
    return Database.query(String.join(sql, ' '));
  }

  Map<String, Integer[]> calculateServiceWorkers(List<Id> locations, String projectId){
    List<String> sql = new List<String>();
    Map<String, Integer[]> data = new Map<String,Integer[]>();
    Integer[] item;
    //sql.add('SELECT ProjectLocation__c location, Sum(EstimatedMinutes__c) minutes, Max(NumberOfWorkers__c) workers');
    sql.add('SELECT ProjectLocation__c location');
    sql.add('FROM Job__c WHERE Project__c=:projectId');
    sql.add('AND ProjectLocation__c In :locations Group By ProjectLocation__c');
    AggregateResult[] results = database.query(String.join(sql, ' '));
    for(AggregateResult r: results){
      item= new Integer[] {
        Integer.valueOf(r.get('workers')),
        Integer.valueOf(r.get('minutes'))
      };

      data.put(String.valueOf(r.get('location')), item);
    }
    return data;
  }

  List<Id> mapIdSet(List<ProjectLocation__c> locations){
    List<Id> idSet = new List<Id>();
    for(ProjectLocation__c l: locations){
      idSet.add(l.Id);
    }
    return idSet;
  }

  //Map<String,Object> transformProjectLocation(ProjectLocation__c location, Integer workers, double hours, String company){
   Map<String,Object> transformProjectLocation(ProjectLocation__c location, String company){
    Map<String,Object> r = new Map<String,Object>();
    String type = location.Location__r != null && location.Location__r.Parent__r != null ? location.Location__r.Parent__r.Name : '';
    r.put('id', location.Id);
    r.put('status', location.Status__c);
    r.put('num', location.LocationNumber__c);
    r.put('name', location.LocationName__c);
    r.put('address', location.Address__c);
    r.put('city', location.City__c);
    r.put('state', location.State__c);
    r.put('postal', location.PostalCode__c);
   // r.put('workers', workers);
   // r.put('hours', hours);
    r.put('type', type);
    r.put('schedule', location.LocationScheduledDate__c);
    r.put('execution', location.Executed__c ==true ? 1 : 0);
    r.put('company', company);
    return r;
  }

  //api: filter
  public override object filter(object parameters) {
    Map<String,Object>results = new Map<String, Object>();
    Map<String,object>query = (Map<String,Object>)parameters;
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));
    LightningRequestHelper.checkStringValueRequired(projectId,
      'The Project Id is required when filtering the project locations.');
    List<Object> queryResults= getProjectLocationsByFilter(projectId, query);
    AggregateResult[] countResults= (AggregateResult[]) queryResults[0];
    List<ProjectLocation__c> pLocs = (List<ProjectLocation__c>) queryResults[1];
    results.put('rowCount', Integer.valueOf(countResults[0].get('total')));
    results.put('data',buildFilterResponse(projectId, pLocs));
    return results;
  }

  List<Object> getProjectLocationsByFilter(String projectId, Map<String,Object>query){
    List<String> sql = genSelectBaseSoql();
    List<String>sqlCount = genSelectCountBaseSoql();
    List<String> predicates = new List<String>();
    List<Object> results = new List<Object>();
    string keyword= '';
    String[] keywords = LightningRequestHelper.parseArrayOfString(query.get('keyword'));
    String city = LightningRequestHelper.parseString(query.get('city'));
    String state = LightningRequestHelper.parseString(query.get('state'));
    String service = LightningRequestHelper.parseString(query.get('service'));
    String postal = LightningRequestHelper.parseString(query.get('postal'));
    String storeType = LightningRequestHelper.parseString(query.get('type'));
    String closed = LightningRequestHelper.parseString(query.get('chkClosed'));
    String hasException = LightningRequestHelper.parseString(query.get('chkException'));
    String hasMaterial = LightningRequestHelper.parseString(query.get('chkMaterial'));
    String jobFilter = LightningRequestHelper.parseString(query.get('jobFilter'));
    String scheduled = LightningRequestHelper.parseString(query.get('chkScheduled'));
    String executed = LightningRequestHelper.parseString(query.get('chkExecuted'));
    Boolean executedBoolean = false;
    String completed = LightningRequestHelper.parseString(query.get('chkCompleted'));
    Date dateFrom = LightningRequestHelper.parseDate(query.get('schedule1'));
    Date dateTo = LightningRequestHelper.parseDate(query.get('schedule2'));
    Integer size = keywords.size();
    if(size > 1) {
      predicates.add('AND LocationNumber__c In :keywords');
      } else {
      if(size == 1){
        keyword = keywords[0] + '%';
        predicates.add('AND (LocationNumber__c Like :keyword OR LocationName__c Like :keyword)');
      }
    }
    if(!String.isBlank(city)){
      city += '%';
      predicates.add('AND City__c Like :city');
    }
    if(!String.isBlank(state)){
      state += '%';
      predicates.add('AND State__c Like :state');
    }
    if(!String.isBlank(postal)){
      postal += '%';
      predicates.add('AND PostalCode__c Like :postal');
    }

    if(!String.isBlank(storeType)){
      storeType = storeType + '%';
      predicates.add('AND Location__c IN (SELECT Id FROM Location__c WHERE Parent__r.Name LIKE :storeType OR Parent__r.OneHubLocationId__c LIKE :storeType)');
    }

    if(executed == '1'){
      executedBoolean = true;
      predicates.add('AND Executed__c =:executedBoolean');
    }
    if(!LightningRequestHelper.isDateNull(dateFrom)){
      predicates.add('AND LocationScheduledDate__c >= :dateFrom');
    }
    if(!LightningRequestHelper.isDateNull(dateTo)){
      predicates.add('AND LocationScheduledDate__c <= :dateTo');
    }
    if(scheduled == '1'){
      predicates.add('AND LocationScheduledDate__c != null');
    }

    if(!String.isBlank(service)){
      predicates.add('AND Id In (SELECT ProjectLocation__c FROM Job__c WHERE Project__c=:projectId AND Service__c=:service)');
    }

    if (jobFilter == '0'){
      predicates.add('AND Id NOT IN (SELECT ProjectLocation__c FROM Job__c WHERE Project__c=:projectId)');
    }

    List<String> jobSubQueryPredicates = getJobSubQueryPredicates(hasMaterial, hasException, service, completed);
    
    if(jobSubQueryPredicates.size() > 0){
      predicates.add('AND Id IN (SELECT ProjectLocation__c FROM Job__c WHERE Project__c=:projectId ' 
        + String.join(jobSubQueryPredicates,' ') + ')');
    } else if (jobFilter == '1') {
      predicates.add('AND Id In (SELECT ProjectLocation__c FROM Job__c WHERE Project__c=:projectId)');
    }

    if (closed == '1'){
      predicates.add('AND Location__r.IsActive__c != true');
    }

    sqlCount.addAll(predicates);
    results.add(Database.query(String.join(sqlCount,' ')));

    sql.addAll(predicates);
    sql.Add('Order By SystemModStamp DESC LIMIT ' + LightningRequestHelper.PAGE_SIZE);
    results.add(Database.query(String.join(sql, ' ')));
    return results;
  }

  static List<String> getJobSubQueryPredicates(string hasMaterial, string hasException, string service, string completed){
    List<String> predicates = new List<String>();
    if (hasMaterial == '1'){
      predicates.add('AND MaterialCount__c > 0');
    }
    if(hasException == '1'){
      predicates.add('AND HasException__c = true');
    }
    if(!String.isBlank(service)){
      predicates.add('AND Service__c=:service');
    }
    if(completed == '1'){
      predicates.add('AND CompletionStatus__c=\'Completed\'');
    }
    return predicates;
  }

  static Integer calculateProjectLocationRowCount(String projectId, List<String> predicates){
    List<String> sql= genSelectCountBaseSoql();
    if(predicates.size() > 0){
      sql.addAll(predicates);
    }
    AggregateResult[] results = Database.query(String.join(sql, ' '));
    return Integer.valueOf(results[0].get('cnt'));
  }

  static List<String> genSelectBaseSoql(){
    List<String> sql = new List<String>();
    sql.add('SELECT Id, ExecutionCompany__r.Name, LocationNumber__c, LocationName__c, Address__c, City__c, State__c, PostalCode__c, Status__c,');
    sql.add('Location__r.Parent__r.Name, Executed__c, LocationScheduledDate__c, Project__r.ProjectScheduleOptionName__c');
    sql.add('From ProjectLocation__c WHERE Project__c=:projectId');
    return sql;
  }

  static List<String> genSelectCountBaseSoql(){
    List<String> sql = new List<String>();
    sql.add('SELECT COUNT(id) total FROM ProjectLocation__c WHERE Project__c=:projectId');
    return sql;
  }

  static Integer countExistedProjectLocations(String projectId){
    AggregateResult[] results = [SELECT count(id) cnt FROM ProjectLocation__c WHERE Project__c=:projectId];
    return Integer.valueOf(results[0].get('cnt'));
  }
}