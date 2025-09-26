Create database Cleaned_northwind;
use cleaned_northwind;
-- 1
 create table cl_customers(
id int,
company varchar(50),
last_name varchar(50), 
first_name varchar(50), 
email_address varchar(100), 
job_title varchar(50),
business_phone varchar(25), 
home_phone varchar(25),
mobile_phone varchar(25),
fax_number varchar(25),
address varchar(100),
city varchar(50),
state_province varchar(50), 
zip_postal_code varchar(15), 
country_region varchar(50) ,
web_page longtext,
notes longtext,
attachments longblob
);

INSERT INTO cl_customers(
id,
company,
last_name, 
first_name, 
email_address, 
job_title,
business_phone, 
home_phone,
mobile_phone,
fax_number,
address,
city,
state_province, 
zip_postal_code, 
country_region,
web_page,
notes,
attachments
)

select 
id ,
case 
when company = "company AA" then "Company A"
when company = "company BB" then "Company B"
when company = "company CC" then "Company C" 
else company 
END AS company,
last_name, 
first_name, 
email_address, 
job_title,
CONCAT('+1', business_phone),
CONCAT('+1', home_phone),
mobile_phone,
fax_number,
address,
city,
state_province, 
zip_postal_code, 
country_region,
web_page,
notes,
attachments 
from northwind_staging.customers ;
-------------------------------------------------------------------------------------------------------------------------------------------
-- 2 
create table cl_employee(
id int ,
company varchar(50) ,
last_name varchar(50) ,
first_name varchar(50) ,
email_address varchar(50) ,
job_title varchar(50) ,
business_phone varchar(25) ,
home_phone varchar(25) ,
mobile_phone varchar(25) ,
fax_number varchar(25) ,
address longtext ,
city varchar(50) ,
state_province varchar(50) ,
zip_postal_code varchar(15) ,
country_region varchar(50) ,
web_page longtext ,
notes longtext ,
attachments longblob
);



INSERT INTO cl_employee(
select
id,
company,
last_name, 
first_name, 
email_address, 
job_title,
concat('+1',business_phone), 
concat('+1',home_phone),
mobile_phone,
concat('+1',fax_number),
address,
city,
state_province, 
zip_postal_code, 
country_region,
case 
when web_page = "#http://northwindtraders.com#" then "http://northwindtraders.com"
else "http://northwindtraders.com"
END AS web_page,
notes,
attachments
from northwind_staging.employee );



-------------------------------------------------------------------------------------------------------------------------------------------
-- 3 
create table cl_employee_privileges(
employee_id int ,
privilege_id int
);

 insert into cl_employee_privileges (
  employee_id,
 privilege_id)
 select  employee_id,
 privilege_id
 from (
select ps.* ,
			row_number() over(partition by employee_id order by employee_id) as rn 
            from northwind_staging.employee_privileges ps
            where employee_id is not null and employee_id != '') t
            where rn = 1;
-------------------------------------------------------------------------------------------------------------------------------------------
-- 4 
create table cl_inventory_transaction_types(
id tinyint ,
type_name varchar(50)
);

insert into cl_inventory_transaction_types(
select 
id,
type_name
from northwind_staging.inventory_transaction_types
);

-------------------------------------------------------------------------------------------------------------------------------------------
-- 5
create table cl_inventory_transactions(
id int,
transaction_type tinyint ,
transaction_created_date date ,
transaction_created_time time ,
transaction_modified_date date ,
transaction_modified_time time ,
product_id int ,
quantity int ,
purchase_order_id int ,
customer_order_id int ,
comments varchar(255)
);

insert into cl_inventory_transactions(
select 
id,
transaction_type,
date(transaction_created_date),
time(transaction_created_date),
date(transaction_modified_date),
time(transaction_modified_date),
product_id,
quantity,
purchase_order_id,
customer_order_id,
comments
from northwind_staging.inventory_transactions
);
-------------------------------------------------------------------------------------------------------------------------------------------
-- 6
create Table cl_invoices (
id int ,
order_id int ,
invoice_date date ,
invoice_time time ,
due_date datetime,
tax decimal(19,4) ,
shipping decimal(19,4),
amount_due decimal(19,4)
);

