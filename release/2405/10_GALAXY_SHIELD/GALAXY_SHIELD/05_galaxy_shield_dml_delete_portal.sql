--liquibase formatted sql
--changeset Vijaysree.S:GALAXY_SHIELD_DDL_05_1 splitStatements:true
--preconditions onFail:HALT onError:HALT

delete from portal where portal_name in ('C360','PM','FRAMEWORK');

commit;