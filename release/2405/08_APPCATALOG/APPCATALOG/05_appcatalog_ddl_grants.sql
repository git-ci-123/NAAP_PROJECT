--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DDL_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'LAYOUT_ID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'RECORD_KEY_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'REFERENCE_TYPES'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'REF_ENTITY_TYPE'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'LCA_METADATA_ID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROCESS_SPEC_ID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'REFERENCE_TYPE_VALUES'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PARAMETER_LOCALE_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANSACTION_ID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'LIFE_CYCLE_ACTIVITY_METADATA'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ENTITY_JOIN_PARAMETER'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:APPCATALOG_DDL_05_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ENTITY_GROUP_FUNCTION'; 
    L_grant_from  VARCHAR2(30):= 'APPCATALOG'; 
    L_grant_to    VARCHAR2(30):= 'HISTORYS'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

