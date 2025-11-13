CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch_time DATETIME, @end_batch_time DATETIME;
		PRINT 'Loading data into Silver Layer';
		PRINT '==========';
		PRINT 'Loading CRM Data';
		PRINT '==========';
		
		SET @start_batch_time = GETDATE();

		-- Truncating and Inserting clean data into silver layer crm_cust_info after cleaning bronze layer crm_cust_info.
		SET @start_time = GETDATE();
		PRINT '> Truncating silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;

		PRINT '> Loading data into silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname, 
			TRIM(cst_lastname) AS cst_lastname,
			CASE UPPER(TRIM(cst_marital_status))
				WHEN 'M' THEN 'Married'
				WHEN 'S' THEN 'Single'
				ELSE 'N/A'
			END AS cst_marital_status, -- Standardizing data to be friendly reading
			CASE UPPER(TRIM(cst_gndr))
				WHEN 'M' THEN 'Male'
				WHEN 'F' THEN 'Female'
				ELSE 'N/A'
			END AS cst_gndr, -- Standardizing data to be friendly reading
			cst_create_date
		FROM (
			SELECT *,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t WHERE flag = 1;

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '----------';

		-- Truncating and Inserting clean data into silver layer crm_prd_info after cleaning bronze layer crm_prd_info
		SET @start_time = GETDATE();
		PRINT '> Truncating silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '> Loading data into silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Derived data: Extracting the cat_id from prd_key -> reference erp_px_cat_g1v2
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Extracting prd_key from prd_key after excluding cat_id
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost, -- Replacing to 0 if the business allowed.
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'S' THEN 'Sport'
				WHEN 'R' THEN 'Road'
				WHEN 'T' THEN 'Touring'
				ELSE 'N/A'
			END AS prd_line, -- Standardizing prd_line data to be friendly
			CAST(prd_start_dt AS DATE) AS prd_start_dt, 
			CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt -- Data enrichment: prd_end_dt from prd_start_dt
		FROM bronze.crm_prd_info

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '----------';

		-- Truncating and Inserting clean data into silver layer crm_sales_details after cleaning bronze layer crm_sales_details.
		SET @start_time = GETDATE();
		PRINT '> Truncating silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT '> Loading data into silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL -- Handling invalid data type
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales -- Calculating the proper values (sales = quantity * price) after handling the invaild data values
			END AS sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity,0) 
				ELSE sls_price
			END AS sls_price
		FROM bronze.crm_sales_details

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '==========';
		PRINT '==========';
		PRINT 'Loading ERP Data';
		PRINT '==========';
		-- Truncating and Inserting clean data into silver layer erp_cust_az12 after cleaning bronze layer erp_cust_az12.
		SET @start_time = GETDATE();
		PRINT '> Truncating silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT '> Loading data into silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Removing extra letters in cid
				ELSE cid
			END AS cid,
			CASE 
				WHEN bdate > GETDATE() THEN NULL -- Handling wrong bdate
				ELSE bdate
			END AS bdate,
			CASE 
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male' 
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE')  THEN 'Female'
				ELSE 'N/A'
			END AS gen
		FROM bronze.erp_cust_az12

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds.'
		PRINT '----------';

		-- Truncating and Inserting clean data into silver layer erp_loc_a101 after cleaning bronze layer erp_loc_a101.
		SET @start_time = GETDATE();
		PRINT '> Truncating silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;

		PRINT '> Loading data into silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)
		SELECT
			REPLACE(TRIM(cid), '-','') AS cid,
			CASE
				WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
				WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
				ELSE TRIM(cntry)
			END AS cntry
		FROM bronze.erp_loc_a101

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds.'
		PRINT '----------';

		-- Truncating and Inserting clean data into silver layer erp_px_cat_g1v2 after cleaning bronze layer erp_px_cat_g1v2.
		SET @start_time = GETDATE();
		PRINT '> Truncating silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '> Loading data into silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2
		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '==========';

		PRINT 'Loading all data into Silver layer is done';
		SET @end_batch_time = GETDATE();
		PRINT 'Batch load time: ' + CAST(DATEDIFF(second, @start_batch_time, @end_batch_time) AS NVARCHAR) + ' seconds.';
	END TRY
	BEGIN CATCH
		PRINT 'Error occured during loading process';
		PRINT 'Error Message: ' + ERROR_MESSAGE() + ', Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END
