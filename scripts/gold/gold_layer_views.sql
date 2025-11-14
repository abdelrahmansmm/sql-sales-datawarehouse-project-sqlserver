/* 
- This code creates the fact and dimensional tables that will be used in analytical and reporting use cases.
- Gold Layer contain:
  - 1 Fact table:
      gold.fact_orders
  - 2 Dimensional tables:
      gold.dim_customers
      gold.dim_products

- Tables created AS VIEWS

Note: You will need 3 SQL files to create 3 VIEWs
*/

-- There is 2 columns for gender: cst_gndr FROM CRM system - gen FROM ERP system -> Business clarified that CRM is most accurate.
CREATE VIEW gold.dim_customers AS 
	SELECT
		ROW_NUMBER() OVER(ORDER BY c.cst_id) AS customer_key, -- Creating a Surrogate Key for Customers
		c.cst_id AS customer_id,
		c.cst_key AS customer_uni,
		c.cst_firstname AS first_name,
		c.cst_lastname AS last_name,
		cl.cntry AS country,
		CASE 
			WHEN c.cst_gndr != 'N/A' THEN c.cst_gndr -- Gender from CRM system takes priority
			ELSE ISNULL(ca.gen,'N/A')
		END AS gender,
		c.cst_marital_status AS marital_status,
		ca.bdate AS birth_date,
		c.cst_create_date AS creation_date
	FROM silver.crm_cust_info c
	LEFT JOIN silver.erp_cust_az12 ca
	ON c.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 cl
	ON c.cst_key = cl.cid
;

-- Business need is not to consider the historical data -> Exluding records with values in prd_end_dt. 
CREATE VIEW gold.dim_products AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY p.prd_line, p.prd_key) AS product_key,
		p.prd_id AS product_id,
		p.prd_key AS product_uni,
		p.prd_nm AS product_name,
		p.cat_id AS category_id,
		pc.cat AS category_name,
		pc.subcat AS sub_category,
		p.prd_cost AS product_cost,
		p.prd_line AS product_type,
		p.prd_start_dt AS start_date,
		pc.maintenance 
	FROM silver.crm_prd_info p
	LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON p.cat_id = pc.id
	WHERE p.prd_end_dt IS NULL -- Filtering to retrieve only present data
;



CREATE VIEW gold.fact_orders AS
	SELECT
		s.sls_ord_num AS order_number,
		p.product_key,
		c.customer_key,
		s.sls_order_dt AS order_date,
		s.sls_ship_dt AS ship_date,
		s.sls_due_dt AS due_date,
		s.sls_price AS price,
		s.sls_quantity AS quantity,
		s.sls_sales AS total_sales
	FROM silver.crm_sales_details s
	LEFT JOIN gold.dim_customers c
	ON s.sls_cust_id = c.customer_id
	LEFT JOIN gold.dim_products p
	ON s.sls_prd_key = p.product_uni
;
