Select * from sales_data;

--INSERT INTO sales_data (Sale_ID, Region, Salesperson, Product, Sale_Amount, Sale_Date) VALUES
--(11, 'Central', 'Anjali', 'Laptop', 1800.00, '2022-12-15'),
--(12, 'South', 'Rahul', 'Monitor', 1600.00, '2023-01-10'),
--(13, 'East', 'Ravi', 'Mouse', 200.00, '2023-01-20'),
--(14, 'West', 'Sneha', 'Tablet', 950.00, '2023-02-05'),
--(15, 'North', 'Amit', 'Keyboard', 500.00, '2023-02-12'),
--(16, 'South', 'Priya', 'Headphones', 300.00, '2023-03-03'),
--(17, 'East', 'Meena', 'Webcam', 750.00, '2023-04-22'),
--(18, 'Central', 'Anjali', 'Scanner', 1200.00, '2023-05-15'),
--(19, 'North', 'Deepak', 'Chair', 2200.00, '2023-06-07'),
--(20, 'South', 'Rahul', 'Desk', 3100.00, '2023-06-25'),
--(21, 'East', 'Meena', 'Laptop', 1900.00, '2023-07-04'),
--(22, 'West', 'Sneha', 'Docking Station', 650.00, '2023-08-19'),
--(23, 'Central', 'Deepak', 'Keyboard', 550.00, '2023-08-29'),
--(24, 'North', 'Amit', 'Monitor', 1450.00, '2023-09-14'),
--(25, 'South', 'Priya', 'Desk', 2900.00, '2023-10-11'),
--(26, 'East', 'Ravi', 'Chair', 1800.00, '2023-11-09'),
--(27, 'Central', 'Anjali', 'Webcam', 780.00, '2023-12-01'),
--(28, 'West', 'Meena', 'Scanner', 1100.00, '2024-01-18'),
--(29, 'North', 'Deepak', 'Laptop', 2100.00, '2024-02-03'),
--(30, 'South', 'Rahul', 'Headphones', 320.00, '2024-03-06'),
--(31, 'North', 'Amit', 'Tablet', 1100.00, '2024-04-10'),
--(32, 'West', 'Sneha', 'Webcam', 780.00, '2024-05-15'),
--(33, 'South', 'Priya', 'Scanner', 1350.00, '2024-06-22'),
--(34, 'Central', 'Meena', 'Mouse', 250.00, '2024-07-13'),
--(35, 'East', 'Ravi', 'Keyboard', 490.00, '2024-08-03'),
--(36, 'Central', 'Anjali', 'Chair', 2000.00, '2024-09-19'),
--(37, 'West', 'Deepak', 'Laptop', 2250.00, '2024-10-26'),
--(38, 'North', 'Amit', 'Monitor', 1700.00, '2024-11-11'),
--(39, 'South', 'Priya', 'Desk', 3200.00, '2024-12-17'),
--(40, 'East', 'Meena', 'Tablet', 1050.00, '2025-01-06');

-----Get total sales (SUM), average sale value (AVG), highest (MAX) and lowest (MIN) sale amount across the entire table.


SELECT 
  COUNT(*) AS total_sales,
  SUM(Sale_Amount) AS total_revenue,
  AVG(Sale_Amount) AS avg_sale_value,
  MIN(Sale_Amount) AS lowest_sale,
  MAX(Sale_Amount) AS highest_sale
FROM sales_data;


-----Get the total sales per product using GROUP BY.


SELECT 
  Product,
  COUNT(*) AS total_transactions,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY Product;


-----Get total sales per salesperson — but only show salespeople with total sales > 3000.


SELECT 
  Salesperson,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY Salesperson
HAVING SUM(Sale_Amount) > 3000;


-----Show total sale amount, number of transactions, and average sale for each region.


SELECT 
  Region,
  COUNT(*) AS transactions,
  SUM(Sale_Amount) AS total_sales,
  AVG(Sale_Amount) AS avg_sale
FROM sales_data
GROUP BY Region;


----- GROUP BY ROLLUP -- Get total sales per region, and also include a grand total row.


SELECT 
  Region,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY ROLLUP(Region);


----- GROUP BY ROLLUP -- Replace NULL with more meaningful labels like 'All Regions', 'All Products', or 'Grand Total' Using ISNULL or COALESCE.


SELECT 
  ISNULL(Region, 'Grand Total') AS Region,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY ROLLUP(Region);


----- GROUP BY ROLLUP -- Replace NULL with more meaningful labels like 'All Regions', 'All Products', or 'Grand Total' Using Case Statements.


SELECT 
  CASE 
    WHEN GROUPING(Region) = 1 THEN 'All Regions'
    ELSE Region
  END AS Region,
  CASE 
    WHEN GROUPING(Product) = 1 AND GROUPING(Region) = 0 THEN 'Subtotal'
    WHEN GROUPING(Product) = 1 AND GROUPING(Region) = 1 THEN 'Grand Total'
    ELSE Product
  END AS Product,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY ROLLUP(Region, Product);


