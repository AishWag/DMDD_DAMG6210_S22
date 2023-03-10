CREATE OR REPLACE PROCEDURE GRANT_EMPLOYEE_ACCESS
AS
BEGIN
FOR E IN (
SELECT ELNAME
FROM EMPLOYEE
WHERE UPPER(DESIGNATION) = 'EMPLOYEE'
)
LOOP
EXECUTE IMMEDIATE 'create user ' || E.ELNAME || ' identified by NEUEmploye2022#';
EXECUTE IMMEDIATE 'GRANT CONNECT TO '|| E.ELNAME;
EXECUTE IMMEDIATE 'grant create session to '|| E.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON INVOICE_ORDER TO ' || E.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON INVOICE_ORDER_DETAILS TO ' || E.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON STORE_VIEW TO ' || E.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON STORE_STOCK TO ' || E.ELNAME;
END LOOP;
END;