--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DDL_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

create or replace PACKAGE PKG_METADATA_EXPORT_GEN AS
    PROCEDURE proc_metadata_export_gen (
        ip_export_type   IN VARCHAR2,
        ip_script_format IN VARCHAR2,
        ip_script_type   IN VARCHAR2
    );

    PROCEDURE proc_type_gen;

    PROCEDURE proc_metadata_debug (
        ip_execution_id_seq     NUMBER,
        ip_proc_name            VARCHAR2,
        ip_export_logs          VARCHAR2,
        ip_debug_dynamic_script CLOB,
        ip_process_id           NUMBER
    );

END PKG_METADATA_EXPORT_GEN;




--changeset Vijaysree.S:APPCATALOG_DDL_10_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

create or replace PACKAGE BODY pkg_metadata_export_gen AS

/*
CHANGES HISTORY 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4788          07-05-2024		    Vijaysree.S	  		  BUSINESS_ENTITY_UPD_2024                  Since BUSINESS_ENTITY is not handled in METADATA_SEQ_DELETE PROCEDURE. To update 
																								        latest version of Market Offering in BUSINESS_ENTITY, CASE statement is handled to prepare 
																								        both insert and update statement.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4784          06-05-2024		    Ramalingam.S	  	  TO_RESTRICT_UNWANTED_2024          	    action_process_id is set to 0 in fetch to restict unwanted data in delete list

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4669          08-05-2024		    Swetha.H	          EXPORT_IDENTIFIER_CHANGES_2024            To populate unique IDs(Combination of processplan/page id and dd-mm-yy with seconds) in EXPORT_IDENTIFIER column while releasing processplan/api to identify the records populated in each metadata tables. 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4800          10-05-2024		    Mohanraj.E	  	      AUTH_API_TEMP_REL_2024          	    	AUTHENTICATION API's Template release --> Auth API associated with Outbounds.
																										If Auth api's Template is Re-usable, I won't to be deleted. Its parent_id values in process_entity
																										has the '0' value. It handled by param_spec_id (Parent_id) in parameter_addon_specification table. 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-5500          30-09-2024		    Mohanraj.E	  	      TM_LNE_TRCK          	    	            To track the Timeline calculation of export of each process plan/APIs 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-3992          03-10-2024		    Swetha.H	  	      BUSINESS_ENTITY_RELEASE_2024          	To include business_entity release in SQL and JSON procedure.

*/

    g_vc_linebreak              VARCHAR2(100) := chr(10);
    g_vc_tabspace               VARCHAR2(100) := chr(09);
    g_vc_space                  VARCHAR2(1) := chr(32);
    g_constant_seperator        CONSTANT VARCHAR2(1) := ',';
    g_constant_terminator       CONSTANT VARCHAR2(1) := '.';
    g_constant_single_quote     CONSTANT VARCHAR2(1) := '''';
    g_cons_print_single_quote   CONSTANT VARCHAR2(5) := q'<''''>';
    g_constant_pipe             CONSTANT VARCHAR2(2) := '||';
    g_constant_print_seperator  CONSTANT VARCHAR2(3) := ''',''';
    g_cons_print_start_quote_op CONSTANT VARCHAR2(10) := '''q''''<''';
    g_cons_print_end_quote_op   CONSTANT VARCHAR2(10) := '''>''''''';
    g_cons_print_linebreak      CONSTANT VARCHAR2(10) := q'<CHR(10)>';
    g_cons_print_space          CONSTANT VARCHAR2(10) := q'<chr(32)>';
    g_vc_trace_flag             metadata_export_file_config.metadata_config_value%TYPE;
    g_n_execution_id_seq        NUMBER;

    /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
    CURSOR md_exp_entitytype IS
    SELECT DISTINCT
        metadata_entity_type
    FROM
        metadata_export_table_config
    WHERE
        upper(is_active) = 'Y'
    ORDER BY
        metadata_entity_type;

    CURSOR md_exp_tables (
        ip_metadata_entity_type metadata_export_table_config.metadata_entity_type%TYPE
    ) IS
    SELECT
        *
    FROM
        metadata_export_table_config
    WHERE
            upper(is_active) = 'Y'
        AND metadata_entity_type = ip_metadata_entity_type
    ORDER BY
        metadata_table_seq;
    /*BUSINESS_ENTITY_RELEASE_2024 Ends*/

    CURSOR md_exp_tab_cols (
        ip_table_name           user_tab_columns.table_name%TYPE,
        ip_metadata_entity_type metadata_export_table_config.metadata_entity_type%TYPE
    ) IS
    SELECT
        *
    FROM
        (
            SELECT
                metc.metadata_table_name,
                metc.metadata_table_alias_name,
                metc.metadata_notexist_cond_col,
                utc.column_name,
                utc.data_type,
                utc.data_length,
                utc.data_precision,
                utc.nullable,
                utc.column_id
            FROM
                metadata_export_table_config metc,
                user_tab_columns             utc
            WHERE
                    upper(metc.metadata_table_name) = upper(utc.table_name)
                AND upper(is_active) = 'Y'
                AND upper(metadata_entity_type) = upper(ip_metadata_entity_type)
                AND upper(metc.metadata_table_name) = ip_table_name
            UNION
            SELECT
                metc.metadata_table_name,
                metc.metadata_table_alias_name,
                metc.metadata_notexist_cond_col,
                utc.column_name,
                utc.data_type,
                utc.data_length,
                utc.data_precision,
                utc.nullable,
                utc.column_id
            FROM
                metadata_export_table_config metc,
                all_tab_columns              utc
            WHERE
                    upper(metc.metadata_table_name) = upper(utc.table_name)
                AND upper(is_active) = 'Y'
                AND upper(metadata_entity_type) = upper(ip_metadata_entity_type)
                AND upper(metc.metadata_table_name) = ip_table_name
                AND upper(utc.owner) = (
                    SELECT
                        CASE
                            WHEN 0 != (
                                SELECT
                                    regexp_count(substr(sys_context('userenv', 'current_schema'), instr(sys_context('userenv', 'current_schema'),
                                    '_')), '_') d
                                FROM
                                    dual
                            ) THEN
                                ( 'CIF'
                                  || (
                                    SELECT
                                        substr(sys_context('userenv', 'current_schema'), instr(sys_context('userenv', 'current_schema'),
                                        '_')) d
                                    FROM
                                        dual
                                ) )
                            ELSE
                                'CIF'
                        END statement
                    FROM
                        dual
                )
        )
    ORDER BY
        column_id;

    CURSOR metadata_file_config IS
    SELECT
        *
    FROM
        metadata_export_file_config
    WHERE
        metadata_config_variable IS NOT NULL
        AND upper(is_active) = 'Y';

    FUNCTION func_get_config (
        ip_config_name   metadata_export_file_config.metadata_config_name%TYPE,
        ip_request_type  VARCHAR2,
        ip_default_value metadata_export_file_config.metadata_config_value%TYPE
    ) RETURN metadata_export_file_config.metadata_config_value%TYPE AS
        l_vc_config_value    metadata_export_file_config.metadata_config_value%TYPE;
        l_vc_config_variable metadata_export_file_config.metadata_config_variable%TYPE;
    BEGIN
        IF ip_request_type = 'VALUE' THEN
            SELECT
                metadata_config_value
            INTO l_vc_config_value
            FROM
                metadata_export_file_config
            WHERE
                    metadata_config_name = ip_config_name
                AND upper(is_active) = 'Y'
            ORDER BY
                execution_order ASC;

            RETURN l_vc_config_value;
        ELSIF ip_request_type = 'VARIABLE' THEN
            SELECT
                metadata_config_variable
            INTO l_vc_config_variable
            FROM
                metadata_export_file_config
            WHERE
                    metadata_config_name = ip_config_name
                AND upper(is_active) = 'Y';

            RETURN l_vc_config_variable;
        ELSE
            SELECT
                metadata_config_variable
                || '~'
                || length(metadata_config_value)
                || '~'
                || metadata_config_value
            INTO l_vc_config_value
            FROM
                metadata_export_file_config
            WHERE
                    metadata_config_name = ip_config_name
                AND upper(is_active) = 'Y';

            RETURN l_vc_config_value;
        END IF;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN ip_default_value;
    END func_get_config;

    PROCEDURE proc_trace_log (
        ip_trace_flag     VARCHAR2,
        ip_execution_id   metadata_export_trace.metadata_export_execution_id%TYPE,
        ip_proc_name      metadata_export_trace.metadata_export_proc_name%TYPE,
        ip_logs           metadata_export_trace.metadata_export_logs%TYPE,
        ip_dynamic_script metadata_export_trace.metadata_export_dynamic_script%TYPE
    ) AS
        PRAGMA autonomous_transaction;
    BEGIN
        IF ip_trace_flag = 'Y' OR ip_trace_flag = 'y' THEN
            INSERT INTO metadata_export_trace (
                metadata_export_execution_id,
                metadata_export_proc_name,
                metadata_export_logs,
                metadata_export_dynamic_script,
                metadata_export_execution_time
            ) VALUES (
                ip_execution_id,
                ip_proc_name,
                ip_logs,
                ip_dynamic_script,
                systimestamp
            );

            COMMIT;
        END IF;
    END proc_trace_log;

    PROCEDURE proc_error_log (
        ip_execution_id metadata_export_error.metadata_export_execution_id%TYPE,
        ip_proc_name    metadata_export_error.metadata_export_proc_name%TYPE,
        ip_logs         metadata_export_error.metadata_export_logs%TYPE,
        ip_error_cd     metadata_export_error.metadata_export_error_code%TYPE,
        ip_error_msg    metadata_export_error.metadata_export_error_msg%TYPE
    ) AS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO metadata_export_error (
            metadata_export_execution_id,
            metadata_export_proc_name,
            metadata_export_logs,
            metadata_export_error_code,
            metadata_export_error_msg,
            metadata_export_execution_time
        ) VALUES (
            ip_execution_id,
            ip_proc_name,
            ip_logs,
            ip_error_cd,
            ip_error_msg,
            systimestamp
        );

        COMMIT;
    END proc_error_log;

    PROCEDURE proc_type_gen AS

        CURSOR metadata_tables_list IS
        SELECT
            *
        FROM
            metadata_export_table_config;

        CURSOR metadata_table_column_list (
            ip_table_name user_tab_columns.table_name%TYPE
        ) IS
        SELECT
            table_name,
            column_name,
            data_type
        FROM
            (
                SELECT
                    table_name,
                    column_name,
                    column_id,
                    (
                        CASE
                            WHEN data_type = 'VARCHAR2' THEN
                                data_type
                                || '('
                                || data_length
                                || ')'
                            ELSE
                                data_type
                        END
                    ) AS data_type
                FROM
                    user_tab_columns
                WHERE
                    table_name = upper(ip_table_name)
                UNION
                SELECT
                    table_name,
                    column_name,
                    column_id,
                    (
                        CASE
                            WHEN data_type = 'VARCHAR2' THEN
                                data_type
                                || '('
                                || data_length
                                || ')'
                            ELSE
                                data_type
                        END
                    ) AS data_type
                FROM
                    all_tab_columns
                WHERE
                        table_name = upper(ip_table_name)
                    AND upper(owner) = 'CIF'
                                       || (
                        SELECT
                            substr(sys_context('userenv', 'current_schema'), instr(sys_context('userenv', 'current_schema'), '_'))
                        FROM
                            dual
                    )
            )
        ORDER BY
            column_id;

        l_clob_pkg_typ_gen     CLOB;
        l_clob_typ_drop_script CLOB;
        l_vc_typ_obj_name      user_objects.object_name%TYPE;
        l_vc_typ_list_name     user_objects.object_name%TYPE;
        l_n_obj_cnt            NUMBER;
        c_vc_proc_name         CONSTANT VARCHAR2(20) := 'PROC_TYP_GEN';
    BEGIN
        IF g_n_execution_id_seq IS NULL THEN
            g_n_execution_id_seq := metadata_export_execution_id_seq.nextval;
        END IF;
        g_vc_trace_flag := func_get_config('METADATA_EXPORT_TRACE', 'VALUE', 'N');
        FOR mdtl IN metadata_tables_list LOOP
            l_vc_typ_obj_name := 'TYP_OBJ_' || mdtl.metadata_table_alias_name;
            l_vc_typ_list_name := 'TYP_LST_' || mdtl.metadata_table_alias_name;
            l_clob_pkg_typ_gen := 'CREATE OR REPLACE TYPE'
                                  || g_vc_space
                                  || l_vc_typ_obj_name
                                  || g_vc_linebreak
                                  || 'AS'
                                  || g_vc_linebreak
                                  || 'OBJECT ('
                                  || g_vc_linebreak;

            FOR mdtcl IN metadata_table_column_list(mdtl.metadata_table_name) LOOP
                SELECT
                    COUNT(1)
                INTO l_n_obj_cnt
                FROM
                    user_objects
                WHERE
                    object_name = upper(l_vc_typ_obj_name);

                IF l_n_obj_cnt = 1 THEN
                    BEGIN
                        l_clob_typ_drop_script := 'DROP TYPE ' || l_vc_typ_list_name;
                        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Drop type List'
                                                                                              || g_vc_space
                                                                                              || l_vc_typ_list_name, l_clob_typ_drop_script);

                        EXECUTE IMMEDIATE l_clob_typ_drop_script;
                    EXCEPTION
                        WHEN OTHERS THEN
                            proc_error_log(g_n_execution_id_seq, c_vc_proc_name, 'Error in Drop type List'
                                                                                 || g_vc_space
                                                                                 || l_vc_typ_list_name
                                                                                 || g_vc_linebreak
                                                                                 || dbms_utility.format_error_backtrace, sqlcode, sqlerrm);

                            RAISE;
                    END;

                    BEGIN
                        l_clob_typ_drop_script := 'DROP TYPE ' || l_vc_typ_obj_name;
                        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Drop type Object'
                                                                                              || g_vc_space
                                                                                              || l_vc_typ_obj_name, l_clob_typ_drop_script);

                        EXECUTE IMMEDIATE l_clob_typ_drop_script;
                    EXCEPTION
                        WHEN OTHERS THEN
                            proc_error_log(g_n_execution_id_seq, c_vc_proc_name, 'Error in Drop type Object'
                                                                                 || g_vc_space
                                                                                 || l_vc_typ_obj_name
                                                                                 || g_vc_linebreak
                                                                                 || dbms_utility.format_error_backtrace, sqlcode, sqlerrm);

                            RAISE;
                    END;

                END IF;

                l_clob_pkg_typ_gen := l_clob_pkg_typ_gen
                                      || mdtcl.column_name
                                      || g_vc_tabspace
                                      || mdtcl.data_type
                                      || g_constant_seperator
                                      || g_vc_linebreak;

            END LOOP;

            l_clob_pkg_typ_gen := rtrim(rtrim(l_clob_pkg_typ_gen, g_vc_linebreak), g_constant_seperator)
                                  || ');';
            BEGIN
                dbms_output.put_line('type create --> ' || l_clob_pkg_typ_gen);
                proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Create type object'
                                                                                      || g_vc_space
                                                                                      || l_vc_typ_obj_name, l_clob_pkg_typ_gen);

                EXECUTE IMMEDIATE l_clob_pkg_typ_gen;
            EXCEPTION
                WHEN OTHERS THEN
                    proc_error_log(g_n_execution_id_seq, c_vc_proc_name, 'Error in Create type object'
                                                                         || g_vc_space
                                                                         || l_vc_typ_obj_name
                                                                         || g_vc_linebreak
                                                                         || dbms_utility.format_error_backtrace, sqlcode, sqlerrm);

                    RAISE;
            END;

            l_clob_pkg_typ_gen := 'CREATE OR REPLACE TYPE'
                                  || g_vc_space
                                  || l_vc_typ_list_name
                                  || g_vc_linebreak
                                  || 'AS'
                                  || g_vc_space
                                  || g_vc_linebreak
                                  || 'TABLE OF'
                                  || g_vc_space
                                  || l_vc_typ_obj_name
                                  || ';';

            BEGIN
                proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Create type list'
                                                                                      || g_vc_space
                                                                                      || l_vc_typ_list_name, l_clob_pkg_typ_gen);

                dbms_output.put_line('type list create --> ' || l_clob_pkg_typ_gen);
                EXECUTE IMMEDIATE l_clob_pkg_typ_gen;
            EXCEPTION
                WHEN OTHERS THEN
                    proc_error_log(g_n_execution_id_seq, c_vc_proc_name, 'Error in Create type list'
                                                                         || g_vc_space
                                                                         || l_vc_typ_list_name
                                                                         || g_vc_linebreak
                                                                         || dbms_utility.format_error_backtrace, sqlcode, sqlerrm);

                    RAISE;
            END;

        END LOOP;

    END proc_type_gen;

    PROCEDURE proc_metadata_file_config_gen (
        op_proc_md_file_config_var OUT CLOB
    ) AS
        l_clob_proc_md_file_config_var CLOB;
        l_n_value_length               NUMBER;
    BEGIN
        FOR file_config_var_script IN metadata_file_config LOOP
            l_n_value_length := ceil(length(file_config_var_script.metadata_config_value) / 100) * 100;
            l_clob_proc_md_file_config_var := l_clob_proc_md_file_config_var
                                              || file_config_var_script.metadata_config_variable
                                              || g_vc_tabspace
                                              || 'VARCHAR2('
                                              || l_n_value_length
                                              || ')'
                                              || g_vc_space
                                              || ':='
                                              || g_vc_space
                                              || 'q''<'
                                              || file_config_var_script.metadata_config_value
                                              || '>'''
                                              || ';'
                                              || g_vc_linebreak;

        END LOOP file_config_variable_script;

        op_proc_md_file_config_var := l_clob_proc_md_file_config_var;
    END proc_metadata_file_config_gen;

    PROCEDURE proc_metadata_export_pre_insert_logic (
        op_clob_pre_insert_script_logic OUT CLOB
    ) AS
    BEGIN
        FOR pre_insert_loop IN (
            SELECT
                metadata_config_value
            FROM
                metadata_export_file_config
            WHERE
                metadata_config_name LIKE '%METADATA_EXPORT_PRE_INSERT_BLOCK%'
                AND upper(is_active) = 'Y'
            ORDER BY
                execution_order ASC
        ) LOOP
            op_clob_pre_insert_script_logic := op_clob_pre_insert_script_logic
                                               || pre_insert_loop.metadata_config_value
                                               || g_vc_linebreak;
        END LOOP;
    END proc_metadata_export_pre_insert_logic;

    PROCEDURE proc_metadata_export_post_insert_logic (
        op_clob_post_insert_script_logic OUT CLOB
    ) AS
    BEGIN
        FOR post_insert_loop IN (
            SELECT
                metadata_config_value
            FROM
                metadata_export_file_config
            WHERE
                metadata_config_name LIKE '%METADATA_EXPORT_POST_INSERT_BLOCK%'
                AND upper(is_active) = 'Y'
            ORDER BY
                execution_order ASC
        ) LOOP
            op_clob_post_insert_script_logic := op_clob_post_insert_script_logic
                                                || post_insert_loop.metadata_config_value
                                                || g_vc_linebreak;
        END LOOP;
    END proc_metadata_export_post_insert_logic;

    PROCEDURE metadata_seq_export_arg_builder (
        ip_metadataseqexport_ip_arg IN VARCHAR2,
        op_metadataseqexport_op_arg OUT CLOB
    ) AS
    BEGIN
        FOR i IN (
            SELECT
                metadata_config_value
            FROM
                metadata_export_file_config
            WHERE
                metadata_config_name LIKE ip_metadataseqexport_ip_arg
                AND upper(is_active) = 'Y'
            ORDER BY
                execution_order ASC
        ) LOOP
            op_metadataseqexport_op_arg := op_metadataseqexport_op_arg
                                           || i.metadata_config_value
                                           || g_constant_seperator
                                           || g_vc_linebreak;
        END LOOP;

        op_metadataseqexport_op_arg := rtrim(rtrim(op_metadataseqexport_op_arg, g_vc_linebreak), g_constant_seperator);
    END metadata_seq_export_arg_builder;

    PROCEDURE proc_metadata_script_export_gen (
        ip_proc_script         IN VARCHAR2,
        ip_script_format       IN VARCHAR2,
        op_proc_script_ex_spec OUT CLOB,
        op_proc_script_ex_body OUT CLOB
    ) AS

        l_clob_proc_script_ex_spec       CLOB;
        l_clob_proc_script_ex_body       CLOB;
        l_clob_proc_script_ex_local_var  CLOB;
        l_clob_proc_script_ex_arg        CLOB;
        l_vc_type_name                   VARCHAR2(500);
        l_vc_local_typ                   VARCHAR2(500);
        l_vc_loop_var                    VARCHAR2(500);
        l_vc_local_op_variable           VARCHAR2(500);
        l_clob_column_list               CLOB;
        l_clob_column_list_update        CLOB;
        /*EXPORT_IDENTIFIER_CHANGES_2024 STARTS*/
        l_clob_json_column_list          CLOB;
        /*EXPORT_IDENTIFIER_CHANGES_2024 ENDS*/
        l_clob_column_script             CLOB;
        l_clob_export_loop               CLOB;
        l_clob_condition_block           CLOB;
        l_clob_output_block              CLOB;
        l_clob_output_block_update       CLOB;
        l_clob_script_format_block_start CLOB;
        l_clob_script_format_block_end   CLOB;
        l_clob_file_config_val           CLOB;
        l_vc_main_for_loop_name          CONSTANT VARCHAR2(20) := 'table_export';
        l_vc_overall_var                 CONSTANT VARCHAR2(30) := 'OP_CLOB_OVER_ALL_TABLE';
        l_clob_post_insert_block         CLOB;
        l_clob_pre_insert_block          CLOB;
        l_vc_ip_query                    VARCHAR2(1000);
        l_vc_ip_proc_name                VARCHAR2(1000);
        l_vc_local_op_json_variable      CLOB;
        l_vc_local_op_debug_variable     CLOB;
        l_vc_local_op_debug_cnt_variable CLOB;
    BEGIN
        proc_metadata_file_config_gen(l_clob_file_config_val);
        SELECT
            metadata_config_value
        INTO l_vc_ip_query
        FROM
            metadata_export_file_config
        WHERE
                metadata_config_name = 'FETCH_IP_' || ip_proc_script
            AND upper(is_active) = 'Y';

        /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
        FOR md_entity_type IN md_exp_entitytype LOOP
            l_clob_script_format_block_end := '';
            l_clob_script_format_block_start := '';
        /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
            l_clob_proc_script_ex_local_var := l_vc_overall_var
                                               || g_vc_space
                                               || 'CLOB;'
                                               || g_vc_linebreak;
        /*TM_LNE_TRCK Starts*/
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'l_n_start_export_time'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'l_n_exec_exp_time'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'l_n_tot_time'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
        /*TM_LNE_TRCK Ends*/
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_SCRIPT_TYPE'
                                               || g_vc_space
                                               || 'VARCHAR2(100);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_INBOUND_API_PROFILE'
                                               || g_vc_space
                                               || 'VARCHAR2(100);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_SCHEMA_NAME'
                                               || g_vc_space
                                               || 'VARCHAR2(100);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_N_STARTTIME'
                                               || g_vc_space
                                               || 'NUMBER DEFAULT dbms_utility.get_time;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'l_n_execution_id_seq'
                                               || g_vc_space
                                               || 'NUMBER := metadata_export_execution_id_seq.nextval;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_N_EXEC_TIME'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_INBOUND_COUNT'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_IP_INPUT_TYPE'
                                               || g_vc_space
                                               || 'VARCHAR2(100);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_IP_LIFECYCLE_ID'
                                               || g_vc_space
                                               || 'VARCHAR2(100);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_SPOOL_DELETEBLOCK'
                                               || g_vc_space
                                               || 'VARCHAR2(1000);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_SPOOL_QUERY'
                                               || g_vc_space
                                               || 'VARCHAR2(2000);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_SPOOL_EXPORTQUERY'
                                               || g_vc_space
                                               || 'VARCHAR2(4000);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_SPOOL_EXPORTBLOCK'
                                               || g_vc_space
                                               || 'VARCHAR2(4000);'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_N_IP_LIFECYCLE_ID'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'OP_CLOB_IDS'
                                               || g_vc_space
                                               || 'CLOB;'
                                               || g_vc_linebreak;
            /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_N_ENTITY_PROCESS_ID'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
            /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_METADATA_ENTITY_TYPE_COUNT'
                                               || g_vc_space
                                               || 'NUMBER;'
                                               || g_vc_linebreak;
             l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || 'L_VC_IP_METADATA_ENTITY_TYPE'
                                               || g_vc_space
                                               || 'VARCHAR2(200);'
                                               || g_vc_linebreak;                                   
            l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                               || l_clob_file_config_val
                                               || g_vc_linebreak;

           /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
            l_clob_condition_block := '';
            l_clob_export_loop := '';
            FOR md_tabl_typ IN md_exp_tables(md_entity_type.metadata_entity_type) LOOP
            /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                l_vc_type_name := 'TYP_' || md_tabl_typ.metadata_table_alias_name;
                l_vc_local_typ := 'L_LST_TYP_' || md_tabl_typ.metadata_table_alias_name;
                l_vc_loop_var := md_tabl_typ.metadata_table_alias_name || '_val';
                l_vc_local_op_variable := 'OP_CLOB_' || md_tabl_typ.metadata_table_alias_name;
                l_vc_local_op_json_variable := 'OP_JSON_CLOB_' || md_tabl_typ.metadata_table_alias_name;
                l_vc_local_op_debug_variable := 'OP_DEBUG_CLOB_' || md_tabl_typ.metadata_table_alias_name;
                l_vc_local_op_debug_cnt_variable := 'L_N_CNT_' || md_tabl_typ.metadata_table_alias_name;
                l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                                   || 'TYPE'
                                                   || g_vc_space
                                                   || l_vc_type_name
                                                   || g_vc_space
                                                   || 'IS TABLE OF'
                                                   || g_vc_space
                                                   || md_tabl_typ.metadata_table_name
                                                   || '%ROWTYPE;'
                                                   || g_vc_linebreak;

                l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                                   || l_vc_local_typ
                                                   || g_vc_space
                                                   || l_vc_type_name
                                                   || g_vc_space
                                                   || ';'
                                                   || g_vc_linebreak;

                l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                                   || l_vc_local_op_variable
                                                   || g_vc_space
                                                   || 'CLOB'
                                                   || ';'
                                                   || g_vc_linebreak;

                l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                                   || l_vc_local_op_json_variable
                                                   || g_vc_space
                                                   || 'CLOB'
                                                   || ';'
                                                   || g_vc_linebreak;

                l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                                   || l_vc_local_op_debug_variable
                                                   || g_vc_space
                                                   || 'CLOB'
                                                   || ';'
                                                   || g_vc_linebreak;

                l_clob_proc_script_ex_local_var := l_clob_proc_script_ex_local_var
                                                   || l_vc_local_op_debug_cnt_variable
                                                   || g_vc_space
                                                   || 'NUMBER'
                                                   || ';'
                                                   || g_vc_linebreak;

                IF ip_script_format = 'SQL' THEN
                    l_clob_condition_block := l_clob_condition_block
                                              || g_vc_linebreak
                                              ||
                        CASE
                            WHEN md_tabl_typ.metadata_table_seq = 1 THEN
                                'IF'
                            ELSE 'ELSIF'
                        END
                                              || g_vc_space
                                              || l_vc_main_for_loop_name
                                              || g_constant_terminator
                                              || 'METADATA_TABLE_NAME'
                                              || g_vc_space
                                              || 'IN'
                                              || g_vc_space
                                              || '('
                                              || ''''
                                              || md_tabl_typ.metadata_table_name
                                              || ''''
                                              || g_vc_space
                                              || ')'
                                              || g_vc_space
                                              || 'THEN'
                                              || g_vc_linebreak
                                              || 'g_dt_start_time := SYSTIMESTAMP;'
                                              || g_vc_linebreak
                                              || 'L_N_STARTTIME := dbms_utility.get_time;'
                                              || g_vc_linebreak
                                              || 'SELECT * BULK COLLECT INTO'
                                              || g_vc_linebreak
                                              || l_vc_local_typ
                                              || g_vc_linebreak
                                              || 'FROM'
                                              || g_vc_linebreak
                                              || '('
                                              || g_vc_linebreak
                                              || replace(md_tabl_typ.metadata_fetch_query, 'IP_VALUES', l_vc_ip_query)
                                              || g_vc_linebreak
                                              || ');'
                                              || g_vc_linebreak;
                ELSE
                    IF ip_script_format = 'JSON' THEN
                        l_clob_column_list := '';
            /*EXPORT_IDENTIFIER_CHANGES_2024 STARTS*/
                        l_clob_json_column_list := '';
            /*EXPORT_IDENTIFIER_CHANGES_2024 ENDS*/
                        FOR md_tab_column IN md_exp_tab_cols(md_tabl_typ.metadata_table_name, md_entity_type.metadata_entity_type) LOOP

            /*EXPORT_IDENTIFIER_CHANGES_2024 STARTS*/
                            l_clob_json_column_list := l_clob_json_column_list
                                                       || md_tab_column.column_name
                                                       || g_constant_seperator;
            /*EXPORT_IDENTIFIER_CHANGES_2024 ENDS*/

                            IF
                                md_tab_column.data_type = 'VARCHAR2'
                                AND md_tab_column.data_length = 4000
                            THEN
                                l_clob_column_list := l_clob_column_list
                                                      || ''''
                                                      || md_tab_column.column_name
                                                      || ''''
                                                      || q'< value (select '"'||to_clob(>'
                                                      || md_tab_column.column_name
                                                      || q'<)||'"' from dual)FORMAT JSON >'
                                                      || g_constant_seperator;

                            ELSE
                                l_clob_column_list := l_clob_column_list
                                                      || md_tab_column.column_name
                                                      || g_constant_seperator;
                            END IF;

                        END LOOP md_tab_column;

                        l_clob_column_list := rtrim(l_clob_column_list, g_constant_seperator);
                /*EXPORT_IDENTIFIER_CHANGES_2024 STARTS*/
                        l_clob_json_column_list := rtrim(l_clob_json_column_list, g_constant_seperator);
                /*EXPORT_IDENTIFIER_CHANGES_2024 ENDS*/
                        l_clob_condition_block := l_clob_condition_block
                                                  || g_vc_linebreak
                                                  ||
                            CASE
                                WHEN md_tabl_typ.metadata_table_seq = 1 THEN
                                    'IF'
                                ELSE 'ELSIF'
                            END
                                                  || g_vc_space
                                                  || l_vc_main_for_loop_name
                                                  || g_constant_terminator
                                                  || 'METADATA_TABLE_NAME'
                                                  || g_vc_space
                                                  || 'IN'
                                                  || g_vc_space
                                                  || '('
                                                  || ''''
                                                  || md_tabl_typ.metadata_table_name
                                                  || ''''
                                                  || g_vc_space
                                                  || ')'
                                                  || g_vc_space
                                                  || 'THEN'
                                                  || g_vc_linebreak
                                                  || 'g_dt_start_time := SYSTIMESTAMP;'
                                                  || g_vc_linebreak
                                                  || 'L_N_STARTTIME := dbms_utility.get_time;'
                                                  || g_vc_linebreak
                                                  || 'SELECT '
                                                  || q'<' ">'
                                                  || md_tabl_typ.metadata_table_name
                                                  || q'<" : ' >'
                                                  || g_constant_pipe
                                                  || ' NVL(JSON_ARRAYAGG(JSON_OBJECT('
                                                  || g_vc_space
                                                  || l_clob_column_list
                                                  || g_vc_space
                                                  || 'RETURNING CLOB) FORMAT JSON RETURNING CLOB), '
                                                  || '''[ ]'''
                                                  || ')'
                                                  || g_vc_linebreak
                                                  || g_vc_space
                                                  || g_constant_seperator
                                                  || ' JSON_VALUE(NVL(JSON_ARRAYAGG(JSON_OBJECT('
                                                  || g_vc_space
                                                  || l_clob_column_list
                                                  || g_vc_space
                                                  || 'RETURNING CLOB) FORMAT JSON RETURNING CLOB), '
                                                  || '''[ ]'''
                                                  || ')'
                                                  || q'<, '$.size()' )>'
                                                  || g_vc_linebreak
                                                  || ' INTO'
                                                  || g_vc_space
                                                  || g_vc_linebreak
                                                  || l_vc_local_op_json_variable
                                                  || g_vc_space
                                                  || g_constant_seperator
                                                  || l_vc_local_op_debug_cnt_variable
                                                  || g_vc_linebreak
                                                  || 'FROM'
                                                  || g_vc_linebreak
                                                  || '('
                                                  || g_vc_linebreak
                                    /*EXPORT_IDENTIFIER_CHANGES_2024 STARTS*/
                                                  || 'SELECT '
                                                  || replace(l_clob_json_column_list, 'EXPORT_IDENTIFIER', func_get_config('EXPORT_IDENTIFIER',
                                                  'VARIABLE', ' ')
                                                                                                           || ' AS EXPORT_IDENTIFIER')
                                                  || ' FROM ('
                                                  || g_vc_linebreak
                                    /*EXPORT_IDENTIFIER_CHANGES_2024 ENDS*/
                                                  || replace(md_tabl_typ.metadata_fetch_query, 'IP_VALUES', l_vc_ip_query)
                                                  || g_vc_linebreak
                                                  || '));'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || q'<IF ip_is_debug_flag = 'Y' THEN>'
                                                  || g_vc_linebreak
                                                  || l_vc_local_op_debug_variable
                                                  || ' := '
                                                  || func_get_config('STARTING_QUOTE', 'VALUE', '')
                                                  || replace(md_tabl_typ.metadata_fetch_query, 'IP_VALUES', l_vc_ip_query)
                                                  || ';'
                                                  || func_get_config('ENDING_QUOTE', 'VALUE', '')
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || q'<SELECT replace(replace(replace(>'
                                                  || l_vc_local_op_debug_variable
                                                  || g_constant_seperator
                                                  || g_constant_single_quote
                                                  || l_vc_ip_query
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || q'<OP_CLOB_IDS>'
                                                  || '),'
                                                  || g_constant_single_quote
                                                  || 'l_n_entity_process_id'
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || 'l_n_entity_process_id),'
                                                  || g_constant_single_quote
                                                  || 'ip_process_id'
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || 'ip_process_id)'
                                                  || ' INTO '
                                                  || l_vc_local_op_debug_variable
                                                  || ' FROM dual ;'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('METADATA_EXPORT_DEBUG', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || replace(replace(replace(replace(func_get_config('PROCEDURE_CALL_METADATA_DEBUG',
                                                  'VALUE', ''), 'ip_execution_id_seq', 'l_n_execution_id_seq'), 'ip_proc_name', 'UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(1))'),
                                                  'ip_export_logs', ''''
                                                                                                                                    ||
                                                                                                                                    'Table_Name --> '
                                                                                                                                    ||
                                                                                                                                    md_tabl_typ.
                                                                                                                                    metadata_table_name
                                                                                                                                    ||
                                                                                                                                    ','
                                                                                                                                    ||
                                                                                                                                    ' Execution Time --> '
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    'L_N_EXEC_TIME'
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    ', Query result count --> '
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    l_vc_local_op_debug_cnt_variable),
                                                                                                                                    'ip_debug_dynamic_script',
                                                                                                                                    l_vc_local_op_debug_variable)
                                                  || g_vc_linebreak
                                                  || 'END IF;'
                                                  || g_vc_linebreak;

                    END IF;
                END IF;

                IF ip_script_format = 'SQL' THEN
                    l_clob_output_block := l_vc_local_op_variable
                                           || g_vc_space
                                           || ':='
                                           || g_vc_space
                                           || '''INSERT INTO'
                                           || g_vc_space
                                           || md_tabl_typ.metadata_table_name
                                           || g_vc_space
                                           || '('
                                           || g_vc_space;

                    l_clob_column_script := '';
                    l_clob_column_list := '';
                    FOR md_tab_column IN md_exp_tab_cols(md_tabl_typ.metadata_table_name, md_entity_type.metadata_entity_type) LOOP
                        l_clob_column_list := l_clob_column_list
                                              || md_tab_column.column_name
                                              || g_constant_seperator;
                        IF md_tab_column.data_type = 'VARCHAR2' OR md_tab_column.data_type = 'CLOB' OR md_tab_column.data_type = 'CHAR'
                        THEN
		    /*EXPORT_IDENTIFIER_CHANGES_2024 STARTS*/
                            IF md_tab_column.column_name = 'EXPORT_IDENTIFIER' THEN
                                l_clob_column_script := l_clob_column_script
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || g_cons_print_start_quote_op
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || func_get_config('EXPORT_IDENTIFIER', 'VARIABLE', ' ')
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || g_cons_print_end_quote_op
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || g_constant_print_seperator;

                            ELSE
                                l_clob_column_script := l_clob_column_script
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || g_cons_print_start_quote_op
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || l_vc_local_typ
                                                        || '('
                                                        || l_vc_loop_var
                                                        || ')'
                                                        || g_constant_terminator
                                                        || md_tab_column.column_name
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || g_cons_print_end_quote_op
                                                        || g_vc_space
                                                        || g_constant_pipe
                                                        || g_vc_space
                                                        || g_constant_print_seperator;
                            END IF;
		/*EXPORT_IDENTIFIER_CHANGES_2024 ENDS*/
                        ELSIF md_tab_column.data_type = 'TIMESTAMP(6)' OR md_tab_column.data_type = 'DATE' THEN
                            l_clob_column_script := l_clob_column_script
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || '''to_timestamp('''
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_cons_print_single_quote
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || l_vc_local_typ
                                                    || '('
                                                    || l_vc_loop_var
                                                    || ')'
                                                    || g_constant_terminator
                                                    || md_tab_column.column_name
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_cons_print_single_quote
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_constant_print_seperator
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_cons_print_single_quote
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || '''DD-MM-YY HH:MI:SS.FF AM'''
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_cons_print_single_quote
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || ''')'''
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_constant_print_seperator;
                        ELSIF md_tab_column.data_type = 'NUMBER' THEN
                            l_clob_column_script := l_clob_column_script
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || 'coalesce(to_char('
                                                    || g_vc_space
                                                    || l_vc_local_typ
                                                    || '('
                                                    || l_vc_loop_var
                                                    || ')'
                                                    || g_constant_terminator
                                                    || md_tab_column.column_name
                                                    || q'<),'null')>'
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_constant_print_seperator;
                        ELSE
                            l_clob_column_script := l_clob_column_script
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || l_vc_local_typ
                                                    || '('
                                                    || l_vc_loop_var
                                                    || ')'
                                                    || g_constant_terminator
                                                    || md_tab_column.column_name
                                                    || g_vc_space
                                                    || g_constant_pipe
                                                    || g_vc_space
                                                    || g_constant_print_seperator;
                        END IF;

                    END LOOP md_tab_column;

                    l_clob_column_script := rtrim(l_clob_column_script, g_constant_print_seperator);
                    l_clob_column_list := rtrim(rtrim(l_clob_column_list), g_constant_seperator);
                    l_clob_output_block := l_clob_output_block
                                           || l_clob_column_list
                                           || ')'
                                           || g_vc_linebreak
                                           || 'Select'
                                           || g_vc_space
                                           || ''''
                                           || l_clob_column_script
                                           || g_vc_space
                                           || ''' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM'
                                           || g_vc_space
                                           || md_tabl_typ.metadata_table_name
                                           || g_vc_space
                                           || 'WHERE'''
                                           || g_constant_pipe
                                           || g_vc_space;

                    FOR notexist_cond_loop IN (
                        SELECT
                            regexp_substr(md_tabl_typ.metadata_notexist_cond_col, '[^,]+', 1, level) AS cond_col_name
                        FROM
                            dual
                        CONNECT BY
                            level <= regexp_count(md_tabl_typ.metadata_notexist_cond_col, ',') + 1
                    ) LOOP
                        l_clob_output_block := l_clob_output_block
                                               || ''''
                                               || g_vc_space
                                               || notexist_cond_loop.cond_col_name
                                               || ' '''
                                               || g_constant_pipe
                                               || g_vc_space
                                               || 'CASE WHEN coalesce(to_char('
                                               || l_vc_local_typ
                                               || '('
                                               || l_vc_loop_var
                                               || ')'
                                               || g_constant_terminator
                                               || notexist_cond_loop.cond_col_name
                                               || q'<), 'IS NULL') = 'IS NULL' THEN 'IS NULL' ELSE '= '>'
                                               || g_constant_pipe
                                               || g_vc_space
                                               || g_cons_print_single_quote
                                               || g_vc_space
                                               || g_constant_pipe
                                               || g_vc_space
                                               || l_vc_local_typ
                                               || '('
                                               || l_vc_loop_var
                                               || ')'
                                               || g_constant_terminator
                                               || notexist_cond_loop.cond_col_name
                                               || g_vc_space
                                               || g_constant_pipe
                                               || g_cons_print_single_quote
                                               || ' END'
                                               || g_vc_space
                                               || g_constant_pipe
                                               || g_vc_space
                                               || g_vc_space
                                               || ''' AND'''
                                               || g_constant_pipe
                                               || g_vc_space;
                    END LOOP notexist_cond_loop;

                    l_clob_output_block := rtrim(rtrim(rtrim(l_clob_output_block, g_vc_space), g_constant_pipe), ''' AND''')
                                           || ''');'''
                                           || ';';

                    l_clob_output_block_update := '';
                    IF md_tabl_typ.metadata_is_update = 'Y' THEN
                        l_clob_output_block_update := l_clob_output_block_update
                                                      || g_vc_linebreak
                                                      || l_vc_local_op_variable
                                                      || g_vc_space
                                                      || ':='
                                                      || g_vc_space
                                                      || l_vc_local_op_variable
                                                      || g_vc_space
                                                      || g_constant_pipe
                                                      || g_vc_space
                                                      || g_cons_print_linebreak
                                                      || g_vc_space
                                                      || g_constant_pipe
                                                      || g_vc_space
                                                      || q'<'UPDATE'>'
                                                      || g_vc_space
                                                      || g_constant_pipe
                                                      || g_vc_space
                                                      || g_constant_single_quote
                                                      || g_vc_space
                                                      || md_tabl_typ.metadata_table_name
                                                      || g_vc_space
                                                      || 'SET '
                                                      || g_constant_single_quote
                                                      || g_vc_space
                                                      || g_vc_linebreak
                                                      || g_vc_space
                                                      || g_constant_pipe;

                        l_clob_column_list_update := '';
                        FOR md_tab_column_update IN md_exp_tab_cols(md_tabl_typ.metadata_table_name, md_entity_type.metadata_entity_type)
                        LOOP
                            IF md_tab_column_update.data_type = 'NUMBER' THEN
                                l_clob_column_list_update := l_clob_column_list_update
                                                             || g_constant_single_quote
                                                             || md_tab_column_update.column_name
                                                             || ' = '
                                                             || g_vc_space
                                                             || g_constant_single_quote
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || 'coalesce(to_char('
                                                             || g_vc_space
                                                             || l_vc_local_typ
                                                             || '('
                                                             || l_vc_loop_var
                                                             || ')'
                                                             || g_constant_terminator
                                                             || md_tab_column_update.column_name
                                                             || q'<),'null')>'
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_constant_single_quote
                                                             || g_vc_space
                                                             || g_constant_single_quote
                                                             || g_constant_pipe
                                                             || g_constant_print_seperator
                                                             || g_constant_pipe
                                                             || g_vc_linebreak;

                            ELSIF md_tab_column_update.data_type = 'VARCHAR2' OR md_tab_column_update.data_type = 'CLOB' THEN
                                l_clob_column_list_update := l_clob_column_list_update
                                                             || g_constant_single_quote
                                                             || md_tab_column_update.column_name
                                                             || ' = '
                                                             || g_vc_space
                                                             || g_constant_single_quote
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_cons_print_start_quote_op
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || l_vc_local_typ
                                                             || '('
                                                             || l_vc_loop_var
                                                             || ')'
                                                             || g_constant_terminator
                                                             || md_tab_column_update.column_name
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_cons_print_end_quote_op
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_constant_print_seperator
                                                             || g_constant_pipe
                                                             || g_vc_linebreak;
                            ELSIF md_tab_column_update.data_type = 'TIMESTAMP(6)' OR md_tab_column_update.data_type = 'DATE' THEN
                                l_clob_column_list_update := l_clob_column_list_update
                                                             || g_constant_single_quote
                                                             || md_tab_column_update.column_name
                                                             || ' = '
                                                             || g_vc_space
                                                             || g_constant_single_quote
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || '''to_timestamp('''
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_cons_print_single_quote
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || l_vc_local_typ
                                                             || '('
                                                             || l_vc_loop_var
                                                             || ')'
                                                             || g_constant_terminator
                                                             || md_tab_column_update.column_name
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_cons_print_single_quote
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_constant_print_seperator
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_cons_print_single_quote
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || '''DD-MM-YY HH:MI:SS.FF AM'''
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_cons_print_single_quote
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || ''')'''
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_constant_print_seperator
                                                             || g_constant_pipe
                                                             || g_vc_linebreak;
                            ELSE
                                l_clob_column_list_update := l_clob_column_list_update
                                                             || g_constant_single_quote
                                                             || md_tab_column_update.column_name
                                                             || ' = '
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || l_vc_local_typ
                                                             || '('
                                                             || l_vc_loop_var
                                                             || ')'
                                                             || g_constant_terminator
                                                             || md_tab_column_update.column_name
                                                             || g_vc_space
                                                             || g_constant_pipe
                                                             || g_vc_space
                                                             || g_constant_print_seperator;
                            END IF;
                        END LOOP md_tab_column_update;

                        l_clob_column_list_update := rtrim(rtrim(rtrim(l_clob_column_list_update, g_vc_linebreak), g_constant_pipe), g_constant_print_seperator);

                        l_clob_output_block_update := l_clob_output_block_update
                                                      || l_clob_column_list_update
                                                      || g_vc_space
                                                      || q'<' WHERE'>'
                                                      || g_constant_pipe
                                                      || g_vc_space;

                        FOR notexist_cond_loop_update IN (
                            SELECT
                                regexp_substr(md_tabl_typ.metadata_notexist_cond_col, '[^,]+', 1, level) AS cond_col_name
                            FROM
                                dual
                            CONNECT BY
                                level <= regexp_count(md_tabl_typ.metadata_notexist_cond_col, ',') + 1
                        ) LOOP
                            l_clob_output_block_update := l_clob_output_block_update
                                                          || ''''
                                                          || g_vc_space
                                                          || notexist_cond_loop_update.cond_col_name
                                                          || ' '''
                                                          || g_constant_pipe
                                                          || g_vc_space
                                                          || 'CASE WHEN coalesce(to_char('
                                                          || l_vc_local_typ
                                                          || '('
                                                          || l_vc_loop_var
                                                          || ')'
                                                          || g_constant_terminator
                                                          || notexist_cond_loop_update.cond_col_name
                                                          || q'<), 'IS NULL') = 'IS NULL' THEN 'IS NULL' ELSE '= '>'
                                                          || g_constant_pipe
                                                          || g_vc_space
                                                          || g_cons_print_single_quote
                                                          || g_vc_space
                                                          || g_constant_pipe
                                                          || g_vc_space
                                                          || l_vc_local_typ
                                                          || '('
                                                          || l_vc_loop_var
                                                          || ')'
                                                          || g_constant_terminator
                                                          || notexist_cond_loop_update.cond_col_name
                                                          || g_vc_space
                                                          || g_constant_pipe
                                                          || g_cons_print_single_quote
                                                          || ' END'
                                                          || g_vc_space
                                                          || g_constant_pipe
                                                          || g_vc_space
                                                          || g_vc_space
                                                          || ''' AND'''
                                                          || g_constant_pipe
                                                          || g_vc_space;
                        END LOOP notexist_cond_loop_update;

                        l_clob_output_block_update := rtrim(rtrim(rtrim(l_clob_output_block_update, g_vc_space), g_constant_pipe), ''' AND''')
                                                      || ''';'''
                                                      || ';';

                        l_clob_condition_block := l_clob_condition_block
                                                  || l_vc_local_op_debug_cnt_variable
                                                  || ' := '
                                                  || l_vc_local_typ
                                                  || g_constant_terminator
                                                  || 'COUNT;'
                                                  || g_vc_linebreak
                                                  || 'FOR'
                                                  || g_vc_space
                                                  || l_vc_loop_var
                                                  || g_vc_space
                                                  || 'IN 1..'
                                                  || l_vc_local_typ
                                                  || g_constant_terminator
                                                  || 'COUNT'
                                                  || g_vc_linebreak
                                                  || 'LOOP'
                                                  || g_vc_linebreak
                                                  ||
                            CASE
                                WHEN md_tabl_typ.metadata_table_name NOT IN ( 'BUSINESS_ENTITY' ) THEN
                                    'IF '
                                    || l_vc_local_typ
                                    || '('
                                    || l_vc_loop_var
                                    || ')'
                                    || g_constant_terminator
                                    || q'<IS_UPDATED = 'Yes' THEN>'
                                    || g_vc_linebreak
                                    || l_clob_output_block
                                    || g_vc_linebreak
                                    || l_clob_output_block_update
                                    || g_vc_linebreak
                                    || 'ELSE'
                                    || g_vc_linebreak
                                    || l_clob_output_block
                                    || g_vc_linebreak
                                    || g_vc_linebreak
                                    || 'END IF;'
                                ELSE g_vc_linebreak
                                     || l_clob_output_block
                                     || g_vc_linebreak
                                     || l_clob_output_block_update
                                     || g_vc_linebreak
                            END
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || l_vc_overall_var
                                                  || g_vc_space
                                                  || ':='
                                                  || g_vc_space
                                                  || l_vc_overall_var
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || l_vc_local_op_variable
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || g_cons_print_linebreak
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || 'END LOOP'
                                                  || g_vc_space
                                                  || l_vc_loop_var
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || q'<IF ip_is_debug_flag = 'Y' THEN>'
                                                  || g_vc_linebreak
                                                  || l_vc_local_op_debug_variable
                                                  || ' := '
                                                  || func_get_config('STARTING_QUOTE', 'VALUE', '')
                                                  || replace(md_tabl_typ.metadata_fetch_query, 'IP_VALUES', l_vc_ip_query)
                                                  || ';'
                                                  || func_get_config('ENDING_QUOTE', 'VALUE', '')
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || q'<SELECT replace(replace(replace(>'
                                                  || l_vc_local_op_debug_variable
                                                  || g_constant_seperator
                                                  || g_constant_single_quote
                                                  || l_vc_ip_query
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || q'<OP_CLOB_IDS>'
                                                  || '),'
                                                  || g_constant_single_quote
                                                  || 'l_n_entity_process_id'
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || 'l_n_entity_process_id),'
                                                  || g_constant_single_quote
                                                  || 'ip_process_id'
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || 'ip_process_id)'
                                                  || ' INTO '
                                                  || l_vc_local_op_debug_variable
                                                  || ' FROM dual ;'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('METADATA_EXPORT_DEBUG', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || replace(replace(replace(replace(func_get_config('PROCEDURE_CALL_METADATA_DEBUG',
                                                  'VALUE', ''), 'ip_execution_id_seq', 'l_n_execution_id_seq'), 'ip_proc_name', 'UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(1))'),
                                                  'ip_export_logs', ''''
                                                                                                                                    ||
                                                                                                                                    'Table_Name --> '
                                                                                                                                    ||
                                                                                                                                    md_tabl_typ.
                                                                                                                                    metadata_table_name
                                                                                                                                    ||
                                                                                                                                    ','
                                                                                                                                    ||
                                                                                                                                    ' Execution Time --> '
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    'L_N_EXEC_TIME'
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    ', Query result count --> '
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    l_vc_local_op_debug_cnt_variable),
                                                                                                                                    'ip_debug_dynamic_script',
                                                                                                                                    l_vc_local_op_debug_variable)
                                                  || g_vc_linebreak
                                                  || 'END IF;'
                                                  || g_vc_linebreak;

                    ELSE
                        l_clob_condition_block := l_clob_condition_block
                                                  || l_vc_local_op_debug_cnt_variable
                                                  || ' := '
                                                  || l_vc_local_typ
                                                  || g_constant_terminator
                                                  || 'COUNT;'
                                                  || g_vc_linebreak
                                                  || 'FOR'
                                                  || g_vc_space
                                                  || l_vc_loop_var
                                                  || g_vc_space
                                                  || 'IN 1..'
                                                  || l_vc_local_typ
                                                  || g_constant_terminator
                                                  || 'COUNT'
                                                  || g_vc_linebreak
                                                  || 'LOOP'
                                                  || g_vc_linebreak
                                                  || l_clob_output_block
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || l_vc_overall_var
                                                  || g_vc_space
                                                  || ':='
                                                  || g_vc_space
                                                  || l_vc_overall_var
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || l_vc_local_op_variable
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || g_cons_print_linebreak
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || 'END LOOP'
                                                  || g_vc_space
                                                  || l_vc_loop_var
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || q'<IF ip_is_debug_flag = 'Y' THEN>'
                                                  || g_vc_linebreak
                                                  || l_vc_local_op_debug_variable
                                                  || ' := '
                                                  || func_get_config('STARTING_QUOTE', 'VALUE', '')
                                                  || replace(md_tabl_typ.metadata_fetch_query, 'IP_VALUES', l_vc_ip_query)
                                                  || ';'
                                                  || func_get_config('ENDING_QUOTE', 'VALUE', '')
                                                  || ';'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || q'<SELECT replace(replace(replace(>'
                                                  || l_vc_local_op_debug_variable
                                                  || g_constant_seperator
                                                  || g_constant_single_quote
                                                  || l_vc_ip_query
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || q'<OP_CLOB_IDS>'
                                                  || '),'
                                                  || g_constant_single_quote
                                                  || 'l_n_entity_process_id'
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || 'l_n_entity_process_id),'
                                                  || g_constant_single_quote
                                                  || 'ip_process_id'
                                                  || g_constant_single_quote
                                                  || g_constant_seperator
                                                  || 'ip_process_id)'
                                                  || ' INTO '
                                                  || l_vc_local_op_debug_variable
                                                  || ' FROM dual ;'
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('METADATA_EXPORT_DEBUG', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || replace(replace(replace(replace(func_get_config('PROCEDURE_CALL_METADATA_DEBUG',
                                                  'VALUE', ''), 'ip_execution_id_seq', 'l_n_execution_id_seq'), 'ip_proc_name', 'UTL_CALL_STACK.concatenate_subprogram(UTL_CALL_STACK.subprogram(1))'),
                                                  'ip_export_logs', ''''
                                                                                                                                    ||
                                                                                                                                    'Table_Name --> '
                                                                                                                                    ||
                                                                                                                                    md_tabl_typ.
                                                                                                                                    metadata_table_name
                                                                                                                                    ||
                                                                                                                                    ','
                                                                                                                                    ||
                                                                                                                                    ' Execution Time --> '
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    'L_N_EXEC_TIME'
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    ', Query result count --> '
                                                                                                                                    ||
                                                                                                                                    ''''
                                                                                                                                    ||
                                                                                                                                    g_constant_pipe
                                                                                                                                    ||
                                                                                                                                    l_vc_local_op_debug_cnt_variable),
                                                                                                                                    'ip_debug_dynamic_script',
                                                                                                                                    l_vc_local_op_debug_variable)
                                                  || g_vc_linebreak
                                                  || 'END IF;'
                                                  || g_vc_linebreak;
                    END IF;

                ELSE
                    IF ip_script_format = 'JSON' THEN
                        l_clob_condition_block := l_clob_condition_block
                                                  || g_vc_linebreak
                                                  || l_vc_overall_var
                                                  || g_vc_space
                                                  || ':='
                                                  || g_vc_space
                                                  || l_vc_overall_var
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || l_vc_local_op_json_variable
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || g_constant_print_seperator
                                                  || g_vc_space
                                                  || g_constant_pipe
                                                  || g_vc_space
                                                  || g_cons_print_linebreak
                                                  || ';'
                                                  || g_vc_linebreak;
                    END IF;

                    l_clob_condition_block := l_clob_condition_block || '--DBMS_OUTPUT.PUT_LINE(OP_CLOB_OVER_ALL_TABLE);';
                END IF;

            END LOOP md_tabl_typ;

            l_clob_export_loop := l_clob_export_loop
                                  || 'FOR'
                                  || g_vc_space
                                  || l_vc_main_for_loop_name
                                  || g_vc_space
                                  || 'IN'
                                  || g_vc_space
                                  || '('
                                  /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                                  || 'Select METADATA_TABLE_NAME from metadata_export_table_config where metadata_entity_type = '
                                  || ''''
                                  || md_entity_type.metadata_entity_type
                                  || ''''
                                  || g_vc_space
                                  /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                  || 'order by METADATA_TABLE_SEQ'
                                  || g_vc_linebreak
                                  || ')'
                                  || g_vc_linebreak
                                  || 'LOOP'
                                  || g_vc_linebreak
                                  || l_clob_condition_block
                                  || g_vc_linebreak
                                  || 'END IF;'
                                  || g_vc_linebreak
                                  || 'END LOOP'
                                  || g_vc_space
                                  || l_vc_main_for_loop_name
                                  || ';'
                                  || g_vc_linebreak;

            l_clob_script_format_block_start := l_clob_script_format_block_start
                                                || 'l_vc_script_type := UPPER(ip_script_type);'
                                                || g_vc_linebreak
                                                || q'<IF l_vc_script_type = 'LIQUIBASE' THEN >'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || ':='
                                                || g_vc_space
                                                || q'<CASE WHEN ip_export_proc_req_flag = 'N' THEN>'
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_delete_proc_req_flag = 'N' THEN>'
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || q'<END )>'
                                                || g_vc_linebreak
                                                || q'<ELSE >'
                                                || g_vc_linebreak
                                                || q'< (CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_2'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_2'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'END )
                                                  END )'
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_delete_proc_req_flag = 'N' THEN>'
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_2'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_2'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || q'<END )>'
                                                || g_vc_linebreak
                                                || q'<ELSE >'
                                                || g_vc_linebreak
                                                || q'< (CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_2'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_3'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || q'<ELSE >'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_FORMAT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_1'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_2'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT_FALSE', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_CHANGESET', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'l_vc_pe_version'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '_3'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_SPLT_STMT', 'VARIABLE', 'l_vc_sql_begin')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('LIQUIBASE_PRECOND', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'END )
                                                  END )'
                                                || g_vc_linebreak
                                                || 'END ;'
                                                || g_vc_linebreak;

            l_clob_script_format_block_start := l_clob_script_format_block_start
                                                || q'<ELSIF l_vc_script_type = 'SPOOL' THEN>'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || ':='
                                                || g_vc_space
                                                || q'<CASE WHEN ip_export_proc_req_flag = 'N' THEN>'
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_delete_proc_req_flag = 'N' THEN>'
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || 'replace('
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || q'<, 'bacatalog', lower(L_VC_SCHEMA_NAME))>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || q'<END )>'
                                                || g_vc_linebreak
                                                || q'<ELSE >'
                                                || g_vc_linebreak
                                                || q'< (CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || 'replace('
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || q'<, 'bacatalog', lower(L_VC_SCHEMA_NAME))>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'END )
                                                  END )'
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_delete_proc_req_flag = 'N' THEN>'
                                                || g_vc_linebreak
                                                || q'<(CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || 'replace('
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || q'<, 'bacatalog', lower(L_VC_SCHEMA_NAME))>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || q'<END )>'
                                                || g_vc_linebreak
                                                || q'<ELSE >'
                                                || g_vc_linebreak
                                                || q'< (CASE WHEN ip_same_schema_release_flag = 'N' THEN >'
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'ELSE '
                                                || g_vc_linebreak
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_space
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || 'replace('
                                                || func_get_config('SPOOL_FILENAME', 'VARIABLE', '')
                                                || q'<, 'bacatalog', lower(L_VC_SCHEMA_NAME))>'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || 'ip_process_id'
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LOG', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSERVER', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETDEFINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_BLANKLINES', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_SETSCAN', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_GBL_SELECT', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_LINE', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || func_get_config('SPOOL_ERRROLLBACK', 'VARIABLE', '')
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_EXPORTBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || q'<replace(L_VC_SPOOL_DELETEBLOCK, 'NULL', IP_PROCESS_ID)>'
                                                || g_constant_pipe
                                                || g_constant_single_quote
                                                || '/'
                                                || g_constant_single_quote
                                                || g_vc_space
                                                || g_constant_pipe
                                                || g_vc_space
                                                || g_cons_print_linebreak
                                                || g_vc_linebreak
                                                || 'END )
                                                  END )'
                                                || g_vc_linebreak
                                                || 'END ;'
                                                || g_vc_linebreak;

            l_clob_script_format_block_start := l_clob_script_format_block_start
                                                || 'ELSE'
                                                || g_vc_linebreak
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || ':='
                                                || g_vc_space
                                                || l_vc_overall_var
                                                || g_vc_space
                                                || g_constant_pipe
                                                || '''{'''
                                                || ';'
                                                || g_vc_linebreak;

            l_clob_script_format_block_start := l_clob_script_format_block_start
                                                || 'END IF;'
                                                || g_vc_linebreak;
            l_clob_script_format_block_end := l_clob_script_format_block_end
                                              || g_vc_linebreak
                                              || q'<IF l_vc_script_type = 'LIQUIBASE' THEN >'
                                              || g_vc_linebreak
                                              || l_vc_overall_var
                                              || g_vc_space
                                              || ':='
                                              || g_vc_space
                                              || l_vc_overall_var
                                              || g_vc_space
                                              || g_constant_pipe
                                              || func_get_config('SQL_COMMIT', 'VARIABLE', '')
                                              || ';'
                                              || g_vc_linebreak;

            l_clob_script_format_block_end := l_clob_script_format_block_end
                                              || q'<ELSIF l_vc_script_type = 'SPOOL' THEN>'
                                              || g_vc_linebreak
                                              || l_vc_overall_var
                                              || g_vc_space
                                              || ':='
                                              || g_vc_space
                                              || l_vc_overall_var
                                              || g_vc_space
                                              || g_constant_pipe
                                              || g_vc_space
                                              || func_get_config('SQL_COMMIT', 'VARIABLE', '')
                                              || g_vc_space
                                              || g_constant_pipe
                                              || g_vc_space
                                              || g_cons_print_linebreak
                                              || g_vc_space
                                              || g_constant_pipe
                                              || g_vc_space
                                              || func_get_config('SPOOL_OFF', 'VARIABLE', '')
                                              || ';'
                                              || g_vc_linebreak;

            l_clob_script_format_block_end := l_clob_script_format_block_end
                                              || 'ELSE'
                                              || g_vc_linebreak
                                              || l_vc_overall_var
                                              || g_vc_space
                                              || ':='
                                              || g_vc_space
                                              || l_vc_overall_var
                                              || g_vc_space
                                              || g_constant_pipe
                                              || '''}'''
                                              || g_vc_space
                                              || ';'
                                              || g_vc_linebreak;

            l_clob_script_format_block_end := l_clob_script_format_block_end
                                              || 'END IF;'
                                              || g_vc_linebreak;
            metadata_seq_export_arg_builder('%METADATA'
                                            || ip_proc_script
                                            || 'EXPORT_ARG_%', l_clob_proc_script_ex_arg);
            SELECT
                metadata_config_value
            INTO l_vc_ip_proc_name
            FROM
                metadata_export_file_config
            WHERE
                    metadata_config_name = 'PROCEDURE_NAME_' || ip_proc_script
                AND upper(is_active) = 'Y';

            /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
            l_clob_proc_script_ex_spec := l_clob_proc_script_ex_spec
                                          || g_vc_linebreak
                                          || 'PROCEDURE '
                                          ||
                CASE
                    WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                        l_vc_ip_proc_name
                    WHEN md_entity_type.metadata_entity_type = 'BusinessEntity' THEN
                        l_vc_ip_proc_name || '_BE'
                    WHEN md_entity_type.metadata_entity_type = 'MarketOffering' THEN
                        l_vc_ip_proc_name || '_MO'
                END
            /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                          || '('
                                          || g_vc_linebreak
                                          || l_clob_proc_script_ex_arg
                                          || ');';

            op_proc_script_ex_spec := l_clob_proc_script_ex_spec;
            proc_metadata_export_pre_insert_logic(l_clob_pre_insert_block);
            proc_metadata_export_post_insert_logic(l_clob_post_insert_block);
            IF ip_script_format = 'SQL' THEN
            /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                l_clob_proc_script_ex_body := l_clob_proc_script_ex_body
                                              || g_vc_linebreak
                                              || 'PROCEDURE '
                                              ||
                    CASE
                        WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                            l_vc_ip_proc_name
                        WHEN md_entity_type.metadata_entity_type = 'BusinessEntity' THEN
                            l_vc_ip_proc_name || '_BE'
                        WHEN md_entity_type.metadata_entity_type = 'MarketOffering' THEN
                            l_vc_ip_proc_name || '_MO'
                    END
                    /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                              || '('
                                              || g_vc_linebreak
                                              || l_clob_proc_script_ex_arg
                                              || g_vc_linebreak
                                              || ')'
                                              || g_vc_linebreak
                                              || 'AS'
                                              || g_vc_linebreak
                                              || l_clob_proc_script_ex_local_var
                                              || g_vc_linebreak
                                              || 'BEGIN'
                                              || g_vc_linebreak
                                              ||
                    /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                    CASE
                        WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                            l_clob_pre_insert_block
                        ELSE func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK4', 'VALUE', '')
                             || g_vc_linebreak
                             || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK5', 'VALUE', '')
                             || g_vc_linebreak
                             || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK10', 'VALUE', '')
                             || g_vc_linebreak
                             || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK11', 'VALUE', '')
                             || g_vc_linebreak
                             || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK12', 'VALUE', '')
                             || g_vc_linebreak
                             || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK13', 'VALUE', '')
                    END
                    /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                              || g_vc_linebreak
                                              || l_clob_script_format_block_start
                                              || g_vc_linebreak
                                              || l_clob_export_loop
                                              || g_vc_linebreak
                                              ||
                    /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                    CASE
                        WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                            l_clob_post_insert_block
                    END
                    /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                              || g_vc_linebreak
                                              || l_clob_script_format_block_end
                                              || g_vc_linebreak
                                              || func_get_config('METADATA_EXPORT_INSERT_BLOCK', 'VALUE', '')
                                              || g_vc_linebreak
                                              || func_get_config('SQL_COMMIT', 'VALUE', '')
                                              || g_vc_linebreak
                                              || g_vc_linebreak
                                              || func_get_config('ERH_INPUT_INSERT_BLOCK', 'VALUE', '')
                                              || g_vc_linebreak
                                              || func_get_config('SQL_COMMIT', 'VALUE', '')
                                              || g_vc_linebreak
                                              || g_vc_linebreak
                                              || func_get_config('ERH_LIST_INSERT_BLOCK', 'VALUE', '')
                                              || g_vc_linebreak
                                              || g_vc_linebreak
                                              || func_get_config('PROCEDURE_CALL_SCRIPT_TASK', 'VALUE', '')
                                              || g_vc_linebreak
                                              || g_vc_linebreak
                                              || func_get_config('METADATA_EXPORT_EXCEPTION_BLOCK', 'VALUE', '')
                                              || g_vc_linebreak
                                              || 'END '
                                              ||
                    /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                    CASE
                        WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                            l_vc_ip_proc_name
                        WHEN md_entity_type.metadata_entity_type = 'BusinessEntity' THEN
                            l_vc_ip_proc_name || '_BE'
                        WHEN md_entity_type.metadata_entity_type = 'MarketOffering' THEN
                            l_vc_ip_proc_name || '_MO'
                    END
                    /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                              || ';'
                                              || g_vc_linebreak;

                op_proc_script_ex_body := l_clob_proc_script_ex_body;
            ELSE
                IF ip_script_format = 'JSON' THEN
                /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                    l_clob_proc_script_ex_body := l_clob_proc_script_ex_body
                                                  || g_vc_linebreak
                                                  || 'PROCEDURE '
                                                  ||
                        CASE
                            WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                                l_vc_ip_proc_name
                            WHEN md_entity_type.metadata_entity_type = 'BusinessEntity' THEN
                                l_vc_ip_proc_name || '_BE'
                            WHEN md_entity_type.metadata_entity_type = 'MarketOffering' THEN
                                l_vc_ip_proc_name || '_MO'
                        END
                /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                                  || '('
                                                  || g_vc_linebreak
                                                  || l_clob_proc_script_ex_arg
                                                  || g_vc_linebreak
                                                  || ')'
                                                  || g_vc_linebreak
                                                  || 'AS'
                                                  || g_vc_linebreak
                                                  || l_clob_proc_script_ex_local_var
                                                  || g_vc_linebreak
                                                  || 'BEGIN'
                                                  || g_vc_linebreak
                                                  ||
                        /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                        CASE
                            WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                                l_clob_pre_insert_block
                            ELSE func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK10', 'VALUE', '')
                                 || g_vc_linebreak
                                 || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK11', 'VALUE', '')
                                 || g_vc_linebreak
                                 || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK12', 'VALUE', '')
                                 || g_vc_linebreak
                                 || func_get_config('METADATA_EXPORT_PRE_INSERT_BLOCK13', 'VALUE', '')
                        END
                        /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                                  || g_vc_linebreak
                                                  || l_clob_script_format_block_start
                                                  || g_vc_linebreak
                                                  || l_clob_export_loop
                                                  || g_vc_linebreak
                                                  || l_vc_overall_var
                                                  || ' := '
                                                  || 'rtrim(rtrim('
                                                  || l_vc_overall_var
                                                  || ','
                                                  || g_cons_print_linebreak
                                                  || '),'
                                                  || g_constant_print_seperator
                                                  || ');'
                                                  || g_vc_linebreak
                                                  || l_clob_script_format_block_end
                                                  || g_vc_linebreak
                                                  || func_get_config('METADATA_EXPORT_INSERT_BLOCK', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || func_get_config('SQL_COMMIT', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('ERH_INPUT_INSERT_BLOCK', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || func_get_config('SQL_COMMIT', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('ERH_LIST_INSERT_BLOCK', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('PROCEDURE_CALL_SCRIPT_TASK', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || g_vc_linebreak
                                                  || func_get_config('METADATA_EXPORT_EXCEPTION_BLOCK', 'VALUE', '')
                                                  || g_vc_linebreak
                                                  || 'END '
                                                  ||
                        /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                        CASE
                            WHEN md_entity_type.metadata_entity_type = 'Process Plan' THEN
                                l_vc_ip_proc_name
                            WHEN md_entity_type.metadata_entity_type = 'BusinessEntity' THEN
                                l_vc_ip_proc_name || '_BE'
                            WHEN md_entity_type.metadata_entity_type = 'MarketOffering' THEN
                                l_vc_ip_proc_name || '_MO'
                        END
                        /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                                  || ';'
                                                  || g_vc_linebreak;

                    op_proc_script_ex_body := l_clob_proc_script_ex_body;
                END IF;
            END IF;

        /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
        END LOOP md_entity_type;
        /*BUSINESS_ENTITY_RELEASE_2024 Ends*/

    END proc_metadata_script_export_gen;

    PROCEDURE proc_metadata_arg_builder (
        ip_proc_arg_name  IN VARCHAR2,
        op_proc_ip_op_arg OUT CLOB
    ) AS
    BEGIN
        FOR i IN (
            SELECT
                metadata_config_value
            FROM
                metadata_export_file_config
            WHERE
                metadata_config_name LIKE ip_proc_arg_name
                AND upper(is_active) = 'Y'
            ORDER BY
                execution_order ASC
        ) LOOP
            op_proc_ip_op_arg := op_proc_ip_op_arg
                                 || i.metadata_config_value
                                 || g_constant_seperator
                                 || g_vc_linebreak;
        END LOOP;

        op_proc_ip_op_arg := rtrim(rtrim(op_proc_ip_op_arg, g_vc_linebreak), g_constant_seperator);
    END proc_metadata_arg_builder;

    PROCEDURE proc_metadata_seq_call_gen (
        op_proc_spec OUT CLOB,
        op_proc_body OUT CLOB
    ) AS
        l_clob_proc_seq_call_spec      CLOB;
        l_clob_proc_seq_call_body      CLOB;
        l_clob_proc_seq_call_local_var CLOB;
        l_clob_proc_seq_call_arg       CLOB;
    BEGIN
        proc_metadata_arg_builder('%METADATASEQCALL_ARG_%', l_clob_proc_seq_call_arg);
        l_clob_proc_seq_call_spec := l_clob_proc_seq_call_spec
                                     || 'PROCEDURE proc_metadata_seq_call('
                                     || g_vc_linebreak
                                     || l_clob_proc_seq_call_arg
                                     || ');';
        op_proc_spec := l_clob_proc_seq_call_spec;
        l_clob_proc_seq_call_local_var := l_clob_proc_seq_call_local_var
                                          || 'IP_PROCESS_TYPE  VARCHAR2(50);'
                                          || g_vc_linebreak
                                          || 'v_n_count number:=0;'
                                          || g_vc_linebreak
                                          || 'list_cnt NUMBER;'
                                          || g_vc_linebreak
                                          /*TM_LNE_TRCK starts*/
                                          || 'l_n_start_ids_export_time NUMBER;'
                                          || g_vc_linebreak
                                          || 'l_n_exec_ids_exp_time NUMBER;'
                                          /*TM_LNE_TRCK ends*/
                                          || g_vc_linebreak;

        l_clob_proc_seq_call_body := l_clob_proc_seq_call_body
                                     || 'PROCEDURE proc_metadata_seq_call('
                                     || g_vc_linebreak
                                     || l_clob_proc_seq_call_arg
                                     || ')'
                                     || g_vc_linebreak
                                     || 'AS'
                                     || g_vc_linebreak
                                     || l_clob_proc_seq_call_local_var
                                     || g_vc_linebreak
                                     || 'BEGIN'
                                     || g_vc_linebreak
                                     || q'<lst_ip_process_id :=lst_process_ids();
FOR i IN
  ( SELECT * FROM TABLE ( ip_process_id )
  )
  LOOP
/*dbMS_OUTPUT.PUT_LINE('INSIDE proc_metadata_seq_call'||i.column_value);*/

/*TM_LNE_TRCK starts*/
l_n_start_ids_export_time :=dbms_utility.get_time;
/*TM_LNE_TRCK ends*/

/*BUSINESS_ENTITY_RELEASE_2024 Starts*/
IF ip_metadata_entity_type = 'BusinessEntity' THEN

SELECT
    bid
BULK COLLECT
INTO ip_all_hrchy_bid
FROM
    business_entity
WHERE
    bid IN ( select * from table(ip_process_id) )
UNION
SELECT related_entity_id
FROM 
   business_entity_specification
WHERE
    root_id IN ( select * from table(ip_process_id) );

/*TM_LNE_TRCK starts*/
SELECT
    ( round((dbms_utility.get_time - l_n_start_ids_export_time) / 100, 2) ) / 60
INTO l_n_exec_ids_exp_time
FROM
    dual;
/*TM_LNE_TRCK ends*/

PROC_METADATA_HIERARCHY_EXPORT_BE(i.column_value, ip_script_type,ip_all_hrchy_bid, ip_delete_proc_req_flag, ip_source_environment,ip_release_environment, ip_same_schema_release_flag, ip_is_debug_flag,ip_export_proc_req_flag, ip_related_pid, ip_export_script_type,l_n_exec_ids_exp_time,ip_metadata_entity_type);

ELSIF ip_metadata_entity_type = 'Market Offering' THEN
/*TM_LNE_TRCK starts*/
SELECT
    ( round((dbms_utility.get_time - l_n_start_ids_export_time) / 100, 2) ) / 60
INTO l_n_exec_ids_exp_time
FROM
    dual;
/*TM_LNE_TRCK ends*/
PROC_METADATA_HIERARCHY_EXPORT_MO(i.column_value, ip_script_type,ip_all_hrchy_bid, ip_delete_proc_req_flag, ip_source_environment,ip_release_environment, ip_same_schema_release_flag, ip_is_debug_flag,ip_export_proc_req_flag, ip_related_pid, ip_export_script_type,l_n_exec_ids_exp_time,ip_metadata_entity_type);

ELSE
/*BUSINESS_ENTITY_RELEASE_2024 Ends*/
SELECT max(TYPE) INTO IP_PROCESS_TYPE FROM PROCESS_ENTITY WHERE PID = i.column_value;

IF IP_PROCESS_TYPE = 'Form' THEN

SELECT distinct ENTITY_TYPE
  INTO IP_ENTITY_TYPE
  FROM business_process_mapping
  WHERE parent_id IN
    (i.column_value
    );
    IF IP_ENTITY_TYPE = 'Market Offering' THEN
       -- dbMS_OUTPUT.PUT_LINE('INSIDE proc_metadata_seq_call INSIDE Market Offering'||i.column_value);
    SELECT COUNT(1)
    INTO ip_p_id_cnt
    FROM process_entity
    WHERE NVL(parent_id,0)       = 0
      CONNECT BY prior parent_id =pid
      START WITH pid            IN
      (SELECT pe.parent_id
      FROM business_process_mapping offr,
        BUSINESS_ENTITY_RELATION ber,
        business_process_mapping bpm,
        process_entity pe
      WHERE offr.parent_id IN
        (i.column_value
        )
      AND offr.entityid = ber.PARENT_ID
      AND ber.child_id  = bpm.entityid
      AND bpm.parent_id = pe.pid
      );
    IF ip_p_id_cnt >0 THEN
   -- dbMS_OUTPUT.PUT_LINE('INSIDE proc_metadata_seq_call INSIDE IF ip_p_id_cnt>0'||i.column_value);
      SELECT DISTINCT pid bulk collect
      INTO lst_ip_process_id FROM
      ( SELECT pid
      FROM process_entity
      WHERE NVL(parent_id,0)       = 0
                                and type = 'Form'
        CONNECT BY prior parent_id =pid
        START WITH pid            IN
        (SELECT pe.parent_id
        FROM business_process_mapping offr,
          BUSINESS_ENTITY_RELATION ber,
          business_process_mapping bpm,
          process_entity pe
        WHERE offr.parent_id IN
          (i.column_value
          )
        AND offr.entityid = ber.PARENT_ID
        AND ber.child_id  = bpm.entityid
        AND bpm.parent_id = pe.pid
        )
        UNION
        SELECT pid FROM
        process_entity START WITH pid IN (i.column_value) CONNECT BY PRIOR pid = parent_id);
       --dbMS_OUTPUT.PUT_LINE('INSIDE proc_metadata_seq_call INSIDE IF ip_p_id_cnt>0 END'||i.column_value);
    ELSE
      v_n_count:=v_n_count+1;
      lst_ip_process_id.extend;
      lst_ip_process_id(v_n_count):=i.column_value;
      --dbms_output.put_line('inside count check'||' '||lst_ip_process_id.count);
    END IF;
  ELSE
    v_n_count:=v_n_count+1;
    lst_ip_process_id.extend;
    lst_ip_process_id(v_n_count):=i.column_value;
   -- dbms_output.put_line('inside off check'||' '||lst_ip_process_id.count);
  END IF;

ELSE
    v_n_count:=v_n_count+1;
    lst_ip_process_id.extend;
    lst_ip_process_id(v_n_count):=i.column_value;

END IF;

FOR proc IN
  ( SELECT * FROM TABLE ( lst_ip_process_id )
  )
  LOOP
    v_n_count:=v_n_count+1;
    lst_ip_process_id.extend;
    lst_ip_process_id(v_n_count):=proc.column_value;
    /*DBMS_OUTPUT.PUT_LINE('inside proc loop : '||proc.column_value);*/
    /* TO get the associated process to input process and pass to next loop to get the child entities
    Eg. If we pass API Spec Id as input to release then below query will get the associated process plan id
    */

end loop proc ;
/* DLT_PROC_PERF_MIX - Performance fixes */

SELECT DISTINCT
    pe.pid
BULK COLLECT
INTO lst_all_hrchy_process_id
FROM
    process_entity pe
CONNECT BY
    PRIOR pid = parent_id
 START WITH pid IN (
    SELECT
        *
    FROM
        TABLE ( lst_ip_process_id )
)
UNION
    /* DLT_PROC_PERF_MIX - Performance fixes - To retrieve the process plan id against for main Ib API Spec*/
    /* To get the Process Plan associated against the Releasing Inbound API */
SELECT DISTINCT
    pe.pid
FROM
    (
        SELECT
            pas.action_process_id
        FROM
            process_action_specification pas,
            process_entity               pe
        WHERE
                pas.parent_id = pe.pid
            AND pe.root_id IN (
                SELECT
                    *
                FROM
                    TABLE ( lst_ip_process_id )
            )
            AND pas.parent_id <> pas.action_process_id
            AND pas.action_process_id IS NOT NULL
            AND action_process_id <> 0
    )              peid,
    process_entity pe
 START WITH
    pe.pid = peid.action_process_id
CONNECT BY
    PRIOR pe.pid = pe.parent_id;
/* DLT_PROC_PERF_MIX - Performance fixes */

/*for i in (select * from table(lst_all_hrchy_process_id))
loop
dbms_output.put_line('1st list :'||i.column_value);
end loop i;
dbms_output.put_line('1st list time:'||L_N_EXEC_TIME);*/

/* To get the OUTBOUND_SERVICE_NAME associated to send task against the Releasing Process Plan */
SELECT
    pe.pid bulk collect into lst_ip_loop_process_id
FROM
    process_entity_specification pes,
    process_entity pe
WHERE
    pes.pid IN (select * from table( lst_all_hrchy_process_id))
    AND pes.outbound_service_name IS NOT NULL
    AND pes.outbound_service_name = pe.process_entity_name
    AND pes.task_type IN ( 'Send Task', 'Receive Task' )
    AND pe.type = 'Page'
    AND pe.version = (SELECT max(version) FROM process_entity WHERE lifecycle_id = pe.lifecycle_id)
union
/* To get the OUTBOUND_FAILURE_SERVICE_NAME associated to send task against the Releasing Process Plan */
SELECT
    pe.pid
FROM
    process_entity_specification pes,
    process_entity pe
WHERE
    pes.pid IN (select * from table( lst_all_hrchy_process_id))
    AND pes.OUTBOUND_FAILURE_SERVICE_NAME IS NOT NULL
    AND pes.OUTBOUND_FAILURE_SERVICE_NAME = pe.process_entity_name
    AND pe.type = 'Page'
    AND pes.task_type IN ( 'Send Task', 'Receive Task' )
    AND pe.version = (SELECT max(version) FROM process_entity WHERE lifecycle_id = pe.lifecycle_id)
/* Below logic is to get queue_ids against the Inbound API */
union
SELECT DISTINCT
    pas.action_queue_id
FROM
    process_entity                pe,
    process_action_specification  pas
WHERE
        pe.pid = pas.parent_id
    AND pas.action_queue_id IS NOT NULL
    AND pe.root_id IN ( select * from table (lst_all_hrchy_process_id) );
/* DLT_PROC_PERF_MIX - Performance fixes */
for list_itr in (select * from table(lst_ip_loop_process_id))
loop
lst_all_hrchy_process_id.extend();
lst_all_hrchy_process_id(lst_all_hrchy_process_id.count) :=list_itr.column_value;
end loop list_itr;


/* DLT_PROC_PERF_MIX - Performance fixes */

 /*FOR all_list_loop IN (
        SELECT
            *
        FROM
            TABLE ( lst_ip_loop_process_id )
    ) LOOP
        dbms_output.put_line('lst_ip_loop_process_id input :' || all_list_loop.column_value);
    END LOOP all_list_loop;
*/
/*Below logic for releasing the template details against for process plan which is associated in parameter level with Inbound APIs*/
SELECT
    pas.action_process_id bulk collect into lst_ip_all_process_id
FROM
    process_action_specification pas
WHERE
    pas.parent_id IN ( select * from table (lst_all_hrchy_process_id) )
    AND pas.parent_id <> pas.action_process_id
    AND pas.action_process_id IS NOT NULL
	            /*TO_RESTRICT_UNWANTED_2024 Starts */
                    AND action_process_id <> 0
            /*TO_RESTRICT_UNWANTED_2024 End */
UNION
/*Below logic for releasing the template details against erro end event in rule table */
select distinct template_id from rule where template_id is not null and  parent_rule_id in (select * from table  (lst_all_hrchy_process_id))
UNION
   /*The below logic for retrieve the parameter level process plan to get outbound details*/
/* DLT_PROC_PERF_MIX - Performance fixes 
select pe1.pid from (select distinct pid from process_entity start with pid in (select * from table (lst_ip_loop_process_id)) connect by prior pid = parent_id) pe, process_entity_specification pes,process_entity pe1 where pes.pid=pe.pid and pes.outbound_service_name = pe1.process_entity_name and pes.outbound_service_name is not null
union
select pe1.pid from (select distinct pid from process_entity start with pid in (select * from table (lst_ip_loop_process_id)) connect by prior pid = parent_id) pe, process_entity_specification pes,process_entity pe1 where pes.pid=pe.pid and pes.OUTBOUND_FAILURE_SERVICE_NAME = pe1.process_entity_name and pes.OUTBOUND_FAILURE_SERVICE_NAME is not null
 DLT_PROC_PERF_MIX - Performance fixes*/

SELECT
    pas.action_process_id
FROM
    process_action_specification pas
WHERE
    pas.parent_id IN (
        SELECT
            bep.parameter_spec_id
        FROM
            business_process_mapping  bpm, business_entity_parameter bep
        WHERE
            bpm.parent_id IN ( select * from table (lst_all_hrchy_process_id) )
            AND bep.parent_id = bpm.record_key
    )
    AND pas.parent_id <> pas.action_process_id
    AND pas.action_process_id IS NOT NULL
	            /*TO_RESTRICT_UNWANTED_2024 Starts */
                    AND action_process_id <> 0
            /*TO_RESTRICT_UNWANTED_2024 End */
    /* Below Logic is to get the dummy form data with no child and parent record */
/* The below logic has been commented for to restrict the unrelavented Object data 
SELECT
    pe.pid
FROM
    process_entity        pe,
    entity_group_function eg
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            process_entity p
        WHERE
            p.parent_id = pe.pid
    )
        AND eg.pid = pe.pid
        AND eg.join_pid IN ( select * from table (lst_ip_loop_process_id) )

UNION
*/

    /* Below logic is to get action_queue_id's form */
UNION
SELECT
    pas.action_queue_id
FROM
    process_action_specification pas
WHERE
    pas.parent_id IN ( select * from table (lst_all_hrchy_process_id) )
    AND pas.action_queue_id IS NOT NULL
UNION

SELECT
    pls.chart_id
FROM
    process_layout_specification pls
WHERE
    pls.chart_id IS NOT NULL
    AND pls.chart_id <> 0
    AND pls.parent_id IN ( select * from table (lst_all_hrchy_process_id) )
UNION
SELECT
    templateid
FROM
    (
        SELECT
            pe.root_id                   AS apispecid,
            pas.display_name             AS templatetype,
            to_number(pas.default_value) AS templateid
        FROM
            process_entity                pe,
            business_process_mapping      bpm,
            business_entity_parameter     bep,
            parameter_addon_specification pas
        WHERE
            pe.root_id IN ( select * from table (lst_all_hrchy_process_id) )
            AND pe.process_entity_name = 'Setting Configuration'
            AND pe.pid = bpm.parent_id
            AND bpm.record_key = bep.parent_id
            AND bep.name IN ( 'Outbound Request', 'Outbound Response', 'Inbound Response', 'Inbound Request', 'Error' )
            AND bep.parameter_spec_id = pas.parent_id
    )
UNION

SELECT
    ctm.template_id
FROM
    process_entity pe,
    rule           r,
    custom_template_mapping ctm
WHERE
        ctm.entity_id = r.rule_id
    and r.parent_rule_id = pe.pid
    AND pe.type = 'Rule'
    AND pe.pid IN (SELECT
                            *
                        FROM
                            TABLE ( lst_all_hrchy_process_id )
    )
    And exists (select 1 from process_entity p where ctm.template_id = p.pid)

union
SELECT
    to_number(pas.default_value)
FROM
    business_process_mapping      bpm,
    business_entity_parameter     bep,
    parameter_addon_specification pas
WHERE
        bpm.parent_id in (select * from table (lst_all_hrchy_process_id))
    AND bpm.record_key = bep.parent_id
    AND bep.parameter_spec_id = pas.parent_id
    AND pas.display_name = 'Parent Process Specification'

union

SELECT DISTINCT
    pas.action_queue_id
FROM
    process_entity                pe,
    process_action_specification  pas
WHERE
        pe.pid = pas.parent_id
    AND pas.action_queue_id IS NOT NULL
    AND pe.root_id IN ( select * from table (lst_all_hrchy_process_id) );

/*for i in (select * from table(lst_ip_all_process_id))
loop
dbms_output.enable(100000);
dbms_output.put_line('2nd list :'||i.column_value);
end loop i;
dbms_output.put_line('2nd list time :'||L_N_EXEC_TIME);*/

for list_itr in (select * from table(lst_ip_loop_process_id))
loop
lst_ip_all_process_id.extend();
lst_ip_all_process_id(lst_ip_all_process_id.count) :=list_itr.column_value;
end loop list_itr;

select distinct pid bulk collect into lst_connect_by_ip_process_id from process_entity start with pid in (select * from table (lst_ip_all_process_id)) connect by prior pid = parent_id;

for list_itr in (select * from table(lst_connect_by_ip_process_id))
loop
lst_all_hrchy_process_id.extend();
lst_all_hrchy_process_id(lst_all_hrchy_process_id.count) :=list_itr.column_value;
end loop list_itr;

select distinct pas.action_queue_id bulk collect into lst_queue_pids from process_action_specification pas, process_entity pe where pe.pid in (select * from table (lst_all_hrchy_process_id))
and pe.pid = pas.parent_id and pe.action_type = 'Gateway View' and pe.type = 'Form';

for list_itr in (select * from table(lst_queue_pids))
loop
lst_all_hrchy_process_id.extend();
lst_all_hrchy_process_id(lst_all_hrchy_process_id.count) :=list_itr.column_value;
end loop list_itr;


SELECT
   distinct pe.pid bulk collect into lst_auth_api_id
FROM
    process_entity               pe,
    process_entity_specification pes
WHERE
        pe.pid in (select * from table(lst_all_hrchy_process_id))
    AND pe.pid = pes.pid
    AND pes.data_load_type = 'Authentication';

            SELECT
               distinct templateid bulk collect into lst_auth_temp_id
            FROM
                (
                    SELECT
                        pe.root_id                   AS apispecid,
                        pas.display_name             AS templatetype,
                        to_number(pas.default_value) AS templateid
                    FROM
                        process_entity                pe,
                        business_process_mapping      bpm,
                        business_entity_parameter     bep,
                        parameter_addon_specification pas
                    WHERE
                        pe.root_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_auth_api_id )
                        )
                        AND pe.process_entity_name = 'Setting Configuration'
                        AND pe.pid = bpm.parent_id
                        AND bpm.record_key = bep.parent_id
                        AND bep.name IN ( 'Outbound Request', 'Outbound Response', 'Inbound Response', 'Inbound Request', 'Error' )
                        AND bep.parameter_spec_id = pas.parent_id
                );

for lst_auth_temp_id_loop in (select distinct pid from process_entity start with pid in (select * from table(lst_auth_temp_id)) connect by prior pid = parent_id)
loop
lst_all_hrchy_process_id.extend();
lst_all_hrchy_process_id(lst_all_hrchy_process_id.count) :=lst_auth_temp_id_loop.pid;
end loop lst_auth_temp_id_loop;
for r in (
    select i from (
     select column_value, rownum as i,
        row_number() over (partition by column_value
          order by column_value) as key_rn
      from table(lst_all_hrchy_process_id) t
      )
    where key_rn > 1
  )
  loop
--    dbms_output.put_line('deleting ' || r.i);
    lst_all_hrchy_process_id.delete(r.i);
  end loop;
/*for i in (select * from table(lst_all_hrchy_process_id))
loop
dbms_output.enable(100000);
dbms_output.put_line('Final list :'||i.column_value);
end loop i;
dbms_output.put_line('Final list time :'||L_N_EXEC_TIME);*/
/*TM_LNE_TRCK starts*/
SELECT
    ( round((dbms_utility.get_time - l_n_start_ids_export_time) / 100, 2) ) / 60
INTO l_n_exec_ids_exp_time
FROM
    dual;
/*TM_LNE_TRCK ends*/
>';
--    PROC_METADATA_HIERARCHY_EXPORT( i.column_value,ip_script_type,lst_ip_process_id);
--END LOOP i;>'

        op_proc_body := l_clob_proc_seq_call_body;
    END proc_metadata_seq_call_gen;

    PROCEDURE proc_metadata_export_gen (
        ip_export_type   IN VARCHAR2,
        ip_script_format IN VARCHAR2,
        ip_script_type   IN VARCHAR2
    ) AS

        l_clob_pkg_spec               CLOB;
        l_clob_pkg_body               CLOB;
        l_clob_pkg_typ_create         CLOB;
        l_clob_pkg_global_var         CLOB;
        l_clob_proc_md_seq_spec       CLOB;
        l_clob_proc_md_seq_body       CLOB;
        l_clob_proc_md_script_ex_spec CLOB;
        l_clob_proc_md_script_ex_body CLOB;
        l_clob_proc_script_exp_spec   CLOB;
        l_clob_proc_script_exp_body   CLOB;
        c_vc_proc_name                CONSTANT VARCHAR2(1000) := 'PROC_METADATA_EXPORT_GEN';
    BEGIN
        g_vc_trace_flag := '';
        g_n_execution_id_seq := metadata_export_execution_id_seq.nextval;
        g_vc_trace_flag := func_get_config('METADATA_EXPORT_TRACE', 'VALUE', 'N');
        l_clob_pkg_global_var := l_clob_pkg_global_var
                                 || 'g_dt_start_time TIMESTAMP;'
                                 || g_vc_linebreak
                                 || 'g_dt_end_time   TIMESTAMP;'
                                 || g_vc_linebreak
                                 || 'g_n_duration_s  NUMBER;'
                                 || g_vc_linebreak
                                 || 'IP_ENTITY_TYPE  VARCHAR2(50);'
                                 || g_vc_linebreak
                                 || 'ip_p_id_cnt     NUMBER;'
                                 || g_vc_linebreak
                                 || 'lst_ip_process_id lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak
                                 /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                                 || 'ip_all_hrchy_bid lst_process_ids:=lst_process_ids();'
                                 /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                                 || g_vc_linebreak
                                 || 'lst_ip_all_process_id lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak
                                 || 'lst_ip_loop_process_id lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak
                                 || 'lst_all_hrchy_process_id lst_process_ids:=lst_process_ids();'
                                 /*AUTH_API_TEMP_REL_2024 Starts*/
                                 || g_vc_linebreak
                                 || 'lst_auth_api_id lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak
                                 || 'lst_auth_temp_id lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak
                                 || 'lst_connect_by_ip_process_id lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak
                                 || 'lst_queue_pids lst_process_ids:=lst_process_ids();'
                                 || g_vc_linebreak;
				 /*AUTH_API_TEMP_REL_2024 Ends*/
        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating Global variable for'
                                                                              || g_vc_space
                                                                              || c_vc_proc_name, l_clob_pkg_global_var);

        proc_metadata_seq_call_gen(l_clob_proc_md_seq_spec, l_clob_proc_md_seq_body);
        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating metadata_seq_call_gen spec'
                                                                              || g_vc_space
                                                                              || c_vc_proc_name, l_clob_proc_md_seq_spec);

        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating metadata_seq_call_gen body'
                                                                              || g_vc_space
                                                                              || c_vc_proc_name, l_clob_proc_md_seq_body);

        proc_metadata_script_export_gen(ip_script_type, ip_script_format, l_clob_proc_md_script_ex_spec, l_clob_proc_md_script_ex_body);
        l_clob_proc_script_exp_spec := l_clob_proc_script_exp_spec || l_clob_proc_md_script_ex_spec;
        l_clob_proc_script_exp_body := l_clob_proc_script_exp_body || l_clob_proc_md_script_ex_body;
        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating proc_metadata_seq_export spec'
                                                                              || g_vc_space
                                                                              || c_vc_proc_name, l_clob_proc_script_exp_spec);

        proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating proc_metadata_seq_export body'
                                                                              || g_vc_space
                                                                              || c_vc_proc_name, l_clob_proc_script_exp_body);

        l_clob_pkg_spec := g_vc_linebreak
                           || 'CREATE OR REPLACE PACKAGE PKG_METADATA_'
                           || ip_export_type
                           || '_'
                           || ip_script_format
                           || '_'
                           || ip_script_type
                           || '_EXPORT '
                           || g_vc_linebreak;

        l_clob_pkg_spec := l_clob_pkg_spec
                           || 'AS '
                           || g_vc_linebreak;
        l_clob_pkg_spec := l_clob_pkg_spec
                           || l_clob_proc_md_seq_spec
                           || g_vc_linebreak
                           || l_clob_proc_script_exp_spec
                           || g_vc_linebreak;
        l_clob_pkg_spec := l_clob_pkg_spec
                           || g_vc_linebreak
                           || 'END PKG_METADATA_'
                           || ip_export_type
                           || '_'
                           || ip_script_format
                           || '_'
                           || ip_script_type
                           || '_EXPORT;'
                           || g_vc_linebreak;

        l_clob_pkg_body := g_vc_linebreak
                           || 'CREATE OR REPLACE PACKAGE BODY PKG_METADATA_'
                           || ip_export_type
                           || '_'
                           || ip_script_format
                           || '_'
                           || ip_script_type
                           || '_EXPORT '
                           || g_vc_linebreak;

        l_clob_pkg_body := l_clob_pkg_body
                           || 'AS '
                           || g_vc_linebreak
                           || l_clob_pkg_global_var
                           || g_vc_linebreak
                           || l_clob_proc_md_seq_body
                           || g_vc_linebreak
                           || func_get_config('PROCEDURE_NAME_' || ip_script_type, 'VALUE', '')
                           || '(i.column_value, '
                           || func_get_config('METADATA_'
                                              || ip_script_type
                                              || '_EXPORT', 'VALUE', '')
                           || ', '
                           || func_get_config('METADATA_'
                                              || ip_script_type
                                              || '_EXPORT2', 'VALUE', '')
                           || ');'
                           || g_vc_linebreak
                           /*BUSINESS_ENTITY_RELEASE_2024 Starts*/
                           || 'END IF;'
                           || g_vc_linebreak
                           /*BUSINESS_ENTITY_RELEASE_2024 Ends*/
                           || 'END LOOP i;'
                           || g_vc_linebreak
                           || 'END proc_metadata_seq_call;'
                           || g_vc_linebreak
                           || g_vc_linebreak
                           || l_clob_proc_script_exp_body;

        l_clob_pkg_body := l_clob_pkg_body
                           || g_vc_linebreak
                           || 'END PKG_METADATA_'
                           || ip_export_type
                           || '_'
                           || ip_script_format
                           || '_'
                           || ip_script_type
                           || '_EXPORT;'
                           || g_vc_linebreak;

        BEGIN
            proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating main package spec package Name:'
                                                                                  || g_vc_space
                                                                                  || c_vc_proc_name, l_clob_pkg_spec);

            EXECUTE IMMEDIATE l_clob_pkg_spec;
        EXCEPTION
            WHEN OTHERS THEN
                proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Error in executing package spec - package Name:'
                                                                                      || g_vc_space
                                                                                      || c_vc_proc_name, l_clob_pkg_spec);

                proc_error_log(g_n_execution_id_seq, c_vc_proc_name, 'Error in executing package spec - package Name:'
                                                                     || g_vc_space
                                                                     || c_vc_proc_name
                                                                     || g_vc_linebreak
                                                                     || dbms_utility.format_error_backtrace, sqlcode, sqlerrm);

                RAISE;
        END;

        BEGIN
            proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Generating main package body package Name:'
                                                                                  || g_vc_space
                                                                                  || c_vc_proc_name, l_clob_pkg_body);

            EXECUTE IMMEDIATE l_clob_pkg_body;
        EXCEPTION
            WHEN OTHERS THEN
                proc_trace_log(g_vc_trace_flag, g_n_execution_id_seq, c_vc_proc_name, 'Error in executing package body - package Name:'
                                                                                      || g_vc_space
                                                                                      || c_vc_proc_name, l_clob_pkg_body);

                proc_error_log(g_n_execution_id_seq, c_vc_proc_name, 'Error in executing package body - package Name:'
                                                                     || g_vc_space
                                                                     || c_vc_proc_name
                                                                     || g_vc_linebreak
                                                                     || dbms_utility.format_error_backtrace, sqlcode, sqlerrm);

                RAISE;
        END;

    END proc_metadata_export_gen;

    PROCEDURE proc_metadata_debug (
        ip_execution_id_seq     NUMBER,
        ip_proc_name            VARCHAR2,
        ip_export_logs          VARCHAR2,
        ip_debug_dynamic_script CLOB,
        ip_process_id           NUMBER
    ) AS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO metadata_export_trace (
            metadata_export_execution_id,
            metadata_export_proc_name,
            metadata_export_logs,
            metadata_export_dynamic_script,
            metadata_export_execution_time,
            metadata_execution_pid
        ) VALUES (
            ip_execution_id_seq,
            ip_proc_name,
            ip_export_logs,
            ip_debug_dynamic_script,
            systimestamp,
            ip_process_id
        );

        COMMIT;
    END proc_metadata_debug;

END pkg_metadata_export_gen;



--changeset Vijaysree.S:APPCATALOG_DDL_10_03 splitStatements:true
--preconditions onFail:HALT onError:HALT

ALTER PACKAGE PKG_METADATA_EXPORT_GEN COMPILE ;
ALTER PACKAGE PKG_METADATA_EXPORT_GEN COMPILE BODY;


--changeset Swetha.H:APPCATALOG_DDL_10_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  IP_EXPORT_TYPE VARCHAR2(200);
  IP_SCRIPT_FORMAT VARCHAR2(200);
  IP_SCRIPT_TYPE VARCHAR2(200);
BEGIN
  IP_EXPORT_TYPE := 'DIRECT';
  IP_SCRIPT_FORMAT := 'JSON';
  IP_SCRIPT_TYPE := 'HIERARCHY';

  PKG_METADATA_EXPORT_GEN.PROC_METADATA_EXPORT_GEN(
    IP_EXPORT_TYPE => IP_EXPORT_TYPE,
    IP_SCRIPT_FORMAT => IP_SCRIPT_FORMAT,
    IP_SCRIPT_TYPE => IP_SCRIPT_TYPE
  );
--rollback;
END;




--changeset Vijaysree.S:APPCATALOG_DDL_10_05 splitStatements:true
--preconditions onFail:HALT onError:HALT

ALTER PACKAGE PKG_METADATA_DIRECT_JSON_HIERARCHY_EXPORT COMPILE ;
ALTER PACKAGE PKG_METADATA_DIRECT_JSON_HIERARCHY_EXPORT COMPILE BODY;


--changeset Vijaysree.S:APPCATALOG_DDL_10_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  IP_EXPORT_TYPE VARCHAR2(200);
  IP_SCRIPT_FORMAT VARCHAR2(200);
  IP_SCRIPT_TYPE VARCHAR2(200);
BEGIN
  IP_EXPORT_TYPE := 'DIRECT';
  IP_SCRIPT_FORMAT := 'SQL';
  IP_SCRIPT_TYPE := 'HIERARCHY';

  PKG_METADATA_EXPORT_GEN.PROC_METADATA_EXPORT_GEN(
    IP_EXPORT_TYPE => IP_EXPORT_TYPE,
    IP_SCRIPT_FORMAT => IP_SCRIPT_FORMAT,
    IP_SCRIPT_TYPE => IP_SCRIPT_TYPE
  );
--rollback;
END;


--changeset Vijaysree.S:APPCATALOG_DDL_10_07 splitStatements:true
--preconditions onFail:HALT onError:HALT


ALTER PACKAGE PKG_METADATA_DIRECT_SQL_HIERARCHY_EXPORT COMPILE ;
ALTER PACKAGE PKG_METADATA_DIRECT_SQL_HIERARCHY_EXPORT COMPILE BODY;
