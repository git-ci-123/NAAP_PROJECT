--liquibase formatted sql
--changeset Swetha.H:CRPT_DDL_02 
--preconditions onFail:HALT onError:HALT


  CREATE TABLE ACCOUNT_DETAILS
(
ACCOUNT_ID                         NUMBER       NOT NULL, 
ACCOUNT_NAME                       VARCHAR2(200) ,
CUSTOMER_NAME                      VARCHAR2(200) ,
CUSTOMER_TYPE                      VARCHAR2(200) ,
ACCOUNT_ACTIVATION_DATE            TIMESTAMP(6)  ,
ACCOUNT_DEACTIVATION_DATE          TIMESTAMP(6)  ,
STATUS                             VARCHAR2(200) ,
DESCRIPTION                        VARCHAR2(200) ,
BILLING_ACCOUNT_NUMBER             NUMBER        ,
BILL_CYCLE_NAME                    VARCHAR2(200) ,
ESTABLISHED_DATE                   TIMESTAMP(6)  ,
EXTERNAL_SOURCE                    VARCHAR2(200) ,
EXTRENAL_REFERENCE_ID              NUMBER        ,
CUSTOMER_ID                        NUMBER        ,
CREATED_DATE                       TIMESTAMP(6)  ,
CREATED_BY                         VARCHAR2(100) ,
MODIFIED_DATE                      TIMESTAMP(6)  ,
MODIFIED_BY                        VARCHAR2(100) 
);



CREATE TABLE CONTRACT_PERFORMANCE_DETAILS 
   (	CONTRACT_VEHICLE VARCHAR2(128), 
	CONTRACT_TYPE VARCHAR2(26), 
	CONTRACT_NAME VARCHAR2(128), 
	CUSTOMER_NAME VARCHAR2(26), 
	LOCATION_NAME VARCHAR2(128), 
	CONTRACT_START DATE, 
	CONTRACT_END DATE, 
	ADDRESS_LINE_1 VARCHAR2(128), 
	ADDRESS_LINE_2 VARCHAR2(26), 
	CITY VARCHAR2(26), 
	STATE VARCHAR2(26), 
	REGION VARCHAR2(26), 
	COUNTRY VARCHAR2(26), 
	ZIP VARCHAR2(26), 
	PRODUCTS_ASSOCIATED_ VARCHAR2(26), 
	NO_OF_PRODUCTS NUMBER(38,0), 
	ON_NET_ VARCHAR2(26), 
	SURVEY VARCHAR2(26), 
	SERVICE_FULLFILLMENT_THROUGH_PARTNERS VARCHAR2(26), 
	STATUS VARCHAR2(26), 
	REVENUE NUMBER(38,0), 
	ROI VARCHAR2(26), 
	PARENT VARCHAR2(26), 
	PARENT_CONTRACT VARCHAR2(128), 
	CONTRACT_ACCEPTANCE VARCHAR2(26), 
	ORDER_ACCEPTANCE VARCHAR2(26), 
	SLA_TYPE VARCHAR2(128), 
	NO_OF_SLA_TYPES NUMBER(38,0), 
	SLA_UNIT NUMBER(38,0), 
	PAYMENT__TERMS VARCHAR2(26), 
	PAYMENT_TYPE VARCHAR2(26), 
	PAYMENT_ADDRESS VARCHAR2(128), 
	INVOICE_ADDRESS VARCHAR2(128), 
	PAYMENT_DATE DATE, 
	CONTRACT_END_DATE DATE, 
	RENEW VARCHAR2(26), 
	DISCONNECT_EXPIRY VARCHAR2(26), 
	PERCENTAGE_INCREASE_AFTER_RENEWAL NUMBER(38,0), 
	RENEWAL_REMINDER_ VARCHAR2(26), 
	DUE_DATE_FOR_RENEWAL DATE, 
	CONTRACT_APPROVAL_DATE DATE, 
	SR_CREATED_DATE DATE, 
	DIGITALLY_SIGNED VARCHAR2(26), 
	SIGNED_DATE DATE, 
	SPEND_BY_CATEGORY VARCHAR2(26)
   ) ;

