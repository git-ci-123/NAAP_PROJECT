--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DML_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

declare
v_count NUMBER;

begin
for i in (select distinct me.METADATA_TABLE_NAME  
from metadata_export_table_config me ,user_tables utt  where
utt.table_name=me.METADATA_TABLE_NAME and
not exists (select 1 from user_tab_columns ut where ut.TABLE_NAME=me.METADATA_TABLE_NAME
and ut.column_name='CREATED_DATE') and me.METADATA_TABLE_NAME <>'LIFE_CYCLE_ACTIVITY_METADATA'
)
loop
dbms_output.put_line ('
Alter table ' || i.METADATA_TABLE_NAME ||' ADD (Created_date timestamp default systimestamp );');
EXECUTE IMMEDIATE 'Alter table '||i.METADATA_TABLE_NAME||' ADD (Created_date  timestamp default systimestamp  )';
end loop;
end;


--changeset Vijaysree.S:APPCATALOG_DML_16_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

declare
v_count NUMBER;

begin
for i in (select distinct me.METADATA_TABLE_NAME  
from metadata_export_table_config me ,user_tables utt  where
utt.table_name=me.METADATA_TABLE_NAME and
not exists (select 1 from user_tab_columns ut where ut.TABLE_NAME=me.METADATA_TABLE_NAME
and ut.column_name='CREATED_BY') and me.METADATA_TABLE_NAME <>'LIFE_CYCLE_ACTIVITY_METADATA'
)
loop
dbms_output.put_line ('
Alter table ' || i.METADATA_TABLE_NAME ||' ADD (Created_by varchar2(200) );');
EXECUTE IMMEDIATE 'Alter table '||i.METADATA_TABLE_NAME||' ADD (Created_by varchar2(200)  )';
end loop;
end;


--changeset Vijaysree.S:APPCATALOG_DML_16_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

declare
v_count NUMBER;

begin
for i in (select distinct me.METADATA_TABLE_NAME  
from metadata_export_table_config me ,user_tables utt  where
utt.table_name=me.METADATA_TABLE_NAME and
not exists (select 1 from user_tab_columns ut where ut.TABLE_NAME=me.METADATA_TABLE_NAME
and ut.column_name='MODIFIED_DATE') and me.METADATA_TABLE_NAME <>'LIFE_CYCLE_ACTIVITY_METADATA'
)
loop
dbms_output.put_line ('
Alter table ' || i.METADATA_TABLE_NAME ||' ADD (Modified_date timestamp default systimestamp );');
EXECUTE IMMEDIATE 'Alter table '||i.METADATA_TABLE_NAME||' ADD (Modified_date  timestamp default systimestamp  )';
end loop;
end;


--changeset Vijaysree.S:APPCATALOG_DML_16_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

declare
v_count NUMBER;

begin
for i in (select distinct me.METADATA_TABLE_NAME  
from metadata_export_table_config me ,user_tables utt  where
utt.table_name=me.METADATA_TABLE_NAME and
not exists (select 1 from user_tab_columns ut where ut.TABLE_NAME=me.METADATA_TABLE_NAME
and ut.column_name='MODIFIED_BY') and me.METADATA_TABLE_NAME <>'LIFE_CYCLE_ACTIVITY_METADATA'
)
loop
dbms_output.put_line ('
Alter table ' || i.METADATA_TABLE_NAME ||' ADD (Modified_by varchar2(200) );');
EXECUTE IMMEDIATE 'Alter table '||i.METADATA_TABLE_NAME||' ADD (Modified_by varchar2(200)  )';
end loop;
end;


--changeset Vijaysree.S:APPCATALOG_DML_16_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'PRODUCT_CODE_DETAILS'
        AND COLUMN_NAME IN ( 'LIFECYCLE_ID','VERSION','VERSION_REL_ID');

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PRODUCT_CODE_DETAILS ADD (LIFECYCLE_ID NUMBER,VERSION NUMBER,VERSION_REL_ID NUMBER)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;


--changeset Vijaysree.S:APPCATALOG_DML_16_06 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
    L_CNT NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO L_CNT
    FROM 
        USER_TAB_COLUMNS
    WHERE  
        TABLE_NAME = 'ENTITY_PRODUCT_CODE_MAPPING'
        AND COLUMN_NAME IN ( 'LIFECYCLE_ID','VERSION','VERSION_REL_ID');

    IF L_CNT = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ENTITY_PRODUCT_CODE_MAPPING ADD (LIFECYCLE_ID NUMBER,VERSION NUMBER,VERSION_REL_ID NUMBER)';
		DBMS_OUTPUT.PUT_LINE('Altered');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already exist');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Skipped');
END;

