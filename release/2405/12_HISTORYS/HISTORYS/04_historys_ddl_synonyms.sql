--liquibase formatted sql
--changeset Swetha.H:HISTORYS_DDL_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ENTITY_JOIN_PARAMETER';
  l_synonym_name VARCHAR2(50) :='ENTITY_JOIN_PARAMETER';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_2 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ENTITY_GROUP_FUNCTION';
  l_synonym_name VARCHAR2(50) :='ENTITY_GROUP_FUNCTION';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_3 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ENTITY_GROUP_PARAMETER_VALUES';
  l_synonym_name VARCHAR2(50) :='ENTITY_GROUP_PARAMETER_VALUES';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_4 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='LIFE_CYCLE_ACTIVITY';
  l_synonym_name VARCHAR2(50) :='LIFE_CYCLE_ACTIVITY';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_5 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SERVICE_GROUP_PARAMETER';
  l_synonym_name VARCHAR2(50) :='SERVICE_GROUP_PARAMETER';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_6 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_PROCESS_INSTANCE';
  l_synonym_name VARCHAR2(50) :='BUSINESS_PROCESS_INSTANCE';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_7 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY_RELATION';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY_RELATION';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_8 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY_INSTANCE';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY_INSTANCE';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_9 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PRODUCT_ENTITY_RELATION';
  l_synonym_name VARCHAR2(50) :='PRODUCT_ENTITY_RELATION';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PRODUCT_ENTITY_INSTANCE';
  l_synonym_name VARCHAR2(50) :='PRODUCT_ENTITY_INSTANCE';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
--changeset Swetha.H:HISTORYS_DDL_04_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PLAN_INSTANCE_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PLAN_INSTANCE_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='HISTORYS';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:HISTORYS_DDL_04_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='MASTER_OBJECT_DETAILS';
  l_synonym_name VARCHAR2(50) :='MASTER_OBJECT_DETAILS';
  l_synonym_src  VARCHAR2(50) :='HISTORYS';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
  END;