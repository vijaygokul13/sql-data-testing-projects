-----Create Test table as Product Sales

--CREATE TABLE product_sales (
--    product_id INT PRIMARY KEY,
--    product_name VARCHAR(50),
--    sale_amount DECIMAL(10,2),
--    sale_date DATE
--);


-----Insert Test Data


--INSERT INTO product_sales (product_id, product_name, sale_amount, sale_date) VALUES
--(101, 'iPhone 14', 95000.00, '2024-12-01'),
--(102, 'Galaxy S23', 87000.00, '2024-12-03'),
--(103, 'Pixel 8', 74000.00, '2024-12-05'),
--(104, 'OnePlus 11', 69000.00, '2024-12-06'),
--(105, 'iPhone 13', 81000.00, '2024-12-08');


-----Global sales rank for each product.


SELECT *, 
RANK() OVER (ORDER BY sale_amount DESC) AS global_sales_rank
FROM product_sales;


-----Running Total of Sales in Descending Order


SELECT *,
SUM(sale_amount) OVER (ORDER BY sale_amount DESC) AS running_total_sales
FROM product_sales;


-----Each Product's Contribution to Global Revenue (%)


SELECT 
    region, 
    sale_amount, 
    sale_date, 
    Total_Sum,
    FORMAT(pct_of_total, 'N2') AS PCT_Contribution
FROM (
    SELECT *,
        SUM(sale_amount) OVER (ORDER BY sale_amount DESC) AS Total_Sum,
        sale_amount * 100.0 / SUM(sale_amount) OVER () AS pct_of_total
    FROM sales_data
) temp;


-----Difference from the Top-Selling Product


SELECT *,
sale_amount - MAX(sale_amount) OVER () AS diff_from_top_sale
FROM product_sales;


-----Insert products into product_sales table with category_id and sales data


--INSERT INTO [dbo].[product_sales] ([product_id], [product_name], [sale_amount], [sale_date], [category_id]) 
--VALUES 
--(101, N'iPhone 14', CAST(95000.00 AS Decimal(10, 2)), CAST(N'2024-12-01' AS Date), 1),
--(102, N'Galaxy S23', CAST(87000.00 AS Decimal(10, 2)), CAST(N'2024-12-03' AS Date), 1),
--(103, N'Pixel 8', CAST(74000.00 AS Decimal(10, 2)), CAST(N'2024-12-05' AS Date), 1),
--(104, N'OnePlus 11', CAST(69000.00 AS Decimal(10, 2)), CAST(N'2024-12-06' AS Date), 1),
--(105, N'iPhone 13', CAST(81000.00 AS Decimal(10, 2)), CAST(N'2024-12-08' AS Date), 1),
--(106, N'Apple iPad Pro', CAST(95000.00 AS Decimal(10, 2)), CAST(N'2024-12-10' AS Date), 2),
--(107, N'Samsung Galaxy Tab S8', CAST(85000.00 AS Decimal(10, 2)), CAST(N'2024-12-12' AS Date), 2),
--(108, N'Microsoft Surface Pro 9', CAST(92000.00 AS Decimal(10, 2)), CAST(N'2024-12-14' AS Date), 2),
--(109, N'Lenovo Tab P11', CAST(40000.00 AS Decimal(10, 2)), CAST(N'2024-12-16' AS Date), 2),
--(110, N'Dell XPS 13', CAST(125000.00 AS Decimal(10, 2)), CAST(N'2024-12-18' AS Date), 3),
--(111, N'Apple MacBook Air', CAST(120000.00 AS Decimal(10, 2)), CAST(N'2024-12-20' AS Date), 3),
--(112, N'HP Spectre x360', CAST(115000.00 AS Decimal(10, 2)), CAST(N'2024-12-22' AS Date), 3),
--(113, N'Lenovo ThinkPad X1', CAST(110000.00 AS Decimal(10, 2)), CAST(N'2024-12-24' AS Date), 3),
--(114, N'Asus ZenBook 14', CAST(90000.00 AS Decimal(10, 2)), CAST(N'2024-12-26' AS Date), 3),
--(115, N'AirPods Pro', CAST(25000.00 AS Decimal(10, 2)), CAST(N'2024-12-28' AS Date), 4),
--(116, N'Samsung Galaxy Buds Pro', CAST(20000.00 AS Decimal(10, 2)), CAST(N'2024-12-30' AS Date), 4),
--(117, N'Apple Magic Mouse', CAST(7500.00 AS Decimal(10, 2)), CAST(N'2025-01-01' AS Date), 4),
--(118, N'Logitech MX Master 3', CAST(8500.00 AS Decimal(10, 2)), CAST(N'2025-01-03' AS Date), 4),
--(119, N'Bose QuietComfort 35', CAST(35000.00 AS Decimal(10, 2)), CAST(N'2025-01-05' AS Date), 4),
--(120, N'Sony PlayStation 5', CAST(50000.00 AS Decimal(10, 2)), CAST(N'2025-01-07' AS Date), 5),
--(121, N'Xbox Series X', CAST(45000.00 AS Decimal(10, 2)), CAST(N'2025-01-09' AS Date), 5),
--(122, N'Nintendo Switch', CAST(30000.00 AS Decimal(10, 2)), CAST(N'2025-01-11' AS Date), 5);


