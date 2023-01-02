CREATE OR REPLACE PROCEDURE GRANT_MANAGER_ACCESS
AS
BEGIN
FOR r IN (
SELECT ELNAME
FROM EMPLOYEE
WHERE UPPER(DESIGNATION) = 'MANAGER'
)
LOOP
EXECUTE IMMEDIATE 'create user ' || r.ELNAME || ' identified by NEUFall2022#';
EXECUTE IMMEDIATE 'GRANT CONNECT TO '|| r.ELNAME;
EXECUTE IMMEDIATE 'grant create session to '|| r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON CUSTOMER TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON EMPLOYEE TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON INVOICE_ORDER TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON INVOICE_ORDER_DETAILS TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON PAYMENT_DETAILS TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON PAYMENT_TYPE TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON PRODUCT TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON RETURN_INVOICE TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON STORE TO ' || r.ELNAME;
EXECUTE IMMEDIATE 'GRANT SELECT ON STORE_STOCK TO ' || r.ELNAME;

END LOOP;
END;