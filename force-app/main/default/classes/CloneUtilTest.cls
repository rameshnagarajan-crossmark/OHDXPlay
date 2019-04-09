@isTest
public class CloneUtilTest {

    @testSetup static void setup() {
        TestDataUtil.init();
        TestProject tP = TestProject.create('demo');
        tP.addAccount()
        .addServices(2)
        .addLocations(50);
       add100ServiceToProject(tP.getInstance());
    }

    static void add100ServiceToProject(Project__c project) {
        TestDataUtil.disableTriggers();
        //step1 create 100 service
        List<String> names = new List<String>();
        for (Integer i = 0; i < 200; i++) {
            names.add('name' + String.valueOf(i));
        }

        List<Service__c> rs = TestDataUtil.initServicesByNames(names);

        //step2 add to retailer service
        Retailer__c retailer = [select id from Retailer__c limit 1];
        TestDataUtil.initRetailerServicesByServiceList(retailer, rs);
        List<RetailerService__c> retailerServices = [SELECT Id,Service__r.Name, Service__c,Retailer__c FROM RetailerService__c];

        //step3 add to project services
        List<ProjectService__c> psList = new List<ProjectService__c>();

        for (RetailerService__c service : retailerServices) {
            ProjectService__c ps = new ProjectService__c(
                Project__c = project.Id,
                Service__c = service.Service__c,
                ServiceTitle__c = service.Service__r.Name,
                TargetType__c = 'Brand',
                JobManual__c = 'Standard',
                NumberOfWorkers__c = 1,
                OneHubRetailerId__c = 'OH' + String.valueOf(service.Retailer__c)
            );
            psList.add(ps);
        }
        TestDataUtil.enableTriggers();
        insert psList;
    }

    static Integer getProjectServiceCount(string projectId){
        List<AggregateResult> results = [Select Count(Id) total FROM ProjectService__c
         WHERE Project__c=:projectId];
         return Integer.valueOf(results.get(0).get('total'));
    }

    static Integer getProjectLocationCount(string projectId){
        list<AggregateResult> results = [SELECT Count(Id) total FROM ProjectLocation__c 
        WHERE Project__c=:projectId];
        return Integer.valueOf(results.get(0).get('total'));
    }

    @istest static void itShouldCloneMoreThan100Services() {
        //GIVEN
        Project__c p = [SELECT Id from Project__c WHERE Name = 'demo' LIMIT 1];
        Integer expectedProjectServiceCount = getProjectServiceCount(p.Id);
        integer expectedProjectLocationCount = getProjectLocationCount(p.Id);

        //WHEN
        test.startTest();
        CloneUtil.CloneAll(p.Id);
        test.stopTest();

        //THEN
        List<Project__c> cPList = [SELECT Id from Project__c WHERE Name = 'Clone - demo'];
        QA.isTrue(cPList.size() > 0, 'Cloned project created');

        Integer resultProjectServiceCount = getProjectServiceCount(cPList[0].Id);
        QA.EQ(expectedProjectServiceCount, resultProjectServiceCount, 'The same number of project services created.' + resultProjectServiceCount);
        integer resultProjectLocationCount = getProjectLocationCount(p.Id);
        QA.EQ(expectedProjectLocationCount, resultProjectLocationCount, 'The same number of project locations created.' + resultProjectLocationCount);
    }

}