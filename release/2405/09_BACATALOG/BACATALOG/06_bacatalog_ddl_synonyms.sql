--liquibase formatted sql
--changeset Vijaysree.S:BACATALOG_DDL_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BASIC_AUTH_DETAILS';
  l_synonym_name VARCHAR2(50) :='BASIC_AUTH_DETAILS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Vijaysree.S:BACATALOG_DDL_06_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='DOCUMENT_ENTITY_ASSOC';
  l_synonym_name VARCHAR2(50) :='DOCUMENT_ENTITY_ASSOC';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='DOCUMENT_INFO';
  l_synonym_name VARCHAR2(50) :='DOCUMENT_INFO';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_04 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUPS';
  l_synonym_name VARCHAR2(50) :='GROUPS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_name VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='LAYOUT_ID_SEQ';
  l_synonym_name VARCHAR2(50) :='LAYOUT_ID_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='LCA_METADATA_ID_SEQ';
  l_synonym_name VARCHAR2(50) :='LCA_METADATA_ID_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_08 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='NOTE';
  l_synonym_name VARCHAR2(50) :='NOTE';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='NOTE_FOLLOWUP';
  l_synonym_name VARCHAR2(50) :='NOTE_FOLLOWUP';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='NOTE_SEQ';
  l_synonym_name VARCHAR2(50) :='NOTE_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='OAUTH_CLIENT_DETAILS';
  l_synonym_name VARCHAR2(50) :='OAUTH_CLIENT_DETAILS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PARAMETER_LOCALE_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PARAMETER_LOCALE_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_SPEC_ID_SEQ';
  l_synonym_name VARCHAR2(50) :='PROCESS_SPEC_ID_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_14 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='QRTZ_CRON_TRIGGERS';
  l_synonym_name VARCHAR2(50) :='QRTZ_CRON_TRIGGERS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='QRTZ_JOB_DETAILS';
  l_synonym_name VARCHAR2(50) :='QRTZ_JOB_DETAILS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='QRTZ_TRIGGERS';
  l_synonym_name VARCHAR2(50) :='QRTZ_TRIGGERS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_17 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='RECORD_KEY_SEQ';
  l_synonym_name VARCHAR2(50) :='RECORD_KEY_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_18 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='REF_ENTITY_TYPE';
  l_synonym_name VARCHAR2(50) :='REF_ENTITY_TYPE';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 




--changeset Vijaysree.S:BACATALOG_DDL_06_19 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SEQ_REFERENCE_ID';
  l_synonym_name VARCHAR2(50) :='SEQ_REFERENCE_ID';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_20 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SEQ_TRANSACTION_ID';
  l_synonym_name VARCHAR2(50) :='SEQ_TRANSACTION_ID';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_21 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SERVICE_INFO';
  l_synonym_name VARCHAR2(50) :='SERVICE_INFO';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='TRANSACTION_CORRECTION_ASSOC';
  l_synonym_name VARCHAR2(50) :='TRANSACTION_CORRECTION_ASSOC';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_23 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='TRANSACTION_DETAILS';
  l_synonym_name VARCHAR2(50) :='TRANSACTION_DETAILS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_24 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='TRANSACTION_ID_SEQ';
  l_synonym_name VARCHAR2(50) :='TRANSACTION_ID_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_25 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='TRANSACTION_SMB_DETAILS';
  l_synonym_name VARCHAR2(50) :='TRANSACTION_SMB_DETAILS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_26 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='TRANS_FAILURE_LOG';
  l_synonym_name VARCHAR2(50) :='TRANS_FAILURE_LOG';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_27 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERS';
  l_synonym_name VARCHAR2(50) :='USERS';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_28 splitStatements:false
--preconditions onFail:HALT onError:HALT 
  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='PID_SEQ';
  l_synonym_name VARCHAR2(100) :='PID_SEQ';
  l_synonym_src  VARCHAR2(100) :='BACATALOG';
  L_synonym_trg  VARCHAR2(100) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;


--changeset Vijaysree.S:BACATALOG_DDL_06_29 splitStatements:false
--preconditions onFail:HALT onError:HALT  
  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='CITY';
  l_synonym_name VARCHAR2(100) :='CITY';
  l_synonym_src  VARCHAR2(100) :='BACATALOG';
  L_synonym_trg  VARCHAR2(100) :='CRDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
--changeset Vijaysree.S:BACATALOG_DDL_06_30 splitStatements:false
--preconditions onFail:HALT onError:HALT  
  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='ZIPCODE_SYSPRIN';
  l_synonym_name VARCHAR2(100) :='ZIPCODE_SYSPRIN';
  l_synonym_src  VARCHAR2(100) :='BACATALOG';
  L_synonym_trg  VARCHAR2(100) :='CRDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
--changeset Vijaysree.S:BACATALOG_DDL_06_31 splitStatements:false
--preconditions onFail:HALT onError:HALT  
  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='ZIPCODE';
  l_synonym_name VARCHAR2(100) :='ZIPCODE';
  l_synonym_src  VARCHAR2(100) :='BACATALOG';
  L_synonym_trg  VARCHAR2(100) :='CRDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
--changeset Vijaysree.S:BACATALOG_DDL_06_32 splitStatements:false
--preconditions onFail:HALT onError:HALT  
  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='STATE';
  l_synonym_name VARCHAR2(100) :='STATE';
  l_synonym_src  VARCHAR2(100) :='BACATALOG';
  L_synonym_trg  VARCHAR2(100) :='CRDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;

--changeset Vijaysree.S:BACATALOG_DDL_06_33 splitStatements:false
--preconditions onFail:HALT onError:HALT  
  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='COMPANY';
  l_synonym_name VARCHAR2(100) :='COMPANY';
  l_synonym_src  VARCHAR2(100) :='BACATALOG';
  L_synonym_trg  VARCHAR2(100) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;



--changeset Vijaysree.S:BACATALOG_DDL_06_34 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='APP_ERROR_LOG';
  l_synonym_name VARCHAR2(50) :='APP_ERROR_LOG';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='HISTORY';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:BACATALOG_DDL_06_35 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ERROR_LOG_ID_SEQ';
  l_synonym_name VARCHAR2(50) :='ERROR_LOG_ID_SEQ';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='HISTORY';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Vijaysree.S:BACATALOG_DDL_06_36 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROC_APPLICATION_ERROR_LOG';
  l_synonym_name VARCHAR2(50) :='PROC_APPLICATION_ERROR_LOG';
  l_synonym_src  VARCHAR2(30) :='BACATALOG';
  L_synonym_trg  VARCHAR2(30) :='HISTORY';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

