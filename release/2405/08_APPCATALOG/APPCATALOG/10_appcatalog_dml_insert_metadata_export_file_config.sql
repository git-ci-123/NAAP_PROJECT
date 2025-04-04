--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DDL_10_01 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<BEGIN
  PROC_API_ROUTING_UPDATE();
--rollback; 
END;
>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_UPDATEBLOCK',str,'L_VC_API_UPDATE_BLOCK','Y','');
dbms_output.put_line('SPOOL_UPDATEBLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<INSERT INTO entity_release_history (
    erh_id,
    entity_id,
    entity_type,
    entity_version,
    group_release_id,
    env_release_number,
    source_environment,
    release_environment,
    release_status,
    created_by,
    created_date
) VALUES (
    erh_id_seq.NEXTVAL,
    ip_process_id,
    (SELECT type FROM process_entity WHERE pid IN (ip_process_id)),
    (SELECT version FROM process_entity WHERE pid IN (ip_process_id)),
    erh_id_seq.CURRVAL,
    (SELECT
    CASE WHEN COUNT(env_release_number) = 0 THEN 1
        ELSE MAX(env_release_number)+1 END cnt
FROM
    entity_release_history
WHERE
        entity_id = ip_process_id
    AND release_environment = ip_release_environment),
    ip_source_environment,
    ip_release_environment,
    'Script Generated',
    'Administrator',
    systimestamp
);>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('ERH_INPUT_INSERT_BLOCK',str,'','N','');
dbms_output.put_line('ERH_INPUT_INSERT_BLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<FOR erh_list IN (
    SELECT
        pe.pid,
        pe.type,
        pe.version
    FROM
        process_entity pe
    WHERE
        pid NOT IN ( ip_process_id )
    START WITH
        pe.pid IN (
            SELECT
                *
            FROM
                TABLE ( ip_lst_ip_process_id )
        )
    CONNECT BY
        PRIOR pe.pid = pe.parent_id
) LOOP
    INSERT INTO entity_release_history (
        erh_id,
        entity_id,
        entity_type,
        entity_version,
        group_release_id,
        env_release_number,
        source_environment,
        release_environment,
        release_status,
        created_by,
        created_date
    ) VALUES (
        erh_id_seq.NEXTVAL,
        erh_list.pid,
        erh_list.type,
        erh_list.version,
        (
            SELECT
                erh_id
            FROM
                entity_release_history
            WHERE
                entity_id IN ( ip_process_id )
                AND env_release_number = (
                    SELECT
                        MAX(env_release_number)
                    FROM
                        entity_release_history
                    WHERE
                            entity_id = ip_process_id
                        AND release_environment = ip_release_environment
                )
                AND release_environment = ip_release_environment
        ),
        (
            SELECT
                MAX(env_release_number)
            FROM
                entity_release_history
            WHERE
                    entity_id = ip_process_id
                AND release_environment = ip_release_environment
        ),
        ip_source_environment,
        ip_release_environment,
        'Script Generated',
        'Administrator',
        systimestamp
    );

    COMMIT;
