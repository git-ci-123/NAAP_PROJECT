--liquibase formatted sql
--changeset Vijaysree.S:CIF_DDL_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SEQ_SERV_ID'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SERVICE_INFO'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SERVICE_INFO'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'QRTZ_TRIGGERS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_05 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'QRTZ_JOB_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SEQ_REFERENCE_ID'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BASIC_AUTH_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BASIC_AUTH_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'QRTZ_CRON_TRIGGERS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SEQ_TRANSACTION_ID'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANSACTION_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANSACTION_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant select, INSERT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANSACTION_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_14 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'OAUTH_CLIENT_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'OAUTH_CLIENT_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Vijaysree.S:CIF_DDL_05_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANSACTION_CORRECTION_ASSOC'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:CIF_DDL_05_17 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SEQ_TRANSACTION_ID'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:CIF_DDL_05_18 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANSACTION_SMB_DETAILS'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:CIF_DDL_05_19 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'TRANS_FAILURE_LOG'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:CIF_DDL_05_20 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'REPORT_TEMPLATE'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:CIF_DDL_05_21 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'REPORT_ID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:CIF_DDL_05_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'SEQ_REFERENCE_ID'; 
    L_grant_from  VARCHAR2(30):= 'CIF'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;