CREATE TABLE CUSTOMER_DETAILS
(
CUSTOMER_ID                NUMBER         NOT NULL,
CUSTOMER_NAME              VARCHAR2(200) ,
CUSTOMER_TYPE              VARCHAR2(200) ,
STATUS                     VARCHAR2(200) ,
DESCRIPTION                VARCHAR2(200) ,
CUSTOMER_CATEGORY          VARCHAR2(200) ,
SERVICE_LEVEL              VARCHAR2(200) ,
CUSTOMER_BRAND             VARCHAR2(200) ,
MARKET_VERTICAL            VARCHAR2(200) ,
EXTERNAL_SOURCE            VARCHAR2(200) ,
TAX_EXEMPT                 VARCHAR2(200) ,
CREATED_DATE               TIMESTAMP(6)  ,
CREATED_BY                 VARCHAR2(100) ,
MODIFIED_DATE              TIMESTAMP(6)  ,
MODIFIED_BY                VARCHAR2(100) 
);
  
CREATE TABLE FILETABLE 
   (	SNO VARCHAR2(3000), 
	FIRST_NAME VARCHAR2(3000), 
	LAST_NAME VARCHAR2(3000), 
	GENDER VARCHAR2(3000), 
	COUNTRY VARCHAR2(3000), 
	AGE VARCHAR2(3000), 
	"DATE" VARCHAR2(3000), 
	ID VARCHAR2(3000)
   ) ;

create table REF_STATUS (
REF_STAT_ID            NUMBER       NOT NULL , 
REF_STAT_NAME          VARCHAR2(30)  ,
DEFAULT_FLAG           CHAR(1)       ,
STAT_DESC              VARCHAR2(500) ,
CREATED_BY             VARCHAR2(100) ,
CREATED_DATE           TIMESTAMP(6)  ,
MODIFIED_BY            VARCHAR2(100) ,
MODIFIED_DATE          TIMESTAMP(6)  ,
CREATED_ON             TIMESTAMP(6)  ,
COLOR_NAME             VARCHAR2(100) ,
COLOR_CODE             VARCHAR2(100) 
);

CREATE TABLE CALENDER 
   (	
    ORGANIZATION_ID            NUMBER  ,      
    CALENDAR_TYPE_ID           NUMBER   ,     
    ORG_CALENDAR_DATE          TIMESTAMP(6)   NOT NULL,
    DESCRIPTION                VARCHAR2(100) ,
    CREATED_BY                 VARCHAR2(50)  ,
    CREATED_DATE               TIMESTAMP(6)  ,
    MODIFIED_BY                VARCHAR2(50)  ,
    MODIFIED_DATE              TIMESTAMP(6)  
   );


CREATE TABLE PROJECT_DETAILS
(
PROJECT_ID                   NUMBER        NOT NULL,
PROJECT_NAME                 VARCHAR2(500) ,
PROJECT_TYPE                 VARCHAR2(500) ,
STATUS                       VARCHAR2(500) ,
PROJECT_SCOPE                VARCHAR2(500) ,
PROJECT_MANAGER              VARCHAR2(500) ,
PROJECT_START_DATE           TIMESTAMP(6)  ,
PROJECT_END_DATE             TIMESTAMP(6)  ,
PLAN_START_DATE              TIMESTAMP(6)  ,
ACTUAL_END_DATE              TIMESTAMP(6)  ,
PRIORITY                     VARCHAR2(500) ,
PROJECT_DESCRIPTION          VARCHAR2(500) ,
SALES_ORDER_ID               NUMBER        ,
PROJECT_COMPLETION           NUMBER        
);