END LOOP erh_list;
>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('ERH_LIST_INSERT_BLOCK',str,'','N','');
dbms_output.put_line('ERH_LIST_INSERT_BLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_source_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP5',str,'','Y','5');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP5 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_release_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP6',str,'','Y','6');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP6 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_release_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP5',str,'','Y','5');
dbms_output.put_line('METADATASEQCALL_ARG_IP5 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_source_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP4',str,'','Y','4');
dbms_output.put_line('METADATASEQCALL_ARG_IP4 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_source_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP4',str,'','Y','4');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP4 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_release_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP5',str,'','Y','5');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP5 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_release_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP5',str,'','Y','5');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP5 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_source_environment VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP4',str,'','Y','4');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP4 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag, ip_source_environment,ip_release_environment, ip_same_schema_release_flag, ip_is_debug_flag,ip_export_proc_req_flag, ip_related_pid, ip_export_script_type,l_n_exec_ids_exp_time,ip_metadata_entity_type>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_HIERARCHY_EXPORT2',str,'','Y','2');
dbms_output.put_line('METADATA_HIERARCHY_EXPORT2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag, ip_source_environment,ip_release_environment, ip_same_schema_release_flag, ip_is_debug_flag,ip_export_proc_req_flag, ip_related_pid, ip_export_script_type,l_n_exec_ids_exp_time,ip_metadata_entity_type>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_SINGLE_EXPORT2',str,'','Y','2');
dbms_output.put_line('METADATA_SINGLE_EXPORT2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_14 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag, ip_source_environment,ip_release_environment, ip_same_schema_release_flag, ip_is_debug_flag,ip_export_proc_req_flag, ip_related_pid, ip_export_script_type,l_n_exec_ids_exp_time,ip_metadata_entity_type>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_USERDEFINED_EXPORT2',str,'','Y','2');
dbms_output.put_line('METADATA_USERDEFINED_EXPORT2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<0>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PROCESS_COUNT_GATEWAY',str,'L_VC_PROCESS_GATEWAY_CNT','Y','');
dbms_output.put_line('PROCESS_COUNT_GATEWAY Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<spool>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL',str,'L_VC_SPOOL','Y','');
dbms_output.put_line('SPOOL Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_17 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_ERRROLLBACK',str,'L_VC_SPOOL_ERRROLLBACK','Y','');
dbms_output.put_line('SPOOL_ERRROLLBACK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_18 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<01_bacatalog_dml_process_entity_>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_FILENAME',str,'L_VC_SPOOL_FILENAME','Y','');
dbms_output.put_line('SPOOL_FILENAME Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_19 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT USER || ' @ '|| global_name || '    '|| TO_CHAR (SYSDATE, 'dd-MON-yy hh24:MI:ss') AS environment FROM global_name;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_GBL_SELECT',str,'L_VC_SPOOL_GBL_SELECT','Y','');
dbms_output.put_line('SPOOL_GBL_SELECT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_20 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<---=============================================================================>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_LINE',str,'L_VC_SPOOL_LINE','Y','');
dbms_output.put_line('SPOOL_LINE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_21 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<.log>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_LOG',str,'L_VC_SPOOL_LOG','Y','');
dbms_output.put_line('SPOOL_LOG Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<spool off;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_OFF',str,'L_VC_SPOOL_OFF','Y','');
dbms_output.put_line('SPOOL_OFF Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_23 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SET DEFINE OFF>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_SETDEFINE',str,'L_VC_SPOOL_SETDEFINE','Y','');
dbms_output.put_line('SPOOL_SETDEFINE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_24 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SET SCAN OFF>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_SETSCAN',str,'L_VC_SPOOL_SETSCAN','Y','');
dbms_output.put_line('SPOOL_SETSCAN Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_25 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SET SERVEROUTPUT ON>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_SETSERVER',str,'L_VC_SPOOL_SETSERVER','Y','');
dbms_output.put_line('SPOOL_SETSERVER Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_26 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<BEGIN>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SQL_BEGIN',str,'L_VC_SQL_BEGIN','Y','');
dbms_output.put_line('SQL_BEGIN Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_27 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<COMMIT;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SQL_COMMIT',str,'L_VC_SQL_COMMIT','Y','');
dbms_output.put_line('SQL_COMMIT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_28 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<END;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SQL_END',str,'L_VC_SQL_END','Y','');
dbms_output.put_line('SQL_END Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_29 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from table (ip_all_hrchy_process_id)>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('FETCH_IP_HIERARCHY',str,'','Y','');
dbms_output.put_line('FETCH_IP_HIERARCHY Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_30 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_process_id>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('FETCH_IP_SINGLE',str,'','Y','');
dbms_output.put_line('FETCH_IP_SINGLE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_31 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<--changeset metadata:>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('LIQUIBASE_CHANGESET',str,'L_VC_LIQUIBASE_CHANGESET','Y','');
dbms_output.put_line('LIQUIBASE_CHANGESET Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_32 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<--liquibase formatted sql>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('LIQUIBASE_FORMAT',str,'L_VC_LIQUIBASE_FORMAT','Y','');
dbms_output.put_line('LIQUIBASE_FORMAT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_33 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<--preconditions onFail:HALT onError:HALT>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('LIQUIBASE_PRECOND',str,'L_VC_LIQUIBASE_PRECOND','Y','');
dbms_output.put_line('LIQUIBASE_PRECOND Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_34 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< dbms:oracle splitStatements:true endDelimeter:;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('LIQUIBASE_SPLT_STMT',str,'L_VC_LIQUIBASE_SPLT_STMT','Y','');
dbms_output.put_line('LIQUIBASE_SPLT_STMT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_35 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_process_id lst_process_ids>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP1',str,'','Y','1');
dbms_output.put_line('METADATASEQCALL_ARG_IP1 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_36 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP2',str,'','Y','2');
dbms_output.put_line('METADATASEQCALL_ARG_IP2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_37 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_process_id  IN NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQEXPORT_ARG_IP1',str,'','Y','1');
dbms_output.put_line('METADATASEQEXPORT_ARG_IP1 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_38 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type IN VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQEXPORT_ARG_IP2',str,'','Y','2');
dbms_output.put_line('METADATASEQEXPORT_ARG_IP2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_39 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_all_hrchy_process_id lst_process_ids>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQEXPORT_ARG_IP3',str,'','Y','3');
dbms_output.put_line('METADATASEQEXPORT_ARG_IP3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_40 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('ERROR: ' || SQLCODE || ' - ' || sqlerrm);
  dbms_output.put_line(dbms_utility.format_error_backtrace);
  RAISE;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_EXCEPTION_BLOCK',str,'','Y','');
dbms_output.put_line('METADATA_EXPORT_EXCEPTION_BLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_41 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<OP_CLOB_OVER_ALL_TABLE := OP_CLOB_OVER_ALL_TABLE || 'UPDATE process_entity
SET
    parent_id = 0
WHERE
    lifecycle_id IN (
        SELECT
            lifecycle_id
        FROM
            process_entity
        WHERE
            pid ='||to_clob(ip_process_id) || ')
    AND pid NOT IN ('||to_clob(ip_process_id)  ||'
    );'||chr(10);>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_POST_INSERT_BLOCK1',str,'','Y','1');
dbms_output.put_line('METADATA_EXPORT_POST_INSERT_BLOCK1 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_42 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select INBOUND_API_PROFILE into L_VC_INBOUND_API_PROFILE from process_entity_specification where pid in (ip_process_id) ;
/*TM_LNE_TRCK starts*/
l_n_start_export_time :=dbms_utility.get_time;
/*TM_LNE_TRCK ends*/
SELECT
    COUNT(1) into L_VC_PROCESS_GATEWAY_CNT
FROM
    process_entity pe,process_entity_specification pes
WHERE
   pes.data_load_type = 'Inbound'
   and pes.inbound_api_profile in (L_VC_INBOUND_API_PROFILE)
    and pe.pid = pes.pid
    and pe.action_type = 'Gateway View'
    AND pe.pid = (ip_process_id) ;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK',str,'','Y','1');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_43 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<Y>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_TRACE',str,'','Y','');
dbms_output.put_line('METADATA_EXPORT_TRACE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_44 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<0>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PID_VERSION',str,'L_VC_PE_VERSION','Y','');
dbms_output.put_line('PID_VERSION Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_45 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< SELECT
     '_V' || max(version) into l_vc_pe_version
 FROM process_entity where pid = ip_process_id ;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK2',str,'','Y','2');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_46 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag VARCHAR2 DEFAULT 'N'>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP3',str,'','Y','3');
dbms_output.put_line('METADATASEQCALL_ARG_IP3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_47 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP4',str,'','Y','4');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP4 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_48 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_same_schema_release_flag VARCHAR2 DEFAULT 'N'>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP7',str,'','Y','7');
dbms_output.put_line('METADATASEQCALL_ARG_IP7 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_49 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_same_schema_release_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP7',str,'','Y','7');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP7 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_50 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_same_schema_release_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP6',str,'','Y','6');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP6 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_51 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_same_schema_release_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP6',str,'','Y','6');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP6 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_52 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    substr(sys_context('userenv', 'current_schema'), 1, instr(sys_context('userenv', 'current_schema'), '_', 1, 1) - 1) schema_name
    INTO L_VC_SCHEMA_NAME
FROM
    dual;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK3',str,'','Y','3');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_53 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP3',str,'','Y','3');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_54 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_delete_proc_req_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP3',str,'','Y','3');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_55 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT pe.pid
          FROM process_entity pe
          WHERE pe.type IN ('Process Plan','Interface','Sequential Instance','Parallel Instance','Rule','Sub Form','Call Activity Sub Process','Step','Page','Form','Loop','Transaction Sub Process','Section')
            CONNECT BY PRIOR pid = parent_id
            START WITH pid      IN ( ip_process_id )>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('FETCH_IP_USERDEFINED',str,'','Y','');
dbms_output.put_line('FETCH_IP_USERDEFINED Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_56 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<PROC_METADATA_USERDEFINED_EXPORT>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PROCEDURE_NAME_USERDEFINED',str,'','Y','');
dbms_output.put_line('PROCEDURE_NAME_USERDEFINED Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_57 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_process_id  IN NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP1',str,'','Y','1');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP1 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_58 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type IN VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP2',str,'','Y','2');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_59 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<runOnChange:true>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('LIQUIBASE_RUN',str,'L_VC_LIQUIBASE_RUN','N','');
dbms_output.put_line('LIQUIBASE_RUN Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_60 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SET SQLBLANKLINES ON>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_BLANKLINES',str,'L_VC_SPOOL_BLANKLINES','Y','');
dbms_output.put_line('SPOOL_BLANKLINES Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_61 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_process_id  IN NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP1',str,'','Y','1');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP1 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_62 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type IN VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP2',str,'','Y','2');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_63 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_all_hrchy_process_id lst_process_ids>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP3',str,'','Y','3');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_64 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<PROC_METADATA_HIERARCHY_EXPORT>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PROCEDURE_NAME_HIERARCHY',str,'','Y','');
dbms_output.put_line('PROCEDURE_NAME_HIERARCHY Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_65 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<PROC_METADATA_SINGLE_EXPORT>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PROCEDURE_NAME_SINGLE',str,'','Y','');
dbms_output.put_line('PROCEDURE_NAME_SINGLE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_66 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_process_id  IN NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP1',str,'','Y','1');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP1 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_67 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type IN VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP2',str,'','Y','2');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_68 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_SINGLE_EXPORT',str,'','Y','1');
dbms_output.put_line('METADATA_SINGLE_EXPORT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_69 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type,lst_all_hrchy_process_id>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_HIERARCHY_EXPORT',str,'','Y','1');
dbms_output.put_line('METADATA_HIERARCHY_EXPORT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_70 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_script_type>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_USERDEFINED_EXPORT',str,'','Y','1');
dbms_output.put_line('METADATA_USERDEFINED_EXPORT Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_71 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<DECLARE
  IP_PROCESS_ID LST_PROCESS_IDS;
BEGIN
  -- Modify the code to initialize the variable
   IP_PROCESS_ID := LST_PROCESS_IDS(NULL);

  METADATA_SEQ_DELETE(
    IP_PROCESS_ID => IP_PROCESS_ID
  );
--rollback;
END;
/>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('SPOOL_DELETEBLOCK',str,'L_VC_SPOOL_DELETEBLOCK','N','');
dbms_output.put_line('SPOOL_DELETEBLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_72 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<export_script_task(ip_process_id,ip_all_hrchy_process_id, 'LIQUIBASE', ip_delete_proc_req_flag);>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PROCEDURE_CALL_SCRIPT_TASK',str,'','Y','');
dbms_output.put_line('PROCEDURE_CALL_SCRIPT_TASK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_73 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<OP_CLOB_OVER_ALL_TABLE := OP_CLOB_OVER_ALL_TABLE || 'UPDATE parameter_specification pss SET pss.description = substr(pss.description, 1, instr(pss.description, ''['', 1))|| (SELECT latest_sequence FROM
            ( SELECT LISTAGG(param_basic_spec_id, '','') AS param_id, pid,inbound_api_profile, application, ROW_NUMBER() OVER(PARTITION BY inbound_api_profile, application ORDER BY pid) - 1  AS latest_sequence FROM
                    ( SELECT
                            pe.pid, pes.inbound_api_profile,
                            pes.inbound_api_profile_value AS application,
                            ps.param_basic_spec_id, pes.task_description AS label,
                            ps.description  AS prop_key,
                            DENSE_RANK() OVER(PARTITION BY pe.lifecycle_id ORDER BY pe.version DESC ) AS dk
                        FROM
                            business_process_mapping      bpm, business_entity_parameter     bep,
                            parameter_addon_specification pas, parameter_specification       ps,
                            process_entity_specification  pes, process_entity                pe
                        WHERE pe.action_type = ''Gateway View''
                            AND bpm.parent_id = pe.pid
                            AND bep.parent_id = bpm.record_key
                            AND pes.pid = bpm.parent_id
                            AND pas.parent_id = bep.parameter_spec_id
                            AND ps.param_basic_spec_id = pas.parent_id
                    )
                WHERE label = ''default''
                    AND dk = 1 AND prop_key IS NOT NULL
                    AND prop_key LIKE ''%spring.cloud.gateway.routes[%''
                GROUP BY pid, inbound_api_profile, application
            ) WHERE param_id LIKE ''%''|| pss.param_basic_spec_id|| ''%'')|| substr(pss.description, instr(pss.description, '']'', 1), instr(pss.description, '']'', 1))
WHERE
    pss.param_basic_spec_id IN ( SELECT ps.param_basic_spec_id FROM
            parameter_specification   ps, business_entity_parameter bep, business_process_mapping  bpm, (SELECT pid FROM (
                        SELECT DISTINCT pe.pid, DENSE_RANK()OVER(PARTITION BY pe.lifecycle_id ORDER BY pe.version DESC) AS ak
                        FROM
                            parameter_specification   ps, business_entity_parameter bep, business_process_mapping  bpm, (
                                SELECT pe.pid, pe.version, pe.lifecycle_id FROM
                                    process_entity pe, process_entity_specification pes
                                WHERE pe.pid = pes.pid
                                    AND pes.data_load_type = ''Inbound''
                                    AND pe.action_type = ''Gateway View'' AND pe.type = ''Form''
                                    AND pe.process_entity_name <> ''Setting Configuration''
                                    START WITH pe.pid IN ( SELECT pe.pid FROM process_entity pe, process_entity_specification pes
                                        WHERE pes.data_load_type = ''Inbound'' AND pe.type = ''Page''
                                            AND pes.inbound_api_profile IS NOT NULL AND pe.pid = pes.pid
                                            AND pe.action_type = ''Gateway View'' )
                                CONNECT BY PRIOR pe.pid = pe.parent_id )  pe
                        WHERE pe.pid = bpm.parent_id AND bpm.record_key = bep.parent_id
                            AND bep.parameter_spec_id = ps.param_basic_spec_id
                            AND ps.description LIKE ''%spring.cloud.gateway.routes[%'' ) WHERE ak = 1
            )   pe
        WHERE pe.pid = bpm.parent_id
            AND bpm.record_key = bep.parent_id
            AND bep.parameter_spec_id = ps.param_basic_spec_id
            AND ps.description LIKE ''%spring.cloud.gateway.routes[%''
    );'||chr(10);
END IF;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_POST_INSERT_BLOCK3',str,'','N','3');
dbms_output.put_line('METADATA_EXPORT_POST_INSERT_BLOCK3 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_74 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    COUNT(*) INTO  L_VC_INBOUND_COUNT
FROM
    process_entity_specification
WHERE
        pid = IP_PROCESS_ID
    AND data_load_type = 'Inbound';

IF L_VC_INBOUND_COUNT <> 0 THEN
    L_VC_IP_INPUT_TYPE := 'Inbound';
    SELECT
    lifecycle_id
INTO l_vc_ip_lifecycle_id
FROM
    process_entity
WHERE
    pid = ip_process_id ;
ELSE
    L_VC_IP_INPUT_TYPE :=  NULL;
END IF;

SELECT
    COUNT(*)
INTO L_VC_METADATA_ENTITY_TYPE_COUNT
FROM
    process_entity pe,
    business_process_mapping bpm
WHERE
        pe.pid = ip_process_id
    AND bpm.parent_id = pe.pid
    AND pe.type IN ( 'Form' )
    AND bpm.entity_type IN ('Market Offering','Product','CFS','RFS','Resource');
IF L_VC_METADATA_ENTITY_TYPE_COUNT = 0 THEN
    L_VC_IP_METADATA_ENTITY_TYPE := 'Process Plan';
ELSE
    L_VC_IP_METADATA_ENTITY_TYPE := 'Market Offering';
    SELECT
    pe.lifecycle_id INTO l_vc_ip_lifecycle_id
FROM
    process_entity           pe,
    business_process_mapping bpm
WHERE
        bpm.parent_id = pe.pid
    AND pe.pid = ip_process_id;
END IF;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK4',str,'','Y','4');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK4 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_75 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<L_VC_SPOOL_DELETEBLOCK := >' || 'q' || '''' || '<' || q'<DECLARE
  IP_PROCESS_ID LST_PROCESS_IDS;
  IP_INPUT_TYPE VARCHAR2(200);
  IP_API_LIFE_CYCLE_ID LST_PROCESS_IDS;
  IP_METADATA_ENTITY_TYPE VARCHAR2(200);
  IP_IS_DEBUG_FLAG VARCHAR2(200);
BEGIN
  -- Modify the code to initialize the variable
  IP_PROCESS_ID := LST_PROCESS_IDS(NULL);
  IP_INPUT_TYPE :=  >' || '>' || '''' || q'<  || '''' || L_VC_IP_INPUT_TYPE || '''' || >' || 'q' || '''' || '<' ||  q'<  ;
  IP_API_LIFE_CYCLE_ID := LST_PROCESS_IDS ( >' || '>' || '''' || q'< ||  L_VC_IP_LIFECYCLE_ID  || >' ||  'q' || '''' || '<' || q'< ) ;
  IP_METADATA_ENTITY_TYPE := >' || '>' || '''' || q'<  || '''' || L_VC_IP_METADATA_ENTITY_TYPE || '''' || >' || 'q' || '''' || '<' ||  q'<  ;
  IP_IS_DEBUG_FLAG := 'Y';
  METADATA_SEQ_DELETE(
    IP_PROCESS_ID => IP_PROCESS_ID,
    IP_INPUT_TYPE => IP_INPUT_TYPE,
	IP_API_LIFE_CYCLE_ID => IP_API_LIFE_CYCLE_ID,
	IP_METADATA_ENTITY_TYPE => IP_METADATA_ENTITY_TYPE,
    IP_IS_DEBUG_FLAG => IP_IS_DEBUG_FLAG
 );
--rollback; 
END;
>' || '>' || '''' || ';';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK5',str,'','Y','5');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK5 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_76 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< dbms:oracle splitStatements:false endDelimeter:;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('LIQUIBASE_SPLT_STMT_FALSE',str,'L_VC_LIQUIBASE_SPLT_STMT_FALSE','Y','');
dbms_output.put_line('LIQUIBASE_SPLT_STMT_FALSE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_77 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_proc_req_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP9',str,'','Y','9');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP9 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_78 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_related_pid VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP10',str,'','Y','10');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP10 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_79 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_script_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP11',str,'','Y','11');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP11 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_80 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_proc_req_flag VARCHAR2 DEFAULT 'N'>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP9',str,'','Y','9');
dbms_output.put_line('METADATASEQCALL_ARG_IP9 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_81 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_related_pid VARCHAR2 DEFAULT NULL>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP10',str,'','Y','10');
dbms_output.put_line('METADATASEQCALL_ARG_IP10 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_82 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_script_type VARCHAR2 DEFAULT 'Release'>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP11',str,'','Y','11');
dbms_output.put_line('METADATASEQCALL_ARG_IP11 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_83 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_proc_req_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP8',str,'','Y','8');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP8 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_84 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_related_pid VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP9',str,'','Y','9');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP9 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_85 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_script_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP10',str,'','Y','10');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP10 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_86 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_proc_req_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP8',str,'','Y','8');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP8 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_87 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_related_pid VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP9',str,'','Y','9');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP9 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_88 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_export_script_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP10',str,'','Y','10');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP10 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_89 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    Distinct process_entity_name INTO L_VC_SPOOL_QUERY
FROM
    process_entity
WHERE
    pid = IP_PROCESS_ID;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK6',str,'','Y','6');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK6 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_90 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    Distinct lifecycle_id INTO L_N_IP_LIFECYCLE_ID
FROM
    process_entity
WHERE
    pid = IP_PROCESS_ID;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK7',str,'','Y','7');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK7 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_91 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<IF L_VC_PROCESS_GATEWAY_CNT <> 0 THEN

l_vc_script_type := UPPER(ip_script_type);
IF l_vc_script_type = 'LIQUIBASE' THEN 
OP_CLOB_OVER_ALL_TABLE := CASE WHEN ip_export_proc_req_flag = 'N' THEN
(CASE WHEN ip_delete_proc_req_flag = 'N' THEN
(CASE WHEN (ip_same_schema_release_flag = 'Y' AND l_vc_schema_name = 'BACATALOG') OR (ip_same_schema_release_flag = 'N') THEN  
    OP_CLOB_OVER_ALL_TABLE || CHR(10) || L_VC_LIQUIBASE_CHANGESET ||to_char(ip_process_id) ||l_vc_pe_version||'_2 ' || L_VC_LIQUIBASE_SPLT_STMT_FALSE || chr(32) || CHR(10) || L_VC_LIQUIBASE_PRECOND || CHR(10) ||  CHR(10) || L_VC_API_UPDATE_BLOCK || CHR(10)
    ELSE 
    OP_CLOB_OVER_ALL_TABLE || CHR(10) 
END)
ELSE
(CASE WHEN (ip_same_schema_release_flag = 'Y' AND l_vc_schema_name = 'BACATALOG') OR (ip_same_schema_release_flag = 'N') THEN  
    OP_CLOB_OVER_ALL_TABLE || CHR(10) || L_VC_LIQUIBASE_CHANGESET ||to_char(ip_process_id) ||l_vc_pe_version||'_3 ' || L_VC_LIQUIBASE_SPLT_STMT_FALSE || chr(32) || CHR(10) || L_VC_LIQUIBASE_PRECOND || CHR(10) ||  CHR(10) || L_VC_API_UPDATE_BLOCK || CHR(10)
    ELSE 
    OP_CLOB_OVER_ALL_TABLE || CHR(10)
END)
                                 END)
ELSE
(CASE WHEN ip_delete_proc_req_flag = 'N' THEN
(CASE WHEN (ip_same_schema_release_flag = 'Y' AND l_vc_schema_name = 'BACATALOG') OR (ip_same_schema_release_flag = 'N') THEN  
    OP_CLOB_OVER_ALL_TABLE || CHR(10) || L_VC_LIQUIBASE_CHANGESET ||to_char(ip_process_id) ||l_vc_pe_version||'_3 ' || L_VC_LIQUIBASE_SPLT_STMT_FALSE || chr(32) || CHR(10) || L_VC_LIQUIBASE_PRECOND || CHR(10) ||  CHR(10) || L_VC_API_UPDATE_BLOCK || CHR(10)
    ELSE 
    OP_CLOB_OVER_ALL_TABLE || CHR(10)
END)
ELSE
(CASE WHEN (ip_same_schema_release_flag = 'Y' AND l_vc_schema_name = 'BACATALOG') OR (ip_same_schema_release_flag = 'N') THEN  
    OP_CLOB_OVER_ALL_TABLE || CHR(10) || L_VC_LIQUIBASE_CHANGESET ||to_char(ip_process_id) ||l_vc_pe_version||'_4 ' || L_VC_LIQUIBASE_SPLT_STMT_FALSE || chr(32) || CHR(10) || L_VC_LIQUIBASE_PRECOND || CHR(10) ||  CHR(10) || L_VC_API_UPDATE_BLOCK || CHR(10)
    ELSE 
    OP_CLOB_OVER_ALL_TABLE || CHR(10) 
END)
                                END)
END;

ELSIF l_vc_script_type = 'SPOOL' THEN
OP_CLOB_OVER_ALL_TABLE := (CASE WHEN (ip_same_schema_release_flag = 'Y' AND l_vc_schema_name = 'BACATALOG') OR (ip_same_schema_release_flag = 'N') THEN  
    OP_CLOB_OVER_ALL_TABLE || CHR(10) || L_VC_API_UPDATE_BLOCK ||'/'  || CHR(10)
    ELSE 
    OP_CLOB_OVER_ALL_TABLE || CHR(10) END);
END IF;

END IF;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_POST_INSERT_BLOCK2',str,'','Y','2');
dbms_output.put_line('METADATA_EXPORT_POST_INSERT_BLOCK2 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_92 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'< L_VC_SPOOL_EXPORTQUERY  := >' || 'q' || '''' || '<' || q'< SELECT DISTINCT
    pe.pid  INTO IP_EXPORT_ID
FROM
    process_entity pe
WHERE
    pe.process_entity_name IN ( >' || '>' ||  '''' || q'< || '''' ||  L_VC_SPOOL_QUERY || '''' || >' || 'q' || '''' || '<' || q'<)
    AND pe.lifecycle_id = >' || '>' || '''' || q'< || L_N_IP_LIFECYCLE_ID || >' || 'q' || '''' || '<' || q'<
    AND pe.version = (
        SELECT
            MAX(p.version)
        FROM
            process_entity p
        WHERE
            p.lifecycle_id = pe.lifecycle_id
    );>' || '>' || '''' || ';';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK8',str,NULL,'Y',8);
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK8 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_93 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< L_VC_SPOOL_EXPORTBLOCK  :=  >' || 'q' || '''' || '<' || q'< DECLARE
  IP_PROCESS_ID LST_PROCESS_IDS;
  IP_SCRIPT_TYPE VARCHAR2(200);
  IP_DELETE_PROC_REQ_FLAG VARCHAR2(200);
  IP_SOURCE_ENVIRONMENT VARCHAR2(200);
  IP_RELEASE_ENVIRONMENT VARCHAR2(200);
  IP_SAME_SCHEMA_RELEASE_FLAG VARCHAR2(200);
  IP_IS_DEBUG_FLAG VARCHAR2(200);
  IP_EXPORT_PROC_REQ_FLAG VARCHAR2(200);
  IP_RELATED_PID VARCHAR2(200);
  IP_EXPORT_SCRIPT_TYPE VARCHAR2(200);
  IP_EXPORT_ID VARCHAR2(200);
  IP_RELEASE_ENV  VARCHAR2(200);
BEGIN
  /* Modify the code to initialize the variable */
   SELECT user INTO IP_RELEASE_ENV FROM dual;
  >' || '>' || '''' || q'< ||    L_VC_SPOOL_EXPORTQUERY || >' ||  'q' ||  '''' || '<' || q'<

  IP_PROCESS_ID := LST_PROCESS_IDS(IP_EXPORT_ID);
  IP_SCRIPT_TYPE := 'SPOOL';
  IP_DELETE_PROC_REQ_FLAG := 'Y';
  IP_SOURCE_ENVIRONMENT := '';
  IP_RELEASE_ENVIRONMENT := '';
  IP_SAME_SCHEMA_RELEASE_FLAG := 'Y';
  IP_IS_DEBUG_FLAG := '';
  IP_EXPORT_PROC_REQ_FLAG := 'N';
  IP_RELATED_PID :=  >' ||  '>' || '''' ||  q'< ||  IP_PROCESS_ID  || >' || 'q' || '''' || '<' || q'< ;
  IP_EXPORT_SCRIPT_TYPE := 'ROLLBACK';

  PKG_METADATA_DIRECT_SQL_HIERARCHY_EXPORT.PROC_METADATA_SEQ_CALL(
    IP_PROCESS_ID => IP_PROCESS_ID,
    IP_SCRIPT_TYPE => IP_SCRIPT_TYPE,
    IP_DELETE_PROC_REQ_FLAG => IP_DELETE_PROC_REQ_FLAG,
    IP_SOURCE_ENVIRONMENT => IP_SOURCE_ENVIRONMENT,
    IP_RELEASE_ENVIRONMENT => IP_RELEASE_ENVIRONMENT,
    IP_SAME_SCHEMA_RELEASE_FLAG => IP_SAME_SCHEMA_RELEASE_FLAG,
    IP_EXPORT_PROC_REQ_FLAG => IP_EXPORT_PROC_REQ_FLAG,
    IP_RELATED_PID => IP_RELATED_PID,
    IP_EXPORT_SCRIPT_TYPE => IP_EXPORT_SCRIPT_TYPE
  );
--rollback;

EXCEPTION
    WHEN no_data_found THEN
      dbms_output.put_line('There is no existing version for this pid - >' || '>' || '''' || q'< || IP_PROCESS_ID || >'  || '''' || ' - ' || ''''
             || q'< || L_VC_SPOOL_QUERY || >'  || '''' || ' in '  || '''' || ' || '  || 'q' || '''' || '<' ||  q'< ' >' || '>' || '''' || ' || ' || '''' || ' || '  || '''' ||
             q'<  || 'IP_RELEASE_ENV' || >' || 'q' || '''' || '<' || q'< );
      
END;
>' || '>' || '''' || q'<;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK9',str,NULL,'Y',9);
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK9 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_94 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<
SELECT (select rtrim(xmlagg(xmlelement(e,column_value,', ').extract('//text()') ).getclobval(),', ') from table (ip_all_hrchy_process_id)) INTO OP_CLOB_IDS FROM DUAL;
>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK10',str,'','Y','10');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK10 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_95 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< >';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('EXPORT_IDENTIFIER',str,'L_VC_EXPORT_IDENTIFIER','Y','');
dbms_output.put_line('EXPORT_IDENTIFIER Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_96 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
            sys_context('USERENV', 'OS_USER')    client_user,
            to_char(systimestamp,'ddmmyyhhmissss') as export_time
        INTO
            l_vc_export_user,
            l_vc_export_time
        FROM
            dual;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK11',str,'','Y','11');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK11 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_97 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<l_vc_export_identifier := ip_process_id||'_'||l_vc_export_time;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK12',str,'','Y','11');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK12 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_98 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< >';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('EXPORT_USER',str,'L_VC_EXPORT_USER','Y','');
dbms_output.put_line('EXPORT_USER Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_99 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'< >';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('EXPORT_TIME',str,'L_VC_EXPORT_TIME','Y','');
dbms_output.put_line('EXPORT_TIME Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_100 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ( round((dbms_utility.get_time - l_n_start_export_time) / 100, 2) ) / 60
INTO l_n_exec_exp_time
FROM
    dual;
        l_n_tot_time:= ip_l_n_exec_ids_exp_time+l_n_exec_exp_time;
        l_n_tot_time:=round(l_n_tot_time,2);

  INSERT
  INTO metadata_script_export (IP_PID, OP_SCRIPTS, CREATED_DATE,IP_RELATED_PID,SCRIPT_TYPE,EXPORTED_BY,EXPORT_IDENTIFIER,EXPORT_DURATION) VALUES
    (
      ip_process_id,
      OP_CLOB_OVER_ALL_TABLE,
      systimestamp,
      ip_related_pid,
      ip_export_script_type,
      L_VC_EXPORT_USER,
      L_VC_EXPORT_IDENTIFIER,
	  /*TM_LNE_TRCK starts*/
      to_char(l_n_tot_time)||' mins'
	  /*TM_LNE_TRCK ends*/
    );>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_INSERT_BLOCK',str,'','Y','');
dbms_output.put_line('METADATA_EXPORT_INSERT_BLOCK Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_101 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT round( (dbms_utility.get_time - L_N_STARTTIME)/100, 2 ) INTO L_N_EXEC_TIME FROM dual;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_DEBUG',str,'','Y','');
dbms_output.put_line('METADATA_EXPORT_DEBUG Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_102 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<pkg_metadata_export_gen.proc_metadata_debug(ip_execution_id_seq, ip_proc_name, ip_export_logs, ip_debug_dynamic_script, ip_process_id);>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('PROCEDURE_CALL_METADATA_DEBUG',str,'','Y','');
dbms_output.put_line('PROCEDURE_CALL_METADATA_DEBUG Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_103 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<q'<>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('STARTING_QUOTE',str,'','Y','');
dbms_output.put_line('STARTING_QUOTE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_104 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := '>' || '''';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('ENDING_QUOTE',str,'','Y','');
dbms_output.put_line('ENDING_QUOTE Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_105 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_is_debug_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP8',str,'','Y','8');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP8 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_106 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_is_debug_flag VARCHAR2 DEFAULT 'N'>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP8',str,'','Y','8');
dbms_output.put_line('METADATASEQCALL_ARG_IP8 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_107 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_is_debug_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP7',str,'','Y','7');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP7 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_108 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_is_debug_flag VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP7',str,'','Y','7');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP7 Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_109 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<Y>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('IS_UAPM_DELETE_REQD_FLAG',str,'','Y','');
dbms_output.put_line('IS_UAPM_DELETE_REQD_FLAG Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_110 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<N>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE,EXECUTION_ORDER) values ('IS_HISTORY_INSERT_FLAG',str,null,'Y',null);
dbms_output.put_line('IS_HISTORY_INSERT_FLAG Inserted');
commit;
end;

--changeset Swetha.H:APPCATALOG_DDL_10_111 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_l_n_exec_ids_exp_time NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP12',str,'','Y','12');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP12 Inserted');
commit;
end;


--changeset Swetha.H:APPCATALOG_DDL_10_112 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_metadata_entity_type VARCHAR2 DEFAULT 'Process Plan'>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASEQCALL_ARG_IP6',str,'','Y','6');
dbms_output.put_line('METADATASEQCALL_ARG_IP6 Inserted');
commit;
end;



--changeset Swetha.H:APPCATALOG_DDL_10_113 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_l_n_exec_ids_exp_time NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP11',str,'','Y','11');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP11 Inserted');
commit;
end;


--changeset Swetha.H:APPCATALOG_DDL_10_114 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_metadata_entity_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATASINGLEEXPORT_ARG_IP12',str,'','Y','12');
dbms_output.put_line('METADATASINGLEEXPORT_ARG_IP12 Inserted');
commit;
end;


--changeset Swetha.H:APPCATALOG_DDL_10_115 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_metadata_entity_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP12',str,'','Y','12');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP12 Inserted');
commit;
end;


--changeset Swetha.H:APPCATALOG_DDL_10_116 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<IF ip_metadata_entity_type = 'Market Offering' THEN
    BEGIN
        SELECT
            entityid
        INTO l_n_entity_process_id
        FROM
            business_process_mapping
        WHERE
            parent_id = ip_process_id;

    EXCEPTION
        WHEN no_data_found THEN
            NULL;
    END;
END IF;>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATA_EXPORT_PRE_INSERT_BLOCK13',str,'','Y','13');
dbms_output.put_line('METADATA_EXPORT_PRE_INSERT_BLOCK13 Inserted');
commit;
end;


--changeset Swetha.H:APPCATALOG_DDL_10_117 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_l_n_exec_ids_exp_time NUMBER>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAUSERDEFINEDEXPORT_ARG_IP11',str,'','Y','11');
dbms_output.put_line('METADATAUSERDEFINEDEXPORT_ARG_IP11 Inserted');
commit;
end;


--changeset Swetha.H:APPCATALOG_DDL_10_118 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<ip_metadata_entity_type VARCHAR2>';
Insert into METADATA_EXPORT_FILE_CONFIG (METADATA_CONFIG_NAME,METADATA_CONFIG_VALUE,METADATA_CONFIG_VARIABLE,IS_ACTIVE, EXECUTION_ORDER) values ('METADATAHIERARCHYEXPORT_ARG_IP13',str,'','Y','13');
dbms_output.put_line('METADATAHIERARCHYEXPORT_ARG_IP13 Inserted');
commit;
end;