--ALTER TABLE product_sales
--ALTER COLUMN category_id VARCHAR(50);


--EXEC sp_rename 'product_sales.category_id', 'category_name', 'COLUMN';


--UPDATE product_sales
--SET category_name = CASE 
--    WHEN category_name = '1' THEN 'Smartphones'
--    WHEN category_name = '2' THEN 'Tablets'
--    WHEN category_name = '3' THEN 'Laptops'
--    WHEN category_name = '4' THEN 'Accessories'
--    WHEN category_name = '5' THEN 'Gaming Consoles'
--END;


--ALTER TABLE product_sales
--ADD Country VARCHAR(50),
--    Region VARCHAR(50);


-- Update Smartphones

--UPDATE product_sales
--SET Country = 'United States', Region = 'North America'
--WHERE product_id = 101;

--UPDATE product_sales
--SET Country = 'Canada', Region = 'North America'
--WHERE product_id = 102;

--UPDATE product_sales
--SET Country = 'United Kingdom', Region = 'Europe'
--WHERE product_id = 103;

--UPDATE product_sales
--SET Country = 'Germany', Region = 'Europe'
--WHERE product_id = 104;

--UPDATE product_sales
--SET Country = 'Australia', Region = 'Oceania'
--WHERE product_id = 105;

---- Update Tablets
--UPDATE product_sales
--SET Country = 'United States', Region = 'North America'
--WHERE product_id = 106;

--UPDATE product_sales
--SET Country = 'Canada', Region = 'North America'
--WHERE product_id = 107;

--UPDATE product_sales
--SET Country = 'United Kingdom', Region = 'Europe'
--WHERE product_id = 108;

--UPDATE product_sales
--SET Country = 'India', Region = 'Asia'
--WHERE product_id = 109;

---- Update Laptops
--UPDATE product_sales
--SET Country = 'Japan', Region = 'Asia'
--WHERE product_id = 110;

--UPDATE product_sales
--SET Country = 'United States', Region = 'North America'
--WHERE product_id = 111;

--UPDATE product_sales
--SET Country = 'Germany', Region = 'Europe'
--WHERE product_id = 112;

--UPDATE product_sales
--SET Country = 'France', Region = 'Europe'
--WHERE product_id = 113;

--UPDATE product_sales
--SET Country = 'Australia', Region = 'Oceania'
--WHERE product_id = 114;

---- Update Accessories
--UPDATE product_sales
--SET Country = 'Canada', Region = 'North America'
--WHERE product_id = 115;

--UPDATE product_sales
--SET Country = 'India', Region = 'Asia'
--WHERE product_id = 116;

--UPDATE product_sales
--SET Country = 'United States', Region = 'North America'
--WHERE product_id = 117;

--UPDATE product_sales
--SET Country = 'Japan', Region = 'Asia'
--WHERE product_id = 118;

--UPDATE product_sales
--SET Country = 'Germany', Region = 'Europe'
--WHERE product_id = 119;

---- Update Gaming Consoles
--UPDATE product_sales
--SET Country = 'Japan', Region = 'Asia'
--WHERE product_id = 120;

--UPDATE product_sales
--SET Country = 'United States', Region = 'North America'
--WHERE product_id = 121;

--UPDATE product_sales
--SET Country = 'Australia', Region = 'Oceania'
--WHERE product_id = 122;


-----


