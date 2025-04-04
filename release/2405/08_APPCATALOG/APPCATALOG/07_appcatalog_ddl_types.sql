--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DDL_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE TYPE TYP_PP_SPEC AS OBJECT (
    pp_instance_id   NUMBER,
    price_plan_id    NUMBER
);

--changeset Vijaysree.S:APPCATALOG_DDL_07_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE TYPE LST_PROCESS_IDS AS
    TABLE OF NUMBER;


--changeset Vijaysree.S:APPCATALOG_DDL_07_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE TYPE TYP_RULE_SPEC AS OBJECT (
    param_rule_spec_id   NUMBER,
    rule_id              NUMBER
);

--changeset Vijaysree.S:APPCATALOG_DDL_07_04 splitStatements:false
--preconditions onFail:HALT onError:HALT


CREATE OR REPLACE EDITIONABLE TYPE LST_PP_SPEC AS
    TABLE OF typ_pp_spec;



--changeset Vijaysree.S:APPCATALOG_DDL_07_05 splitStatements:false
--preconditions onFail:HALT onError:HALT


CREATE OR REPLACE EDITIONABLE TYPE LST_RULE_SPEC AS
    TABLE OF typ_rule_spec;


--changeset Vijaysree.S:APPCATALOG_DDL_07_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE TYPE LST_PROCESS AS TABLE OF VARCHAR2(2000);


--changeset Vijaysree.S:APPCATALOG_DDL_07_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE TYPE LST_EGF_GROUP_IDS AS
    TABLE OF VARCHAR2(4000);


