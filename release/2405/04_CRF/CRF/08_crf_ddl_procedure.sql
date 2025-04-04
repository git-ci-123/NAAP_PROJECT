--liquibase formatted sql
--changeset Swetha.H:CRF_DDL_08 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE PROCEDURE PROC_DASH_COMP_SUMMARY_DEL (IP_DASHBOARD_ID IN NUMBER,OP_MSG OUT VARCHAR2)
IS
  L_N_COUNT NUMBER;
BEGIN
  SELECT COUNT(1)
  INTO L_N_COUNT
  FROM USERS_DASHBOARD
  WHERE DASHBOARD_ID=IP_DASHBOARD_ID;
  IF L_N_COUNT=1 THEN
    BEGIN
      FOR DCOMP IN (SELECT DASHBOARD_ID,SUMMARY_ID FROM DASHBOARD_COMP WHERE DASHBOARD_ID=IP_DASHBOARD_ID)
      LOOP
        DELETE FROM DASHBOARD_COMP WHERE DASHBOARD_ID=DCOMP.DASHBOARD_ID;
        DELETE FROM SUMMARY_DETAILS WHERE SUMMARY_ID=DCOMP.SUMMARY_ID;
      END LOOP;
    END;
    OP_MSG :='SUCCESS';
   ELSE
    OP_MSG :='INVALID DASHBOARD_ID';
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    OP_MSG := 'INVALID DASHBOARD_ID';
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    OP_MSG := 'FAILURE';
END;


--changeset Swetha.H:CRF_DDL_08_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE PROCEDURE PROC_QUERY_DELETE (
    IP_QUERY_ID  IN NUMBER,
    IP_FOLDER_ID IN NUMBER,
    IP_USER_NAME IN VARCHAR2,
    IP_USER_ID NUMBER,
    Op_Msg OUT VARCHAR2)
IS
  l_n_schedule_id       NUMBER;
  l_n_count             NUMBER;
  l_n_count1            NUMBER;
  L_N_SUMMARY_ID        NUMBER;
  l_n_dir_id            NUMBER;
  L_VC_STATUS           VARCHAR2(30) :='Stopped';
  l_vc_dir_id_reports   VARCHAR2(30) :='REPORTS';
  l_vc_dir_id_published VARCHAR2(30) :='PUBLISHED REPORTS';
