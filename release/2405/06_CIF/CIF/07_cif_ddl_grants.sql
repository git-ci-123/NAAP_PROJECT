--liquibase formatted sql
--changeset Vijaysree.S:CIF_DDL_07 splitStatements:false
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


