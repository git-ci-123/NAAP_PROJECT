--liquibase formatted sql
--changeset Vijaysree.S:BACATALOG_DDL_09 splitStatements:false
--preconditions onFail:HALT onError:HALT


DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT pps.*
        FROM price_plan_specification pps
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES)
          )
          UNION
          SELECT pps.*
        FROM price_plan_specification pps,
          price_plan_entity ppe
        WHERE ppe.entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )
        AND ppe.plan_id = pps.price_plan_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100024','PRICE_PLAN_SPECIFICATION','PPS','26','17',str,'Y','PP_INSTANCE_ID','N','Process Plan');
dbms_output.put_line('PRICE_PLAN_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    prv.*
FROM
    business_process_mapping  bpm,
    business_entity_parameter bep,
    parameter_reference_value prv
WHERE
    bpm.parent_id IN (IP_VALUES)
    AND bpm.record_key = bep.parent_id
    AND bep.parameter_spec_id = prv.param_spec_id
UNION
SELECT
    prv.*
FROM
    parameter_reference_value prv
WHERE
    prv.entity_specification_type IN ( 'Process Plan', 'Page', 'Interface', 'Market Offering', 'Task' )
    AND prv.param_spec_id IN (IP_VALUES )
UNION
SELECT
    prv.*
FROM
    business_process_mapping  bpm,
    parameter_reference_value prv
WHERE
    bpm.parent_id IN (IP_VALUES)
    AND bpm.entityid = prv.param_spec_id
UNION
SELECT
    prv.*
FROM
    process_entity            pe,
    table_specification       ts,
    table_row_specification   trs,
    table_parameter_mapping   tpm,
    parameter_reference_value prv
WHERE
        prv.param_spec_id = tpm.parameter_spec_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN (IP_VALUES)
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100028','PARAMETER_REFERENCE_VALUE','PRV','30','7',str,'Y','PARAM_REF_VAL_ID','N','Process Plan');
dbms_output.put_line('PARAMETER_REFERENCE_VALUE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT pas.*
        FROM process_action_specification pas
        WHERE pas.parent_id IN
          (IP_VALUES
          )
        UNION
        SELECT pas.*
        FROM process_action_specification pas
        WHERE pas.parent_id IN
          (SELECT bep.parameter_spec_id
          FROM business_process_mapping bpm,
            business_entity_parameter bep
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          AND bep.parent_id = bpm.record_key
          )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100017','PROCESS_ACTION_SPECIFICATION','PACTSPEC','19','12',str,'Y','ACTION_ID','N','Process Plan');
dbms_output.put_line('PROCESS_ACTION_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT pes.*
          FROM process_entity_specification pes
          WHERE pes.pid IN
            (IP_VALUES)
			UNION
			SELECT 
    pes.*
FROM 
    business_entity                be, 
    business_process_mapping       bpm, 
    process_entity_specification   pes, 
    process_entity                 pe 
 WHERE 
    be.bid IN (SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (
                IP_VALUES
            )
    )
    AND bpm.entityid = be.bid 
    AND pes.pid = bpm.parent_id 
    AND pe.pid = pes.pid 
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100004','PROCESS_ENTITY_SPECIFICATION','PES','5','32',str,'Y','PROCESS_SPEC_ID','N','Process Plan');
dbms_output.put_line('PROCESS_ENTITY_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT pas.*
          FROM process_layout_specification pas
          WHERE pas.parent_id IN
            (IP_VALUES
            )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100005','PROCESS_LAYOUT_SPECIFICATION','PLS','6','30',str,'Y','LAYOUT_ID','N','Process Plan');
dbms_output.put_line('PROCESS_LAYOUT_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    rt.*
FROM
    reference_types rt,
    (
        SELECT
            prv.*
        FROM
            business_process_mapping  bpm,
            business_entity_parameter bep,
            parameter_reference_value prv
        WHERE
            bpm.parent_id IN ( IP_VALUES )
            AND bpm.record_key = bep.parent_id
            AND bep.parameter_spec_id = prv.param_spec_id
    )               pr
WHERE
    rt.ref_type_id = pr.ref_default_id
UNION
SELECT
    rt1.*
FROM
    reference_types           rt1,
    parameter_reference_value prv
WHERE
    prv.entity_specification_type IN ( 'Process Plan', 'Page', 'Interface', 'Market Offering', 'Task' )
    AND prv.param_spec_id IN ( IP_VALUES )
    AND rt1.ref_type_id = prv.ref_default_id
UNION
SELECT
    rt2.*
FROM
    reference_types rt2,
    (
        SELECT
            prv.*
        FROM
            business_process_mapping  bpm,
            parameter_reference_value prv
        WHERE
            bpm.parent_id IN ( IP_VALUES )
            AND bpm.entityid = prv.param_spec_id
    )               pr2
WHERE
    rt2.ref_type_id = pr2.ref_default_id
UNION
SELECT
    rt.*
FROM
    reference_type_values        rtv,
    reference_types              rt,
    parameter_rule_specification prs,
    business_process_mapping     bpm
WHERE
        prs.parent_id = bpm.entityid
    AND bpm.parent_id IN ( IP_VALUES )
    AND prs.expression_type = 'Reference'
    AND rtv.ref_val_id = prs.reference_value
    AND rt.ref_type_id = rtv.ref_type_id
UNION
SELECT
    rt.*
FROM
    process_entity_specification pes,
    reference_types              rt,
    reference_type_values        rtv
WHERE
    pes.pid IN ( IP_VALUES )
    AND pes.execution_url = rtv.ref_value
    AND rtv.ref_type_id = rt.ref_type_id
UNION
SELECT
    rt.*
FROM
    process_entity            pe,
    table_specification       ts,
    table_row_specification   trs,
    table_parameter_mapping   tpm,
    parameter_reference_value prv,
    reference_types           rt
WHERE
        prv.param_spec_id = tpm.parameter_spec_id
    AND prv.ref_default_id = rt.ref_type_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN ( IP_VALUES )
    AND pe.action_type = 'Parameter Group'
UNION
SELECT
    rt.*
FROM
    reference_types              rt,
    rule                         r,
    rule                         r1,
    parameter_rule_specification prs
WHERE
    r.parent_rule_id IN ( IP_VALUES )
    AND r.rule_id = r1.parent_rule_id
    AND r1.rule_id = prs.rule_id
    AND prs.output_data_store_name = rt.ref_type_name
    AND prs.output_data_store_name IS NOT NULL>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100026','REFERENCE_TYPES','REFTYP','28','9',str,'Y','REF_TYPE_ID','N','Process Plan');
dbms_output.put_line('REFERENCE_TYPES Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<WITH refer_ids AS (
    SELECT DISTINCT
        pe.pid
    FROM
        process_entity pe
    WHERE
        pid IN (
            IP_VALUES
        )
)
SELECT
    rtv.*
FROM
    reference_types       rt,
    reference_type_values rtv,
    (
        SELECT
            prv.*
        FROM
            business_process_mapping  bpm,
            business_entity_parameter bep,
            parameter_reference_value prv,
            refer_ids                 r
        WHERE
                bpm.parent_id = r.pid
            AND bpm.record_key = bep.parent_id
            AND bep.parameter_spec_id = prv.param_spec_id
    )                     pr
WHERE
        rt.ref_type_id = pr.ref_default_id
    AND rtv.ref_type_id = rt.ref_type_id
UNION
SELECT
    rtv1.*
FROM
    reference_types       rt1,
    reference_type_values rtv1,
    (
        SELECT
            prv.*
        FROM
            parameter_reference_value prv,
            refer_ids                 r
        WHERE
            prv.entity_specification_type IN ( 'Process Plan', 'Page', 'Interface', 'Market Offering', 'Task' )
            AND prv.param_spec_id = r.pid
    )                     pr1
WHERE
        rt1.ref_type_id = pr1.ref_default_id
    AND rtv1.ref_type_id = rt1.ref_type_id
UNION
SELECT
    rtv2.*
FROM
    reference_types       rt2,
    reference_type_values rtv2,
    (
        SELECT
            prv.*
        FROM
            business_process_mapping  bpm,
            parameter_reference_value prv,
            refer_ids                 r
        WHERE
                bpm.parent_id = r.pid
            AND bpm.entityid = prv.param_spec_id
    )                     pr2
WHERE
        rt2.ref_type_id = pr2.ref_default_id
    AND rtv2.ref_type_id = rt2.ref_type_id
    AND pr2.category_type = rtv2.ref_value
UNION
SELECT
    rtv.*
FROM
    reference_types       rt,
    reference_type_values rtv,
    (
        SELECT
            prs.*
        FROM
            business_process_mapping     bpm,
            business_entity_parameter    bep,
            parameter_rule_specification prs,
            refer_ids                    r
        WHERE
                bpm.parent_id = r.pid
            AND bpm.record_key = bep.parent_id
            AND prs.parent_id = bep.parameter_spec_id
    )                     prs1
WHERE
        rt.ref_type_id = rtv.ref_type_id
    AND rtv.ref_type_id = prs1.dynamic_reference_id
UNION
SELECT
    rtv.*
FROM
    reference_type_values        rtv,
    parameter_rule_specification prs,
    business_process_mapping bpm, 
    refer_ids                r
WHERE
    prs.parent_id = bpm.entityid 
    AND bpm.parent_id = r.pid
    AND prs.expression_type = 'Reference'
    AND rtv.ref_val_id = prs.reference_value
UNION
SELECT
    rtv.*
FROM
    process_entity_specification pes,
    reference_type_values        rtv,
    reference_type_values        rt
WHERE
    pes.pid IN (
        IP_VALUES
    )
    AND pes.execution_url = rt.ref_value
    AND rt.ref_type_id = rtv.ref_type_id
UNION
SELECT
    rtv.*
FROM
    process_entity            pe,
    table_specification       ts,
    table_row_specification   trs,
    table_parameter_mapping   tpm,
    parameter_reference_value prv,
    reference_types           rt,
    reference_type_values rtv
WHERE
        prv.param_spec_id = tpm.parameter_spec_id
    AND prv.ref_default_id = rt.ref_type_id
    AND rt.ref_type_id = rtv.ref_type_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN ( IP_VALUES )
    AND pe.action_type = 'Parameter Group'
UNION
SELECT 
    rtv.*
FROM
    reference_types              rt,
    reference_type_values        rtv,
    rule                         r,
    rule                         r1,
    parameter_rule_specification prs,
    refer_ids                    rf
WHERE
        rf.pid = r.parent_rule_id
    AND r.rule_id = r1.parent_rule_id
    AND r1.rule_id = prs.rule_id
    AND prs.output_data_store_name = rt.ref_type_name
    AND prs.output_data_store_name IS NOT NULL
    AND rt.ref_type_id = rtv.ref_type_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100027','REFERENCE_TYPE_VALUES','REFTYPVAL','29','8',str,'Y','REF_VAL_ID','N','Process Plan');
dbms_output.put_line('REFERENCE_TYPE_VALUES Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    si.*
FROM
    process_entity_specification   pes,
    parameter_rule_specification   prs,
    script_info                    si
WHERE
    si.script_group_id = prs.rule_script_id
    AND prs.parent_id = pes.process_spec_id
    AND pes.pid IN (IP_VALUES)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100035','SCRIPT_INFO','SI','37','14',str,'Y','SCRIPT_ID','N','Process Plan');
dbms_output.put_line('SCRIPT_INFO Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_09 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT scm.*
        FROM service_column_metadata scm
        WHERE group_id IN
          (SELECT bep.parameter_spec_id
          FROM business_process_mapping bpm,
            business_entity_parameter bep
          WHERE bpm.parent_id IN
            (IP_VALUES)
          AND bep.parent_id = bpm.record_key
          )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100021','SERVICE_COLUMN_METADATA','SCM','23','10',str,'Y','SERV_COL_META_ID','N','Process Plan');
dbms_output.put_line('SERVICE_COLUMN_METADATA Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_10 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ebc.*
FROM
    entity_boundary_condition ebc
WHERE
    ebc.entity_id IN (
        IP_VALUES
)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100040','ENTITY_BOUNDARY_CONDITION','EBC','42','40',str,'Y','EBC_ID','N','Process Plan');
dbms_output.put_line('ENTITY_BOUNDARY_CONDITION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_11 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
            lcm.*
        FROM
            life_cycle_activity_metadata lcm,

               (     select distinct parent_rule_id
FROM
    business_process_mapping   pes,
    parameter_rule_specification   prs
   , rule                           r
   WHERE
    prs.parent_id = pes.entityid
    AND pes.parent_id IN (IP_VALUES  )
    AND r.rule_id = prs.rule_id
     ) pee
                       where lcm.entity_id=pee.parent_rule_id 
union all

SELECT
    lcm.*
FROM
    (
        WITH pids AS (
            SELECT DISTINCT
                pid
            FROM
                process_entity pe
            WHERE
                    pe.version = (
                        SELECT
                            MAX(version)
                        FROM
                            process_entity
                        WHERE
                            pe.pid = pid
                    )
                AND pe.pid IN (IP_VALUES)
        )
        SELECT
            lcm.*
        FROM
            life_cycle_activity_metadata lcm,
            (
                SELECT
                    p.pid
                FROM
                    pids p
                UNION
                SELECT
                    be.bid
                FROM
                    pids                     p,
                    business_entity          be,
                    business_process_mapping bpm
                WHERE
                        bpm.entityid = be.bid
                    AND bpm.parent_id = p.pid
            )                            pe
        WHERE
                lcm.entity_id = pe.pid
            AND lcm.lca_version = (
                SELECT
                    MAX(lca_version)
                FROM
                    life_cycle_activity_metadata lca
                WHERE
                     lca.entity_id = lcm.entity_id
            )
    ) lcm
>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100020','LIFE_CYCLE_ACTIVITY_METADATA','LCAM','22','11',str,'Y','LCA_ID','N','Process Plan');
dbms_output.put_line('LIFE_CYCLE_ACTIVITY_METADATA Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_12 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<WITH rule_det AS (
    SELECT DISTINCT
        r.*
    FROM
        business_process_mapping     bpm,
        business_entity_parameter    bep,
        parameter_rule_specification prs,
        rule                         r
    WHERE
        bpm.parent_id IN ( IP_VALUES )
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
        prs.parent_id IN ( IP_VALUES )
        AND r.rule_id = prs.rule_id
    UNION
    SELECT
        r.*
    FROM
        parameter_rule_specification prs,
        rule                         r
    WHERE
        r.parent_rule_id IN ( IP_VALUES )
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
                bpm.parent_id IN ( IP_VALUES )
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
        egf.pid IN ( IP_VALUES )
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
        pas.parent_id IN ( IP_VALUES )
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
                r.parent_rule_id IN ( IP_VALUES )
                AND r.rule_id = prs.rule_id
        )
    UNION
    SELECT
        r.*
    FROM
        rule r
    WHERE
        r.parent_rule_id IN ( IP_VALUES )
    UNION
    SELECT
        r.*
    FROM
        process_entity_specification pes,
        parameter_rule_specification prs,
        rule                         r
    WHERE
            prs.parent_id = pes.process_spec_id
        AND pes.pid IN ( IP_VALUES )
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
                AND bpm.parent_id IN ( IP_VALUES )
        )
        AND p.rule_id = r1.rule_id
        AND r1.parent_rule_id = r.rule_id
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
        AND 1 = (
            CASE
                WHEN r.entity_type_id IS NOT NULL
                     AND r.entity_id IN ( IP_VALUES ) THEN
                    1
                WHEN r.entity_type_id IS NULL THEN
                    1
                WHEN r.entity_id NOT IN ( IP_VALUES ) THEN
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
                AND bpm.parent_id IN ( IP_VALUES )
        )
        AND p.rule_id = r1.rule_id
        AND r1.parent_rule_id = r.rule_id
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
        AND 1 = (
            CASE
                WHEN r.entity_type_id IS NOT NULL
                     AND r.entity_id IN ( IP_VALUES ) THEN
                    1
                WHEN r.entity_type_id IS NULL THEN
                    1
                WHEN r.entity_id NOT IN ( IP_VALUES ) THEN
                    0
            END
        )
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/
    UNION
    /* RULE_ASSOC_TO_OFFR_DLT_2024 STARTS*/
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
                AND bpm.parent_id IN ( IP_VALUES )
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
                AND bpm.parent_id IN ( IP_VALUES )
        )
        AND prs.rule_id = r.rule_id
        AND r.parent_rule_id = r1.rule_id
	/* RULE_ASSOC_TO_OFFR_DLT_2024 ENDS*/
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
                                AND bpm.parent_id IN ( IP_VALUES )
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
                                                AND bpm.parent_id IN ( IP_VALUES )
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
                ebc.entity_id IN ( IP_VALUES )
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
        ts.parent_id IN ( IP_VALUES )
        AND ts.id = trs.parent_id
        AND trs.id = r.row_spec_id
	/*API_FUNC_RULE_GRID_ENH_2024 ENDS*/
	UNION
	SELECT
        r1.*
    FROM
        parameter_specification      ps,
        parameter_rule_specification prs,
		rule						 r,
		rule						 r1
    WHERE
            ps.param_basic_spec_id = prs.reference_store_id
        AND prs.expression_type = 'Parameter'
		AND r.rule_id = prs.rule_id
        AND r.parent_rule_id = r1.rule_id
        AND prs.parent_id IN (
            SELECT
                be.bid
            FROM
                business_entity          be, business_process_mapping bpm
            WHERE
                    bpm.entityid = be.bid
                AND bpm.parent_id IN ( IP_VALUES )
        )
		/*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
		 AND 1 = (
            CASE
                WHEN r1.entity_type_id IS NOT NULL
                     AND r.entity_id IN ( IP_VALUES ) THEN
                    1
                WHEN r1.entity_type_id IS NULL THEN
                    1
                WHEN r1.entity_id NOT IN ( IP_VALUES ) THEN
                    0
            END
        )
		/*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/
)
SELECT
    r.*
FROM
    rule_det r
UNION
SELECT
    r.*
FROM
    rule_det rd,
    rule     r
WHERE
    r.parent_rule_id = rd.rule_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100015','RULE','RUL','16','20',str,'Y','RULE_ID','N','Process Plan');
dbms_output.put_line('RULE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_13 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<WITH prs_det AS (
    SELECT
        prs.*
    FROM
        ( (
            SELECT
                prs.*
            FROM
                business_process_mapping     bpm,
                business_entity_parameter    bep,
                parameter_rule_specification prs
            WHERE
                bpm.parent_id IN ( IP_VALUES )
                AND bep.parent_id = bpm.record_key
                AND bep.parameter_spec_id = prs.parent_id
        ) ) prs
    UNION
    SELECT
        prs.*
    FROM
        (
            SELECT
                prs.*
            FROM
                parameter_rule_specification prs,
                rule                         r
            WHERE
                prs.parent_id IN ( IP_VALUES )
                AND r.rule_id = prs.rule_id
        ) prs
    UNION
    SELECT
        prs.*
    FROM
        (
            SELECT
                prs.*
            FROM
                parameter_rule_specification prs,
                rule                         r
            WHERE
                r.parent_rule_id IN ( IP_VALUES )
                AND r.rule_id = prs.rule_id
        ) prs
    UNION
    SELECT
        prs.*
    FROM
        (
            SELECT
                prs.*
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
                        bpm.parent_id IN ( IP_VALUES )
                )
                AND cps.charge_item_id = pps.pp_instance_id
                AND prs.rule_id = cps.rule_id
        ) prs
    UNION
    SELECT
        prs.*
    FROM
        (
            SELECT
                prs.*
            FROM
                entity_join_parameter        ejp,
                rule                         r,
                entity_group_function        egf,
                parameter_rule_specification prs
            WHERE
                egf.pid IN ( IP_VALUES )
                AND egf.group_id = ejp.group_id
                AND egf.entity_function_id = ejp.entity_function_id
                AND ejp.mapping_entity_id = r.rule_id
                AND r.rule_id = prs.rule_id
        ) prs
    UNION
    SELECT
        prs.*
    FROM
        (
            SELECT DISTINCT
                prs.*
            FROM
                parameter_rule_specification prs,
                process_action_specification pas,
                rule                         r
            WHERE
                pas.parent_id IN ( IP_VALUES )
                AND pas.action_id = prs.parent_id
                AND r.rule_id = prs.rule_id
        ) prs
    UNION
    SELECT
        prs.*
    FROM
        process_entity_specification pes,
        parameter_rule_specification prs
    WHERE
            prs.parent_id = pes.process_spec_id
        AND pes.pid IN ( IP_VALUES )
    UNION
    SELECT
        prs.*
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
                r.parent_rule_id IN ( IP_VALUES )
                AND r.rule_id = prs.rule_id
        )
        AND r.rule_id = prs.rule_id
    UNION
    SELECT
        p.*
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
                AND bpm.parent_id IN ( IP_VALUES )
        )
        AND p.rule_id = r.rule_id
        AND r.parent_rule_id = r1.rule_id
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
		 AND 1 = (
            CASE
                WHEN r1.entity_type_id IS NOT NULL
                     AND r.entity_id IN ( IP_VALUES ) THEN
                    1
                WHEN r1.entity_type_id IS NULL THEN
                    1
                WHEN r1.entity_id NOT IN ( IP_VALUES ) THEN
                    0
            END
        )
		/*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/
    UNION
	    /* RULE_ASSOC_TO_OFFR_DLT_2024 STARTS*/
    SELECT
    prs.*
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
               IP_VALUES
            )
    )
    AND prs.rule_id = r.rule_id
    UNION
    SELECT
    prs1.*
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
               IP_VALUES
            )
    )
    AND prs.rule_id = r.rule_id
    AND r.parent_rule_id = r1.rule_id
    AND r1.rule_id = prs1.rule_id
	    /* RULE_ASSOC_TO_OFFR_DLT_2024 ENDS*/
    UNION
    SELECT
        pes.*
    FROM
        parameter_rule_specification pes,
        rule                         r,
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
                                AND bpm.parent_id IN ( IP_VALUES )
                        )
                        AND p.parameter_id = bp.parameter_id
                        AND ps.parent_id = p.parameter_id
                        AND ps.core_spec = 'Yes'
                ) rt
            WHERE
                sk = 1
        )                            pbsi
    WHERE
            pes.parent_id = pbsi.param_basic_spec_id
        AND r.rule_id = pes.rule_id
    UNION
    SELECT
        prs.*
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
                                                AND bpm.parent_id IN ( IP_VALUES )
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
        prs.*
    FROM
        reference_type_values        rtv,
        reference_types              rt,
        parameter_rule_specification prs
    WHERE
        prs.parent_id IN (
            SELECT
                be.bid
            FROM
                business_entity          be, business_process_mapping bpm
            WHERE
                    bpm.entityid = be.bid
                AND bpm.parent_id IN ( IP_VALUES )
        )
        AND prs.expression_type = 'Reference'
        AND rtv.ref_val_id = prs.reference_value
        AND rt.ref_type_id = rtv.ref_type_id
    UNION
    SELECT
        prs.*
    FROM
        parameter_specification      ps,
        parameter_rule_specification prs,
		rule						 r,
		rule						 r1
    WHERE
            ps.param_basic_spec_id = prs.reference_store_id
        AND prs.expression_type = 'Parameter'
		AND prs.rule_id = r.rule_id
		AND r.parent_rule_id = r1.rule_id
        AND prs.parent_id IN (
            SELECT
                be.bid
            FROM
                business_entity          be, business_process_mapping bpm
            WHERE
                    bpm.entityid = be.bid
                AND bpm.parent_id IN ( IP_VALUES )
        )
        /*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 STARTS*/
		 AND 1 = (
            CASE
                WHEN r1.entity_type_id IS NOT NULL
                     AND r.entity_id IN ( IP_VALUES ) THEN
                    1
                WHEN r1.entity_type_id IS NULL THEN
                    1
                WHEN r1.entity_id NOT IN ( IP_VALUES ) THEN
                    0
            END
        )
		/*RULE_ASSOC_TO_IP_PROCESSPLAN_2024 ENDS*/
    UNION
    SELECT
        prs.*
    FROM
        rule                         ru,
        parameter_rule_specification prs
    WHERE
        ru.entity_id IN ( IP_VALUES )
        AND prs.rule_id = ru.rule_id
    UNION
	/*API_FUNC_RULE_GRID_ENH_2024 STARTS*/
    SELECT
    prs.*
