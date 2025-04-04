--liquibase formatted sql
--changeset Vijaysree.S:BACATALOG_DML_12 splitStatements:false
--preconditions onFail:HALT onError:HALT


create or replace PROCEDURE PROC_METADATA_DELETE_DEBUG (
    ip_delete_execution_id   NUMBER,
    ip_delete_proc_name      VARCHAR2,
    ip_delete_logs           VARCHAR2,
    ip_delete_dynamic_script CLOB,
    ip_delete_ids CLOB,
    ip_delete_ip_pid         NUMBER,
    ip_delete_notin_parentid CLOB
) AS
PRAGMA autonomous_transaction;
BEGIN
    INSERT INTO metadata_delete_trace (
        metadata_delete_execution_id,
        metadata_delete_proc_name,
        metadata_delete_logs,
        metadata_delete_dynamic_script,
        metadata_delete_ids,
        metadata_delete_execution_time,
        metadata_delete_ip_pid,
        metadata_delete_notin_parentid
    ) VALUES (
        ip_delete_execution_id,
        ip_delete_proc_name,
        ip_delete_logs,
        ip_delete_dynamic_script,
        ip_delete_ids,
        systimestamp,
        ip_delete_ip_pid,
        ip_delete_notin_parentid
    );

COMMIT;

END proc_metadata_delete_debug;



--changeset Vijaysree.S:BACATALOG_DML_12_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

create or replace PROCEDURE metadata_seq_delete (
    ip_process_id           IN lst_process_ids,
    ip_input_type           VARCHAR2,
    ip_api_life_cycle_id    IN lst_process_ids,
    ip_metadata_entity_type VARCHAR2,
    ip_is_debug_flag        VARCHAR2 DEFAULT 'Y'
    /*USR_AUTH_PRCS_MPNG_DLT_2024 Starts*/
    /* commented this for change USR_AUTH_PRCS_MPNG_DLT_APPL_2024 
    is_delete_req   VARCHAR2 DEFAULT 'Y' 
    */
    /*USR_AUTH_PRCS_MPNG_DLT_2024 Ends*/
) AS
/*
CHANGES HISTORY 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4627          16-04-2024		    Mohanraj.E	  		  USR_AUTH_PRCS_MPNG_DLT_2024               Since in the lower(dev) environment, the user mappings will be created and deleted via application 
                                                                                                        and in higher environments, default user mappings will be mapped with API's which should not be deleted. Hence the user_auth_process_mapping 
																										table delete will be performed with the input flag value if required. If we release from application 
																										then based on default flag 'Y',  USER_AUTH_PROCESS_MAPPING table will be deleted. In export process it should be passed as 'N'.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4640          16-04-2024		    Swetha.H	          RULE_ASSOC_TO_OFFR_DLT_2024               To get the rule(Rule associated to the offering and services) not getting released issue while releasing processplan. 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4659          17-04-2024		    Mohanraj.E	          TEMP_DLT_MLT_ASSOC_SNGL_PROC_2024         Template --> 50000109901 not getting deleted from Bacatalog,
																										50000109901 'Interface' --> it associated to single process plan - 50000082489 only,
																										but it associations with multiple sub process plan against the single process plan -50000082489. 
																										So its getting retrieve from Not in condition pid list in metadata seq delete procedure.
																										issue raised by Aravindsai.
																										Reg this, logic has been changed --> Retrieval query of not in pid list --> LST_PARENT_PROC_IDS.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4659          17-04-2024		    Dharmaprakash.S	      CMD_ENTY_GRP_JOIN_UNWNTED_OBJ_MPG_2024    1.changeRatePlan - 50000076857 --> messageHeader object form 50000112942,
																										2.change sim - 50000098833 --->  kafka-on object form 50000111153,
																										Getting delete from Bacatalog by unwanted mapping of entity_group_function table join 
																										in lst_ip_all_process_id list Retrieval queries. so that COMMENTED the particular union select query.
JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4643          19-04-2024		    Swetha.H	  		  API_FUNC_RULE_GRID_ENH_2024               In Inbound API Page, new form has been created to display the API FUNCTIONS, under API Functions they can create parameters and rule will be created 
															                                            and associated with each records.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4687          22-04-2024		    Mohanraj.E	          TEMP_DLT_MLT_ASSOC_CNT_CHK_2024           In Retrieval query of not in pid list , change count condition 'where template count >=1'
                                                                                                        Purpose : It getting deleted the multiple association of template to process plans.
                                                                                                        The above changes told by Dharma. 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4714          24-04-2024		    Mohanraj.E	      	  TO_RMV_ZRO_FRM_LST_PE_ID_2024         	To remove the 'Zero' values from the LST_PE_ID list type. 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4714          24-04-2024		    Mohanraj.E	      	  TO_DLT_TEMP_PROC_ASSOC_IN_PE_TBL_2024     To delete the process plan's template association record in process entity table which is under the releasing process plan data.
																										to delete by passing the LST_PROC_PAR_IDS list ids (Not in PID lists) and LST_PE_ID list ids in delete query.
																										LST_PROC_PAR_IDS --> getting all multiple association of Template ids,queue ids and page ids i.e., Re-use of Queue,Template and page to other process plans.
																										LST_PE_ID --> getting the all parent_id's of lst_all_ip_hierarchy_id list ids, it contains --> AUTHENTICATION API IDs,queue ids which is having parent as '0' that
																										'0' has been restricted in TO_RMV_ZRO_FRM_LST_PE_ID_2024

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4699          24-04-2024		    Vijaysree.S	  		  USR_AUTH_PRCS_MPNG_DLT_APPL_2024          Since in the lower(dev) environment, the user mappings will be created and deleted via application 
                                                                                                        and in higher environments, default user mappings will be mapped with API's which should not be deleted. Hence the user_auth_process_mapping 
																										table delete will be performed based on the metadata_config_value in metadata_export_file_config and the config_value will be assigned
                                                                                                        to the variable. 
                                                                                                        For DEVR2 - metadata_config_value - 'Y'
                                                                                                        SIT,UAT,PROD & higher environments   - metadata_config_value - 'N'

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4724          24-04-2024		    Dharma.S	  		  CHD_RUL_DLT_2024          				To delete the child rule records in rule table

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4724          24-04-2024		    Dharma.S	  		  CHD_PARAM_RUL_DLT_2024          			To delete the child rule's expression (PARAM_RULE) records in rule table

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4724          24-04-2024		    Dharma.S	  		  RUL_DLT_ADD_TYP_CON_2024          		In Rule delete fetch query, added the type condition by adding the process entity table joins
																										to filter out the 'Rule' type records in Parent_rule_id in rule table.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4738          27-04-2024		    Swetha.H	  		  RULE_ASSOC_TO_IP_PROCESSPLAN_2024         To get the rules associated for the input processplan alone, i.e., market offering associated to the input processplan can be associated to other processplan. In that case, the rules associated to the input should only be exported/deleted.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4748          29-04-2024		    Mohanraj.E	  		  TO_RETRV_LIST_RMV_ZRO_CNT_2024            To check the count of lst_pe_id list to remove the '0' value from the same.
																										We faced the ORA-06502: PL/SQL: numeric or value error issue due to SIT deployement
JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4741          26-04-2024		    Mohanraj.E	  		  TO_FTH_REF_TYP_VAL_EXP_RUL_2024          	To fetch the reference_type_values rule expression records 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4784          06-05-2024		    Ramalingam.S	  	  TO_RESTRICT_UNWANTED_2024          	    action_process_id is set to 0 in fetch to restict unwanted data in delete list

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4793          07-05-2024		    Mohanraj.E	  	      PRT_PIDS_RET_QRY_CMD_2024          	    The Parent_id retrieval query logic has been commented for performance issue fix - 
                                                                                                        while releasing the e-sim transfer process plan. 
                                                                                                        Purpose: all_lst_hierarchy list itself contains the all process ids (like 'INTERFACE' and all other entities)
                                                                                                        against for which releasing process plan/APIs.
                                                                                                        So there is no need to connect by prior logic again in Parent_id retrieval query logic.

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4800          10-05-2024		    Mohanraj.E	  	      AUTH_API_TEMP_DEL_2024          	    	AUTHENTICATION API's Template release --> Auth API associated with Outbounds.
																										If Auth api's Template is Re-usable, I won't to be deleted. Its parent_id values in process_entity
																										has the '0' value. It handled by param_spec_id (Parent_id) in parameter_addon_specification table. 

JIRA ID             CHANGE_DATE         CHANGED_BY            CHANGE_KEY				                DESCRIPTION
DBCOE-4825          14-05-2024		    Mohanraj.E	  	      PARAM_FUNCT_SPEC_DEL_2024          	    To the delete the parameter_funct_specification table records.

*/

    l_n_execution_id_seq               NUMBER := metadata_delete_execution_id_seq.nextval;
    l_n_exec_time                      NUMBER;
    l_n_del_ids                        CLOB;
    l_n_del_parent_ids                 CLOB;
    l_n_del_notin_ids                  CLOB;
    l_n_starttime                      NUMBER DEFAULT dbms_utility.get_time;
    l_n_cnt_egf                        NUMBER;
    op_debug_clob_egf                  CLOB;
    op_clob_egf_ids                    CLOB;
    l_n_cnt_ejp                        NUMBER;
    op_debug_clob_ejp                  CLOB;
    op_clob_ejp_ids                    CLOB;
    l_n_cnt_pes                        NUMBER;
    op_debug_clob_pes                  CLOB;
    op_clob_pes_ids1                   CLOB;
    op_clob_pes_ids2                   CLOB;
    op_clob_pes_ids                    CLOB;
    l_n_cnt_pe                         NUMBER;
    op_debug_clob_pe                   CLOB;
    op_debug_clob_pe_auth              CLOB;
    op_clob_pe_ids1                    CLOB;
    op_clob_pe_ids2                    CLOB;
    l_n_cnt_pe1                        NUMBER;
    op_debug_clob_pe1                  CLOB;
    op_clob_pe1_ids                    CLOB;
    op_clob_not_pe2_ids                CLOB;
    l_n_cnt_pls                        NUMBER;
    op_debug_clob_pls                  CLOB;
    op_clob_pls_ids1                   CLOB;
    op_clob_pls_ids2                   CLOB;
    op_clob_pls_ids                    CLOB;
    l_n_cnt_ps                         NUMBER;
    op_debug_clob_ps                   CLOB;
    op_clob_ps_ids                     CLOB;
    l_n_cnt_pads                       NUMBER;
    op_debug_clob_pads                 CLOB;
    op_clob_pads_ids                   CLOB;
    l_n_cnt_bpm                        NUMBER;
    op_debug_clob_bpm                  CLOB;
    op_clob_bpm_ids                    CLOB;
    l_n_cnt_bep                        NUMBER;
    op_debug_clob_bep                  CLOB;
    op_clob_bep_ids                    CLOB;
    l_n_cnt_ctm                        NUMBER;
    op_debug_clob_ctm                  CLOB;
    op_clob_ctm_ids                    CLOB;
    l_n_cnt_pds                        NUMBER;
    op_debug_clob_pds                  CLOB;
    op_clob_pds_ids                    CLOB;
    l_n_cnt_uapm                       NUMBER;
    op_debug_clob_uapm                 CLOB;
    op_clob_uapm_ids                   CLOB;
    l_n_cnt_ts                         NUMBER;
    op_debug_clob_ts                   CLOB;
    op_clob_ts_ids1                    CLOB;
    op_clob_ts_ids2                    CLOB;
    op_clob_ts_ids                     CLOB;
    l_n_cnt_trs                        NUMBER;
    op_debug_clob_trs                  CLOB;
    op_clob_trs_ids                    CLOB;
    l_n_cnt_tpm                        NUMBER;
    op_debug_clob_tpm                  CLOB;
    op_clob_tpm_ids                    CLOB;
    l_n_cnt_pas                        NUMBER;
    op_debug_clob_pas                  CLOB;
    op_clob_pas_ids                    CLOB;
    l_n_cnt_aip                        NUMBER;
    op_debug_clob_aip                  CLOB;
    op_clob_aip_ids                    CLOB;
    l_n_cnt_scm                        NUMBER;
    op_debug_clob_scm                  CLOB;
    op_clob_scm_ids                    CLOB;
    l_n_cnt_cps                        NUMBER;
    op_debug_clob_cps                  CLOB;
    op_clob_cps_ids                    CLOB;
    l_n_cnt_prv                        NUMBER;
    op_debug_clob_prv                  CLOB;
    op_clob_prv_ids                    CLOB;
    l_n_cnt_si                         NUMBER;
    op_debug_clob_si                   CLOB;
    op_clob_si_ids                     CLOB;
    l_n_cnt_st                         NUMBER;
    op_debug_clob_st                   CLOB;
    op_clob_st_ids                     CLOB;
    l_n_cnt_ebc                        NUMBER;
    op_debug_clob_ebc                  CLOB;
    op_clob_ebc_ids                    CLOB;
    l_n_cnt_bes                        NUMBER;
    op_debug_clob_bes                  CLOB;
    op_clob_bes_ids                    CLOB;
    l_n_cnt_pm                         NUMBER;
    op_debug_clob_pm                   CLOB;
    op_clob_pm_ids                     CLOB;
    l_n_cnt_prs                        NUMBER;
    op_debug_clob_prs                  CLOB;
    op_clob_prs_ids                    CLOB;
    l_n_cnt_r                          NUMBER;
    op_debug_clob_r                    CLOB;
    op_clob_r_ids                      CLOB;
    l_n_cnt_r1                         NUMBER;
    op_debug_clob_r1                   CLOB;
    op_clob_r1_ids                     CLOB;
    l_n_cnt_prs1                       NUMBER;
    op_debug_clob_prs1                 CLOB;
    op_clob_prs1_ids                   CLOB;
    op_ber_clob                        CLOB;
    ip_ber_clob                        CLOB;
    l_n_cnt_ber                        NUMBER;
    op_debug_clob_ber                  CLOB;
    op_clob_ber_ids                    CLOB;
    op_hm_clob                         CLOB;
    ip_hm_clob                         CLOB;
    l_n_cnt_hm                         NUMBER;
    op_debug_clob_hm                   CLOB;
    op_ppe_clob                        CLOB;
    ip_ppe_clob                        CLOB;
    l_n_cnt_ppe                        NUMBER;
    op_debug_clob_ppe                  CLOB;
    op_debug_clob_lst_inti             CLOB;
    lst_ini_cnt                        NUMBER;
    op_debug_clob_lst_ip_hie           CLOB;
    lst_ip_hie                         NUMBER;
    op_debug_clob_lst_ip_all           CLOB;
    lst_ip_all                         NUMBER;
    op_debug_clob_lst_all_ip           CLOB;
    lst_all_ip                         NUMBER;
    op_debug_clob_lst_parent           CLOB;
    lst_parent_cnt                     NUMBER;
    op_debug_clob_lst_proc_par_ids     CLOB;
    lst_proc_par_ids_cnt               NUMBER;
    op_debug_clob_lst_need_delete      CLOB;
    lst_need_delete_pid_cnt            NUMBER;
    op_debug_clob_lst_pe_id            CLOB;
    lst_pe_id_cnt                      NUMBER;
    ip_pe_clob                         CLOB;
    op_pe_clob                         CLOB;
    ip_pm_clob                         CLOB;
    op_pm_clob                         CLOB;
    l_n_cnt_pps                        NUMBER;
    op_debug_clob_pps                  CLOB;
    op_clob_ppe_ids                    CLOB;
    op_clob_pps_ids                    CLOB;
/*USR_AUTH_PRCS_MPNG_DLT_APPL_2024 Starts*/
    l_vc_uapm_delete                   VARCHAR2(2);
/*USR_AUTH_PRCS_MPNG_DLT_APPL_2024 Ends*/

    TYPE typ_pp_spec IS RECORD (
        pp_instance_id NUMBER,
        price_plan_id  NUMBER
    );
    TYPE typ_spec IS
        TABLE OF typ_pp_spec;
    TYPE typ_op_sc IS RECORD (
        offering_process_id NUMBER,
        service_code        VARCHAR2(50)
    );
    TYPE typ_opsc IS
        TABLE OF typ_op_sc;
    lst_pp_spec_val                    typ_spec := typ_spec();
    lst_op_sc_id                       typ_opsc := typ_opsc();
    lst_pe_root_id                     typ_spec := typ_spec();
    lst_ip_process_id                  lst_process_ids := lst_process_ids();
    lst_queue_ids                      lst_process_ids := lst_process_ids();
    lst_ip_all_process_id              lst_process_ids := lst_process_ids();
    lst_all_process_id_bf_hr           lst_process_ids := lst_process_ids();
    lst_proc_par_ids                   lst_process_ids := lst_process_ids();
    lst_parent_proc_ids                lst_process_ids := lst_process_ids();
    lst_need_delete_pid                lst_process_ids := lst_process_ids();
    lst_ip_hierarchy_id                lst_process_ids := lst_process_ids();
    lst_all_ip_hierarchy_id            lst_process_ids := lst_process_ids();
    lst_egf_id                         lst_egf_group_ids := lst_egf_group_ids();
    lst_ejp_id                         lst_egf_group_ids := lst_egf_group_ids();
    lst_pe_id                          lst_process_ids := lst_process_ids();
    lst_pes_id                         lst_process_ids := lst_process_ids();
    lst_ppe_id                         lst_process_ids := lst_process_ids();
    lst_pps_id                         lst_process_ids := lst_process_ids();
    lst_pls_id                         lst_process_ids := lst_process_ids();
    lst_ps_id                          lst_process_ids := lst_process_ids();
    lst_pas_id                         lst_process_ids := lst_process_ids();
    lst_bpm_id                         lst_process_ids := lst_process_ids();
    lst_bep_id                         lst_process_ids := lst_process_ids();
    lst_cstemp_id                      lst_process_ids := lst_process_ids();
    lst_prs_id                         lst_process_ids := lst_process_ids();
    lst_pds_id                         lst_process_ids := lst_process_ids();
    lst_tsid_id                        lst_process_ids := lst_process_ids();
    lst_tbrsp_id                       lst_process_ids := lst_process_ids();
    lst_tbm_id                         lst_process_ids := lst_process_ids();
    lst_pacts_id                       lst_process_ids := lst_process_ids();
    lst_aip_id                         lst_process_ids := lst_process_ids();
    lst_scm_id                         lst_process_ids := lst_process_ids();
    lst_r_id                           lst_process_ids := lst_process_ids();
    lst_rule_val                       lst_process_ids := lst_process_ids();
    lst_param_rule_spec                lst_process_ids := lst_process_ids();
    lst_cps_id                         lst_process_ids := lst_process_ids();
    lst_prv_id                         lst_process_ids := lst_process_ids();
    lst_si_id                          lst_process_ids := lst_process_ids();
    lst_st_id                          lst_process_ids := lst_process_ids();
    lst_ebc_id                         lst_process_ids := lst_process_ids();
    lst_bes_id                         lst_process_ids := lst_process_ids();
    lst_pm_id                          lst_process_ids := lst_process_ids();
    lst_uapm_id                        lst_process_ids := lst_process_ids();
    lst_epcm_id                        lst_process_ids := lst_process_ids();
    lst_pcd_id                         lst_process_ids := lst_process_ids();
    /*AUTH_API_TEMP_DEL_2024 start*/
    lst_auth_api_id                    lst_process_ids := lst_process_ids();
    lst_auth_temp_id                   lst_process_ids := lst_process_ids();
    l_n_cnt_pe_auth_temp_id            NUMBER;
    op_debug_clob_lst_auth_api_id      CLOB;
    op_debug_clob_lst_auth_api_temp_id CLOB;
    /*AUTH_API_TEMP_DEL_2024 end*/
    /*PARAM_FUNCT_SPEC_DEL_2024 start*/
    lst_param_funct_spec_id            lst_process_ids := lst_process_ids();
    op_debug_clob_pfs                  CLOB;
    op_clob_param_funct_spec_id        CLOB;
    l_n_cnt_pfs                        NUMBER;
    /*PARAM_FUNCT_SPEC_DEL_2024 end*/
    lst_prod_code_id                   lst_process_ids := lst_process_ids();
    op_debug_clob_pcd                  CLOB;
    op_clob_prod_code_id               CLOB;
    l_n_cnt_pcd                        NUMBER;
    lst_entity_prd_cd_id               lst_process_ids := lst_process_ids();
    op_debug_clob_epcm                 CLOB;
    op_clob_entity_prd_cd_id           CLOB;
    l_n_cnt_epcm                       NUMBER;
    lst_business_entity_rel_id         lst_process_ids := lst_process_ids();
    l_v_temp_cnt_var                   NUMBER := 0;
    pro_id                             NUMBER;
    del_pid                            NUMBER;
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 start*/
    v_lst_cnt                          NUMBER;
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 END*/
    list_cnt                           NUMBER;
    start_time                         TIMESTAMP;
    end_time                           TIMESTAMP;
    diff_time                          VARCHAR2(100);
    lst_entity_process_id              lst_process_ids := lst_process_ids();
    lst_mo_processids                  lst_process_ids := lst_process_ids();
BEGIN

/*USR_AUTH_PRCS_MPNG_DLT_APPL_2024 Starts*/
    SELECT
        nvl(metadata_config_value, 'N')
    INTO l_vc_uapm_delete
    FROM
        metadata_export_file_config
    WHERE
        metadata_config_name = 'IS_UAPM_DELETE_REQD_FLAG';