----- GROUP BY CUBE -- Get total sales by Region and Product, and also include subtotals for each and a grand total.


SELECT 
  Region,
  Product,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY CUBE(Region, Product);


----- GROUP BY CUBE -- Replace NULL with more meaningful labels like 'All Regions', 'All Products', or 'Grand Total' Using ISNULL or COALESCE + Case Statements.


SELECT 
  ISNULL(Region, 
    CASE 
      WHEN Product IS NULL THEN 'Grand Total' 
      ELSE 'All Regions' 
    END
  ) AS Region,
  
  ISNULL(Product, 
    CASE 
      WHEN Region IS NULL THEN 'Grand Total' 
      ELSE 'All Products' 
    END
  ) AS Product,

  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY CUBE(Region, Product);


----- GROUP BY GROUPING SETS -- Get total sales by Region only, by Product only, and the grand total.


SELECT 
  Region,
  Product,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY GROUPING SETS (
  (Region),
  (Product),
  ());


----- GROUP BY GROUPING SETS -- Replace NULL with more meaningful labels like 'All Regions', 'All Products', or 'Grand Total' Using Case Statements.


SELECT 
  CASE 
    WHEN GROUPING(Region) = 1 THEN 'All Regions'
    ELSE Region
  END AS Region,
  CASE 
    WHEN GROUPING(Product) = 1 THEN 'All Products'
    ELSE Product
  END AS Product,
  SUM(Sale_Amount) AS total_sales
FROM sales_data
GROUP BY GROUPING SETS ( (Region), (Product), () );


-----Find the top-performing salesperson(s) in each region based on total sales amount, only if their regional total exceeds $2000.


--CTE + ROW_NUMBER()


WITH cte1 AS (
    SELECT 
        Region,
        Salesperson,
        SUM(Sale_Amount) AS Sum_Amount
    FROM sales_data
    GROUP BY Region, Salesperson
    HAVING SUM(Sale_Amount) > 2000
),
cte2 AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Region ORDER BY Sum_Amount DESC) AS row_num
    FROM cte1
)
SELECT * 
FROM cte2
WHERE row_num = 1;


--Derived Table + ROW_NUMBER()


SELECT *
FROM (
    SELECT 
        Region,
        Salesperson,
        SUM(Sale_Amount) AS Sum_Amount,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sale_Amount) DESC) AS row_num
    FROM sales_data
    GROUP BY Region, Salesperson
    HAVING SUM(Sale_Amount) > 2000
) AS ranked_sales
WHERE row_num = 1;


--Using TOP 1 WITH TIES and ORDER BY


SELECT TOP 1 WITH TIES 
    Region,
    Salesperson,
    SUM(Sale_Amount) AS Sum_Amount
FROM sales_data
GROUP BY Region, Salesperson
HAVING SUM(Sale_Amount) > 2000
ORDER BY 
    ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sale_Amount) DESC);


--Using INNER JOIN with Grouped Max Aggregation


WITH sales_summary AS (
    SELECT 
        Region,
        Salesperson,
        SUM(Sale_Amount) AS Sum_Amount
    FROM sales_data
    GROUP BY Region, Salesperson
    HAVING SUM(Sale_Amount) > 2000
),
max_sales AS (
    SELECT 
        Region,
        MAX(Sum_Amount) AS max_amount
    FROM sales_summary
    GROUP BY Region
)
SELECT s.*
FROM sales_summary s
JOIN max_sales m 
  ON s.Region = m.Region AND s.Sum_Amount = m.max_amount;


-----Show only Subtotals and Grand Total (Filter Detailed Rows)


SELECT 
    COALESCE(Region, 'Grand Total') AS Region,
    CASE 
        WHEN GROUPING(Product) = 1 AND GROUPING(Region) = 0 THEN 'Region Subtotal*'
        WHEN GROUPING(Product) = 1 AND GROUPING(Region) = 1 THEN 'Grand Total'
    END AS Product,
    SUM(Sale_Amount) AS Total_Sales
FROM sales_data
GROUP BY ROLLUP (Region, Product)
HAVING GROUPING(Product) = 1
ORDER BY GROUPING(Region), Region;


-----Sales Summary by Region and Product using CUBE


SELECT 
    COALESCE(Region, 'ALL Regions') AS Region,
    COALESCE(Product, 'ALL Products') AS Product,
    SUM(Sale_Amount) AS Total_Sales,
	GROUPING(Region) AS Group_Region,
	GROUPING(Product) AS Group_Product
FROM sales_data
GROUP BY CUBE (Region, Product)
ORDER BY GROUPING(Region), GROUPING(Product), Region, Product;


-----Top-Selling Product per Region