CREATE TABLE SALES_ORDER_DETAILS
(
SALES_ORDER_ID                  NUMBER         NOT NULL,
CUSTOMER_NAME                   VARCHAR2(500)  ,
BILLING_ACCOUNT_NUMBER          NUMBER         ,
ACTIVITY_TYPE                   VARCHAR2(500)  ,
DATE_RECEIVED                   TIMESTAMP(6)   ,
DESIRED_DUE_DATE                TIMESTAMP(6)   ,
REQUESTED_END_DATE              TIMESTAMP(6)   ,
FORECASTED_DUE_DATE             TIMESTAMP(6)   ,
CATEGORY_TYPE                   VARCHAR2(100)  ,
ORDER_CHANNEL                   VARCHAR2(100)  ,
TOTAL_MRC                       VARCHAR2(100)  ,
TOTAL_NRC                       VARCHAR2(100)  ,
SOW_ID                          NUMBER         ,
MARKET_OFFERING_ID              NUMBER         ,
SALES_ORDER_STATUS              VARCHAR2(100)  ,
REVENUE                         NVARCHAR2(100) ,
CONTRACT_ID                     NUMBER         ,
STATUS                          VARCHAR2(100)  ,
ROLE                            VARCHAR2(100)  ,
CATEGORY                        VARCHAR2(200)  
);

CREATE TABLE MARKET_OFFERING_DETAILS
(
MARKET_OFFERING_ID            NUMBER        NOT NULL,
MARKET_OFFERING_NAME          VARCHAR2(100) ,
PRICE_PLAN                    VARCHAR2(100) ,
TERMS                         VARCHAR2(100) ,
ITEM_NAME                     VARCHAR2(100) ,
SPECIAL_ITEM_NUMBER           NUMBER        ,
NRC                           VARCHAR2(100) ,
MRC                           VARCHAR2(100) ,
TOTAL_NRC                     VARCHAR2(100) ,
TOTAL_MRC                     VARCHAR2(100) ,
DESIGN_ID                     NUMBER        ,
CREATED_DATE                  TIMESTAMP(6)  ,
CREATED_BY                    VARCHAR2(100) ,
MODIFIED_DATE                 TIMESTAMP(6)  ,
MODIFIED_BY                   VARCHAR2(100) ,
SALES_ORDER_ID                NUMBER        ,
PRODUCT_ORDER_ID              NUMBER        ,
SERVICE_ID                    NUMBER        ,
EXTERNAL_CATALOG_ID           VARCHAR2(200) 
);

