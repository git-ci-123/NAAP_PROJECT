--liquibase formatted sql
--changeset Swetha.H:APPCATALOG_DML_17 splitStatements:true
--preconditions onFail:HALT onError:HALT
  
--deleting all category reference values 
  delete from reference_type_values where ref_type_id = '80021358890944';

--default market offering /form business entity status moved to 'InActive'
  update life_cycle_activity_metadata set LCA_STATUS  = 'InActive'  where entity_id in (125457804,125457805,1205467375,1205467376,22605461042);
 
--default form status moved to  Inactive 
 update life_cycle_activity_metadata set LCA_STATUS  = 'InActive'  where entity_id in (50000126086,
1607042869,
1607042863,
1207042588,
1207042579,
1607042862,
1207042587,
1207042582,
117022591);


-- delete all release tag under release_number reference in release management tab
delete from reference_type_values where ref_type_id = 80021358892011;

--delete SMB  from service group in service configuration page
delete from reference_type_values where ref_val_id= 180048393288168;

--queuetenantid all reference delete from service configuration page
delete from reference_type_values where ref_type_id =180021358893605;

--deleting entitytype reference values in business_entity module

delete from reference_type_values where ref_type_id =80021358891997;

 
commit;