/*USR_AUTH_PRCS_MPNG_DLT_APPL_2024 Ends*/
    IF ip_metadata_entity_type = 'Market Offering' THEN
        FOR ip_mo_pid IN (
            SELECT
                *
            FROM
                TABLE ( ip_process_id )
        ) LOOP
            BEGIN
                SELECT
                    pid
                BULK COLLECT
                INTO lst_mo_processids
                FROM
                    process_entity
                WHERE
                    lifecycle_id IN (
                        select * from table(ip_api_life_cycle_id)
                    );

                SELECT
                    entityid
                BULK COLLECT
                INTO lst_entity_process_id
                FROM
                    business_process_mapping
                WHERE
                    parent_id IN (
                        SELECT
                            *
                        FROM
                            TABLE ( lst_mo_processids )
                    );

            EXCEPTION
                WHEN no_data_found THEN
                    NULL;
            END;

            SELECT
                ber.business_entity_rel_id
            BULK COLLECT
            INTO lst_business_entity_rel_id
            FROM
                business_process_mapping bpm,
                business_entity_relation ber
            WHERE
                    ber.root_id = bpm.entityid
                AND bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            SELECT
                bes.business_entity_spec_id
            BULK COLLECT
            INTO lst_bes_id
            FROM
                business_entity_specification bes,
                business_process_mapping      bpm
            WHERE
                    bes.root_id = bpm.entityid
                AND bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            SELECT
                pes.process_spec_id
            BULK COLLECT
            INTO lst_pes_id
            FROM
                process_entity               pe,
                process_entity_specification pes
            WHERE
                    pe.pid = pes.pid
                AND pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                )
            UNION
            SELECT
                pes.process_spec_id
            FROM
                process_entity               pe,
                process_entity_specification pes
            WHERE
                    pe.pid = pes.pid
                AND pe.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            SELECT
                pls.layout_id
            BULK COLLECT
            INTO lst_pls_id
            FROM
                process_entity               pe,
                process_layout_specification pls
            WHERE
                    pe.pid = pls.parent_id
                AND pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                )
            UNION
            SELECT
                pls.layout_id
            FROM
                process_entity               pe,
                process_layout_specification pls
            WHERE
                    pe.pid = pls.parent_id
                AND pe.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            SELECT
                pas.action_id
            BULK COLLECT
            INTO lst_pacts_id
            FROM
                process_entity               pe,
                process_action_specification pas
            WHERE
                    pe.pid = pas.parent_id
                AND pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                )
            UNION
            SELECT
                pas.action_id
            FROM
                process_entity               pe,
                process_action_specification pas
            WHERE
                    pe.pid = pas.parent_id
                AND pe.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            SELECT
                record_key
            BULK COLLECT
            INTO lst_bpm_id
            FROM
                business_process_mapping
            WHERE
                parent_id IN (
                    SELECT
                        pe.pid
                    FROM
                        process_entity pe
                    WHERE
                        pe.root_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_mo_processids )
                        )
                    UNION
                    SELECT
                        pe.pid
                    FROM
                        process_entity pe
                    WHERE
                        pe.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_mo_processids )
                        )
                );

            SELECT
                bep.record_key_param
            BULK COLLECT
            INTO lst_bep_id
            FROM
                business_entity_parameter bep
            WHERE
                parent_id IN (
                    SELECT
                        record_key
                    FROM
                        business_process_mapping
                    WHERE
                        parent_id IN (
                            SELECT
                                pe.pid
                            FROM
                                process_entity pe
                            WHERE
                                pe.root_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_mo_processids )
                                )
                            UNION
                            SELECT
                                pe.pid
                            FROM
                                process_entity pe
                            WHERE
                                pe.pid IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_mo_processids )
                                )
                        )
                );

            SELECT
                ts.id
            BULK COLLECT
            INTO lst_tsid_id
            FROM
                table_specification ts
            WHERE
                parent_id IN (
                    SELECT
                        pe.pid
                    FROM
                        process_entity pe
                    WHERE
                        pe.root_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_mo_processids )
                        )
                    UNION
                    SELECT
                        pe.pid
                    FROM
                        process_entity pe
                    WHERE
                        pe.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_mo_processids )
                        )
                );

            SELECT
                trs.id
            BULK COLLECT
            INTO lst_tbrsp_id
            FROM
                table_row_specification trs
            WHERE
                trs.parent_id IN (
                    SELECT
                        ts.id
                    FROM
                        table_specification ts
                    WHERE
                        parent_id IN (
                            SELECT
                                pe.pid
                            FROM
                                process_entity pe
                            WHERE
                                pe.root_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_mo_processids )
                                )
                            UNION
                            SELECT
                                pe.pid
                            FROM
                                process_entity pe
                            WHERE
                                pe.pid IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_mo_processids )
                                )
                        )
                );

            SELECT
                tpm.tabl_param_mapping_id
            BULK COLLECT
            INTO lst_tbm_id
            FROM
                table_parameter_mapping tpm
            WHERE
                tpm.row_spec_id IN (
                    SELECT
                        trs.id
                    FROM
                        table_row_specification trs
                    WHERE
                        trs.parent_id IN (
                            SELECT
                                ts.id
                            FROM
                                table_specification ts
                            WHERE
                                parent_id IN (
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.root_id IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                    UNION
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.pid IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                )
                        )
                );

            SELECT
                ps.param_basic_spec_id
            BULK COLLECT
            INTO lst_ps_id
            FROM
                parameter_specification ps
            WHERE
                param_basic_spec_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_entity_parameter bep
                    WHERE
                        parent_id IN (
                            SELECT
                                record_key
                            FROM
                                business_process_mapping
                            WHERE
                                parent_id IN (
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.root_id IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                    UNION
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.pid IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                )
                        )
                    UNION
                    SELECT
                        bp.parameter_id
                    FROM
                        business_parameters      bp, business_process_mapping bpm
                    WHERE
                            bp.type = 'Property'
                        AND bp.root_id = bpm.entityid
                        AND bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_mo_processids )
                        )
                );

            SELECT
                pas.param_addon_spec_id
            BULK COLLECT
            INTO lst_pas_id
            FROM
                parameter_addon_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT
                        ps.param_basic_spec_id
                    FROM
                        parameter_specification ps
                    WHERE
                        param_basic_spec_id IN (
                            SELECT
                                bep.parameter_spec_id
                            FROM
                                business_entity_parameter bep
                            WHERE
                                parent_id IN (
                                    SELECT
                                        record_key
                                    FROM
                                        business_process_mapping
                                    WHERE
                                        parent_id IN (
                                            SELECT
                                                pe.pid
                                            FROM
                                                process_entity pe
                                            WHERE
                                                pe.root_id IN (
                                                    SELECT
                                                        *
                                                    FROM
                                                        TABLE ( lst_mo_processids )
                                                )
                                            UNION
                                            SELECT
                                                pe.pid
                                            FROM
                                                process_entity pe
                                            WHERE
                                                pe.pid IN (
                                                    SELECT
                                                        *
                                                    FROM
                                                        TABLE ( lst_mo_processids )
                                                )
                                        )
                                )
                            UNION
                            SELECT
                                bp.parameter_id
                            FROM
                                business_parameters      bp, business_process_mapping bpm
                            WHERE
                                    bp.type = 'Property'
                                AND bp.root_id = bpm.entityid
                                AND bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_mo_processids )
                                )
                        )
                );

            SELECT
                pds.param_data_spec_id
            BULK COLLECT
            INTO lst_pds_id
            FROM
                parameter_data_specification pds
            WHERE
                pds.parent_id IN (
                    SELECT
                        ps.param_basic_spec_id
                    FROM
                        parameter_specification ps
                    WHERE
                        param_basic_spec_id IN (
                            SELECT
                                bep.parameter_spec_id
                            FROM
                                business_entity_parameter bep
                            WHERE
                                parent_id IN (
                                    SELECT
                                        record_key
                                    FROM
                                        business_process_mapping
                                    WHERE
                                        parent_id IN (
                                            SELECT
                                                pe.pid
                                            FROM
                                                process_entity pe
                                            WHERE
                                                pe.root_id IN (
                                                    SELECT
                                                        *
                                                    FROM
                                                        TABLE ( lst_mo_processids )
                                                )
                                            UNION
                                            SELECT
                                                pe.pid
                                            FROM
                                                process_entity pe
                                            WHERE
                                                pe.pid IN (
                                                    SELECT
                                                        *
                                                    FROM
                                                        TABLE ( lst_mo_processids )
                                                )
                                        )
                                )
                        )
                );

            SELECT
                prv.param_ref_val_id
            BULK COLLECT
            INTO lst_prv_id
            FROM
                parameter_reference_value prv
            WHERE
                prv.param_spec_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_entity_parameter bep
                    WHERE
                        parent_id IN (
                            SELECT
                                record_key
                            FROM
                                business_process_mapping
                            WHERE
                                parent_id IN (
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.root_id IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                    UNION
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.pid IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                )
                        )
                );

            SELECT
                pfs.param_func_spec_id
            BULK COLLECT
            INTO lst_param_funct_spec_id
            FROM
                parameter_func_specification pfs
            WHERE
                pfs.param_spec_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_entity_parameter bep
                    WHERE
                        parent_id IN (
                            SELECT
                                record_key
                            FROM
                                business_process_mapping
                            WHERE
                                parent_id IN (
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.root_id IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                    UNION
                                    SELECT
                                        pe.pid
                                    FROM
                                        process_entity pe
                                    WHERE
                                        pe.pid IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_mo_processids )
                                        )
                                )
                        )
                    UNION
                    SELECT
                        bp.parameter_id
                    FROM
                        business_parameters      bp, business_process_mapping bpm
                    WHERE
                            bp.type = 'Property'
                        AND bp.root_id = bpm.entityid
                        AND bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_mo_processids )
                        )
                );

            SELECT
                ppe.price_plan_entity_id
            BULK COLLECT
            INTO lst_ppe_id
            FROM
                price_plan_entity ppe
            WHERE
                ppe.entity_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                pps.pp_instance_id
            BULK COLLECT
            INTO lst_pps_id
            FROM
                price_plan_specification pps,
                price_plan               pp,
                price_plan_entity        ppe
            WHERE
                    pps.price_plan_id = pp.price_plan_id
                AND ppe.plan_id = pp.price_plan_id
                AND ppe.entity_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                cps.charge_instance_id
            BULK COLLECT
            INTO lst_cps_id
            FROM
                charge_parameter_specification cps,
                price_plan_specification       pps,
                price_plan                     pp,
                price_plan_entity              ppe
            WHERE
                    pps.pp_instance_id = cps.charge_item_id
                AND pps.price_plan_id = pp.price_plan_id
                AND ppe.plan_id = pp.price_plan_id
                AND ppe.entity_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                pcd.product_code_id
            BULK COLLECT
            INTO lst_prod_code_id
            FROM
                product_code_details        pcd,
                entity_product_code_mapping epcm
            WHERE
                    pcd.product_code_id = epcm.product_code_id
                AND epcm.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                epcm1.entity_prd_cd_id
            BULK COLLECT
            INTO lst_entity_prd_cd_id
            FROM
                entity_product_code_mapping epcm,
                entity_product_code_mapping epcm1
            WHERE
                epcm.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                )
                AND epcm.product_code_id = epcm1.product_code_id;

            SELECT
                scm.serv_col_meta_id
            BULK COLLECT
            INTO lst_scm_id
            FROM
                service_column_metadata scm
            WHERE
                scm.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                r.rule_id
            BULK COLLECT
            INTO lst_r_id
            FROM
                rule r
            WHERE
                r.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                prs.param_rule_spec_id
            BULK COLLECT
            INTO lst_prs_id
            FROM
                parameter_rule_specification prs,
                rule                         r
            WHERE
                    prs.rule_id = r.rule_id
                AND r.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_entity_process_id )
                );

            SELECT
                pm.offering_process_id,
                pm.service_code
            BULK COLLECT
            INTO lst_op_sc_id
            FROM
                product_mapping pm
            WHERE
                pm.offering_process_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            SELECT
                pe.pid,
                pe.root_id
            BULK COLLECT
            INTO lst_pe_root_id
            FROM
                process_entity pe
            WHERE
                pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                )
            UNION
            SELECT
                pe.pid,
                pe.root_id
            FROM
                process_entity pe
            WHERE
                pe.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_mo_processids )
                );

            FOR tab_mo IN (
                SELECT
                    ut.table_name
                FROM
                    user_tables                  ut,
                    metadata_export_table_config metc
                WHERE
                        ut.table_name = metc.metadata_table_name
                    AND metc.metadata_entity_type = 'MarketOffering'
                ORDER BY
                    metc.metadata_table_delete_seq
            ) LOOP
                IF tab_mo.table_name IN ( 'PROCESS_ENTITY' ) THEN
                    FOR ip_pe IN (
                        SELECT
                            pe.pid,
                            pe.root_id
                        FROM
                            process_entity pe
                        WHERE
                            pe.root_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_mo_processids )
                            )
                        UNION
                        SELECT
                            pe.pid,
                            pe.root_id
                        FROM
                            process_entity pe
                        WHERE
                            pe.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_mo_processids )
                            )
                    ) LOOP
                        ip_pe_clob := ip_pe_clob
                                      || '('
                                      || ip_pe.pid
                                      || ','
                                      || ip_pe.root_id
                                      || ')'
                                      || ',';
                    END LOOP ip_pe;

                    l_n_starttime := dbms_utility.get_time;
                    FORALL i IN lst_pe_root_id.first..lst_pe_root_id.last
                        DELETE FROM process_entity
                        WHERE
                            pid IN ( lst_pe_root_id(i).pp_instance_id )
                            AND root_id IN ( lst_pe_root_id(i).price_plan_id );

                    l_n_cnt_pe := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pe := q'<SELECT * FROM PROCESS_ENTITY
      WHERE (pid, root_id) IN
        >';
                        ip_pe_clob := rtrim(ip_pe_clob, ',');
                        op_pe_clob := '('
                                      || ip_pe_clob
                                      || ')';
                        op_debug_clob_pe := op_debug_clob_pe
                                            || chr(10)
                                            || op_pe_clob;
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ENTITY, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pe
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pe,
                                                                                                                                        op_pe_clob,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PROCESS_ENTITY_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM process_entity_specification
                    WHERE
                        process_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pes_id )
                        );

                    l_n_cnt_pes := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pes := q'<SELECT * FROM PROCESS_ENTITY_SPECIFICATION
      WHERE process_spec_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pes_id )
                            )
                        INTO op_clob_pes_ids
                        FROM
                            dual;

                        op_debug_clob_pes := op_debug_clob_pes
                                             || chr(10)
                                             || op_clob_pes_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pes_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ENTITY_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pes
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pes,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PROCESS_LAYOUT_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM process_layout_specification
                    WHERE
                        layout_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pls_id )
                        );

                    l_n_cnt_pls := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pls := q'<SELECT * FROM PROCESS_LAYOUT_SPECIFICATION
      WHERE layout_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pls_id )
                            )
                        INTO op_clob_pls_ids
                        FROM
                            dual;

                        op_debug_clob_pls := op_debug_clob_pls
                                             || chr(10)
                                             || op_clob_pls_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pls_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_LAYOUT_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pls
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pls,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'BUSINESS_ENTITY_RELATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_entity_relation
                    WHERE
                        business_entity_rel_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_business_entity_rel_id )
                        );

                    l_n_cnt_ber := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ber := q'<SELECT * FROM BUSINESS_ENTITY_RELATION
      WHERE business_entity_rel_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_business_entity_rel_id )
                            )
                        INTO op_clob_ber_ids
                        FROM
                            dual;

                        op_debug_clob_ber := op_debug_clob_ber
                                             || chr(10)
                                             || op_clob_ber_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_business_entity_rel_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_ENTITY_RELATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ber
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ber,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PARAMETER_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_specification
                    WHERE
                        param_basic_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ps_id )
                        );

                    l_n_cnt_ps := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ps := q'<SELECT * FROM PARAMETER_SPECIFICATION
      WHERE param_basic_spec_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_ps_id )
                            )
                        INTO op_clob_ps_ids
                        FROM
                            dual;

                        op_debug_clob_ps := op_debug_clob_ps
                                            || chr(10)
                                            || op_clob_ps_ids
                                            || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_ps_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ps
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ps,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PARAMETER_ADDON_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_addon_specification
                    WHERE
                        param_addon_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pas_id )
                        );

                    l_n_cnt_pads := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pads := q'<SELECT * FROM PARAMETER_ADDON_SPECIFICATION
      WHERE param_addon_spec_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pas_id )
                            )
                        INTO op_clob_pads_ids
                        FROM
                            dual;

                        op_debug_clob_pads := op_debug_clob_pads
                                              || chr(10)
                                              || op_clob_pads_ids
                                              || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pas_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_ADDON_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pads
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pads,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'BUSINESS_PROCESS_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_process_mapping
                    WHERE
                        record_key IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_bpm_id )
                        );

                    l_n_cnt_bpm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bpm := q'<SELECT * FROM BUSINESS_PROCESS_MAPPING
      WHERE record_key IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_bpm_id )
                            )
                        INTO op_clob_bpm_ids
                        FROM
                            dual;

                        op_debug_clob_bpm := op_debug_clob_bpm
                                             || chr(10)
                                             || op_clob_bpm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_bpm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_PROCESS_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_bpm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_bpm,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'BUSINESS_ENTITY_PARAMETER' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_entity_parameter
                    WHERE
                        record_key_param IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_bep_id )
                        );

                    l_n_cnt_bep := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bep := q'<SELECT * FROM BUSINESS_ENTITY_PARAMETER
      WHERE record_key_param IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_bep_id )
                            )
                        INTO op_clob_bep_ids
                        FROM
                            dual;

                        op_debug_clob_bep := op_debug_clob_bep
                                             || chr(10)
                                             || op_clob_bep_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_bep_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_ENTITY_PARAMETER, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_bep
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_bep,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PARAMETER_RULE_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_rule_specification
                    WHERE
                        param_rule_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_prs_id )
                        );

                    l_n_cnt_prs := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_prs := q'<SELECT * FROM PARAMETER_RULE_SPECIFICATION
      WHERE param_rule_spec_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_prs_id )
                            )
                        INTO op_clob_prs_ids
                        FROM
                            dual;

                        op_debug_clob_prs := op_debug_clob_prs
                                             || chr(10)
                                             || op_clob_prs_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_prs_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_RULE_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_prs
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_prs,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PARAMETER_DATA_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_data_specification
                    WHERE
                        param_data_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pds_id )
                        );

                    l_n_cnt_pds := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pds := q'<SELECT * FROM PARAMETER_DATA_SPECIFICATION
      WHERE param_data_spec_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pds_id )
                            )
                        INTO op_clob_pds_ids
                        FROM
                            dual;

                        op_debug_clob_pds := op_debug_clob_pds
                                             || chr(10)
                                             || op_clob_pds_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pds_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_DATA_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pds
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pds,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'TABLE_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM table_specification
                    WHERE
                        id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_tsid_id )
                        );

                    l_n_cnt_ts := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ts := q'<SELECT * FROM TABLE_SPECIFICATION
      WHERE id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_tsid_id )
                            )
                        INTO op_clob_ts_ids
                        FROM
                            dual;

                        op_debug_clob_ts := op_debug_clob_ts
                                            || chr(10)
                                            || op_clob_ts_ids
                                            || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_tsid_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> TABLE_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pls
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ts,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'TABLE_ROW_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM table_row_specification
                    WHERE
                        id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_tbrsp_id )
                        );

                    l_n_cnt_trs := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_trs := q'<SELECT * FROM TABLE_ROW_SPECIFICATION
      WHERE id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_tbrsp_id )
                            )
                        INTO op_clob_trs_ids
                        FROM
                            dual;

                        op_debug_clob_trs := op_debug_clob_trs
                                             || chr(10)
                                             || op_clob_trs_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_tbrsp_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> TABLE_ROW_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_trs
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_trs,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'TABLE_PARAMETER_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM table_parameter_mapping
                    WHERE
                        tabl_param_mapping_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_tbm_id )
                        );

                    l_n_cnt_tpm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_tpm := q'<SELECT * FROM TABLE_PARAMETER_MAPPING
      WHERE row_spec_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_tbm_id )
                            )
                        INTO op_clob_tpm_ids
                        FROM
                            dual;

                        op_debug_clob_tpm := op_debug_clob_tpm
                                             || chr(10)
                                             || op_clob_tpm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_tbm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> TABLE_PARAMETER_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_tpm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_tpm,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PROCESS_ACTION_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM process_action_specification
                    WHERE
                        action_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pacts_id )
                        );

                    l_n_cnt_pas := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pas := q'<SELECT * FROM PROCESS_ACTION_SPECIFICATION
      WHERE action_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pacts_id )
                            )
                        INTO op_clob_pas_ids
                        FROM
                            dual;

                        op_debug_clob_pas := op_debug_clob_pas
                                             || chr(10)
                                             || op_clob_pas_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pacts_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ACTION_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pas
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pas,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'SERVICE_COLUMN_METADATA' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM service_column_metadata
                    WHERE
                        serv_col_meta_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_scm_id )
                        );

                    l_n_cnt_scm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_scm := q'<SELECT * FROM SERVICE_COLUMN_METADATA
      WHERE serv_col_meta_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_scm_id )
                            )
                        INTO op_clob_scm_ids
                        FROM
                            dual;

                        op_debug_clob_scm := op_debug_clob_scm
                                             || chr(10)
                                             || op_clob_scm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_scm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> SERVICE_COLUMN_METADATA, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_scm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_scm,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'RULE' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM rule r
                    WHERE
                        r.rule_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_r_id )
                        );

                    l_n_cnt_r := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_r := q'<SELECT * FROM RULE
      WHERE rule_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_r_id )
                            )
                        INTO op_clob_r_ids
                        FROM
                            dual;

                        op_debug_clob_r := op_debug_clob_r
                                           || chr(10)
                                           || op_clob_r_ids
                                           || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_r_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> RULE, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_r
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_r,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PRICE_PLAN_ENTITY' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM price_plan_entity
                    WHERE
                        price_plan_entity_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ppe_id )
                        );

                    l_n_cnt_ppe := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ppe := q'<SELECT * FROM PRICE_PLAN_ENTITY
      WHERE price_plan_entity_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_ppe_id )
                            )
                        INTO op_clob_ppe_ids
                        FROM
                            dual;

                        op_debug_clob_ppe := op_debug_clob_ppe
                                             || chr(10)
                                             || op_clob_ppe_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_ppe_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRICE_PLAN_ENTITY, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ppe
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ppe,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PRICE_PLAN_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM price_plan_specification
                    WHERE
                        pp_instance_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pps_id )
                        );

                    l_n_cnt_pps := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pps := q'<SELECT * FROM PRICE_PLAN_SPECIFICATION
      WHERE pp_instance_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pps_id )
                            )
                        INTO op_clob_pps_ids
                        FROM
                            dual;

                        op_debug_clob_pps := op_debug_clob_pps
                                             || chr(10)
                                             || op_clob_pps_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pps_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRICE_PLAN_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pps
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pps,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'CHARGE_PARAMETER_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM charge_parameter_specification
                    WHERE
                        charge_instance_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_cps_id )
                        );

                    l_n_cnt_cps := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_cps := q'<SELECT * FROM CHARGE_PARAMETER_SPECIFICATION
      WHERE charge_instance_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_cps_id )
                            )
                        INTO op_clob_cps_ids
                        FROM
                            dual;

                        op_debug_clob_cps := op_debug_clob_cps
                                             || chr(10)
                                             || op_clob_cps_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_cps_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> CHARGE_PARAMETER_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_cps
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_cps,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PARAMETER_REFERENCE_VALUE' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_reference_value
                    WHERE
                        param_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_prv_id )
                        );

                    l_n_cnt_prv := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_prv := q'<SELECT * FROM parameter_reference_value
        WHERE param_spec_id IN
      (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_prv_id )
                            )
                        INTO op_clob_prv_ids
                        FROM
                            dual;

                        op_debug_clob_prv := op_debug_clob_prv
                                             || chr(10)
                                             || op_clob_prv_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_prv_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_REFERENCE_VALUE, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_prv
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_prv,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'BUSINESS_ENTITY_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_entity_specification bes
                    WHERE
                        bes.business_entity_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_bes_id )
                        );

                    l_n_cnt_bes := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bes := q'<SELECT * FROM business_entity_specification 
