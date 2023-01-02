create or replace PACKAGE PKG_RETAIL_SYSTEM IS
    PROCEDURE ADD_DATA;
	PROCEDURE data_entry_product (
	p_product_category_id in product.product_category_id%type,
	p_category_name in product.category_name%type,
	p_description in product.description%TYPE,
	p_product_name in product.product_name%type,
	p_product_price in product.product_price%type,
	p_batch_no in product.batch_no%type,
	p_expiry_date in product.expiry_date%type);


	PROCEDURE data_entry_customer (
	p_customer_fname in customer.customerfname%type,
	p_customer_lname in customer.customerlname%type,
	p_dob in customer.dob%TYPE,
	p_gender in customer.gender%type,
	p_mobile in customer.mobile%type,
	p_street in customer.street%type,
	p_city in customer.city%type,
	p_state in customer.state%type,
	p_zip in customer.zip_code%type,
	p_email in customer.email%type);


	PROCEDURE data_entry_employee (
	p_STORE_ID in employee.store_id%type,
	p_efname in employee.efname%type,
	p_elname in employee.elname%type,
	p_dob in employee.dob%TYPE,
	p_gender in employee.gender%type,
	p_ssn in employee.ssn%type,
	p_DESIGNATION in employee.designation%type,
	p_sal in employee.sal%type,
	p_address in employee.address%type,
	p_city in employee.city%type,
	p_state in employee.state%type,
	p_zip_code in employee.zip_code%type);


	PROCEDURE create_store (
	p_store_name in store.store_name%type,
	p_city in store.city%type,
	p_mgrid in store.mgrid%TYPE);
	PROCEDURE GRANT_EMPLOYEE_ACCESS;
	PROCEDURE GRANT_MANAGER_ACCESS;
	FUNCTION CALC_EMP_SAL (SAL_DATE INVOICE_ORDER.ORDER_DATE%TYPE, E_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER;
	FUNCTION CALC_MGR_SAL (E_ID EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER;
	PROCEDURE TRANSACTION(STORE_ID int, t_a varray_product, t_b varray_quantity, CUSTOMER_ID int, P_ID NUMBER, ORDER_DATE DATE DEFAULT NULL, CRD_NO NUMBER DEFAULT NULL, CCEXP_DATE DATE DEFAULT NULL, CHEQ NUMBER DEFAULT NULL);
--	PROCEDURE RETURN_ORDER(INVOICE_ID NUMBER, RET_DATE DATE);
END PKG_RETAIL_SYSTEM;