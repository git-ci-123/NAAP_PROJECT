--liquibase formatted sql
--changeset Swetha.H:CRPT_DDL_01_01 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERS_DASHBOARD';
  l_synonym_name VARCHAR2(50) :='USERS_DASHBOARD';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='CRF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY_RELATION';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY_RELATION';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_03 splitStatements:false
--preconditions onFail:HALT onError:HALT 


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PARAMETER_SPECIFICATION';
  l_synonym_name VARCHAR2(50) :='PARAMETER_SPECIFICATION';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:CRPT_DDL_01_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='DASHBOARD_PUBLISH_DETAIL';
  l_synonym_name VARCHAR2(50) :='DASHBOARD_PUBLISH_DETAIL';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='CRF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_05 splitStatements:false
--preconditions onFail:HALT onError:HALT 



DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='LIFE_CYCLE_ACTIVITY_METADATA';
  l_synonym_name VARCHAR2(50) :='LIFE_CYCLE_ACTIVITY_METADATA';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 




--changeset Swetha.H:CRPT_DDL_01_06 splitStatements:false
--preconditions onFail:HALT onError:HALT 


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERS';
  l_synonym_name VARCHAR2(50) :='USERS';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 



--changeset Swetha.H:CRPT_DDL_01_07 splitStatements:false
--preconditions onFail:HALT onError:HALT 

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='ENTITY_GROUP_PARAMETER_VALUES';
  l_synonym_name VARCHAR2(50) :='ENTITY_GROUP_PARAMETER_VALUES';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='METRICS_TEMPLATE_DETAIL';
  l_synonym_name VARCHAR2(50) :='METRICS_TEMPLATE_DETAIL';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='CRF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PRODUCT_ENTITY_INSTANCE';
  l_synonym_name VARCHAR2(50) :='PRODUCT_ENTITY_INSTANCE';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:CRPT_DDL_01_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='SITE_NOTE_ASSOC';
  l_synonym_name VARCHAR2(50) :='SITE_NOTE_ASSOC';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:CRPT_DDL_01_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USER_ROLE_ASSOC';
  l_synonym_name VARCHAR2(50) :='USER_ROLE_ASSOC';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_13 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='LIFE_CYCLE_ACTIVITY';
  l_synonym_name VARCHAR2(50) :='LIFE_CYCLE_ACTIVITY';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_14 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUPS';
  l_synonym_name VARCHAR2(50) :='GROUPS';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_15 splitStatements:false
--preconditions onFail:HALT onError:HALT
 

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='QUERYDETAILS';
  l_synonym_name VARCHAR2(50) :='QUERYDETAILS';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='CRF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:CRPT_DDL_01_16 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='USERQUERYASSOCIATION';
  l_synonym_name VARCHAR2(50) :='USERQUERYASSOCIATION';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='CRF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:CRPT_DDL_01_17 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_name VARCHAR2(50) :='GROUP_TO_USER';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='GALAXY_SHIELD';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

--changeset Swetha.H:CRPT_DDL_01_18 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='NOTE_ENTITY_TYPE';
  l_synonym_name VARCHAR2(50) :='NOTE_ENTITY_TYPE';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_19 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='NOTE';
  l_synonym_name VARCHAR2(50) :='NOTE';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='NOTES';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_20 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='PROCESS_ENTITY_INSTANCE';
  l_synonym_name VARCHAR2(50) :='PROCESS_ENTITY_INSTANCE';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 


--changeset Swetha.H:CRPT_DDL_01_21 splitStatements:false
--preconditions onFail:HALT onError:HALT
 

DECLARE
  L_Source_Name  VARCHAR2(50);
  L_Target_Name  VARCHAR2(50);
  L_Table_Name   VARCHAR2(50) :='BUSINESS_PROCESS_INSTANCE';
  l_synonym_name VARCHAR2(50) :='BUSINESS_PROCESS_INSTANCE';
  l_synonym_src  VARCHAR2(50) :='CRPT';
  L_synonym_trg  VARCHAR2(50) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;