WHERE
    business_entity_spec_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_bes_id )
                            )
                        INTO op_clob_bes_ids
                        FROM
                            dual;

                        op_debug_clob_bes := op_debug_clob_bes
                                             || chr(10)
                                             || op_clob_bes_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_bes_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_ENTITY_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_bes
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_bes,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PARAMETER_FUNC_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_func_specification
                    WHERE
                        param_func_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_param_funct_spec_id )
                        );

                    l_n_cnt_pfs := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pfs := q'<SELECT * FROM parameter_func_specification
      WHERE PARAM_FUNC_SPEC_ID IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_param_funct_spec_id )
                            )
                        INTO op_clob_param_funct_spec_id
                        FROM
                            dual;

                        op_debug_clob_pfs := op_debug_clob_pfs
                                             || chr(10)
                                             || op_clob_param_funct_spec_id
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_param_funct_spec_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_FUNC_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pfs
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pfs,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);
			/*PARAM_FUNCT_SPEC_DEL_2024 end*/
                    END IF;

                ELSIF tab_mo.table_name IN ( 'PRODUCT_CODE_DETAILS' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM product_code_details
                    WHERE
                        product_code_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_prod_code_id )
                        );

                    l_n_cnt_pcd := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pcd := q'<SELECT * FROM product_code_details
      WHERE product_code_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_prod_code_id )
                            )
                        INTO op_clob_prod_code_id
                        FROM
                            dual;

                        op_debug_clob_pcd := op_debug_clob_pcd
                                             || chr(10)
                                             || op_clob_prod_code_id
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_prod_code_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRODUCT_CODE_DETAILS, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pcd
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pcd,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'ENTITY_PRODUCT_CODE_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM entity_product_code_mapping
                    WHERE
                        entity_prd_cd_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_entity_prd_cd_id )
                        );

                    l_n_cnt_epcm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_epcm := q'<SELECT * FROM entity_product_code_mapping
      WHERE entity_prd_cd_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_entity_prd_cd_id )
                            )
                        INTO op_clob_entity_prd_cd_id
                        FROM
                            dual;

                        op_debug_clob_epcm := op_debug_clob_epcm
                                              || chr(10)
                                              || op_clob_entity_prd_cd_id
                                              || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_entity_prd_cd_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> ENTITY_PRODUCT_CODE_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_epcm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_epcm,
                                                                                                                                        l_n_del_ids,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                ELSIF tab_mo.table_name IN ( 'PRODUCT_MAPPING' ) THEN
                    FOR ip_pm IN (
                        SELECT
                            pm.offering_process_id,
                            pm.service_code
                        FROM
                            product_mapping pm
                        WHERE
                            pm.offering_process_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_mo_processids )
                            )
                    ) LOOP
                        ip_pm_clob := ip_pm_clob
                                      || '('
                                      || ip_pm.offering_process_id
                                      || ','
                                      || ''''
                                      || ip_pm.service_code
                                      || ''''
                                      || ')'
                                      || ',';
                    END LOOP ip_pm;

                    l_n_starttime := dbms_utility.get_time;
                    FORALL i IN lst_op_sc_id.first..lst_op_sc_id.last
                        DELETE FROM product_mapping
                        WHERE
                            offering_process_id IN ( lst_op_sc_id(i).offering_process_id )
                            AND service_code IN ( lst_op_sc_id(i).service_code );

                    l_n_cnt_pm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pm := q'<SELECT * FROM PRODUCT_MAPPING
      WHERE (offering_process_id, service_code) IN
        >';
                        ip_pm_clob := rtrim(ip_pm_clob, ',');
                        op_pm_clob := '('
                                      || ip_pm_clob
                                      || ')';
                        op_debug_clob_pm := op_debug_clob_pm
                                            || chr(10)
                                            || op_pm_clob;
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRODUCT_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pm,
                                                                                                                                        op_pm_clob,
                                                  ip_mo_pid.column_value, NULL);

                    END IF;

                END IF;
            END LOOP tab_mo;

        END LOOP ip_mo_pid;

    ELSE
        FOR ip_pid IN (
            SELECT
                *
            FROM
                TABLE ( ip_process_id )
        ) LOOP
            IF ip_input_type = 'Inbound' THEN
                SELECT
                    pid
                BULK COLLECT
                INTO lst_ip_process_id
                FROM
                    (
                        SELECT
                            pid
                        FROM
                            process_entity
                        WHERE
                            lifecycle_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( ip_api_life_cycle_id )
                            )
                    );

            END IF;

            FOR proc IN (
                SELECT
                    *
                FROM
                    TABLE ( ip_process_id )
            ) LOOP
                lst_ip_process_id.extend();
                lst_ip_process_id(lst_ip_process_id.count) := proc.column_value;
            END LOOP proc;

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_ini_cnt
                FROM
                    TABLE ( lst_ip_process_id );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_ip_process_id )
                    )
                INTO op_debug_clob_lst_inti
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'Initial I/P List lst_ip_process_id , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_ini_cnt
                                                                                                                                || ' .',
                                                                                                                                'lst_ip_process_id',
                                                                                                                                op_debug_clob_lst_inti,
                                          ip_pid.column_value, NULL);

            END IF;

            SELECT DISTINCT
                pe.pid
            BULK COLLECT
            INTO lst_ip_hierarchy_id
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
            SELECT
                to_number(pas.default_value)
            FROM
                business_process_mapping      bpm,
                business_entity_parameter     bep,
                parameter_addon_specification pas,
                (
                    SELECT
                        pid
                    FROM
                        process_entity
                    WHERE
                            process_entity_name <> 'Setting Configuration'
                        AND action_type = 'Gateway View'
                        AND type = 'Form'
                    START WITH
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_process_id )
                        )
                    CONNECT BY
                        PRIOR pid = parent_id
                )                             pe,
                process_entity_specification  pes
            WHERE
                    pes.data_load_type = 'Inbound'
                AND pes.pid = pe.pid
                AND pe.pid = bpm.parent_id
                AND bpm.record_key = bep.parent_id
                AND bep.parameter_spec_id = pas.parent_id
                AND pas.display_name = 'Process Specification'
            UNION
            SELECT
                pe.pid
            FROM
                process_entity_specification pes,
                process_entity               pe
            WHERE
                pes.pid IN (
                    SELECT DISTINCT
                        pid
                    FROM
                        process_entity
                    START WITH
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_process_id )
                        )
                    CONNECT BY
                        PRIOR pid = parent_id
                )
                AND pes.outbound_service_name IS NOT NULL
                AND pes.outbound_service_name = pe.process_entity_name
                AND pe.type = 'Page'
            UNION
            SELECT
                pe.pid
            FROM
                process_entity_specification pes,
                process_entity               pe
            WHERE
                pes.pid IN (
                    SELECT DISTINCT
                        pid
                    FROM
                        process_entity
                    START WITH
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_process_id )
                        )
                    CONNECT BY
                        PRIOR pid = parent_id
                )
                AND pes.outbound_failure_service_name IS NOT NULL
                AND pes.outbound_failure_service_name = pe.process_entity_name
                AND pe.type = 'Page'
            UNION
            SELECT
                pesq.pid
            FROM
                process_entity               pe,
                process_entity_specification pes,
                process_entity_specification pesq
            WHERE
                pe.root_id IN (
                    SELECT
                        action_process_id
                    FROM
                        process_action_specification
                    WHERE
                        parent_id IN (
                            SELECT
                                pid
                            FROM
                                process_entity
                            WHERE
                                root_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_ip_process_id )
                                )
                        )
            /*TO_RESTRICT_UNWANTED_2024 Starts */
                        AND action_process_id <> 0
            /*TO_RESTRICT_UNWANTED_2024 End */
                )
                AND pe.pid = pes.pid
                AND pes.task_type IN ( 'Send Task', 'Receive Task' )
                AND pes.outbound_service_name = pesq.name
                AND pesq.type = 'Page'
            UNION
            SELECT
                pesq.pid
            FROM
                process_entity               pe,
                process_entity_specification pes,
                process_entity_specification pesq
            WHERE
                pe.root_id IN (
                    SELECT
                        action_process_id
                    FROM
                        process_action_specification
                    WHERE
                        parent_id IN (
                            SELECT
                                pid
                            FROM
                                process_entity
                            WHERE
                                root_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_ip_process_id )
                                )
                        )
            /*TO_RESTRICT_UNWANTED_2024 Starts */
                        AND action_process_id <> 0
            /*TO_RESTRICT_UNWANTED_2024 End */
                )
                AND pe.pid = pes.pid
                AND pes.task_type IN ( 'Send Task', 'Receive Task' )
                AND pes.outbound_failure_service_name = pesq.name
                AND pesq.type = 'Page'
            UNION
            SELECT DISTINCT
                pas.action_queue_id
            FROM
                process_entity               pe,
                process_action_specification pas
            WHERE
                    pe.pid = pas.parent_id
                AND pas.action_queue_id IS NOT NULL
                AND pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_ip_process_id )
                )
            UNION
            SELECT
                pesq.pid
            FROM
                process_entity               pe,
                process_entity_specification pes,
                process_entity_specification pesq
            WHERE
                pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_ip_process_id )
                )
                AND pe.pid = pes.pid
                AND pes.task_type IN ( 'Send Task', 'Receive Task' )
                AND pes.outbound_service_name = pesq.name
                AND pesq.type = 'Page'
            UNION
            SELECT
                pesq.pid
            FROM
                process_entity               pe,
                process_entity_specification pes,
                process_entity_specification pesq
            WHERE
                pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_ip_process_id )
                )
                AND pe.pid = pes.pid
                AND pes.task_type IN ( 'Send Task', 'Receive Task' )
                AND pes.outbound_failure_service_name = pesq.name
                AND pesq.type = 'Page';

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_ip_hie
                FROM
                    TABLE ( lst_ip_hierarchy_id );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_ip_hierarchy_id )
                    )
                INTO op_debug_clob_lst_ip_hie
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'List lst_ip_hierarchy_id , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count -->'
                                                                                                                                || lst_ip_hie
                                                                                                                                || ' .',
                                                                                                                                'lst_ip_hierarchy_id',
                                                                                                                                op_debug_clob_lst_ip_hie,
                                          ip_pid.column_value, NULL);

            END IF;

            SELECT
                pas.action_process_id
            BULK COLLECT
            INTO lst_ip_all_process_id
            FROM
                process_action_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT DISTINCT
                        pid
                    FROM
                        process_entity
                    START WITH
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_hierarchy_id )
                        )
                    CONNECT BY
                        PRIOR pid = parent_id
                )
                AND pas.parent_id <> pas.action_process_id
                AND pas.action_process_id IS NOT NULL
            /*TO_RESTRICT_UNWANTED_2024 Starts */
                AND action_process_id <> 0
            /*TO_RESTRICT_UNWANTED_2024 End */
            UNION
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
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_hierarchy_id )
                        )
                        AND bep.parent_id = bpm.record_key
                )
                AND pas.parent_id <> pas.action_process_id
                AND pas.action_process_id IS NOT NULL
            /*TO_RESTRICT_UNWANTED_2024 Starts */
                AND action_process_id <> 0
            /*TO_RESTRICT_UNWANTED_2024 End */
/*CMD_ENTY_GRP_JOIN_UNWNTED_OBJ_MPG_2024*/
   /*   UNION
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
        AND eg.join_pid IN (select * from table(lst_ip_hierarchy_id))*/
	/*CMD_ENTY_GRP_JOIN_UNWNTED_OBJ_MPG_2024*/

            UNION
            SELECT
                pas.action_queue_id
            FROM
                process_action_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_ip_hierarchy_id )
                )
                AND pas.action_queue_id IS NOT NULL
            UNION
            SELECT
                res.pid
            FROM
                (
                    SELECT
                        pe.*,
                        DENSE_RANK()
                        OVER(PARTITION BY pe.lifecycle_id
                             ORDER BY
                                 pe.version DESC
                        ) rk
                    FROM
                        process_entity pe,
                        (
                            SELECT
                                outbound_service_name
                            FROM
                                (
                                    SELECT
                                        pes.outbound_service_name as,
                                        pes.outbound_failure_service_name
                                    FROM
                                        process_entity_specification pes,
                                        (
                                            SELECT
                                                pid
                                            FROM
                                                process_entity
                                            WHERE
                                                type = 'Step'
                                            CONNECT BY
                                                PRIOR pid = parent_id
                                            START WITH pid IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_ip_hierarchy_id )
                                            )
                                        )                            pe
                                    WHERE
                                            pe.pid = pes.pid
                                        AND pes.task_type = 'Send Task'
                                        AND pes.outbound_service_name IS NOT NULL
                                ) UNPIVOT ( outbound_service_name
                                    FOR out_service_name
                                IN ( outbound_service_name,
                                     outbound_failure_service_name ) )
                        )              pes1
                    WHERE
                            pes1.outbound_service_name = pe.process_entity_name
                        AND pe.type = 'Page'
                ) res
            WHERE
                rk = 1
            UNION
            SELECT
                pls.chart_id
            FROM
                process_layout_specification pls
            WHERE
                pls.chart_id IS NOT NULL
                AND pls.chart_id <> 0
                AND pls.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_ip_hierarchy_id )
                )
            UNION
            SELECT
                pe1.pid
            FROM
                (
                    SELECT DISTINCT
                        pid
                    FROM
                        process_entity
                    START WITH
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_hierarchy_id )
                        )
                    CONNECT BY
                        PRIOR pid = parent_id
                )                            pe,
                process_entity_specification pes,
                process_entity               pe1
            WHERE
                    pes.pid = pe.pid
                AND pes.outbound_service_name = pe1.process_entity_name
                AND pe1.type = 'Page'
                AND pes.outbound_service_name IS NOT NULL
            UNION
            SELECT
                pe1.pid
            FROM
                (
                    SELECT DISTINCT
                        pid
                    FROM
                        process_entity
                    START WITH
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_hierarchy_id )
                        )
                    CONNECT BY
                        PRIOR pid = parent_id
                )                            pe,
                process_entity_specification pes,
                process_entity               pe1
            WHERE
                    pes.pid = pe.pid
                AND pes.outbound_failure_service_name = pe1.process_entity_name
                AND pe1.type = 'Page'
                AND pes.outbound_failure_service_name IS NOT NULL
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
                        pe.root_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ip_hierarchy_id )
                        )
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
                custom_template_mapping ctm,
                (
                    WITH rule_det AS (
                        SELECT DISTINCT
                            r.*
                        FROM
                            business_process_mapping     bpm,
                            business_entity_parameter    bep,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            bpm.parent_id IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                            AND bep.parent_id = bpm.record_key
                            AND bep.parameter_spec_id = prs.parent_id
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            prs.parent_id IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            r.parent_rule_id IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT DISTINCT
                            r.*
                        FROM
                            price_plan_specification       pps,
                            charge_parameter_specification cps,
                            rule                           r
                        WHERE
                            pps.service_entity_id IN (
                                SELECT
                                    bpm.entityid
                                FROM
                                    business_process_mapping bpm
                                WHERE
                                    bpm.parent_id IN (
                                        SELECT DISTINCT
                                            pid
                                        FROM
                                            process_entity
                                        START WITH
                                            pid IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_ip_hierarchy_id )
                                            )
                                        CONNECT BY
                                            PRIOR pid = parent_id
                                    )
                            )
                            AND cps.charge_item_id = pps.pp_instance_id
                            AND r.rule_id = cps.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            entity_group_function egf,
                            entity_join_parameter ejp,
                            rule                  r
                        WHERE
                            egf.pid IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                            AND egf.group_id = ejp.group_id
                            AND egf.entity_function_id = ejp.entity_function_id
                            AND ejp.mapping_entity_id = r.rule_id
                        UNION
                        SELECT DISTINCT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            process_action_specification pas,
                            rule                         r
                        WHERE
                            pas.parent_id IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                            AND pas.action_id = prs.parent_id
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            *
                        FROM
                            rule
                        WHERE
                            parent_rule_id IN (
                                SELECT
                                    r.rule_id
                                FROM
                                    parameter_rule_specification prs, rule                         r
                                WHERE
                                    r.parent_rule_id IN (
                                        SELECT DISTINCT
                                            pid
                                        FROM
                                            process_entity
                                        START WITH
                                            pid IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_ip_hierarchy_id )
                                            )
                                        CONNECT BY
                                            PRIOR pid = parent_id
                                    )
                                    AND r.rule_id = prs.rule_id
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule r
                        WHERE
                            r.parent_rule_id IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            process_entity_specification pes,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                                prs.parent_id = pes.process_spec_id
                            AND pes.pid IN (
                                SELECT DISTINCT
                                    pid
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_ip_hierarchy_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification p
                        WHERE
                            p.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT DISTINCT
                                            pid
                                        FROM
                                            process_entity
                                        START WITH
                                            pid IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_ip_hierarchy_id )
                                            )
                                        CONNECT BY
                                            PRIOR pid = parent_id
                                    )
                            )
                            AND p.rule_id = r1.rule_id
                            AND r1.parent_rule_id = r.rule_id
                        UNION
                        SELECT
                            r1.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification p
                        WHERE
                            p.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT DISTINCT
                                            pid
                                        FROM
                                            process_entity
                                        START WITH
                                            pid IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_ip_hierarchy_id )
                                            )
                                        CONNECT BY
                                            PRIOR pid = parent_id
                                    )
                            )
                            AND p.rule_id = r1.rule_id
                            AND r1.parent_rule_id = r.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs,
                            (
                                SELECT
                                    rt.*
                                FROM
                                    (
                                        SELECT
                                            ps.param_basic_spec_id,
                                            DENSE_RANK()
                                            OVER(
                                                ORDER BY
                                                    ps.version DESC
                                            ) AS sk
                                        FROM
                                            parameter_specification ps,
                                            business_parameters     bp,
                                            parameter               p
                                        WHERE
                                            bp.bid IN (
                                                SELECT
                                                    be.bid
                                                FROM
                                                    business_entity          be, business_process_mapping bpm
                                                WHERE
                                                        bpm.entityid = be.bid
                                                    AND bpm.parent_id IN (
                                                        SELECT DISTINCT
                                                            pid
                                                        FROM
                                                            process_entity
                                                        START WITH
                                                            pid IN (
                                                                SELECT
                                                                    *
                                                                FROM
                                                                    TABLE ( lst_ip_hierarchy_id )
                                                            )
                                                        CONNECT BY
                                                            PRIOR pid = parent_id
                                                    )
                                            )
                                            AND p.parameter_id = bp.parameter_id
                                            AND ps.parent_id = p.parameter_id
                                            AND ps.core_spec = 'Yes'
                                    ) rt
                                WHERE
                                    sk = 1
                            )                            pbsi
                        WHERE
                                r.rule_id = prs.rule_id
                            AND prs.parent_id = pbsi.param_basic_spec_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs,
                            (
                                SELECT
                                    rt.*
                                FROM
                                    (
                                        SELECT
                                            ps.param_basic_spec_id,
                                            DENSE_RANK()
                                            OVER(
                                                ORDER BY
                                                    ps.version DESC
                                            ) AS sk
                                        FROM
                                            parameter_specification ps
                                        WHERE
                                            ps.parent_id IN (
                                                SELECT DISTINCT
                                                    p.parameter_id
                                                FROM
                                                    table_parameter_mapping       tpm, table_row_specification       trs, table_specification           ts,
                                                    parameter                     p, parameter_specification       ps,
                                                    parameter_addon_specification pas
                                                WHERE
                                                        pas.parent_id (+) = ps.param_basic_spec_id
                                                    AND ps.core_spec != 'Yes'
                                                    AND ps.parent_id = p.parameter_id
                                                    AND p.parameter_id = ps.parent_id
                                                    AND pas.parent_id = ps.param_basic_spec_id
                                                    AND ps.param_basic_spec_id = tpm.parameter_spec_id
                                                    AND tpm.row_spec_id = trs.id
                                                    AND trs.parent_id = ts.id
                                                    AND ts.parent_id IN (
                                                        SELECT
                                                            pes.pid
                                                        FROM
                                                            business_entity              be, business_process_mapping     bpm, process_entity_specification pes,
                                                            process_entity               pe
                                                        WHERE
                                                            be.bid IN (
                                                                SELECT
                                                                    be.bid
                                                                FROM
                                                                    business_entity          be, business_process_mapping bpm
                                                                WHERE
                                                                        bpm.entityid = be.bid
                                                                    AND bpm.parent_id IN (
                                                                        SELECT DISTINCT
                                                                            pid
                                                                        FROM
                                                                            process_entity
                                                                        START WITH
                                                                            pid IN (
                                                                                SELECT
                                                                                    *
                                                                                FROM
                                                                                    TABLE ( lst_ip_hierarchy_id )
                                                                            )
                                                                        CONNECT BY
                                                                            PRIOR pid = parent_id
                                                                    )
                                                            )
                                                            AND bpm.entityid = be.bid
                                                            AND pes.pid = bpm.parent_id
                                                            AND pe.pid = pes.pid
                                                            AND pe.action_type = 'Parameter Group'
                                                    )
                                            )
                                            AND ps.core_spec != 'Yes'
                                    ) rt
                                WHERE
                                    sk = 1
                            )                            pbsi
                        WHERE
                                r.rule_id = prs.rule_id
                            AND prs.parent_id = pbsi.param_basic_spec_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            (
                                SELECT DISTINCT
                                    ebc.entity_id
                                FROM
                                    entity_boundary_condition ebc
                                WHERE
                                    ebc.entity_id IN (
                                        SELECT DISTINCT
                                            pid
                                        FROM
                                            process_entity
                                        START WITH
                                            pid IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_ip_hierarchy_id )
                                            )
                                        CONNECT BY
                                            PRIOR pid = parent_id
                                    )
                            )    ebc,
                            rule r
                        WHERE
                            r.entity_id = ebc.entity_id
                    )
                    SELECT
                        r.rule_id,
                        r.parent_rule_id
                    FROM
                        rule_det r
                    UNION
                    SELECT
                        r.rule_id,
                        r.parent_rule_id
                    FROM
                        rule_det rd,
                        rule     r
                    WHERE
                        r.parent_rule_id = rd.rule_id
                )                       ss
            WHERE
                ss.rule_id = ctm.entity_id
            UNION
            SELECT DISTINCT
                pas.action_queue_id
            FROM
                process_entity               pe,
                process_action_specification pas
            WHERE
                    pe.pid = pas.parent_id
                AND pas.action_queue_id IS NOT NULL
                AND pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_ip_hierarchy_id )
                );

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_ip_all
                FROM
                    TABLE ( lst_ip_all_process_id );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_ip_all_process_id )
                    )
                INTO op_debug_clob_lst_ip_all
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'List lst_ip_all_process_id , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_ip_all
                                                                                                                                || ' .',
                                                                                                                                'lst_ip_all_process_id',
                                                                                                                                op_debug_clob_lst_ip_all,
                                          ip_pid.column_value, NULL);

            END IF;

            SELECT
                COUNT(1)
            INTO list_cnt
            FROM
                TABLE ( lst_ip_all_process_id );

            SELECT
                *
            BULK COLLECT
            INTO lst_all_process_id_bf_hr
            FROM
                TABLE ( lst_ip_hierarchy_id )
            UNION
            SELECT
                *
            FROM
                TABLE ( lst_ip_all_process_id );

            SELECT DISTINCT
                pid
            BULK COLLECT
            INTO lst_all_ip_hierarchy_id
            FROM
                process_entity
            START WITH
                pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_process_id_bf_hr )
                )
            CONNECT BY
                PRIOR pid = parent_id;
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 start */
            SELECT
                COUNT(1)
            INTO v_lst_cnt
            FROM
                TABLE ( lst_all_ip_hierarchy_id );

            IF v_lst_cnt <> 0 THEN
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 END*/
/*TO_RMV_ZRO_FRM_LST_PE_ID_2024 start*/
                FOR all_lst_id_loop IN lst_all_ip_hierarchy_id.first..lst_all_ip_hierarchy_id.last LOOP
                    IF lst_all_ip_hierarchy_id(all_lst_id_loop) = 0 THEN
                        lst_all_ip_hierarchy_id.DELETE(all_lst_id_loop);
                    END IF;
                END LOOP all_lst_id_loop;
