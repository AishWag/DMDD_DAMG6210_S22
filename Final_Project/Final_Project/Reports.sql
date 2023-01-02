- CUSTOMER_VIEW

CREATE OR REPLACE VIEW CUSTOMER_VIEW AS

with x as (
SELECT c.customer_id, c.customerfname, max(order_date)last_purchase_date, count(distinct invoice_id) noofbills
FROM CUSTOMER C
JOIN invoice_order I ON I.CUSTOMER_ID = c.Customer_Id 
group by c.customer_id, c.customerfname )
SELECT C.CUSTOMER_ID, C.CUSTOMERFNAME, C.CUSTOMERLNAME, C.DOB, C.GENDER, C.MOBILE, C.STREET, C.CITY, C.STATE, C.ZIP_CODE, C.EMAIL,
COUNT(INV_OR.CUSTOMER_ID) as LIFETIME_VISITS,
SUM(INV_OR.SALE_AMT) as LIFETIME_SALES,
COUNT(INV_OR.INVOICE_ID) as LIFETIME_INVOICES,
COUNT(inv_or.invoice_id)/COUNT(inv_or_d.quantity) AS ABS,
ROUND(SUM(inv_or.sale_amt)/COUNT(inv_or.invoice_id),2) AS ABV,
(CASE WHEN ROUND(SUM(inv_or.sale_amt)/COUNT(inv_or.invoice_id),2) > 100 THEN 'GOLD' WHEN ROUND(SUM(inv_or.sale_amt)/COUNT(inv_or.invoice_id),2) < 100 AND ROUND(SUM(inv_or.sale_amt)/COUNT(inv_or.invoice_id),2) > 50 THEN 'SILVER' WHEN ROUND(SUM(inv_or.sale_amt)/COUNT(inv_or.invoice_id),2) < 50 THEN 'BRONZE' END ) AS CUSTOMERSEGMENTATION,
recency,
frequency
FROM CUSTOMER C
JOIN INVOICE_ORDER INV_OR ON C.CUSTOMER_ID = INV_OR.CUSTOMER_ID
JOIN INVOICE_ORDER_DETAILS INV_OR_D ON INV_OR.INVOICE_ID = INV_OR_D.INVOICE_ID
JOIN
    (select X.customer_id, 
    case when 
    (10-EXTRACT(month FROM X.last_purchase_date)) > 1 then  (10-EXTRACT(month FROM X.last_purchase_date)) 
    else 1 end recency,
    case when 
    X.noofbills > 1 then X.noofbills else 1 end frequency
    from x
    ) AA ON AA.customer_id = C.customer_id
GROUP BY C.CUSTOMER_ID, C.CUSTOMERFNAME, C.CUSTOMERLNAME, C.DOB, C.GENDER, C.MOBILE, C.STREET, C.CITY, C.STATE, C.ZIP_CODE, C.EMAIL,recency,
frequency
ORDER BY C.CUSTOMER_ID;


- PRODUCT_VIEW

CREATE OR REPLACE VIEW PRODUCT_VIEW AS 
SELECT P.*,SUM(UNIT_PRICE) as TOTAL_REVENUE, 
SUM(CASE WHEN EXTRACT(year from i.order_date) =  EXTRACT(year from sysdate)-1 THEN UNIT_PRICE END) as TOTAL_REVENUE_LY,
SUM(CASE WHEN EXTRACT(year from i.order_date) =  EXTRACT(year from sysdate) THEN UNIT_PRICE END) as TOTAL_REVENUE_TY,
SUM(CASE WHEN EXTRACT(year from i.order_date) =  EXTRACT(year from sysdate)-1 THEN IOT.INVOICE_ID END) as INVOICES_LY,
SUM(CASE WHEN EXTRACT(year from i.order_date) =  EXTRACT(year from sysdate) THEN IOT.INVOICE_ID END) as INVOICES_TY,
(CASE WHEN SUM(UNIT_PRICE) > 100 THEN 'GOLD' WHEN SUM(UNIT_PRICE) < 100  AND SUM(UNIT_PRICE) > 50 THEN 'SILVER' WHEN SUM(UNIT_PRICE) < 50 THEN 'BRONZE' END ) AS PRODUCTSEGMENTATION 
FROM PRODUCT P
JOIN INVOICE_ORDER_DETAILS IOT on P.PRODUCT_ID = IOT.PRODUCT_ID 
JOIN INVOICE_ORDER I on IOT.INVOICE_ID = I.INVOICE_ID 
GROUP BY P.PRODUCT_ID, P.PRODUCT_CATEGORY_ID, P.CATEGORY_NAME, P.DESCRIPTION, P.PRODUCT_NAME, P.PRODUCT_PRICE, P.BATCH_NO, P.EXPIRY_DATE;

- STORE_SALES_VIEW

CREATE OR REPLACE VIEW STORE_VIEW AS 
SELECT S.*, sum(sale_amt) as total_revenue, 
SUM(CASE WHEN EXTRACT(year from order_date) =  EXTRACT(year from sysdate)-1 ThEN sale_amt END) as TOTAL_REVENUE_LY,
SUM(CASE WHEN EXTRACT(year from order_date) =  EXTRACT(year from sysdate) ThEN sale_amt END) as TOTAL_REVENUE_TY 
FROM STORE S
JOIN invoice_order inv_or on inv_or.store_id = s.store_id
group by s.store_id, s.store_name, s.city, s.mgrid
order by s.store_id;


create view temp as
select store_id, Store_name, Prod_Name, rn
from
(
with a as(
select  s.store_id, s.Store_name,  p.Description Prod_Name , sum(o.quantity) no_of_items
from store s 
left join invoice_order i on s.store_id = i.store_id
join  invoice_order_details o on i.invoice_id = o.invoice_id
join product p on p.product_id = o.product_id
group by   s.store_id, s.Store_name, p.Description )
select a.*, row_number() over(partition by Store_id order by no_of_items desc) rn
from a
) x
where rn < 4;

--- FINAL STORE VIEW
select s.* , ( select prod_name from temp t where t.store_id = s.store_id and rn = 1) Most_Sold_Product_1,
( select prod_name from temp t where t.store_id = s.store_id and rn = 2) Most_Sold_Product_2,
( select prod_name from temp t where t.store_id = s.store_id and rn = 3) Most_Sold_Product_3
from store_view s 


