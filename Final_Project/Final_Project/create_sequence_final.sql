create or replace PROCEDURE CREATE_SEQ AS

BEGIN

-- PRODUCT

EXECUTE IMMEDIATE 'CREATE SEQUENCE PRODUCT_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';



-- STORE 

EXECUTE IMMEDIATE 'CREATE SEQUENCE STORE_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';



-- STORE_STOCK

EXECUTE IMMEDIATE 'CREATE SEQUENCE STORE_STOCK_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- EMPLOYEE

EXECUTE IMMEDIATE 'CREATE SEQUENCE EMP_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- CUSTOMER

EXECUTE IMMEDIATE 'CREATE SEQUENCE CUSTOMER_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- PAYMENT_TYPE

EXECUTE IMMEDIATE 'CREATE SEQUENCE PAY_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- PAYMENT_DETAILS

EXECUTE IMMEDIATE 'CREATE SEQUENCE PAYMENT_NO_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- INVOICE_ORDER

EXECUTE IMMEDIATE 'CREATE SEQUENCE INVOICE_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- INVOICE_ORDER_DETAILS

EXECUTE IMMEDIATE 'CREATE SEQUENCE INVOICE_LINE_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';


-- RETURN INVOICE

EXECUTE IMMEDIATE 'CREATE SEQUENCE RETURN_INVOICE_ID_SEQ START WITH 1 INCREMENT by 1 NOMAXVALUE';

END;

