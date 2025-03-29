-- Create a test table
CREATE TABLE TEST_TABLE (
    ID NUMBER(10) PRIMARY KEY,
    NAME VARCHAR2(50) NOT NULL
);

-- Insert a test row
INSERT INTO TEST_TABLE (ID, NAME) VALUES (1, 'Test Name');

-- Commit the transaction
COMMIT;
