--liquibase formatted sql
--changeset Swetha.H:HISTORYS_DDL_09_1 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'APP_ERROR_LOG'; 
    L_grant_from  VARCHAR2(30):= 'HISTORYS'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT,INSERT,UPDATE,DELETE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;



--changeset Swetha.H:HISTORYS_DDL_09_2 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'ERROR_LOG_ID_SEQ'; 
    L_grant_from  VARCHAR2(30):= 'HISTORYS'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant SELECT on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;


--changeset Swetha.H:HISTORYS_DDL_09_3 splitStatements:false
--preconditions onFail:HALT onError:HALT 

DECLARE 
    L_Source_Name VARCHAR2(50); 
    L_Target_Name VARCHAR2(50); 
    L_Table_Name  VARCHAR2(50):= 'PROC_APPLICATION_ERROR_LOG'; 
    L_grant_from  VARCHAR2(30):= 'HISTORYS'; 
    L_grant_to    VARCHAR2(30):= 'BACATALOG'; 
BEGIN 
    SELECT USER INTO L_Source_Name FROM Dual; 
    SELECT L_grant_to||REPLACE(USER,L_grant_from) 
    INTO L_Target_Name FROM Dual; 
    EXECUTE Immediate 'grant EXECUTE on ' ||L_Source_Name||'.'||L_Table_Name||' to '||L_Target_Name; 
END;

