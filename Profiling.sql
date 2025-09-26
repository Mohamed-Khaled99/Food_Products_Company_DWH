use northwind_staging;
-- Customer Porfiling 
-- Check duplicates
select * 
from customers
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from customers )t
	where rn > 1 );
 
 -- check for null or spaces 
 
select * 
from customers
where length(substring_index(company," ", -1))>1;

select * 
from customers 
where company !=  trim(company) or trim(company) = '' or trim(company) IS null; 

select * 
from customers 
where last_name !=  trim(last_name) or trim(last_name) = '' or trim(last_name) IS null; 

select * 
from customers 
where first_name !=  trim(first_name) or trim(first_name) = '' or trim(first_name) IS null; 

select * 
from customers 
where job_title !=  trim(job_title) or trim(job_title) = '' or trim(job_title) IS null; 

select * 
from customers 
where business_phone !=  trim(business_phone) or trim(business_phone) = '' or trim(business_phone) IS null; 

select * 
from customers 
where address !=  trim(address) or trim(address) = '' or trim(address) IS null; 

select * 
from customers 
where city !=  trim(city) or trim(city) = '' or trim(city) IS null; 

select distinct city 
from customers ;

select * 
from customers 
where state_province !=  trim(state_province) or trim(state_province) = '' or trim(state_province) IS null; 

select distinct state_province 
from customers;


select * 
from customers 
where zip_postal_code !=  trim(zip_postal_code) or trim(zip_postal_code) = '' or trim(zip_postal_code) IS null;

select * 
from customers 
where country_region !=  trim(country_region) or trim(country_region) = '' or trim(country_region) IS null;

---------------------------------------------------------------------------------------------------------
-- Employee Porfiling 
-- Check duplicates
select * 
from employee
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from employee )t
	where rn > 1 );
    
    -- check for null or spaces 
select * 
from employee
where company !=  trim(company) or trim(company) = '' or trim(company) IS null; 

select * 
from employee 
where last_name !=  trim(last_name) or trim(last_name) = '' or trim(last_name) IS null; 

select * 
from employee 
where first_name !=  trim(first_name) or trim(first_name) = '' or trim(first_name) IS null;

select * 
from employee 
where email_address !=  trim(email_address) or trim(email_address) = '' or trim(email_address) IS null;

SELECT 
    id,
    first_name,
    last_name,
    email_address
FROM employee
WHERE TRIM(LOWER(email_address)) NOT LIKE CONCAT(LOWER(TRIM(first_name)),'@northwindtraders.com')
AND first_name != '';

select * 
from employee 
where job_title !=  trim(job_title) or trim(job_title) = '' or trim(job_title) IS null;

select * 
from employee 
where business_phone !=  trim(business_phone) or trim(business_phone) = '' or trim(business_phone) IS null;

select * 
from employee 
where fax_number !=  trim(fax_number) or trim(fax_number) = '' or trim(fax_number) IS null;


select * 
from employee 
where address !=  trim(address) or trim(address) = '' or trim(address) IS null;

select * 
from employee 
where city !=  trim(city) or trim(city) = '' or trim(city) IS null;

select distinct city
from employee ;

select * 
from employee 
where state_province !=  trim(state_province) or trim(state_province) = '' or trim(state_province) IS null;

select distinct state_province
from employee ;

select * 
from employee 
where zip_postal_code !=  trim(zip_postal_code) or trim(zip_postal_code) = '' or trim(zip_postal_code) IS null;

select * 
from employee 
where country_region !=  trim(country_region) or trim(country_region) = '' or trim(country_region) IS null;

select * 
from employee 
where web_page !=  trim(web_page) or trim(web_page) = '' or trim(web_page) IS null;

---------------------------------------------------------------------------------------------------------
-- employee_privileges Porfiling 
-- Check duplicates
select * 
from employee_privileges
where privilege_id in(
	select privilege_id 
	from (
			select employee_id, 
					row_number() over(partition by employee_id order by employee_id desc) as rn 
			from employee_privileges )t
	where rn > 1 );


select *
from employee_privileges
where privilege_id in(
	select privilege_id 
	from (
			select privilege_id, 
					row_number() over(partition by privilege_id order by privilege_id desc) as rn 
			from employee_privileges )t
	where rn > 1 );
    

---------------------------------------------------------------------------------------------------------
-- inventory_transaction_types Porfiling 
-- Check duplicates

select * 
from inventory_transaction_types
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from inventory_transaction_types )t
	where rn > 1 );

select * 
from inventory_transaction_types 
where type_name !=  trim(type_name) or trim(type_name) = '' or trim(type_name) IS null;

