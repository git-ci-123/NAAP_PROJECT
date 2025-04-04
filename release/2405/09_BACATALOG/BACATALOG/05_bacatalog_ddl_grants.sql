--liquibase formatted sql
--changeset Vijaysree.S:BACATALOG_DDL_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BATCH_TRACKER'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PARAMETER_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_PROCESS_MAPPING'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_ENTITY_PARAMETER'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROJECT_LIFECYCLE_ACTIVITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_07 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PARAMETER_ADDON_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CIF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name	VARCHAR2(50);
  L_Target_Name	VARCHAR2(50);
  L_Table_Name	VARCHAR2(50) :='ENTITY_DUE_DATE_DETAILS';
  L_grant_from	VARCHAR2(30) :='BACATALOG';
  L_grant_to	VARCHAR2(50) :='CRPT';
BEGIN
  Select User Into L_Source_Name From Dual;
  SELECT L_grant_to||REPLACE(USER,L_grant_from)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE Immediate 'grant select,insert,update,delete on '||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name;
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'MASTER_OBJECT_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT,DELETE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY_RELATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_INS_PROCESS_MAPPING'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_14 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PRODUCT_ENTITY_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY_RELATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PARAMETER_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_17 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ENTITY_GROUP_PARAMETER_VALUES'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_18 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PRODUCT_ENTITY_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_19 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_20 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'LIFE_CYCLE_ACTIVITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_21 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_PROCESS_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_23 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_ENTITY_PARAMETER'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_24 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PRODUCT_ENTITY_RELATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_25 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_26 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_PROCESS_MAPPING'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_27 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_ENTITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_28 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PARAMETER_REFERENCE_VALUE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_29 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_ENTITY_PARAMETER'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'GALAXY_SHIELD'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_30 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_PROCESS_MAPPING'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'GALAXY_SHIELD'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_31 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PARAMETER_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'GALAXY_SHIELD'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_32 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ACTION_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'GALAXY_SHIELD'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DDL_05_33 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_ENTITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'GALAXY_SHIELD'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_34 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_LAYOUT_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'GALAXY_SHIELD'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_35 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ENTITY_GROUP_PARAMETER_VALUES'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_36 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'LIFE_CYCLE_ACTIVITY'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_37 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SERVICE_GROUP_PARAMETER'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_38 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_PROCESS_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_39 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PRODUCT_ENTITY_RELATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_40 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PRODUCT_ENTITY_INSTANCE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:BACATALOG_DDL_05_41 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PLAN_INSTANCE_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;