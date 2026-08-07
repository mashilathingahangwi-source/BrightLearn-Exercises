To verify the data
SELECT *
FROM bright_coffee_shop_sales
LIMIT 10;

unit_price format change
SELECT
REPLACE (unit_price,',','.')
FROM bright_coffee_shop_sales;

Checking duplicates
SELECT *,
COUNT(*)
FROM bright_coffee_shop_sales
GROUP BY All
HAVING COUNT(*) > 1; No duplicates

 Check Null

 SELECT*
 FROM bright_coffee_shop_sales
 WHERE transaction_id IS NULL OR transaction_date IS NULL OR transaction_time IS NULL OR transaction_qty IS NULL OR store_id IS NULL OR store_location IS NULL OR unit_price IS NULL OR product_category IS NULL OR product_detail IS NULL OR product_type IS NULL;  NO NULL

 ..............................................................................................

..1.TOTAL REVENUE

SELECT
SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop_sales;

..2.TOTAL REVENUE BY CATEGORY

SELECT
product_category,
SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop_sales
GROUP BY 1;

..3.TOTAL REVENUE BY PRODUCT CATEGORY AND PRODUCT DETAIL

SELECT
product_category,
product_detail,
SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop_sales
GROUP BY ALL;




..4.TOTAL REVENUE BASED ON TIME OF DAY
...6am - 11:59 > Morning
...12pm - 16:59 > Afternoon
...17pm - 19:59 > Evening

SELECT
transaction_time,
CASE
    WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 9 AND 12 THEN 'Midday'
    WHEN HOUR(transaction_time) BETWEEN 13 AND 16 THEN 'Afternoon'
    ElSE 'Evening'
    END AS transactiona_time_bucket
    FROM bright_coffee_shop_sales;

    SELECT
    CASE
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN'18:00:00' AND '19:59:59' THEN 'Evening'
    ELSE 'Night'
    END AS time_bucket,
    SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
    FROM bright_coffee_shop_sales
    GROUP BY time_bucket;

 SELECT
 product_category,
    CASE
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN'18:00:00' AND '19:59:59' THEN 'Evening'
    ELSE 'Night'
    END AS time_bucket,
    SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
    FROM bright_coffee_shop_sales
    GROUP BY ALL;

..5.TOTAL REVENUE BY STORE LOCATION

SELECT
store_location,
SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop_sales
GROUP BY ALL;


..6.DATE EXTRACTION
SELECT 
transaction_date,
MONTHNAME(transaction_date) AS month_name,
DATE_FORMAT(transaction_date,'yyyy-MM') AS Month_id,
DAYNAME(transaction_date) AS day_name,
DAYOFWEEK(transaction_date) AS day_Number
FROM bright_coffee_shop_sales;


..7.Best Performing Product
SELECT
product_type,
SUM(transaction_qty*unit_price) AS Total_Revenue
FROM bright_coffee_shop_sales
GROUP BY product_type
ORDER BY Total_Revenue DESC
LIMIT 1;

..8.Least Brought Product
SELECT
product_detail,
SUM(transaction_qty*unit_price) AS Total_Revenue
FROM bright_coffee_shop_sales
GROUP BY product_detail
ORDER BY Total_Revenue ASC
LIMIT 1;

...................................................................................................

SELECT 
transaction_date,
MONTHNAME(transaction_date) AS month_name,
DATE_FORMAT(transaction_date,'yyyy-MM') AS Month_id,
DAYNAME(transaction_date) AS day_name,
DAYOFWEEK(transaction_date) AS day_Number,
COUNT(transaction_id) AS trans_count,
COUNT(product_id) AS product_sold,
product_category,
product_detail,
product_type,
store_location,
CASE
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '18:00:00' AND '19:59:59' THEN 'Evening'
    ELSE 'Night'
    END AS time_bucket,
SUM(transaction_qty * CAST(REPLACE (unit_price,',','.') AS DECIMAL(10,2))) AS total_revenue
FROM bright_coffee_shop_sales
GROUP BY ALL;

