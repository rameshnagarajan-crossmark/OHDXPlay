public with sharing Class JobImageHandler {
    static final Integer JobImagsLimit;
    static{
        
        OrgCustomSettings__c setting = [SELECT BatchNumberofJobImages__c FROM OrgCustomSettings__c LIMIT 1];
        if(setting.BatchNumberofJobImages__c !=null)  
        {
            JobImagsLimit = Integer.valueOf(setting.BatchNumberofJobImages__c);
        }
        else
        {
            JobImagsLimit = 1000;
        }
    }
    
    public static  List<JobImage__c> getJobImages()
    {
        List<JobImage__c> lstJobImages = [Select Id,name,ImageURL__c,ImageContentType__c,ProcessingPickupDateTime__c,ImageName__c, ImageDescription__c, Job__c,AttachmentId__c, ProjectLocation__c, Project__c  from JobImage__c  where ReadyForProcessing__c = true Limit:JobImagsLimit];
        if(lstJobImages.size()> 0)
        {
            
            for (JobImage__c ji :lstJobImages)
            {
                ji.ProcessingPickupDateTime__c = DateTime.now();
                
            }
            update lstJobImages;
        }
        
        
        return lstJobImages;
    }
    
    public static void InvokeBatchJobImages(list<JobImage__c> lstJobImages)
    {
        Id[] jobImageIds = new Id[] {};
            for(JobImage__c ji:lstJobImages)
        {
            jobImageIds.add(ji.Id);
            
        }
        BatchGenerateJobImageUrl bmimages = new BatchGenerateJobImageUrl(jobImageIds);
        Id batchJobId = Database.ExecuteBatch(bmimages, 1); 
        
    }
    public static void DoGenerateNewJobImageURL(JobImage__c jobimage)
    {
        ImageServiceSettings__c imgSvc = ImageServiceSettings__c.getValues('ImageService');
        List<Attachment> lstattmnt = [Select ID, ParentID, body, Name from Attachment where Id = :jobimage.AttachmentId__c limit 1];
         Attachment attmnt =null;
        if(lstattmnt.size()>0)
        {
           attmnt = lstattmnt[0];
        }
        else
        {
            return;
        }
        
        if(string.isBlank(jobimage.ImageContentType__c))
        {
            return;
        }
        String ext = string.valueof(jobimage.ImageContentType__c).toLowerCase();
        string attext ='';
        if(ext.length()>0)
        {
            Integer intIndex = ext.indexOf('/');
            
            if(intIndex>0)
            {
                attext  = ext.substring(intIndex+1,ext.length());
            }
            else
            {
                attext = ext;
            }
        }
        
        string JobcntType = AppUtil.getContentType(attext);
        
        
        String attachUrl = imgSvc.URL__c; 
        String userName = imgSvc.UserName__c;
        String password = imgSvc.Password__c;
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        // create new attachment URL
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(attachUrl);
        req.setMethod('POST');
        
        // set headers
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', JobcntType);
        req.setHeader('Accept', 'application/json');
        
        //set body
        
        req.setBodyAsBlob(attmnt.body);
        
        //Send request
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest())
        {
            Http http = new Http();
            res = http.send(req);
        }        
        
        //analyze the result
        
        
        JobImage__c jimage = [Select Id,name,ImageURL__c,ImageContentType__c,ProcessingPickupDateTime__c,ImageName__c, ImageDescription__c, Job__c,AttachmentId__c, ProjectLocation__c, Project__c  from JobImage__c where id=:jobimage.Id limit 1];
        if(jimage == null)
        {
            return;
        }
        jimage.ImageURL__c = res.getHeader('Location');
        update jimage;
        if (!(string.isEmpty(jimage.ImageURL__c)))
        {
            List<Attachment> a = [select id from attachment where id =:jobimage.AttachmentId__c];
            if(a.size() > 0){
                delete a;
            }
        }
        
        
        
    }
    
    
}