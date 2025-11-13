/*
- Load method is Full Load Data -> using (Truncate and Insert).
- Inserting data to the bronze tables from the source CSV file using BULK INSERT.
- BULK INSERT uses WITH Clause which determine what the first row in the file is, and determines the delimiter.

-- WARNING: Running the code without the TRUNCATE query will cause a duplication in the table.

- The code is writtin within TRY AND CATCH to handle errors that may appear.
- All loading code will be store in a Stored Procedure Called bronze.load_bronze.
*/
USE SalesDataWarehouse;
GO

-- Creating Stored Procedure for loading data into bronze layer
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch_time DATETIME, @end_batch_time DATETIME;
		PRINT 'Loading data into Bronze Layer';
		PRINT '==========';
		PRINT 'Loading CRM Data';
		PRINT '==========';

		SET @start_batch_time = GETDATE();

		--Truncate and load crm_cust_info
		PRINT '> Truncating bronze.crm_cust_info';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '> Loading data into bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Learning\Projects\SQL Sales Data Warehouse From Scrach\Data\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time = ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
		PRINT '----------';

		--Truncate and load crm_prd_info
		PRINT '> Truncating bronze.crm_prd_info';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '> Loading data into bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Learning\Projects\SQL Sales Data Warehouse From Scrach\Data\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time = ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
		PRINT '----------';
		
		--Truncate and load crm_sales_details
		PRINT '> Truncating bronze.crm_sales_details';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '> Loading data into bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Learning\Projects\SQL Sales Data Warehouse From Scrach\Data\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time = ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
		
		PRINT '==========';
		PRINT '==========';
		PRINT 'Loading ERP Data';
		PRINT '==========';
		--Truncate and load erp_cust_az12
		PRINT '> Truncating bronze.erp_cust_az12';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '> Loading data into bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Learning\Projects\SQL Sales Data Warehouse From Scrach\Data\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time = ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
		PRINT '----------';

		--Truncate and load erp_loc_a101
		PRINT '> Truncating bronze.erp_loc_a101';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '> Loading data into bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Learning\Projects\SQL Sales Data Warehouse From Scrach\Data\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time = ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
		PRINT '----------';

		--Truncate and load erp_px_cat_g1v2
		PRINT '> Truncating bronze.erp_px_cat_g1v2';
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '> Loading data into bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Learning\Projects\SQL Sales Data Warehouse From Scrach\Data\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		PRINT 'Done';

		SET @end_time = GETDATE();
		PRINT 'Loading time = ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds.';
		PRINT '=========='

		PRINT 'Loading all data into Bronze layer is done';
		SET @end_batch_time = GETDATE();
		PRINT 'Batch load time = ' + CAST(DATEDIFF(second,@start_batch_time,@end_batch_time) AS NVARCHAR) + ' seconds.';
	END TRY
	BEGIN CATCH
		PRINT 'Error occured during loading process';
		PRINT 'Error Message: ' + ERROR_MESSAGE() + ', Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END
