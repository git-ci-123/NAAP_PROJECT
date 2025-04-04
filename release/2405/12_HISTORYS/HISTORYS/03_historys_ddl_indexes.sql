--liquibase formatted sql
--changeset Swetha.H:HISTORYS_DDL_03_1 
--preconditions onFail:HALT onError:HALT

CREATE INDEX IDX_ARFUN_ID ON ARCH_ENTITY_GROUP_FUNCTION (ENTITY_FUNCTION_ID) 
  ;

CREATE INDEX IDX_ARID ON ARCH_ENTITY_GROUP_FUNCTION (RELATED_FUNCTION_ID) 
  ;

CREATE INDEX INDEX_EJP_ARID ON ARCH_ENTITY_JOIN_PARAMETER (ENTITY_FUNCTION_ID) 
  ;


--changeset Swetha.H:HISTORYS_DDL_03_2 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    already_exists EXCEPTION;
    columns_indexed EXCEPTION;
    PRAGMA exception_init ( already_exists,-00955 );
    PRAGMA exception_init ( columns_indexed,-01408 );
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX_ARCH_MAST_PARENT_RT_ID ON ARCH_MASTER_OBJECT_DETAILS(PARENT_ROOT_ID)';
    dbms_output.put_line('Altered');
EXCEPTION
    WHEN already_exists OR columns_indexed THEN
        dbms_output.put_line('skipped');
END;

--changeset Swetha.H:HISTORYS_DDL_03_3 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
    already_exists EXCEPTION;
    columns_indexed EXCEPTION;
    PRAGMA exception_init ( already_exists,-00955 );
    PRAGMA exception_init ( columns_indexed,-01408 );
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX_ARCH_MAST_CREATED_DATE ON ARCH_MASTER_OBJECT_DETAILS(TRUNC(CREATED_DATE))';
    dbms_output.put_line('Altered');
EXCEPTION
    WHEN already_exists OR columns_indexed THEN
        dbms_output.put_line('skipped');
END;


--changeset Swetha.H:HISTORYS_DDL_03_4 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    already_exists EXCEPTION;
    columns_indexed EXCEPTION;
    PRAGMA exception_init ( already_exists,-00955 );
    PRAGMA exception_init ( columns_indexed,-01408 );
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX_ARCH_INS_CREATED_DATE ON ARCH_PROCESS_ENTITY_INSTANCE(TRUNC(CREATED_DATE))';
    dbms_output.put_line('Altered');
EXCEPTION
    WHEN already_exists OR columns_indexed THEN
        dbms_output.put_line('skipped');
END;


--changeset Swetha.H:HISTORYS_DDL_03_5 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    already_exists EXCEPTION;
    columns_indexed EXCEPTION;
    PRAGMA exception_init ( already_exists,-00955 );
    PRAGMA exception_init ( columns_indexed,-01408 );
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX_ARCH_REL_CREATED_DATE ON ARCH_PROCESS_ENTITY_RELATION(TRUNC(CREATED_DATE))';
    dbms_output.put_line('Altered');
EXCEPTION
    WHEN already_exists OR columns_indexed THEN
        dbms_output.put_line('skipped');
END;