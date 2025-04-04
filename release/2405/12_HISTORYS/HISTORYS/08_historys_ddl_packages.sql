--liquibase formatted sql
--changeset Swetha.H:HISTORYS_DDL_08_1 splitStatements:false
--preconditions onFail:HALT onError:HALT 


create or replace PACKAGE PKG_INSTANCE_ARCHIVAL
 AS

  /* TODO enter package declarations (types, exceptions, methods etc) here */
    PROCEDURE process_stg_data_load (
        op_msg OUT VARCHAR2
    );

    PROCEDURE process_instance_archival (
        op_msg OUT VARCHAR2
    );

END pkg_instance_archival;

--changeset Swetha.H:HISTORYS_DDL_08_2 splitStatements:false
--preconditions onFail:HALT onError:HALT 

CREATE OR REPLACE PACKAGE BODY pkg_instance_archival AS

    PROCEDURE process_stg_data_load (
        op_msg OUT VARCHAR2
    ) AS
        l_vc_enable_flag VARCHAR2(10);
        l_n_archive_days NUMBER;
    BEGIN
-- TODO: Implementation required for PROCEDURE PKG_INSTANCE_ARCHIVAL.PROCESS_INSTANCE_ARCHIVAL
        /* Checking for enable flag for G7 Table to process archival logic. If this flag is set as 'N' then Archival logic will not be process for
        PROCESS_ENTITY_INSTANCE & PROCESS_ENTITY_RELATION  table.

        Based on Archival_days mentioned in ref_archive_days for only those records will be archived.
        */
        SELECT
            enable_flag,
            archive_days
        INTO
            l_vc_enable_flag,
            l_n_archive_days
        FROM
            ref_archive_days
        WHERE
                table_name = 'ARCH_PROCESS_ENTITY_INSTANCE'
            AND schema_name = 'BACATALOG';

        IF l_vc_enable_flag = 'Y' OR l_vc_enable_flag = 'y' THEN
 /* Truncating staging table below loading latest data*/
            EXECUTE IMMEDIATE 'TRUNCATE table STG_TEMP_INSTANCE_ARCHIVAL';

  /*Loading completed instance_id into staging instance table for G7 archival process*/
            INSERT INTO stg_temp_instance_archival
                SELECT DISTINCT
                    pei.instance_id
                FROM
                    process_entity_instance peiroot,
                    process_entity_instance pei
                WHERE
                        pei.parent_root_id = peiroot.instance_id
                    AND peiroot.type = 'Process Plan'
                    AND peiroot.status = 'Completed'
                    AND peiroot.root_id = 0
                    AND trunc(peiroot.created_date) < trunc(sysdate) - l_n_archive_days;

            COMMIT;
        END IF;

        op_msg := 'SUCCESS';
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            op_msg := 'FAILURE';
    END process_stg_data_load;

    PROCEDURE process_instance_archival (
        op_msg OUT VARCHAR2
    ) AS

        l_vc_enable_flag VARCHAR2(10);
        l_n_archive_days NUMBER;
        CURSOR cur_stg_ins_arch IS
        SELECT
            instance_id
        FROM
            stg_temp_instance_archival;

        TYPE typ_stg_ins_arch IS
            TABLE OF cur_stg_ins_arch%rowtype;
        t_stg_ins_arch   typ_stg_ins_arch;
    BEGIN
    -- TODO: Implementation required for PROCEDURE PKG_INSTANCE_ARCHIVAL.PROCESS_INSTANCE_ARCHIVAL
        /* Checking for enable flag for G7 Table to process archival logic. If this flag is set as 'N' then Archival logic will not be process for
        PROCESS_ENTITY_INSTANCE & PROCESS_ENTITY_RELATION  table.

        Based on Archival_days mentioned in ref_archive_days for only those records will be archived.
        */
        SELECT
            enable_flag,
            archive_days
        INTO
            l_vc_enable_flag,
            l_n_archive_days
        FROM
            ref_archive_days
        WHERE
                table_name = 'ARCH_PROCESS_ENTITY_INSTANCE'
            AND schema_name = 'BACATALOG';

        IF l_vc_enable_flag = 'Y' OR l_vc_enable_flag = 'y' THEN

       /*Moving process_entity_instance data to ARCH_process_entity_instance table */
            INSERT INTO arch_process_entity_instance (
                instance_id,
                version,
                parent_instance_id,
                meta_data_id,
                lifecycle_id,
                meta_data_lifecycleid,
                metadata_version,
                created_date,
                created_by,
                root_id,
                status,
                type,
                parent_root_id
            )
                SELECT
                    pei.instance_id,
                    pei.version,
                    pei.parent_instance_id,
                    pei.meta_data_id,
                    pei.lifecycle_id,
                    pei.meta_data_lifecycleid,
                    pei.metadata_version,
                    pei.created_date,
                    pei.created_by,
                    pei.root_id,
                    pei.status,
                    pei.type,
                    pei.parent_root_id
                FROM
                    process_entity_instance    pei,
                    stg_temp_instance_archival stia
                WHERE
                    pei.instance_id = stia.instance_id;

            COMMIT;
            INSERT INTO arch_process_entity_relation (
                parent_instance_id,
                child_instance_id,
                entity_type,
                version,
                status,
                meta_data_lifecycleid,
                metadata_version,
                created_date,
                created_by
            )
                SELECT
                    per.parent_instance_id,
                    per.child_instance_id,
                    per.entity_type,
                    per.version,
                    per.status,
                    per.meta_data_lifecycleid,
                    per.metadata_version,
                    per.created_date,
                    per.created_by
                FROM
                    process_entity_relation    per,
                    stg_temp_instance_archival stia
                WHERE
                    per.child_instance_id = stia.instance_id;

            COMMIT;
			/*Moving master_object_details data to arch_master_object_details table */
			INSERT INTO arch_master_object_details (
                TRANSACTION_ID,
                MODIFIED_DATE, 
                MASTER_OBJECT, 
                MASTER_ID,     
                ENTITY_ID,     
                CREATED_DATE,  
                PARENT_ROOT_ID
				)
                SELECT
                    md.TRANSACTION_ID,
                    md.MODIFIED_DATE, 
                    md.MASTER_OBJECT, 
                    md.MASTER_ID,     
                    md.ENTITY_ID,     
                    md.CREATED_DATE,  
                    md.PARENT_ROOT_ID    
                FROM
                    master_object_details    md,
                    stg_temp_instance_archival stia
                WHERE
                    md.parent_root_id = stia.instance_id;
			COMMIT;
        /*Deleting data from main tables*/
		
			 BEGIN
                OPEN cur_stg_ins_arch;
                LOOP
                    FETCH cur_stg_ins_arch
                    BULK COLLECT INTO t_stg_ins_arch LIMIT 100000;
                    EXIT WHEN t_stg_ins_arch.count = 0;
                    FORALL i IN 1..t_stg_ins_arch.count
                        DELETE FROM master_object_details
                        WHERE
                            parent_root_id = t_stg_ins_arch(i).instance_id;

                    COMMIT;
                END LOOP;

                CLOSE cur_stg_ins_arch;
            END;
			
			
            BEGIN
                OPEN cur_stg_ins_arch;
                LOOP
                    FETCH cur_stg_ins_arch
                    BULK COLLECT INTO t_stg_ins_arch LIMIT 100000;
                    EXIT WHEN t_stg_ins_arch.count = 0;
                    FORALL i IN 1..t_stg_ins_arch.count
                        DELETE FROM process_entity_relation
                        WHERE
                            child_instance_id = t_stg_ins_arch(i).instance_id;

                    COMMIT;
                END LOOP;

                CLOSE cur_stg_ins_arch;
            END;

            BEGIN
                OPEN cur_stg_ins_arch;
                LOOP
                    FETCH cur_stg_ins_arch
                    BULK COLLECT INTO t_stg_ins_arch LIMIT 100000;
                    EXIT WHEN t_stg_ins_arch.count = 0;
                    FORALL i IN 1..t_stg_ins_arch.count
                        DELETE FROM process_entity_instance
                        WHERE
                            instance_id = t_stg_ins_arch(i).instance_id;

                    COMMIT;
                END LOOP;

                CLOSE cur_stg_ins_arch;
            END;
			
			

            DELETE FROM arch_process_entity_instance
            WHERE
                trunc(created_date) < trunc(sysdate) - l_n_archive_days * 2;

            COMMIT;
            DELETE FROM arch_process_entity_relation
            WHERE
                trunc(created_date) < trunc(sysdate) - l_n_archive_days * 2;

            COMMIT;
			DELETE FROM arch_master_object_details
            WHERE
                trunc(created_date) < trunc(sysdate) - l_n_archive_days * 2;

            COMMIT;
            op_msg := 'SUCCESS';
        ELSE
            op_msg := 'Archival Flag is not set as ''Y'' for G7 Tables(PROCESS_ENTITY_INSTANCE)';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            op_msg := 'FAILURE';
    END process_instance_archival;

END pkg_instance_archival;