CREATE TABLE SERVICE_DETAILS
(
ID                               NUMBER        NOT NULL ,  
SERVICE                          VARCHAR2(250)  ,
SERVICE_DESCRIPTION              VARCHAR2(2500) ,
SERVICE_STARTDATE                DATE           ,
SERVICE_ENDDATE                  DATE           ,
SERVICE_VERSION                  NUMBER         ,
SERVICE_SF_ID                    NUMBER         ,
SERVICE_ST_ID                    NUMBER         ,
SERVICE_GRANDFATHERED            CHAR(3)        ,
SERVICE_QUANTIFIABLE             CHAR(3)        ,
SERVICE_PROD_STATUS              CHAR(1)        ,
SERVICE_PROD_DATE                DATE           ,
SERVICE_TEMPLATE_STATUS          CHAR(1)        ,
STATUS                           VARCHAR2(100)  ,
SERVICE_CREATEDON                DATE           ,
SERVICE_CREATEDBY                VARCHAR2(100)  ,
SERVICE_MODIFIEDON               DATE           ,
SERVICE_MODIFIEDBY               VARCHAR2(100)  ,
SERVICE_CATALOG_ID               VARCHAR2(400)  ,
SERVICE_DISPLAY_NAME             VARCHAR2(250)  ,
SERVICE_PROD_VERSION             NUMBER         ,
SERVICE_ALPHA_CODE               VARCHAR2(50)   ,
DET_TYPE                         VARCHAR2(1000) ,
SERVICE_TOWNLEVEL                VARCHAR2(4000) ,
SERVICE_FEATURE                  VARCHAR2(1)    ,
IMAGE_URL                        VARCHAR2(4000) ,
VERSION_ID                       NUMBER         ,
ENTITY_TYPE_ID                   NUMBER         ,
GLOBAL_YN                        CHAR(1)        ,
DISPLAY_INFORMATION              VARCHAR2(250)  ,
LIFECYCLE_ID                     NUMBER         ,
VERSION                          NUMBER         ,
CREATED_DATE                     TIMESTAMP(6)   ,
CREATED_BY                       VARCHAR2(100)  ,
MODIFIED_DATE                    TIMESTAMP(6)   ,
MODIFIED_BY                      VARCHAR2(100)  ,
QUANTITY                         NUMBER         ,
MRC                              VARCHAR2(250)  ,
TOTAL_MRC                        VARCHAR2(250)  ,
MARKET_OFFERING_ID               NUMBER         ,
LOCATION_ID                      NUMBER         ,
TERMINATION_CHARGE               VARCHAR2(200)  ,
TOTAL_NRC                        VARCHAR2(200)  ,
NRC                              VARCHAR2(200)  ,
PENALTY                          VARCHAR2(200)  ,
SUSPENSION_CHARGE                NUMBER         ,
INVOICE_NUMBER                   VARCHAR2(100)  ,
SPEED                            VARCHAR2(200)  ,
POE_PORT                         VARCHAR2(200)  ,
LAN_PORT                         VARCHAR2(200)  ,
DEVICE                           VARCHAR2(200)  ,
DEVICE_TYPE                      VARCHAR2(200)  ,
REDUNDANCY_SUPPORT               VARCHAR2(200)  ,
SERVICE_ID                       NUMBER         ,
FIREWALL_TYPE                    VARCHAR2(200)  ,
UNDERLAY_CIRCUIT_ID              NUMBER         ,
REDUNDANCY                       VARCHAR2(200)  ,
IP_ADDRESS_TYPE                  VARCHAR2(200)  ,
FIBER_TYPE                       VARCHAR2(200)  ,
VPN_SUPPORT                      VARCHAR2(200)  ,
UNDERLAY_SERVICE                 VARCHAR2(200)  ,
QOS                              VARCHAR2(200)  ,
CONNECTION_TYPE                  VARCHAR2(200)  ,
ROUTER_THROUGHPUT                VARCHAR2(200)  ,
ROUTER_MODEL                     VARCHAR2(200)  ,
WAN_PORT                         VARCHAR2(200)  ,
THREAT_DETECTION                 VARCHAR2(200)  ,
POE_POWER_BUDGET                 VARCHAR2(200)  ,
WIRELESS_STANDARD                VARCHAR2(200)  ,
DEVICE_MODEL                     VARCHAR2(200)  ,
TRAFFIC_MONITORING               VARCHAR2(200)  ,
DEVICE_VENDOR                    VARCHAR2(200)  ,
DATA_LIMIT                       VARCHAR2(200)  ,
MODEL                            VARCHAR2(200)  ,
FIRMWARE_VERSION                 VARCHAR2(200)  ,
TRANSPORT_TYPE                   VARCHAR2(200)  ,
VENDOR                           VARCHAR2(200)  ,
PRODUCT_ORDER_ID                 NUMBER         ,
SALES_ORDER_ID                   NUMBER  
);

