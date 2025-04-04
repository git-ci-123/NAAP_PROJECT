--liquibase formatted sql
--changeset Swetha.H:CDM_DDL_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'DOCUMENT_INFO'; 
    L_grant_from  VARCHAR2(30):= 'CDM'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Swetha.H:CDM_DDL_05_02 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'DOCUMENT_ENTITY_ASSOC'; 
    L_grant_from  VARCHAR2(30):= 'CDM'; 
    L_grant_to    VARCHAR2(30):= 'NOTES'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant ALTER,DEBUG,DELETE,FLASHBACK,INDEX,INSERT,ON COMMIT REFRESH,QUERY REWRITE,READ,REFERENCES,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:CDM_DDL_05_03 splitStatements:false 
--preconditions onFail:HALT onError:HALT
DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'DOCUMENT_ENTITY_ASSOC'; 
    L_grant_from  VARCHAR2(30):= 'CDM'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Swetha.H:CDM_DDL_05_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'DOCUMENT_INFO'; 
    L_grant_from  VARCHAR2(30):= 'CDM'; 
    L_grant_to    VARCHAR2(30):= 'APPCATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Swetha.H:CDM_DDL_05_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'DOCUMENT_INFO'; 
    L_grant_from  VARCHAR2(30):= 'CDM'; 
    L_grant_to    VARCHAR2(30):= 'NOTES'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant DELETE,INSERT,SELECT,UPDATE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;