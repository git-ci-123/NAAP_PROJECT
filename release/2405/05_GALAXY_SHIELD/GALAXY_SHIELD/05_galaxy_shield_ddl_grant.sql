--liquibase formatted sql
--changeset Swetha.H:GALAXY_SHIELD_DDL_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CA'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant ALTER,DEBUG,DELETE,FLASHBACK,INDEX,INSERT,ON COMMIT REFRESH,QUERY REWRITE,READ,REFERENCES,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_03 splitStatements:false
--preconditions onFail:HALT onError:HALT
DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name || ' WITH GRANT OPTION'; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_04 splitStatements:false
--preconditions onFail:HALT onError:HALT
DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CDM'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_05 splitStatements:false
--preconditions onFail:HALT onError:HALT
DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUPS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUPS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUPS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'COMPANY'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'COMPANY'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'RESOURC'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ACCESSOR'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_14 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ACCESS_AUTH'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_ROLE'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_USER'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_17 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_USER'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_18 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_USER'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_19 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_USER'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_20 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USER_ROLE_ASSOC'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;
--changeset Swetha.H:GALAXY_SHIELD_DDL_05_21 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUPS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'CRF'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'RESOURC'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_23 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_USER'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_24 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'COMPANY'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_25 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ACCESSOR'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_26 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUPS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_27 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'GROUP_TO_ROLE'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_28 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'USERS'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:GALAXY_SHIELD_DDL_05_29 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ACCESS_AUTH'; 
    L_grant_from  VARCHAR2(30):= 'GALAXY_SHIELD'; 
    L_grant_to    VARCHAR2(30):= 'GS_AUDITLOG_REPORT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