CREATE TABLE LOCATION_DETAILS
(
LOCATION_ID                        NUMBER        NOT NULL,
LOCATION_NAME                      VARCHAR2(500) ,
CITY                               VARCHAR2(500) ,
STATE                              VARCHAR2(500) ,
ZIPCODE                            VARCHAR2(500) ,
ACCOUNT_ID                         NUMBER        ,
SOW_ID                             NUMBER        ,
OFF_NET_VENDOR                     VARCHAR2(500) ,
SURVEY_REQUIRED                    VARCHAR2(10)  ,
CONSTRUCTION_REQUIRED              VARCHAR2(10)  ,
ROE_REQUIRED                       VARCHAR2(10)  ,
EQUIPMENT_SUPPLIERS                VARCHAR2(500) ,
EQUIPMENT                          VARCHAR2(500) ,
SITE_DEPLOYMENT_DATE               TIMESTAMP(6)  ,
SITE_GROUP                         VARCHAR2(500) ,
EQUIPMENTS_AVAILABILITY            VARCHAR2(500) ,
FORECASTED_DUE_DATE                TIMESTAMP(6)  ,
ACTUAL_END_DATE                    TIMESTAMP(6)  ,
PLANNED_END_DATE                   TIMESTAMP(6)  ,
TECHNICIAN_REQUIRED                VARCHAR2(10)  ,
PERMIT_REQUIRED                    VARCHAR2(10)  ,
EQUIPMENT_REQUIRED                 VARCHAR2(10)  ,
PRODUCT_ID                         NUMBER        ,
ACCESS_TYPE                        VARCHAR2(100) ,
GROUP_ID                           NUMBER        ,
BUILD_TYPE                         VARCHAR2(100) ,
CUSTOMER_DESIRED_DUE_DATE          TIMESTAMP(6)  ,
SERVICE_PROVIDER                   VARCHAR2(100) ,
LOCATION_STATUS                    VARCHAR2(100) ,
COUNTRY                            VARCHAR2(100) ,
TRANSPORT_TYPE                     VARCHAR2(100) ,
ADDRESS_LINE_1                     VARCHAR2(100) ,
MANAGED_SERVICES                   VARCHAR2(100) ,
APPROVED_DATE                      TIMESTAMP(6)  ,
CONSTRUCTION_CONTRACTOR            VARCHAR2(100) ,
PROPERTY_OWNER_ADDRESS             VARCHAR2(100) ,
LATITUDE                           VARCHAR2(100) ,
APPLIED_DATE                       TIMESTAMP(6)  ,
PERMIT_COST                        VARCHAR2(100) ,
PERMIT_ID                          VARCHAR2(100) ,
RACK_SPACE_AVAILABLE               VARCHAR2(100) ,
POWER_TESTED                       VARCHAR2(100) ,
SUBMITTED_DATE                     TIMESTAMP(6)  ,
SITE_PRIORITY                      VARCHAR2(100) ,
PERMIT_NAME                        VARCHAR2(100) ,
AGREEMENT_NAME                     VARCHAR2(100) ,
ACTUAL_RECEIVED_DATE               TIMESTAMP(6)  ,
OTHERS                             VARCHAR2(100) ,
PERMIT_TYPE                        VARCHAR2(100) ,
PERMIT_JURISDICTION                VARCHAR2(100) ,
RACK_GROUNDING_OK                  VARCHAR2(100) ,
HVAC_OK                            VARCHAR2(100) ,
AGREEMENT_TYPE                     VARCHAR2(100) ,
SOW_REQUESTED_DATE                 TIMESTAMP(6)  ,
EXISTING_ROE                       VARCHAR2(100) ,
SIGNED_BY_LAND_LORD_DATE           TIMESTAMP(6)  ,
LONGITUDE                          VARCHAR2(100) ,
UPS_AVAILABLE                      VARCHAR2(100) ,
ESTIMATED_RECEIVED_DATE            TIMESTAMP(6)  ,
PROPERTY_OWNER_NAME                VARCHAR2(100) ,
SOW_RECEIVED_DATE                  TIMESTAMP(6)  ,
SCOPE_OF_WORK                      VARCHAR2(100) ,
ROE_TYPE                           VARCHAR2(100) ,
SCHEDULED_APPROVAL_DATE            TIMESTAMP(6)  ,
AGREEMENT_NUMBER                   VARCHAR2(100) ,
CUSTOMER_OWNS_BUILDING             VARCHAR2(100) ,
ADDRESS_LINE_2                     VARCHAR2(100) ,
ADDRESS_LINE_3                     VARCHAR2(100) ,
ADDRESS_LINE_4                     VARCHAR2(100) ,
SERVICE_GROUP_ID                   NUMBER        ,
APPOINTMENT_DATE                   DATE          ,
DEVICE                             VARCHAR2(100) ,
ROUTER_AVAILABILITY                VARCHAR2(200) ,
SWITCH_AVAILABILITY                VARCHAR2(200) ,
CONTROLLER_AVAILABILITY            VARCHAR2(200) ,
ACCESSPOINT_AVAILABILITY           VARCHAR2(200) ,
FIREWALL_AVAILABILITY              VARCHAR2(200) ,
ROUTER                             NUMBER        ,
SWITCH                             NUMBER        ,
CONTROLLER                         NUMBER        ,
ACCESS_POINT                       NUMBER        ,
FIREWALL                           NUMBER  
);