/*TO_RMV_ZRO_FRM_LST_PE_ID_2024 end*/
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 START*/
            END IF;
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 END */
/* The below query logic is to get the queue ids associated with multiple API and these queues will not be deleted -- Mohanraj(Requested by Nishanth and Dhaya) */
            SELECT DISTINCT
                action_queue_id
            BULK COLLECT
            INTO lst_queue_ids
            FROM
                (
                    SELECT
                        per.pid,
                        per.process_entity_name,
                        pas.action_queue_id,
                        COUNT(1)
                        OVER(PARTITION BY pas.action_queue_id) cnt_qu,
                        pes.data_load_type,
                        per.type
                    FROM
                        process_action_specification pas,
                        process_entity               pe,
                        process_entity               per,
                        process_entity_specification pes
                    WHERE
                        pas.action_queue_id IN (
                            SELECT DISTINCT
                                action_queue_id
                            FROM
                                process_action_specification
                            WHERE
                                parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND action_queue_id IS NOT NULL
                        )
                        AND pas.parent_id = pe.pid
                        AND pe.root_id = per.pid
                        AND pes.pid = per.pid
                        AND per.type = 'Page'
                        AND per.version = (
                            SELECT
                                MAX(p.version)
                            FROM
                                process_entity p
                            WHERE
                                p.lifecycle_id = per.lifecycle_id
                        )
                )
            WHERE
                cnt_qu > 1;

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_all_ip
                FROM
                    TABLE ( lst_all_ip_hierarchy_id );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_all_ip_hierarchy_id )
                    )
                INTO op_debug_clob_lst_all_ip
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'List lst_all_ip_hierarchy_id , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_all_ip
                                                                                                                                || ' .',
                                                                                                                                'lst_all_ip_hierarchy_id',
                                                                                                                                op_debug_clob_lst_all_ip,
                                          ip_pid.column_value, NULL);

            END IF;
/*AUTH_API_TEMP_DEL_2024 start*/
            SELECT DISTINCT
                pe.pid
            BULK COLLECT
            INTO lst_auth_api_id
            FROM
                process_entity               pe,
                process_entity_specification pes
            WHERE
                pe.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND pe.pid = pes.pid
                AND pes.data_load_type = 'Authentication';

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_all_ip
                FROM
                    TABLE ( lst_auth_api_id );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_auth_api_id )
                    )
                INTO op_debug_clob_lst_auth_api_id
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'List lst_auth_api_id , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_all_ip
                                                                                                                                || ' .',
                                                                                                                                'lst_auth_api_id',
                                                                                                                                op_debug_clob_lst_auth_api_id,
                                          ip_pid.column_value, NULL);

            END IF;

            SELECT
                to_number(template_id) temp_id
            BULK COLLECT
            INTO lst_auth_temp_id
            FROM
                (
                    SELECT
                        pas.default_value template_id,
                        COUNT(1)          cnt
                    FROM
                        (
                            SELECT
                                templateid
                            FROM
                                (
                                    SELECT
                                        pe.root_id        AS apispecid,
                                        pas.display_name  AS templatetype,
                                        pas.default_value AS templateid
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
                                        AND bep.name IN ( 'Outbound Request', 'Outbound Response', 'Inbound Response', 'Inbound Request',
                                        'Error' )
                                        AND bep.parameter_spec_id = pas.parent_id
                                )
                        )                             tmp,
                        parameter_addon_specification pas
                    WHERE
                        pas.default_value = tmp.templateid
                    GROUP BY
                        pas.default_value
                    HAVING
                        COUNT(1) = 1
                );

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_all_ip
                FROM
                    TABLE ( lst_auth_temp_id );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_auth_temp_id )
                    )
                INTO op_debug_clob_lst_auth_api_temp_id
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'List lst_auth_api_id , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_all_ip
                                                                                                                                || ' .',
                                                                                                                                'lst_auth_api_id',
                                                                                                                                op_debug_clob_lst_auth_api_id,
                                          ip_pid.column_value, NULL);

            END IF;

            FOR lst_auth_temp_id_loop IN (
                SELECT DISTINCT
                    pid,
                    parent_id
                FROM
                    process_entity
                START WITH
                    pid IN (
                        SELECT
                            *
                        FROM
                            TABLE ( lst_auth_temp_id )
                    )
                CONNECT BY
                    PRIOR pid = parent_id
            ) LOOP
                lst_all_ip_hierarchy_id.extend();
                lst_all_ip_hierarchy_id(lst_all_ip_hierarchy_id.count) := lst_auth_temp_id_loop.pid;
/*it is specific delete logic to delete the Auth api's template , we have already handled two delete comment for process entity 
1. For delete the process plan template in hierarchy model i.e. with condition of pid and parent_id passed as lst_all_hierarchy and parent_id <> 0 --> Auth api's template has parent_id = 0.
2. To delete the other data apart from 'interface' */
                DELETE FROM process_entity
                WHERE
                        pid = lst_auth_temp_id_loop.pid
                    AND parent_id = lst_auth_temp_id_loop.parent_id;

                IF ip_is_debug_flag = 'Y' THEN
                    op_debug_clob_pe_auth := q'<SELECT * FROM process_entity where pid = >'
                                             || lst_auth_temp_id_loop.pid
                                             || ' and parent_id = '
                                             || lst_auth_temp_id_loop.parent_id;
                    SELECT
                        round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                    INTO l_n_exec_time
                    FROM
                        dual;

                    proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                    1)), 'Table_Name --> AUTH APIs Template PROCESS_ENTITY, Execution Time --> '
                                                                                                                                    ||
                                                                                                                                    l_n_exec_time
                                                                                                                                    ||
                                                                                                                                    ', Query result count --> '
                                                                                                                                    ||
                                                                                                                                    l_n_cnt_pe_auth_temp_id
                                                                                                                                    ||
                                                                                                                                    ' in sec',
                                                                                                                                    op_debug_clob_pe_auth,
                                                                                                                                    'Pid - '
                                                                                                                                     ||
                                                                                                                                     lst_auth_temp_id_loop.
                                                                                                                                     parent_id
                                                                                                                                     ||
                                                                                                                                     ' , Parent_id - '
                                                                                                                                     ||
                                                                                                                                     lst_auth_temp_id_loop.
                                                                                                                                     parent_id,
                                              ip_pid.column_value, NULL);

                END IF;

            END LOOP lst_auth_temp_id_loop;
/*AUTH_API_TEMP_DEL_2024 end*/
            SELECT DISTINCT
                pid
            BULK COLLECT
            INTO lst_parent_proc_ids
            FROM
                (
                    SELECT
                        COUNT(1) cnt,
                        pid
                    FROM
                        process_entity
                    WHERE
                        pid IN (
                            SELECT
                                pid
                            FROM
                                process_entity
                            WHERE
                                parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND type IN ( 'Page', 'Interface' )
                        ) 
  /*TEMP_DLT_MLT_ASSOC_SNGL_PROC_2024 starts*/
                        AND parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
  /*TEMP_DLT_MLT_ASSOC_SNGL_PROC_2024 end*/
                    GROUP BY
                        pid
                )
  /*TEMP_DLT_MLT_ASSOC_CNT_CHK_2024 starts*/
            WHERE
                cnt >= 1
  /*TEMP_DLT_MLT_ASSOC_CNT_CHK_2024 starts*/
            UNION
            SELECT DISTINCT
                template_id
            FROM
                rule
            WHERE
                template_id IS NOT NULL
                AND parent_rule_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
            UNION
            SELECT DISTINCT
                pas.action_process_id
            FROM
                process_action_specification pas,
                process_entity               pe
            WHERE
                    pe.pid = pas.action_process_id
                AND pe.type = 'Interface'
                AND pas.action_process_id <> 0
                AND pas.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                );

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_parent_cnt
                FROM
                    TABLE ( lst_parent_proc_ids );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_parent_proc_ids )
                    )
                INTO op_debug_clob_lst_parent
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'Not in initi List LST_PARENT_PROC_IDS , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_parent_cnt
                                                                                                                                || ' .',
                                                                                                                                'LST_PARENT_PROC_IDS',
                                                                                                                                op_debug_clob_lst_parent,
                                          ip_pid.column_value, NULL);

            END IF;

            SELECT DISTINCT
                pid
            BULK COLLECT
            INTO lst_proc_par_ids
            FROM
                process_entity
            START WITH
                pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_parent_proc_ids )
                )
            CONNECT BY
                PRIOR pid = parent_id;

            FOR ip_queue_id IN (
                SELECT
                    *
                FROM
                    TABLE ( lst_queue_ids )
            ) LOOP
                lst_proc_par_ids.extend();
                lst_proc_par_ids(lst_proc_par_ids.count) := ip_queue_id.column_value;
            END LOOP ip_queue_id;

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_proc_par_ids_cnt
                FROM
                    TABLE ( lst_proc_par_ids );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_proc_par_ids )
                    )
                INTO l_n_del_notin_ids
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'Not in List LST_PROC_PAR_IDS , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_proc_par_ids_cnt
                                                                                                                                || ' .',
                                                                                                                                'LST_PROC_PAR_IDS',
                                                                                                                                l_n_del_notin_ids,
                                          ip_pid.column_value, NULL);

            END IF;

            SELECT DISTINCT
                pe.pid
            BULK COLLECT
            INTO lst_need_delete_pid
            FROM
                process_entity pe
            WHERE
                pe.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND pe.pid NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_parent_proc_ids )
                );

            IF ip_is_debug_flag = 'Y' THEN
                SELECT
                    COUNT(1)
                INTO lst_need_delete_pid_cnt
                FROM
                    TABLE ( lst_need_delete_pid );

                SELECT
                    (
                        SELECT
                            rtrim(xmlagg(xmlelement(e, '('
                                                       || column_value
                                                       || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                        FROM
                            TABLE ( lst_need_delete_pid )
                    )
                INTO op_debug_clob_lst_need_delete
                FROM
                    dual;

                SELECT
                    round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                INTO l_n_exec_time
                FROM
                    dual;

                proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                'Needed Id to delete in process entity List LST_NEED_DELETE_PID , Execution Time --> '
                                                                                                                                || l_n_exec_time
                                                                                                                                || ' in Secs, List record count --> '
                                                                                                                                || lst_need_delete_pid_cnt
                                                                                                                                || ' .',
                                                                                                                                'LST_NEED_DELETE_PID',
                                                                                                                                op_debug_clob_lst_need_delete,
                                          ip_pid.column_value, op_debug_clob_lst_parent);

            END IF;

            FOR template_page_loop IN (
                SELECT
                    pid,
                    parent_id
                FROM
                    (
                        SELECT DISTINCT
                            pid,
                            parent_id
                        FROM
                            process_entity
                        START WITH
                            pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_ip_hierarchy_id )
                            )
                        CONNECT BY
                            PRIOR pid = parent_id
                    )
                WHERE
                    pid IN (
                        SELECT
                            pid
                        FROM
                            (
                                SELECT
                                    COUNT(1) cnt, pid
                                FROM
                                    process_entity
                                WHERE
                                    pid IN (
                                        SELECT
                                            pid
                                        FROM
                                            process_entity
                                        WHERE
                                            parent_id IN (
                                                SELECT
                                                    *
                                                FROM
                                                    TABLE ( lst_all_ip_hierarchy_id )
                                            )
                                            AND type IN ( 'Page', 'Interface' )
                                    )
                                    AND parent_id <> 0
                                GROUP BY
                                    pid
                            )
                        WHERE
                            cnt = 1
                    )
            ) LOOP
                SELECT
                    COUNT(pid)
                INTO del_pid
                FROM
                    process_entity
                WHERE
                        pid = template_page_loop.pid
                    AND parent_id = 0;

                IF del_pid <> 0 THEN
                    DELETE FROM process_entity
                    WHERE
                            pid = template_page_loop.pid
                        AND parent_id = template_page_loop.parent_id;

                    IF ip_is_debug_flag = 'Y' THEN
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Page/Interface delete in process entity with pid and parent_id combination which is not associated with multiple parent .PID --> '
                                                                                                                                        ||
                                                                                                                                        template_page_loop.
                                                                                                                                        pid
                                                                                                                                        ||
                                                                                                                                        ' Parent_id --> '
                                                                                                                                        ||
                                                                                                                                        template_page_loop.
                                                                                                                                        parent_id
                                                                                                                                        ||
                                                                                                                                        ' .',
                                                                                                                                        'template_page_loop',
                                                                                                                                        NULL,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSE
                    UPDATE process_entity
                    SET
                        parent_id = 0
                    WHERE
                            pid = template_page_loop.pid
                        AND parent_id = template_page_loop.parent_id;

                    IF ip_is_debug_flag = 'Y' THEN
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Page/Interface update parent_id as 0 in process entity with pid and parent_id combination which is not associated with multiple parent .PID --> '
                                                                                                                                        ||
                                                                                                                                        template_page_loop.
                                                                                                                                        pid
                                                                                                                                        ||
                                                                                                                                        ' Parent_id --> '
                                                                                                                                        ||
                                                                                                                                        template_page_loop.
                                                                                                                                        parent_id
                                                                                                                                        ||
                                                                                                                                        ' .',
                                                                                                                                        'template_page_loop',
                                                                                                                                        NULL,
                                                  ip_pid.column_value, NULL);

                    END IF;

                END IF;

            END LOOP;

            SELECT
                egf.group_id
            BULK COLLECT
            INTO lst_egf_id
            FROM
                entity_group_function egf
            WHERE
                egf.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND egf.join_pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND egf.pid NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
                AND egf.join_pid NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
            UNION
            SELECT
                egf.group_id
            FROM
                entity_group_function egf
            WHERE
                egf.pid IN (
                    SELECT
                        param_data_spec_id
                    FROM
                        parameter_data_specification
                    WHERE
                        parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                )
                AND egf.pid NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                ejp.group_id
            BULK COLLECT
            INTO lst_ejp_id
            FROM
                entity_join_parameter ejp,
                (
                    SELECT
                        egf.group_id
                    FROM
                        entity_group_function egf
                    WHERE
                        egf.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND egf.join_pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND egf.pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                        AND egf.join_pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        egf.group_id
                    FROM
                        entity_group_function egf
                    WHERE
                        egf.pid IN (
                            SELECT
                                param_data_spec_id
                            FROM
                                parameter_data_specification
                            WHERE
                                parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                        )
                        AND egf.pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )                     egf
            WHERE
                ejp.group_id = egf.group_id;

/*PRT_PIDS_RET_QRY_CMD_2024 START*/
/*        SELECT DISTINCT
            parent_id
        BULK COLLECT
        INTO lst_pe_id
        FROM
            process_entity pe
        WHERE
            pid NOT IN (
                SELECT
                    *
                FROM
                    TABLE ( lst_proc_par_ids )
            )
        CONNECT BY NOCYCLE
            PRIOR pe.pid = pe.parent_id
        START WITH pe.pid IN (
            SELECT
                *
            FROM
                TABLE ( lst_all_ip_hierarchy_id )
        );*/

/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 start */
 /*       SELECT
            COUNT(1)
        INTO v_lst_cnt
        FROM
            TABLE ( lst_pe_id );

        IF v_lst_cnt <> 0 THEN
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 END*/
/*TO_RMV_ZRO_FRM_LST_PE_ID_2024 start*/
            /*FOR lst_pe_id_loop IN lst_pe_id.first..lst_pe_id.last LOOP
                IF lst_pe_id(lst_pe_id_loop) = 0 THEN
                    lst_pe_id.DELETE(lst_pe_id_loop);
                END IF;
            END LOOP lst_pe_id_loop;*/
