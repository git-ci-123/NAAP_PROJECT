--liquibase formatted sql
--changeset Swetha.H:CRF_DDL_05 splitStatements:false 
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ACCESSOR';
  l_synonym_name VARCHAR2(50) :='ACCESSOR';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRF_DDL_05_02 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ACCESS_AUTH';
  l_synonym_name VARCHAR2(50) :='ACCESS_AUTH';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:CRF_DDL_05_03 splitStatements:false 
--preconditions onFail:HALT onError:HALT 


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='COMPANY';
  l_synonym_name VARCHAR2(50) :='COMPANY';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRF_DDL_05_04 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUPS';
  l_synonym_name VARCHAR2(50) :='GROUPS';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:CRF_DDL_05_05 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUP_TO_ROLE';
  l_synonym_name VARCHAR2(50) :='GROUP_TO_ROLE';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRF_DDL_05_06 splitStatements:false 
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_name VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRF_DDL_05_07 splitStatements:false 
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='MVIEW_USERS';
  l_synonym_name VARCHAR2(50) :='MVIEW_USERS';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(30) :='CRPT';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRF_DDL_05_08 splitStatements:false 
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='RESOURC';
  l_synonym_name VARCHAR2(50) :='RESOURC';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRF_DDL_05_09 splitStatements:false 
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERS';
  l_synonym_name VARCHAR2(50) :='USERS';
  l_synonym_src  VARCHAR2(30) :='CRF';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 
