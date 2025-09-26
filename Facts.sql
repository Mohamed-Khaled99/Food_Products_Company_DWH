use northwind_dwh;
CREATE TABLE Fact_Sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    
    date_key INT NOT NULL,
    time_key INT NOT NULL,
    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    employee_key INT NOT NULL,
    region_key INT NOT NULL,
    supplier_key INT NOT NULL,
    order_id INT NOT NULL,
    order_detail_id INT,   
    quantity_ordered INT NOT NULL,
    unit_price DECIMAL(19,4) NOT NULL,
    discount_percent DECIMAL(5,4) DEFAULT 0,
    sales_amount DECIMAL(19,4) NOT NULL,
    discount_amount DECIMAL(19,4) NOT NULL,
    net_sales DECIMAL(19,4) NOT NULL,
    unit_cost DECIMAL(19,4) NOT NULL,
    cost_amount DECIMAL(19,4) NOT NULL,
    gross_profit DECIMAL(19,4) NOT NULL,
    gross_margin_percent DECIMAL(8,4) NOT NULL,
    shipping_cost DECIMAL(19,4) DEFAULT 0,
    tax_amount DECIMAL(19,4) DEFAULT 0,
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (date_key) REFERENCES Dim_Date(date_key),
    FOREIGN KEY (time_key) REFERENCES Dim_Time(time_key),
    FOREIGN KEY (customer_key) REFERENCES Dim_Customers(customersKey),
    FOREIGN KEY (product_key) REFERENCES Dim_Product(productKey),
    FOREIGN KEY (employee_key) REFERENCES Dim_Employee(employeeKey),
    FOREIGN KEY (region_key) REFERENCES Dim_Region(regionKey),
    FOREIGN KEY (supplier_key) REFERENCES Dim_Suppliers(supplierKey)

);


INSERT INTO Fact_Sales (
    date_key, time_key, customer_key, product_key, employee_key, 
    region_key, supplier_key, order_id, order_detail_id,
    quantity_ordered, unit_price, discount_percent, 
    sales_amount, discount_amount, net_sales,
    unit_cost, cost_amount, gross_profit, gross_margin_percent,
    shipping_cost, tax_amount
)
SELECT 
     
    COALESCE(dd.date_key, -1) AS date_key,
    COALESCE(dt.time_key, -1) AS time_key,
    COALESCE(dc.customersKey, -1) AS customer_key,
    COALESCE(dp.productKey, -1) AS product_key,
    COALESCE(de.employeeKey, -1) AS employee_key,
    COALESCE(dr.regionKey, -1) AS region_key,
    COALESCE(ds.supplierKey, -1) AS supplier_key,
    o.id AS order_id,
    od.id AS order_detail_id,
    od.quantity AS quantity_ordered,
    od.unit_price,
    COALESCE(od.discount, 0) AS discount_percent,
    (od.unit_price * od.quantity) AS sales_amount,
    (od.unit_price * od.quantity * COALESCE(od.discount, 0)) AS discount_amount,
    (od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) AS net_sales,
    COALESCE(p.standard_cost, 0) AS unit_cost,
    (COALESCE(p.standard_cost, 0) * od.quantity) AS cost_amount,
    ((od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) - (COALESCE(p.standard_cost, 0) * od.quantity)) AS gross_profit,
    CASE 
        WHEN (od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) > 0 
        THEN (((od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) - (COALESCE(p.standard_cost, 0) * od.quantity)) 
              / (od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0)))) * 100
        ELSE 0 
    END AS gross_margin_percent,
    COALESCE(o.shipping_fee, 0) AS shipping_cost,
    COALESCE(o.taxes, 0) AS tax_amount