select distinct type_name
from inventory_transaction_types ;

---------------------------------------------------------------------------------------------------------
-- inventory_transactions Porfiling 
-- Check duplicates
  
  select * 
from inventory_transactions
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from inventory_transactions )t
	where rn > 1 );
    
   select * 
from inventory_transactions 
where transaction_type !=  trim(transaction_type) or trim(transaction_type) = '' or trim(transaction_type) IS null;

select distinct transaction_type
from inventory_transactions ; 
    
select * 
from inventory_transactions 
where transaction_created_date !=  trim(transaction_created_date) or trim(transaction_created_date) = '' or trim(transaction_created_date) IS null;
    
select * 
from inventory_transactions 
where transaction_modified_date !=  trim(transaction_modified_date) or trim(transaction_modified_date) = '' or trim(transaction_modified_date) IS null;
    
select * 
from inventory_transactions 
where product_id !=  trim(product_id) or trim(product_id) = '' or trim(product_id) IS null;

select * 
from inventory_transactions 
where quantity !=  trim(quantity) or trim(quantity) = '' or trim(quantity) IS null;
    
---------------------------------------------------------------------------------------------------------
-- invoices Porfiling 
-- Check duplicates

  select * 
from invoices
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from invoices )t
	where rn > 1 );

  select * 
from invoices
where order_id in(
	select order_id 
	from (
			select order_id, 
					row_number() over(partition by order_id order by order_id desc) as rn 
			from invoices )t
	where rn > 1 );

select * 
from invoices 
where invoice_date !=  trim(invoice_date) or trim(invoice_date) = '' or trim(invoice_date) IS null;

select * 
from invoices 
where tax !=  trim(tax) or trim(tax) = '' or trim(tax) IS null;

select * 
from invoices 
where shipping !=  trim(shipping) or trim(shipping) = '' or trim(shipping) IS null;

select * 
from invoices 
where amount_due !=  trim(amount_due) or trim(amount_due) = '' or trim(amount_due) IS null;

---------------------------------------------------------------------------------------------------------
-- order_details Porfiling 
-- Check duplicates

  select * 
from order_details
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from order_details )t
	where rn > 1 );
    
 select * 
from order_details 
where order_id !=  trim(order_id) or trim(order_id) = '' or trim(order_id) IS null;

 select * 
from order_details 
where product_id !=  trim(product_id) or trim(product_id) = '' or trim(product_id) IS null;

 select * 
from order_details 
where quantity !=  trim(quantity) or trim(quantity) = '' or trim(quantity) IS nullor trim(quantity)=0;

 select * 
from order_details 
where unit_price !=  trim(unit_price) or trim(unit_price) = '' or trim(unit_price) IS nullor trim(unit_price)=0;

select distinct status_id
from order_details ; 

 select * 
from order_details 
where purchase_order_id !=  trim(purchase_order_id) or trim(purchase_order_id) = '' or trim(purchase_order_id) is null ;

 select * 
from order_details 
where inventory_id !=  trim(inventory_id) or trim(inventory_id) = '' or trim(inventory_id) is null ;
---------------------------------------------------------------------------------------------------------
-- order_details_status Porfiling 
-- Check duplicates
  select * 
from order_details_status
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from order_details_status )t
	where rn > 1 );
    
    select * 
from order_details_status 
where status_name !=  trim(status_name) or trim(status_name) = '' or trim(status_name) is null ;
    ---------------------------------------------------------------------------------------------------------
-- order_details_status Porfiling 
-- Check duplicate
  select * 
from orders
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from orders )t
	where rn > 1 );

    select * 
from orders 
where employee_id !=  trim(employee_id) or trim(employee_id) = '' or trim(employee_id) is null ;

    select * 
from orders 
where customer_id !=  trim(customer_id) or trim(customer_id) = '' or trim(customer_id) is null ;

    select * 
from orders 
where order_date !=  trim(order_date) or trim(order_date) = '' or trim(order_date) is null ;

    select * 
from orders 
where ship_name !=  trim(ship_name) or trim(ship_name) = '' or trim(ship_name) is null ;

    select * 
from orders 
where ship_address !=  trim(ship_address) or trim(ship_address) = '' or trim(ship_address) is null ;

    select * 
from orders 
where ship_city !=  trim(ship_city) or trim(ship_city) = '' or trim(ship_city) is null ;

    select * 
from orders 
where ship_state_province !=  trim(ship_state_province) or trim(ship_state_province) = '' or trim(ship_state_province) is null ;

