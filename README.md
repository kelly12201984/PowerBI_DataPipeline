# Sales Dashboard (Power BI + ETL Pipeline)

This project demonstrates a full business intelligence workflow — from raw source data to interactive dashboards — using Microsoft’s modern data stack. It includes a complete ETL process and dimensional data model, visualized through a Power BI dashboard.

<img width="2109" height="1156" alt="image" src="https://github.com/user-attachments/assets/abf931c5-9f3a-4d9f-9bb5-1078d8824c76" />

---

## 🗂️ Project Files

- **`Co.Sales_PowerBI.pbix`** – Power BI dashboard file  
- **`Co_database.xlsx`** – Source data used in the Power BI model  
- **`Data_Pipeline.docx`** – Documentation of the ETL pipeline from Azure/SQL Server into Power BI

---

## 🛠️ Tools & Technologies

- **Power BI Desktop** – For modeling and dashboard creation  
- **SQL Server + SSMS** – Database engine and query editor  
- **SQL Server Integration Services (SSIS)** – ETL automation  
- **Azure Data Platform** – Cloud-based data storage and integration  
- **Power Query (M Language)** – For in-model data transformation  
- **DAX** – For light measure calculations

---

## 🔁 ETL Pipeline Overview

Structured data from multiple sources was loaded and transformed using:

- **Azure storage** for cloud-hosted raw data
- **SQL Server** for staging, joins, and transformations
- **SSIS** for automated data movement and integration
- Cleaned data exported to Excel (Co_database.xlsx) for flexible downstream use

The pipeline is fully documented in `Data_Pipeline.docx`, including:
- Table relationships
- Staging queries
- Key column mappings
- Transformation logic
- Export procedures

---

## 📊 Power BI Features

- **Star schema** with dimension tables: `Products`, `Customers`, `Employees`, and `Dates`
- **Fact table**: sales metrics including quantity, discount, and total price
- **Dynamic filtering** using slicers for:
  - Product Category
  - Supervisor
  - Product Name
- **Visuals**:
  - Sales by Employee
  - Sales by Product
  - Category filter breakdowns
  - Drilldowns & tooltips for interaction

---

## 🤖 Data Modeling

- Relationship setup follows best-practice dimensional modeling
- All tables renamed for clarity (pluralized: `Products`, `Customers`, etc.)
- Date table filtered to exclude placeholder rows (e.g. `DateKey = -1`)
- Data types explicitly set to avoid visualization errors
- Schema shown in Power BI’s Model View

---

## 📈 Possible Enhancements

- Add calculated KPIs (e.g., profit margin, YTD sales)
- Build a calendar table using DAX instead of Excel
- Automate refresh via Power BI Service + Gateway
- Integrate RLS (row-level security) by region or employee

---

## 👩‍💻 Created By

**Kelly Arseneau**  
M.S. Applied Data Science, Syracuse University  

---

