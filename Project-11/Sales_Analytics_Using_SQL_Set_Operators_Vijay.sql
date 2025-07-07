--Challenge 1: Compare Products with and without Sales

SELECT product_name
FROM products
EXCEPT
SELECT DISTINCT product_name
FROM sales_data;


SELECT product_name, category, price
FROM products
WHERE product_name IN (
    SELECT product_name
    FROM products
    EXCEPT
    SELECT product_name
    FROM sales_data
);

--Challenge 2: Find Common Names Between Customers and Salespersons


SELECT name FROM customers
INTERSECT
SELECT name FROM salespersons;

SELECT name FROM customers
EXCEPT
SELECT name FROM salespersons;

SELECT name FROM salespersons
EXCEPT
SELECT name FROM customers;


--Challenge 3: Sales Made in 2023 vs 2024


SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2023
UNION
SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2024;

SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2023
INTERSECT
SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2024;

SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2023
EXCEPT
SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2024;

SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2024
EXCEPT
SELECT DISTINCT product_name
FROM sales_data
WHERE YEAR(sale_date) = 2023;


--Challenge 4: Loyalty Program Comparison – Customers Joined in 2022 vs 2023

SELECT customer_id, name
FROM customers
WHERE YEAR(join_date) = 2022
INTERSECT
SELECT customer_id, name
FROM customers
WHERE YEAR(join_date) = 2023;

SELECT customer_id, name
FROM customers
WHERE YEAR(join_date) = 2022
EXCEPT
SELECT customer_id, name
FROM customers
WHERE YEAR(join_date) = 2023;

SELECT customer_id, name
FROM customers
WHERE YEAR(join_date) = 2023
EXCEPT
SELECT customer_id, name
FROM customers
WHERE YEAR(join_date) = 2022;


---Challenge 5: Common Products Between Salespersons – Amit vs Sneha


SELECT DISTINCT product_name
FROM sales_data
WHERE salesperson = 'Amit'

INTERSECT

SELECT DISTINCT product_name
FROM sales_data
WHERE salesperson = 'Sneha';


---Challenge 7: Salespersons Who Didn’t Meet Targets


SELECT st1.salesperson, st1.month, st1.target_amount
FROM sales_targets st1

EXCEPT

SELECT 
  st2.salesperson, 
  st2.Month,
  st2.target_amount
FROM sales_targets st2
JOIN (
    SELECT 
      salesperson, 
      FORMAT(sale_date, 'yyyy-MM') AS month, 
      SUM(sale_amount) AS total_sales
    FROM sales_data
    GROUP BY salesperson, FORMAT(sale_date, 'yyyy-MM')
) sales_summary
ON st2.salesperson = sales_summary.salesperson 
AND st2.Month = sales_summary.month
WHERE sales_summary.total_sales >= st2.Target_Amount;


-----Challenge 8: Compare Sales Regions
--Find regions that made sales but had no sales targets assigned — useful for:
--Spotting operational oversight
--Identifying unmonitored regions
--Ensuring accountability


SELECT DISTINCT sd.region, sd.product_name
FROM sales_data sd
WHERE sd.region IN (
    SELECT region
    FROM sales_data
    EXCEPT
    SELECT region
    FROM sales_targets
)
ORDER BY sd.region, sd.product_name;


-----Challenge 9: Duplicate vs Unique Product Sales


SELECT 
  product_name, 
  'Unique' AS sale_type,
  COUNT(*) AS times_sold
FROM sales_data
GROUP BY product_name
HAVING COUNT(*) = 1

UNION ALL


SELECT 
  product_name, 
  'Duplicate' AS sale_type,
  COUNT(*) AS times_sold
FROM sales_data
GROUP BY product_name
HAVING COUNT(*) > 1;


-----Challenge 10: Salespersons Active in Consecutive Years


SELECT DISTINCT salesperson
FROM sales_data
WHERE YEAR(sale_date) = 2023

INTERSECT

SELECT DISTINCT salesperson
FROM sales_data
WHERE YEAR(sale_date) = 2024;


-----11. Region-Wise Exclusive Products
--Objective: Products sold in one region but never in another.

SELECT DISTINCT product_name
FROM sales_data
WHERE region = 'Central'
EXCEPT
SELECT DISTINCT product_name
FROM sales_data
WHERE region = 'East';

SELECT DISTINCT product_name
FROM sales_data
WHERE region = 'East'
EXCEPT
SELECT DISTINCT product_name
FROM sales_data
WHERE region = 'Central';


-----12. Products with Dropped Sales
--Objective: Products sold in 2023 but not in 2024


SELECT DISTINCT product_name
FROM sales_data
WHERE format(sale_date, 'yyyy-MM') BETWEEN '2023-01' AND '2023-12'
EXCEPT
SELECT DISTINCT product_name
FROM sales_data
WHERE format(sale_date, 'yyyy-MM') BETWEEN '2024-01' AND '2024-12';


SELECT DISTINCT product_name
FROM sales_data
WHERE format(sale_date, 'yyyy-MM') BETWEEN '2024-01' AND '2024-12'
EXCEPT
SELECT DISTINCT product_name
FROM sales_data
WHERE format(sale_date, 'yyyy-MM') BETWEEN '2023-01' AND '2023-12';


-----13. Product Category Coverage by Region
--Objective: Identify which regions haven’t sold from each product category.


SELECT DISTINCT r.region, p.category
FROM regions r
CROSS JOIN (SELECT DISTINCT category FROM products) p
EXCEPT
SELECT DISTINCT s.region, p.category
FROM sales_data s
JOIN products p ON s.product_name = p.product_name;

SELECT DISTINCT s.region, p.category
FROM sales_data s
JOIN products p ON s.product_name = p.product_name
EXCEPT
SELECT DISTINCT r.region, p.category
FROM regions r
CROSS JOIN (SELECT DISTINCT category FROM products) p;


-----14. Salesperson Handoff Detection
--Objective: Detect when one salesperson stops selling and another starts for the same region/product.


WITH prev_sales AS (
    SELECT DISTINCT region, product_name, salesperson
    FROM sales_data
    WHERE format(sale_date, 'yyyy-MM') BETWEEN '2023-01' AND '2023-12'
),
curr_sales AS (
    SELECT DISTINCT region, product_name, salesperson
    FROM sales_data
    WHERE format(sale_date, 'yyyy-MM') BETWEEN '2024-01' AND '2024-12'
)
SELECT region, product_name, salesperson
FROM curr_sales
EXCEPT
SELECT region, product_name, salesperson
FROM prev_sales;


-----15. Compare Actual vs Targeted Months
--Objective: Find months where targets were set but no actual sales occurred.


SELECT DISTINCT month AS target_month
FROM sales_targets
EXCEPT
SELECT DISTINCT format(sale_date, 'yyyy-MM') AS actual_month
FROM sales_data;

SELECT DISTINCT format(sale_date, 'yyyy-MM') AS actual_month
FROM sales_data
EXCEPT
SELECT DISTINCT month AS target_month
FROM sales_targets;


-----16. Salesperson Product Reassignment
--Objective: Products sold by one person in 2023 and another in 2024.


WITH prev_sales AS (
    SELECT DISTINCT product_name, salesperson
    FROM sales_data
    WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31'
),
curr_sales AS (
    SELECT DISTINCT product_name, salesperson
    FROM sales_data
    WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
)
SELECT product_name, salesperson
FROM curr_sales
EXCEPT
SELECT product_name, salesperson
FROM prev_sales;


-----