BEGIN
  --FOLDER DELETE
  --IF IP_FOLDER_ID IS NOT NULL THEN TAKING QUERIES ASSOCIATED TO THAT FOLDER
  IF (IP_FOLDER_ID <>0 OR IP_FOLDER_ID IS NOT NULL) AND IP_QUERY_ID =0 THEN
    FOR FOLD IN
    ( SELECT DISTINCT FQA.QUERY_ID
    FROM RPT_DIRECTORY_HIERARCHY rdt,
      FOLDER_QUERY_ASSOC fqa,
      REF_DIRECTORY rd
    WHERE RD.RPT_DIR_ID           =RDT.DIR_ID
    AND FQA.FOLDER_ID(+)          =RDT.DIR_ID
    AND FQA.QUERY_ID             IS NOT NULL
      START WITH rdt.DIR_ID       = IP_FOLDER_ID
      CONNECT BY PRIOR rdt.DIR_ID = rdt.REL_DIR_ID
    )
    LOOP
      SELECT COUNT(1)
      INTO l_n_count
      FROM SCHEDULE_ENTITY_ASSOC
      WHERE reportid=FOLD.QUERY_ID
      AND USR_ID    =IP_USER_ID;
      --IF l_n_count=0 THEN THE GIVEN QUERY ID IS NO ASSOCIATED TO ANY OF THE SCHEDULER IF l_n_count<>0 THEN IT IS ASSOCIATED TO A SCHEDULER
      IF l_n_count <>0 THEN
        --TAKING SCHEULEID IN LOOP BY GIVING QUERY ID AND USER ID AS INPUT, SINCE THE SAME QUERY ID CAN BE ASSIGNED TO A MULTIPLE SCHEDULERS
        FOR i IN
        (SELECT SCHEDULEID
        FROM SCHEDULE_ENTITY_ASSOC
        WHERE reportid=FOLD.QUERY_ID
        AND USR_ID    =IP_USER_ID
        )
        LOOP
          --CHECKING FOR THE COUNT BY PASSING THE SCHEULEID
          SELECT COUNT(1)
          INTO l_n_count1
          FROM SCHEDULE_ENTITY_ASSOC
          WHERE SCHEDULEID=i.SCHEDULEID;
          --IF l_n_count1 >1 THEN THIS SCHEDULER HAS MULTIPLE QUERIES ASSIGNED TO IT
          --THEN ONLY WE NEED TO DELETE THE VALUES WITH THE GIVEN I/P
          IF l_n_count1 >1 THEN
            DELETE
            FROM SCHEDULE_ENTITY_ASSOC
            WHERE reportid=FOLD.QUERY_ID
            AND USR_ID    =IP_USER_ID;
            --IF l_n_count1=1 THEN THE GIVEN QUERY ID IS THE ONLY ID ASSOCIATED TO THE SCHEDULER THEN WE NEED TO DELETE AND UPDATE THE STATUS
          elsif l_n_count1=1 THEN
            DELETE
            FROM SCHEDULE_ENTITY_ASSOC
            WHERE reportid=FOLD.QUERY_ID
            AND USR_ID    =IP_USER_ID;
            UPDATE SCHEDULEDETAILS SET STATUS=L_VC_STATUS WHERE SCHEDULEID=i.SCHEDULEID;
          END IF;
        END LOOP;
      END IF;
      --CHECKING FOR DASHBOARD INFORMATIONS FOR GIVEN QUERYID
      SELECT COUNT(1)
      INTO l_n_count
      FROM SUMMARY_DETAILS
      WHERE QUERYID=FOLD.QUERY_ID
      AND userid   =IP_USER_NAME;
      --TASKING COUNT FOR SUMMARY_ID FROM SUMMARY_DETAILS FOR THE GIVEN QUERYID AND USER ID TO CHECK WHETHER DASHBOARD IS ASSOCIATED OR NOT
      IF l_n_count >0 THEN
        FOR i IN
        (SELECT SUMMARY_ID
        FROM SUMMARY_DETAILS
        WHERE QUERYID=FOLD.QUERY_ID
        AND userid   =IP_USER_NAME
        )
        LOOP
          --IF THE GIVEN QUERY ID IS ASSOCIATED TO DASHBOARD THE WE ARE DELETING IT
          DELETE
          FROM DASHBOARD_COMP
          WHERE SUMMARY_ID=i.SUMMARY_ID;
        END LOOP;
        DELETE
        FROM SUMMARY_DETAILS
        WHERE QUERYID=FOLD.QUERY_ID
        AND userid   =IP_USER_NAME;
      END IF;
      --Temp Code added for User_id delete logic in dashboard publish
      --CHECKING FOR DASHBOARD INFORMATIONS FOR GIVEN QUERYID
      SELECT COUNT(1)
      INTO l_n_count
      FROM SUMMARY_DETAILS
      WHERE QUERYID=FOLD.QUERY_ID
      AND userid   =IP_USER_ID;
      --TASKING COUNT FOR SUMMARY_ID FROM SUMMARY_DETAILS FOR THE GIVEN QUERYID AND USER ID TO CHECK WHETHER DASHBOARD IS ASSOCIATED OR NOT
      IF l_n_count >0 THEN
        FOR i IN
        (SELECT SUMMARY_ID
        FROM SUMMARY_DETAILS
        WHERE QUERYID=FOLD.QUERY_ID
        AND userid   =IP_USER_ID
        )
        LOOP
          --IF THE GIVEN QUERY ID IS ASSOCIATED TO DASHBOARD THE WE ARE DELETING IT
          DELETE
          FROM DASHBOARD_COMP
          WHERE SUMMARY_ID=i.SUMMARY_ID;
        END LOOP;
        DELETE
        FROM SUMMARY_DETAILS
        WHERE QUERYID=FOLD.QUERY_ID
        AND userid   =IP_USER_ID;
      END IF;
      --CHECKING FOR REPORT_HEADER_DETAILS
      SELECT COUNT(1)
      INTO l_n_count
      FROM REPORT_HEADER_DETAILS
      WHERE QUERYID=FOLD.QUERY_ID;
      IF l_n_count<>0 THEN
        FOR i IN
        (SELECT COLUMN_ID,
          MAPPED_ENTITY_ID,
          MAPPED_ENTITY_TYPE
        FROM REPORT_HEADER_DETAILS
        WHERE QUERYID=FOLD.QUERY_ID
        )
        LOOP
          IF i.MAPPED_ENTITY_TYPE='others' THEN
            DELETE FROM url_config WHERE url_id=i.MAPPED_ENTITY_ID;
            DELETE FROM REPORT_PARAM WHERE REP_COMP_ID=i.COLUMN_ID;
          END IF;
          IF i.MAPPED_ENTITY_TYPE<>'others' THEN
            DELETE FROM REPORT_PARAM WHERE REP_COMP_ID=i.COLUMN_ID;
          END IF;
        END LOOP;
        DELETE
        FROM REPORT_HEADER_DETAILS
        WHERE QUERYID=FOLD.QUERY_ID;
        FOR i IN
        (SELECT COLUMN_ID,
          MAPPED_ENTITY_ID,
          MAPPED_ENTITY_TYPE
        FROM REPORT_HEADER_DETAILS
        WHERE MAPPED_ENTITY_ID=FOLD.QUERY_ID
        AND MAPPED_ENTITY_TYPE='report'
        )
        LOOP
          DELETE FROM REPORT_PARAM WHERE REP_COMP_ID=i.COLUMN_ID;
        END LOOP;
        DELETE
        FROM REPORT_HEADER_DETAILS
        WHERE MAPPED_ENTITY_ID=FOLD.QUERY_ID
        AND MAPPED_ENTITY_TYPE='report';
      END IF;
      DELETE
      FROM FOLDER_QUERY_ASSOC
      WHERE QUERY_ID=FOLD.QUERY_ID
      AND FOLDER_ID =
        (SELECT FOLDER_ID
        FROM FOLDER_QUERY_ASSOC FQA,
          RPT_DIRECTORY_HIERARCHY RPT,
          REF_DIRECTORY RE
        WHERE FQA.FOLDER_ID  =RPT.DIR_ID
        AND RPT.DIR_ID       =RE.RPT_DIR_ID
        AND RE.DIRECTORY_TYPE='REPORT'
        AND FQA.QUERY_ID     =FOLD.QUERY_ID
        );
      DELETE
      FROM USERQUERYASSOCIATION
      WHERE QUERYID=FOLD.QUERY_ID
      AND USR_ID   =IP_USER_ID;
      DELETE
      FROM QUERYDETAILS
      WHERE QUERYID=FOLD.QUERY_ID;
    END LOOP FOLD;
    IF (IP_FOLDER_ID <>0 OR IP_FOLDER_ID IS NOT NULL) AND IP_QUERY_ID =0 THEN
      FOR DEL_FOLD IN
      ( SELECT DISTINCT rdt.DIR_ID
      FROM RPT_DIRECTORY_HIERARCHY rdt,
        REF_DIRECTORY rd
      WHERE rd.RPT_DIR_ID           =rdt.DIR_ID
        START WITH rdt.DIR_ID       = IP_FOLDER_ID
        CONNECT BY PRIOR rdt.DIR_ID = rdt.REL_DIR_ID
      ORDER BY rdt.DIR_ID
      )
      LOOP
        DELETE FROM RPT_DIRECTORY_HIERARCHY WHERE DIR_ID=DEL_FOLD.DIR_ID;
        DELETE FROM REF_DIRECTORY WHERE RPT_DIR_ID=DEL_FOLD.DIR_ID;
      END LOOP DEL_FOLD;
    END IF;
  END IF;
  IF IP_FOLDER_ID =0 AND (IP_QUERY_ID IS NOT NULL OR IP_QUERY_ID<>0) THEN
    --SINGLE QUERY DELETE
    --SCHEDULER DETAILS DELETE
    --CHECKING WHETHER THE INPUT QUERY ID IS ASSIGNED TO THE SCHEDULER
    SELECT COUNT(1)
    INTO l_n_count
    FROM SCHEDULE_ENTITY_ASSOC
    WHERE reportid=IP_QUERY_ID
    AND USR_ID    =IP_USER_ID;
    --IF l_n_count=0 THEN THE GIVEN QUERY ID IS NO ASSOCIATED TO ANY OF THE SCHEDULER IF l_n_count<>0 THEN IT IS ASSOCIATED TO A SCHEDULER
    IF l_n_count <>0 THEN
      --TAKING SCHEULEID IN LOOP BY GIVING QUERY ID AND USER ID AS INPUT, SINCE THE SAME QUERY ID CAN BE ASSIGNED TO A MULTIPLE SCHEDULERS
      FOR i IN
      (SELECT SCHEDULEID
      FROM SCHEDULE_ENTITY_ASSOC
      WHERE reportid=IP_QUERY_ID
      AND USR_ID    =IP_USER_ID
      )
      LOOP
        --CHECKING FOR THE COUNT BY PASSING THE SCHEULEID
        SELECT COUNT(1)
        INTO l_n_count1
        FROM SCHEDULE_ENTITY_ASSOC
        WHERE SCHEDULEID=i.SCHEDULEID;
        --IF l_n_count1 >1 THEN THIS SCHEDULER HAS MULTIPLE QUERIES ASSIGNED TO IT
        --THEN ONLY WE NEED TO DELETE THE VALUES WITH THE GIVEN I/P
        IF l_n_count1 >1 THEN
          DELETE
          FROM SCHEDULE_ENTITY_ASSOC
          WHERE reportid=IP_QUERY_ID
          AND USR_ID    =IP_USER_ID;
          --IF l_n_count1=1 THEN THE GIVEN QUERY ID IS THE ONLY ID ASSOCIATED TO THE SCHEDULER THEN WE NEED TO DELETE AND UPDATE THE STATUS
        elsif l_n_count1=1 THEN
          DELETE
          FROM SCHEDULE_ENTITY_ASSOC
          WHERE reportid=IP_QUERY_ID
          AND USR_ID    =IP_USER_ID;
          UPDATE SCHEDULEDETAILS SET STATUS=L_VC_STATUS WHERE SCHEDULEID=i.SCHEDULEID;
        END IF;
      END LOOP;
    END IF;
    --CHECKING FOR DASHBOARD INFORMATIONS FOR GIVEN QUERYID
    SELECT COUNT(1)
    INTO l_n_count
    FROM SUMMARY_DETAILS
    WHERE QUERYID=IP_QUERY_ID
    AND userid   =IP_USER_NAME;
    --TASKING COUNT FOR SUMMARY_ID FROM SUMMARY_DETAILS FOR THE GIVEN QUERYID AND USER ID TO CHECK WHETHER DASHBOARD IS ASSOCIATED OR NOT
    IF l_n_count >0 THEN
      FOR i IN
      (SELECT SUMMARY_ID
      FROM SUMMARY_DETAILS
      WHERE QUERYID=IP_QUERY_ID
      AND userid   =IP_USER_NAME
      )
      LOOP
        --IF THE GIVEN QUERY ID IS ASSOCIATED TO DASHBOARD THE WE ARE DELETING IT
        DELETE
        FROM DASHBOARD_COMP
        WHERE SUMMARY_ID=i.SUMMARY_ID;
      END LOOP;
      DELETE
      FROM SUMMARY_DETAILS
      WHERE QUERYID=IP_QUERY_ID
      AND userid   =IP_USER_NAME;
    END IF;
    --CHECKING FOR DASHBOARD INFORMATIONS FOR GIVEN QUERYID
    SELECT COUNT(1)
    INTO l_n_count
    FROM SUMMARY_DETAILS
    WHERE QUERYID=IP_QUERY_ID
    AND userid   =IP_USER_ID;
    --TASKING COUNT FOR SUMMARY_ID FROM SUMMARY_DETAILS FOR THE GIVEN QUERYID AND USER ID TO CHECK WHETHER DASHBOARD IS ASSOCIATED OR NOT
    IF l_n_count >0 THEN
      FOR i IN
      (SELECT SUMMARY_ID
      FROM SUMMARY_DETAILS
      WHERE QUERYID=IP_QUERY_ID
      AND userid   =IP_USER_ID
      )
      LOOP
        --IF THE GIVEN QUERY ID IS ASSOCIATED TO DASHBOARD THE WE ARE DELETING IT
        DELETE
        FROM DASHBOARD_COMP
        WHERE SUMMARY_ID=i.SUMMARY_ID;
      END LOOP;
      DELETE FROM SUMMARY_DETAILS WHERE QUERYID=IP_QUERY_ID AND userid =IP_USER_ID;
    END IF;
    --CHECKING FOR REPORT_HEADER_DETAILS
    SELECT COUNT(1)
    INTO l_n_count
    FROM REPORT_HEADER_DETAILS
    WHERE QUERYID=IP_QUERY_ID;
    IF l_n_count<>0 THEN
      FOR i IN
      (SELECT COLUMN_ID,
        MAPPED_ENTITY_ID,
        MAPPED_ENTITY_TYPE
      FROM REPORT_HEADER_DETAILS
      WHERE QUERYID=IP_QUERY_ID
      )
      LOOP
        IF i.MAPPED_ENTITY_TYPE='others' THEN
          DELETE FROM url_config WHERE url_id=i.MAPPED_ENTITY_ID;
          DELETE FROM REPORT_PARAM WHERE REP_COMP_ID=i.COLUMN_ID;
        END IF;
        IF i.MAPPED_ENTITY_TYPE<>'others' THEN
          DELETE FROM REPORT_PARAM WHERE REP_COMP_ID=i.COLUMN_ID;
        END IF;
      END LOOP;
      DELETE
      FROM REPORT_HEADER_DETAILS
      WHERE QUERYID=IP_QUERY_ID;
      FOR i IN
      (SELECT COLUMN_ID,
        MAPPED_ENTITY_ID,
        MAPPED_ENTITY_TYPE
      FROM REPORT_HEADER_DETAILS
      WHERE MAPPED_ENTITY_ID=IP_QUERY_ID
      AND MAPPED_ENTITY_TYPE='report'
      )
      LOOP
        DELETE FROM REPORT_PARAM WHERE REP_COMP_ID=i.COLUMN_ID;
      END LOOP;
      DELETE
      FROM REPORT_HEADER_DETAILS
      WHERE MAPPED_ENTITY_ID=IP_QUERY_ID
      AND MAPPED_ENTITY_TYPE='report';
    END IF;
    DELETE
    FROM FOLDER_QUERY_ASSOC
    WHERE QUERY_ID=IP_QUERY_ID
    AND FOLDER_ID =
      (SELECT FOLDER_ID
      FROM FOLDER_QUERY_ASSOC FQA,
        RPT_DIRECTORY_HIERARCHY RPT,
        REF_DIRECTORY RE
      WHERE FQA.FOLDER_ID  =RPT.DIR_ID
      AND RPT.DIR_ID       =RE.RPT_DIR_ID
      AND RE.DIRECTORY_TYPE='REPORT'
      AND FQA.QUERY_ID     =IP_QUERY_ID
      );
    DELETE
    FROM USERQUERYASSOCIATION
    WHERE QUERYID=IP_QUERY_ID
    AND USR_ID   =IP_USER_ID;
    DELETE FROM QUERYDETAILS WHERE QUERYID=IP_QUERY_ID;
  END IF;
  COMMIT;
  op_msg := 'SUCCESS';
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  op_msg := 'FAILURE';
END proc_query_delete;