with first_last_value as
(
select 
	product_name,
	region,
	price,
	price_date,
	FIRST_VALUE(price) over (
		partition by product_name, region 
		order by price_date) as first_price,
	LAST_VALUE(price) over (
		partition by product_name, region 
		order by price_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) As last_price
from product_prices
)
	select *,
		last_price-first_price as Price_Diff_,
			CAST(
			FORMAT(
			((last_price-first_price)* (100.0/first_price)),'N1') +'%' as varchar) 
			as Diff_in_percentage
from first_last_value


-----E Commerce Global Sales Leaderboard & Contribution Tracker


Select
	Product_name,
	Category,
	Country,
	Sale_amount,
	Sale_date,
	Total_Sale_Amount,
		Format(Sale_Contribution,'N2') as Sale_Contribution_In_Total,
	Highest_Rank,
	Max_Sale,
	Diff_From_Max_Sale,
	Cumulative_Sales
From
(
Select *,
	sum(sale_amount) 
		Over () as Total_Sale_Amount,
	(sale_amount * 100) / sum(sale_amount) 
		over () as Sale_Contribution,
	rank() over (
		order by sale_amount desc) as Highest_Rank,
	max(sale_amount) 
		over () as Max_Sale,
	Sale_amount - max(sale_amount) 
		over () as Diff_From_Max_Sale,
		SUM(sale_amount) 
		OVER (ORDER BY sale_amount DESC) AS Cumulative_Sales
from global_sales_data) temp


-----Sub Queries vs Joins


---Case:1 - We want to get a list of products that have a sale amount greater than the average sale amount for that product category.

--(Subquery in the WHERE Clause)


SELECT ps1.product_id, ps1.product_name, ps1.sale_amount
FROM product_sales ps1
WHERE ps1.sale_amount > (
    SELECT AVG(ps2.sale_amount)
    FROM product_sales ps2
    WHERE ps2.category_name = ps1.category_name
);


select ps1.product_id, ps1.product_name, ps1.sale_amount
from product_sales ps1
join (select ps2.category_name, avg(ps2.sale_amount) as AVG_Sale
		from product_sales ps2
		group by ps2.category_name) ps2 
	on ps2.category_name = ps1.category_name
	and ps1.sale_amount > ps2.AVG_Sale


---Case:2 - We want to find products that were sold in regions where the average sale amount is above a certain threshold (80000). 

--(Subquery with IN Operator)


SELECT product_id, product_name, sale_amount, region
FROM product_sales
WHERE region IN (
    SELECT region
    FROM product_sales
    GROUP BY region
    HAVING AVG(sale_amount) > 80000
);


SELECT ps1.product_id, ps1.product_name, ps1.sale_amount, ps1.region
FROM product_sales ps1
JOIN (
    SELECT region
    FROM product_sales
    GROUP BY region
    HAVING AVG(sale_amount) > 80000) ps2 
	ON ps1.region = ps2.region;


---Case:3 - Let’s calculate the sale amount for each product and the highest sale amount for that product. 

--(Subquery in the SELECT Clause)


SELECT product_id, product_name, sale_amount, 
       (SELECT MAX(sale_amount) 
		FROM product_sales ps2 
		WHERE ps2.product_id = product_sales.product_id) AS max_sale_amount
FROM product_sales;


SELECT ps1.product_id, ps1.product_name, ps1.sale_amount, ps2.max_sale_amount
FROM product_sales ps1
JOIN (
    SELECT product_id, MAX(sale_amount) AS max_sale_amount
    FROM product_sales
    GROUP BY product_id
) ps2 ON ps1.product_id = ps2.product_id;


---Case:4 - We want to find the top 3 selling products in each category. 

--(Subquery in the FROM Clause)


SELECT product_id, product_name, sale_amount
FROM (
    SELECT product_id, product_name, sale_amount, 
           RANK() OVER (PARTITION BY category_name ORDER BY sale_amount DESC) AS rank
    FROM product_sales
) AS ranked_sales
WHERE rank <= 3;


WITH ranked_sales AS (
    SELECT product_id, product_name, sale_amount, category_name,
           RANK() OVER (PARTITION BY category_name ORDER BY sale_amount DESC) AS rank
    FROM product_sales
)
SELECT ps.product_id, ps.product_name, ps.sale_amount
FROM ranked_sales ps
WHERE ps.rank <= 3;


-----Master table creation

