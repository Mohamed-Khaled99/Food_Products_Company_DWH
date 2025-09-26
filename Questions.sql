--  Total sales by product, category, customer, region, and sales representative.
SELECT 
    d.year,
    d.month_name,
    p.product_name,
    p.category,  
    cust.company as customer_name,
    r.countryregion,
    r.city,
    CONCAT(e.FirstName, ' ', e.LastName) as employee_name,
    e.JobTitle,
    
    SUM(fs.quantity_ordered) as total_quantity,
    SUM(fs.sales_amount) as total_sales,
    SUM(fs.net_sales) as net_revenue,
    SUM(fs.gross_profit) as total_profit,
    ROUND(AVG(fs.gross_margin_percent), 2) as avg_margin_percent

FROM Fact_Sales fs
JOIN Dim_Date d ON fs.date_key = d.date_key
JOIN Dim_Product p ON fs.product_key = p.productKey
JOIN Dim_Customers cust ON fs.customer_key = cust.customersKey
JOIN Dim_Region r ON fs.region_key = r.regionKey
JOIN Dim_Employee e ON fs.employee_key = e.employeeKey

GROUP BY d.year, d.month_name, p.product_name, p.category,
         cust.company, r.countryregion, r.city, e.JobTitle,
         CONCAT(e.FirstName, ' ', e.LastName)
         
ORDER BY d.year DESC, d.month_name, total_sales DESC;

-----------------------------------
-- Identification of top 10 products.
SELECT 
    p.product_name,
	SUM(fs.quantity_ordered) as total_quantity_sold,
    SUM(fs.net_sales) as total_revenue,
    ROUND(SUM(fs.gross_profit), 2) as total_profit
FROM Fact_Sales fs
JOIN Dim_Product p ON fs.product_key = p.productKey
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;
-------------------------------------
-- Identification of top 10 customers.
SELECT 
    cust.company as customer_name,
    r.countryregion,
    r.city,
    COUNT(DISTINCT fs.order_id) as total_orders,
    SUM(fs.net_sales) as sales,
    ROUND(AVG(fs.gross_margin_percent), 2) as avg_margin
FROM Fact_Sales fs
JOIN Dim_Customers cust ON fs.customer_key = cust.customersKey
JOIN Dim_Region r ON fs.region_key = r.regionKey
GROUP BY cust.company, r.countryregion, r.city
ORDER BY sales DESC
LIMIT 10;

-------------
-- Sales trends by month and quarter
SELECT 
    d.year,
    d.quarter,
    d.month_name,
    SUM(fs.net_sales) as monthly_revenue,
    SUM(fs.gross_profit) as monthly_profit,
    COUNT(DISTINCT fs.order_id) as order_count
   
FROM Fact_Sales fs
JOIN Dim_Date d ON fs.date_key = d.date_key
GROUP BY d.year, d.quarter, d.month_name, d.month_num
ORDER BY d.year, d.month_num;

---------------
-- Profit margins by product category and supplier.

SELECT 
	p.category, 
    sup.company as supplier_name,
    COUNT(DISTINCT p.product_id) as product_count,
    SUM(fs.quantity_ordered) as total_quantity_sold,
    SUM(fs.net_sales) as total_revenue,
    SUM(fs.gross_profit) as total_profit,
    ROUND(SUM(fs.gross_profit) / SUM(fs.net_sales) * 100, 2) as net_margin_percent,
    ROUND(AVG(p.standard_cost), 2) as avg_product_cost,
    ROUND(AVG(fs.unit_price), 2) as avg_selling_price
FROM Fact_Sales fs
JOIN Dim_Product p ON fs.product_key = p.productKey
JOIN Dim_Suppliers sup ON fs.supplier_key = sup.supplierKey
GROUP BY  p.category,  sup.company
ORDER BY net_margin_percent DESC;

------------------------
-- Impact of discounts on overall revenue and profit.
SELECT 
    CASE 
        WHEN fs.discount_percent = 0 THEN 'No Discount'
        WHEN fs.discount_percent <= 0.1 THEN 'Small Discount (0-10%)'
        WHEN fs.discount_percent <= 0.2 THEN 'Medium Discount (11-20%)'
        ELSE 'Large Discount (>20%)'
    END as discount_range,
    COUNT(*) as order_lines,
    SUM(fs.quantity_ordered) as total_quantity,
    SUM(fs.sales_amount) as revenue,
    SUM(fs.discount_amount) as total_discounts,
    SUM(fs.net_sales) as net_revenue,
    SUM(fs.gross_profit) as actual_profit,
    ROUND(SUM(fs.discount_amount) / SUM(fs.sales_amount) * 100, 2) as discount_rate,
    ROUND(SUM(fs.gross_profit) / SUM(fs.net_sales) * 100, 2) as net_margin
