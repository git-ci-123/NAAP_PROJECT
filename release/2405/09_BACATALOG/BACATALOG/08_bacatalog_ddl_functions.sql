--liquibase formatted sql
--changeset Vijaysree.S:BACATALOG_DML_08 splitStatements:false
--preconditions onFail:HALT onError:HALT

create or replace FUNCTION func_get_entity_param_value (
    ip_entity_id  NUMBER,
    ip_param_name VARCHAR2,
    is_date       VARCHAR2 DEFAULT 'N'
) RETURN VARCHAR2

AS
pragma udf;

    l_vc_values     VARCHAR2(2500);
    ip_primary_key  VARCHAR2(100);
    l_vc_sql_string VARCHAR2(1000);
    ip_entity_type  VARCHAR2(100);
BEGIN
    SELECT
        be.data_source_name,
        be.data_source_column
    INTO
        ip_entity_type,
        ip_primary_key
    FROM
        business_entity         be,
        product_entity_instance pei
    WHERE
            pei.instance_id = ip_entity_id
        AND be.bid = pei.business_meta_data_id;

    IF ip_primary_key IS NULL THEN
        SELECT
            val
        INTO l_vc_values
        FROM
            (
                SELECT
                    val,
                    ROWNUM rn
                FROM
                    (
                        SELECT
                            egpv.value AS val
                        FROM
                            entity_group_parameter_values egpv,
                            parameter_specification       ps
                        WHERE
                                ps.param_name = ip_param_name
                            AND egpv.param_spec_id = ps.param_basic_spec_id
                            AND egpv.entity_id = ip_entity_id
                        ORDER BY
                            param_instance_id DESC
                    )
            )
        WHERE
            rn = 1;

    ELSE
        l_vc_sql_string := 'select '
                           ||
            CASE
                WHEN is_date = 'Y' THEN
                    'to_char('
                    || replace(ip_param_name, ' ', '_')
                    || ',''MM-dd-YYYY'') as '
                    || replace(ip_param_name, ' ', '_')
                ELSE replace(ip_param_name, ' ', '_')
            END
                           || ' from '
                           || ip_entity_type
                           || ' where '
                           || ip_primary_key
                           || ' = '
                           || ip_entity_id;

        dbms_output.put_line('sql string--> ' || l_vc_sql_string);
        EXECUTE IMMEDIATE l_vc_sql_string
        INTO l_vc_values;
    END IF;

    RETURN l_vc_values;
EXCEPTION
    WHEN OTHERS THEN
        l_vc_values := NULL;
        RETURN l_vc_values;
END func_get_entity_param_value;