CREATE TABLE TASK_DETAILS
(
TASK_ID                       NUMBER         NOT NULL,
TASK_STATUS                   VARCHAR2(100) ,
TASK_CREATED_BY               VARCHAR2(100) ,
TASK_DUE_DATE                 TIMESTAMP(6)  ,
TASK_ENTITY_ID                NUMBER        ,
TASK_ROOT_ID                  NUMBER        ,
TASK_START_DATE               TIMESTAMP(6)  ,
TASK_END_DATE                 TIMESTAMP(6)  ,
SUB_PHASE_ID                  NUMBER        ,
JEOPARDY_DESCRIPTION          VARCHAR2(100) 
);

CREATE TABLE PHASE_DETAILS
(
PHASE_ID           NUMBER  ,      
PHASE_NAME         VARCHAR2(100) ,
PHASE_STATUS       VARCHAR2(100) ,
PROJECT_ID         NUMBER 
);

CREATE TABLE SUB_PHASE_DETAILS
(
ID                     NUMBER  ,      
SUB_PHASE_NAME         VARCHAR2(100) ,
SUB_PHASE_STATUS       VARCHAR2(100) ,
PHASE_ID               NUMBER 
);

create table SITE_GROUP_DETAILS
(
GROUP_ID              NUMBER ,       
GROUP_NAME            VARCHAR2(100) ,
NO_OF_LOCATIONS       NUMBER        ,
PROJECT_ID            NUMBER        ,
DESIGN_ID             NUMBER        ,
LOCATION_ID           NUMBER        ,
STATUS                VARCHAR2(100) 
);

CREATE TABLE PRODUCT_ORDER_DETAILS
(
SERVICE_REQUEST_ID                NUMBER         NOT NULL ,
STATUS                            VARCHAR2(500) ,
REQUESTED_START_DATE              TIMESTAMP(6)  ,
SALES_ORDER_ID                    NUMBER        ,
MARKET_OFFERING_ID                NUMBER        ,
ACTIVITY_TYPE                     VARCHAR2(100) ,
REQUESTED_COMPLETED_DATE          TIMESTAMP(6) 
);

CREATE TABLE SERVICE_ORDER_DETAILS
(
SERVICE_ORDERID          NUMBER ,       
STATUS                   VARCHAR2(100), 
SERVICE_REQUEST_ID       NUMBER        
);

CREATE TABLE SOW_DETAILS
(
CONTRACT_ID                  NUMBER          NOT NULL,
MSA_NAME                     VARCHAR2(500) ,
CONTRACT_NAME                VARCHAR2(500) ,
MSA_ID                       NUMBER        ,
PRODUCT                      VARCHAR2(500) ,
LOCATION_ID                  NUMBER        ,
CUSTOMER_ID                  NUMBER        ,
SOW_CONTRACT_STATUS          VARCHAR2(100) ,
ACCOUNT_ID                   NUMBER        
);