insert into cl_invoices(
select 
id,
order_id,
DATE(invoice_date),
TIME(invoice_date),
due_date,
tax,
shipping,
amount_due
from northwind_staging.invoices
);
-------------------------------------------------------------------------------------------------------------------------------------------
-- 7  not now 
create Table cl_order_details (
id int ,
order_id int ,
product_id int, 
quantity int ,
unit_price decimal(19,4), 
discount double ,
status_id int ,
date_allocated datetime ,
purchase_order_id int ,
inventory_id int
);

insert into cl_order_details(
select 
id,
order_id,
product_id, 
case when quantity = 0 then (SELECT AVG(quantity) 
                                FROM northwind.order_details)
else quantity
end,
unit_price, 
discount,
status_id,
date_allocated,
purchase_order_id,
inventory_id
from northwind_staging.order_details
); 

-------------------------------------------------------------------------------------------------------------------------------------------
-- 8 
create Table cl_order_details_status(
id int  ,
status_name varchar(50)
);

insert into cl_order_details_status(
select 
id,
status_name
from northwind_staging.order_details_status
); 

-------------------------------------------------------------------------------------------------------------------------------------------
-- 9 
create Table cl_orders (
id int ,
employee_id int ,
customer_id int ,
order_date date ,
order_time time ,
shipped_date date ,
shipped_time time ,
shipper_id int ,
ship_name varchar(50) ,
ship_address longtext ,
ship_city varchar(50) ,
ship_state_province varchar(50) ,
ship_zip_postal_code varchar(50) ,
ship_country_region varchar(50) ,
shipping_fee decimal(19,4) ,
taxes decimal(19,4) ,
payment_type varchar(50) ,
paid_date date ,
paid_time time ,
notes longtext ,
tax_rate double ,
tax_status_id tinyint ,
status_id tinyint
);

insert into cl_orders(
select 
id,
employee_id,
customer_id,
date(order_date),
time(order_date),
date(shipped_date),
time(shipped_date),
shipper_id,
ship_name,
ship_address,
ship_city,
ship_state_province,
ship_zip_postal_code,
ship_country_region,
shipping_fee,
taxes,
payment_type,
date(paid_date),
time(paid_date),
notes,
tax_rate,
tax_status_id,
status_id
from northwind_staging.orders
); 


-------------------------------------------------------------------------------------------------------------------------------------------
-- 10
create Table cl_orders_status (
id tinyint  ,
status_name varchar(50)
);

insert into cl_orders_status(
select 
id,
status_name
from northwind_staging.orders_status
); 

-------------------------------------------------------------------------------------------------------------------------------------------
-- 11  
create table cl_orders_tax_status(

id tinyint ,
tax_status_name varchar(50)
);
 
 insert into cl_orders_tax_status(
select 
id,
tax_status_name
from northwind_staging.orders_tax_status
); 
 -------------------------------------------------------------------------------------------------------------------------------------------
-- 12
create table cl_privileges(
id int ,
privilege_name varchar(50)
);

 insert into cl_privileges(
select 
id,
privilege_name
from northwind_staging.privileges
); 
------------------------------------------------------------------------------------------------------------------------------------------
-- 13
create table cl_products(
supplier_ids longtext ,
id int ,
product_code varchar(25) ,
product_name varchar(50) ,
description longtext ,
standard_cost decimal(19,4) ,
list_price decimal(19,4), 
reorder_level int ,
target_level int ,
quantity_per_unit varchar(50) ,
discontinued tinyint ,
minimum_reorder_quantity int, 
category varchar(50),
attachments longblob
);

 insert into cl_products(
select 
supplier_ids,
id,
product_code,
product_name,
description,
standard_cost,
list_price,
reorder_level,
target_level,
case 
when quantity_per_unit is null then 0 
else quantity_per_unit 
end,
discontinued,
case 
when minimum_reorder_quantity is null then 0 
else minimum_reorder_quantity 
end, 
category,
attachments
from northwind_staging.products
); 