--changeset Swetha.H:CRF_DDL_08_03 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE PROCEDURE MIGRATEOLDDASHBOARD (
    DASHBOARDID IN NUMBER
    --, summaryArray IN SUMMARYOBJECT_ARRAY
  )
IS
  dashbcompid         NUMBER;
  DASHBCOMPIDFORCHART NUMBER;
  summobj SUMMARYOBJECT;
BEGIN
  --FOR J IN SUMMARYARRAY.FIRST .. SUMMARYARRAY.LAST
  --LOOP
  --DBMS_OUTPUT.PUT_LINE(SUMMARYARRAY(j).sumaryJson);
  --update summary_Details set query = TO_CLOB(SUMMARYARRAY(j).sumaryJson), displayformat = getNewChartName(displayformat) where summary_id = SUMMARYARRAY(j).summaryId;
  --END LOOP;
  FOR dashboardcompobj IN
  (SELECT dashboard_comp_id,
    summary_id,
    disp_seq,
    rel_dashboard_comp_id
  FROM dashboard_comp
  WHERE dashboard_id      = dashboardid
  AND dashboard_comp_type ='FRAME'
  ORDER BY disp_seq
  )
  LOOP
    SELECT SEQ_DASHBOARD_COMP_ID.nextval INTO dashbcompid FROM dual;
    INSERT
    INTO DASHBOARD_COMP
      (
        DASHBOARD_COMP_ID,
        DASHBOARD_ID,
        SUMMARY_ID,
        DASHBOARD_COMP_NAME,
        DASHBOARD_COMP_TYPE,
        HEIGHT_PERCENTAGE,
        WIDTH_PERCENTAGE,
        DISP_SEQ,
        REL_DASHBOARD_COMP_ID,
        LAYOUT_ID
      )
      VALUES
      (
        dashbcompid,
        dashboardid,
        dashboardcompobj.SUMMARY_ID,
        '',
        'FRAME',
        237,
        NULL,
        dashboardcompobj.DISP_SEQ,
        NULL,
        NULL
      );
    FOR dashboardcompchartobj IN
    (SELECT dashboard_comp_id,
        summary_id,
        disp_seq,
        rel_dashboard_comp_id,
        WIDTH_PERCENTAGE
      FROM dashboard_comp
      WHERE rel_dashboard_comp_id = dashboardcompobj.dashboard_comp_id
      ORDER BY disp_seq
    )
    LOOP
      SELECT SEQ_DASHBOARD_COMP_ID.nextval INTO dashbcompidforchart FROM dual;
      INSERT
      INTO DASHBOARD_COMP
        (
          DASHBOARD_COMP_ID,
          DASHBOARD_ID,
          SUMMARY_ID,
          DASHBOARD_COMP_NAME,
          DASHBOARD_COMP_TYPE,
          HEIGHT_PERCENTAGE,
          WIDTH_PERCENTAGE,
          DISP_SEQ,
          REL_DASHBOARD_COMP_ID,
          LAYOUT_ID
        )
        VALUES
        (
          dashbcompidforchart,
          dashboardid,
          dashboardcompchartobj.SUMMARY_ID,
          '',
          'CHART',
          237,
          dashboardcompchartobj.WIDTH_PERCENTAGE,
          dashboardcompchartobj.DISP_SEQ,
          dashbcompid,
          NULL
        );
      DELETE
      FROM dashboard_comp
      WHERE dashboard_comp_id=dashboardcompchartobj.dashboard_comp_id;
    END LOOP;
    DELETE
    FROM dashboard_comp
    WHERE dashboard_comp_id=dashboardcompobj.dashboard_comp_id;
  END LOOP;
