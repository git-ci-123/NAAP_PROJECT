--liquibase formatted sql
--changeset Swetha.H:CRF_DDL_06 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE TYPE OBJ_UNPUBLISHED 
AS
  OBJECT
  (
   USER_ID NUMBER(20));
   

--changeset Swetha.H:CRF_DDL_06_02 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE TYPE SUMMARYOBJECT 
AS
  OBJECT
  (
    SUMMARYID  NUMBER,
    sumaryJson VARCHAR2(4000));


--changeset Swetha.H:CRF_DDL_06_03 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE TYPE SUMMARYOBJECT_ARRAY 
AS
  TABLE OF SUMMARYOBJECT;


--changeset Swetha.H:CRF_DDL_06_04 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE TYPE LIST_UNPUBLISHED 
AS
  TABLE OF OBJ_UNPUBLISHED;