-------------------------------------------------------------------------------------------------------------------------------------------
-- 14
create table cl_purchase_order_details(
id int ,
purchase_order_id int ,
product_id int ,
quantity decimal(18,4) ,
unit_cost decimal(19,4) ,
date_received date,
time_received time ,
posted_to_inventory tinyint,
inventory_id int
);

insert into cl_purchase_order_details(
select 
id,
purchase_order_id,
product_id,
quantity,
unit_cost,
date(date_received),
time(date_received),
posted_to_inventory,
inventory_id
from northwind_staging.purchase_order_details
);

-------------------------------------------------------------------------------------------------------------------------------------------
-- 15
create table cl_purchase_order_status(
id int, 
status varchar(50)
);

 insert into cl_purchase_order_status(
select 
id, 
status
from northwind_staging.purchase_order_status
); 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 16
create table cl_purchase_orders(
id int ,
supplier_id int ,
created_by int ,
submitted_date date,
submitted_time time ,
creation_date date,
creation_time time ,
status_id int ,
expected_date datetime,
shipping_fee decimal(19,4) ,
taxes decimal(19,4) ,
payment_date datetime ,
payment_amount decimal(19,4) ,
payment_method varchar(50) , 
notes longtext ,
approved_by int ,
approved_date date ,
approved_time time ,
submitted_by int
 );
 
insert into cl_purchase_orders(
select 
id,
supplier_id,
created_by,
date(submitted_date),
time(submitted_date),
date(creation_date),
time(creation_date),
status_id,
expected_date,
shipping_fee,
taxes,
payment_date,
payment_amount,
payment_method, 
notes,
approved_by,
date(approved_date),
time(approved_date),
submitted_by
from northwind_staging.purchase_orders
); 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 17 
 create table cl_sales_reports(
group_by varchar(50),
display varchar(50) ,
title varchar(50) ,
filter_row_source longtext ,
`default` TINYINT
);

  insert into cl_sales_reports(
select 
group_by,
display,
title,
filter_row_source,
`default`
from northwind_staging.sales_reports
); 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 18
create table cl_shippers(
id int ,
company varchar(50) ,
last_name varchar(50) ,
first_name varchar(50) ,
email_address varchar(50) ,
job_title varchar(50) ,
business_phone varchar(25) ,
home_phone varchar(25) ,
mobile_phone varchar(25) ,
fax_number varchar(25) ,
address longtext ,
city varchar(50) ,
state_province varchar(50) ,
zip_postal_code varchar(15) ,
country_region varchar(50) ,
web_page longtext ,
notes longtext ,
attachments longblob
);

insert into cl_shippers(
select 
id,
company,
last_name,
first_name,
email_address,
job_title,
business_phone,
home_phone,
mobile_phone,
fax_number,
address,
city,
state_province,
zip_postal_code,
country_region,
web_page,
notes,
attachments
from northwind_staging.shippers
); 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 19 
create table cl_strings(
string_id int ,
string_data varchar(255)
);

insert into cl_strings(
select 
string_id,
string_data
from northwind_staging.strings
); 
-------------------------------------------------------------------------------------------------------------------------------------------
-- 20
 create table cl_suppliers(
 id int ,
company varchar(50) ,
last_name varchar(50) ,
first_name varchar(50) ,
email_address varchar(50) ,
job_title varchar(50) ,
business_phone varchar(25) ,
home_phone varchar(25) ,
mobile_phone varchar(25) ,
fax_number varchar(25) ,
address longtext ,
city varchar(50) ,
state_province varchar(50) ,
zip_postal_code varchar(15) ,
country_region varchar(50) ,
web_page longtext ,
notes longtext ,
attachments longblob
);

insert into cl_suppliers(
select 
id,
company,
last_name,
first_name,
email_address,
job_title,
business_phone,
home_phone,
mobile_phone,
fax_number,
address,
city,
state_province,
zip_postal_code,
country_region,
web_page,
notes,
attachments
from northwind_staging.suppliers
);
------------------------------------------------------------------------
-- end 