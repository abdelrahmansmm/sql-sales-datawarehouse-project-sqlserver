# Building Data Warehouse Project
This project demonstrates a data warehouse and analytics solution by building a data warehouse that generates actionable insight. 
Building a data warehousing with SQL Server, including ETL processing, data modeling, and data analytics.

---

## Data Architecture:

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](docs/data_architecture_diagram.jpg)

1. **Bronze Layer**: Stores raw data as from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: In this layer, the data is being cleaned, standardized, and normalized to be ready for analysis processes.
3. **Gold Layer**: The data here is modeled with a star schema required for analysis and reporting.

---

## Overview:

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL**: Extracting, transforming, and loading data from source systems into the datawarehouse.
3. **Data Modeling**: Creating fact and dimensional tables optimized for analytical queries.

---

## Tools & Links:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.

---

## Project Requirements:

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Clean and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---
