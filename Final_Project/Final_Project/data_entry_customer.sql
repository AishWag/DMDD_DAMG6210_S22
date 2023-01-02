create or replace procedure data_entry_customer (
p_customer_id in customer.CUSTOMER_ID%type,
p_customer_fname in customer.customerfname%type,
p_customer_lname in customer.customerlname%type,
p_dob in customer.dob%TYPE,
p_gender in customer.gender%type,
p_mobile in customer.mobile%type,
p_street in customer.street%type,
p_city in customer.city%type,
p_state in customer.state%type,
p_zip in customer.zip_code%type,
p_email in customer.email%type)



as
BEGIN
IF (p_customer_fname IS NULL
OR p_customer_lname IS NULL
OR p_mobile IS NULL
OR p_street IS NULL
OR p_city IS NULL
OR p_state IS NULL
OR p_email IS NULL)
then
RAISE_APPLICATION_ERROR(-20000,'Cannot be null!!');
ELSE
insert into customer("CUSTOMER_ID","CUSTOMERFNAME","CUSTOMERLNAME","DOB","GENDER","MOBILE","STREET","CITY","STATE","ZIP_CODE","EMAIL")
values(p_customer_id,p_customer_fname,p_customer_lname,p_dob,p_gender,p_mobile,p_street,p_city,p_state,p_zip,p_email);
end if;
commit;

end;