END;


--changeset Swetha.H:CRF_DDL_08_04 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE PROCEDURE PROC_FOLDER_PASTE_DASHBOARD (
    IP_TARGET_FOLDER_ID NUMBER,
    IP_SOURCE_FOLDER_ID NUMBER,
    IP_FOLDER_TYPE REF_DIRECTORY.DIRECTORY_TYPE%TYPE,
    IP_USER_NAME REF_DIRECTORY.CREATED_BY%TYPE,
    OP_OUTPUT_MSG OUT VARCHAR2)
IS
  L_N_DIR_LEVEL_SOURCE  NUMBER;
  L_N_DIR_LEVEL_TARGET  NUMBER;
  L_N_FINAL_LEVEL       NUMBER;
  L_N_COUNT             NUMBER;
  L_N_DIR_LEVEL_SUB     NUMBER;
  EX_LEVEL_EXCEEDED     EXCEPTION;
  EX_LIMIT_EXCEEDED     EXCEPTION;
  L_N_LEVEL             NUMBER;
  L_N_MAIN_DIR_ID       NUMBER;
  L_N_DIR_LEVEL         NUMBER;
  L_VC_SOURCE_FOLD_NAME VARCHAR2(300);
  L_VC_NEW_FOLDER_NAME  VARCHAR2(300);