/*TO_RMV_ZRO_FRM_LST_PE_ID_2024 end*/
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 START*/
    /*    END IF;
/*TO_RETRV_LIST_RMV_ZRO_CNT_2024 END */
      /*  IF ip_is_debug_flag = 'Y' THEN
            SELECT
                COUNT(1)
            INTO lst_pe_id_cnt
            FROM
                TABLE ( lst_pe_id );

            SELECT
                (
                    SELECT
                        rtrim(xmlagg(xmlelement(e, '('
                                                   || column_value
                                                   || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                    FROM
                        TABLE ( lst_pe_id )
                )
            INTO op_debug_clob_lst_pe_id
            FROM
                dual;

            SELECT
                round((dbms_utility.get_time - l_n_starttime) / 100, 2)
            INTO l_n_exec_time
            FROM
                dual;

            proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1)),
                                      'Needed parent_id process entity List lst_pe_id , Execution Time --> '
                                      || l_n_exec_time
                                      || ' in Secs, List record count --> '
                                      || lst_pe_id_cnt
                                      || ' .',
                                      'lst_pe_id',
                                      op_debug_clob_lst_pe_id,
                                      ip_pid.column_value,
                                      l_n_del_notin_ids);

        END IF;
*/
/*PRT_PIDS_RET_QRY_CMD_2024 END*/
            SELECT
                pes.process_spec_id
            BULK COLLECT
            INTO lst_pes_id
            FROM
                process_entity_specification pes
            WHERE
                pes.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                );

            SELECT
                pm.offering_process_id
            BULK COLLECT
            INTO lst_pm_id
            FROM
                product_mapping pm
            WHERE
                pm.offering_process_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                );

            SELECT
                pas.layout_id
            BULK COLLECT
            INTO lst_pls_id
            FROM
                process_layout_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                );

            SELECT
                ps.param_basic_spec_id
            BULK COLLECT
            INTO lst_ps_id
            FROM
                business_process_mapping  bpm,
                business_entity_parameter bep,
                parameter_specification   ps
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND bep.parent_id = bpm.record_key
                AND ps.param_basic_spec_id = bep.parameter_spec_id
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                param_addon_spec_id
            BULK COLLECT
            INTO lst_pas_id
            FROM
                parameter_addon_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_process_mapping  bpm, business_entity_parameter bep
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bep.parent_id = bpm.record_key
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                bpm.record_key
            BULK COLLECT
            INTO lst_bpm_id
            FROM
                business_entity tbe,
                (
                    SELECT
                        bpm.*
                    FROM
                        business_process_mapping bpm
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                )               bpm
            WHERE
                    bpm.entityid = tbe.bid
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                bep.record_key_param
            BULK COLLECT
            INTO lst_bep_id
            FROM
                business_process_mapping  bpm,
                business_entity_parameter bep
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND bep.parent_id = bpm.record_key
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                ctm.custom_templ_map_id
            BULK COLLECT
            INTO lst_cstemp_id
            FROM
                custom_template_mapping ctm,
                (
                    WITH rule_det AS (
                        SELECT DISTINCT
                            r.*
                        FROM
                            business_process_mapping     bpm,
                            business_entity_parameter    bep,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            bpm.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND bep.parent_id = bpm.record_key
                            AND bep.parameter_spec_id = prs.parent_id
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            prs.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            r.parent_rule_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT DISTINCT
                            r.*
                        FROM
                            price_plan_specification       pps,
                            charge_parameter_specification cps,
                            rule                           r
                        WHERE
                            pps.service_entity_id IN (
                                SELECT
                                    bpm.entityid
                                FROM
                                    business_process_mapping bpm
                                WHERE
                                    bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                            )
                            AND cps.charge_item_id = pps.pp_instance_id
                            AND r.rule_id = cps.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            entity_group_function egf,
                            entity_join_parameter ejp,
                            rule                  r
                        WHERE
                            egf.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND egf.group_id = ejp.group_id
                            AND egf.entity_function_id = ejp.entity_function_id
                            AND ejp.mapping_entity_id = r.rule_id
                        UNION
                        SELECT DISTINCT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            process_action_specification pas,
                            rule                         r
                        WHERE
                            pas.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND pas.action_id = prs.parent_id
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            *
                        FROM
                            rule
                        WHERE
                            parent_rule_id IN (
                                SELECT
                                    r.rule_id
                                FROM
                                    parameter_rule_specification prs, rule                         r
                                WHERE
                                    r.parent_rule_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND r.rule_id = prs.rule_id
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule r
                        WHERE
                            r.parent_rule_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            process_entity_specification pes,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                                prs.parent_id = pes.process_spec_id
                            AND pes.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification p
                        WHERE
                            p.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                            )
                            AND p.rule_id = r1.rule_id
                            AND r1.parent_rule_id = r.rule_id
                        UNION
                        SELECT
                            r1.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification p
                        WHERE
                            p.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                            )
                            AND p.rule_id = r1.rule_id
                            AND r1.parent_rule_id = r.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs,
                            (
                                SELECT
                                    rt.*
                                FROM
                                    (
                                        SELECT
                                            ps.param_basic_spec_id,
                                            DENSE_RANK()
                                            OVER(
                                                ORDER BY
                                                    ps.version DESC
                                            ) AS sk
                                        FROM
                                            parameter_specification ps,
                                            business_parameters     bp,
                                            parameter               p
                                        WHERE
                                            bp.bid IN (
                                                SELECT
                                                    be.bid
                                                FROM
                                                    business_entity          be, business_process_mapping bpm
                                                WHERE
                                                        bpm.entityid = be.bid
                                                    AND bpm.parent_id IN (
                                                        SELECT
                                                            *
                                                        FROM
                                                            TABLE ( lst_all_ip_hierarchy_id )
                                                    )
                                            )
                                            AND p.parameter_id = bp.parameter_id
                                            AND ps.parent_id = p.parameter_id
                                            AND ps.core_spec = 'Yes'
                                    ) rt
                                WHERE
                                    sk = 1
                            )                            pbsi
                        WHERE
                                r.rule_id = prs.rule_id
                            AND prs.parent_id = pbsi.param_basic_spec_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs,
                            (
                                SELECT
                                    rt.*
                                FROM
                                    (
                                        SELECT
                                            ps.param_basic_spec_id,
                                            DENSE_RANK()
                                            OVER(
                                                ORDER BY
                                                    ps.version DESC
                                            ) AS sk
                                        FROM
                                            parameter_specification ps
                                        WHERE
                                            ps.parent_id IN (
                                                SELECT DISTINCT
                                                    p.parameter_id
                                                FROM
                                                    table_parameter_mapping       tpm, table_row_specification       trs, table_specification           ts,
                                                    parameter                     p, parameter_specification       ps,
                                                    parameter_addon_specification pas
                                                WHERE
                                                        pas.parent_id (+) = ps.param_basic_spec_id
                                                    AND ps.core_spec != 'Yes'
                                                    AND ps.parent_id = p.parameter_id
                                                    AND p.parameter_id = ps.parent_id
                                                    AND pas.parent_id = ps.param_basic_spec_id
                                                    AND ps.param_basic_spec_id = tpm.parameter_spec_id
                                                    AND tpm.row_spec_id = trs.id
                                                    AND trs.parent_id = ts.id
                                                    AND ts.parent_id IN (
                                                        SELECT
                                                            pes.pid
                                                        FROM
                                                            business_entity              be, business_process_mapping     bpm, process_entity_specification pes,
                                                            process_entity               pe
                                                        WHERE
                                                            be.bid IN (
                                                                SELECT
                                                                    be.bid
                                                                FROM
                                                                    business_entity          be, business_process_mapping bpm
                                                                WHERE
                                                                        bpm.entityid = be.bid
                                                                    AND bpm.parent_id IN (
                                                                        SELECT
                                                                            *
                                                                        FROM
                                                                            TABLE ( lst_all_ip_hierarchy_id )
                                                                    )
                                                            )
                                                            AND bpm.entityid = be.bid
                                                            AND pes.pid = bpm.parent_id
                                                            AND pe.pid = pes.pid
                                                            AND pe.action_type = 'Parameter Group'
                                                    )
                                            )
                                            AND ps.core_spec != 'Yes'
                                    ) rt
                                WHERE
                                    sk = 1
                            )                            pbsi
                        WHERE
                                r.rule_id = prs.rule_id
                            AND prs.parent_id = pbsi.param_basic_spec_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            (
                                SELECT DISTINCT
                                    ebc.entity_id
                                FROM
                                    entity_boundary_condition ebc
                                WHERE
                                    ebc.entity_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                            )    ebc,
                            rule r
                        WHERE
                            r.entity_id = ebc.entity_id
                    )
                    SELECT
                        r.rule_id,
                        r.parent_rule_id
                    FROM
                        rule_det r
                    UNION
                    SELECT
                        r.rule_id,
                        r.parent_rule_id
                    FROM
                        rule_det rd,
                        rule     r
                    WHERE
                        r.parent_rule_id = rd.rule_id
                )                       ss
            WHERE
                ss.rule_id = ctm.entity_id;