--CREATE TABLE product_master (
--    product_id INT PRIMARY KEY,
--    product_name VARCHAR(100) NOT NULL,
--    category_name VARCHAR(50) NOT NULL
--);

--INSERT INTO product_master (product_id, product_name, category_name)
--VALUES
--(101, 'iPhone 14', 'Smartphones'),
--(102, 'Galaxy S23', 'Smartphones'),
--(103, 'Pixel 8', 'Smartphones'),
--(104, 'OnePlus 11', 'Smartphones'),
--(105, 'iPhone 13', 'Smartphones'),
--(106, 'Apple iPad Pro', 'Tablets'),
--(107, 'Samsung Galaxy Tab S8', 'Tablets'),
--(108, 'Microsoft Surface Pro 9', 'Tablets'),
--(109, 'Lenovo Tab P11', 'Tablets'),
--(110, 'Dell XPS 13', 'Laptops'),
--(111, 'Apple MacBook Air', 'Laptops'),
--(112, 'HP Spectre x360', 'Laptops'),
--(113, 'Lenovo ThinkPad X1', 'Laptops'),
--(114, 'Asus ZenBook 14', 'Laptops'),
--(115, 'AirPods Pro', 'Accessories'),
--(116, 'Samsung Galaxy Buds Pro', 'Accessories'),
--(117, 'Apple Magic Mouse', 'Accessories'),
--(118, 'Logitech MX Master 3', 'Accessories'),
--(119, 'Bose QuietComfort 35', 'Accessories'),
--(120, 'Sony PlayStation 5', 'Gaming Consoles'),
--(121, 'Xbox Series X', 'Gaming Consoles'),
--(122, 'Nintendo Switch', 'Gaming Consoles');


-----CROSS APPLY Query (For each product, you want to find its latest sale record).


SELECT 
    pm1.product_id,
    pm1.product_name,
    ps1.sale_amount,
    ps1.sale_date
FROM 
    product_master pm1
CROSS APPLY
(
    SELECT TOP 1 
        ps1.sale_amount, ps1.sale_date
    FROM 
        product_sales ps1
    WHERE 
        ps1.product_id = pm1.product_id
    ORDER BY 
        ps1.sale_date DESC
) ps1;


-----For every product in product_sales, find its highest sale amount made till now.


SELECT 
    ps1.product_id, 
    ps1.product_name, 
    ps2.sale_amount AS highest_sale_amount, 
    ps2.sale_date 
FROM 
    product_sales ps1
CROSS APPLY 
    (SELECT TOP 1 
         ps2.sale_amount, 
         ps2.sale_date
     FROM 
         product_sales ps2
     WHERE 
         ps2.product_id = ps1.product_id
     ORDER BY 
         ps2.sale_amount DESC
    ) ps2;


-----For every product category (category_name) in the product_sales table, find:
--The product having the highest sale amount within that category.
--Show: category_name, product_name, sale_amount, and sale_date.


select  
	distinct ps1.category_name,
	ps2.product_name,
	ps2.sale_amount as highest_sale_amount,
	ps2.sale_date
	from product_sales ps1
		cross apply (
			select 
				top 1
				ps2.product_name,
				ps2.sale_amount,
				ps2.sale_date
				from product_sales ps2
				where ps2.category_name = ps1.category_name
				order by ps2.sale_amount desc
				) ps2


-----For each Region, find the product with the highest sale_amount. (cross apply)


select 
	distinct ps1.Region,
	ps2.product_name,
	ps2.sale_amount as highest_sale_amount,
	ps2.sale_date
from product_sales ps1
cross apply (
	select
	top 1
		ps2.product_name,
		ps2.sale_amount,
		ps2.sale_date
	from product_sales ps2
	where ps2.Region = ps1.Region
	order by ps2.sale_amount desc) ps2


--For each Region, find the product with the highest sale_amount. (Using CTE)


WITH Region_Top_Product AS (
    SELECT 
        Region,
        Product_Name,
        Sale_Amount,
        Sale_Date,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY Sale_Amount DESC) AS rn
    FROM product_sales
)
SELECT
    Region,
    Product_Name,
    Sale_Amount AS highest_sale_amount,
    Sale_Date
FROM Region_Top_Product
WHERE rn = 1;


-----You are tasked with finding the highest selling product in each region, but this time, 
--you need to consider only the top 3 products per region based on the sale amount. 