CREATE TABLE SERVICE_GROUP_DETAILS
(
SERVICE_GROUP_ID         NUMBER ,       
SERVICE_GROUP_NAME       VARCHAR2(100) ,
LOCATION_ID              NUMBER  ,      
SOW_ID                   NUMBER 
);

CREATE TABLE ADDRESS_DETAILS
(
ADDRESS_ID              NUMBER        NOT NULL,
ADDRESS_LINE_1          VARCHAR2(200) ,
ADDRESS_LINE_2          VARCHAR2(200) ,
CITY                    VARCHAR2(200) ,
STATE                   VARCHAR2(200) ,
COUNTRY                 VARCHAR2(200) ,
ZIPCODE                 NUMBER        ,
LATTITUDE               NUMBER        ,
LONGITUDE               NUMBER        ,
CUSTOMER_ID             NUMBER        ,
ACCOUNT_ID              NUMBER        ,
CREATED_DATE            TIMESTAMP(6)  ,
CREATED_BY              VARCHAR2(100) ,
MODIFIED_DATE           TIMESTAMP(6)  ,
MODIFIED_BY             VARCHAR2(100) 
);



--changeset Vijaysree.S:CRPT_DDL_02_02 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TABLES 
    WHERE  
        TABLE_NAME = 'LOCATION_COMPLETED_BY_MONTH';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE LOCATION_COMPLETED_BY_MONTH (
		                      MONTH                    DATE,          
                              TARGET_BY_MONTH          NUMBER(38),    
                              LOCATION_COMPLETED       NUMBER(38) ,   
                              PROJECT_MANAGER          VARCHAR2(100) )';
        DBMS_OUTPUT.PUT_LINE('ALTERED');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ALREADY EXIST');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SKIPPED');
END;


--changeset Vijaysree.S:CRPT_DDL_02_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TABLES 
    WHERE  
        TABLE_NAME = 'LOCATION_COMPLETED_BY_WEEK';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE LOCATION_COMPLETED_BY_WEEK (
		                      WEEK                     DATE,          
                              TARGET_BY_WEEK           NUMBER(38),    
                              LOCATION_COMPLETED       NUMBER(38),    
                              PROJECT_MANAGER          VARCHAR2(100)  )';
        DBMS_OUTPUT.PUT_LINE('ALTERED');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ALREADY EXIST');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SKIPPED');
END;


--changeset Vijaysree.S:CRPT_DDL_02_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TABLES 
    WHERE  
        TABLE_NAME = 'PROJECT_PROGRESS_GPM';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE PROJECT_PROGRESS_GPM (
		                      PROJECT                  VARCHAR2(26) , 
                              TOTAL_LOCATIONS          NUMBER(38) ,   
                              COMPLETED_ORDERS         NUMBER(38) ,  
                              PENDING_ORDERS           NUMBER(38) , 
                              ON_HOLD_ORDERS           NUMBER(38) ,   
                              IN_PROGRESS_ORDERS       NUMBER(38) ,   
                              PROJECT_MANAGER          VARCHAR2(100)  )';
        DBMS_OUTPUT.PUT_LINE('ALTERED');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ALREADY EXIST');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SKIPPED');
END;

 



--changeset Vijaysree.S:CRPT_DDL_02_05 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'SOW_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SOW_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_06 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'MARKET_OFFERING_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE MARKET_OFFERING_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'LOCATION_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE LOCATION_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'SERVICE_GROUP_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_GROUP_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_09 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'PHASE_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PHASE_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'SUB_PHASE_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SUB_PHASE_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_11 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'TASK_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE TASK_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:CRPT_DDL_02_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'ADDRESS_DETAILS'
        AND COLUMN_NAME = 'STATUS';

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ADDRESS_DETAILS ADD STATUS VARCHAR2(100)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;