/* The below parameter rule Specification fetch delete query has been changed for --> parameter rule Specification data not getting deleted , due to the in rule table we have added the logic not exists of parameter rule Specification table.
So, data not getting delete from rule table because of parameter rule Specification record not getting deleted , So that logic has been modified 
*/

            SELECT
                prs.param_rule_spec_id
            BULK COLLECT
            INTO lst_prs_id
            FROM
                business_process_mapping     bpm,
                business_entity_parameter    bep,
                parameter_rule_specification prs
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND bep.parent_id = bpm.record_key
                AND bep.parameter_spec_id = prs.parent_id
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
            UNION
            SELECT
                prs.param_rule_spec_id
            FROM
                price_plan_specification       pps,
                charge_parameter_specification cps,
                parameter_rule_specification   prs
            WHERE
                pps.service_entity_id IN (
                    SELECT
                        bpm.entityid
                    FROM
                        business_process_mapping bpm
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
                AND cps.charge_item_id = pps.pp_instance_id
                AND prs.rule_id = cps.rule_id
            UNION
            SELECT
                param_rule_spec_id
            FROM
                parameter_rule_specification
            WHERE
                rule_id IN (
                    SELECT
                        r.rule_id
                    FROM
                        process_entity pe, rule           r
                    WHERE
                            pe.pid = r.parent_rule_id
                        AND pe.type = 'Rule'
                        AND pe.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
/*CHD_PARAM_RUL_DLT_2024 start*/
                    UNION
                    SELECT
                        r1.rule_id
                    FROM
                        process_entity pe, rule           r, rule           r1
                    WHERE
                            r.rule_id = r1.parent_rule_id
                        AND pe.pid = r.parent_rule_id
                        AND pe.type = 'Rule'
                        AND pe.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
	/*CHD_PARAM_RUL_DLT_2024 end*/
                )
            UNION
            SELECT
                param_rule_spec_id
            FROM
                parameter_rule_specification
            WHERE
                rule_id IN (
                    SELECT
                        rule_id
                    FROM
                        rule
                    WHERE
                        entity_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                    UNION
                    SELECT
                        param_rule_spec_id
                    FROM
                        parameter_rule_specification
                    WHERE
                        rule_id IN (
                            SELECT
                                r1.rule_id
                            FROM
                                rule r, rule r1
                            WHERE
                                r.entity_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND r.rule_id = r1.parent_rule_id
                        )
                )
            UNION
     /* RULE_ASSOC_TO_OFFR_DLT_2024 STARTS*/
            SELECT
                prs.param_rule_spec_id
            FROM
                rule                         r,
                parameter_rule_specification prs
            WHERE
                prs.parent_bid IN (
                    SELECT
                        be.bid
                    FROM
                        business_entity          be, business_process_mapping bpm
                    WHERE
                            bpm.entityid = be.bid
                        AND bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
                AND prs.rule_id = r.rule_id
            UNION
            SELECT
                prs1.param_rule_spec_id
            FROM
                rule                         r,
                rule                         r1,
                parameter_rule_specification prs,
                parameter_rule_specification prs1
            WHERE
                prs.parent_bid IN (
                    SELECT
                        be.bid
                    FROM
                        business_entity          be, business_process_mapping bpm
                    WHERE
                            bpm.entityid = be.bid
                        AND bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
                AND prs.rule_id = r.rule_id
                AND r.parent_rule_id = r1.rule_id
                AND r1.rule_id = prs1.rule_id
    /*RULE_ASSOC_TO_OFFR_DLT_2024 ENDS*/
            UNION
	/*API_FUNC_RULE_GRID_ENH_2024 STARTS*/
            SELECT
                prs.param_rule_spec_id
            FROM
                rule                         r,
                parameter_rule_specification prs,
                table_specification          ts,
                table_row_specification      trs
            WHERE
                ts.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND ts.id = trs.parent_id
                AND trs.id = r.row_spec_id
                AND r.rule_id = prs.rule_id
            UNION
            SELECT
                prs.param_rule_spec_id
            FROM
                rule                         r,
                rule                         r1,
                parameter_rule_specification prs,
                table_specification          ts,
                table_row_specification      trs
            WHERE
                ts.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND ts.id = trs.parent_id
                AND trs.id = r.row_spec_id
                AND r.rule_id = r1.parent_rule_id
                AND r1.rule_id = prs.rule_id
	/*API_FUNC_RULE_GRID_ENH_2024 ENDS*/
            UNION
            SELECT
                p.param_rule_spec_id
            FROM
                rule                         r,
                rule                         r1,
                parameter_rule_specification p
            WHERE
                p.parent_id IN (
                    SELECT
                        be.bid
                    FROM
                        business_entity          be, business_process_mapping bpm
                    WHERE
                            bpm.entityid = be.bid
                        AND bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
                AND p.rule_id = r1.rule_id
                AND r1.parent_rule_id = r.rule_id
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
                AND 1 = (
                    CASE
                        WHEN r.entity_type_id IS NOT NULL
                             AND r.entity_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        ) THEN
                            1
                        WHEN r.entity_type_id IS NULL THEN
                            1
                        WHEN r.entity_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        ) THEN
                            0
                    END
                )
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/
            UNION
   /*TO_FTH_REF_TYP_VAL_EXP_RUL_2024 STARTS*/
            SELECT
                prs.param_rule_spec_id
            FROM
                parameter_rule_specification prs,
                (
                    SELECT
                        r.*
                    FROM
                        reference_type_values        rtv,
                        reference_types              rt,
                        parameter_rule_specification prs,
                        rule                         r
                    WHERE
                        prs.parent_id IN (
                            SELECT
                                be.bid
                            FROM
                                business_entity          be, business_process_mapping bpm
                            WHERE
                                    bpm.entityid = be.bid
                                AND bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND bpm.parent_id NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                        )
                        AND prs.expression_type = 'Reference'
                        AND rtv.ref_val_id = prs.reference_value
                        AND rt.ref_type_id = rtv.ref_type_id
                        AND r.rule_id = prs.rule_id
                    UNION
                    SELECT
                        r1.*
                    FROM
                        reference_type_values        rtv,
                        reference_types              rt,
                        parameter_rule_specification prs,
                        rule                         r,
                        rule                         r1
                    WHERE
                        prs.parent_id IN (
                            SELECT
                                be.bid
                            FROM
                                business_entity          be, business_process_mapping bpm
                            WHERE
                                    bpm.entityid = be.bid
                                AND bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND bpm.parent_id NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                        )
                        AND prs.expression_type = 'Reference'
                        AND rtv.ref_val_id = prs.reference_value
                        AND rt.ref_type_id = rtv.ref_type_id
                        AND r.rule_id = prs.rule_id
                        AND r.rule_id = r1.rule_id
                )                            r
            WHERE
                prs.rule_id = r.rule_id;
   /*TO_FTH_REF_TYP_VAL_EXP_RUL_2024 ENDS*/

            SELECT
                rule_id
            BULK COLLECT
            INTO lst_rule_val
            FROM
                (
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        parameter_rule_specification prs,
                        rule                         r
                    WHERE
                        prs.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND r.rule_id = prs.rule_id
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        parameter_rule_specification prs,
                        rule                         r
                    WHERE
                        r.parent_rule_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND r.rule_id = prs.rule_id
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        entity_join_parameter        ejp,
                        rule                         r,
                        entity_group_function        egf,
                        parameter_rule_specification prs
                    WHERE
                        egf.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND egf.pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                        AND egf.group_id = ejp.group_id
                        AND egf.entity_function_id = ejp.entity_function_id
                        AND ejp.mapping_entity_id = r.rule_id
                        AND r.rule_id = prs.rule_id
                    UNION
                    SELECT DISTINCT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        parameter_rule_specification prs,
                        process_action_specification pas,
                        rule                         r
                    WHERE
                        pas.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND pas.action_id = prs.parent_id
                        AND r.rule_id = prs.rule_id
                        AND pas.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        prs.rule_id
                    FROM
                        process_entity_specification pes,
                        parameter_rule_specification prs
                    WHERE
                            prs.parent_id = pes.process_spec_id
                        AND pes.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        rule                         r,
                        parameter_rule_specification prs
                    WHERE
                        parent_rule_id IN (
                            SELECT
                                r.rule_id
                            FROM
                                parameter_rule_specification prs, rule                         r
                            WHERE
                                r.parent_rule_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND r.rule_id = prs.rule_id
                        )
                        AND r.rule_id = prs.rule_id
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                pds.param_data_spec_id
            BULK COLLECT
            INTO lst_pds_id
            FROM
                parameter_data_specification pds
            WHERE
                pds.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND pds.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
            UNION
            SELECT
                pds.param_data_spec_id
            FROM
                parameter_data_specification pds
            WHERE
                pds.parent_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_process_mapping  bpm, business_entity_parameter bep
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bep.parent_id = bpm.record_key
                )
                AND pds.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                tbsp.id
            BULK COLLECT
            INTO lst_tsid_id
            FROM
                table_specification tbsp
            WHERE
                tbsp.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                );

            SELECT
                tbrsp.id
            BULK COLLECT
            INTO lst_tbrsp_id
            FROM
                table_row_specification tbrsp
            WHERE
                tbrsp.parent_id IN (
                    SELECT
                        ts.id
                    FROM
                        table_specification ts
                    WHERE
                        ts.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND ts.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                tpm.row_spec_id
            BULK COLLECT
            INTO lst_tbm_id
            FROM
                table_row_specification tbrsp,
                table_parameter_mapping tpm
            WHERE
                tbrsp.parent_id IN (
                    SELECT
                        ts.id
                    FROM
                        table_specification ts
                    WHERE
                        ts.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND tbrsp.id = tpm.row_spec_id
                        AND ts.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                pas.action_id
            BULK COLLECT
            INTO lst_pacts_id
            FROM
                process_action_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND pas.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
            UNION
            SELECT
                pas.action_id
            FROM
                process_action_specification pas
            WHERE
                pas.parent_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_process_mapping  bpm, business_entity_parameter bep
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bep.parent_id = bpm.record_key
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                aip.action_spec_id
            BULK COLLECT
            INTO lst_aip_id
            FROM
                (
                    SELECT DISTINCT
                        pas.*
                    FROM
                        process_action_specification pas
                    WHERE
                        pas.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND pas.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        pas.*
                    FROM
                        process_action_specification pas
                    WHERE
                        pas.parent_id IN (
                            SELECT
                                bep.parameter_spec_id
                            FROM
                                business_process_mapping  bpm, business_entity_parameter bep
                            WHERE
                                bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND bep.parent_id = bpm.record_key
                                AND bpm.parent_id NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                        )
                )                      pas,
                action_input_parameter aip
            WHERE
                pas.action_id = aip.action_spec_id;

            SELECT
                scm.group_id
            BULK COLLECT
            INTO lst_scm_id
            FROM
                service_column_metadata scm
            WHERE
                group_id IN (
                    SELECT
                        bep.parameter_spec_id
                    FROM
                        business_process_mapping  bpm, business_entity_parameter bep
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bep.parent_id = bpm.record_key
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                rule_id
            BULK COLLECT
            INTO lst_r_id
            FROM
                (
                    WITH rule_det AS (
                        SELECT DISTINCT
                            r.*
                        FROM
                            business_process_mapping     bpm,
                            business_entity_parameter    bep,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            bpm.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND bep.parent_id = bpm.record_key
                            AND bep.parameter_spec_id = prs.parent_id
                            AND r.rule_id = prs.rule_id
                            AND bpm.parent_id NOT IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            prs.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
	/*RUL_DLT_ADD_TYP_CON_2024 start*/
                        SELECT
                            r.*
                        FROM
                            rule           r,
                            process_entity pe
                        WHERE
                            pe.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND pe.type = 'Rule'
                            AND r.parent_rule_id = pe.pid
	/*RUL_DLT_ADD_TYP_CON_2024 end*/
	/*CHD_RUL_DLT_2024 start*/
                        UNION
                        SELECT
                            r1.*
                        FROM
                            rule           r,
                            rule           r1,
                            process_entity pe
                        WHERE
                            pe.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND pe.type = 'Rule'
                            AND r.parent_rule_id = pe.pid
                            AND r.rule_id = r1.parent_rule_id
	/*CHD_RUL_DLT_2024 end*/
                        UNION
                        SELECT DISTINCT
                            r.*
                        FROM
                            price_plan_specification       pps,
                            charge_parameter_specification cps,
                            rule                           r
                        WHERE
                            pps.service_entity_id IN (
                                SELECT
                                    bpm.entityid
                                FROM
                                    business_process_mapping bpm
                                WHERE
                                    bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND cps.charge_item_id = pps.pp_instance_id
                            AND r.rule_id = cps.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            entity_group_function egf,
                            entity_join_parameter ejp,
                            rule                  r
                        WHERE
                            egf.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND egf.group_id = ejp.group_id
                            AND egf.entity_function_id = ejp.entity_function_id
                            AND ejp.mapping_entity_id = r.rule_id
                        UNION
                        SELECT DISTINCT
                            r.*
                        FROM
                            parameter_rule_specification prs,
                            process_action_specification pas,
                            rule                         r
                        WHERE
                            pas.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND pas.action_id = prs.parent_id
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            *
                        FROM
                            rule
                        WHERE
                            parent_rule_id IN (
                                SELECT
                                    r.rule_id
                                FROM
                                    parameter_rule_specification prs, rule                         r
                                WHERE
                                    r.parent_rule_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND r.rule_id = prs.rule_id
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule r
                        WHERE
                            r.parent_rule_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                        UNION
                        SELECT
                            r.*
                        FROM
                            process_entity_specification pes,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                                prs.parent_id = pes.process_spec_id
                            AND pes.pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification p
                        WHERE
                            p.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND p.rule_id = r1.rule_id
                            AND r1.parent_rule_id = r.rule_id
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
                            AND 1 = (
                                CASE
                                    WHEN r.entity_type_id IS NOT NULL
                                         AND r.entity_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    ) THEN
                                        1
                                    WHEN r.entity_type_id IS NULL THEN
                                        1
                                    WHEN r.entity_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    ) THEN
                                        0
                                END
                            )
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/

                        UNION
                        SELECT
                            r1.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification p
                        WHERE
                            p.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND p.rule_id = r1.rule_id
                            AND r1.parent_rule_id = r.rule_id
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
                            AND 1 = (
                                CASE
                                    WHEN r.entity_type_id IS NOT NULL
                                         AND r.entity_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    ) THEN
                                        1
                                    WHEN r.entity_type_id IS NULL THEN
                                        1
                                    WHEN r.entity_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    ) THEN
                                        0
                                END
                            )
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/

                        UNION
        /*RULE_ASSOC_TO_OFFR_DLT_2024 STARTS*/
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs
                        WHERE
                            prs.parent_bid IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND prs.rule_id = r.rule_id
                        UNION
                        SELECT
                            r1.*
                        FROM
                            rule                         r,
                            rule                         r1,
                            parameter_rule_specification prs
                        WHERE
                            prs.parent_bid IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND prs.rule_id = r.rule_id
                            AND r.parent_rule_id = r1.rule_id
        /*RULE_ASSOC_TO_OFFR_DLT_2024 ENDS*/
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs,
                            (
                                SELECT
                                    rt.*
                                FROM
                                    (
                                        SELECT
                                            ps.param_basic_spec_id,
                                            DENSE_RANK()
                                            OVER(
                                                ORDER BY
                                                    ps.version DESC
                                            ) AS sk
                                        FROM
                                            parameter_specification ps,
                                            business_parameters     bp,
                                            parameter               p
                                        WHERE
                                            bp.bid IN (
                                                SELECT
                                                    be.bid
                                                FROM
                                                    business_entity          be, business_process_mapping bpm
                                                WHERE
                                                        bpm.entityid = be.bid
                                                    AND bpm.parent_id IN (
                                                        SELECT
                                                            *
                                                        FROM
                                                            TABLE ( lst_all_ip_hierarchy_id )
                                                    )
                                                    AND bpm.parent_id NOT IN (
                                                        SELECT
                                                            *
                                                        FROM
                                                            TABLE ( lst_proc_par_ids )
                                                    )
                                            )
                                            AND p.parameter_id = bp.parameter_id
                                            AND ps.parent_id = p.parameter_id
                                            AND ps.core_spec = 'Yes'
                                    ) rt
                                WHERE
                                    sk = 1
                            )                            pbsi
                        WHERE
                                r.rule_id = prs.rule_id
                            AND prs.parent_id = pbsi.param_basic_spec_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            rule                         r,
                            parameter_rule_specification prs,
                            (
                                SELECT
                                    rt.*
                                FROM
                                    (
                                        SELECT
                                            ps.param_basic_spec_id,
                                            DENSE_RANK()
                                            OVER(
                                                ORDER BY
                                                    ps.version DESC
                                            ) AS sk
                                        FROM
                                            parameter_specification ps
                                        WHERE
                                            ps.parent_id IN (
                                                SELECT DISTINCT
                                                    p.parameter_id
                                                FROM
                                                    table_parameter_mapping       tpm, table_row_specification       trs, table_specification           ts,
                                                    parameter                     p, parameter_specification       ps,
                                                    parameter_addon_specification pas
                                                WHERE
                                                        pas.parent_id (+) = ps.param_basic_spec_id
                                                    AND ps.core_spec != 'Yes'
                                                    AND ps.parent_id = p.parameter_id
                                                    AND p.parameter_id = ps.parent_id
                                                    AND pas.parent_id = ps.param_basic_spec_id
                                                    AND ps.param_basic_spec_id = tpm.parameter_spec_id
                                                    AND tpm.row_spec_id = trs.id
                                                    AND trs.parent_id = ts.id
                                                    AND ts.parent_id IN (
                                                        SELECT
                                                            pes.pid
                                                        FROM
                                                            business_entity              be, business_process_mapping     bpm, process_entity_specification pes,
                                                            process_entity               pe
                                                        WHERE
                                                            be.bid IN (
                                                                SELECT
                                                                    be.bid
                                                                FROM
                                                                    business_entity          be, business_process_mapping bpm
                                                                WHERE
                                                                        bpm.entityid = be.bid
                                                                    AND bpm.parent_id IN (
                                                                        SELECT
                                                                            *
                                                                        FROM
                                                                            TABLE ( lst_all_ip_hierarchy_id )
                                                                    )
                                                                    AND bpm.parent_id NOT IN (
                                                                        SELECT
                                                                            *
                                                                        FROM
                                                                            TABLE ( lst_proc_par_ids )
                                                                    )
                                                            )
                                                            AND bpm.entityid = be.bid
                                                            AND pes.pid = bpm.parent_id
                                                            AND pe.pid = pes.pid
                                                            AND pe.action_type = 'Parameter Group'
                                                    )
                                            )
                                            AND ps.core_spec != 'Yes'
                                    ) rt
                                WHERE
                                    sk = 1
                            )                            pbsi
                        WHERE
                                r.rule_id = prs.rule_id
                            AND prs.parent_id = pbsi.param_basic_spec_id
                        UNION
                        SELECT
                            r.*
                        FROM
                            (
                                SELECT DISTINCT
                                    ebc.entity_id
                                FROM
                                    entity_boundary_condition ebc
                                WHERE
                                    ebc.entity_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                            )    ebc,
                            rule r
                        WHERE
                            r.entity_id = ebc.entity_id
                        UNION
	/*API_FUNC_RULE_GRID_ENH_2024 STARTS*/
                        SELECT
                            r.*
                        FROM
                            rule                    r,
                            table_specification     ts,
                            table_row_specification trs
                        WHERE
                            ts.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND ts.id = trs.parent_id
                            AND trs.id = r.row_spec_id
                        UNION
                        SELECT
                            r1.*
                        FROM
                            rule                    r,
                            rule                    r1,
                            table_specification     ts,
                            table_row_specification trs
                        WHERE
                            ts.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND ts.id = trs.parent_id
                            AND trs.id = r.row_spec_id
                            AND r.rule_id = r1.parent_rule_id
	/*API_FUNC_RULE_GRID_ENH_2024 ENDS*/
                        UNION
	/*TO_FTH_REF_TYP_VAL_EXP_RUL_2024 STARTS*/
                        SELECT
                            r.*
                        FROM
                            reference_type_values        rtv,
                            reference_types              rt,
                            parameter_rule_specification prs,
                            rule                         r
                        WHERE
                            prs.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND prs.expression_type = 'Reference'
                            AND rtv.ref_val_id = prs.reference_value
                            AND rt.ref_type_id = rtv.ref_type_id
                            AND r.rule_id = prs.rule_id
                        UNION
                        SELECT
                            r1.*
                        FROM
                            reference_type_values        rtv,
                            reference_types              rt,
                            parameter_rule_specification prs,
                            rule                         r,
                            rule                         r1
                        WHERE
                            prs.parent_id IN (
                                SELECT
                                    be.bid
                                FROM
                                    business_entity          be, business_process_mapping bpm
                                WHERE
                                        bpm.entityid = be.bid
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND prs.expression_type = 'Reference'
                            AND rtv.ref_val_id = prs.reference_value
                            AND rt.ref_type_id = rtv.ref_type_id
                            AND r.rule_id = prs.rule_id
                            AND r.rule_id = r1.rule_id
	/*TO_FTH_REF_TYP_VAL_EXP_RUL_2024 ENDS*/
                    )
                    SELECT
                        r.*
                    FROM
                        rule_det r
                );

            SELECT
                param_rule_spec_id
            BULK COLLECT
            INTO lst_param_rule_spec
            FROM
                (
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        parameter_rule_specification prs,
                        rule                         r
                    WHERE
                        prs.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND r.rule_id = prs.rule_id
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        parameter_rule_specification prs,
                        rule                         r
                    WHERE
                        r.parent_rule_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND r.rule_id = prs.rule_id
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        entity_join_parameter        ejp,
                        rule                         r,
                        entity_group_function        egf,
                        parameter_rule_specification prs
                    WHERE
                        egf.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND egf.pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                        AND egf.group_id = ejp.group_id
                        AND egf.entity_function_id = ejp.entity_function_id
                        AND ejp.mapping_entity_id = r.rule_id
                        AND r.rule_id = prs.rule_id
                    UNION
                    SELECT DISTINCT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        parameter_rule_specification prs,
                        process_action_specification pas,
                        rule                         r
                    WHERE
                        pas.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND pas.action_id = prs.parent_id
                        AND r.rule_id = prs.rule_id
                        AND pas.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        prs.rule_id
                    FROM
                        process_entity_specification pes,
                        parameter_rule_specification prs
                    WHERE
                            prs.parent_id = pes.process_spec_id
                        AND pes.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                    UNION
                    SELECT
                        prs.param_rule_spec_id,
                        r.rule_id
                    FROM
                        rule                         r,
                        parameter_rule_specification prs
                    WHERE
                        parent_rule_id IN (
                            SELECT
                                r.rule_id
                            FROM
                                parameter_rule_specification prs, rule                         r
                            WHERE
                                r.parent_rule_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND r.rule_id = prs.rule_id
                        )
                        AND r.rule_id = prs.rule_id
                        AND prs.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );

            SELECT
                pp_instance_id,
                price_plan_id
            BULK COLLECT
            INTO lst_pp_spec_val
            FROM
                price_plan_specification pps
            WHERE
                pps.service_entity_id IN (
                    SELECT
                        bpm.entityid
                    FROM
                        business_process_mapping bpm
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
            UNION
            SELECT
                pps.pp_instance_id,
                pps.price_plan_id
            FROM
                price_plan_specification pps,
                price_plan_entity        ppe
            WHERE
                ppe.entity_id IN (
                    SELECT
                        bpm.entityid
                    FROM
                        business_process_mapping bpm
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
                AND ppe.plan_id = pps.price_plan_id;

            SELECT
                cps.charge_instance_id
            BULK COLLECT
            INTO lst_cps_id
            FROM
                price_plan_specification       pps,
                charge_parameter_specification cps
            WHERE
                pps.service_entity_id IN (
                    SELECT
                        bpm.entityid
                    FROM
                        business_process_mapping bpm
                    WHERE
                        bpm.parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND bpm.parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                )
                AND cps.charge_item_id = pps.pp_instance_id
            UNION
            SELECT
                charge_instance_id
            FROM
                charge_parameter_specification
            WHERE
                rule_id IN (
                    SELECT
                        prs.rule_id
                    FROM
                        price_plan_specification       pps, charge_parameter_specification cps, parameter_rule_specification   prs
                    WHERE
                        pps.service_entity_id IN (
                            SELECT
                                bpm.entityid
                            FROM
                                business_process_mapping bpm
                            WHERE
                                bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND bpm.parent_id NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                        )
                        AND cps.charge_item_id = pps.pp_instance_id
                        AND prs.rule_id = cps.rule_id
                );

            SELECT
                prv.param_spec_id
            BULK COLLECT
            INTO lst_prv_id
            FROM
                business_process_mapping  bpm,
                business_entity_parameter bep,
                parameter_reference_value prv
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND bpm.record_key = bep.parent_id
                AND bep.parameter_spec_id = prv.param_spec_id
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
            UNION
            SELECT
                prv.param_spec_id
            FROM
                parameter_reference_value prv
            WHERE
                prv.entity_specification_type IN ( 'Process Plan', 'Page' )
                AND prv.param_spec_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND prv.param_spec_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                si.script_group_id
            BULK COLLECT
            INTO lst_si_id
            FROM
                process_entity_specification pes,
                parameter_rule_specification prs,
                script_info                  si
            WHERE
                    si.script_group_id = prs.rule_script_id
                AND prs.parent_id = pes.process_spec_id
                AND pes.pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND prs.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                pe.pid
            BULK COLLECT
            INTO lst_st_id
            FROM
                process_entity               pe,
                process_entity_specification pes
            WHERE
                pe.root_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND pe.pid = pes.pid
                AND pes.task_type = 'Script Task'
                AND pe.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                );

            SELECT
                pid
            BULK COLLECT
            INTO lst_ebc_id
            FROM
                process_entity
            WHERE
                    type = 'Step'
                AND pid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                );

            SELECT
                bes.root_id
            BULK COLLECT
            INTO lst_bes_id
            FROM
                business_process_mapping      bpm,
                business_entity_specification bes,
                business_entity               be
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND be.bid = bpm.entityid
                AND be.bid = bes.root_id;

            SELECT
                uap.usr_auth_proc_mapping_id
            BULK COLLECT
            INTO lst_uapm_id
            FROM
                user_auth_process_mapping uap
            WHERE
                uap.auth_process_id IN (
                    SELECT
                        pe.lifecycle_id
                    FROM
                        process_entity pe
                    WHERE
                        pe.pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND pe.pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        )
                );
 /*PARAM_FUNCT_SPEC_DEL_2024 start*/
            SELECT
                pfs.param_func_spec_id
            BULK COLLECT
            INTO lst_param_funct_spec_id
            FROM
                (
                    SELECT
                        pas.parent_id
                    FROM
                        parameter_addon_specification pas
                    WHERE
                        pas.parent_id IN (
                            SELECT
                                bep.parameter_spec_id
                            FROM
                                business_process_mapping  bpm, business_entity_parameter bep
                            WHERE
                                bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND bpm.parent_id NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                                AND bep.parent_id = bpm.record_key
                        )
                )                            pas1,
                parameter_func_specification pfs
            WHERE
                pfs.param_spec_id = pas1.parent_id;
 /*PARAM_FUNCT_SPEC_DEL_2024 end*/

            SELECT DISTINCT
                pcd.product_code_id
            BULK COLLECT
            INTO lst_prod_code_id
            FROM
                entity_product_code_mapping epcm,
                business_process_mapping    bpm,
                product_code_details        pcd
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
                AND bpm.entityid = epcm.business_entity_id
                AND epcm.product_code_id = pcd.product_code_id;

            SELECT DISTINCT
                epcm.entity_prd_cd_id
            BULK COLLECT
            INTO lst_entity_prd_cd_id
            FROM
                entity_product_code_mapping epcm,
                business_process_mapping    bpm
            WHERE
                bpm.parent_id IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_all_ip_hierarchy_id )
                )
                AND bpm.parent_id NOT IN (
                    SELECT
                        *
                    FROM
                        TABLE ( lst_proc_par_ids )
                )
                AND bpm.entityid = epcm.business_entity_id;

            FOR tab IN (
                SELECT
                    ut.table_name
                FROM
                    user_tables                  ut,
                    metadata_export_table_config metc
                WHERE
                        ut.table_name = metc.metadata_table_name
                    AND metc.metadata_entity_type = 'Process Plan'
                ORDER BY
                    metc.metadata_table_delete_seq
            ) LOOP
                IF tab.table_name IN ( 'PROCESS_ENTITY' ) THEN
                    l_n_starttime := dbms_utility.get_time;

/*TO_DLT_TEMP_PROC_ASSOC_IN_PE_TBL_2024 start*/
/*Removing this block due to deleting interface associated with other parents --> this changes uncommented for the TO_DLT_TEMP_PROC_ASSOC_IN_PE_TBL_2024
*/
/*PRT_PIDS_RET_QRY_CMD_2024 START*/
/*                DELETE FROM process_entity
                WHERE
                    pid IN (
                        SELECT
                            *
                        FROM
                            TABLE ( lst_parent_proc_ids )
                    )
                    AND parent_id IN (
                        SELECT
                            *
                        FROM
                            TABLE ( lst_pe_id )
                    )
                    AND type = 'Interface'
                    AND parent_id <> 0;*/
/*PRT_PIDS_RET_QRY_CMD_2024 END*/
/*PRT_PIDS_RET_QRY_CMD_2024 START*/
/*To delete the particular association of template and step (Task) for respective releasing processplan/APIs.*/

                    FOR upd_multi_parent IN (
                        SELECT
                            pid,
                            parent_id
                        FROM
                            process_entity
                        WHERE
                            pid IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                            AND type = 'Page'
                            AND parent_id <> 0
                            AND parent_id IN (
                                SELECT DISTINCT
                                    parent_id
                                FROM
                                    process_entity
                                START WITH
                                    pid IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( ip_process_id )
                                    )
                                CONNECT BY
                                    PRIOR pid = parent_id
                            )
                    ) LOOP
                        BEGIN
                            UPDATE process_entity
                            SET
                                parent_id = 0
                            WHERE
                                    pid = upd_multi_parent.pid
                                AND parent_id = upd_multi_parent.parent_id;

                        EXCEPTION
                            WHEN dup_val_on_index THEN
                                DELETE FROM process_entity
                                WHERE
                                        pid = upd_multi_parent.pid
                                    AND parent_id = upd_multi_parent.parent_id;

                        END;
                    END LOOP upd_multi_parent;

                    DELETE FROM process_entity
                    WHERE
                            type = 'Interface'
                        AND pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND parent_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_all_ip_hierarchy_id )
                        )
                        AND parent_id <> 0;
