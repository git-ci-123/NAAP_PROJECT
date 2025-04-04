--liquibase formatted sql
--changeset Swetha.H:GALAXY_SHIELD_DDL_02_1 splitStatements:false
--preconditions onFail:HALT onError:HALT


  CREATE OR REPLACE EDITIONABLE PROCEDURE MY_PROC (param1        IN     VARCHAR2,
                                     outuserid        OUT VARCHAR2,
                                     outusername      OUT VARCHAR2,
                                     outusermsg       OUT VARCHAR2)
AS
BEGIN
    SELECT   usr_id, usr_login_id
      INTO   outuserid, outusername
      FROM   users
     WHERE   usr_id = param1;

    IF outusername = 'CPFE456'
    THEN
        outusermsg := 'Hari';
    ELSE
        outusermsg := 'vutukuri';
    END IF;
END my_proc;

--changeset Swetha.H:GALAXY_SHIELD_DDL_02_2 splitStatements:false
--preconditions onFail:HALT onError:HALT

create or replace PROCEDURE proc_image_insert(
    ip_vc_img      IN CLOB,
    ip_vc_user_id  IN NUMBER,
    ip_vc_response OUT CLOB
) IS

    l_raw        RAW(32767);
    l_n_count    NUMBER;
    l_offset     NUMBER := 1; -- Start reading from the beginning
    l_buffer     VARCHAR2(32767);
    l_chunk_size NUMBER := 32767; -- chunk size
    l_tmpblob    BLOB;
BEGIN
    SELECT
        COUNT(1)
    INTO l_n_count
    FROM
        user_profile
    WHERE
        usr_id = ip_vc_user_id;

    dbms_lob.createtemporary(l_tmpblob, false);
    -- Prepare to read from the CLOB in chunks
    LOOP
        l_buffer := dbms_lob.substr(ip_vc_img, l_chunk_size, l_offset);
        l_offset := l_offset + l_chunk_size;
        dbms_output.put_line(length(l_buffer));
        dbms_lob.writeappend(l_tmpblob, length(l_buffer) / 2, utl_raw.cast_to_raw(l_buffer));

        EXIT WHEN l_offset > dbms_lob.getlength(ip_vc_img); -- Exit when end of CLOB is reached
    END LOOP;

    IF l_n_count = 0 THEN
        INSERT INTO user_profile (
            user_profile_id,
            usr_id,
            user_image,
            created_by,
            created_date,
            modified_by,
            modified_date
        ) VALUES (
            seq_user_profile.NEXTVAL,
            ip_vc_user_id,
            l_tmpblob,
            (
                SELECT
                    USR_LOGIN_ID
                FROM
                    users
                WHERE
                    usr_id = ip_vc_user_id
            ),
            systimestamp,
            (
                SELECT
                    USR_LOGIN_ID
                FROM
                    users
                WHERE
                    usr_id = ip_vc_user_id
            ),
            systimestamp
        );

    END IF;
        -- Update existing user image
    IF l_n_count <> 0 THEN
        UPDATE user_profile
        SET
            user_image = l_tmpblob,
            modified_by = (
                SELECT
                    USR_LOGIN_ID
                FROM
                    users
                WHERE
                    usr_id = ip_vc_user_id
            ),
            modified_date = systimestamp
        WHERE
            usr_id = ip_vc_user_id;

    END IF;

    COMMIT;
    ip_vc_response := 'Success';
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        ip_vc_response := sqlerrm;
END proc_image_insert;