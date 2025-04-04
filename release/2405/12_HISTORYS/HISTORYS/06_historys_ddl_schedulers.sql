--liquibase formatted sql
--changeset Swetha.H:HISTORYS_DDL_06 splitStatements:false
--preconditions onFail:HALT onError:HALT

BEGIN 
dbms_scheduler.disable1_calendar_check();
dbms_scheduler.create_schedule('"SCHEDULER_EGF_ARCHIVE"',TO_TIMESTAMP_TZ('26-JUL-2023 11.41.02.502582000 AM +00:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
'FREQ=DAILY;BYTIME=220100',
NULL,
NULL
);
COMMIT; 
END; 
--changeset Swetha.H:HISTORYS_DDL_06_2 splitStatements:false
--preconditions onFail:HALT onError:HALT

BEGIN 
dbms_scheduler.disable1_calendar_check();
dbms_scheduler.create_schedule('"SCHEDULER_INSTANCE_ARCHIVE"',TO_TIMESTAMP_TZ('26-JUL-2023 11.41.05.190466000 AM +00:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
'FREQ=DAILY;BYTIME=230100',
NULL,
NULL
);
COMMIT; 
END; 