/*PRT_PIDS_RET_QRY_CMD_2024 End*/
                    IF ip_is_debug_flag = 'Y' THEN
                        l_n_cnt_pe := SQL%rowcount;
                        op_debug_clob_pe := q'<SELECT * FROM process_entity where type ='Interface' and (pid,0) in (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, '('
                                                               || column_value
                                                               || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                        INTO op_clob_pe_ids1
                        FROM
                            dual;
    /*PRT_PIDS_RET_QRY_CMD_2024 start*/
	/*To COMMENT the trace logic of needed list pids - For PRT_PIDS_RET_QRY_CMD_2024*/
                  /*  SELECT
                        (
                            SELECT
                                rtrim(xmlagg(xmlelement(e, '('
                                                           || column_value
                                                           || ',0)', ', ').extract('//text()')).getclobval(),
                                      ', ')
                            FROM
                                TABLE ( lst_need_delete_pid )
                        )
                    INTO op_clob_pe_ids2
                    FROM
                        dual;*/
  /*PRT_PIDS_RET_QRY_CMD_2024 end*/
                        op_debug_clob_pe := op_debug_clob_pe
                                            || op_clob_pe_ids1
                                            || q'<) and (parent_id,0) in (>'
                                            || chr(10)
                                            || op_clob_pe_ids1
                                            || ' and parent_id <> 0 ;';

                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            'Pid: '
                            || rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
					/*PRT_PIDS_RET_QRY_CMD_2024 START*/
                            TABLE ( lst_all_ip_hierarchy_id );
					/*PRT_PIDS_RET_QRY_CMD_2024 END*/
                        SELECT
                            'Parent_id: '
                            || rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_parent_ids
                        FROM
					/*PRT_PIDS_RET_QRY_CMD_2024 START*/
                            TABLE ( lst_all_ip_hierarchy_id );
					/*PRT_PIDS_RET_QRY_CMD_2024 END*/

                        l_n_del_ids := l_n_del_ids
                                       || chr(10)
                                       || l_n_del_parent_ids;
                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ENTITY, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pe
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pe,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                    DELETE FROM process_entity
                    WHERE
                        ( pid, parent_id ) IN (
                            SELECT
                                pe.pid, parent_id
                            FROM
                                process_entity pe
                            WHERE
                                pid NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                        /*PRT_PIDS_RET_QRY_CMD_2024 start*/
						/*To delete the other entities apart from template in process entity table*/
                                AND pid IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND type <> 'Interface' 
                        /*PRT_PIDS_RET_QRY_CMD_2024 END*/
                        );

                    l_n_cnt_pe1 := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, '('
                                                               || column_value
                                                               || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                        INTO op_clob_not_pe2_ids
                        FROM
                            dual;

                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, '('
                                                               || column_value
                                                               || ',0)', ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                        INTO op_clob_pe1_ids
                        FROM
                            dual;

                        op_debug_clob_pe1 := q'<SELECT * FROM process_entity
      WHERE (pid,parent_id) IN
        (SELECT pe.pid,parent_id
        FROM process_entity pe
        where (pid,0) not in (>'
                                             || op_clob_not_pe2_ids
                                             || q'< ) and (pe.pid,0) IN (>'
                                             || op_clob_pe1_ids
                                             || ') and type <> ''Interface'' );';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            'Pid: '
                            || rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_need_delete_pid );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ENTITY (Delete with pid and parent_id combination), Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pe1
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pe1,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'PROCESS_ENTITY_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM process_entity_specification
                    WHERE
                        process_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pes_id )
                        )
                        AND pid NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        );

                    l_n_cnt_pes := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pes := q'<SELECT * FROM PROCESS_ENTITY_SPECIFICATION
      WHERE PROCESS_SPEC_ID IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pes_id )
                            )
                        INTO op_clob_pes_ids1
                        FROM
                            dual;

                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                        INTO op_clob_pes_ids2
                        FROM
                            dual;

                        op_debug_clob_pes := op_debug_clob_pes
                                             || op_clob_pes_ids1
                                             || chr(10)
                                             || q'<) and pid  not in (>'
                                             || op_clob_pes_ids2
                                             || ');';

                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pes_id );

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_notin_ids
                        FROM
                            TABLE ( lst_proc_par_ids );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ENTITY_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pes
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pes,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'PROCESS_LAYOUT_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM process_layout_specification
                    WHERE
                        layout_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pls_id )
                        )
                        AND parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        );

                    l_n_cnt_pls := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pls := q'<SELECT * FROM PROCESS_LAYOUT_SPECIFICATION
      WHERE layout_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                        INTO op_clob_pls_ids1
                        FROM
                            dual;

                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pls_id )
                            )
                        INTO op_clob_pls_ids2
                        FROM
                            dual;

                        op_debug_clob_pls := op_debug_clob_pls
                                             || op_clob_pls_ids1
                                             || chr(10)
                                             || q'<) and parent_id not in (>'
                                             || op_clob_pls_ids2
                                             || ');';

                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pls_id );

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_notin_ids
                        FROM
                            TABLE ( lst_proc_par_ids );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_LAYOUT_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pls
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pls,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'BUSINESS_ENTITY_RELATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    FOR i IN (
                        SELECT
                            ber.child_id,
                            ber.parent_id
                        FROM
                            business_process_mapping bpm,
                            business_entity          be,
                            business_entity_relation ber
                        WHERE
                            bpm.parent_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_all_ip_hierarchy_id )
                            )
                            AND be.bid = bpm.entityid
                            AND ber.parent_id = bpm.entityid
                            AND bpm.parent_id NOT IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                    ) LOOP
                        DELETE FROM business_entity_relation
                        WHERE
                                child_id = i.child_id
                            AND parent_id = i.parent_id;

                    END LOOP;

                    l_n_cnt_ber := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ber := q'<SELECT * FROM BUSINESS_ENTITY_RELATION
      WHERE (child_id, parent_id) IN
        >';
                        FOR ip_ber IN (
                            SELECT
                                ber.child_id,
                                ber.parent_id
                            FROM
                                business_process_mapping bpm,
                                business_entity          be,
                                business_entity_relation ber
                            WHERE
                                bpm.parent_id IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_all_ip_hierarchy_id )
                                )
                                AND be.bid = bpm.entityid
                                AND ber.parent_id = bpm.entityid
                                AND bpm.parent_id NOT IN (
                                    SELECT
                                        *
                                    FROM
                                        TABLE ( lst_proc_par_ids )
                                )
                        ) LOOP
                            ip_ber_clob := ip_ber_clob
                                           || '('
                                           || ip_ber.child_id
                                           || ','
                                           || ip_ber.parent_id
                                           || ')'
                                           || ',';
                        END LOOP;

                        ip_ber_clob := rtrim(ip_ber_clob, ',');
                        op_ber_clob := '('
                                       || ip_ber_clob
                                       || ')';
                        op_debug_clob_ber := op_debug_clob_ber
                                             || chr(10)
                                             || op_ber_clob;
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_notin_ids
                        FROM
                            TABLE ( lst_proc_par_ids );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_ENTITY_RELATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ber
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ber,
                                                                                                                                        op_ber_clob,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'PARAMETER_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_specification
                    WHERE
                        param_basic_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ps_id )
                        );

                    l_n_cnt_ps := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ps := q'<SELECT * FROM PARAMETER_SPECIFICATION
      WHERE param_basic_spec_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_ps_id )
                            )
                        INTO op_clob_ps_ids
                        FROM
                            dual;

                        op_debug_clob_ps := op_debug_clob_ps
                                            || chr(10)
                                            || op_clob_ps_ids
                                            || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_ps_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ps
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ps,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'PARAMETER_ADDON_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_addon_specification
                    WHERE
                        param_addon_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pas_id )
                        );

                    l_n_cnt_pads := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pads := q'<SELECT * FROM PARAMETER_ADDON_SPECIFICATION
      WHERE param_addon_spec_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pas_id )
                            )
                        INTO op_clob_pads_ids
                        FROM
                            dual;

                        op_debug_clob_pads := op_debug_clob_pads
                                              || chr(10)
                                              || op_clob_pads_ids
                                              || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pas_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_ADDON_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pads
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pads,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'BUSINESS_PROCESS_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_process_mapping
                    WHERE
                        record_key IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_bpm_id )
                        );

                    l_n_cnt_bpm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bpm := q'<SELECT * FROM BUSINESS_PROCESS_MAPPING
      WHERE record_key IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_bpm_id )
                            )
                        INTO op_clob_bpm_ids
                        FROM
                            dual;

                        op_debug_clob_bpm := op_debug_clob_bpm
                                             || chr(10)
                                             || op_clob_bpm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_bpm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_PROCESS_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_bpm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_bpm,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'BUSINESS_ENTITY_PARAMETER' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_entity_parameter
                    WHERE
                        record_key_param IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_bep_id )
                        );

                    l_n_cnt_bep := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bep := q'<SELECT * FROM BUSINESS_ENTITY_PARAMETER
      WHERE record_key_param IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_bep_id )
                            )
                        INTO op_clob_bep_ids
                        FROM
                            dual;

                        op_debug_clob_bep := op_debug_clob_bep
                                             || chr(10)
                                             || op_clob_bep_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_bep_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_ENTITY_PARAMETER, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_bep
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_bep,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'CUSTOM_TEMPLATE_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM custom_template_mapping
                    WHERE
                        custom_templ_map_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_cstemp_id )
                        );

                    l_n_cnt_ctm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ctm := q'<SELECT * FROM custom_template_mapping where custom_templ_map_id in ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_cstemp_id )
                            )
                        INTO op_clob_ctm_ids
                        FROM
                            dual;

                        op_debug_clob_ctm := op_debug_clob_ctm
                                             || chr(10)
                                             || op_clob_ctm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_cstemp_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> CUSTOM_TEMPLATE_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ctm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ctm,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'PARAMETER_RULE_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_rule_specification
                    WHERE
                        param_rule_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_prs_id )
                        );

                    l_n_cnt_prs := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_prs := q'<SELECT * FROM PARAMETER_RULE_SPECIFICATION
      WHERE param_rule_spec_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_prs_id )
                            )
                        INTO op_clob_prs_ids
                        FROM
                            dual;

                        op_debug_clob_prs := op_debug_clob_prs
                                             || chr(10)
                                             || op_clob_prs_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_prs_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_RULE_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_prs
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_prs,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                    FORALL i IN lst_param_rule_spec.first..lst_param_rule_spec.last
                        DELETE FROM parameter_rule_specification
                        WHERE
                            param_rule_spec_id IN ( lst_param_rule_spec(i) );

                    l_n_cnt_prs1 := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_prs1 := q'<SELECT * FROM PARAMETER_RULE_SPECIFICATION
      WHERE param_rule_spec_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_param_rule_spec )
                            )
                        INTO op_clob_prs1_ids
                        FROM
                            dual;

                        op_debug_clob_prs1 := op_debug_clob_prs1
                                              || chr(10)
                                              || op_clob_prs1_ids
                                              || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_param_rule_spec );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_RULE_SPECIFICATION(FORALL delete for list LST_PARAM_RULE_SPEC), Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_prs1
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_prs1,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'PARAMETER_DATA_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_data_specification
                    WHERE
                        param_data_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pds_id )
                        );

                    l_n_cnt_pds := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pds := q'<SELECT * FROM PARAMETER_DATA_SPECIFICATION
      WHERE param_data_spec_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pds_id )
                            )
                        INTO op_clob_pds_ids
                        FROM
                            dual;

                        op_debug_clob_pds := op_debug_clob_pds
                                             || chr(10)
                                             || op_clob_pds_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pds_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_DATA_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pds
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pds,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'ENTITY_GROUP_FUNCTION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM entity_group_function
                    WHERE
                        group_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_egf_id )
                        );

                    l_n_cnt_egf := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_egf := q'<SELECT * FROM ENTITY_GROUP_FUNCTION
      WHERE group_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(XMLCAST(XMLAGG(xmlelement(e, chr(39)
                                                                       || column_value
                                                                       || chr(39), ', ').extract('//text()')) AS CLOB), ', ')
                                FROM
                                    TABLE ( lst_egf_id )
                            )
                        INTO op_clob_egf_ids
                        FROM
                            dual;

                        op_debug_clob_egf := op_debug_clob_egf
                                             || chr(10)
                                             || op_clob_egf_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_egf_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> ENTITY_GROUP_FUNCTION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_egf
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_egf,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'TABLE_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM table_specification
                    WHERE
                        id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_tsid_id )
                        )
                        AND parent_id NOT IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_proc_par_ids )
                        );

                    l_n_cnt_ts := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ts := q'<SELECT * FROM TABLE_SPECIFICATION
      WHERE id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_proc_par_ids )
                            )
                        INTO op_clob_ts_ids2
                        FROM
                            dual;

                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_tsid_id )
                            )
                        INTO op_clob_ts_ids1
                        FROM
                            dual;

                        op_debug_clob_ts := op_debug_clob_ts
                                            || chr(10)
                                            || op_clob_ts_ids1
                                            || q'<) and parent_id not in (>'
                                            || op_clob_ts_ids2
                                            || ');';

                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_tsid_id );

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_notin_ids
                        FROM
                            TABLE ( lst_proc_par_ids );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> TABLE_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ts
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ts,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'TABLE_ROW_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM table_row_specification
                    WHERE
                        id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_tbrsp_id )
                        );

                    l_n_cnt_trs := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_trs := q'<SELECT * FROM TABLE_ROW_SPECIFICATION
      WHERE id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_tbrsp_id )
                            )
                        INTO op_clob_trs_ids
                        FROM
                            dual;

                        op_debug_clob_trs := op_debug_clob_trs
                                             || chr(10)
                                             || op_clob_trs_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_tbrsp_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> TABLE_ROW_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_trs
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_trs,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'TABLE_PARAMETER_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM table_parameter_mapping
                    WHERE
                        row_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_tbm_id )
                        );

                    l_n_cnt_tpm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_tpm := q'<SELECT * FROM TABLE_PARAMETER_MAPPING
      WHERE row_spec_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_tbm_id )
                            )
                        INTO op_clob_tpm_ids
                        FROM
                            dual;

                        op_debug_clob_tpm := op_debug_clob_tpm
                                             || chr(10)
                                             || op_clob_tpm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_tbm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> TABLE_PARAMETER_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_tpm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_tpm,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'ENTITY_JOIN_PARAMETER' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM entity_join_parameter
                    WHERE
                        group_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ejp_id )
                        );

                    l_n_cnt_ejp := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ejp := q'<SELECT * FROM ENTITY_JOIN_PARAMETER
      WHERE group_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(XMLCAST(XMLAGG(xmlelement(e, chr(39)
                                                                       || column_value
                                                                       || chr(39), ', ').extract('//text()')) AS CLOB), ', ')
                                FROM
                                    TABLE ( lst_ejp_id )
                            )
                        INTO op_clob_ejp_ids
                        FROM
                            dual;

                        op_debug_clob_ejp := op_debug_clob_ejp
                                             || chr(10)
                                             || op_clob_ejp_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_ejp_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> ENTITY_JOIN_PARAMETER, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ejp
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ejp,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'PROCESS_ACTION_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM process_action_specification
                    WHERE
                        action_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pacts_id )
                        );

                    l_n_cnt_pas := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pas := q'<SELECT * FROM PROCESS_ACTION_SPECIFICATION
      WHERE action_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pacts_id )
                            )
                        INTO op_clob_pas_ids
                        FROM
                            dual;

                        op_debug_clob_pas := op_debug_clob_pas
                                             || chr(10)
                                             || op_clob_pas_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pacts_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PROCESS_ACTION_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pas
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pas,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'ACTION_INPUT_PARAMETER' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM action_input_parameter
                    WHERE
                        action_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_aip_id )
                        );

                    l_n_cnt_aip := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_aip := q'<SELECT * FROM ACTION_INPUT_PARAMETER
      WHERE ACTION_SPEC_ID IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_aip_id )
                            )
                        INTO op_clob_aip_ids
                        FROM
                            dual;

                        op_debug_clob_aip := op_debug_clob_aip
                                             || chr(10)
                                             || op_clob_aip_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_aip_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> ACTION_INPUT_PARAMETER, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_aip
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_aip,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'SERVICE_COLUMN_METADATA' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM service_column_metadata
                    WHERE
                        group_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_scm_id )
                        );

                    l_n_cnt_scm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_scm := q'<SELECT * FROM SERVICE_COLUMN_METADATA
      WHERE group_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_scm_id )
                            )
                        INTO op_clob_scm_ids
                        FROM
                            dual;

                        op_debug_clob_scm := op_debug_clob_scm
                                             || chr(10)
                                             || op_clob_scm_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_scm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> SERVICE_COLUMN_METADATA, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_scm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_scm,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'RULE' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM rule r
                    WHERE
                        r.rule_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_r_id )
                        )
                        AND NOT EXISTS (
                            SELECT
                                1
                            FROM
                                parameter_rule_specification
                            WHERE
                                rule_id = r.rule_id
                        );

                    l_n_cnt_r := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_r := q'<SELECT * FROM rule r
      WHERE r.rule_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_r_id )
                            )
                        INTO op_clob_r_ids
                        FROM
                            dual;

                        op_debug_clob_r := op_debug_clob_r
                                           || chr(10)
                                           || op_clob_r_ids
                                           || ')and not exists(select 1 from parameter_rule_specification where rule_id = r.rule_id);';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_r_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> RULE, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_r
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_r,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                    FORALL i IN lst_rule_val.first..lst_rule_val.last
                        DELETE FROM rule r
                        WHERE
                            r.rule_id IN ( lst_rule_val(i) )
                            AND NOT EXISTS (
                                SELECT
                                    1
                                FROM
                                    parameter_rule_specification
                                WHERE
                                    rule_id = r.rule_id
                            );

                    l_n_cnt_r1 := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_r1 := q'<SELECT * FROM rule r
      WHERE r.rule_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_rule_val )
                            )
                        INTO op_clob_r1_ids
                        FROM
                            dual;

                        op_debug_clob_r1 := op_debug_clob_r1
                                            || chr(10)
                                            || op_clob_r1_ids
                                            || ')and not exists(select 1 from parameter_rule_specification where rule_id = r.rule_id);';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_rule_val );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> RULE(FORALL delete for list LST_RULE_VAL), Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_r1
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_r1,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'PRICE_PLAN_ENTITY' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    FOR i IN (
                        SELECT
                            ppe.*
                        FROM
                            price_plan_specification pps,
                            price_plan_entity        ppe
                        WHERE
                            pps.service_entity_id IN (
                                SELECT
                                    bpm.entityid
                                FROM
                                    business_process_mapping bpm
                                WHERE
                                    bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                            AND ppe.plan_id = pps.price_plan_id
                    ) LOOP
                        DELETE FROM price_plan_entity
                        WHERE
                                plan_id = i.plan_id
                            AND entity_id = i.entity_id;

                    END LOOP i;

                    l_n_cnt_ppe := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ppe := q'<SELECT * FROM PRICE_PLAN_ENTITY
      WHERE (plan_id, entity_id) IN
        >';
                        FOR ip_ppe IN (
                            SELECT
                                ppe.*
                            FROM
                                price_plan_specification pps,
                                price_plan_entity        ppe
                            WHERE
                                pps.service_entity_id IN (
                                    SELECT
                                        bpm.entityid
                                    FROM
                                        business_process_mapping bpm
                                    WHERE
                                        bpm.parent_id IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_all_ip_hierarchy_id )
                                        )
                                        AND bpm.parent_id NOT IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_proc_par_ids )
                                        )
                                )
                                AND ppe.plan_id = pps.price_plan_id
                        ) LOOP
                            ip_ppe_clob := ip_ppe_clob
                                           || '('
                                           || ip_ppe.plan_id
                                           || ','
                                           || ip_ppe.entity_id
                                           || ')'
                                           || ',';
                        END LOOP;

                        ip_ppe_clob := rtrim(ip_ppe_clob, ',');
                        op_ppe_clob := '('
                                       || ip_ppe_clob
                                       || ')';
                        op_debug_clob_ppe := op_debug_clob_ppe
                                             || chr(10)
                                             || op_ppe_clob;
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_notin_ids
                        FROM
                            TABLE ( lst_proc_par_ids );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRICE_PLAN_ENTITY, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ppe
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ppe,
                                                                                                                                        op_ppe_clob,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'PRICE_PLAN_SPECIFICATION' ) THEN
                    FORALL i IN lst_pp_spec_val.first..lst_pp_spec_val.last
                        DELETE FROM price_plan_specification
                        WHERE
                            pp_instance_id IN ( lst_pp_spec_val(i).pp_instance_id );

                    FORALL i IN lst_pp_spec_val.first..lst_pp_spec_val.last
                        DELETE FROM price_plan_entity
                        WHERE
                            plan_id IN ( lst_pp_spec_val(i).price_plan_id );

                ELSIF tab.table_name IN ( 'CHARGE_PARAMETER_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM charge_parameter_specification
                    WHERE
                        charge_instance_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_cps_id )
                        );

                    l_n_cnt_cps := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_cps := q'<SELECT * FROM CHARGE_PARAMETER_SPECIFICATION
      WHERE charge_instance_id IN
        ( >';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_cps_id )
                            )
                        INTO op_clob_cps_ids
                        FROM
                            dual;

                        op_debug_clob_cps := op_debug_clob_cps
                                             || chr(10)
                                             || op_clob_cps_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_cps_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> CHARGE_PARAMETER_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_cps
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_cps,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'PARAMETER_REFERENCE_VALUE' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_reference_value
                    WHERE
                        param_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_prv_id )
                        );

                    l_n_cnt_prv := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_prv := q'<SELECT * FROM parameter_reference_value
        WHERE param_spec_id IN
      (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_prv_id )
                            )
                        INTO op_clob_prv_ids
                        FROM
                            dual;

                        op_debug_clob_prv := op_debug_clob_prv
                                             || chr(10)
                                             || op_clob_prv_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_prv_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_REFERENCE_VALUE, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_prv
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_prv,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'HIERARCHY_METADATA' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    FOR hm IN (
                        SELECT
                            hm.*
                        FROM
                            hierarchy_metadata hm
                        WHERE
                            hierarchy_entity_id IN (
                                SELECT DISTINCT
                                    ber.child_id
                                FROM
                                    business_process_mapping bpm, business_entity          be, business_entity_relation ber
                                WHERE
                                    bpm.parent_id IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_all_ip_hierarchy_id )
                                    )
                                    AND be.bid = bpm.entityid
                                    AND ber.parent_id = bpm.entityid
                                    AND bpm.parent_id NOT IN (
                                        SELECT
                                            *
                                        FROM
                                            TABLE ( lst_proc_par_ids )
                                    )
                            )
                        ORDER BY
                            hierarchy_level
                    ) LOOP
                        DELETE FROM hierarchy_metadata
                        WHERE
                                hierarchy_entity_id = hm.hierarchy_entity_id
                            AND hierarchy_id = hm.hierarchy_id;

                    END LOOP;

                    l_n_cnt_hm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_hm := q'<SELECT * FROM HIERARCHY_METADATA
      WHERE (hierarchy_entity_id, hierarchy_id) IN
        >';
                        FOR ip_hm IN (
                            SELECT
                                hm.*
                            FROM
                                hierarchy_metadata hm
                            WHERE
                                hierarchy_entity_id IN (
                                    SELECT DISTINCT
                                        ber.child_id
                                    FROM
                                        business_process_mapping bpm, business_entity          be, business_entity_relation ber
                                    WHERE
                                        bpm.parent_id IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_all_ip_hierarchy_id )
                                        )
                                        AND be.bid = bpm.entityid
                                        AND ber.parent_id = bpm.entityid
                                        AND bpm.parent_id NOT IN (
                                            SELECT
                                                *
                                            FROM
                                                TABLE ( lst_proc_par_ids )
                                        )
                                )
                            ORDER BY
                                hierarchy_level
                        ) LOOP
                            ip_hm_clob := ip_hm_clob
                                          || '('
                                          || ip_hm.hierarchy_entity_id
                                          || ','
                                          || ip_hm.hierarchy_id
                                          || ')'
                                          || ',';
                        END LOOP;

                        ip_hm_clob := rtrim(ip_hm_clob, ',');
                        op_hm_clob := '('
                                      || ip_hm_clob
                                      || ')';
                        op_debug_clob_hm := op_debug_clob_hm
                                            || chr(10)
                                            || op_hm_clob;
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_notin_ids
                        FROM
                            TABLE ( lst_proc_par_ids );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> HIERARCHY_METADATA, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_hm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_hm,
                                                                                                                                        op_hm_clob,
                                                  ip_pid.column_value, l_n_del_notin_ids);

                    END IF;

                ELSIF tab.table_name IN ( 'SCRIPT_INFO' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM script_info
                    WHERE
                        script_group_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_si_id )
                        );

                    l_n_cnt_si := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_si := q'<SELECT * FROM SCRIPT_INFO WHERE script_group_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_si_id )
                            )
                        INTO op_clob_si_ids
                        FROM
                            dual;

                        op_debug_clob_si := op_debug_clob_si
                                            || chr(10)
                                            || op_clob_si_ids
                                            || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_si_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> SCRIPT_INFO, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_si
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_si,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'SCRIPT_TASK' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM script_task
                    WHERE
                        pid IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_st_id )
                        );

                    l_n_cnt_st := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_st := q'<SELECT * FROM script_task  where pid in (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_st_id )
                            )
                        INTO op_clob_st_ids
                        FROM
                            dual;

                        op_debug_clob_st := op_debug_clob_st
                                            || chr(10)
                                            || op_clob_st_ids
                                            || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_st_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> SCRIPT_TASK, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_st
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_st,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'ENTITY_BOUNDARY_CONDITION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM entity_boundary_condition ebc
                    WHERE
                        ebc.entity_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_ebc_id )
                        );

                    l_n_cnt_ebc := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_ebc := q'<SELECT * FROM entity_boundary_condition ebc
