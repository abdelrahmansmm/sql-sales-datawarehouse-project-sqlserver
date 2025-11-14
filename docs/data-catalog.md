Overview:
- The Gold Layer represent the last layer that contains fact and dimensional tables which contain cleaned data to support analytics and reporting use cases.
- The Gold Layer contains:
  - dim_customers
  - dim_products
  - fact_orders

-------------------------------------------------------------------------

1. gold.dim_customers
 - Contains customers details, demographic and geographic information.
 - Columns:
   
   | Column Name | Data Type | Description |
   | ----------- | ---------- | ---------- |
   | customer_key | BIGINT | Surrogate key created to identify each customer record.|
   | customer_id | INT | Unique number assigned to each customer |
   | customer_uni | NVARCHAR | Unique Alphanumeric value assigned to each customer for referencing and tracking |
   | first_name | NVARCHAR | Customer's first name |
   | last_name | NVARCHAR | Customer's last name |
   | country | NVARCHAR | Customer's origin country ex. 'United States', 'Canada', .. |
   | gender | NVARCHAR | Customer gender ex. 'Male', 'Female', 'N/A' |
   | marital_status | NVARCHAR | The marital status of the customer ex. 'Single', 'Married' |
   | birth_date | DATE | Customer's birth date ex, '2000-01-01' |
   | creation_date | DATE | The date the customer record was created ex. '2020-01-01'|

   -------------------------------------------------------------------------

   2. gold.dim_products
    - Contains product and categories informations.
    - Columns:
      
   | Column Name | Data Type | Description |
   | ----------- | ---------- | ---------- |
   | product_key | BIGINT | Surrogate key created to identify each product record.|
   | product_id | INT | Unique number assigned to each product |
   | product_uni | NVARCHAR | Unique Alphanumeric value assigned to each product for referencing and categorizing |
   | product_name | NVARCHAR | Descriptive product name |
   | category_id | NVARCHAR | Unique id to identify the category |
   | category_name | NVARCHAR | Category name |
   | sucategory | NVARCHAR | Sub-category name under the main category |
   | product_cost | INT | The cost of each product |
   | product_type | NVARCHAR | The type of each product ex. 'Mountain', 'Sport', 'Touring', 'Road' |
   | start_date | DATE | The date the product added to the system ex. '2021-01-01'|
   | maintenance | NVARCHAR | Tells if this product needs maintenance or not ex. 'Yes', 'No' |
   
   -------------------------------------------------------------------------

   3. gold.fact_orders
    - Contains transactions data used in analytics and reporting
    - Columns:
   
   | Column Name | Data Type | Description |
   | ----------- | ---------- | ---------- |
   | order_number | NVARCHAR | Unique Alphanumeric value assigned to each order. |
   | product_key | BIGINT | Surrogate key to link with dim_products |
   | customer_key | BIGINT | Surrogate key to link with dim_customers |
   | order_date | DATE | The date the order placed |
   | ship_date | DATE | The expected date the order will be shipped |
   | due_date | DATE | The expected date to deliver the order |
   | price | INT | The product price |
   | quantity | INT | Quantity sold in each order |
   | total_sales | INT | Total sales amount of the order = price * quantity |

   -------------------------------------------------------------------------
