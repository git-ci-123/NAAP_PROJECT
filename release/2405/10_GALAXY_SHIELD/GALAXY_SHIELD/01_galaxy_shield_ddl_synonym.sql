--liquibase formatted sql
--changeset Swetha.H:GALAXY_SHIELD_DDL_01_1 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_ENTITY_PARAMETER';
  l_synonym_name VARCHAR2(50) :='BUSINESS_ENTITY_PARAMETER';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:GALAXY_SHIELD_DDL_01_2 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_PROCESS_MAPPING';
  l_synonym_name VARCHAR2(50) :='BUSINESS_PROCESS_MAPPING';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:GALAXY_SHIELD_DDL_01_3 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PARAMETER_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PARAMETER_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:GALAXY_SHIELD_DDL_01_4 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ACTION_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PROCESS_ACTION_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:GALAXY_SHIELD_DDL_01_5 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:GALAXY_SHIELD_DDL_01_6 splitStatements:false
--preconditions onFail:HALT onError:HALT
 

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_LAYOUT_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PROCESS_LAYOUT_SPECIFICATION';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:GALAXY_SHIELD_DDL_01_7 splitStatements:false
--preconditions onFail:HALT onError:HALT
 

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='REPORT_DETAILS';
  l_synonym_name VARCHAR2(50) :='REPORT_DETAILS';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='CRF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:GALAXY_SHIELD_DDL_01_8 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='REFERENCE_TYPE_VALUES';
  l_synonym_name VARCHAR2(50) :='REFERENCE_TYPE_VALUES';
  l_synonym_src  VARCHAR2(30) :='GALAXY_SHIELD';
  L_synonym_trg  VARCHAR2(10) :='CRDM';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 