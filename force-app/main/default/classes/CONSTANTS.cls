global without sharing class CONSTANTS {
    public static final String CURRENTNAMESPACE = CONSTANTS.class.getName().substringBefore('CONSTANTS').removeEnd('.');
    public static final String CURRENTNAMESPACEPREFIX = (String.isEmpty(CURRENTNAMESPACE)) ? '' : CURRENTNAMESPACE + '__';

    public static final String PROJECT_STATUS_PLANNING;
    public static final String PROJECT_STATUS_PENDING;
    public static final String PROJECT_STATUS_BOOKED;
    public static final String PROJECT_STATUS_LAUNCHED;
    public static final String PROJECT_STATUS_INPROGRESS;
    public static final String PROJECT_STATUS_ENDED;
    public static final String PROJECT_STATUS_CLOSED;
    public static final String PROJECT_STATUS_CANCELED;

    public static final String PROJECT_SERVICE_STATUS_CANCELED;

    public static final String PROJECT_LOCATION_JOBSCREATED;
    public static final String PROJECT_LOCATION_CANCELED;
    public static final String PROJECT_LOCATION_FAILED;

    public static final String PROJECT_SERVICE_CANCELED;

    public static final String SCHEDULE_OPTION_EC;
    public static final String SCHEDULE_OPTION_SYSTEM;
    public static final String SCHEDULE_OPTION_USER;

    public static final String RESPONSIBLE_FOR_EXECUTION_EXECUTIONCOMPANY;

    public static final String JOB_MANUAL_CUSTOM_TEMPLATE ;
    public static final String JOB_MANUAL_STANDARD_TEMPLATE;
    public static final String JOB_NOMANUAL_TEMPLATE;
    
    public static final String JOB_STATUS_PENDING;
    public static final String JOB_STATUS_OPEN;
    public static final String JOB_STATUS_ASSIGNED;
    public static final String JOB_STATUS_STARTED;
    public static final String JOB_STATUS_REPORTED;
    public static final String JOB_STATUS_CLOSED;
    public static final String JOB_STATUS_CANCELED;
    
    
    public static final String RESERVATION_STATUS_DRAFT;
    public static final String RESERVATION_STATUS_RESERVED;
    public static final String RESERVATION_STATUS_EXPIRED;
    public static final String RESERVATION_STATUS_CANCELED;    
    public static final String RESERVATION_REQUESTSTATUS_PENDINGRESERVATION;
    public static final String RESERVATION_REQUESTSTATUS_PENDINGCANCELLATION;
    public static final String RESERVATION_REQUESTSTATUS_PENDINGEXPIRATION;
    
    public static final String RESERVATIONLOCATION_STATUS_PENDINGRESERVATION;
    public static final String RESERVATIONLOCATION_STATUS_PENDINGCANCELLATION;
    public static final String RESERVATIONLOCATION_STATUS_PENDINGEXPIRATION;

    public static final String RESERVATIONLOCATION_STATUS_RESERVED;
    public static final String RESERVATIONLOCATION_STATUS_EXPIRED;
    public static final String RESERVATIONLOCATION_STATUS_FAILED;
    public static final String RESERVATIONLOCATION_STATUS_CANCELED;    
    
    
    

    public static final String JOB_COMPLETION_STATUS_COMPLETED;
    public static final String JOB_COMPLETION_STATUS_NOT_COMPLETED;



    public static final String JOB_ATTEMPT_STATUS_OPEN;
    public static final String JOB_ATTEMPT_STATUS_ASSIGNED;
    public static final String JOB_ATTEMPT_STATUS_STARTED;
    public static final String JOB_ATTEMPT_STATUS_REPORTED;
    public static final String JOB_ATTEMPT_STATUS_CANCELED;
    public static final String JOB_ATTEMPT_STATUS_CLOSED;
    public static final String JOB_ATTEMPT_TYPE_ORIGINAL;
    public static final String JOB_ATTEMPT_TYPE_REATTEMPT;
    
    
    public static final String JOB_ATTEMPT_WORKER_STATUS_OPEN;
    public static final String JOB_ATTEMPT_WORKER_STATUS_ASSIGNED;
    public static final String JOB_ATTEMPT_WORKER_STATUS_CANCELED;
    public static final String JOB_ATTEMPT_WORKER_STATUS_CHECKED_IN;
    public static final String JOB_ATTEMPT_WORKER_STATUS_CHECKED_OUT;
    public static final String JOB_ATTEMPT_WORKER_STATUS_NO_SHOW;
    
    public static final String JOB_ATTEMPT_WORKER_WORKER_TYPE_TEAM_LEAD;
    public static final String JOB_ATTEMPT_WORKER_WORKER_TYPE_TEAM_MEMBER;
    
    public static final String JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_CHECK_IN;
    public static final String JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_CHECK_OUT;
	public static final String JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_LUNCH;
    public static final String JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_BREAK;

    public static final String EQUIPMENT_ASSET;
    public static final String EQUIPMENT_TOOL;

    public static final String ATTRIBUTE_TEXT;
    public static final String ATTRIBUTE_DATE;
    public static final String ATTRIBUTE_YESNO;
    public static final String ATTRIBUTE_NUMBER;
    public static final String ATTRIBUTE_SINGLE_SELECT;
    public static final String ATTRIBUTE_MULTI_SELECT;
    public static final String ATTRIBUTE_PHOTO;
    public static final String ATTRIBUTE_FILE;


    public static final String QUESTIONTYPE_TEXT;
    public static final String QUESTIONTYPE_DATE;
    public static final String QUESTIONTYPE_YESNO;
    public static final String QUESTIONTYPE_NUMBER;
    public static final String QUESTIONTYPE_SINGLE_SELECT;
    public static final String QUESTIONTYPE_MULTI_SELECT;
    public static final String QUESTIONTYPE_PHOTO;
    public static final String QUESTIONTYPE_FILE;
	public static final String QUESTIONTYPE_TARGET_GROUP;
    
    public static final string QUESTIONJUMP_ENDOFSURVEY;
    public static final string QUESTIONJUMP_NEXTTARGET;
    public static final string QUESTIONJUMP_QUESTION;
    public static final string QUESTIONJUMP_RETURN;
    public static final string QUESTIONJUMP_BRANCH;
    public static final string QUESTIONJUMP_CONTINUE;



    public static final String ARCHIVE_STATUS_ARCHIVED;
    public static final String ARCHIVE_STATUS_PENDING;
    public static final String ARCHIVE_STATUS_COMPLETE;

    public static final String RESPONSE_STATE_SUCCESS;
    public static final String RESPONSE_STATE_ERROR;
    public static final String RESPONSE_STATE_WARNING;

    public static final String CLONE_STATUS_STRATED;
    public static final String CLONE_STATUS_COMPLETE;

    public static final String PROJECT_ACCOUNT_SERVICE_ACCESS_LEVEL_FULL_ACCESS;
    public static final String PROJECT_ACCOUNT_SERVICE_ACCESS_LEVEL_NO_ACCESS;        
    
    public static final String MANUAL;
    
    public static final String APEX_RULE_TYPE_RESERVATION;    
    
    public static final String PRODUCT_BILLTYPE_USAGE;
    public static final String PRODUCT_BILLTYPE_LUMPSUM;
    
    public static final String BILLING_STATUS_BILLABLE;
    public static final String BILLING_STATUS_NEEDSREVIEW;
    public static final String BILLING_STATUS_NOTBILLABLE;
    public static final String BILLING_STATUS_NONBILLABLE;
    public static final String BILLING_STATUS_DISPUTED;
    
    
    public static final String PROJECT_INVOICE_STATUS_CREATED;
    public static final String PROJECT_INVOICE_STATUS_PROCESSING;
    public static final String PROJECT_INVOICE_STATUS_INVOICED;
    public static final String PROJECT_INVOICE_STATUS_PAID;
    public static final String PROJECT_INVOICE_STATUS_CANCELED;

    public static final String PROJECT_INVOICE_TYPE_PREBILL;
    public static final String PROJECT_INVOICE_TYPE_POSTEXECUTION;
    public static final String PROJECT_INVOICE_TYPE_RECONCILE;
    public static final String PROJECT_INVOICE_TYPE_UNRECONCILED;
    
    public static final String LAWSON_PROCESS_TYPE_PB;
    public static final String LAWSON_PROCESS_TYPE_PE;
    
    
    public static final String PROJECT_INVOICE_LINEITEM_TYPE_LUMPSUM;
    public static final String PROJECT_INVOICE_LINEITEM_TYPE_USAGE;
    
    public static final String PROJECT_INVOICE_LINEITEM_SERVICETYPE_LABOR;
    public static final String PROJECT_INVOICE_LINEITEM_SERVICETYPE_PRODUCT;
    public static final String PROJECT_INVOICE_LINEITEM_SERVICETYPE_SALESTAX;
    public static final String PROJECT_INVOICE_LINEITEM_SERVICETYPE_UNRECONCILED;
    
    public static final String ENTITY_CHANGELOG_STATUS_RELEASED;
    
    
    static {
        String orgInstace = AppUtil.getOrgInstance();
        if (orgInstace == 'ONEHUB' || orgInstace == 'WALGREENS' || orgInstace == 'SEG') {
            PROJECT_STATUS_PLANNING = 'Planning';
            PROJECT_STATUS_PENDING = 'Pending';
            PROJECT_STATUS_BOOKED = 'Booked';
            PROJECT_STATUS_LAUNCHED = 'Launched';
            PROJECT_STATUS_INPROGRESS = 'In Progress';
            PROJECT_STATUS_ENDED = 'Ended';
            PROJECT_STATUS_CLOSED = 'Closed';
            PROJECT_STATUS_CANCELED = 'Canceled';

            PROJECT_SERVICE_STATUS_CANCELED = 'Canceled';

            PROJECT_LOCATION_JOBSCREATED = 'Jobs Created';
            PROJECT_LOCATION_CANCELED = 'Canceled';
            PROJECT_LOCATION_FAILED = 'Failed';

            PROJECT_SERVICE_CANCELED = 'Canceled';

            JOB_STATUS_PENDING = 'Pending';
            JOB_STATUS_OPEN = 'Open';
            JOB_STATUS_ASSIGNED = 'Assigned';
            JOB_STATUS_STARTED = 'Started';
            JOB_STATUS_REPORTED = 'Reported';
            JOB_STATUS_CLOSED = 'Closed';
            JOB_STATUS_CANCELED = 'Canceled';

            JOB_COMPLETION_STATUS_COMPLETED = 'Completed';
            JOB_COMPLETION_STATUS_NOT_COMPLETED = 'Not Completed';

            JOB_ATTEMPT_TYPE_ORIGINAL = 'ORIGINAL';
            JOB_ATTEMPT_TYPE_REATTEMPT = 'RE-ATTEMPT';

            JOB_ATTEMPT_STATUS_OPEN = 'Open';
            JOB_ATTEMPT_STATUS_ASSIGNED = 'Assigned';
            JOB_ATTEMPT_STATUS_STARTED = 'Started';
            JOB_ATTEMPT_STATUS_REPORTED = 'Reported';
            JOB_ATTEMPT_STATUS_CANCELED = 'Canceled';
            JOB_ATTEMPT_STATUS_CLOSED = 'Closed';
                
    		JOB_ATTEMPT_WORKER_STATUS_OPEN = 'Open';
    		JOB_ATTEMPT_WORKER_STATUS_ASSIGNED = 'Assigned';
    		JOB_ATTEMPT_WORKER_STATUS_CANCELED = 'Canceled';
    		JOB_ATTEMPT_WORKER_STATUS_CHECKED_IN = 'Checked In';
    		JOB_ATTEMPT_WORKER_STATUS_CHECKED_OUT = 'Checked Out';
    		JOB_ATTEMPT_WORKER_STATUS_NO_SHOW = 'No Show';
            
		 	JOB_ATTEMPT_WORKER_WORKER_TYPE_TEAM_LEAD = 'Team Lead';
    		JOB_ATTEMPT_WORKER_WORKER_TYPE_TEAM_MEMBER = 'Team Member';            
                
    		JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_CHECK_IN  = 'Check In';
    		JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_CHECK_OUT  = 'Check out';
			JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_LUNCH = 'Lunch';
    		JOB_ATTEMPT_WORKER_TIME_ENTRY_TIME_ENTRY_TYPE_BREAK = 'Break';            
            
            SCHEDULE_OPTION_USER = 'USER';
            SCHEDULE_OPTION_SYSTEM = 'SYSTEM';
            SCHEDULE_OPTION_EC = 'EC';

            EQUIPMENT_ASSET = 'Asset';
            EQUIPMENT_TOOL = 'Tool';

            ATTRIBUTE_TEXT = 'Text';
            ATTRIBUTE_DATE = 'Date';
            ATTRIBUTE_YESNO = 'Yes/No';
            ATTRIBUTE_NUMBER = 'Number';
            ATTRIBUTE_SINGLE_SELECT = 'Single-Select List';
            ATTRIBUTE_MULTI_SELECT = 'Multi-Select List';
            ATTRIBUTE_PHOTO = 'Photo';
            ATTRIBUTE_FILE = 'File';

            QUESTIONTYPE_TEXT = 'Text';
            QUESTIONTYPE_DATE = 'Date';
            QUESTIONTYPE_YESNO = 'Yes/No';
            QUESTIONTYPE_NUMBER = 'Number';
            QUESTIONTYPE_SINGLE_SELECT = 'Single-Select List';
            QUESTIONTYPE_MULTI_SELECT = 'Multi-Select List';
            QUESTIONTYPE_PHOTO = 'Photo';
            QUESTIONTYPE_FILE = 'File';
			QUESTIONTYPE_TARGET_GROUP = 'Target Group';
            
            QUESTIONJUMP_ENDOFSURVEY = 'ENDOFSURVEY';
            QUESTIONJUMP_NEXTTARGET = 'NEXTTARGET';
            QUESTIONJUMP_QUESTION = 'QUESTION';
            QUESTIONJUMP_RETURN = 'RETURN';
            QUESTIONJUMP_BRANCH = 'BRANCH';
            QUESTIONJUMP_CONTINUE = 'CONTINUE';
            
            RESERVATION_STATUS_DRAFT = 'Draft';
            RESERVATION_STATUS_RESERVED = 'Reserved';
            RESERVATION_STATUS_EXPIRED = 'Expired';
            RESERVATION_STATUS_CANCELED = 'Canceled';    
            RESERVATION_REQUESTSTATUS_PENDINGCANCELLATION = 'Pending Cancellation';    
            RESERVATION_REQUESTSTATUS_PENDINGRESERVATION = 'Pending Reservation';    
            RESERVATION_REQUESTSTATUS_PENDINGEXPIRATION = 'Pending Expiration';    
    

            RESERVATIONLOCATION_STATUS_PENDINGRESERVATION = 'Pending Reservation';
            RESERVATIONLOCATION_STATUS_PENDINGCANCELLATION = 'Pending Cancellation';
            RESERVATIONLOCATION_STATUS_PENDINGEXPIRATION = 'Pending Expiration';
			RESERVATIONLOCATION_STATUS_RESERVED = 'Reserved';
			RESERVATIONLOCATION_STATUS_EXPIRED = 'Expired';
            RESERVATIONLOCATION_STATUS_FAILED = 'Failed';
            RESERVATIONLOCATION_STATUS_CANCELED = 'Canceled';


            //JOB_MANUAL_CUSTOM_TEMPLATE = 'Custom Template';
            //Manual
            JOB_MANUAL_CUSTOM_TEMPLATE = 'Custom Manual';
            JOB_MANUAL_STANDARD_TEMPLATE = 'Standard';
            JOB_NOMANUAL_TEMPLATE ='No Manual';
            RESPONSIBLE_FOR_EXECUTION_EXECUTIONCOMPANY = 'Execution Company';

            ARCHIVE_STATUS_ARCHIVED = 'Archived';
            ARCHIVE_STATUS_PENDING = 'Pending';
            ARCHIVE_STATUS_COMPLETE = 'Complete';

            RESPONSE_STATE_SUCCESS = 'SUCCESS';
            RESPONSE_STATE_ERROR = 'ERROR';
            RESPONSE_STATE_WARNING = 'WARNING';
            MANUAL = 'Job Manual';

            CLONE_STATUS_STRATED = 'Started';
            CLONE_STATUS_COMPLETE = 'Complete';
                        
    		PROJECT_ACCOUNT_SERVICE_ACCESS_LEVEL_FULL_ACCESS = 'Full Access';
    		PROJECT_ACCOUNT_SERVICE_ACCESS_LEVEL_NO_ACCESS = 'No Access';    
            
            APEX_RULE_TYPE_RESERVATION = 'Reservation';
            
            PROJECT_INVOICE_STATUS_CREATED = 'Created';
            PROJECT_INVOICE_STATUS_PROCESSING = 'Processing';
            PROJECT_INVOICE_STATUS_INVOICED = 'Invoiced';
            PROJECT_INVOICE_STATUS_PAID = 'Paid';
            PROJECT_INVOICE_STATUS_CANCELED = 'Canceled';

            PROJECT_INVOICE_TYPE_PREBILL = 'PreBill';
            PROJECT_INVOICE_TYPE_POSTEXECUTION = 'PostExecution';
			PROJECT_INVOICE_TYPE_RECONCILE = 'Reconcile';
            PROJECT_INVOICE_TYPE_UNRECONCILED = 'Unreconciled';
            
            LAWSON_PROCESS_TYPE_PB = 'PB';
            LAWSON_PROCESS_TYPE_PE = 'PE';

            
    		PROJECT_INVOICE_LINEITEM_TYPE_LUMPSUM = 'LumpSum';
            PROJECT_INVOICE_LINEITEM_TYPE_USAGE = 'Usage';

            PROJECT_INVOICE_LINEITEM_SERVICETYPE_LABOR = 'Labor';
            PROJECT_INVOICE_LINEITEM_SERVICETYPE_PRODUCT = 'Product';
            PROJECT_INVOICE_LINEITEM_SERVICETYPE_SALESTAX = 'SalesTax';
            PROJECT_INVOICE_LINEITEM_SERVICETYPE_UNRECONCILED = 'Unreconciled';
            
           	PRODUCT_BILLTYPE_USAGE = 'Usage';
    	   	PRODUCT_BILLTYPE_LUMPSUM = 'Lumpsum';
            
            BILLING_STATUS_BILLABLE = 'Billable';
            BILLING_STATUS_NONBILLABLE = 'NonBillable';
            BILLING_STATUS_NEEDSREVIEW = 'NeedsReview';
            BILLING_STATUS_NOTBILLABLE = 'NotBillable';
            BILLING_STATUS_DISPUTED = 'Disputed';
            
			ENTITY_CHANGELOG_STATUS_RELEASED = 'Released';

        }
    }

}