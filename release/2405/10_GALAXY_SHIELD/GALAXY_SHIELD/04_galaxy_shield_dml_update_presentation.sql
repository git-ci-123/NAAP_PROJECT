--liquibase formatted sql
--changeset Vijaysree.S:GALAXY_SHIELD_DDL_04 splitStatements:true
--preconditions onFail:HALT onError:HALT


update presentation set prsnttn_order=3 where prsnttn_label='PRODUCT MAPPING SUBMENU';
 
update presentation set prsnttn_order=4 where prsnttn_label='PRODUCT SPECIFICATION';
 
update presentation set prsnttn_order=5 where prsnttn_label='PARAMETER SUBMENU';


Insert into PRESENTATION (PRSNTTN_ID,FRAME_ID,URL,ONCLICK,PRSNTTN_LABEL,PRSNTTN_LABEL2,PRSNTTN_LABEL_TAG,PRSNTTN_LABEL_POS,PRSNTTN_RESTRICT,PRSNTTN_CHK_BX_GRP,PRSNTTN_POS,PRSNTTN_COL_HEADING,CREATED_DT,MODIFY_DT,CREATED_BY,MODIFY_BY,PRSNTTN_COPERMISSIONID,PRSNTTN_DENYUSERCLASS,PRSNTTN_COMPANY_TYPE,PRSNTTTN_ALLOW_USERCLASS,PRSNTTN_GROUP_ID,INDICATOR,FLAG,DEFAULTLAYOUT,EXT_MENU_ID,EXT_SYSTEM,PRSNTTN_ORDER) values (PRESENTATION_ID_SEQ.nextval,null,null,null,'STANDARD OFFERING SUBMENU','STANDARD OFFERING SUBMENU',null,null,null,null,null,null,systimestamp,null,'1003',null,null,null,null,null,(select PRSNTTN_ID from presentation where PRSNTTN_LABEL='MARKETOFFERING'),'N','Y','N',null,null,2);
Insert into PRESENTATION (PRSNTTN_ID,FRAME_ID,URL,ONCLICK,PRSNTTN_LABEL,PRSNTTN_LABEL2,PRSNTTN_LABEL_TAG,PRSNTTN_LABEL_POS,PRSNTTN_RESTRICT,PRSNTTN_CHK_BX_GRP,PRSNTTN_POS,PRSNTTN_COL_HEADING,CREATED_DT,MODIFY_DT,CREATED_BY,MODIFY_BY,PRSNTTN_COPERMISSIONID,PRSNTTN_DENYUSERCLASS,PRSNTTN_COMPANY_TYPE,PRSNTTTN_ALLOW_USERCLASS,PRSNTTN_GROUP_ID,INDICATOR,FLAG,DEFAULTLAYOUT,EXT_MENU_ID,EXT_SYSTEM,PRSNTTN_ORDER) values (PRESENTATION_ID_SEQ.nextval,null,null,null,'STANDARD OFFERING CHILD SUBMENU','STANDARD OFFERING CHILD SUBMENU',null,null,null,null,null,null,systimestamp,null,'1003',null,null,null,null,null,(select PRSNTTN_ID from presentation where PRSNTTN_LABEL='STANDARD OFFERING SUBMENU'),'N','Y','N',null,null,1);


Insert into RESOURC (RSRC_ID,RSRC_NAME,RSRC_DESC,PRSNTTN_ID,CREATED_DT,MODIFY_DT,CREATED_BY,MODIFY_BY,PROD_MENU_CATEGORY,RSRC_GROUPTYPE,RSRC_TYP_CD,CMPNY_CD,RESOURC_ID,PARENT_MENU_ID,CHILD_MENU_ID) values ('CATALOG_MarketOffering_Submenu_StandardOfferingSubmenu','CATALOG_MarketOffering_Submenu_StandardOfferingSubmenu',null,(select PRSNTTN_ID from presentation where PRSNTTN_LABEL='STANDARD OFFERING SUBMENU'),systimestamp,null,'1003',null,'None','presentationgroup',7,null,RESOURC_ID.NEXTVAL,null,null);
Insert into RESOURC (RSRC_ID,RSRC_NAME,RSRC_DESC,PRSNTTN_ID,CREATED_DT,MODIFY_DT,CREATED_BY,MODIFY_BY,PROD_MENU_CATEGORY,RSRC_GROUPTYPE,RSRC_TYP_CD,CMPNY_CD,RESOURC_ID,PARENT_MENU_ID,CHILD_MENU_ID) values ('CATALOG_Submenu_StandardOfferingSubmenu_StandardOffering','CATALOG_Submenu_StandardOfferingSubmenu_StandardOffering',null,(select PRSNTTN_ID from presentation where PRSNTTN_LABEL='STANDARD OFFERING CHILD SUBMENU'),systimestamp,null,'1003',null,'None','menuitem',7,null,RESOURC_ID.NEXTVAL,null,null);


Insert into RSRC_TO_RSRC_REL (RSRC_ID1,RSRC_ID2,CREATED_DT,MODIFIED_DT,CREATED_BY,MODIFIED_BY,IS_PERM_ASSIGNABLE,REL_TYP_CD,RSRC_TYP_CD,RESOURC_ID) values ('CATALOG','CATALOG_MarketOffering_Submenu_StandardOfferingSubmenu',systimestamp,null,'1003',null,'RW ',8,7,(select RESOURC_ID from RESOURC where RSRC_ID ='CATALOG_MarketOffering_Submenu_StandardOfferingSubmenu'));
Insert into RSRC_TO_RSRC_REL (RSRC_ID1,RSRC_ID2,CREATED_DT,MODIFIED_DT,CREATED_BY,MODIFIED_BY,IS_PERM_ASSIGNABLE,REL_TYP_CD,RSRC_TYP_CD,RESOURC_ID) values ('CATALOG','CATALOG_Submenu_StandardOfferingSubmenu_StandardOffering',systimestamp,null,'1003',null,'RW ',8,7,(select RESOURC_ID from RESOURC where RSRC_ID ='CATALOG_Submenu_StandardOfferingSubmenu_StandardOffering'));


Insert into ACCESS_AUTH (ACCESSOR_ID,RSRC_ID,CREATED_DT,MODIFY_DT,CREATED_BY,MODIFY_BY,READ,WRITE) values ((select accessor_id from accessor where role_id = (select role_id from role where role_name='AdminRoleForCatalog')),'CATALOG_MarketOffering_Submenu_StandardOfferingSubmenu',systimestamp,null,1197,null,2,2);
Insert into ACCESS_AUTH (ACCESSOR_ID,RSRC_ID,CREATED_DT,MODIFY_DT,CREATED_BY,MODIFY_BY,READ,WRITE) values ((select accessor_id from accessor where role_id = (select role_id from role where role_name='AdminRoleForCatalog')),'CATALOG_Submenu_StandardOfferingSubmenu_StandardOffering',systimestamp,null,1197,null,2,2);


commit;