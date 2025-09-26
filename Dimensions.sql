create database northwind_dwh;
use northwind_dwh;
-- Date Dimension
CREATE TABLE Dim_date (
date_key INT PRIMARY KEY,
full_date DATE NOT NULL, 
day_of_week VARCHAR(10),
day_of_month INT,
day_of_year INT,
week_of_year INT,
month_num INT,
month_name VARCHAR(10),
quarter INT,	
year INT,
is_weekend BOOLEAN,
is_holiday BOOLEAN
);

INSERT INTO northwind_dwh.dim_date (
    date_key, full_date, day_of_week, day_of_month, day_of_year,
    week_of_year, month_num, month_name, quarter, year,
    is_weekend, is_holiday
)
SELECT
    UNIX_TIMESTAMP(d.dt) AS date_key, 
    d.dt,
    DAYNAME(d.dt),
    DAY(d.dt),
    DAYOFYEAR(d.dt),
    WEEKOFYEAR(d.dt),
    MONTH(d.dt),
    MONTHNAME(d.dt),
    QUARTER(d.dt),
    YEAR(d.dt),
    CASE WHEN DAYOFWEEK(d.dt) IN (1,7) THEN TRUE ELSE FALSE END,
    FALSE AS is_holiday
FROM (
    SELECT DISTINCT dt
    FROM (
        SELECT transaction_created_date AS dt FROM cleaned_northwind.cl_inventory_transactions
        UNION
        SELECT transaction_modified_date FROM cleaned_northwind.cl_inventory_transactions
        UNION
        SELECT invoice_date FROM cleaned_northwind.cl_invoices
        UNION
        SELECT order_date FROM cleaned_northwind.cl_orders
        UNION
        SELECT shipped_date FROM cleaned_northwind.cl_orders
        UNION
        SELECT paid_date FROM cleaned_northwind.cl_orders
        UNION
        SELECT date_received FROM cleaned_northwind.cl_purchase_order_details
        UNION
        SELECT submitted_date FROM cleaned_northwind.cl_purchase_orders
        UNION
        SELECT creation_date FROM cleaned_northwind.cl_purchase_orders
        UNION
        SELECT approved_date FROM cleaned_northwind.cl_purchase_orders
    ) AS all_dates
) AS d
WHERE d.dt >= '1970-01-01'
  AND NOT EXISTS (
      SELECT 1 FROM northwind_dwh.dim_date dd
      WHERE dd.full_date = d.dt
  );

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Time Dimension
CREATE TABLE Dim_time (
time_key INT PRIMARY KEY,
time_24hr TIME NOT NULL,
hour INT,
minute INT,
time_period VARCHAR(10), -- MORNING, AFTERNOON, EVENING, NIGHT
business_hours_flag BOOLEAN
);

-- DIM TIME
INSERT INTO northwind_dwh.dim_time (
    time_key, time_24hr, hour, minute, time_period, business_hours_flag
)
SELECT DISTINCT
    (HOUR(t.t)*100 + MINUTE(t.t)) AS time_key, 
    SEC_TO_TIME(HOUR(t.t)*3600 + MINUTE(t.t)*60) AS time_24hr, 
    HOUR(t.t) AS hour,
    MINUTE(t.t) AS minute,
    CASE
        WHEN HOUR(t.t) BETWEEN 6 AND 11 THEN 'MORNING'
        WHEN HOUR(t.t) BETWEEN 12 AND 16 THEN 'AFTERNOON'
        WHEN HOUR(t.t) BETWEEN 17 AND 20 THEN 'EVENING'
        ELSE 'NIGHT'
    END AS time_period,
    CASE WHEN HOUR(t.t) BETWEEN 9 AND 17 THEN TRUE ELSE FALSE END AS business_hours_flag
