--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DDL_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BASIC_AUTH_DETAILS';
  l_synonym_name VARCHAR2(50) :='BASIC_AUTH_DETAILS';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_INS_PROCESS_MAPPING';
  l_synonym_name VARCHAR2(50) :='BUSINESS_INS_PROCESS_MAPPING';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='DOCUMENT_INFO';
  l_synonym_name VARCHAR2(50) :='DOCUMENT_INFO';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_04 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUPS';
  l_synonym_name VARCHAR2(50) :='GROUPS';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(30) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_name VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(30) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='NOTE';
  l_synonym_name VARCHAR2(50) :='NOTE';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='OAUTH_CLIENT_DETAILS';
  l_synonym_name VARCHAR2(50) :='OAUTH_CLIENT_DETAILS';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PRODUCT_ENTITY_INSTANCE';
  l_synonym_name VARCHAR2(50) :='PRODUCT_ENTITY_INSTANCE';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='REPORT_ID_SEQ';
  l_synonym_name VARCHAR2(50) :='REPORT_ID_SEQ';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='REPORT_TEMPLATE';
  l_synonym_name VARCHAR2(50) :='REPORT_TEMPLATE';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SEQ_SERV_ID';
  l_synonym_name VARCHAR2(50) :='SEQ_SERV_ID';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SEQ_TRANSACTION_ID';
  l_synonym_name VARCHAR2(50) :='SEQ_TRANSACTION_ID';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SERVICE_INFO';
  l_synonym_name VARCHAR2(50) :='SERVICE_INFO';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_14 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='TRANSACTION_DETAILS';
  l_synonym_name VARCHAR2(50) :='TRANSACTION_DETAILS';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERS';
  l_synonym_name VARCHAR2(50) :='USERS';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(30) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:APPCATALOG_DDL_06_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SEQ_REFERENCE_ID';
  l_synonym_name VARCHAR2(50) :='SEQ_REFERENCE_ID';
  l_synonym_src  VARCHAR2(30) :='APPCATALOG';
  L_synonym_trg  VARCHAR2(10) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 