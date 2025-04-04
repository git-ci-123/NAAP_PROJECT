--liquibase formatted sql
--changeset Vijaysree.S:APPCATALOG_DML_14 splitStatements:true
--preconditions onFail:HALT onError:HALT

Insert into REF_ENTITY_TYPE (ENTITY_ID,ENTITY_TYPE) values (1,'Template Mapping');
Insert into REF_ENTITY_TYPE (ENTITY_ID,ENTITY_TYPE) values (2,'Rule');
Insert into REF_ENTITY_TYPE (ENTITY_ID,ENTITY_TYPE) values (3,'Api Specification');
Insert into ref_entity_type (ENTITY_ID,ENTITY_TYPE) values (4,'Process Plan');
Insert into ref_entity_type (ENTITY_ID,ENTITY_TYPE) values (5,'Inbound API');
Insert into ref_entity_type (ENTITY_ID,ENTITY_TYPE) values (6,'Outbound API');


Insert into REF_LINEOFBUSINESS (LOB_ID,LINEOFBUSINESS) values (1,'Enterprise');
Insert into REF_LINEOFBUSINESS (LOB_ID,LINEOFBUSINESS) values (2,'Small and Medium Size Business');
Insert into REF_LINEOFBUSINESS (LOB_ID,LINEOFBUSINESS) values (3,'Government Agencies');
Insert into REF_LINEOFBUSINESS (LOB_ID,LINEOFBUSINESS) values (4,'Wholesale');
Insert into REF_LINEOFBUSINESS (LOB_ID,LINEOFBUSINESS) values (5,'Retail');


COMMIT;