FROM (
    SELECT transaction_created_time AS t FROM cleaned_northwind.cl_inventory_transactions
    UNION ALL
    SELECT transaction_modified_time FROM cleaned_northwind.cl_inventory_transactions
    UNION ALL
    SELECT invoice_time FROM cleaned_northwind.cl_invoices
    UNION ALL
    SELECT order_time FROM cleaned_northwind.cl_orders
    UNION ALL
    SELECT shipped_time FROM cleaned_northwind.cl_orders
    UNION ALL
    SELECT paid_time FROM cleaned_northwind.cl_orders
    UNION ALL
    SELECT time_received FROM cleaned_northwind.cl_purchase_order_details
    UNION ALL
    SELECT submitted_time FROM cleaned_northwind.cl_purchase_orders
    UNION ALL
    SELECT creation_time FROM cleaned_northwind.cl_purchase_orders
    UNION ALL
    SELECT approved_time FROM cleaned_northwind.cl_purchase_orders
) t
WHERE t.t IS NOT NULL
AND NOT EXISTS (
    SELECT 1 
    FROM northwind_dwh.dim_time tt
    WHERE tt.time_key = (HOUR(t.t)*100 + MINUTE(t.t))
);

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Customers Dimension
Create Table Dim_Customers (
CustomersKey INT AUTO_INCREMENT PRIMARY KEY, 
id int,
first_name VARCHAR(50),
last_name VARCHAR(50),
full_name VARCHAR(100),
company varchar(50), 
job_title varchar(50),
business_phone varchar(25),
fax_number varchar(25),
city varchar(50),
state_province varchar(50) ,
zip_postal_code varchar(15) ,
country_region varchar(50),
effective_date DATE,
expiration_date DATE,
current_flag BOOLEAN DEFAULT TRUE,
UNIQUE KEY unique_Customer_current (id,current_flag)
);


INSERT INTO northwind_dwh.dim_customers (
    id, first_name, last_name, full_name,
    company, job_title, business_phone, fax_number, city, state_province,
    zip_postal_code, country_region, effective_date, expiration_date, current_flag
)
SELECT DISTINCT
    id,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) As Full_Name,
    company,
    job_title,
    business_phone,
    fax_number,
    city,
    state_province,
    zip_postal_code,
    country_region,
    CURDATE(),
    NULL,
    TRUE
FROM cleaned_northwind.cl_customers ;

--------------------------------------------------------------------------------------------------------------------------------------------
-- Employee Dimension 
CREATE TABLE Dim_Employee (
    EmployeeKey INT AUTO_INCREMENT PRIMARY KEY, 
    EmployeeID INT NOT NULL,
    Company VARCHAR(50)  ,
	FirstName  VARCHAR(50) NOT NULL ,
    LastName VARCHAR(50) NOT NULL,
    FullName VARCHAR(50) NOT NULL,
    address longtext,
    JobTitle VARCHAR(50) NOT NULL,
    BusinessPhone VARCHAR(50),
    HomePhone VARCHAR(50),
    FaxNumber VARCHAR(50),
    CountryRegion VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    StateProvince VARCHAR(50),
    ZipPostalCode VARCHAR(15),
	effective_date DATE,
	expiration_date DATE,
	current_flag BOOLEAN DEFAULT TRUE,
	UNIQUE KEY unique_employee_current (EmployeeID,current_flag)
	);
    
    
INSERT INTO northwind_dwh.Dim_Employee (
    EmployeeID , Company, FirstName, LastName, FullName,
    address, JobTitle, BusinessPhone, HomePhone, FaxNumber, CountryRegion,
    City, StateProvince, ZipPostalCode, effective_date, expiration_date, current_flag
)
SELECT DISTINCT
	id,
    Company,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name),
    address,
    job_title,
    business_phone,
    home_phone,
    fax_number,
    country_region,
    city,
    state_province,
    zip_postal_code,
    CURDATE(),
    NULL,
    TRUE
FROM cleaned_northwind.cl_employee ;

