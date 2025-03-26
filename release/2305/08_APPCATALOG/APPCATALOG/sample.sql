CREATE TABLE galaxy_users (
    user_id       NUMBER PRIMARY KEY,
    user_name     VARCHAR2(50),
    email         VARCHAR2(100),
    created_date  DATE DEFAULT SYSDATE
);
 
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (1, 'John Doe', 'john.doe@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (2, 'Jane Smith', 'jane.smith@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (3, 'Arun Kumar', 'arun.kumar@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (4, 'Venkata Ramana', 'venkata.ramana@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (5, 'Priya Sharma', 'priya.sharma@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (6, 'Anil Reddy', 'anil.reddy@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (7, 'Kavitha Rao', 'kavitha.rao@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (8, 'Rahul Mehra', 'rahul.mehra@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (9, 'Sita Devi', 'sita.devi@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (10, 'Ravi Shankar', 'ravi.shankar@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (11, 'Deepak Joshi', 'deepak.joshi@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (12, 'Aishwarya Patel', 'aishwarya.patel@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (13, 'Manoj Kumar', 'manoj.kumar@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (14, 'Sunita Rani', 'sunita.rani@example.com');
INSERT INTO galaxy_users (user_id, user_name, email) VALUES (15, 'Gaurav Verma', 'gaurav.verma@example.com');
 
COMMIT;