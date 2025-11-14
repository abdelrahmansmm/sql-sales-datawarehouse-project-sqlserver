-- CHECKING silver.crm_cust_info
-- Checking for duplicates in cst_id OR nulls
-- Expectation: No result
-- Result: 0
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Checking for unwanted spaces in cst_firstname
-- Expectation: No result
-- Results: 0
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Checking for unwanted spaces in cst_lastname
-- Expectation: No result
-- Results: 0
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Checking for unwanted spaces in cst_marital_status
-- Expectation: No result
-- Results: 0 records
SELECT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

-- Checking for unwanted spaces in cst_gndr
-- Expectation: No result
-- Results: 0 records
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Checking DISTINCT in cst_gndr and cst_marital_status for Standardization
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info
-- Values: M, F, and Nulls -> Male, Female
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info
-- Values: M, S, and Nulls -> Married, Single
-- END silver.crm_cust_info

-- =======================

-- CHECKING silver.crm_prd_info

-- Checking for duplicates in prd_id OR nulls
-- Expectation: No result
-- Result: 0 records
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Checking for spaces in prd_key
-- Expectation: No result
-- Result: 0 records
SELECT prd_key
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key)

--Checking cat_id consistency.
SELECT DISTINCT cat_id
FROM silver.crm_prd_info
WHERE cat_id NOT IN (
				SELECT id
				FROM silver.erp_px_cat_g1v2
				)

-- Checking for spaces in prd_nm
-- Expectation: No result
-- Result: 0 records
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Checking for nulls and non-positive number in prd_cost
-- Expectation: No Result
-- Result: 0
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Checking DISTINCT in prd_line for Standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info; 
-- Values: M, R, S, T, and Nulls -> After reviewing the business -> Mountain, Road, Sport, Touring.

-- Checking prd_start_dt and prd_end_dt pattern.
-- Results:
-- All prd_end_dt is earlier than prd_start_dt -> #1 wrong intervals issue
-- Some products have different cost in the same intervals -> #2 overlapping issue
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
-- END silver.crm_prd_info

-- =======================

-- CHECKING crm_sales_details
-- Checking dates columns sls_order_dt, sls_ship_dt, sls_due_dt
-- Result: 19 records (NULLS)
SELECT sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL
	OR sls_order_dt > '2026-01-01' -- Date Boundary
	OR sls_order_dt < '2000-01-01'; -- Date Boundary

-- Result: 0 records
SELECT sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt IS NULL
	OR sls_ship_dt > '2026-01-01' -- Date Boundary
	OR sls_ship_dt < '2000-01-01'; -- Date Boundary

-- Result: 0 records
SELECT sls_order_dt, sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt < sls_order_dt;

-- Result: 0 records
SELECT sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL -- Date Boundary
	OR sls_due_dt < '2000-01-01';

-- Results: 0 records
SELECT sls_order_dt, sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt < sls_order_dt;

-- Results: 0 records
SELECT sls_ship_dt, sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt < sls_ship_dt;

-- Checking sls_price for nulls, non-positive numbers, and ,miscalculations
-- Expectation: No result
-- Result: 0
SELECT DISTINCT sls_sales, sls_quantity, sls_price,
	CASE 
		WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS cal_sales,
	CASE
		WHEN sls_price <= 0 OR sls_price IS NULL
		THEN sls_sales / NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS cal_price
FROM silver.crm_sales_details
WHERE sls_price <= 0 OR sls_price IS NULL
	OR sls_quantity <= 0 OR sls_quantity IS NULL
	OR sls_sales <= 0 OR sls_sales IS NULL
	OR sls_sales != sls_quantity * sls_price;

-- Checking consistency
SELECT *
FROM silver.crm_sales_details;

SELECT sls_cust_id
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (
	SELECT cst_id
	FROM silver.crm_cust_info)

SELECT sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (
	SELECT prd_key
	FROM silver.crm_prd_info)
-- END silver.crm_sales_details

-- =======================

-- CHECKING bronez.erp_cust_az12
SELECT 
	cid
FROM silver.erp_cust_az12
WHERE cid NOT IN (
	SELECT cst_key
	FROM silver.crm_cust_info)

-- Checking bdate
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Checking gen
-- Inconsisteny issue
SELECT DISTINCT gen
FROM silver.erp_cust_az12
-- END silver.erp_cust_az12

-- =======================

-- CHECKING bronez.erp_loc_a101
-- Checking cid
SELECT *
FROM silver.erp_loc_a101

SELECT cid
FROM silver.erp_loc_a101
WHERE cid NOT IN (
	SELECT cst_key
	FROM silver.crm_cust_info)

-- Checking cntry
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
-- END silver.erp_loc_a101

-- =======================

-- CHECKING bronez.erp_px_cat_g1v2
SELECT *
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2
-- END silver.erp_loc_a101