------------------------------------------------------------------------------------------------------------------------------------------------
-- Product Dimension
CREATE TABLE Dim_Product (
    ProductKey INT AUTO_INCREMENT PRIMARY KEY, -- surrogate key
    Product_ID INT,                             
    product_code VARCHAR(25),
    product_name VARCHAR(100),
    standard_cost DECIMAL(19,4),
    list_price DECIMAL(19,4),
    reorder_level INT,
    target_level INT,
    quantity_per_unit VARCHAR(50),
    discontinued TINYINT,
    category VARCHAR(50),
    supplier_ids VARCHAR(50)   
);

INSERT INTO northwind_dwh.dim_product (
    Product_ID , product_code, product_name, standard_cost, list_price,
    reorder_level, target_level, quantity_per_unit, discontinued, category, supplier_ids
)
SELECT DISTINCT
	id,
    product_code,
    product_name,
    standard_cost,
    list_price,
    reorder_level,
    target_level,
    quantity_per_unit,
    discontinued,
    category,
    supplier_ids
FROM cleaned_northwind.cl_products ;
------------------------------------------------------------------------------------------------------------------------------------------------
-- Suppliers Dimension
create table dim_suppliers(
 supplierKey INT AUTO_INCREMENT PRIMARY KEY,
 supplier_ID int,
Company  varchar(50),
FirstName varchar(50),
LastName varchar(50), 
FullName varchar(50),
job_title varchar(50)
);


INSERT INTO northwind_dwh.dim_suppliers (
    supplier_ID , Company, FirstName, LastName, FullName, job_title
)
SELECT DISTINCT
	id,
    company,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name),
    job_title
FROM cleaned_northwind.cl_suppliers ;

------------------------------------------------------------------------------------------------------------------------------------------------
-- Shipping Dimension
create table dim_Shipper(
shippingKey INT AUTO_INCREMENT PRIMARY KEY,
shipping_ID int,
Company varchar(50),
City varchar(50) ,
State_province varchar(50) ,
Zip_postal_code varchar(15) ,
Country_region varchar(50)
);

INSERT INTO northwind_dwh.dim_shipper (
    shipping_ID , Company, City, State_province, Zip_postal_code, Country_region
)
SELECT DISTINCT
	id,
    company,
    city,
    state_province,
    zip_postal_code,
    country_region
FROM cleaned_northwind.cl_shippers ;

------------------------------------------------------------------------------------------------------------------------------------------------
-- Region Dimension

create table dim_Region ( 
RegionKey INT AUTO_INCREMENT PRIMARY KEY,
CountryRegion VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
StateProvince VARCHAR(50),
ZipPostalCode VARCHAR(15)
);

INSERT INTO northwind_dwh.dim_region (
    CountryRegion , City, StateProvince, ZipPostalCode
)

select distinct 
r.CountryRegion,
r.city,
r.StateProvince,
r.ZipPostalCode
from(
SELECT 
    country_region AS CountryRegion,
    city AS City,
    state_province AS StateProvince,
    zip_postal_code AS ZipPostalCode
FROM cleaned_northwind.cl_customers
WHERE country_region IS NOT NULL

UNION

SELECT 
    country_region AS CountryRegion,
    city AS City,
    state_province AS StateProvince,
    zip_postal_code AS ZipPostalCode
FROM cleaned_northwind.cl_employee
WHERE country_region IS NOT NULL

UNION

SELECT
    ship_country_region AS CountryRegion,
    ship_city AS City,
    ship_state_province AS StateProvince,
    ship_zip_postal_code AS ZipPostalCode
FROM cleaned_northwind.cl_orders
WHERE ship_country_region IS NOT NULL

UNION

SELECT 
    country_region AS CountryRegion,
    city AS City,
    state_province AS StateProvince,
    zip_postal_code AS ZipPostalCode
FROM cleaned_northwind.cl_shippers
WHERE country_region IS NOT NULL
) r ;