BEGIN
  SELECT REL_DIR_ID
  INTO L_N_MAIN_DIR_ID
  FROM RPT_DIRECTORY_HIERARCHY
  WHERE DIR_ID       =IP_SOURCE_FOLDER_ID;
  IF L_N_MAIN_DIR_ID<>IP_TARGET_FOLDER_ID THEN
    SELECT COUNT( RD.DIR_LEVEL)
    INTO L_N_DIR_LEVEL_SOURCE
    FROM RPT_DIRECTORY_HIERARCHY rdt,
      REF_DIRECTORY rd
    WHERE rd.RPT_DIR_ID           =rdt.DIR_ID
    AND RD.DIRECTORY_TYPE         =IP_FOLDER_TYPE
      START WITH rdt.DIR_ID       = IP_SOURCE_FOLDER_ID
      CONNECT BY PRIOR rdt.DIR_ID = rdt.REL_DIR_ID;
    SELECT RD.DIR_LEVEL
    INTO L_N_DIR_LEVEL_TARGET
    FROM REF_DIRECTORY rd
    WHERE rd.RPT_DIR_ID  = IP_TARGET_FOLDER_ID
    AND RD.DIRECTORY_TYPE=IP_FOLDER_TYPE;
    SELECT L_N_DIR_LEVEL_SOURCE+L_N_DIR_LEVEL_TARGET
    INTO L_N_FINAL_LEVEL
    FROM DUAL;
    SELECT COUNT(1)
    INTO L_N_COUNT
    FROM RPT_DIRECTORY_HIERARCHY
    WHERE REL_DIR_ID =IP_TARGET_FOLDER_ID;
    SELECT DIR_LEVEL
    INTO L_N_DIR_LEVEL
    FROM REF_DIRECTORY
    WHERE RPT_DIR_ID   =IP_TARGET_FOLDER_ID;
    IF L_N_FINAL_LEVEL >4 THEN
      RAISE EX_LEVEL_EXCEEDED;
    ELSIF L_N_COUNT>=50 AND L_N_DIR_LEVEL>1 THEN
      RAISE EX_LIMIT_EXCEEDED;
    elsif L_N_DIR_LEVEL_TARGET =4 AND L_N_DIR_LEVEL_SOURCE=3 THEN
      RAISE EX_LEVEL_EXCEEDED;
    ELSE
      SELECT RPT_DIR_NAME
      INTO L_VC_SOURCE_FOLD_NAME
      FROM REF_DIRECTORY
      WHERE CREATED_BY  = IP_USER_NAME
      AND DIRECTORY_TYPE=IP_FOLDER_TYPE
      AND RPT_DIR_ID    =IP_SOURCE_FOLDER_ID;
      SELECT COUNT(1)
      INTO L_N_COUNT
      FROM REF_DIRECTORY RD,
        RPT_DIRECTORY_HIERARCHY RPT
      WHERE RPT.REL_DIR_ID =IP_TARGET_FOLDER_ID
      AND RD.CREATED_BY    = IP_USER_NAME
      AND RD.RPT_DIR_ID    =RPT.DIR_ID
      AND RD.DIRECTORY_TYPE=IP_FOLDER_TYPE
      AND RD.RPT_DIR_NAME  =L_VC_SOURCE_FOLD_NAME;
      IF L_N_COUNT         =1 THEN
        SELECT (
          CASE
            WHEN FOLDERNAME IS NULL
            THEN (
              CASE
                WHEN (SELECT COUNT(1)
                  FROM REF_DIRECTORY
                  WHERE RPT_DIR_NAME=L_VC_SOURCE_FOLD_NAME
                  AND CREATED_BY    = IP_USER_NAME)<>0
                THEN L_VC_SOURCE_FOLD_NAME
                  ||'-1'
                ELSE L_VC_SOURCE_FOLD_NAME
              END)
            ELSE FOLDERNAME
          END )FOLDERNAME
        INTO L_VC_NEW_FOLDER_NAME
        FROM
          (SELECT
            CASE MAX(RPT_DIR_NAME)
              WHEN NULL
              THEN NULL
              ELSE SUBSTR( MAX(RPT_DIR_NAME),0,INSTR( MAX(RPT_DIR_NAME), '-', -1))
                || (SUBSTR( MAX(RPT_DIR_NAME),INSTR( MAX(RPT_DIR_NAME), '-',  -1)+1) + 1 )
            END AS FOLDERNAME
          FROM REF_DIRECTORY RD
          WHERE RD.CREATED_BY = IP_USER_NAME
          AND REGEXP_LIKE (RD.RPT_DIR_NAME,''
            ||L_VC_SOURCE_FOLD_NAME
            ||'-([0-9])','c')
          );
        UPDATE REF_DIRECTORY
        SET RPT_DIR_NAME  =L_VC_NEW_FOLDER_NAME
        WHERE RPT_DIR_ID  =IP_SOURCE_FOLDER_ID
        AND CREATED_BY    = IP_USER_NAME
        AND DIRECTORY_TYPE=IP_FOLDER_TYPE;
      END IF;
      UPDATE RPT_DIRECTORY_HIERARCHY
      SET REL_DIR_ID=IP_TARGET_FOLDER_ID
      WHERE DIR_ID  =IP_SOURCE_FOLDER_ID;
      FOR I IN
      ( SELECT DISTINCT rdt.DIR_ID
      FROM RPT_DIRECTORY_HIERARCHY rdt,
        REF_DIRECTORY rd
      WHERE rd.RPT_DIR_ID           =rdt.DIR_ID
        START WITH rdt.DIR_ID       = IP_SOURCE_FOLDER_ID
        CONNECT BY PRIOR rdt.DIR_ID = rdt.REL_DIR_ID
      ORDER BY rdt.DIR_ID
      )
      LOOP
        L_N_LEVEL :=L_N_DIR_LEVEL_TARGET+1;
        UPDATE REF_DIRECTORY SET DIR_LEVEL=L_N_LEVEL WHERE RPT_DIR_ID=I.DIR_ID;
        L_N_DIR_LEVEL_TARGET := L_N_LEVEL;
      END LOOP;
    END IF;
  END IF;
  OP_OUTPUT_MSG :='SUCCESS';
