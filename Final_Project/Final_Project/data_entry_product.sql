create or replace procedure data_entry_product (
p_product_id in product.product_ID%type,
p_product_category_id in product.product_category_id%type,
p_category_name in product.category_name%type,
p_description in product.description%TYPE,
p_product_name in product.product_name%type,
p_product_price in product.product_price%type,
p_batch_no in product.batch_no%type,
p_expiry_date in product.expiry_date%type)

as
BEGIN
IF (p_product_id IS NULL
OR p_product_category_id IS NULL
OR p_category_name IS NULL
OR p_description IS NULL
OR p_product_name IS NULL
OR p_product_price IS NULL
OR p_batch_no IS NULL)

then

RAISE_APPLICATION_ERROR(-20000,'Cannot be null!!');
ELSE
insert into product("PRODUCT_ID","PRODUCT_CATEGORY_ID","CATEGORY_NAME","DESCRIPTION","PRODUCT_NAME","PRODUCT_PRICE","BATCH_NO","EXPIRY_DATE")
values(p_product_id,p_product_category_id,p_category_name,p_description,p_product_name,p_product_price,p_batch_no,p_expiry_date);
end if;
end;