FROM
    rule                    r,
    parameter_rule_specification prs,
    table_specification     ts,
    table_row_specification trs
WHERE
    ts.parent_id IN ( IP_VALUES )
    AND ts.id = trs.parent_id
    AND trs.id = r.row_spec_id
    AND r.rule_id = prs.rule_id
	/*API_FUNC_RULE_GRID_ENH_2024 ENDS*/
)
SELECT
    prs.*
FROM
    prs_det prs
UNION
SELECT
    prs1.*
FROM
    prs_det                      prs,
    rule                         r,
    parameter_rule_specification prs1
WHERE
        prs.rule_id = r.parent_rule_id
    AND r.rule_id = prs1.rule_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100016','PARAMETER_RULE_SPECIFICATION','PRS','18','15',str,'Y','PARAM_RULE_SPEC_ID','N','Process Plan');
dbms_output.put_line('PARAMETER_RULE_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_14 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pm.*
FROM
    product_mapping pm
WHERE
    pm.offering_process_id IN (
        IP_VALUES
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100044','PRODUCT_MAPPING','PM','43','13',str,'Y','OFFERING_PROCESS_ID','N','Process Plan');
dbms_output.put_line('PRODUCT_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_15 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    bad.*
FROM
    user_auth_process_mapping uap,
    basic_auth_details bad
WHERE
bad.client_id = uap.user_id
    AND uap.auth_process_id IN (SELECT pe.lifecycle_id FROM process_entity pe WHERE pe.pid IN (IP_VALUES)
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100043','BASIC_AUTH_DETAILS','BAD','44','',str,'Y','CLIENT_ID','N','Process Plan');
dbms_output.put_line('BASIC_AUTH_DETAILS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_16 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT * 
FROM
(
SELECT bes.*
        FROM
          (SELECT bes.*
          FROM business_process_mapping bpm,
          business_entity_specification bes,
            business_entity be
          WHERE bpm.parent_id IN
            (  IP_VALUES)
          AND be.bid = bpm.entityid
          and be.bid=bes.root_id)bes
)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100045','BUSINESS_ENTITY_SPECIFICATION','BES','3','35',str,'Y','BUSINESS_ENTITY_SPEC_ID','N','Process Plan');
dbms_output.put_line('BUSINESS_ENTITY_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_17 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ei.*
FROM
    error_info ei
WHERE
    ei.error_id IN (
        SELECT
            prs.error_id
        FROM
            business_parameters          bp, business_entity              be, parameter_rule_specification prs
        WHERE
                be.bid IN (IP_VALUES)
            AND be.bid = bp.bid
            AND bp.core_param_spec_id = prs.parent_id
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100049','ERROR_INFO','EI','14','',str,'Y','ERROR_ID','N','BusinessEntity');
dbms_output.put_line('ERROR_INFO Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_18 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pfas.*
FROM
    business_parameters bp,
    business_entity     be,
    parameter_format_addon_spec pfas
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND pfas.param_spec_id = bp.core_param_spec_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100050','PARAMETER_FORMAT_ADDON_SPEC','PFAS','15','',str,'Y','PARAM_FORMAT_ADDON_SPEC_ID','N','BusinessEntity');
dbms_output.put_line('PARAMETER_FORMAT_ADDON_SPEC Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_19 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select   pe.*
FROM
    process_entity pe
WHERE
    pe.pid IN (IP_VALUES) 


    AND 1 = (
        CASE
        when 1 = (select distinct 1 from process_entity where pid = ip_process_id and type = 'Interface') then
            0

            WHEN pe.type = 'Interface'
                 AND pe.parent_id IN (IP_VALUES) THEN
                1
            WHEN pe.type <> 'Interface' THEN
                1
            WHEN pe.type = 'Interface' AND  pe.parent_id = 0 and pe.root_id = 0   THEN
                1
           WHEN pe.type = 'Interface' and pe.pid in (select template_id from rule where template_id in (IP_VALUES)) THEN
               1 
            WHEN pe.type = 'Interface' and pe.pid in (select action_process_id from process_action_specification where action_process_id in (IP_VALUES))THEN
                1

            ELSE
                0

        END
    )
    union all
select pe1.* from process_entity pe1 ,(select distinct pid from process_entity pe
where pe.pid in (ip_process_id)
and 1 = (case when pe.type = 'Interface' then
1 
else 0 end)) pe
 start with 
pe1.pid =  pe.pid connect by prior pe1.pid = pe1.parent_id
union 
    SELECT 
    pe.*
FROM 
    business_entity                be, 
    business_process_mapping       bpm, 
    process_entity_specification   pes, 
    process_entity                 pe 
 WHERE 
    be.bid IN (SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (
                IP_VALUES
            )
    )
    AND bpm.entityid = be.bid 
    AND pes.pid = bpm.parent_id 
    AND pe.pid = pes.pid 
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100003','PROCESS_ENTITY','PE','4','41',str,'Y','PARENT_ID, PID, VERSION ,ROOT_ID','N','Process Plan');
dbms_output.put_line('PROCESS_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_20 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ps.*
FROM
    business_process_mapping  bpm,
    business_entity_parameter bep,
    parameter_specification   ps
WHERE
    bpm.parent_id IN ( IP_VALUES )
    AND bep.parent_id = bpm.record_key
    AND ps.param_basic_spec_id = bep.parameter_spec_id
UNION
SELECT
    ps.*
FROM
    parameter_specification      ps,
    parameter_rule_specification prs,
    business_process_mapping     bpm
WHERE
        ps.param_basic_spec_id = prs.reference_store_id
    AND prs.expression_type = 'Parameter'
    AND prs.parent_id = bpm.entityid
    AND bpm.parent_id IN (
        IP_VALUES
    )
UNION
SELECT
    ps.*
FROM
    business_parameters      bp,
    parameter_specification  ps,
    business_process_mapping bpm
WHERE
        ps.param_basic_spec_id = bp.core_param_spec_id
    AND bp.bid = bpm.entityid
    AND bpm.parent_id IN (
        IP_VALUES
    )
UNION
SELECT
    ps.*
FROM
    process_entity          pe,
    table_specification     ts,
    table_row_specification trs,
    table_parameter_mapping tpm,
    parameter_specification ps
WHERE
        ps.param_basic_spec_id = tpm.parameter_spec_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN (
       IP_VALUES
    )
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100008','PARAMETER_SPECIFICATION','PS','9','28',str,'Y','PARAM_BASIC_SPEC_ID','Y','Process Plan');
dbms_output.put_line('PARAMETER_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_21 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pfs.*
FROM
    business_parameters bp,
    business_entity     be,
    parameter_func_specification pfs
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND pfs.param_spec_id = bp.core_param_spec_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100051','PARAMETER_FUNC_SPECIFICATION','PFS','16','',str,'Y','PARAM_FUNC_SPEC_ID','N','BusinessEntity');
dbms_output.put_line('PARAMETER_FUNC_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_22 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pas.*
FROM
    parameter_addon_specification pas,
    business_process_mapping      bpm,
    business_entity_parameter     bep
WHERE
        pas.parent_id = bep.parameter_spec_id
    AND bpm.parent_id IN (
       IP_VALUES
    )
    AND bep.parent_id = bpm.record_key
UNION
SELECT
    pas.*
FROM
    process_entity                pe,
    table_specification           ts,
    table_row_specification       trs,
    table_parameter_mapping       tpm,
    parameter_addon_specification pas
WHERE
        pas.parent_id = tpm.parameter_spec_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN (
        IP_VALUES
    )
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100009','PARAMETER_ADDON_SPECIFICATION','PADDSPEC','10','27',str,'Y','PARAM_ADDON_SPEC_ID','Y','Process Plan');
dbms_output.put_line('PARAMETER_ADDON_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_23 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    rtv.*
FROM
    reference_types       rt,
    reference_type_values rtv,
    (
        SELECT
            prs.ref_default_id
        FROM
            parameter_reference_value prs,
            business_entity           be
        WHERE
                be.bid IN (IP_VALUES)
            AND be.bid = prs.param_spec_id
        UNION
        SELECT
            prs.ref_default_id
        FROM
            parameter_reference_value prs,
            business_parameters       bp,
            business_entity           be
        WHERE
                be.bid IN (IP_VALUES)
            AND be.bid = bp.bid
            AND bp.core_param_spec_id = prs.param_spec_id
    )                     prs
WHERE
        rt.ref_type_id = prs.ref_default_id
    AND rtv.ref_type_id = rt.ref_type_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100052','REFERENCE_TYPE_VALUES','REFTYPVAL','11','3',str,'Y','REF_VAL_ID','N','BusinessEntity');
dbms_output.put_line('REFERENCE_TYPE_VALUES Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_24 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    prs.*
FROM
    parameter_reference_value prs,
    business_entity           be
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = prs.param_spec_id
UNION
SELECT
    prs.*
FROM
    parameter_reference_value prs,
    business_parameters       bp,
    business_entity           be
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.core_param_spec_id = prs.param_spec_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100053','PARAMETER_REFERENCE_VALUE','PRV','12','2',str,'Y','PARAM_REF_VAL_ID','N','BusinessEntity');
dbms_output.put_line('PARAMETER_REFERENCE_VALUE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_25 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    bp.*
FROM
    business_parameters bp,
    business_entity     be
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100054','BUSINESS_PARAMETERS','BP','13','1',str,'Y','BUSINESS_PARAM_ID','N','BusinessEntity');
dbms_output.put_line('BUSINESS_PARAMETERS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_26 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    lcam.*
FROM
    business_entity be,
    life_cycle_activity_metadata lcam
WHERE
    be.bid IN (IP_VALUES)
    AND lcam.entity_id = be.bid
    AND lcam.lca_version = (select max(lca_version) from life_cycle_activity_metadata where entity_id = lcam.entity_id)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100055','LIFE_CYCLE_ACTIVITY_METADATA','LCAM','17','',str,'Y','LCA_ID','N','BusinessEntity');
dbms_output.put_line('LIFE_CYCLE_ACTIVITY_METADATA Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_27 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    p.*
FROM
    business_parameters bp,
    business_entity     be,
    parameter           p
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.parameter_id = p.parameter_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100056','PARAMETER','P','3','11',str,'Y','PARAMETER_ID','N','BusinessEntity');
dbms_output.put_line('PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_28 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ps.*
FROM
    business_parameters     bp,
    business_entity         be,
    parameter_specification ps
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.core_param_spec_id = ps.param_basic_spec_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100057','PARAMETER_SPECIFICATION','PS','4','10',str,'Y','PARAM_BASIC_SPEC_ID','Y','BusinessEntity');
dbms_output.put_line('PARAMETER_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_29 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    p.*
FROM
    business_process_mapping  bpm,
    business_entity_parameter bep,
    parameter                 p,
    parameter_specification   ps
WHERE
    bpm.parent_id IN ( IP_VALUES )
    AND bep.parent_id = bpm.record_key
    AND bep.parameter_spec_id = ps.param_basic_spec_id
    AND p.parameter_id = ps.parent_id
UNION
SELECT
    p.*
FROM
    parameter p
WHERE
    parameter_id IN (
        SELECT
            bp.parameter_id
        FROM
            business_entity     be, business_parameters bp
        WHERE
            be.business_entity_name IN (
                SELECT
                    data_store_name
                FROM
                    parameter_data_specification
                WHERE
                    parent_id IN ( IP_VALUES )
            )
            AND bp.bid = be.bid
    )
UNION
SELECT
    p.*
FROM
    business_parameters      bp,
    parameter                p,
    parameter_specification  ps,
    business_process_mapping bpm
WHERE
        ps.parent_id = p.parameter_id
    AND ps.param_basic_spec_id = bp.core_param_spec_id
    AND bp.core_param_spec_id IS NOT NULL
    AND bpm.entityid = bp.bid
    AND bpm.parent_id IN ( IP_VALUES )
UNION
SELECT
    p.*
FROM
    business_process_mapping bpm,
    business_entity          be,
    business_entity_relation ber,
    business_parameters      bp,
    parameter                p
WHERE
    bpm.parent_id IN ( IP_VALUES )
    AND be.bid = ber.child_id
    AND ber.parent_id = bpm.entityid
    AND bp.parameter_id = p.parameter_id
    AND bp.bid = be.bid>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100007','PARAMETER','P','8','29',str,'Y','PARAMETER_ID','N','Process Plan');
dbms_output.put_line('PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_30 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    rcm.*
FROM
    ref_content_management       rcm,
    process_layout_specification pls
WHERE
    pls.parent_id IN ( IP_VALUES )
    AND pls.layout_content_id = rcm.content_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100048','REF_CONTENT_MANAGEMENT','RCM','47','',str,'Y','CONTENT_ID','N','Process Plan');
dbms_output.put_line('REF_CONTENT_MANAGEMENT Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_31 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pads.*
FROM
    business_parameters           bp,
    business_entity               be,
    parameter_addon_specification pads
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.core_param_spec_id = pads.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100058','PARAMETER_ADDON_SPECIFICATION','PADDSPEC','5','9',str,'Y','PARAM_ADDON_SPEC_ID','Y','BusinessEntity');
dbms_output.put_line('PARAMETER_ADDON_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_32 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pds.*
FROM
    business_parameters          bp,
    business_entity              be,
    parameter_data_specification pds
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.core_param_spec_id = pds.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100059','PARAMETER_DATA_SPECIFICATION','PDS','6','8',str,'Y','PARAM_DATA_SPEC_ID','N','BusinessEntity');
dbms_output.put_line('PARAMETER_DATA_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_33 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    r.*
FROM
    rule r
WHERE
    r.rule_id IN (
        SELECT
            prs.rule_id
        FROM
            business_parameters          bp, business_entity              be, parameter_rule_specification prs
        WHERE
                be.bid IN (IP_VALUES)
            AND be.bid = bp.bid
            AND bp.core_param_spec_id = prs.parent_id
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100060','RULE','RUL','7','7',str,'Y','RULE_ID','N','BusinessEntity');
dbms_output.put_line('RULE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_34 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    prs.*
FROM
    business_parameters          bp,
    business_entity              be,
    parameter_rule_specification prs
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.core_param_spec_id = prs.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100061','PARAMETER_RULE_SPECIFICATION','PRS','8','6',str,'Y','PARAM_RULE_SPEC_ID','N','BusinessEntity');
dbms_output.put_line('PARAMETER_RULE_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_35 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pas.*
FROM
    business_parameters          bp,
    business_entity              be,
    process_action_specification pas
WHERE
        be.bid IN (IP_VALUES)
    AND be.bid = bp.bid
    AND bp.core_param_spec_id = pas.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100062','PROCESS_ACTION_SPECIFICATION','PACTSPEC','9','5',str,'Y','ACTION_ID','N','BusinessEntity');
dbms_output.put_line('PROCESS_ACTION_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_36 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    rt.*
FROM
    reference_types rt,
    (
        SELECT
            prs.ref_default_id
        FROM
            parameter_reference_value prs,
            business_entity           be
        WHERE
                be.bid IN (IP_VALUES)
            AND be.bid = prs.param_spec_id
        UNION
        SELECT
            prs.ref_default_id
        FROM
            parameter_reference_value prs,
            business_parameters       bp,
            business_entity           be
        WHERE
                be.bid IN (IP_VALUES)
            AND be.bid = bp.bid
            AND bp.core_param_spec_id = prs.param_spec_id
    )               prs
WHERE
    rt.ref_type_id = prs.ref_default_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100063','REFERENCE_TYPES','REFTYP','10','4',str,'Y','REF_TYPE_ID','N','BusinessEntity');
dbms_output.put_line('REFERENCE_TYPES Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_37 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    *
FROM
    business_entity
WHERE
    bid IN (IP_VALUES)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100064','BUSINESS_ENTITY','BE','1','13',str,'Y','BID','Y','BusinessEntity');
dbms_output.put_line('BUSINESS_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_38 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT DISTINCT
    epcm.*
FROM
    entity_product_code_mapping epcm,
    business_process_mapping    bpm
WHERE
    bpm.parent_id IN ( IP_VALUES )
    AND bpm.entityid = epcm.business_entity_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100046','ENTITY_PRODUCT_CODE_MAPPING','EPCM','46','36',str,'Y','ENTITY_PRD_CD_ID','N','Process Plan');
dbms_output.put_line('ENTITY_PRODUCT_CODE_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_39 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT DISTINCT
    pcd.*
FROM
    entity_product_code_mapping epcm,
    business_process_mapping    bpm,
    product_code_details pcd
WHERE
    bpm.parent_id IN ( IP_VALUES )
    AND bpm.entityid = epcm.business_entity_id
    AND epcm.product_code_id = pcd.product_code_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100047','PRODUCT_CODE_DETAILS','PCD','45','37',str,'Y','PRODUCT_CODE_ID','N','Process Plan');
dbms_output.put_line('PRODUCT_CODE_DETAILS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_40 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    bes.*
FROM
    business_entity_specification bes,
    business_entity               be
WHERE
        bes.root_id = be.bid
    AND be.bid IN (IP_VALUES)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100065','BUSINESS_ENTITY_SPECIFICATION','BES','2','12',str,'Y','BUSINESS_ENTITY_SPEC_ID','N','BusinessEntity');
dbms_output.put_line('BUSINESS_ENTITY_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_41 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select epcm1.* from ENTITY_PRODUCT_CODE_MAPPING epcm,ENTITY_PRODUCT_CODE_MAPPING epcm1 where epcm.root_id = l_n_entity_process_id
and epcm.product_code_id = epcm1.product_code_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100145','ENTITY_PRODUCT_CODE_MAPPING','EPCM','27','22',str,'Y','ENTITY_PRD_CD_ID','N','MarketOffering');
dbms_output.put_line('ENTITY_PRODUCT_CODE_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_42 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select scm.* from SERVICE_COLUMN_METADATA scm where scm.root_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100147','SERVICE_COLUMN_METADATA','SCM','28','3',str,'Y','SERV_COL_META_ID','N','MarketOffering');
dbms_output.put_line('SERVICE_COLUMN_METADATA Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_43 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from OBJECT_CHANGE_DETAILS ocd where  ocd.entity_id= ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100148','OBJECT_CHANGE_DETAILS','OCD','29','',str,'Y','SCRIPT_ID','N','MarketOffering');
dbms_output.put_line('OBJECT_CHANGE_DETAILS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_44 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from rule r where r.root_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100149','RULE','R','30','10',str,'Y','RULE_ID','N','MarketOffering');
dbms_output.put_line('RULE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_45 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select prs.* from parameter_rule_specification prs,
rule r where prs.rule_id = r.rule_id
and r.root_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100150','PARAMETER_RULE_SPECIFICATION','PRS','31','6',str,'Y','PARAM_RULE_SPEC_ID','N','MarketOffering');
dbms_output.put_line('PARAMETER_RULE_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_46 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select ei.* from error_info ei , rule r 
where 
r.code = ei.ERROR_CODE
and r.root_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100151','ERROR_INFO','EI','32','',str,'Y','ERROR_ID','N','MarketOffering');
dbms_output.put_line('ERROR_INFO Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_47 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select rt.* from parameter_rule_specification prs,
rule r,
reference_types rt where 
prs.dynamic_reference_id = rt.ref_type_id
and prs.rule_id = r.rule_id
and r.root_id = l_n_entity_process_id
union
select * from reference_types rt 
where rt.ref_type_id  in (select prv.REF_DEFAULT_ID from parameter_reference_value prv where prv.PARAM_SPEC_ID in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100152','REFERENCE_TYPES','REFTYP','33','',str,'Y','REF_TYPE_ID','N','MarketOffering');
dbms_output.put_line('REFERENCE_TYPES Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_48 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from LIFE_CYCLE_ACTIVITY_METADATA lcam where entity_id in (select r.rule_id from rule r where r.root_id = l_n_entity_process_id
union
SELECT
    pe.pid
FROM
    process_entity pe
WHERE
    pe.root_id = ip_process_id
union 
SELECT
    pe.pid
FROM
    process_entity pe
WHERE
    pe.pid = ip_process_id
union
SELECT
    be.bid
FROM
    business_entity            be,
    business_process_mapping   bpm,
    business_entity_relation   ber
WHERE
    ber.child_id = be.bid
    AND ber.root_id = bpm.entityid
    AND bpm.parent_id = ip_process_id
    union
    select be.bid from business_process_mapping   bpm,business_entity            be where 
    be.bid = bpm.entityid
    and bpm.parent_id = ip_process_id)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100154','LIFE_CYCLE_ACTIVITY_METADATA','LCAM','34','',str,'Y','LCA_ID','N','MarketOffering');
dbms_output.put_line('LIFE_CYCLE_ACTIVITY_METADATA Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_49 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select distinct rtv.* from parameter_rule_specification prs,
rule r,
reference_types rt,
reference_type_values rtv where 
rtv.ref_type_id = rt.ref_type_id
and prs.dynamic_reference_id = rt.ref_type_id
and prs.rule_id = r.rule_id
and r.root_id = l_n_entity_process_id
union
select distinct rtv.* from reference_types rt,
reference_type_values rtv 
where 
rtv.ref_type_id = rt.ref_type_id
and rt.ref_type_id  in (select prv.REF_DEFAULT_ID from parameter_reference_value prv where prv.PARAM_SPEC_ID in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100153','REFERENCE_TYPE_VALUES','RTV','35','',str,'Y','REF_VAL_ID','N','MarketOffering');
dbms_output.put_line('REFERENCE_TYPE_VALUES Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_50 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    be.*
FROM
    business_entity          be,
    business_process_mapping bpm,
    business_entity_relation ber
WHERE
        ber.child_id = be.bid
    AND ber.root_id = bpm.entityid
    AND bpm.parent_id = ip_process_id
UNION
SELECT
    be.*
FROM
    business_process_mapping bpm,
    business_entity          be
WHERE
        be.bid = bpm.entityid
    AND bpm.parent_id = ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100120','BUSINESS_ENTITY','BE','1','13',str,'Y','BID','Y','MarketOffering');
dbms_output.put_line('BUSINESS_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_51 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ber.*
FROM
    business_process_mapping   bpm,
    business_entity_relation   ber
WHERE
    ber.root_id = bpm.entityid
    AND bpm.parent_id = ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100121','BUSINESS_ENTITY_RELATION','BER','2','19',str,'Y','BUSINESS_ENTITY_REL_ID','N','MarketOffering');
dbms_output.put_line('BUSINESS_ENTITY_RELATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_52 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    bes.*
FROM
    business_entity_specification   bes,
    business_process_mapping        bpm
WHERE
    bes.root_id = bpm.entityid
    AND bpm.parent_id = ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100122','BUSINESS_ENTITY_SPECIFICATION','BES','3','21',str,'Y','BUSINESS_ENTITY_SPEC_ID','N','MarketOffering');
dbms_output.put_line('BUSINESS_ENTITY_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_53 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pe.*
FROM
    process_entity pe
WHERE
    pe.root_id = ip_process_id
union 
SELECT
    pe.*
FROM
    process_entity pe
WHERE
    pe.pid = ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100123','PROCESS_ENTITY','PE','4','25',str,'Y','PARENT_ID, PID, VERSION ,ROOT_ID','N','MarketOffering');
dbms_output.put_line('PROCESS_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_54 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pes.*
FROM
    process_entity pe,
    process_entity_specification pes
WHERE
   pe.pid = pes.pid
   and  pe.root_id = ip_process_id
union 
SELECT
    pes.*
FROM
    process_entity pe,
    process_entity_specification pes
WHERE
     pe.pid = pes.pid
    and pe.pid = ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100124','PROCESS_ENTITY_SPECIFICATION','PES','5','18',str,'Y','PROCESS_SPEC_ID','N','MarketOffering');
dbms_output.put_line('PROCESS_ENTITY_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_55 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pls.*
FROM
    process_entity pe,
    process_layout_specification pls
WHERE
   pe.pid = pls.parent_id
   and  pe.root_id = ip_process_id
union 
SELECT
    pls.*
FROM
    process_entity pe,
    process_layout_specification pls
WHERE
     pe.pid = pls.parent_id
    and pe.pid = ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100125','PROCESS_LAYOUT_SPECIFICATION','PLS','6','17',str,'Y','LAYOUT_ID','N','MarketOffering');
dbms_output.put_line('PROCESS_LAYOUT_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_56 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<WITH res AS (
    SELECT
        pe.pid
    FROM
        process_entity pe
    WHERE
        pe.root_id = ip_process_id
    UNION
    SELECT
        pe.pid
    FROM
        process_entity pe
    WHERE
        pe.pid = ip_process_id
)
SELECT
    pas.*
FROM
    process_action_specification pas,
    (
        SELECT
            pid
        FROM
            res
        UNION
        SELECT
            bep.parameter_spec_id
        FROM
            business_entity_parameter bep,
            business_process_mapping  bpm,
            res
        WHERE
                bpm.parent_id = res.pid
            AND bpm.record_key = bep.parent_id
    )                            pe
WHERE
    pe.pid = pas.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100126','PROCESS_ACTION_SPECIFICATION','PAS','7','4',str,'Y','ACTION_ID','N','MarketOffering');
dbms_output.put_line('PROCESS_ACTION_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_57 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from business_process_mapping where parent_id in (SELECT
    pe.pid
FROM
    process_entity pe
WHERE
    pe.root_id = ip_process_id
union 
SELECT
    pe.pid
FROM
    process_entity pe
WHERE
    pe.pid = ip_process_id)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100127','BUSINESS_PROCESS_MAPPING','BPM','8','24',str,'Y','RECORD_KEY','N','MarketOffering');
dbms_output.put_line('BUSINESS_PROCESS_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_58 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    bep.*
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100128','BUSINESS_ENTITY_PARAMETER','BEP','9','20',str,'Y','RECORD_KEY_PARAM','N','MarketOffering');
dbms_output.put_line('BUSINESS_ENTITY_PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_59 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ts.*
FROM
    table_specification ts
WHERE
    parent_id IN (
        SELECT
            pe.pid
        FROM
            process_entity pe
        WHERE
            pe.root_id = ip_process_id
        UNION
        SELECT
            pe.pid
        FROM
            process_entity pe
        WHERE
            pe.pid = ip_process_id
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100129','TABLE_SPECIFICATION','TS','10','13',str,'Y','ID','N','MarketOffering');
dbms_output.put_line('TABLE_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_60 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    *
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
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100130','TABLE_ROW_SPECIFICATION','TRS','11','12',str,'Y','ID','N','MarketOffering');
dbms_output.put_line('TABLE_ROW_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_61 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from table_parameter_mapping tpm where tpm.ROW_SPEC_ID in (SELECT
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
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    ))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100131','TABLE_PARAMETER_MAPPING','TPM','12','11',str,'Y','TABL_PARAM_MAPPING_ID','N','MarketOffering');
dbms_output.put_line('TABLE_PARAMETER_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_62 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from parameter_specification ps where param_basic_spec_id in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )
    union
SELECT
    bp.parameter_id
FROM

    Business_parameters            bp,
    business_process_mapping bpm 
WHERE
   bp.type = 'Property'
   and  bp.root_id = bpm.entityid
   and bpm.parent_id =ip_process_id  )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100132','PARAMETER_SPECIFICATION','PS','13','16',str,'Y','PARAM_BASIC_SPEC_ID','Y','MarketOffering');
dbms_output.put_line('PARAMETER_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_63 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select pas.* from parameter_addon_specification pas where pas.parent_id in (
select ps.param_basic_spec_id from parameter_specification ps where param_basic_spec_id in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )
    union 
   SELECT
    bp.parameter_id
FROM

    Business_parameters            bp,
    business_process_mapping bpm 
WHERE
   bp.type = 'Property'
   and  bp.root_id = bpm.entityid
   and bpm.parent_id =ip_process_id   ))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100133','PARAMETER_ADDON_SPECIFICATION','PADDSPEC','14','15',str,'Y','PARAM_ADDON_SPEC_ID','Y','MarketOffering');
dbms_output.put_line('PARAMETER_ADDON_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_64 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select pds.* from parameter_data_specification pds where pds.parent_id in (
select ps.param_basic_spec_id from parameter_specification ps where param_basic_spec_id in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100134','PARAMETER_DATA_SPECIFICATION','PDS','15','14',str,'Y','PARAM_DATA_SPEC_ID','N','MarketOffering');
dbms_output.put_line('PARAMETER_DATA_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_65 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select prv.* from parameter_reference_value prv where prv.PARAM_SPEC_ID in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )
    UNION
    select bid from business_entity where bid = l_n_entity_process_id)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100135','PARAMETER_REFERENCE_VALUE','PRV','16','2',str,'Y','PARAM_REF_VAL_ID','N','MarketOffering');
dbms_output.put_line('PARAMETER_REFERENCE_VALUE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_66 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    bp.*
FROM

    Business_parameters            bp,
    business_process_mapping bpm 
WHERE
   bp.root_id = bpm.entityid
   and bpm.parent_id =ip_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100136','BUSINESS_PARAMETERS','BP','17','',str,'Y','BUSINESS_PARAM_ID','N','MarketOffering');
dbms_output.put_line('BUSINESS_PARAMETERS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_67 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from parameter where parameter_id in (select ps.parent_id from parameter_specification ps where param_basic_spec_id in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )
    union
SELECT
    bp.parameter_id
FROM

    Business_parameters            bp,
    business_process_mapping bpm 
WHERE
   bp.type = 'Property'
   and  bp.root_id = bpm.entityid
   and bpm.parent_id =ip_process_id  ))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100137','PARAMETER','P','18','',str,'Y','PARAMETER_ID','N','MarketOffering');
dbms_output.put_line('PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_68 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select pfs.* from parameter_func_specification pfs where pfs.param_spec_id in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )
    union
SELECT
    bp.parameter_id
FROM

    Business_parameters            bp,
    business_process_mapping bpm 
WHERE
   bp.type = 'Property'
   and  bp.root_id = bpm.entityid
   and bpm.parent_id =ip_process_id  )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100138','PARAMETER_FUNC_SPECIFICATION','PFS','19','1',str,'Y','PARAM_FUNC_SPEC_ID','N','MarketOffering');
dbms_output.put_line('PARAMETER_FUNC_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_69 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from PARAMETER_FORMAT_ADDON_SPEC pfas where pfas.param_spec_id in (SELECT
    bep.PARAMETER_SPEC_ID
FROM
    business_entity_parameter bep
WHERE
    parent_id IN (
        SELECT
            RECORD_KEY
        FROM
            business_process_mapping
        WHERE
            parent_id IN (
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.root_id = ip_process_id
                UNION
                SELECT
                    pe.pid
                FROM
                    process_entity pe
                WHERE
                    pe.pid = ip_process_id
            )
    )
    union
SELECT
    bp.parameter_id
FROM

    Business_parameters            bp,
    business_process_mapping bpm 
WHERE
   bp.type = 'Property'
   and  bp.root_id = bpm.entityid
   and bpm.parent_id =ip_process_id  )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100139','PARAMETER_FORMAT_ADDON_SPEC','PFAS','20','',str,'Y','PARAM_FORMAT_ADDON_SPEC_ID','N','MarketOffering');
dbms_output.put_line('PARAMETER_FORMAT_ADDON_SPEC Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_70 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<
 SELECT
            pp.*
        FROM
            price_plan        pp,
            price_plan_entity ppe
        WHERE
                ppe.entity_id = l_n_entity_process_id
            AND ppe.plan_id = pp.price_plan_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100140','PRICE_PLAN','PP','21','',str,'Y','PRICE_PLAN_ID','N','MarketOffering');
dbms_output.put_line('PRICE_PLAN Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_71 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    ppe.*
FROM
    price_plan_entity ppe
WHERE
    ppe.entity_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100141','PRICE_PLAN_ENTITY','PPE','22','9',str,'Y','PRICE_PLAN_ENTITY_ID','N','MarketOffering');
dbms_output.put_line('PRICE_PLAN_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_72 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pps.*
FROM
    price_plan_specification pps,
    price_plan               pp,
    price_plan_entity        ppe
WHERE
        pps.price_plan_id = pp.price_plan_id
    AND ppe.plan_id = pp.price_plan_id
    AND ppe.entity_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100142','PRICE_PLAN_SPECIFICATION','PPS','23','8',str,'Y','PP_INSTANCE_ID','N','MarketOffering');
dbms_output.put_line('PRICE_PLAN_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_73 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    cps.*
FROM
    charge_parameter_specification cps,
    price_plan_specification       pps,
    price_plan                     pp,
    price_plan_entity              ppe
WHERE
        pps.pp_instance_id = cps.charge_item_id
    AND pps.price_plan_id = pp.price_plan_id
    AND ppe.plan_id = pp.price_plan_id
    AND ppe.entity_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100143','CHARGE_PARAMETER_SPECIFICATION','CPS','24','7',str,'Y','CHARGE_INSTANCE_ID','N','MarketOffering');
dbms_output.put_line('CHARGE_PARAMETER_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_74 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    pm.*
FROM
    product_mapping pm
WHERE
    pm.offering_process_id IN (
        ip_process_id
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100144','PRODUCT_MAPPING','PM','25','5',str,'Y','OFFERING_PROCESS_ID,SERVICE_CODE','N','MarketOffering');
dbms_output.put_line('PRODUCT_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_75 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select pcd.* from PRODUCT_CODE_DETAILS pcd,ENTITY_PRODUCT_CODE_MAPPING epcm where
pcd.PRODUCT_CODE_ID = epcm.PRODUCT_CODE_ID
and epcm.root_id = l_n_entity_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100146','PRODUCT_CODE_DETAILS','PCD','26','23',str,'Y','PRODUCT_CODE_ID','N','MarketOffering');
dbms_output.put_line('PRODUCT_CODE_DETAILS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_76 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<WITH process_ids AS (
    SELECT DISTINCT
        pe.pid
    FROM
        process_entity pe

    where pe.pid IN ( IP_VALUES )
), entity_ids AS (
    SELECT
        DISTINCT be.bid
    FROM
        business_entity          be,
        business_process_mapping bpm,
        process_ids              p
    WHERE
            bpm.entityid = be.bid
        AND bpm.parent_id = p.pid
)
SELECT
    pfas.*
FROM
    business_process_mapping    bpm,
    business_entity_parameter   bep,
    process_ids                 p,
    parameter_specification     ps,
    parameter_format_addon_spec pfas
WHERE
        pfas.param_spec_id = ps.param_basic_spec_id
    AND bpm.parent_id = p.pid
    AND bep.parent_id = bpm.record_key
    AND ps.param_basic_spec_id = bep.parameter_spec_id
UNION
SELECT
    pfas.*
FROM
    parameter_specification      ps,
    parameter_rule_specification prs,
    entity_ids                   e,
    parameter_format_addon_spec  pfas
WHERE
        pfas.param_spec_id = ps.param_basic_spec_id
    AND ps.param_basic_spec_id = prs.reference_store_id
    AND prs.expression_type = 'Parameter'
    AND prs.parent_id = e.bid
UNION
SELECT
    pfas.*
FROM
    parameter_specification     ps,
    business_parameters         bp,
    entity_ids                  e,
    parameter_format_addon_spec pfas
WHERE
        pfas.param_spec_id = ps.param_basic_spec_id
    AND bp.bid = e.bid
    AND ps.parent_id = bp.parameter_id
    AND ps.core_spec = 'Yes'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100039','PARAMETER_FORMAT_ADDON_SPEC','PFAS','41','',str,'Y','PARAM_FORMAT_ADDON_SPEC_ID','N','Process Plan');
dbms_output.put_line('PARAMETER_FORMAT_ADDON_SPEC Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_77 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select st.* from script_task st where pid in (SELECT
    pe.pid
FROM
    process_entity               pe,
    process_entity_specification pes
WHERE
        pe.root_id in (ip_process_id)
    AND pe.pid = pes.pid
    AND pes.task_type = 'Script Task')>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100041','SCRIPT_TASK','ST','','31',str,'N','SCRIPT_TASK_ID','N','Process Plan');
dbms_output.put_line('SCRIPT_TASK Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_78 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT DISTINCT pp.*
        FROM price_plan_specification pps,
          price_plan pp
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES)
          )
        AND pp.price_plan_id = pps.price_plan_id
        UNION
        SELECT pp.*
          FROM price_plan pp, 
               price_plan_entity ppe
            WHERE ppe.entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )  and ppe.plan_id = pp.price_plan_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100022','PRICE_PLAN','PP','24','19',str,'Y','PRICE_PLAN_ID','N','Process Plan');
dbms_output.put_line('PRICE_PLAN Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_79 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT DISTINCT ppe.*
        FROM price_plan_specification pps,
          price_plan_entity ppe,
          business_entity be
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )
        AND ppe.plan_id = pps.price_plan_id
        and ppe.entity_id = be.bid
        UNION
          SELECT ppe.*
        FROM 
          price_plan_entity ppe
        WHERE ppe.entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100023','PRICE_PLAN_ENTITY','PPE','25','18',str,'Y','PRICE_PLAN_ENTITY_ID','N','Process Plan');
dbms_output.put_line('PRICE_PLAN_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_80 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select ctm.* from  CUSTOM_TEMPLATE_MAPPING ctm,(
with rule_det as (SELECT DISTINCT
    r.*
FROM
    business_process_mapping       bpm,
    business_entity_parameter      bep,
    parameter_rule_specification   prs,
    rule                           r
WHERE
    bpm.parent_id IN (IP_VALUES)
    AND bep.parent_id = bpm.record_key
    AND bep.parameter_spec_id = prs.parent_id
    AND r.rule_id = prs.rule_id
UNION
SELECT
    r.*
FROM
    parameter_rule_specification   prs,
    rule                           r
WHERE
    prs.parent_id IN (IP_VALUES)
    AND r.rule_id = prs.rule_id
UNION  SELECT
    r.*
FROM
    parameter_rule_specification   prs,
    rule                           r
WHERE
    r.parent_rule_id IN (IP_VALUES)
    AND r.rule_id = prs.rule_id
UNION
SELECT DISTINCT
    r.*
FROM
    price_plan_specification         pps,
    charge_parameter_specification   cps,
    rule                             r
WHERE
    pps.service_entity_id IN (
        SELECT
            bpm.entityid
        FROM
            business_process_mapping bpm
        WHERE
            bpm.parent_id IN (IP_VALUES)
    )
    AND cps.charge_item_id = pps.pp_instance_id
    AND r.rule_id = cps.rule_id
UNION
SELECT
    r.*
FROM
    entity_group_function   egf,
    entity_join_parameter   ejp,
    rule                    r
WHERE
    egf.pid IN (IP_VALUES)
    AND egf.group_id = ejp.group_id
    AND egf.entity_function_id = ejp.entity_function_id
    AND ejp.mapping_entity_id = r.rule_id
UNION
SELECT DISTINCT
    r.*
FROM
    parameter_rule_specification   prs,
    process_action_specification   pas,
    rule                           r
WHERE
    pas.parent_id IN (IP_VALUES
    )
    AND pas.action_id = prs.parent_id
    AND r.rule_id = prs.rule_id
UNION  SELECT
    *
FROM
    rule
WHERE
    parent_rule_id IN (
        SELECT
            r.rule_id
        FROM
            parameter_rule_specification   prs,
            rule                           r
        WHERE
            r.parent_rule_id IN (IP_VALUES)
            AND r.rule_id = prs.rule_id
    )
UNION
SELECT
    r.*
FROM
    rule r
WHERE
    r.parent_rule_id IN (IP_VALUES)
UNION
SELECT
    r.*
FROM
    process_entity_specification   pes,
    parameter_rule_specification   prs,
    rule                           r
WHERE
    prs.parent_id = pes.process_spec_id
    AND pes.pid IN (IP_VALUES)
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
            AND bpm.parent_id IN (IP_VALUES)
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
            AND bpm.parent_id IN (IP_VALUES)
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
                    DENSE_RANK()  OVER( ORDER BY  ps.version DESC ) AS sk
                FROM
                    parameter_specification ps,
                    business_parameters     bp,
                    parameter               p
                WHERE
                    bp.bid IN ( SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (IP_VALUES)
    )
                    AND p.parameter_id = bp.parameter_id
                    AND ps.parent_id = p.parameter_id
                    AND ps.core_spec = 'Yes'
            ) rt
        WHERE
            sk = 1
    )  pbsi
WHERE
    r.rule_id = prs.rule_id
    AND prs.parent_id = pbsi.param_basic_spec_id
	UNION
	SELECT r.*
 FROM
    rule                           r,
    parameter_rule_specification   prs,
    (
        SELECT
            rt.*
        FROM
            (
                SELECT
                    ps.param_basic_spec_id,
                    DENSE_RANK() OVER(ORDER BY ps.version DESC) AS sk
                FROM
                    parameter_specification ps
                WHERE
                    ps.parent_id IN (SELECT DISTINCT
    p.parameter_id
FROM
    table_parameter_mapping         tpm,
    table_row_specification         trs,
    table_specification             ts,
    parameter                       p,
    parameter_specification         ps,
    parameter_addon_specification   pas
WHERE
    pas.parent_id (+) = ps.param_basic_spec_id
    AND ps.core_spec != 'Yes'
    AND ps.parent_id = p.parameter_id
    AND p.parameter_id = ps.parent_id
    AND pas.parent_id = ps.param_basic_spec_id
    AND ps.param_basic_spec_id = tpm.parameter_spec_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id IN
(SELECT
    pes.pid
FROM
    business_entity                be,
    business_process_mapping       bpm,
    process_entity_specification   pes,
    process_entity                 pe
 WHERE
    be.bid IN (SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (IP_VALUES)
                )
    AND bpm.entityid = be.bid
    AND pes.pid = bpm.parent_id
    AND pe.pid = pes.pid
    AND pe.action_type = 'Parameter Group'))
                    AND ps.core_spec != 'Yes'
            ) rt
        WHERE
            sk = 1
    ) pbsi
 WHERE
    r.rule_id = prs.rule_id
    AND prs.parent_id = pbsi.param_basic_spec_id
union
SELECT
    r.*
FROM
    (
        SELECT DISTINCT
            ebc.entity_id
        FROM
            entity_boundary_condition ebc
        WHERE
            ebc.entity_id IN (IP_VALUES)
    )    ebc,
    rule r
WHERE
    r.entity_id = ebc.entity_id)
   select r.RULE_ID,r.PARENT_RULE_ID from rule_det r union select r.RULE_ID,r.PARENT_RULE_ID from rule_det rd, rule r where r.parent_rule_id = rd.rule_id)ss
   where ss.rule_id=ctm.entity_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100042','CUSTOM_TEMPLATE_MAPPING','CTM','17','13',str,'Y','CUSTOM_TEMPL_MAP_ID','N','Process Plan');
dbms_output.put_line('CUSTOM_TEMPLATE_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_91 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT cps.*
        FROM price_plan_specification pps,
          charge_parameter_specification cps
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )
        AND cps.charge_item_id = pps.pp_instance_id
        UNION
        SELECT cps.*
        FROM charge_parameter_specification cps
        WHERE cps.rule_id IN
        ( SELECT prs.rule_id
        FROM price_plan_specification pps,
          charge_parameter_specification cps,
          parameter_rule_specification prs
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )
        AND cps.charge_item_id = pps.pp_instance_id
        AND prs.rule_id        = cps.rule_id)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100025','CHARGE_PARAMETER_SPECIFICATION','CPS','27','16',str,'Y','CHARGE_INSTANCE_ID','N','Process Plan');
dbms_output.put_line('CHARGE_PARAMETER_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_92 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    tpm.*
FROM
    table_row_specification tbrsp,
    table_parameter_mapping tpm,
    table_specification     ts
WHERE
        tbrsp.parent_id = ts.id
    AND ts.parent_id IN ( IP_VALUES )
    AND tbrsp.id = tpm.row_spec_id
    AND tpm.parameter_spec_id IS NOT NULL
    AND tpm.row_spec_id IS NOT NULL
UNION
SELECT
    tpm.*
FROM
    process_entity          pe,
    table_specification     ts,
    table_row_specification trs,
    table_parameter_mapping tpm
WHERE
        tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN ( IP_VALUES )
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100014','TABLE_PARAMETER_MAPPING','TPM','15','21',str,'Y','TABL_PARAM_MAPPING_ID','N','Process Plan');
dbms_output.put_line('TABLE_PARAMETER_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_93 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    tbrsp.*
FROM
    table_row_specification tbrsp,
    table_specification     ts
WHERE
        tbrsp.parent_id = ts.id
    AND ts.parent_id IN ( IP_VALUES )
UNION
SELECT
    trs.*
FROM
    process_entity          pe,
    table_specification     ts,
    table_row_specification trs
WHERE
        trs.parent_id = ts.id
    AND ts.parent_id = pe.pid
    AND pe.pid IN ( IP_VALUES )
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100013','TABLE_ROW_SPECIFICATION','TRS','14','22',str,'Y','ID','N','Process Plan');
dbms_output.put_line('TABLE_ROW_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_94 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    uap.*

FROM
    user_auth_process_mapping uap
WHERE
    uap.auth_process_id IN (SELECT pe.lifecycle_id FROM process_entity pe WHERE pe.pid IN (IP_VALUES))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100033','USER_AUTH_PROCESS_MAPPING','UAP','35','2',str,'Y','USR_AUTH_PROC_MAPPING_ID','N','Process Plan');
dbms_output.put_line('USER_AUTH_PROCESS_MAPPING Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_95 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT ei.* FROM error_info ei WHERE ei.error_code IN
(SELECT DISTINCT r.ERROR_CODE
        FROM business_process_mapping bpm,
          business_entity_parameter bep,
          parameter_rule_specification prs,
          rule r
        WHERE bpm.parent_id IN
          (IP_VALUES
          )
        AND bep.parent_id         = bpm.record_key
        AND bep.parameter_spec_id = prs.parent_id
        AND r.rule_id             = prs.rule_id
		union
		SELECT r.ERROR_CODE
        FROM parameter_rule_specification prs,
          rule r
        WHERE prs.parent_id IN
          (IP_VALUES
          )
        AND r.rule_id = prs.rule_id
		union
		SELECT r.ERROR_CODE
        FROM parameter_rule_specification prs,
          rule r
        WHERE r.parent_rule_id IN
          (IP_VALUES
          )
        AND r.rule_id = prs.rule_id
union
 SELECT DISTINCT r.ERROR_CODE
        FROM price_plan_specification pps,
          charge_parameter_specification cps,
          rule r
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )
        AND cps.charge_item_id = pps.pp_instance_id
        AND r.rule_id          = cps.rule_id
		union
SELECT r.ERROR_CODE
        FROM entity_group_function egf,
          entity_join_parameter ejp,
          rule r
        WHERE egf.pid IN
          (IP_VALUES
          )
        AND egf.group_id           = ejp.group_id
        AND egf.entity_function_id = ejp.entity_function_id
        AND ejp.mapping_entity_id  = r.rule_id
		union
	SELECT DISTINCT r.ERROR_CODE
        FROM parameter_rule_specification prs,
          process_action_specification pas,
          rule r
        WHERE pas.parent_id IN
          (IP_VALUES
          )
        AND PAS.ACTION_ID = prs.parent_id
        AND r.rule_id     = prs.rule_id
        union
        SELECT  ERROR_CODE  FROM
    rule
WHERE
    parent_rule_id IN (
        SELECT
            r.rule_id
        FROM
            parameter_rule_specification prs, rule  r
        WHERE
            r.parent_rule_id IN (IP_VALUES
            )
            AND r.rule_id = prs.rule_id
    ) UNION
    SELECT r.ERROR_CODE
        FROM
          rule r
        WHERE r.parent_rule_id IN
          (IP_VALUES
          )
          union
          SELECT
    r.ERROR_CODE
FROM
rule r,
    process_entity_specification   pes,
    parameter_rule_specification   prs
WHERE
    prs.rule_id = r.rule_id
    and prs.parent_id = pes.process_spec_id
    AND pes.pid IN (IP_VALUES)
    UNION
    SELECT
   to_char(p.error_id)
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
         IP_VALUES  )
    )
    AND p.rule_id = r1.rule_id
    AND r1.parent_rule_id = r.rule_id
	UNION
	SELECT to_char(prs.error_id)
 FROM
    rule                           r,
    parameter_rule_specification   prs,
    (
        SELECT
            rt.*
        FROM
            (
                SELECT
                    ps.param_basic_spec_id,
                    DENSE_RANK() OVER(ORDER BY ps.version DESC) AS sk
                FROM
                    parameter_specification ps
                WHERE
                    ps.parent_id IN (SELECT DISTINCT
    p.parameter_id
FROM
    table_parameter_mapping         tpm,
    table_row_specification         trs,
    table_specification             ts,
    parameter                       p,
    parameter_specification         ps,
    parameter_addon_specification   pas
WHERE
    pas.parent_id (+) = ps.param_basic_spec_id
    AND ps.core_spec != 'Yes'
    AND ps.parent_id = p.parameter_id
    AND p.parameter_id = ps.parent_id
    AND pas.parent_id = ps.param_basic_spec_id
    AND ps.param_basic_spec_id = tpm.parameter_spec_id
    AND tpm.row_spec_id = trs.id
    AND trs.parent_id = ts.id
    AND ts.parent_id IN
(SELECT
    pes.pid
FROM
    business_entity                be,
    business_process_mapping       bpm,
    process_entity_specification   pes,
    process_entity                 pe
 WHERE
    be.bid IN (SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (IP_VALUES
    )
                )
    AND bpm.entityid = be.bid
    AND pes.pid = bpm.parent_id
    AND pe.pid = pes.pid
    AND pe.action_type = 'Parameter Group'))
                    AND ps.core_spec != 'Yes'
            ) rt
        WHERE
            sk = 1
    ) pbsi
 WHERE
    r.rule_id = prs.rule_id
    AND prs.parent_id = pbsi.param_basic_spec_id)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100037','ERROR_INFO','EI','39','',str,'Y','ERROR_ID','N','Process Plan');
dbms_output.put_line('ERROR_INFO Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_96 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    tbsp.*
FROM
    table_specification tbsp
WHERE
    tbsp.parent_id IN (
        IP_VALUES
    )
UNION
SELECT
    ts.*
FROM
    process_entity      pe,
    table_specification ts
WHERE
        ts.parent_id = pe.pid
    AND pe.pid IN (
        IP_VALUES
    )
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100012','TABLE_SPECIFICATION','TS','13','25',str,'Y','ID','N','Process Plan');
dbms_output.put_line('TABLE_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_97 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    et.*
FROM
    email_template et,
    (
        SELECT
            pas.*
        FROM
            process_action_specification pas
        WHERE
            pas.parent_id IN (IP_VALUES
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
                    business_process_mapping    bpm,
                    business_entity_parameter   bep
                WHERE
                    bpm.parent_id IN (IP_VALUES
                    )
                    AND bep.parent_id = bpm.record_key
            )
    ) pes1
WHERE
    et.template_id = pes1.action_process_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100036','EMAIL_TEMPLATE','ET','38','',str,'Y','EMAIL_TEMP_ID','N','Process Plan');
dbms_output.put_line('EMAIL_TEMPLATE Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_98 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select * from (WITH egf_ety_id AS (
    SELECT
        egf.*
    FROM
        entity_group_function egf,
        (
            SELECT
                ber.parent_id,
                ber.child_id
            FROM
                business_process_mapping bpm,
                business_entity          be,
                business_entity_relation ber
            WHERE
                bpm.parent_id IN ( IP_VALUES )
                AND be.bid = bpm.entityid
                AND ber.parent_id = bpm.entityid
        )                     br
    WHERE
            egf.pid = br.parent_id
        AND egf.status = 'Active'
        AND egf.version IN (
            SELECT
                MAX(ef.version)
            FROM
                entity_group_function ef
            WHERE
                egf.lifecycle_id = ef.lifecycle_id
        )
    UNION
    SELECT
        egf.*
    FROM
        entity_group_function egf,
        (
            SELECT
                ber.parent_id,
                ber.child_id
            FROM
                business_process_mapping bpm,
                business_entity          be,
                business_entity_relation ber
            WHERE
                bpm.parent_id IN ( IP_VALUES )
                AND be.bid = bpm.entityid
                AND ber.parent_id = bpm.entityid
        )                     br
    WHERE
            egf.pid = br.child_id
        AND egf.status = 'Active'
        AND egf.version IN (
            SELECT
                MAX(ef.version)
            FROM
                entity_group_function ef
            WHERE
                egf.lifecycle_id = ef.lifecycle_id
        )
    UNION
    SELECT
        egf.*
    FROM
        entity_group_function egf,
        (
            SELECT
                ber.parent_id,
                ber.child_id
            FROM
                business_process_mapping bpm,
                business_entity          be,
                business_entity_relation ber
            WHERE
                bpm.parent_id IN ( IP_VALUES )
                AND be.bid = bpm.entityid
                AND ber.parent_id = bpm.entityid
        )                     br
    WHERE
            egf.join_pid = br.parent_id
        AND egf.status = 'Active'
        AND egf.version IN (
            SELECT
                MAX(ef.version)
            FROM
                entity_group_function ef
            WHERE
                egf.lifecycle_id = ef.lifecycle_id
        )
    UNION
    SELECT
        egf.*
    FROM
        entity_group_function egf,
        (
            SELECT
                ber.parent_id,
                ber.child_id
            FROM
                business_process_mapping bpm,
                business_entity          be,
                business_entity_relation ber
            WHERE
                bpm.parent_id IN ( IP_VALUES )
                AND be.bid = bpm.entityid
                AND ber.parent_id = bpm.entityid
        )                     br
    WHERE
            egf.join_pid = br.child_id
        AND egf.status = 'Active'
        AND egf.version IN (
            SELECT
                MAX(ef.version)
            FROM
                entity_group_function ef
            WHERE
                egf.lifecycle_id = ef.lifecycle_id
        )
)
SELECT
    *
FROM
    egf_ety_id e
UNION
SELECT
    egf.*
FROM
    entity_group_function egf,
    egf_ety_id            ef
WHERE
    ef.entity_function_id = egf.related_function_id
UNION
SELECT
    egf.*
FROM
    entity_group_function egf
WHERE
    egf.pid IN ( IP_VALUES )
    AND egf.version = (
        SELECT
            MAX(ef.version)
        FROM
            entity_group_function ef
        WHERE
            egf.lifecycle_id = ef.lifecycle_id
    )
UNION
SELECT
    egf.*
FROM
    entity_group_function egf
WHERE 
    egf.join_pid IN ( IP_VALUES )
    AND egf.version = (
        SELECT
            MAX(ef.version)
        FROM
            entity_group_function ef
        WHERE
            egf.lifecycle_id = ef.lifecycle_id
    )
UNION
SELECT
    egf.*
FROM
    entity_group_function egf
WHERE
    egf.pid IN (
        SELECT
            param_data_spec_id
        FROM
            parameter_data_specification
        WHERE
            parent_id IN ( IP_VALUES )
    )
    AND egf.version = (
        SELECT
            MAX(ef.version)
        FROM
            entity_group_function ef
        WHERE
            egf.lifecycle_id = ef.lifecycle_id
    ))>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100018','ENTITY_GROUP_FUNCTION','EGF','20','24',str,'Y','ENTITY_GROUP_FUNC_ID','N','Process Plan');
dbms_output.put_line('ENTITY_GROUP_FUNCTION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_99 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
            ejp.*
        FROM
            entity_join_parameter ejp,
            (
                SELECT
                    egf.group_id
                FROM
                    entity_group_function egf
                WHERE
                    egf.pid IN (
                        IP_VALUES
                    )
                UNION 
                   SELECT
                    egf.group_id
                FROM
                    entity_group_function egf
                WHERE
                    egf.join_pid IN (
                        IP_VALUES
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
                               IP_VALUES
                            )
                    )
            )                     egf
        WHERE
                ejp.group_id = egf.group_id
            AND ejp.version_no = (
                SELECT
                    MAX(ej.version_no)
                FROM
                    entity_join_parameter ej
                WHERE
                    ej.lifecycle_id = ejp.lifecycle_id
            )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100019','ENTITY_JOIN_PARAMETER','EJP','21','23',str,'Y','ENTITY_JOIN_PARAM_ID','N','Process Plan');
dbms_output.put_line('ENTITY_JOIN_PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_100 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT hm.*
        FROM HIERARCHY_METADATA hm
        WHERE HIERARCHY_ENTITY_ID IN
          (SELECT ber.CHILD_ID
          FROM business_process_mapping bpm,
            business_entity be,
            business_entity_relation ber
          WHERE bpm.parent_id IN
            (IP_VALUES)
          AND be.bid        = bpm.entityid
          AND ber.parent_id = bpm.entityid
          )
        ORDER BY HIERARCHY_LEVEL>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100031','HIERARCHY_METADATA','HM','33','4',str,'Y','HIERARCHY_METADATA_ID','N','Process Plan');
dbms_output.put_line('HIERARCHY_METADATA Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_101 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT pds.*
        FROM
          (SELECT pds.*
          FROM parameter_data_specification pds
          WHERE pds.parent_id IN
            (IP_VALUES
            )
          ) pds
        UNION
        SELECT pds.*
        FROM
          (SELECT pds.*
          FROM parameter_data_specification pds
          WHERE pds.parent_id IN
            (SELECT bep.parameter_spec_id
            FROM business_process_mapping bpm,
              business_entity_parameter bep
            WHERE bpm.parent_id IN
              (IP_VALUES
              )
            AND bep.parent_id = bpm.record_key
            )
          ) pds>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100010','PARAMETER_DATA_SPECIFICATION','PDS','11','26',str,'Y','PARAM_DATA_SPEC_ID','N','Process Plan');
dbms_output.put_line('PARAMETER_DATA_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_102 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<select pfs.* from (select pas.parent_id FROM parameter_addon_specification pas
      WHERE pas.parent_id IN
        (SELECT bep.parameter_spec_id
        FROM business_process_mapping bpm,
          business_entity_parameter bep
        WHERE bpm.parent_id IN
          (IP_VALUES
          )
        AND bep.parent_id = bpm.record_key)) pas1,PARAMETER_FUNC_SPECIFICATION pfs where pfs.param_spec_id = pas1.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100038','PARAMETER_FUNC_SPECIFICATION','PFS','40','1',str,'Y','PARAM_FUNC_SPEC_ID','N','Process Plan');
dbms_output.put_line('PARAMETER_FUNC_SPECIFICATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_103 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
    oac.*
FROM
    oauth_client_details      oac,
    user_auth_process_mapping uap
WHERE
        oac.client_id = uap.user_id
    AND uap.auth_process_id IN (SELECT pe.lifecycle_id FROM process_entity pe WHERE pe.pid IN (IP_VALUES)
    )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100034','OAUTH_CLIENT_DETAILS','OAC','36','',str,'Y','CLIENT_ID','N','Process Plan');
dbms_output.put_line('OAUTH_CLIENT_DETAILS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_104 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<(
SELECT obj.*
        FROM
          (SELECT pid,
            type
          FROM process_entity WHERE pid in (IP_VALUES)
          ) pe,
          object_change_details obj
        WHERE obj.entity_id = pe.pid and pe.type IN ('Process Plan','Page','Interface','Market Offering')
)
UNION
(
SELECT obj.*
        FROM
          (SELECT parent_id,
            entity_type
          FROM Business_process_mapping WHERE parent_id in (IP_VALUES)
          ) pe,
          object_change_details obj
        WHERE obj.entity_id = pe.parent_id and pe.entity_type IN ('Market Offering')
)>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100032','OBJECT_CHANGE_DETAILS','OCD','34','3',str,'Y','SCRIPT_ID','N','Process Plan');
dbms_output.put_line('OBJECT_CHANGE_DETAILS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_105 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT aip.*
        FROM
          (SELECT pas.*
          FROM process_action_specification pas
          WHERE pas.parent_id IN
            (IP_VALUES)
          UNION
          SELECT pas.*
          FROM process_action_specification pas
          WHERE pas.parent_id IN
            (SELECT bep.parameter_spec_id
            FROM business_process_mapping bpm,
              business_entity_parameter bep
            WHERE bpm.parent_id IN
              (IP_VALUES)
            AND bep.parent_id = bpm.record_key
            )
          )pas,
          action_input_parameter aip
        WHERE pas.action_id = aip.action_spec_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100030','ACTION_INPUT_PARAMETER','AIP','32','5',str,'Y','ACTION_INPUT_PARAM_ID','N','Process Plan');
dbms_output.put_line('ACTION_INPUT_PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_106 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT be.*
        FROM
          (SELECT be.*
          FROM business_process_mapping bpm,
            business_entity be
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          AND be.bid = bpm.entityid
          UNION
          SELECT be.*
          FROM business_process_mapping bpm,
            business_entity be,
            business_entity_relation ber
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          AND be.bid        = ber.CHILD_ID
          AND ber.parent_id = bpm.entityid
          ) be
        UNION
        SELECT be.*
        FROM business_entity be
        WHERE be.business_entity_name IN
          (SELECT data_store_name
          FROM parameter_data_specification
          WHERE parent_id IN
            (IP_VALUES 
            ))
        union
        select be.* from business_entity be where  bid in       
          (SELECT DISTINCT ppe.entity_id
        FROM price_plan_specification pps,
          price_plan_entity ppe
        WHERE pps.service_entity_id IN
          (SELECT bpm.entityid
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          )
        AND ppe.plan_id = pps.price_plan_id	)
    UNION
    SELECT 
    be.*
FROM 
    business_entity                be, 
    business_process_mapping       bpm, 
    process_entity_specification   pes, 
    process_entity                 pe 
 WHERE 
    be.bid IN (SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (
                IP_VALUES
            )
    )
    AND bpm.entityid = be.bid 
    AND pes.pid = bpm.parent_id 
    AND pe.pid = pes.pid 
    AND pe.action_type = 'Parameter Group'>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100001','BUSINESS_ENTITY','BE','1','39',str,'Y','BID','Y','Process Plan');
dbms_output.put_line('BUSINESS_ENTITY Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_107 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT bep.*
        FROM business_process_mapping bpm,
          business_entity_parameter bep
        WHERE bpm.parent_id IN
          (IP_VALUES
          )
        AND bep.parent_id = bpm.record_key>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100011','BUSINESS_ENTITY_PARAMETER','BEP','12','34',str,'Y','RECORD_KEY_PARAM','N','Process Plan');
dbms_output.put_line('BUSINESS_ENTITY_PARAMETER Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_108 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT DISTINCT ber.*
        FROM business_process_mapping bpm,
          business_entity be,
          business_entity_relation ber
        WHERE bpm.parent_id IN
          (IP_VALUES)
        AND be.bid        = bpm.entityid
        AND ber.parent_id = bpm.entityid>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100002','BUSINESS_ENTITY_RELATION','BER','2','33',str,'Y','BUSINESS_ENTITY_REL_ID','N','Process Plan');
dbms_output.put_line('BUSINESS_ENTITY_RELATION Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_109 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT
   bp.*
FROM
    business_process_mapping    bpm,
    business_parameters         bp
WHERE
    bpm.parent_id IN (IP_VALUES
    )

    AND bp.bid = bpm.entityid

UNION
SELECT
    bp.*
FROM
    business_entity       be,
    business_parameters   bp
WHERE
    be.business_entity_name IN (
        SELECT
            data_store_name
        FROM
            parameter_data_specification
        WHERE
            parent_id IN (IP_VALUES
            )
    )
    AND bp.bid = be.bid
	UNION
	SELECT
            bp.*
        FROM
            business_parameters           bp,
            parameter_addon_specification pas
        WHERE
            bp.bid IN (
                SELECT
                    be.bid
                FROM
                    business_entity          be, business_process_mapping bpm
                WHERE
                        bpm.entityid = be.bid
                    AND bpm.parent_id IN (IP_VALUES
                    )
            )
            AND pas.parent_id = bp.parameter_id
            AND pas.name IN ( 'serviceType', 'maxQuantity', 'eligibleForDowngrade', 'eligibleForUpgrade', 'minQuantity' )>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100029','BUSINESS_PARAMETERS','BP','31','6',str,'Y','BUSINESS_PARAM_ID','N','Process Plan');
dbms_output.put_line('BUSINESS_PARAMETERS Inserted');
commit;
end;


--changeset Vijaysree.S:BACATALOG_DDL_09_110 splitStatements:false
--preconditions onFail:HALT onError:HALT

DECLARE
  str varchar2(32767);
BEGIN
  str := q'<SELECT bpm.*
        FROM business_entity tbe,
          (SELECT bpm.*
          FROM business_process_mapping bpm
          WHERE bpm.parent_id IN
            (IP_VALUES
            )
          ) bpm
        WHERE bpm.entityid = tbe.bid
    UNION
    SELECT
    bpm.*
FROM
    business_entity                be,
    business_process_mapping       bpm,
    process_entity_specification   pes,
    process_entity                 pe
 WHERE
    be.bid IN (SELECT
            be.bid
        FROM
            business_entity          be, business_process_mapping bpm
        WHERE
                bpm.entityid = be.bid
            AND bpm.parent_id IN (
                IP_VALUES
            )
    )
    AND bpm.entityid = be.bid
    AND pes.pid = bpm.parent_id
    AND pe.pid = pes.pid
    AND pe.action_type = 'Parameter Group'
UNION    
SELECT bpm1.*
        FROM business_process_mapping bpm,
        business_process_mapping bpm1,
          business_entity be,
          business_entity_relation ber
        WHERE bpm.parent_id IN
          (IP_VALUES
          )
        AND be.bid        = bpm.entityid
        AND ber.parent_id = bpm.entityid
        AND bpm1.entityid = ber.parent_id>';
Insert into METADATA_EXPORT_TABLE_CONFIG (METADATA_TABLE_ID,METADATA_TABLE_NAME,METADATA_TABLE_ALIAS_NAME,METADATA_TABLE_SEQ,METADATA_TABLE_DELETE_SEQ,METADATA_FETCH_QUERY,IS_ACTIVE, METADATA_NOTEXIST_COND_COL,METADATA_IS_UPDATE,METADATA_ENTITY_TYPE) values ('100006','BUSINESS_PROCESS_MAPPING','BPM','7','38',str,'Y','RECORD_KEY','N','Process Plan');
dbms_output.put_line('BUSINESS_PROCESS_MAPPING Inserted');
commit;
end;



