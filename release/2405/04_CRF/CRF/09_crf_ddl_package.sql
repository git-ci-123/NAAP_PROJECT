--liquibase formatted sql
--changeset Swetha.H:CRF_DDL_09 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE PACKAGE PKG_UNPUBLISH is
    PROCEDURE proc_unpublish(
    ip_user_id IN LIST_UNPUBLISHED,
    ip_query_id in number,
    op_msg OUT VARCHAR2);
    END PKG_UNPUBLISH;


--changeset Swetha.H:CRF_DDL_09_02 splitStatements:false
--preconditions onFail:HALT onError:HALT

CREATE OR REPLACE EDITIONABLE PACKAGE BODY PKG_UNPUBLISH 
IS
  PROCEDURE proc_unpublish(
      ip_user_id  IN LIST_UNPUBLISHED,
      ip_query_id IN NUMBER,
      op_msg OUT VARCHAR2)
  IS
    l_n_user_id NUMBER;
  BEGIN
    FOR i IN 1..ip_user_id.count
    LOOP
      l_n_user_id     :=ip_user_id(i).user_id;
      IF (l_n_user_id <> 0 OR l_n_user_id IS NOT NULL) THEN
        BEGIN
          FOR k IN
          (SELECT usr_id
          FROM USERQUERYASSOCIATION
          WHERE QUERYID        =ip_query_id
          AND QUERY_PRIVILEGE IS NULL
          )
          LOOP
            IF (k.usr_id <>l_n_user_id) THEN
              BEGIN
                FOR j IN
                (SELECT SUMMARY_ID
                FROM SUMMARY_DETAILS
                WHERE QUERYID=ip_query_id
                AND userid   =l_n_user_id
                )
                LOOP
                  DELETE FROM DASHBOARD_COMP WHERE SUMMARY_ID=j.SUMMARY_ID;
                  DELETE FROM SUMMARY_DETAILS WHERE SUMMARY_ID=j.SUMMARY_ID;
                END LOOP;
              END;
            END IF;
          END LOOP;
        END;
        op_msg := 'SUCCESS';
      ELSE
        op_msg := 'FAILURE';
      END IF;
    END LOOP;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    op_msg := 'INVALID DASHBOARD_ID';
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    op_msg := 'FAILURE';
  END proc_unpublish;
END PKG_UNPUBLISH;