END; 

  
--changeset Swetha.H:CRPT_DDL_01_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='BUSINESS_ENTITY_PARAMETER';
  l_synonym_name VARCHAR2(100) :='BUSINESS_ENTITY_PARAMETER';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
 
 --changeset Swetha.H:CRPT_DDL_01_23 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='PRODUCT_ENTITY_RELATION';
  l_synonym_name VARCHAR2(100) :='PRODUCT_ENTITY_RELATION';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
 
 
 --changeset Swetha.H:CRPT_DDL_01_24 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='PROCESS_ENTITY_SPECIFICATION';
  l_synonym_name VARCHAR2(100) :='PROCESS_ENTITY_SPECIFICATION';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;

--changeset Swetha.H:CRPT_DDL_01_25 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='BUSINESS_PROCESS_MAPPING';
  l_synonym_name VARCHAR2(100) :='BUSINESS_PROCESS_MAPPING';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;

--changeset Swetha.H:CRPT_DDL_01_26 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='BUSINESS_ENTITY';
  l_synonym_name VARCHAR2(100) :='BUSINESS_ENTITY';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;

--changeset Swetha.H:CRPT_DDL_01_27 splitStatements:false
--preconditions onFail:HALT onError:HALT



DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='PARAMETER_REFERENCE_VALUE';
  l_synonym_name VARCHAR2(100) :='PARAMETER_REFERENCE_VALUE';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;



--changeset Swetha.H:CRPT_DDL_01_28 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='TRANSACTION_DETAILS';
  l_synonym_name VARCHAR2(100) :='TRANSACTION_DETAILS';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='CIF';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;

--changeset Swetha.H:CRPT_DDL_01_29 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='PROJECT_LIFECYCLE_ACTIVITY';
  l_synonym_name VARCHAR2(100) :='PROJECT_LIFECYCLE_ACTIVITY';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
--changeset Swetha.H:CRPT_DDL_01_30 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='ENTITY_DUE_DATE_DETAILS';
  l_synonym_name VARCHAR2(100) :='ENTITY_DUE_DATE_DETAILS';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;


--changeset Swetha.H:CRPT_DDL_01_31 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='REFERENCE_TYPES';
  l_synonym_name VARCHAR2(100) :='REFERENCE_TYPES';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
--changeset Swetha.H:CRPT_DDL_01_32 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='REFERENCE_TYPE_VALUES';
  l_synonym_name VARCHAR2(100) :='REFERENCE_TYPE_VALUES';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='APPCATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
  
--changeset Swetha.H:CRPT_DDL_01_33 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='FUNC_GET_ENTITY_PARAM_VALUE';
  l_synonym_name VARCHAR2(100) :='FUNC_GET_ENTITY_PARAM_VALUE';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;
  
--changeset Swetha.H:CRPT_DDL_01_34 splitStatements:false
--preconditions onFail:HALT onError:HALT

  
DECLARE
  L_Source_Name  VARCHAR2(100);
  L_Target_Name  VARCHAR2(100);
  L_Table_Name   VARCHAR2(100) :='BUSINESS_ENTITY_SPECIFICATION';
  l_synonym_name VARCHAR2(100) :='BUSINESS_ENTITY_SPECIFICATION';
  l_synonym_src  VARCHAR2(100) :='CRPT';
  L_synonym_trg  VARCHAR2(100) :='BACATALOG';
BEGIN
  SELECT USER INTO L_Source_Name FROM Dual;
  SELECT L_synonym_trg
    ||REPLACE(USER,L_synonym_src)
  INTO L_Target_Name
  FROM Dual;
  EXECUTE immediate 'create or replace synonym '||l_source_name||'.'||l_synonym_name||' for '||l_target_name||'.'||l_table_name;  
  END;