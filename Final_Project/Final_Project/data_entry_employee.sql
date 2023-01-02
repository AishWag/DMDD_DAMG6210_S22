create or replace procedure data_entry_employee (
p_emp_id in employee.emp_id%type,
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
p_zip_code in employee.zip_code%type)

as
BEGIN
IF (p_emp_id IS NULL
OR p_efname IS NULL
OR p_elname IS NULL
OR p_dob IS NULL
OR p_gender IS NULL
OR p_ssn IS NULL
OR p_DESIGNATION IS NULL
OR p_sal IS NULL
OR p_address IS NULL
OR p_city IS NULL
OR p_state IS NULL
OR p_zip_code IS NULL)
then

RAISE_APPLICATION_ERROR(-20000,'Cannot be null!!');
ELSE

insert into EMPLOYEE("EMP_ID","STORE_ID","EFNAME","ELNAME","DOB","GENDER","SSN","DESIGNATION","SAL","ADDRESS","CITY","STATE","ZIP_CODE")
values(p_emp_id,p_STORE_ID,p_efname,p_elname,p_dob,p_gender,p_ssn,p_DESIGNATION,p_sal,p_address,p_city,p_state,p_zip_code);

end if;
--commit;
end;