SELECT DISTINCT 
    ps1.Region,
    ps2.product_name,
    ps2.sale_amount,
    ps2.sale_date
FROM product_sales ps1
CROSS APPLY (
    SELECT 
        ps2.product_name,
        ps2.sale_amount,
        ps2.sale_date,
        ROW_NUMBER() OVER (PARTITION BY ps2.Region ORDER BY ps2.sale_amount DESC) AS row_number_
    FROM product_sales ps2
    WHERE ps2.Region = ps1.Region
) ps2
WHERE ps2.row_number_ <= 3;


-----

select * from product_master

--INSERT INTO product_master (product_id, product_name, category_name)
--VALUES
--(123, 'Apple Watch Series 8', 'Wearables'),
--(124, 'Samsung Galaxy Watch 5', 'Wearables'),
--(125, 'Fitbit Charge 5', 'Wearables');

--CREATE TABLE categories (
--    category_id INT PRIMARY KEY,
--    category_name VARCHAR(50) NOT NULL
--);

--INSERT INTO categories (category_id, category_name)
--VALUES
--(1, 'Smartphones'),
--(2, 'Tablets'),
--(3, 'Laptops'),
--(4, 'Accessories'),
--(5, 'Gaming Consoles'),
--(6, 'Wearables');  -- New category added

--ALTER TABLE product_master
--ADD category_id INT;

--UPDATE product_master
--SET category_id = CASE
--    WHEN category_name = 'Smartphones' THEN 1
--    WHEN category_name = 'Tablets' THEN 2
--    WHEN category_name = 'Laptops' THEN 3
--    WHEN category_name = 'Accessories' THEN 4
--    WHEN category_name = 'Gaming Consoles' THEN 5
--    WHEN category_name = 'Wearables' THEN 6
--    ELSE NULL
--END;

--ALTER TABLE product_master
--ADD CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES categories(category_id);

--EXEC sp_rename 'categories', 'product_categories';

select * from product_categories

select * from product_master

select * from product_sales


-----


SELECT 
    pm1.product_id,
    pm1.product_name,
    ps1.sale_amount AS highest_sale_amount,
    ps1.sale_date
FROM 
    product_master pm1
OUTER APPLY 
    (SELECT TOP 1 
        ps1.sale_amount, 
        ps1.sale_date
     FROM 
        product_sales ps1
     WHERE 
        ps1.product_id = pm1.product_id
     ORDER BY 
        ps1.sale_amount DESC) ps1;

-----we want to retrieve the top 2 sales for each category from the product_sales table for each product listed in 
--the product_master table. Even if a product has fewer than 2 sales, we want it to appear in the result 
--with NULL values for missing sales.


SELECT 
    pm1.product_id,
    pm1.product_name,
    ps1.sale_amount AS highest_sale_amount_1,
    ps1.sale_date AS sale_date_1,
    ps2.sale_amount AS highest_sale_amount_2,
    ps2.sale_date AS sale_date_2
FROM 
    product_master pm1
OUTER APPLY 
    (SELECT TOP 1 
        ps1.sale_amount, 
        ps1.sale_date
     FROM 
        product_sales ps1
     WHERE 
        ps1.product_id = pm1.product_id
     ORDER BY 
        ps1.sale_amount DESC) ps1
OUTER APPLY 
    (SELECT TOP 1 
        ps2.sale_amount, 
        ps2.sale_date
     FROM 
        product_sales ps2
     WHERE 
        ps2.product_id = pm1.product_id 
        AND ps2.sale_amount < ps1.sale_amount  -- second highest sale
     ORDER BY 
        ps2.sale_amount DESC) ps2;

-----Find the latest sale for each product along with the total number of sales for each product

SELECT 
    pm1.product_id,
    pm1.product_name,
    ps1.sale_amount AS latest_sale_amount,
    ps1.sale_date AS latest_sale_date,
    ps2.total_sales
FROM 
    product_master pm1
OUTER APPLY 
    (SELECT TOP 1 
        ps1.sale_amount, 
        ps1.sale_date
     FROM 
        product_sales ps1
     WHERE 
        ps1.product_id = pm1.product_id
     ORDER BY 
        ps1.sale_date DESC) ps1
OUTER APPLY 
    (SELECT 
        COUNT(*) AS total_sales
     FROM 
        product_sales ps2
     WHERE 
        ps2.product_id = pm1.product_id) ps2;

-----