WITH RegionProductSales AS (
    SELECT 
        Region,
        Product,
        SUM(Sale_Amount) AS Total_Sales
    FROM sales_data
    GROUP BY Region, Product
),
MaxSalesPerRegion AS (
    SELECT 
        Region,
        MAX(Total_Sales) AS Max_Sales
    FROM RegionProductSales
    GROUP BY Region
)
SELECT 
    rps.Region,
    rps.Product,
    rps.Total_Sales
FROM RegionProductSales rps
JOIN MaxSalesPerRegion msr
  ON rps.Region = msr.Region AND rps.Total_Sales = msr.Max_Sales
ORDER BY rps.Region;


-----Monthly Sales Trend by Region


SELECT 
    FORMAT(Sale_Date, 'yyyy-MM') AS Sale_Month,
    Region,
    SUM(Sale_Amount) AS Monthly_Sales
FROM sales_data
GROUP BY FORMAT(Sale_Date, 'yyyy-MM'), Region
ORDER BY Sale_Month, Region;


-----Yearly Product Performance Summary


SELECT 
    isnull(cast((YEAR(Sale_Date)) as varchar(50)), 'All Years') AS Sale_Year,
    isnull(Product, 'All Products'),
    SUM(Sale_Amount) AS Total_Sales
FROM sales_data
GROUP BY ROLLUP (YEAR(Sale_Date), Product)
ORDER BY GROUPING(YEAR(Sale_Date)), GROUPING(Product), Sale_Year, Product;


----- % Contribution of Each Product to Region's Total using CTE + Joins + Group By


WITH RegionTotals AS (
    SELECT Region, SUM(Sale_Amount) AS Region_Total
    FROM sales_data
    GROUP BY Region
)
SELECT 
    sd.Region,
    sd.Product,
    SUM(sd.Sale_Amount) AS Product_Sales,
    rt.Region_Total,
    (format(100.0 * SUM(sd.Sale_Amount) / rt.Region_Total, 'N1'))+ '%' AS Percentage_Contribution
FROM sales_data sd
JOIN RegionTotals rt ON sd.Region = rt.Region
GROUP BY sd.Region, sd.Product, rt.Region_Total
ORDER BY sd.Region, Percentage_Contribution DESC;

---% Contribution of Each Product to Region's Total using Windows Function + Group By


SELECT
    Region,
    Product,
    SUM(Sale_Amount) AS Total_Sales,
	 (
	 FORMAT (SUM(SUM(Sale_Amount)) 
		OVER (PARTITION BY Region), 'N2')
			) as Regional_Sales,
    (
		(FORMAT (100.0 * SUM(Sale_Amount) / SUM(SUM(Sale_Amount)) 
			OVER (PARTITION BY Region), 'N2')) + '%'
				) AS Contribution_Percentage
FROM sales_data
GROUP BY Region, Product
ORDER BY Region, Contribution_Percentage DESC;


-----Most Diverse Product Seller


SELECT 
    Salesperson,
    COUNT(DISTINCT Product) AS Unique_Products_Sold
FROM sales_data
GROUP BY Salesperson
ORDER BY Unique_Products_Sold DESC;


-----Salesperson Ranking by Total Sales Within Each Region


SELECT
    Region,
    Salesperson,
    SUM(Sale_Amount) AS Total_Sales,
    RANK() OVER (PARTITION BY Region ORDER BY SUM(Sale_Amount) DESC) AS Regional_Rank
FROM sales_data
GROUP BY Region, Salesperson
ORDER BY Region, Regional_Rank;


-----Top 3 Selling Products by Total Revenue


SELECT TOP 3
    Product,
    SUM(Sale_Amount) AS Total_Revenue
FROM sales_data
GROUP BY Product
ORDER BY Total_Revenue DESC;


-----Monthly Revenue by Region with Yearly Total using GROUPING SETS


SELECT
    ISNULL(Region, 'All Regions') AS Region,
    CASE 
        WHEN Month IS NULL THEN 'Year Total' 
        ELSE FORMAT(Month, '00') + ' (' + DATENAME(MONTH, DATEFROMPARTS(2024, Month, 1)) + ')'
    END AS Month_Name,
    SUM(Sale_Amount) AS Total_Revenue
FROM (
    SELECT 
        Region,
        MONTH(Sale_Date) AS Month,
        Sale_Amount
    FROM sales_data
    WHERE YEAR(Sale_Date) = 2024
) AS base
GROUP BY 
    GROUPING SETS (
        (Region, Month),
        (Region),
        ()
    )
ORDER BY 
    GROUPING(Region), 
    Region, 
    GROUPING(Month), 
    Month;


-----Salesperson Performance with Percent of Total Region Sales


SELECT
    Region,
    Salesperson,
    SUM(Sale_Amount) AS Total_Sales,
    CAST(
        100.0 * SUM(Sale_Amount) / SUM(SUM(Sale_Amount)) OVER (PARTITION BY Region)
        AS DECIMAL(5,2)
    ) AS Percent_of_Region
FROM sales_data
GROUP BY Region, Salesperson
ORDER BY Region, Percent_of_Region DESC;


-----