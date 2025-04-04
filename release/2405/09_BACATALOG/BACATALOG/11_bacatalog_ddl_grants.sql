--liquibase formatted sql
--changeset Vijaysree.S:BACATALOG_DML_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'FUNC_GET_ENTITY_PARAM_VALUE'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant EXECUTE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

--changeset Vijaysree.S:BACATALOG_DML_11_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'BUSINESS_ENTITY_SPECIFICATION'; 
    L_grant_from  VARCHAR2(30):= 'BACATALOG'; 
    L_grant_to    VARCHAR2(30):= 'CRPT'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant select on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;