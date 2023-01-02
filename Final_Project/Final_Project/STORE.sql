create or replace procedure create_store (
p_store_id in store.store_id%type,
p_store_name in store.store_name%type,
p_city in store.city%type,
p_mgrid in store.mgrid%TYPE)

as
cnt int;
BEGIN

IF
(p_store_id IS NULL
OR p_store_name IS NULL
OR p_city IS NULL
OR p_mgrid IS NULL)
then
RAISE_APPLICATION_ERROR(-20000,'Cannot be null value!!');
ELSE
select count(*) into cnt from employee where emp_id = p_mgrid;
if(cnt != 0)
then
insert into store("STORE_ID","STORE_NAME","CITY","MGRID")
values(p_store_id,p_store_name,p_city,p_mgrid);
else
raise_application_error(-20000,'Employee not present');
end if;
end if;
commit;
end;