WHERE
    ebc.entity_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_ebc_id )
                            )
                        INTO op_clob_ebc_ids
                        FROM
                            dual;

                        op_debug_clob_ebc := op_debug_clob_ebc
                                             || chr(10)
                                             || op_clob_ebc_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_ebc_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> ENTITY_BOUNDARY_CONDITION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_ebc
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_ebc,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'BUSINESS_ENTITY_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM business_entity_specification bes
                    WHERE
                        bes.root_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_bes_id )
                        );

                    l_n_cnt_bes := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bes := q'<SELECT * FROM business_entity_specification bes
WHERE
    bes.root_id IN (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_bes_id )
                            )
                        INTO op_clob_bes_ids
                        FROM
                            dual;

                        op_debug_clob_bes := op_debug_clob_bes
                                             || chr(10)
                                             || op_clob_bes_ids
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_bes_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> BUSINESS_ENTITY_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_bes
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_bes,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'USER_AUTH_PROCESS_MAPPING' ) THEN
/*USR_AUTH_PRCS_MPNG_DLT_2024 Starts*/
/*commented this for change USR_AUTH_PRCS_MPNG_DLT_APPL_2024 
IF is_delete_req = 'Y' then
*/

/*USR_AUTH_PRCS_MPNG_DLT_APPL_2024 Starts*/
                    IF l_vc_uapm_delete = 'Y' THEN
/*USR_AUTH_PRCS_MPNG_DLT_APPL_2024 Ends*/

                        l_n_starttime := dbms_utility.get_time;
                        DELETE FROM user_auth_process_mapping
                        WHERE
                            usr_auth_proc_mapping_id IN (
                                SELECT
                                    *
                                FROM
                                    TABLE ( lst_uapm_id )
                            );

                        l_n_cnt_uapm := SQL%rowcount;
                        IF ip_is_debug_flag = 'Y' THEN
                            op_debug_clob_uapm := q'<SELECT * FROM USER_AUTH_PROCESS_MAPPING
      WHERE USR_AUTH_PROC_MAPPING_ID IN
        (>';
                            SELECT
                                (
                                    SELECT
                                        rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                    FROM
                                        TABLE ( lst_uapm_id )
                                )
                            INTO op_clob_uapm_ids
                            FROM
                                dual;

                            op_debug_clob_uapm := op_debug_clob_uapm
                                                  || chr(10)
                                                  || op_clob_uapm_ids
                                                  || ');';
                            SELECT
                                round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                            INTO l_n_exec_time
                            FROM
                                dual;

                            SELECT
                                rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                            INTO l_n_del_ids
                            FROM
                                TABLE ( lst_uapm_id );

                            proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                            1)), 'Table_Name --> USER_AUTH_PROCESS_MAPPING, Execution Time --> '
                                                                                                                                 || l_n_exec_time
                                                                                                                                 || ', Query result count --> '
                                                                                                                                 || l_n_cnt_uapm
                                                                                                                                 || ' in sec',
                                                                                                                                 op_debug_clob_uapm,
                                                                                                                                 l_n_del_ids,
                                                      ip_pid.column_value, NULL);

                        END IF;

                    END IF;
/*USR_AUTH_PRCS_MPNG_DLT_2024 End*/

                ELSIF tab.table_name IN ( 'PRODUCT_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM product_mapping pm
                    WHERE
                        pm.offering_process_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_pm_id )
                        );

                    l_n_cnt_bes := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_bes := q'<SELECT * FROM  product_mapping pm
WHERE
    pm.offering_process_id IN(>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_pm_id )
                            )
                        INTO op_clob_pm_ids
                        FROM
                            dual;

                        op_debug_clob_pm := op_debug_clob_pm
                                            || chr(10)
                                            || op_clob_pm_ids
                                            || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_pm_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRODUCT_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_debug_clob_pm,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;
 /*PARAM_FUNCT_SPEC_DEL_2024 start*/
                ELSIF tab.table_name IN ( 'PARAMETER_FUNC_SPECIFICATION' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM parameter_func_specification
                    WHERE
                        param_func_spec_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_param_funct_spec_id )
                        );

                    l_n_cnt_pfs := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pfs := q'<SELECT * FROM parameter_func_specification
      WHERE PARAM_FUNC_SPEC_ID IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_param_funct_spec_id )
                            )
                        INTO op_clob_param_funct_spec_id
                        FROM
                            dual;

                        op_debug_clob_pfs := op_debug_clob_pfs
                                             || chr(10)
                                             || op_clob_param_funct_spec_id
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_param_funct_spec_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PARAMETER_FUNC_SPECIFICATION, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pfs
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_clob_param_funct_spec_id,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);
			/*PARAM_FUNCT_SPEC_DEL_2024 end*/
                    END IF;

                ELSIF tab.table_name IN ( 'PRODUCT_CODE_DETAILS' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM product_code_details
                    WHERE
                        product_code_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_prod_code_id )
                        );

                    l_n_cnt_pcd := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_pcd := q'<SELECT * FROM product_code_details
      WHERE product_code_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_prod_code_id )
                            )
                        INTO op_clob_prod_code_id
                        FROM
                            dual;

                        op_debug_clob_pcd := op_debug_clob_pcd
                                             || chr(10)
                                             || op_clob_prod_code_id
                                             || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_prod_code_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> PRODUCT_CODE_DETAILS, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_pcd
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_clob_prod_code_id,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                ELSIF tab.table_name IN ( 'ENTITY_PRODUCT_CODE_MAPPING' ) THEN
                    l_n_starttime := dbms_utility.get_time;
                    DELETE FROM entity_product_code_mapping
                    WHERE
                        entity_prd_cd_id IN (
                            SELECT
                                *
                            FROM
                                TABLE ( lst_entity_prd_cd_id )
                        );

                    l_n_cnt_epcm := SQL%rowcount;
                    IF ip_is_debug_flag = 'Y' THEN
                        op_debug_clob_epcm := q'<SELECT * FROM entity_product_code_mapping
      WHERE entity_prd_cd_id IN
        (>';
                        SELECT
                            (
                                SELECT
                                    rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                                FROM
                                    TABLE ( lst_entity_prd_cd_id )
                            )
                        INTO op_clob_entity_prd_cd_id
                        FROM
                            dual;

                        op_debug_clob_epcm := op_debug_clob_epcm
                                              || chr(10)
                                              || op_clob_entity_prd_cd_id
                                              || ');';
                        SELECT
                            round((dbms_utility.get_time - l_n_starttime) / 100, 2)
                        INTO l_n_exec_time
                        FROM
                            dual;

                        SELECT
                            rtrim(xmlagg(xmlelement(e, column_value, ', ').extract('//text()')).getclobval(), ', ')
                        INTO l_n_del_ids
                        FROM
                            TABLE ( lst_entity_prd_cd_id );

                        proc_metadata_delete_debug(l_n_execution_id_seq, utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(
                        1)), 'Table_Name --> ENTITY_PRODUCT_CODE_MAPPING, Execution Time --> '
                                                                                                                                        ||
                                                                                                                                        l_n_exec_time
                                                                                                                                        ||
                                                                                                                                        ', Query result count --> '
                                                                                                                                        ||
                                                                                                                                        l_n_cnt_epcm
                                                                                                                                        ||
                                                                                                                                        ' in sec',
                                                                                                                                        op_clob_entity_prd_cd_id,
                                                                                                                                        l_n_del_ids,
                                                  ip_pid.column_value, NULL);

                    END IF;

                END IF;
            END LOOP tab;

        END LOOP ip_pid;
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END metadata_seq_delete;


--changeset Vijaysree.S:BACATALOG_DML_12_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE PROCEDURE METADATA_DELETE_RULE (
    ip_process_id IN NUMBER
) AS
    v_n_count         NUMBER := 0;
    lst_ip_process_id lst_process_ids := lst_process_ids();
BEGIN
    FOR rule_id_loop IN (
        SELECT
            r.rule_id
        FROM
            business_entity              be,
            parameter_rule_specification prs,
            rule                         r
        WHERE
            be.entity_type IN ( 'Market Offering', 'Service', 'Element', 'Feature' )
            AND r.rule_id = prs.rule_id
            AND be.bid = prs.parent_id
            AND be.bid IN (
                SELECT
                    child_id AS bid
                FROM
                    business_entity_relation ber
                START WITH
                    ber.parent_id = ip_process_id
                CONNECT BY
                    PRIOR ber.child_id = ber.parent_id
                UNION
                SELECT
                    parent_id AS bid
                FROM
                    business_entity_relation ber
                WHERE
                    ber.parent_id = ip_process_id
            )
        UNION
        SELECT
            r1.rule_id
        FROM
            business_entity              be,
            parameter_rule_specification prs,
            rule                         r,
            rule                         r1
        WHERE
            be.entity_type IN ( 'Market Offering', 'Service', 'Element', 'Feature' )
            AND r1.rule_id = r.parent_rule_id
            AND r.rule_id = prs.rule_id
            AND be.bid = prs.parent_id
            AND be.bid IN (
                SELECT
                    child_id AS bid
                FROM
                    business_entity_relation ber
                START WITH
                    ber.parent_id = ip_process_id
                CONNECT BY
                    PRIOR ber.child_id = ber.parent_id
                UNION
                SELECT
                    parent_id AS bid
                FROM
                    business_entity_relation ber
                WHERE
                    ber.parent_id = ip_process_id
            )
    ) LOOP
        v_n_count := v_n_count + 1;
        lst_ip_process_id.extend;
        lst_ip_process_id(v_n_count) := rule_id_loop.rule_id;
        dbms_output.put_line('rule_id_loop records: ' || rule_id_loop.rule_id);
    END LOOP rule_id_loop;

    DELETE FROM parameter_rule_specification
    WHERE
        rule_id IN (
            SELECT
                *
            FROM
                TABLE ( lst_ip_process_id )
        );

    dbms_output.put_line('Parameter_rule_specification Table records deleted');
    DELETE FROM rule
    WHERE
        rule_id IN (
            SELECT
                *
            FROM
                TABLE ( lst_ip_process_id )
        );

    dbms_output.put_line('Rule Table records deleted');
    DELETE FROM service_column_metadata scm
    WHERE
        group_id IN (
            SELECT
                parameter_spec_id
            FROM
                (
                    SELECT
                        bpm.*, bep.parameter_spec_id, DENSE_RANK()
                                                      OVER(PARTITION BY bpm.entityid, bpm.lifecycle_id
                                                           ORDER BY
                                                               bpm.version_no DESC
                                                      ) ak
                    FROM
                        business_process_mapping  bpm, business_entity_parameter bep
                    WHERE
                        bpm.entityid IN (
                            SELECT
                                parent_id bid
                            FROM
                                business_entity_relation
                            WHERE
                                parent_id = ip_process_id
                            UNION ALL
                            SELECT
                                child_id bid
                            FROM
                                business_entity_relation
                            START WITH
                                parent_id = ip_process_id
                            CONNECT BY
                                PRIOR child_id = parent_id
                        )
                        AND bep.parent_id = bpm.record_key
                )
            WHERE
                ak = 1
        );

    dbms_output.put_line('service_column_metadata Table records deleted');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: '
                             || sqlcode
                             || ' - '
                             || sqlerrm);
        dbms_output.put_line(dbms_utility.format_error_backtrace);
        ROLLBACK;
        RAISE;
END metadata_delete_rule;


--changeset Vijaysree.S:BACATALOG_DML_12_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE PROCEDURE EXPORT_SCRIPT_TASK (
    ip_process_id    IN NUMBER,
    ip_all_hrchy_process_id IN lst_process_ids,
    ip_script_type   VARCHAR2,
    ip_delete_proc_req_flag VARCHAR2 DEFAULT 'N'
) AS

    TYPE typ_scrpt_tsk IS
        TABLE OF script_task%rowtype;
    lst_typ_scrpt_tsk        typ_scrpt_tsk;
    scrpt_task_op            CLOB;
    over_all_op              CLOB;
    script_cnt               NUMBER;
    lst_ip_process_id        lst_process_ids := lst_process_ids();
    op_clob_over_all_table   CLOB;
    l_vc_script_type         VARCHAR2(100);
    l_vc_inbound_api_profile VARCHAR2(100);
    l_vc_process_gateway_cnt VARCHAR2(100) := q'<0>';
    l_vc_spool               VARCHAR2(100) := q'<spool>';
    l_vc_spool_errrollback   VARCHAR2(100) := q'<WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;>';
    l_vc_spool_filename      VARCHAR2(100) := q'<01_bacatalog_dml_process_entity_>';
    l_vc_spool_gbl_select    VARCHAR2(200) := q'<SELECT USER || ' @ '|| global_name || '    '|| TO_CHAR (SYSDATE, 'dd-MON-yy hh24:MI:ss') AS environment FROM global_name;>';
    l_vc_spool_line          VARCHAR2(100) := q'<---=============================================================================>';
    l_vc_spool_log           VARCHAR2(100) := q'<.log>';
    l_vc_spool_off           VARCHAR2(100) := q'<spool off;>';
    l_vc_spool_setdefine     VARCHAR2(100) := q'<SET DEFINE OFF>';
    l_vc_spool_setscan       VARCHAR2(100) := q'<SET SCAN OFF>';
    l_vc_spool_setserver     VARCHAR2(100) := q'<SET SERVEROUTPUT ON>';
    l_vc_sql_begin           VARCHAR2(100) := q'<BEGIN>';
    l_vc_sql_commit          VARCHAR2(100) := q'<COMMIT;>';
    l_vc_sql_end             VARCHAR2(100) := q'<END;>';
    l_vc_liquibase_changeset VARCHAR2(100) := q'<--changeset metadata:>';
    l_vc_liquibase_format    VARCHAR2(100) := q'<--liquibase formatted sql>';
    l_vc_liquibase_precond   VARCHAR2(100) := q'<--preconditions onFail:HALT onError:HALT>';
    l_vc_liquibase_splt_stmt VARCHAR2(100) := q'< dbms:oracle splitStatements:true endDelimeter:;>';
    l_vc_pe_version          VARCHAR2(100) := q'<0>';
    l_vc_spool_blanklines    VARCHAR2(100) := q'<SET SQLBLANKLINES ON>';
    l_vc_spool_deleteblock   VARCHAR2(300) := q'<DECLARE
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
BEGIN
    l_vc_script_type := upper(ip_script_type);
    IF l_vc_script_type = 'LIQUIBASE' THEN
        op_clob_over_all_table := op_clob_over_all_table
                                  || l_vc_liquibase_format
                                  || chr(10)
                                  || l_vc_liquibase_changeset
                                  || ip_process_id
                                  || l_vc_pe_version
                                  || l_vc_liquibase_splt_stmt
                                  || chr(32)
                                  || chr(10)
                                  || l_vc_liquibase_precond
                                  || chr(10)
                                  || chr(10);

    ELSIF l_vc_script_type = 'SPOOL' THEN
        op_clob_over_all_table :=
            CASE
                WHEN ip_delete_proc_req_flag = 'N' THEN
                    op_clob_over_all_table
                    || l_vc_spool
                    || chr(32)
                    || l_vc_spool_filename
                    || ip_process_id
                    || l_vc_spool_log
                    || chr(10)
                    || l_vc_spool_line
                    || chr(10)
                    || l_vc_spool_setserver
                    || chr(10)
                    || l_vc_spool_setdefine
                    || chr(10)
                    || l_vc_spool_blanklines
                    || chr(10)
                    || l_vc_spool_setscan
                    || chr(10)
                    || l_vc_spool_gbl_select
                    || chr(10)
                    || l_vc_spool_line
                    || chr(10)
                    || l_vc_spool_errrollback
                    || chr(10)
                ELSE op_clob_over_all_table
                     || l_vc_spool
                     || chr(32)
                     || l_vc_spool_filename
                     || ip_process_id
                     || l_vc_spool_log
                     || chr(10)
                     || l_vc_spool_line
                     || chr(10)
                     || l_vc_spool_setserver
                     || chr(10)
                     || l_vc_spool_setdefine
                     || chr(10)
                     || l_vc_spool_blanklines
                     || chr(10)
                     || l_vc_spool_setscan
                     || chr(10)
                     || l_vc_spool_gbl_select
                     || chr(10)
                     || l_vc_spool_line
                     || chr(10)
                     || l_vc_spool_errrollback
                     || chr(10)
                     || replace(l_vc_spool_deleteblock, 'NULL', ip_process_id)
                     || chr(10)
            END;
    ELSE
        op_clob_over_all_table := op_clob_over_all_table || '{';
    END IF;

    SELECT
        COUNT(1)
    INTO script_cnt
    FROM
        script_task st
    WHERE
        pid IN (
            SELECT
                pe.pid
            FROM
                process_entity               pe, process_entity_specification pes
            WHERE
                pe.root_id IN ( select * from table (ip_all_hrchy_process_id) )
                AND pe.pid = pes.pid
                AND pes.task_type = 'Script Task'
        );

    IF script_cnt > 0 THEN
        SELECT
            st.*
        BULK COLLECT
        INTO lst_typ_scrpt_tsk
        FROM
            script_task st
        WHERE
            pid IN (
                SELECT
                    pe.pid
                FROM
                    process_entity               pe, process_entity_specification pes
                WHERE
                    pe.root_id IN ( select * from table (ip_all_hrchy_process_id) )
                    AND pe.pid = pes.pid
                    AND pes.task_type = 'Script Task'
            );

        FOR st_loop IN 1..lst_typ_scrpt_tsk.count LOOP
            scrpt_task_op := '
DECLARE
  str varchar2(32767);
BEGIN
  str := q''<';
            scrpt_task_op := scrpt_task_op
                             || lst_typ_scrpt_tsk(st_loop).script_data
                             || '>'';';
            scrpt_task_op := scrpt_task_op || '
Insert into script_task (SCRIPT_TASK_ID,PID,SCRIPT_DATA,CREATED_DATE,CREATED_BY,MODIFIED_DATE,MODIFIED_BY,SCRIPT_FILE_NAME,SCRIPT_FILE_TYPE,SCRIPT_TYPE,SCHEMA_NAME,OPERATOR_TYPE,PROCESS_TYPE) values (';
            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).script_task_id
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).pid
                             || ''',';

            scrpt_task_op := scrpt_task_op || 'str,';
            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).created_date
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).created_by
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).modified_date
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).modified_by
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).script_file_name
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).script_file_type
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).script_type
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).schema_name
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).operator_type
                             || ''',';

            scrpt_task_op := scrpt_task_op
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).process_type
                             || ''');';

            scrpt_task_op := scrpt_task_op
                             || '
dbms_output.put_line('
                             || ''''
                             || lst_typ_scrpt_tsk(st_loop).pid
                             || ' Inserted'
                             || ''''
                             || ');
commit;
end;
/';

            op_clob_over_all_table := op_clob_over_all_table
                                      || scrpt_task_op
                                      || chr(10);

        END LOOP st_loop;

        INSERT INTO script_task_export (
            export_id,
            pid,
            task_id,
            scripts,
            created_date
        ) VALUES (
            export_id_seq.NEXTVAL,
            ip_process_id,
            NULL,
            op_clob_over_all_table,
            systimestamp
        );

    END IF;

END export_script_task;