EXCEPTION
WHEN EX_LEVEL_EXCEEDED THEN
  raise_application_error (-20001,'LEVEL EXCEEDED');
WHEN EX_LIMIT_EXCEEDED THEN
  raise_application_error (-20002,'LIMIT EXCEEDED');
END proc_folder_paste_dashboard;


--changeset Swetha.H:CRF_DDL_08_05 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE PROCEDURE PROC_DASHBOARD_DEL (
    ip_dashboard_id IN NUMBER,
    ip_folder_id    IN NUMBER,
    op_msg OUT VARCHAR2)
IS
  l_n_count   NUMBER;
  l_n_summ_id NUMBER;
BEGIN
  IF (ip_folder_id =0 OR ip_folder_id IS NULL) AND (ip_dashboard_id IS NOT NULL OR ip_dashboard_id <>0) THEN
    SELECT COUNT(1)
    INTO l_n_count
    FROM users_dashboard
    WHERE dashboard_id=ip_dashboard_id;
    IF l_n_count      =1 THEN
      SELECT MAX(SUMMARY_ID)
      INTO l_n_summ_id
      FROM dashboard_comp
      WHERE DASHBOARD_ID=ip_dashboard_id ;
      IF l_n_summ_id   IS NOT NULL THEN
        BEGIN
          FOR i IN
          ( SELECT DISTINCT dc.dashboard_id,
            dc.summary_id
          FROM dashboard_comp dc,
            users_dashboard ud,
            summary_details sd,
            dashboard_publish_detail dpd
          WHERE dc.DASHBOARD_ID=ud.DASHBOARD_ID
          AND dc.summary_id    =sd.summary_id
          AND dc.dashboard_id  =dpd.dashboard_id
          AND dc.dashboard_id  =ip_dashboard_id
          )
          LOOP
            DELETE FROM dashboard_comp WHERE dashboard_id=i.dashboard_id;
            DELETE FROM summary_details WHERE summary_id=i.summary_id;
            DELETE FROM users_dashboard WHERE dashboard_id=i.dashboard_id;
            DELETE FROM dashboard_publish_detail WHERE dashboard_id=i.dashboard_id;
            --Deleting Dashboards inside the folder logic added
            DELETE
            FROM FOLDER_QUERY_ASSOC
            WHERE QUERY_ID=i.dashboard_id
            AND FOLDER_ID =
              (SELECT FOLDER_ID
              FROM FOLDER_QUERY_ASSOC FQA,
                REF_DIRECTORY RE
              WHERE FQA.FOLDER_ID    =RE.RPT_DIR_ID
              AND RE.DIRECTORY_TYPE IN ('DASHBOARD','EUREKA_HOMEPAGE','LANDING_DASHBOARD')
              AND FQA.QUERY_ID       =i.dashboard_id
              );
          END LOOP;
        END;
      END IF;
      IF l_n_summ_id IS NULL THEN
        BEGIN
          FOR i IN
          ( SELECT DISTINCT dc.dashboard_id,
            dc.summary_id
          FROM dashboard_comp dc,
            users_dashboard ud,
            summary_details sd,
            dashboard_publish_detail dpd
          WHERE dc.DASHBOARD_ID=ud.DASHBOARD_ID
          AND dc.summary_id    =sd.summary_id(+)
          AND dc.dashboard_id  =dpd.dashboard_id
          AND dc.dashboard_id  =ip_dashboard_id
          )
          LOOP
            DELETE FROM dashboard_comp WHERE dashboard_id=i.dashboard_id;
            DELETE FROM summary_details WHERE summary_id=i.summary_id;
            DELETE FROM users_dashboard WHERE dashboard_id=i.dashboard_id;
            DELETE FROM dashboard_publish_detail WHERE dashboard_id=i.dashboard_id;
            --Deleting Dashboards inside the folder logic added
            DELETE
            FROM FOLDER_QUERY_ASSOC
            WHERE QUERY_ID=i.dashboard_id
            AND FOLDER_ID =
              (SELECT FOLDER_ID
              FROM FOLDER_QUERY_ASSOC FQA,
                REF_DIRECTORY RE
              WHERE FQA.FOLDER_ID    =RE.RPT_DIR_ID
              AND RE.DIRECTORY_TYPE IN ('DASHBOARD','EUREKA_HOMEPAGE','LANDING_DASHBOARD')
              AND FQA.QUERY_ID       =i.dashboard_id
              );
          END LOOP;
        END;
      END IF;
      -- COMMIT;
      op_msg := 'SUCCESS';
    END IF;
  END IF;
  IF (ip_folder_id <>0 OR ip_folder_id IS NOT NULL) AND (ip_dashboard_id IS NULL OR ip_dashboard_id =0) THEN
    FOR j IN
    ( SELECT DISTINCT FQA.QUERY_ID
    FROM RPT_DIRECTORY_HIERARCHY rdt,
      FOLDER_QUERY_ASSOC fqa,
      REF_DIRECTORY rd
    WHERE RD.RPT_DIR_ID           =RDT.DIR_ID
    AND FQA.FOLDER_ID(+)          =RDT.DIR_ID
    AND FQA.QUERY_ID             IS NOT NULL
      START WITH rdt.DIR_ID       = ip_folder_id
      CONNECT BY PRIOR rdt.DIR_ID = rdt.REL_DIR_ID
    )
    LOOP
      SELECT COUNT(1)
      INTO l_n_count
      FROM users_dashboard
      WHERE dashboard_id=j.QUERY_ID;
      IF l_n_count      =1 THEN
        BEGIN
          FOR i IN
          ( SELECT DISTINCT dc.dashboard_id,
            dc.summary_id
          FROM dashboard_comp dc,
            users_dashboard ud,
            summary_details sd,
            dashboard_publish_detail dpd
          WHERE dc.DASHBOARD_ID=ud.DASHBOARD_ID
          AND dc.summary_id    =sd.summary_id
          AND dc.dashboard_id  =dpd.dashboard_id
          AND dc.dashboard_id  =j.QUERY_ID
          )
          LOOP
            DELETE FROM dashboard_comp WHERE dashboard_id=i.dashboard_id;
            DELETE FROM summary_details WHERE summary_id=i.summary_id;
            DELETE FROM users_dashboard WHERE dashboard_id=i.dashboard_id;
            DELETE FROM dashboard_publish_detail WHERE dashboard_id=i.dashboard_id;
            --Deleting Dashboards inside the folder logic added
            DELETE
            FROM FOLDER_QUERY_ASSOC
            WHERE QUERY_ID=i.dashboard_id
            AND FOLDER_ID =
              (SELECT FOLDER_ID
              FROM FOLDER_QUERY_ASSOC FQA,
                REF_DIRECTORY RE
              WHERE FQA.FOLDER_ID    =RE.RPT_DIR_ID
              AND RE.DIRECTORY_TYPE IN ('DASHBOARD','EUREKA_HOMEPAGE','LANDING_DASHBOARD')
              AND FQA.QUERY_ID       =i.dashboard_id
              );
          END LOOP;
        END;
        -- COMMIT;
      END IF;
    END LOOP;
    FOR DEL_FOLD IN
    ( SELECT DISTINCT rdt.DIR_ID
    FROM RPT_DIRECTORY_HIERARCHY rdt,
      REF_DIRECTORY rd
    WHERE rd.RPT_DIR_ID           =rdt.DIR_ID
      START WITH rdt.DIR_ID       = ip_folder_id
      CONNECT BY PRIOR rdt.DIR_ID = rdt.REL_DIR_ID
    ORDER BY rdt.DIR_ID
    )
    LOOP
      DELETE FROM RPT_DIRECTORY_HIERARCHY WHERE DIR_ID=DEL_FOLD.DIR_ID;
      DELETE FROM REF_DIRECTORY WHERE RPT_DIR_ID=DEL_FOLD.DIR_ID;
    END LOOP DEL_FOLD;
    op_msg := 'SUCCESS';
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  op_msg := 'INVALID DASHBOARD_ID';
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  op_msg := 'FAILURE';
END;


