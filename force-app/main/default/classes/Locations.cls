public without sharing class Locations extends LightningRequestBase {
  static Integer MAX_ROW_SIZE;
  static {
    MAX_ROW_SIZE = 9500;
  }
  //bad design. locations only handle request related to its defintion, should not be aware of project.
  public override Object search(Object parameters){
    Map<String,object> query = (Map<String,object>) parameters;
    String action = LightningRequestHelper.getRequestAction1(query);
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));
    String keyword = LightningRequestHelper.parseString(query.get('keyword'));

    if (String.isBlank(projectId)){
      throw new AuraHandledException('The project identifier is required when searching locations.');
    }
    
    if(action == 'uploadFile'){
      return getLocationsByOneHubLocationId(projectId, LightningRequestHelper.parseArrayOfString(query.get('locations')));
    }

    Map<String,Object> response = new Map<String,Object>();
    List<Map<String,Object>> data = new List<Map<String,Object>>();
    List<Location__c> locations = getLocationsByKeyword(projectId, keyword);
    for(Location__c rec: locations){
        data.add(transformLocation(rec));
    }
    return data;
  }

  static Integer countExistedProjectLocations(String projectId){
    AggregateResult[] results = [SELECT count(id) cnt FROM ProjectLocation__c WHERE Project__c=:projectId];
    return Integer.valueOf(results[0].get('cnt'));
  }

  Map<String,Object> getLocationsByOneHubLocationId(String projectId, List<String> idSet){
    List<Map<String,Object>> data = new List<Map<String,Object>>();
    Map<String,Object> result = new Map<String,Object>();
    Map<String,Object> rec;
    Boolean isOneHubIdSearch = ProjectLocationSettings.isSearchLocationByOneHubId();
    String sql ='SELECT Id, LocationNumber__c, Name, OneHubLocationID__c FROM Location__c';
    sql += ' WHERE IsActive__c=true AND Type__c=\'Location\' AND OneHubLocationID__c <> null AND ';
    if(isOneHubIdSearch){
      sql += 'OneHubLocationID__c IN :idSet';
    } else {
      sql += 'LocationNumber__c IN :idSet';
    }

    for(Location__c loc: Database.query(sql)){
      rec = new Map<String,Object>();
      rec.put('id', loc.Id);
      rec.put('uid', loc.OneHubLocationID__c);
      rec.put('num', loc.LocationNumber__c);
      rec.put('desc', loc.Name);
      data.add(rec);
    }
    result.put('locations',data);
    List<Map<String,Object>>  addedLocations = new List<Map<String,Object>>();
    sql = 'SELECT OneHubLocationID__c, LocationNumber__c FROM Location__c WHERE IsActive__c=true AND Type__c=\'Location\' AND OneHubLocationID__c <> null AND ';
    if(isOneHubIdSearch){
        sql += 'OneHubLocationID__c IN :idSet';
      }else{
        sql += 'LocationNumber__c IN :idSet';
      }
    
    sql += ' AND Id IN (SELECT Location__c FROM ProjectLocation__c Where Project__c=:projectId)';

    for(Location__c loc: Database.query(sql)){
       rec = new Map<String,Object>();
       rec.put('uid', loc.OneHubLocationID__c);
       rec.put('num', loc.LocationNumber__c);
      addedLocations.add(rec);
    }
    result.put('exclusions', addedLocations);
    return result;
  }

    private static List<Location__c> getLocationsByKeyword(String projectId, String keyword){
    List<String> sql = genLocationSelectBaseSoql();
    if (!String.isBlank(keyword)){
      keyword = keyword + '%';
      sql.add('AND (OneHubLocationId__c Like :keyword OR Name Like :keyword)');
    }
    Integer count = MAX_ROW_SIZE - countExistedProjectLocations(projectId);
    sql.add('LIMIT ' + count);
    return database.query(String.join(sql,' '));
  }

   private static Map<String,Object> transformLocation(Location__c location){
    Map<String,Object> rec = new Map<String,Object>();
    rec.put('id', location.Id);
    rec.put('uid', location.OneHubLocationID__c);
    rec.put('num', location.LocationNumber__c);
    rec.put('name', location.Name);
    rec.put('postal', location.PostalCode__r != null ? location.PostalCode__r.Name : '');
    rec.put('city', location.City__c);
    rec.put('state', location.State__c);
    rec.put('type', location.Parent__r != null ? location.Parent__r.Name : '');
    return rec;
  }

  private static List<String> genLocationSelectBaseSoql(){
    List<String> sql = new List<String>();
    sql.add('SELECT Id, LocationNumber__c, OneHubLocationID__c, Name, Address__c, City__c, State__c, PostalCode__r.Name, Parent__r.Name FROM Location__c');
    sql.add('WHERE IsActive__c=true AND Type__c=\'Location\'');
    sql.add('AND OneHubLocationID__c <> null');
    sql.add('AND Id Not In (SELECT Location__c FROM ProjectLocation__c WHERE Project__c=:projectId AND Status__c != \'Canceled\')');
    return sql;
  }

  public override Object filter(Object parameters){
    Map<String,object> query = (Map<String,object>) parameters;
    String projectId = LightningRequestHelper.parseString(query.get('projectId'));

    if (String.isBlank(projectId)){
      throw new AuraHandledException('The project identifier is required when filtering locations.');
    }
    
    String keyword = LightningRequestHelper.parseString(query.get('keyword'));
    String city = LightningRequestHelper.parseString(query.get('city'));
    String state = LightningRequestHelper.parseString(query.get('state'));
    String postal = LightningRequestHelper.parseString(query.get('postal'));
    String storeType = LightningRequestHelper.parseString(query.get('type'));

    Map<String,Object> response = new Map<String,Object>();
    List<Map<String,Object>> data = new List<Map<String,Object>>();
    List<Location__c> locations = getLocationsByFilter(projectId, keyword, city, state, postal, storeType);
    for(Location__c rec: locations){
        data.add(transformLocation(rec));
    }
    return data;
  }
  static List<Location__c> getLocationsByFilter(String projectId, String keyword, String city, String state, String postal, String storeType){
    Integer count = MAX_ROW_SIZE - countExistedProjectLocations(projectId);
    if(count == 0) {
      throw new AuraHandledException('The maximum of 9500 Locations has been reached.');
    }

    List<String> sql = genLocationSelectBaseSoql();
    if (!String.isBlank(keyword)){
      keyword = keyword + '%';
      sql.add('AND (LocationNumber__c Like :keyword OR Name Like :keyword)');
    }
    if (!String.isBlank(city)){
      city = city + '%';
      sql.add('AND City__c like :city');
    }
    if (!String.isBlank(city)){
      city = city + '%';
      sql.add('AND City__c like :city');
    }
    if (!String.isBlank(state)){
      state = state + '%';
      sql.add('AND State__c like :state');
    }
    if (!String.isBlank(postal)){
      postal = postal + '%';
      sql.add('AND PostalCode__r.Name like :postal');
    }
    if (!String.isBlank(storeType)){
      storeType = storeType + '%';
      sql.add('AND Parent__r.Name LIKE :storeType');
    }
    
    sql.add('LIMIT ' + count);
    return database.query(String.join(sql, ' '));
  }
}