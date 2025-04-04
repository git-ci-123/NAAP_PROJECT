--liquibase formatted sql
--changeset Vijaysree.S:CIF_DDL_06 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_ENTITY_PARAMETER';
  l_synonym_name VARCHAR2(50) :='BUSINESS_ENTITY_PARAMETER';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:CIF_DDL_06_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_PROCESS_MAPPING';
  l_synonym_name VARCHAR2(50) :='BUSINESS_PROCESS_MAPPING';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:CIF_DDL_06_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PARAMETER_ADDON_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PARAMETER_ADDON_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:CIF_DDL_06_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PARAMETER_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PARAMETER_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:CIF_DDL_06_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Vijaysree.S:CIF_DDL_06_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Vijaysree.S:CIF_DDL_06_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BATCH_TRACKER';
  l_synonym_name VARCHAR2(50) :='BATCH_TRACKER';
  l_synonym_src  VARCHAR2(30) :='CIF';
  L_synonym_trg  VARCHAR2(30) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

