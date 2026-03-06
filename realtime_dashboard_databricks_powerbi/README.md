+------------------+        +-------------------+        +-------------------+
|   Data Source    | -----> | Data Processing   | -----> | Delta Lake Table  |
|Oracle-direct access)  |  | (Spark in Databricks)       |                   |         Real time
+------------------+        +-------------------+        +-------------------+
                                           |                         |
                                           v                         v
                                +---------------------+   +------------------------+
                                | Optimization &      |   | Power BI Dashboard     |
                                | Maintenance Scripts |   | (Connects via JDBC)    |
                                +---------------------+   +------------------------+


Technical Summary of EQP_STATUS Data Pipeline & Dashboard Project
1. Overview
This project involves creating a robust data pipeline for equipment status data, stored efficiently in Delta Lake, with periodic updates, maintenance, and visualization in Power BI. The goal is to enable real-time or near-real-time dashboarding with optimized data loading and query performance.

a. Real time equipment status data with attributes like EQP_ID, STATUS, STEP, DEPARTMENT, LOT_ID.  
b. Data Ingestion & Upsert into Delta Lake  

Connect to External Oracle XE (optional): Use JDBC to pull real data from Oracle database.  
Data Preparation: Convert data into Spark DataFrame.  
Merge Operation: Upsert (update/insert) data into Delta Lake table for incremental updates.

c. Data Optimization & Maintenance  

Optimize: Use OPTIMIZE with ZORDER to improve query speed.  
Vacuum: Remove obsolete files to reduce storage and improve performance.  
Analyze: Update table statistics for query optimizer.

d. Data Consumption & Visualization  

Power BI Connection: Use JDBC or DirectQuery to connect to the Delta Lake table.  
Dashboarding: Build real-time dashboards with filters, aggregations, and visualizations based on equipment status data.


Equipment units tracked in system
EQP_ID, STATUS, STEP, DEPARTMENT, LOT_ID
Unique equipment identifier
Delta Lake Table
Storage of equipment status data
Same as Equipment attributes
Optimized for fast read/write
#################################




Power BI Dashboard
Visualization layer for insights
Filtered and aggregated data from Delta Lake
User interface for decision making

Data Pipeline
ETL/ELT process for data refresh
Data ingestion, merge, optimize, vacuum
Automates data updates

##########################POWER BI#################################
---

## Establish Connection**
- Use **DirectQuery** mode to connect Power BI directly to your Delta Lake table via your Spark SQL endpoint.

## **Summary of Visuals**

| Visual Type             | Data/Measures                                          | Purpose                                              |
|-------------------------|--------------------------------------------------------|------------------------------------------------------|
| **Table**               | All latest status info, with conditional formatting    | Main status overview                                |
| **Pie Chart**           | Count of latest statuses                                | Status distribution overview                        |
| **Stacked Bar Chart**   | Count of statuses per department                        | Department-wise status analysis                     |
| **Card**                | Total tools count                                       | Quick summary                                       |
| **Line Chart**          | Status over time (optional)                              | Trend analysis over recent days                     |