--changeset Swetha.H:CRF_DDL_08_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE PROCEDURE PROC_COPY_DASHBOARD (
    IP_DASHBOARD_ID   IN NUMBER,
    IP_DASHBOARD_NAME IN VARCHAR2,
    IP_FOLDER_ID      IN NUMBER,
    Op_Msg OUT VARCHAR2)
IS
  l_n_new_dashboard_id NUMBER;
  l_n_dash_comp_id     NUMBER;
  l_n_summary_id       NUMBER;
BEGIN
  --  Person                Release            Date            Comments
  --  Nirmal.B              17.07 Sprint 1     01/06/2017      New Procedure Created for Coping Dashboard for Eureka.
  --  Nirmal.B              17.08 Sprint 1     03/07/2017      Procedure modified for adding Folder_id as input since we can copy dashboard and past it in any of the folders.
  IF IP_DASHBOARD_ID IS NOT NULL OR IP_DASHBOARD_ID<>0 THEN
    SELECT SEQ_DASHBOARD_ID.NEXTVAL INTO l_n_new_dashboard_id FROM DUAL;
    INSERT
    INTO USERS_DASHBOARD
      (
        DASHBOARD_ID,
        DASHBOARD_NAME,
        DASHBOARD_DESCRIPTION,
        USER_ID,
        CREATED_DATE,
        DEFAULT_YN,
        NUM_OF_HFRAMES,
        NUM_OF_VFRAMES,
        DASHBOARD_TYPE,
        MODIFIED_DATE
      )
    SELECT l_n_new_dashboard_id,
      IP_DASHBOARD_NAME,
      DASHBOARD_DESCRIPTION,
      USER_ID,
      SYSDATE,
      'N',
      NUM_OF_HFRAMES,
      NUM_OF_VFRAMES,
      DASHBOARD_TYPE,
      SYSDATE
    FROM USERS_DASHBOARD
    WHERE dashboard_id =IP_DASHBOARD_ID;
    --Dashboard copy to Folder changes added
    INSERT
    INTO FOLDER_QUERY_ASSOC
      (
        FOLDER_ID,
        QUERY_ID
      )
      VALUES
      (
        IP_FOLDER_ID,
        l_n_new_dashboard_id
      );
    INSERT
    INTO DASHBOARD_PUBLISH_DETAIL
      (
        DASHBOARD_ID,
        USER_ID,
        GROUP_ID,
        DASHBOARD_PUBLISH_FLG,
        DFLT_FLG,
        PUBLISHED_BY,
        PUBLISHED_DATE
      )
    SELECT l_n_new_dashboard_id,
      USER_ID ,
      NULL ,
      'N',
      NULL ,
      NULL,
      NULL
    FROM DASHBOARD_PUBLISH_DETAIL
    WHERE dashboard_id=IP_DASHBOARD_ID;
    FOR i IN
    (SELECT DASHBOARD_COMP_ID,
      DASHBOARD_ID,
      SUMMARY_ID,
      DASHBOARD_COMP_NAME,
      DASHBOARD_COMP_TYPE,
      HEIGHT_PERCENTAGE,
      WIDTH_PERCENTAGE,
      DISP_SEQ,
      REL_DASHBOARD_COMP_ID,
      LAYOUT_ID
    FROM DASHBOARD_COMP
    WHERE DASHBOARD_ID     =IP_DASHBOARD_ID
    AND DASHBOARD_COMP_TYPE='FRAME'
    ORDER BY DASHBOARD_COMP_ID
    )
    LOOP
      SELECT SEQ_DASHBOARD_COMP_ID.nextval INTO l_n_dash_comp_id FROM dual;
      INSERT
      INTO DASHBOARD_COMP
        (
          DASHBOARD_COMP_ID,
          DASHBOARD_ID,
          SUMMARY_ID,
          DASHBOARD_COMP_NAME,
          DASHBOARD_COMP_TYPE,
          HEIGHT_PERCENTAGE,
          WIDTH_PERCENTAGE,
          DISP_SEQ,
          REL_DASHBOARD_COMP_ID,
          LAYOUT_ID
        )
        VALUES
        (
          l_n_dash_comp_id,
          l_n_new_dashboard_id,
          i.SUMMARY_ID,
          i.DASHBOARD_COMP_NAME,
          i.DASHBOARD_COMP_TYPE,
          i.HEIGHT_PERCENTAGE,
          i.WIDTH_PERCENTAGE,
          i.DISP_SEQ,
          i.REL_DASHBOARD_COMP_ID,
          i.LAYOUT_ID
        );
      FOR j IN
      (SELECT DASHBOARD_COMP_ID,
          DASHBOARD_ID,
          SUMMARY_ID,
          DASHBOARD_COMP_NAME,
          DASHBOARD_COMP_TYPE,
          HEIGHT_PERCENTAGE,
          WIDTH_PERCENTAGE,
          DISP_SEQ,
          REL_DASHBOARD_COMP_ID,
          LAYOUT_ID
        FROM DASHBOARD_COMP
        WHERE REL_DASHBOARD_COMP_ID=i.DASHBOARD_COMP_ID
        ORDER BY DASHBOARD_COMP_ID
      )
      LOOP
        SELECT SEQ_SUMMARY_ID.nextval INTO l_n_summary_id FROM dual;
        INSERT
        INTO SUMMARY_DETAILS
          (
            SUMMARY_ID,
            QUERYID,
            USERID,
            QUERY,
            DISPLAYFORMAT,
            METRICS_TEMPLATE_ID
          )
        SELECT l_n_summary_id,
          sd.QUERYID,
          sd.USERID,
          sd.QUERY,
          sd.DISPLAYFORMAT,
          sd.METRICS_TEMPLATE_ID
        FROM SUMMARY_DETAILS sd
        WHERE sd.summary_id= j.SUMMARY_ID;
        INSERT
        INTO DASHBOARD_COMP
          (
            DASHBOARD_COMP_ID,
            DASHBOARD_ID,
            SUMMARY_ID,
            DASHBOARD_COMP_NAME,
            DASHBOARD_COMP_TYPE,
            HEIGHT_PERCENTAGE,
            WIDTH_PERCENTAGE,
            DISP_SEQ,
            REL_DASHBOARD_COMP_ID,
            LAYOUT_ID
          )
          VALUES
          (
            SEQ_DASHBOARD_COMP_ID.nextval,
            l_n_new_dashboard_id,
            l_n_summary_id,
            j.DASHBOARD_COMP_NAME,
            j.DASHBOARD_COMP_TYPE,
            j.HEIGHT_PERCENTAGE,
            j.WIDTH_PERCENTAGE,
            j.DISP_SEQ,
            l_n_dash_comp_id,
            j.LAYOUT_ID
          );
      END LOOP;
    END LOOP;
  END IF;
  op_msg := 'SUCCESS';
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(SQLERRM);
  op_msg := 'FAILURE';
