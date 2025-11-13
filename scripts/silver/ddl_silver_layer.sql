-- Creating the silver tables the same as bronze table + some metadata column like (dwh_create_date) which tells the date the record inserted.
-- Creating code checks first if the table exists and drops it, then it creates a new one.

USE SalesDataWarehouse;
GO

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(255),
	cst_firstname NVARCHAR(255),
	cst_lastname NVARCHAR(255),
	cst_marital_status NVARCHAR(255),
	cst_gndr NVARCHAR(255),
	cst_create_date DATE,
	dwh_create_time DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(255),
	prd_key NVARCHAR(255),
	prd_nm NVARCHAR(255),
	prd_cost INT,
	prd_line NVARCHAR(255),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_time DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(255),
	sls_prd_key NVARCHAR(255),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_time DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	cid NVARCHAR(255),
	bdate DATE,
	gen NVARCHAR(255),
	dwh_create_time DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
	cid NVARCHAR(255),
	cntry NVARCHAR(255),
	dwh_create_time DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
	id NVARCHAR(255),
	cat NVARCHAR(255),
	subcat NVARCHAR(255),
	maintenance NVARCHAR(255),
	dwh_create_time DATETIME2 DEFAULT GETDATE()
);
