# Northwind Traders Data Warehouse Project

This project demonstrates the design and implementation of a **Data Warehouse** for a specialty food import/export company (**Northwind Traders**).  
It follows **Kimball’s Dimensional Modeling Approach**, using **Star Schema** design, SQL for ETL & analytics, and Power BI for visualization.

---

## 📌 Business Context
Northwind Traders is a fictitious specialty foods import/export company, managing thousands of orders across diverse product lines, regions, and customer segments.  

Core operations include:
- **Sales Operations**
- **Logistics Management**

---

## 🗂️ Data Warehouse Design
- **Facts**: Sales, Logistics, Supply Chain  
- **Dimensions**: Products, Categories, Suppliers, Customers, Employees, Regions, Shippers, Date & Time
<img width="997" height="911" alt="image" src="https://github.com/user-attachments/assets/7bc59772-211a-414f-abe7-5b26d999761d" />


- **Architecture**: Kimball’s Star Schema (Fact tables + Dimension hierarchies)
- ![Architecture](https://github.com/user-attachments/assets/6b81e805-ccf7-4f41-ac11-bdd7d2a30422)

  

---

## 🔹 Implementation Strategy
1. **Staging Area** – raw data ingestion  
2. **Data Profiling** – quality assessment & pattern discovery  
3. **Data Cleaning & Handling** – standardization, deduplication, error correction  
4. **Facts & Dimensions** – structured modeling in SQL  
5. **Business Questions** – analytics-ready dataset for decision-making  

---

## 📊 Business Insights (via SQL + Power BI)
- Sales trend analysis (monthly & quarterly)  
- Top 10 products by revenue  
- Regional customer performance  
- Profit margin and discount impact  
- Shipper performance & delivery times  
- Customer segmentation and purchasing behavior  
<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/81824571-c6ae-4786-a746-87988d10de5f" />
<img width="2400" height="1350" alt="image" src="https://github.com/user-attachments/assets/15ac1a66-0d50-4f29-9f99-7a2421b9090d" />
<img width="2406" height="2703" alt="image" src="https://github.com/user-attachments/assets/2bbb798a-676e-4a7f-b088-6ae1b53a75e9" />

---

## 🚀 Technologies
- **SQL** for data modeling, ETL, and querying
- **Power BI** for dashboarding & business intelligence  
- **Kimball’s methodology** for DWH design  