END proc_copy_dashboard;


--changeset Swetha.H:CRF_DDL_08_07 splitStatements:false
--preconditions onFail:HALT onError:HALT

  CREATE OR REPLACE EDITIONABLE PROCEDURE PROC_REPORT_COPY (
    ip_query_id querydetails.queryid%type,
    ip_query_name querydetails.queryname%type,
    ip_query_xml querydetails.queryxml%type,
    ip_query querydetails.query%type,
    ip_user_name USERQUERYASSOCIATION.USERID%type,
    IP_USR_ID USERQUERYASSOCIATION.USR_ID%TYPE,
    op_query_id OUT querydetails.queryid%type)
AS
  l_n_query_id       NUMBER;
  l_n_USERQUERYASSID NUMBER;
  l_n_dir_id         NUMBER;
BEGIN
  SELECT queryseq.nextval INTO l_n_query_id FROM dual;
  INSERT
  INTO QUERYDETAILS
    (
      QUERYID,
      QUERYNAME,
      QUERYXML,
      USERID,
      CREATEDDATE,
      QUERYDESCRIPTION,
      DOMAINNAME,
      STATUS,
      REPORTTYPE,
      QRY_FORMATION_TYPE,
      QUERY,
      MODIFIED_DATE
    )
  SELECT l_n_query_id,
    ip_query_name,
    (
    CASE
      WHEN ip_query_xml IS NULL
      THEN QUERYXML
      ELSE ip_query_xml
    END),
    USERID,
    sysdate,
    QUERYDESCRIPTION,
    DOMAINNAME,
    STATUS,
    REPORTTYPE,
    QRY_FORMATION_TYPE,
    (
    CASE
      WHEN ip_query IS NULL
      THEN QUERY
      ELSE ip_query
    END),
    SYSDATE
  FROM QUERYDETAILS
  WHERE queryid = ip_query_id;
  SELECT USERQUERYASSID.nextval INTO l_n_USERQUERYASSID FROM dual;
  INSERT
  INTO USERQUERYASSOCIATION
    (
      USERQUERYASSID,
      USERID,
      USR_ID,
      QUERYID
    )
    VALUES
    (
      l_n_USERQUERYASSID,
      ip_user_name ,
      ip_usr_id ,
      l_n_query_id
    );
  INSERT
  INTO FOLDER_QUERY_ASSOC
    (
      FOLDER_ID,
      QUERY_ID
    )
    VALUES
    (
      (SELECT (
          CASE
            WHEN domainname='MSSQL_JNDI_NAME'
            THEN 19
            ELSE 10
          END) folder_id
        FROM QUERYDETAILS
        WHERE QUERYID=l_n_query_id
      )
      ,
      l_n_query_id
    );
  OP_QUERY_ID :=L_N_QUERY_ID;
EXCEPTION
WHEN OTHERS THEN
  OP_QUERY_ID :=0;
END proc_report_copy;