FROM Fact_Sales fs
GROUP BY discount_range
ORDER BY discount_rate;
--------------------------------
-- Regional customer analysis (who buys the most, and where).
SELECT 
    r.countryregion,
    r.city,
    COUNT(DISTINCT fs.customer_key) as unique_customers,
    COUNT(DISTINCT fs.order_id) as total_orders,
    SUM(fs.net_sales) as regional_revenue,
    SUM(fs.gross_profit) as regional_profit,
    ROUND(SUM(fs.net_sales) / COUNT(DISTINCT fs.customer_key), 2) as revenue_per_customer,
    ROUND(SUM(fs.net_sales) / COUNT(DISTINCT fs.order_id), 2) as avg_order_value
FROM Fact_Sales fs
JOIN Dim_Region r ON fs.region_key = r.regionKey
JOIN Dim_Customers cust ON fs.customer_key = cust.customersKey
GROUP BY r.countryregion, r.city
ORDER BY regional_revenue DESC;

---------------------------------------
-- Sales performance by employee (e.g., orders handled, revenue generated).

SELECT 
    e.FullName as employee_name,
    e.JobTitle,
    COUNT(DISTINCT fs.order_id) as orders_handled,
    COUNT(DISTINCT fs.customer_key) as unique_customers,
    SUM(fs.net_sales) as total_sales_generated,
    SUM(fs.gross_profit) as total_profit_generated,
    ROUND(AVG(fs.gross_margin_percent), 2) as avg_margin,
    ROUND(SUM(fs.net_sales) / COUNT(DISTINCT fs.order_id), 2) as avg_order_value,
    ROUND(SUM(fs.net_sales) / COUNT(DISTINCT fs.customer_key), 2) as revenue_per_customer
FROM Fact_Sales fs
JOIN Dim_Employee e ON fs.employee_key = e.employeeKey
GROUP BY e.FullName, e.JobTitle
ORDER BY total_sales_generated DESC;

--------------------------------------------
-- Average delivery time (from order to shipment).
SELECT 
    s.company as shipper_name,
    COUNT(*) as shipments_handled,
    ROUND(AVG(fl.delivery_time_days), 1) as avg_processing_time,
    MIN(fl.delivery_time_days) as min_processing_time,
    MAX(fl.delivery_time_days) as max_processing_time,
    ROUND(AVG(fl.shipping_cost), 2) as avg_shipping_cost,
    SUM(CASE WHEN fl.delivery_time_days > 7 THEN 1 ELSE 0 END) as delayed_shipments,
    ROUND(SUM(CASE WHEN fl.delivery_time_days > 7 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as delay_percentage
FROM FactLogistics fl
JOIN Dim_Shipper s ON fl.shipper_key = s.shippingKey
GROUP BY s.company
ORDER BY avg_processing_time;
-------------------------
-- Shipper performance comparison (cost and reliability).

SELECT 
    s.company as shipper_name,
    COUNT(*) as total_shipments,
    ROUND(AVG(fl.delivery_time_days), 1) as avg_processing_days,
    ROUND(SUM(CASE WHEN fl.delivery_time_days <= 7 THEN 1 ELSE 0 END)  / COUNT(*)* 100.0, 2) as on_time_rate,
    ROUND(AVG(fl.shipping_cost), 2) as avg_shipping_cost,
    ROUND(MIN(fl.shipping_cost), 2) as min_shipping_cost,
    ROUND(MAX(fl.shipping_cost), 2) as max_shipping_cost,
    ROUND(AVG(fs_order.order_value), 2) as avg_order_value,
    ROUND(AVG(fl.shipping_cost / NULLIF(fs_order.order_value, 0)) * 100, 2) as shipping_cost_percentage
    
FROM FactLogistics fl
JOIN Dim_Shipper s ON fl.shipper_key = s.shippingKey
JOIN (
    SELECT 
        order_id,
        SUM(net_sales) as order_value  
    FROM Fact_Sales 
    GROUP BY order_id
) fs_order ON fl.order_id = fs_order.order_id

WHERE fs_order.order_value > 0
GROUP BY s.company
ORDER BY on_time_rate DESC, avg_shipping_cost ASC;