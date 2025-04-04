--liquibase formatted sql
--changeset Swetha.H:HISTORYS_DDL_07_1 splitStatements:true
--preconditions onFail:HALT onError:HALT


INSERT INTO ref_archive_days (
    schema_name,
    table_name,
    archive_days,
    enable_flag,
    archival_by_date,
    purge_limit,
    purge_pg_by_date
) VALUES (
    'BACATALOG',
    'ARCH_PROCESS_ENTITY_INSTANCE',
    7,
    'Y',
    'N',
    0,
    'N'
);

commit;

