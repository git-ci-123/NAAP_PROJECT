--liquibase formatted sql
--changeset Swetha.H:CRPT_DDL_04
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE FORCE EDITIONABLE VIEW MVIEW_USERS (USER_NAME, USR_LAST_NAME, USR_LOGIN_ID, USR_ID) AS 
  SELECT User_Name ,
    Usr_Last_Name,
    Usr_Login_Id,
    usr_id
  FROM
    (SELECT Usr_Last_Name
      || ', '
      || Usr_Name AS User_Name,
      Usr_Login_Id,
      Usr_Last_Name,
      Usr_Name,
      usr_id
    FROM Users
    );

 