--liquibase formatted sql
--changeset Swetha.H:NOTES_DDL_05 splitStatements:false 
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='DOCUMENT_ENTITY_ASSOC';
  l_synonym_name VARCHAR2(50) :='DOCUMENT_ENTITY_ASSOC';
  l_synonym_src  VARCHAR2(30) :='NOTES';
  L_synonym_trg  VARCHAR2(10) :='CDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:NOTES_DDL_05_02 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='DOCUMENT_INFO';
  l_synonym_name VARCHAR2(50) :='DOCUMENT_INFO';
  l_synonym_src  VARCHAR2(30) :='NOTES';
  L_synonym_trg  VARCHAR2(10) :='CDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:NOTES_DDL_05_03 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERS';
  l_synonym_name VARCHAR2(50) :='USERS';
  l_synonym_src  VARCHAR2(30) :='NOTES';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

