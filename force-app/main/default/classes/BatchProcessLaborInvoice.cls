global class BatchProcessLaborInvoice implements Database.Batchable<sObject>, Database.Stateful {
    
    Date invoicecutoffdate;
    Date invoicestartdate;

    global BatchProcessLaborInvoice(Date pinvoicecutoffdate) {
        invoicecutoffdate = pinvoicecutoffdate.addDays(1);

    }
    
    global BatchProcessLaborInvoice(Date pinvoicecutoffdate, Date pinvoicestartdate) {

        if (pinvoicestartdate != null)
        	invoicestartdate = pinvoicestartdate;
    }    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('BatchProcessLaborInvoice Batch Started');
        
        if (invoicestartdate == null)
        {
            Date isdate = Date.valueOf('2019-01-01');
            invoicestartdate = isdate;
            
        }
		        
        return Database.getQueryLocator([SELECT Id, Project__c, Invoiced__c, Location__r.LaborTaxLawsonID__c, Location__r.LaborTaxRate__c 
                                         FROM ProjectLocation__c 
                                         WHERE
                                         LocationExecutedDate__c >= :invoicestartdate AND 
                                         LocationExecutedDate__c <= :invoicecutoffdate AND 
                                         Invoiced__c = false AND 
                                         BillingStatus__c = :CONSTANTS.BILLING_STATUS_BILLABLE AND
                                         Project__r.ProjectType__r.CreateInvoice__c = true 
                                        ]);        
        
    }
   
    global void execute(Database.BatchableContext BC, List<ProjectLocation__c> scope) {
        
        Set<String> projectids = new Set<String>();
        Set<String> projectaccountids = new Set<String>();
        Set<String> opportunityids = new Set<String>();
        Set<String> invoicedpls = new Set<String>();
        
        Map<String, List<ProjectAccount__c>> ptopalistmap = new Map<String, List<ProjectAccount__c>>();
        Map<String, List<ProjectLocation__c>> ptopllistmap = new Map<String, List<ProjectLocation__c>>();
        Map<String, List<ProjectLocation__c>> patopllistmap = new Map<String, List<ProjectLocation__c>>();
		Map<String, List<OpportunityLineItem>> otoolilistmap = new Map<String, List<OpportunityLineItem>>();        
		Map<String, ProjectInvoice__c> patopimap = new Map<String, ProjectInvoice__c>();        
        
        List<ProjectInvoice__c> newpis = new List<ProjectInvoice__c>();
        List<ProjectInvoiceLineItem__c> newpilis = new List<ProjectInvoiceLineItem__c>();
		List<ProjectInvoiceLineItemDetail__c> pilidetaillist = new List<ProjectInvoiceLineItemDetail__c>();        
                
        for (ProjectLocation__c pl : scope)
        {
            projectids.add(pl.Project__c);
            List<ProjectLocation__c> plList = new List<ProjectLocation__c>();
            plList.add(pl);                
            if (ptopllistmap.get(pl.Project__c) != null)
            {
                plList.addall(ptopllistmap.get(pl.Project__c));
            }
            ptopllistmap.put(pl.Project__c, plList);

        }
        
        List<ProjectAccount__c> pas = [Select Id, Project__c, Account__c, Opportunity__c FROM ProjectAccount__c 
                                       WHERE Project__c IN :projectids];
        if (!pas.isEmpty())
        {
            for (ProjectAccount__c pa : pas)
            {
                projectaccountids.add(pa.Id);
                opportunityids.add(pa.Opportunity__c);
                List<ProjectAccount__c> paList = new List<ProjectAccount__c>();
                paList.add(pa);                
                if (ptopalistmap.get(pa.Project__c) != null)
                {
                    paList.addall(ptopalistmap.get(pa.Project__c));
                }
                ptopalistmap.put(pa.Project__c, paList);
                patopllistmap.put(pa.Id, ptopllistmap.get(pa.Project__c));
            }
        }
        
        
        List<OpportunityLineItem> olList = [Select Id, Opportunity.NumberOfLocations__c, OpportunityId, 
                                            UnitPrice, TotalPrice, Service__c, 
                      Service__r.Name, Product2.PreBillPercent__c, AccrualAmount__c 
                      FROM OpportunityLineItem 
                      WHERE OpportunityId IN :opportunityids and Product2.Billable__c = true and 
                      Product2.BillType__c = :Constants.PRODUCT_BILLTYPE_USAGE];

		for (OpportunityLineItem oli : olList)        
        {
            
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            oliList.add(oli);                
            if (otoolilistmap.get(oli.OpportunityId) != null)
            {
                oliList.addall(otoolilistmap.get(oli.OpportunityId));
            }
            otoolilistmap.put(oli.OpportunityId, oliList);
        }
        
        
        List<ProjectInvoice__c> pis = [SELECT Id, Name, ProjectAccount__c FROM ProjectInvoice__c 
                                       WHERE Project__c IN :projectids AND 
                                       Status__c = :CONSTANTS.PROJECT_INVOICE_STATUS_CREATED AND
                                       Type__c = :CONSTANTS.PROJECT_INVOICE_TYPE_POSTEXECUTION];
        if (!pis.isEmpty())
        {
            for (ProjectInvoice__c pi : pis)
            {
                patopimap.put(pi.ProjectAccount__c, pi);
            }
        }

        
        //Check if there's already a Project Invoice that can be used
        for (ProjectAccount__c pa : pas)
        {
            //If project invoice already exists, then continue
            if (patopimap.get(pa.Id) != null)
                continue;
            
            //Check if the project account has an oppli that
            //requires a project invoice to be created
            //If no product in oppli that is of billtype usage
            
            if (otoolilistmap.get(pa.Opportunity__c) == null)
                continue;
            
            ProjectInvoice__c pi = new ProjectInvoice__c();
            pi.Project__c = pa.Project__c;
            pi.Status__c = Constants.PROJECT_INVOICE_STATUS_CREATED;
            pi.Type__c = Constants.PROJECT_INVOICE_TYPE_POSTEXECUTION;
            pi.LawsonProcessType__c = Constants.LAWSON_PROCESS_TYPE_PE;
            pi.Account__c = pa.Account__c;
            pi.ProjectAccount__c = pa.Id;
            newpis.add(pi);                        
            
        }
        //Insert all the new project invoices
        insert newpis;
        
		newpis = [SELECT Id, Name, ProjectAccount__c, ProjectAccount__r.Opportunity__c FROM ProjectInvoice__c 
                                       WHERE Id IN :newpis];        

        //Create a Invoice Line Item for all the newly created project invoices.
        //Create a line item for every product
        for (ProjectInvoice__c newpi : newpis)
        {
            List<OpportunityLineItem> opplis = otoolilistmap.get(newpi.ProjectAccount__r.Opportunity__c);
            for (OpportunityLineItem oppli : opplis)
            {
                ProjectInvoiceLineItem__c pili = new ProjectInvoiceLineItem__c();
                pili.ProjectInvoice__c = newpi.Id;
                pili.Type__c = Constants.PROJECT_INVOICE_LINEITEM_TYPE_USAGE;
            	pili.ServiceType__c = Constants.PROJECT_INVOICE_LINEITEM_SERVICETYPE_LABOR;
                pili.Product__c = oppli.Product2Id;
                pili.Amount__c = 0;
                pili.Rate__c = oppli.UnitPrice;
                pili.AccrualAmount__c = oppli.AccrualAmount__c;
                newpilis.add(pili);                
            }
        }
        
        Insert newpilis;
        
        List<ProjectInvoiceLineItem__c> piliLaborList = [SELECT Id, name, ProjectInvoice__c, ProjectInvoice__r.ProjectAccount__c, Rate__c,
                                                         Amount__c
                                                         FROM ProjectInvoiceLineItem__c 
                                                         WHERE ProjectInvoice__r.ProjectAccount__c in :projectaccountids 
                                                   		 AND ServiceType__c = :Constants.PROJECT_INVOICE_LINEITEM_SERVICETYPE_LABOR
                                                         AND ProjectInvoice__r.Status__c = :Constants.PROJECT_INVOICE_STATUS_CREATED];
        
        for (ProjectInvoiceLineItem__c laborpilineitem: piliLaborList)
        {
        	List<ProjectLocation__c> pllist = new List<ProjectLocation__c>();
            String projectaccount = laborpilineitem.ProjectInvoice__r.ProjectAccount__c;
            if (patopllistmap.get(projectaccount) != null) 
                pllist = patopllistmap.get(projectaccount);
            
            for (ProjectLocation__c pl : pllist)
            {
                ProjectInvoiceLineItemDetail__c pilid = new ProjectInvoiceLineItemDetail__c();
                pilid.ProjectInvoiceLineItem__c = laborpilineitem.Id;
                pilid.ProjectLocation__c = pl.Id;
                pilid.Rate__c = laborpilineitem.Rate__c;
                pilid.LaborTaxLawsonID__c = pl.Location__r.LaborTaxLawsonID__c;
                pilid.LaborTaxRate__c = pl.Location__r.LaborTaxRate__c;
                pilidetaillist.add(pilid);
                invoicedpls.add(pl.Id);
            }            
            
        }
        
        //Set the project locations to invoiced
        for (ProjectLocation__c pl : scope)
        {
			if (invoicedpls.contains(pl.Id))
                pl.Invoiced__c = true;
        }
        
        insert pilidetaillist;        
        update scope;
        
    }

   	global void finish(Database.BatchableContext BC) {
    
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];    
        
        if (a.NumberOfErrors == 0)
        {
	        system.debug('BatchProcessLaborInvoice Finished');
        }
   }    
}