select distinct ship_state_province 
from orders;

    select * 
from orders 
where ship_zip_postal_code !=  trim(ship_zip_postal_code) or trim(ship_zip_postal_code) = '' or trim(ship_zip_postal_code) is null ;

    select * 
from orders 
where ship_country_region !=  trim(ship_country_region) or trim(ship_country_region) = '' or trim(ship_country_region) is null ;

 select * 
from orders 
where shipping_fee !=  trim(shipping_fee) or trim(shipping_fee) = '' or trim(shipping_fee) is null;

 select * 
from orders 
where payment_type !=  trim(payment_type) or trim(payment_type) = '' or trim(payment_type) is null;

 select * 
from orders 
where paid_date !=  trim(paid_date) or trim(paid_date) = '' or trim(paid_date) is null;

 select * 
from orders 
where tax_rate !=  trim(tax_rate) or trim(tax_rate) = '' or trim(tax_rate) is null;

 select * 
from orders 
where status_id !=  trim(status_id) or trim(status_id) = '' or trim(status_id) is null;
    ---------------------------------------------------------------------------------------------------------
-- orders_status Porfiling 
-- Check duplicate
 select * 
from orders_status
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from orders_status )t
	where rn > 1 );
    
     select * 
from orders_status 
where status_name !=  trim(status_name) or trim(status_name) = '' or trim(status_name) is null;
---------------------------------------------------------------------------------------------------------
-- orders_tax_status Porfiling 
-- Check duplicate 
select * 
from orders_tax_status
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from orders_tax_status )t
	where rn > 1 );

     select * 
from orders_status 
where status_name !=  trim(status_name) or trim(status_name) = '' or trim(status_name) is null;
---------------------------------------------------------------------------------------------------------
-- privileges Porfiling 
-- Check duplicate
select * 
from privileges
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from privileges )t
	where rn > 1 );

     select * 
from privileges 
where privilege_name !=  trim(privilege_name) or trim(privilege_name) = '' or trim(privilege_name) is null;
---------------------------------------------------------------------------------------------------------
-- products Porfiling 
-- Check duplicate
select * 
from products
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from products )t
	where rn > 1 );

     select * 
from products 
where supplier_ids !=  trim(supplier_ids) or trim(supplier_ids) = '' or trim(supplier_ids) is null;

    select * 
from products 
where supplier_ids !=  trim(supplier_ids) or trim(supplier_ids) = '' or trim(supplier_ids) is null;

select distinct supplier_ids
from products;

    select * 
from products 
where product_code !=  trim(product_code) or trim(product_code) = '' or trim(product_code) is null;

select distinct product_code
from products;

   select * 
from products 
where standard_cost !=  trim(standard_cost) or trim(standard_cost) = '' or trim(standard_cost) is null;

   select * 
from products 
where standard_cost !=  trim(standard_cost) or trim(standard_cost) = '' or trim(standard_cost) is null or trim(standard_cost) = 0;

   select * 
from products 
where list_price !=  trim(list_price) or trim(list_price) = '' or trim(list_price) is null;

   select * 
from products 
where list_price !=  trim(list_price) or trim(list_price) = '' or trim(list_price) is null or trim(list_price) = 0;

    select * 
from products 
where reorder_level !=  trim(reorder_level) or trim(reorder_level) = '' or trim(reorder_level) is null;

    select * 
from products 
where target_level !=  trim(target_level) or trim(target_level) = '' or trim(target_level) is null;

    select * 
from products 
where quantity_per_unit !=  trim(quantity_per_unit) or trim(quantity_per_unit) = '' or trim(quantity_per_unit) is null;

    select * 
from products 
where discontinued !=  trim(discontinued) or trim(discontinued) = '' or trim(discontinued) is null;

    select * 
from products 
where minimum_reorder_quantity !=  trim(minimum_reorder_quantity) or trim(minimum_reorder_quantity) = '' or trim(minimum_reorder_quantity) is null;

select * 
from products 
where category !=  trim(category) or trim(category) = '' or trim(category) is null;

---------------------------------------------------------------------------------------------------------
-- purchase_order_details Porfiling 
-- Check duplicate
select * 
from purchase_order_details
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from purchase_order_details )t
	where rn > 1 );

select * 
from purchase_order_details 
where purchase_order_id !=  trim(purchase_order_id) or trim(purchase_order_id) = '' or trim(purchase_order_id) is null;

select * 
from purchase_order_details 
where product_id !=  trim(product_id) or trim(product_id) = '' or trim(product_id) is null;