FROM cleaned_northwind.cl_order_details od
INNER JOIN cleaned_northwind.cl_orders o ON od.order_id = o.id
INNER JOIN cleaned_northwind.cl_products p ON od.product_id = p.id
LEFT JOIN northwind_dwh.dim_date dd ON DATE(o.order_date) = dd.full_date
LEFT JOIN northwind_dwh.dim_time dt ON TIME(o.order_time) = dt.time_24hr
LEFT JOIN northwind_dwh.dim_customers dc ON o.customer_id = dc.id AND dc.current_flag = TRUE
LEFT JOIN northwind_dwh.dim_product dp ON od.product_id = dp.product_ID
LEFT JOIN northwind_dwh.dim_employee de ON o.employee_id = de.employeeID AND de.current_flag = TRUE
LEFT JOIN northwind_dwh.dim_region dr ON o.ship_country_region = dr.countryregion 
    AND o.ship_city = dr.city
    AND COALESCE(o.ship_state_province, '') = COALESCE(dr.stateprovince, '')
LEFT JOIN northwind_dwh.dim_suppliers ds ON dp.supplier_ids = ds.supplier_ID

WHERE o.order_date IS NOT NULL 
  AND o.order_time IS NOT NULL
  AND od.quantity > 0
  AND od.unit_price > 0
  AND NOT EXISTS (
      SELECT 1 FROM Fact_Sales fs 
      WHERE fs.order_id = o.id 
      AND fs.order_detail_id = od.id
  );

-------------------------------------------------------------------------------------------------

CREATE TABLE FactLogistics (
    logistics_key INT AUTO_INCREMENT PRIMARY KEY,

    date_key INT NOT NULL,
    shipper_key INT NOT NULL,
    customer_key INT NOT NULL,
    region_key INT NOT NULL,
    employee_key INT,  
    order_id INT NOT NULL,
    shipment_id INT,
    shipping_cost DECIMAL(19,4) NOT NULL,
    delivery_time_days INT,  
    on_time_flag BOOLEAN NOT NULL,
    promised_delivery_date DATE,
    actual_delivery_date DATE,
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (date_key) REFERENCES Dim_Date(date_key),
    FOREIGN KEY (shipper_key) REFERENCES Dim_Shipper(shippingKey),
    FOREIGN KEY (customer_key) REFERENCES Dim_Customers(customersKey),
    FOREIGN KEY (region_key) REFERENCES Dim_Region(regionKey),
    FOREIGN KEY (employee_key) REFERENCES Dim_Employee(employeeKey)
    
);

INSERT INTO FactLogistics (
    date_key, shipper_key, customer_key, region_key, employee_key,
    order_id, shipping_cost, delivery_time_days, on_time_flag,
    promised_delivery_date, actual_delivery_date
)
SELECT 
    COALESCE(dd.date_key,-1) AS date_key,
    COALESCE(ds.shippingKey,-1),
	COALESCE(dc.customersKey,-1) AS customer_key,
    COALESCE(dr.regionKey,-1) AS region_key,
    COALESCE(de.employeeKey,-1) AS employee_key,
    COALESCE(o.id,-1) as order_id,
    COALESCE(o.shipping_fee,-1) as shipping_cost,
    DATEDIFF(o.shipped_date, o.order_date) as delivery_time_days,
    CASE 
        WHEN DATEDIFF(o.shipped_date, o.order_date) <= 7 THEN TRUE
        ELSE FALSE 
    END as on_time_flag,
    DATE_ADD(o.order_date, INTERVAL 7 DAY) as promised_delivery_date,
    o.shipped_date as actual_delivery_date

FROM cleaned_northwind.cl_orders o
JOIN northwind_dwh.dim_date dd ON DATE(o.order_date) = dd.full_date
JOIN northwind_dwh.dim_shipper ds ON o.shipper_id = ds.shipping_ID
JOIN northwind_dwh.dim_customers dc ON o.customer_id = dc.id AND dc.current_flag = TRUE
JOIN northwind_dwh.dim_region dr ON o.ship_country_region = dr.countryregion 
    AND o.ship_city = dr.city
JOIN northwind_dwh.dim_employee de ON o.employee_id = de.employeeID AND de.current_flag = TRUE

WHERE o.shipped_date IS NOT NULL;
