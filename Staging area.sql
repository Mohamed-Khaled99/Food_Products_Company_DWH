create database northwind_Staging;
use northwind_staging;
create table northwind_staging.customers like northwind.customers ;
create table northwind_staging.employee_privileges like northwind.employee_privileges;
create table northwind_staging.employee like northwind.employees;
create table northwind_staging.inventory_transaction_types like northwind.inventory_transaction_types;
create table northwind_staging.inventory_transactions like northwind.inventory_transactions;
create table northwind_staging.invoices like northwind.invoices;
create table northwind_staging.order_details like northwind.order_details;
create table northwind_staging.order_details_status like northwind.order_details_status;
create table northwind_staging.orders like northwind.orders;
create table northwind_staging.orders_status like northwind.orders_status;
create table northwind_staging.orders_tax_status like northwind.orders_tax_status;
create table northwind_staging.privileges like northwind.privileges;
create table northwind_staging.products like northwind.products;
create table northwind_staging.purchase_order_details like northwind.purchase_order_details;
create table northwind_staging.purchase_order_status like northwind.purchase_order_status;
create table northwind_staging.purchase_orders like northwind.purchase_orders;
create table northwind_staging.sales_reports like northwind.sales_reports;
create table northwind_staging.shippers like northwind.shippers;
create table northwind_staging.strings like northwind.strings;
create table northwind_staging.suppliers like northwind.suppliers;


insert into northwind_staging.customers select * from northwind.customers;
insert into northwind_staging.employee select * from northwind.employees;
insert into northwind_staging.employee_privileges select * from northwind.employee_privileges;
insert into northwind_staging.inventory_transaction_types select * from northwind.inventory_transaction_types;
insert into northwind_staging.inventory_transactions select * from northwind.inventory_transactions;
insert into northwind_staging.invoices select * from northwind.invoices;
insert into northwind_staging.order_details select * from northwind.order_details;
insert into northwind_staging.order_details_status select * from northwind.order_details_status;
insert into northwind_staging.orders select * from northwind.orders;
insert into northwind_staging.orders_status select * from northwind.orders_status;
insert into northwind_staging.orders_tax_status select * from northwind.orders_tax_status;
insert into northwind_staging.privileges select * from northwind.privileges;
insert into northwind_staging.products select * from northwind.products;
insert into northwind_staging.purchase_order_details select * from northwind.purchase_order_details;
insert into northwind_staging.purchase_order_status select * from northwind.purchase_order_status;
insert into northwind_staging.purchase_orders select * from northwind.purchase_orders;
insert into northwind_staging.sales_reports select * from northwind.sales_reports;
insert into northwind_staging.shippers select * from northwind.shippers;
insert into northwind_staging.strings select * from northwind.strings;
insert into northwind_staging.suppliers select * from northwind.suppliers;

-- create table New_table as select * from northwind.customers; new way 