select * 
from purchase_order_details 
where quantity !=  trim(quantity) or trim(quantity) = '' or trim(quantity) is null;

select * 
from purchase_order_details 
where unit_cost !=  trim(unit_cost) or trim(unit_cost) = '' or trim(unit_cost) is null or trim(unit_cost) = 0 ;

select * 
from purchase_order_details 
where date_received !=  trim(date_received) or trim(date_received) = '' or trim(date_received) is null;

select * 
from purchase_order_details 
where posted_to_inventory !=  trim(posted_to_inventory) or trim(posted_to_inventory) = '' or trim(posted_to_inventory) is null;

select * 
from purchase_order_details 
where inventory_id !=  trim(inventory_id) or trim(inventory_id) = '' or trim(inventory_id) is null;
---------------------------------------------------------------------------------------------------------
-- purchase_order_status Porfiling 
-- Check duplicate

select * 
from purchase_order_status
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from purchase_order_status )t
	where rn > 1 );

select * 
from purchase_order_status 
where status !=  trim(status) or trim(status) = '' or trim(status) is null;
---------------------------------------------------------------------------------------------------------
-- purchase_orders Porfiling  Ex 
-- Check duplicate

select * 
from purchase_orders
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from purchase_orders )t
	where rn > 1 );

select * 
from purchase_orders 
where supplier_id !=  trim(supplier_id) or trim(supplier_id) = '' or trim(supplier_id) is null;

select * 
from purchase_orders 
where created_by !=  trim(created_by) or trim(created_by) = '' or trim(created_by) is null;

select * 
from purchase_orders 
where submitted_date !=  trim(submitted_date) or trim(submitted_date) = '' or trim(submitted_date) is null;

select * 
from purchase_orders 
where creation_date !=  trim(creation_date) or trim(creation_date) = '' or trim(creation_date) is null;

select * 
from purchase_orders 
where status_id !=  trim(status_id) or trim(status_id) = '' or trim(status_id) is null;

select * 
from purchase_orders 
where approved_by !=  trim(approved_by) or trim(approved_by) = '' or trim(approved_by) is null;

select * 
from purchase_orders 
where approved_date !=  trim(approved_date) or trim(approved_date) = '' or trim(approved_date) is null;

select * 
from purchase_orders 
where submitted_by !=  trim(submitted_by) or trim(submitted_by) = '' or trim(submitted_by) is null;
---------------------------------------------------------------------------------------------------------
-- (sales_reports) Porfiling  Improtant 
----------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
-- shippers Porfiling   ex 
-- Check duplicate

select * 
from shippers
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from shippers )t
	where rn > 1 );

select * 
from shippers 
where company !=  trim(company) or trim(company) = '' or trim(company) is null;

select distinct company
from shippers;

select * 
from shippers 
where address !=  trim(address) or trim(address) = '' or trim(address) is null;

select * 
from shippers 
where city !=  trim(city) or trim(city) = '' or trim(city) is null;

select * 
from shippers 
where state_province !=  trim(state_province) or trim(state_province) = '' or trim(state_province) is null;

select * 
from shippers 
where zip_postal_code !=  trim(zip_postal_code) or trim(zip_postal_code) = '' or trim(zip_postal_code) is null;

select * 
from shippers 
where country_region !=  trim(country_region) or trim(country_region) = '' or trim(country_region) is null;

---------------------------------------------------------------------------------------------------------
-- strings Porfiling    
-- Check duplicate

select * 
from strings
where string_id in(
	select string_id 
	from (
			select string_id, 
					row_number() over(partition by string_id order by string_id desc) as rn 
			from strings )t
	where rn > 1 );

select * 
from strings 
where string_data !=  trim(string_data) or trim(string_data) = '' or trim(string_data) is null;

---------------------------------------------------------------------------------------------------------
-- strings Porfiling    EX
-- Check duplicate

select * 
from suppliers
where id in(
	select id 
	from (
			select id, 
					row_number() over(partition by id order by id desc) as rn 
			from suppliers )t
	where rn > 1 );
   
select * 
from suppliers 
where company !=  trim(company) or trim(company) = '' or trim(company) is null;

select distinct company
from suppliers ;

select * 
from suppliers 
where last_name !=  trim(last_name) or trim(last_name) = '' or trim(last_name) is null;

select * 
from suppliers 
where first_name !=  trim(first_name) or trim(first_name) = '' or trim(first_name) is null;

select * 
from suppliers 
where job_title !=  trim(job_title) or trim(job_title) = '' or trim(job_title) is null;
 
-- Done 
----------------------------------------------------------------------------------------------------------------------------




















