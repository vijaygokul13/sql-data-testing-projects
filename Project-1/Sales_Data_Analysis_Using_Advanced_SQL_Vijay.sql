--CREATE TABLE sales_data (
--    Sale_ID INT PRIMARY KEY,
--    Region VARCHAR(20),
--    Salesperson VARCHAR(50),
--    Product VARCHAR(50),
--    Sale_Amount DECIMAL(10,2),
--    Sale_Date DATE
--);

-----

--INSERT INTO sales_data (Sale_ID, Region, Salesperson, Product, Sale_Amount, Sale_Date) VALUES
--(1, 'North', 'Amit', 'Laptop', 1200.00, '2024-01-01'),
--(2, 'South', 'Priya', 'Tablet', 800.00, '2024-01-01'),
--(3, 'North', 'Amit', 'Monitor', 1500.00, '2024-01-02'),
--(4, 'East', 'Ravi', 'Printer', 650.00, '2024-01-02'),
--(5, 'West', 'Sneha', 'Laptop', 2200.00, '2024-01-03'),
--(6, 'North', 'Amit', 'Mouse', 300.00, '2024-01-03'),
--(7, 'South', 'Priya', 'Keyboard', 450.00, '2024-01-04'),
--(8, 'East', 'Ravi', 'Tablet', 1200.00, '2024-01-04'),
--(9, 'West', 'Sneha', 'Monitor', 1800.00, '2024-01-05'),
--(10, 'North', 'Amit', 'Laptop', 2500.00, '2024-01-05'),
--(11, 'South', 'Priya', 'Printer', 950.00, '2024-01-06'),
--(12, 'East', 'Ravi', 'Mouse', 350.00, '2024-01-06'),
--(13, 'West', 'Sneha', 'Tablet', 1700.00, '2024-01-07'),
--(14, 'North', 'Amit', 'Keyboard', 550.00, '2024-01-07'),
--(15, 'South', 'Priya', 'Laptop', 2100.00, '2024-01-08'),
--(16, 'East', 'Ravi', 'Monitor', 1900.00, '2024-01-08'),
--(17, 'West', 'Sneha', 'Printer', 1150.00, '2024-01-09'),
--(18, 'North', 'Amit', 'Tablet', 1600.00, '2024-01-09'),
--(19, 'South', 'Priya', 'Mouse', 400.00, '2024-01-10'),
--(20, 'East', 'Ravi', 'Laptop', 1950.00, '2024-01-10');

-----

With Largest_Sale As
(
  Select 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    Sale_Amount,
    Sale_Date,
    ROW_NUMBER() over (partition by salesperson order by sale_date desc) as Row_Num
  from sales_data
)
Select 
  Sale_ID,
    Region,
    Salesperson,
    Product,
    Sale_Amount,
    Sale_Date
From Largest_Sale
where Row_Num = 1;

-----

Select * from
(Select 
Sale_ID,
Region,
Salesperson,
Product,
Sale_Amount,
Sale_Date,
DENSE_RANK() over (partition by region order by sale_amount desc) as Dense_Rank
from sales_data) temp
where Dense_Rank='1'

-----

With Region_wise_highest_sale as
(Select 
Sale_ID,
Region,
Salesperson,
Product,
Sale_Amount,
Sale_Date,
RANK() over (partition by region order by sale_amount desc) as Rank_
from sales_data)
Select * from Region_wise_highest_sale where Rank_=1

-----

WITH NTILE_SALE_AMOUNT AS 
(Select 
Sale_ID,
Region,
Salesperson,
Product,
Sale_Amount,
Sale_Date,
NTILE(4) over (order by sale_amount) as NTILE_
from sales_data)
Select 
FORMAT(AVG(Sale_Amount), 'N2') AS Formatted_Sale_Amount, 
NTILE_
from NTILE_SALE_AMOUNT
group by NTILE_

-----

SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    FORMAT(Sale_Amount, 'N2') AS Formatted_Sale_Amount,
    Sale_Date,
    PERCENT_RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount DESC) AS Percent_Rank
FROM sales_data
ORDER BY Region, Percent_Rank;

-----

WITH Ranked_Sales AS (
    SELECT 
        Sale_ID,
        Region,
        Salesperson,
        Product,
        Sale_Amount,
        Sale_Date,
        PERCENT_RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount DESC) AS Percent_Rank
    FROM sales_data
)
SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    FORMAT(Sale_Amount, 'N2') AS Formatted_Sale_Amount,
    Sale_Date,
    Percent_Rank
FROM Ranked_Sales
WHERE Percent_Rank <= 0.25
ORDER BY Region, Percent_Rank;

-----

WITH Cumulative_Distribution AS (
    SELECT 
        Sale_ID,
        Region,
        Salesperson,
        Product,
        Sale_Amount,
        Sale_Date,
        CUME_DIST() OVER (PARTITION BY Region ORDER BY Sale_Amount) AS Cume_Dist
    FROM sales_data
)
SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    FORMAT(Sale_Amount, 'N2') AS Formatted_Sale_Amount,
    Sale_Date,
    Cume_Dist
FROM Cumulative_Distribution
WHERE Cume_Dist <= 0.5
ORDER BY Region, Cume_Dist;

-----

WITH Rank_Compare AS (
    SELECT 
        Sale_ID,
        Region,
        Salesperson,
        Product,
        Sale_Amount,
        Sale_Date,
        PERCENT_RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount) AS Percent_Rank,
        CUME_DIST() OVER (PARTITION BY Region ORDER BY Sale_Amount) AS Cume_Dist
    FROM sales_data
)
SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    FORMAT(Sale_Amount, 'N2') AS Formatted_Sale_Amount,
    Sale_Date,
    Percent_Rank,
    Cume_Dist
FROM Rank_Compare
ORDER BY Region, Sale_Amount;

-----

WITH Sales_Rankings AS (
   SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    Sale_Amount,
    Sale_Date,
    ROUND(PERCENT_RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount), 2) AS Pct_Rank,
    ROUND(CUME_DIST() OVER (PARTITION BY Region ORDER BY Sale_Amount), 2) AS Cume_Dist
FROM sales_data
)
SELECT 
    Region,
    Salesperson,
    Product,
    FORMAT(Sale_Amount, 'N2') AS Formatted_Sale_Amount,
    Sale_Date,
    Pct_Rank,
    Cume_Dist,
    CASE 
        WHEN Pct_Rank <= 0.2 THEN 'Top 20% (PERCENT_RANK)'
        ELSE '---'
    END AS Pct_Rank_Remark,
    CASE 
        WHEN Cume_Dist <= 0.2 THEN 'Top 20% (CUME_DIST)'
        ELSE '---'
    END AS Cume_Dist_Remark
FROM Sales_Rankings
ORDER BY Region, Sale_Amount DESC;

-----

WITH Sales_Ranked AS (
    SELECT 
        Sale_ID,
        Region,
        Salesperson,
        Product,
        Sale_Amount,
        Sale_Date,
        ROUND(PERCENT_RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount), 2) AS Pct_Rank,
        ROUND(CUME_DIST() OVER (PARTITION BY Region ORDER BY Sale_Amount), 2) AS Cume_Dist
    FROM sales_data
)

SELECT *,
CASE 
  WHEN Cume_Dist > 0.75 THEN 'Top Performer'
  WHEN Pct_Rank <= 0.25 THEN 'Needs Attention'
  ELSE 'Average'
END AS Sales_Performance

FROM Sales_Ranked
WHERE 
    Cume_Dist > 0.75 -- Top 25%
    OR Pct_Rank <= 0.25 -- Bottom 25%
ORDER BY Region, Sale_Amount;

-----

WITH Sales_With_Quarter AS (
    SELECT 
        Sale_ID,
        Salesperson,
        Region,
        Product,
        Sale_Amount,
        Sale_Date,
        DATEPART(QUARTER, Sale_Date) AS Quarter,
        YEAR(Sale_Date) AS Sale_Year
    FROM sales_data
),
Quarterly_Sales AS (
    SELECT 
        Salesperson,
        Region,
        Sale_Year,
        Quarter,
        SUM(Sale_Amount) AS Total_Quarterly_Sales
    FROM Sales_With_Quarter
    GROUP BY Salesperson, Region, Sale_Year, Quarter
),
Sales_Comparison AS (
    SELECT 
		*,
		LAG(Total_Quarterly_Sales) OVER (
		PARTITION BY Salesperson, Region, Sale_Year 
		ORDER BY Quarter
		) AS Prev_Quarter_Sales
    FROM Quarterly_Sales
),
Sale_Diff AS (
	SELECT 
		Salesperson,
		Region,
		Sale_Year,
		Quarter,
		Total_Quarterly_Sales,
		ISNULL(Prev_Quarter_Sales, 0) AS Prev_Quarter_Sales,
		Total_Quarterly_Sales - ISNULL(Prev_Quarter_Sales, 0) AS Difference
	FROM Sales_Comparison
),
Ranked_Sales AS 
(
	SELECT 
		*,
        RANK() OVER (
            PARTITION BY Salesperson, Region, Sale_Year, Quarter 
            ORDER BY Difference DESC
			) AS Sales_Rank
    FROM Sale_Diff
)
	SELECT 
		Salesperson,
		Region,
		Sale_Year,
		Quarter,
		Total_Quarterly_Sales,
		Prev_Quarter_Sales,
		Difference,
		Sales_Rank
	FROM Ranked_Sales 
	ORDER BY Salesperson, Region, Sale_Year, Quarter;

-----

--INSERT INTO sales_data (Sale_ID, Region, Salesperson, Product, Sale_Amount, Sale_Date) VALUES
--(21, 'West', 'Amit', 'Laptop', 2086.76, '2023-05-24'),
--(22, 'West', 'Ravi', 'Printer', 2715.45, '2024-07-06'),
--(23, 'West', 'Priya', 'Laptop', 1566.36, '2023-11-30'),
--(24, 'East', 'Sneha', 'Mouse', 517.81, '2023-03-07'),
--(25, 'North', 'Ravi', 'Printer', 2694.42, '2024-09-16'),
--(26, 'West', 'Ravi', 'Mouse', 1033.90, '2023-09-12'),
--(27, 'South', 'Ravi', 'Keyboard', 584.08, '2024-01-25'),
--(28, 'South', 'Sneha', 'Monitor', 980.15, '2024-04-02'),
--(29, 'East', 'Amit', 'Laptop', 2011.16, '2024-07-27'),
--(30, 'West', 'Priya', 'Printer', 1559.89, '2024-07-26'),
--(31, 'North', 'Priya', 'Tablet', 1592.14, '2023-04-11'),
--(32, 'East', 'Ravi', 'Monitor', 1482.00, '2024-06-22'),
--(33, 'South', 'Sneha', 'Mouse', 452.60, '2024-08-09'),
--(34, 'South', 'Amit', 'Monitor', 1341.65, '2023-10-04'),
--(35, 'North', 'Sneha', 'Laptop', 1950.50, '2024-02-20'),
--(36, 'North', 'Ravi', 'Printer', 2100.00, '2023-01-15'),
--(37, 'East', 'Priya', 'Tablet', 1876.23, '2024-03-16'),
--(38, 'West', 'Sneha', 'Monitor', 1725.00, '2024-10-01'),
--(39, 'East', 'Ravi', 'Keyboard', 410.10, '2023-05-01'),
--(40, 'South', 'Amit', 'Laptop', 2220.75, '2024-11-11'),
--(41, 'North', 'Amit', 'Mouse', 365.20, '2024-12-05'),
--(42, 'North', 'Priya', 'Tablet', 1480.90, '2023-06-09'),
--(43, 'South', 'Sneha', 'Laptop', 2500.00, '2023-12-22'),
--(44, 'West', 'Ravi', 'Keyboard', 515.45, '2024-02-08'),
--(45, 'East', 'Sneha', 'Printer', 980.00, '2024-09-30'),
--(46, 'South', 'Priya', 'Mouse', 399.99, '2024-10-05'),
--(47, 'North', 'Sneha', 'Tablet', 1705.95, '2023-08-20'),
--(48, 'East', 'Amit', 'Monitor', 1467.35, '2023-07-12'),
--(49, 'South', 'Ravi', 'Tablet', 1589.75, '2023-09-18'),
--(50, 'North', 'Amit', 'Printer', 1905.50, '2023-02-28'),
--(51, 'West', 'Priya', 'Laptop', 2430.40, '2024-05-21'),
--(52, 'East', 'Sneha', 'Mouse', 425.30, '2023-06-15'),
--(53, 'North', 'Ravi', 'Monitor', 1399.00, '2023-11-05'),
--(54, 'South', 'Priya', 'Keyboard', 489.99, '2023-03-17'),
--(55, 'West', 'Amit', 'Mouse', 320.25, '2024-04-04'),
--(56, 'East', 'Ravi', 'Laptop', 1900.65, '2023-07-01'),
--(57, 'North', 'Sneha', 'Printer', 1111.11, '2023-08-25'),
--(58, 'South', 'Amit', 'Monitor', 1695.50, '2023-05-30'),
--(59, 'West', 'Sneha', 'Tablet', 1800.00, '2024-06-10'),
--(60, 'South', 'Priya', 'Laptop', 2050.75, '2023-10-10'),
--(61, 'East', 'Priya', 'Tablet', 1495.95, '2023-12-03'),
--(62, 'North', 'Ravi', 'Keyboard', 580.00, '2024-03-13'),
--(63, 'East', 'Amit', 'Mouse', 350.55, '2024-01-30'),
--(64, 'South', 'Ravi', 'Monitor', 1455.45, '2024-03-23'),
--(65, 'North', 'Priya', 'Laptop', 2300.00, '2024-06-01'),
--(66, 'West', 'Amit', 'Printer', 990.10, '2023-04-19'),
--(67, 'South', 'Sneha', 'Tablet', 1670.00, '2023-09-09'),
--(68, 'East', 'Ravi', 'Monitor', 1555.00, '2023-11-19'),
--(69, 'North', 'Amit', 'Mouse', 399.95, '2023-10-25'),
--(70, 'South', 'Priya', 'Keyboard', 444.44, '2023-05-13'),
--(71, 'West', 'Sneha', 'Laptop', 2600.00, '2024-08-18'),
--(72, 'East', 'Amit', 'Tablet', 1700.00, '2024-02-14'),
--(73, 'North', 'Sneha', 'Monitor', 1433.33, '2024-07-03'),
--(74, 'West', 'Ravi', 'Mouse', 505.05, '2023-06-26'),
--(75, 'South', 'Amit', 'Tablet', 1750.00, '2023-08-11'),
--(76, 'North', 'Priya', 'Printer', 1333.33, '2023-07-17'),
--(77, 'East', 'Sneha', 'Keyboard', 360.00, '2023-01-22'),
--(78, 'West', 'Priya', 'Monitor', 1455.55, '2023-03-14'),
--(79, 'East', 'Amit', 'Laptop', 2100.00, '2024-05-07'),
--(80, 'South', 'Sneha', 'Mouse', 380.00, '2023-02-04');

-----calculate the running total of sales for each region, within each year, month, in order of the sale date---

With Monthly_sales as
(
	Select 
		Region,
		Sale_Amount,
		Sale_Date,
		YEAR(Sale_Date) as Year_,
		month(Sale_Date) as Month_
	from sales_data
),
Running_total as 
(
	Select *,
		sum(Sale_Amount) 
		over (partition by region, Year_, Month_ 
		order by sale_date) as Running_total
	from Monthly_sales
)
	Select * 
	from Running_total
	where Year_='2024'
	order by Region, Year_, Month_

-----calculate the Moving Average

WITH Region_sales AS 
(
	Select 
		Region,
		Sale_Amount,
		Sale_Date,
		YEAR(Sale_Date) as YEAR_,
		MONTH(Sale_Date) as MONTH_
	from sales_data
),
Region_Sale_Moving_AVG as 
(
	select *,
		AVG(sale_amount) 
		over (partition by region 
		order by sale_date 
		rows between 2 preceding and current row) as Moving_AVG,
		COUNT(*) OVER (
		PARTITION BY region
		ORDER BY sale_date
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		) AS Row_Count
	from Region_sales
)
	Select 
		region,
		sale_amount,
		MONTH_,
		YEAR_,
		sale_date,
		Row_Count,
	format(Moving_AVG,'N2') as Moving_AVG
	from Region_Sale_Moving_AVG
	order by Region, Sale_Date

-----Calculate the Monthly Cumulative Average (Running Average per Region, Day by Day):

with Running_AVG_By_Date As
(
Select
Region,
Sale_Amount,
Sale_Date,
YEAR(Sale_Date) as Year_,
MONTH(Sale_Date) as Month_,
DAY(Sale_Date) as Day_,
AVG(Sale_Amount) 
over (partition by region 
order by sale_date 
rows between unbounded preceding and current row) as Running_Average_By_Date
from sales_data
)
Select 
Region,
Sale_Amount,
Sale_Date,
Year_,
Month_,
Day_,
FORMAT(Running_Average_By_Date,'N2') as Running_Average_By_Date
from Running_AVG_By_Date
order by Region, Year_, Month_, Day_

-----Calculate the Monthly Cumulative Average (Running Average per Region, Month by Month):

WITH Monthly_Sales AS (
    SELECT 
        Region,
        Sale_Amount,
        Sale_Date,
        YEAR(Sale_Date) AS Year_,
        MONTH(Sale_Date) AS Month_,
        CAST(DATEFROMPARTS(YEAR(Sale_Date), MONTH(Sale_Date), 1) AS DATE) AS Month_Start
    FROM sales_data
),
Monthly_Cumulative_Avg AS (
    SELECT 
        Region,
        Month_Start,
        AVG(Sale_Amount) 
            OVER (
                PARTITION BY Region 
                ORDER BY Month_Start 
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS Monthly_Running_Avg
    FROM Monthly_Sales
)
SELECT 
    Region,
    FORMAT(Month_Start, 'yyyy-MM') AS Month_,
    FORMAT(Monthly_Running_Avg, 'N2') AS Monthly_Cumulative_Average
FROM Monthly_Cumulative_Avg
GROUP BY Region, Month_Start, Monthly_Running_Avg
ORDER BY Region, Month_Start;

-----Cumulative Count

With Cumulative_Sale_Count as
(
Select 
Region,
Sale_Amount,
Sale_Date,
YEAR(Sale_Date) as Year_,
MONTH(Sale_Date) as Month_,
count(*) 
over (partition by region 
order by sale_date
rows between unbounded preceding and current row) as Cumulative_count
from sales_data)
select * 
from Cumulative_Sale_Count
order by Region, Sale_Date;

-----Track Cumulative Unique Products Sold in Each Region Over Time

WITH Ranked_Products AS (
    SELECT 
        Region,
        Product,
        Sale_Date,
        MIN(Sale_Date) OVER (PARTITION BY Region, Product) AS First_Sale_Date
    FROM sales_data
),
Region_Dates AS (
    SELECT DISTINCT Region, Sale_Date FROM sales_data
),
Cumulative_Unique_Product_Count AS (
    SELECT 
        RD.Region,
        RD.Sale_Date,
        COUNT(DISTINCT RP.Product) AS Cumulative_Products_Sold
    FROM Region_Dates RD
    LEFT JOIN Ranked_Products RP
        ON RP.Region = RD.Region
        AND RP.First_Sale_Date <= RD.Sale_Date
    GROUP BY RD.Region, RD.Sale_Date
)
SELECT * 
FROM Cumulative_Unique_Product_Count
ORDER BY Region, Sale_Date;

-----Running Minimum and Maximum

SELECT 
    Region,
    Sale_Date,
    Sale_Amount,
    MAX(Sale_Amount) OVER (
        PARTITION BY Region 
        ORDER BY Sale_Date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Max_Sale_So_Far,
    MIN(Sale_Amount) OVER (
        PARTITION BY Region 
        ORDER BY Sale_Date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Min_Sale_So_Far
FROM sales_data
ORDER BY Region, Sale_Date;

-----Real-World Challenge: Sales Performance Tracker

With Running_Max_Min As
(
Select 
	Region,
	Product,
	Sale_Amount,
	Sale_Date,
	Max(Sale_Amount) 
	Over (Partition By region,Product 
	Order By sale_date
	Rows Between Unbounded Preceding And Current Row) As Max_Value,
	Min(Sale_Amount)
	Over (Partition By region,Product
	Order By sale_date
	Rows between Unbounded Preceding and Current Row) As Min_Value
From sales_data
)
Select *,
	(Sale_Amount - Max_Value) As diff_,
	CAST(
    FORMAT(
        ((Sale_Amount - Max_Value) * 100.0) / Max_Value,
        'N2'
    ) + '%'
AS VARCHAR) AS Percent_diff_

	From Running_Max_Min
	Order By region, product, Sale_Date

-----Identify Sudden Drop in Sales

WITH Max_Sale_Per_Region AS (
    SELECT 
        region,
        product,
        sale_amount,
        sale_date,
        MAX(sale_amount) OVER (
            PARTITION BY region, product 
            ORDER BY sale_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Max_Sale_As_Date
    FROM sales_data
),
Growth_By_Percent AS (
    SELECT *,
        ((sale_amount - Max_Sale_As_Date) * 100.0) / Max_Sale_As_Date AS Growth_Percent,
        ROW_NUMBER() OVER (PARTITION BY region, product ORDER BY sale_date) AS First_Instance
    FROM Max_Sale_Per_Region
),
Filtered_Drop AS (
    SELECT *
    FROM Growth_By_Percent
    WHERE Growth_Percent < -20.0
)
-- First significant drop for each region-product
SELECT 
    region,
    product,
    sale_date,
    sale_amount,
    Max_Sale_As_Date,
    FORMAT(Growth_Percent, 'N2') + '%' AS Drop_Percent
FROM Filtered_Drop
--WHERE First_Instance = 1
ORDER BY region, product, sale_date;

-----Analyze Regional Trends with 3-Day Moving Average

WITH Moving_Avg_Calc AS (
  SELECT
    Region,
    Product,
    Sale_Date,
    Sale_Amount,
    CAST(
      AVG(Sale_Amount * 1.0) OVER (
        PARTITION BY Region, Product
        ORDER BY Sale_Date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
      ) AS DECIMAL(10,2)
    ) AS Moving_Avg_3_Day
  FROM sales_data
  WHERE Sale_Amount IS NOT NULL
)
SELECT *
FROM Moving_Avg_Calc
WHERE Moving_Avg_3_Day > 2000
ORDER BY Region, Product, Sale_Date

-----Rank the products within each region based on their sales amount, where the highest sales get the highest rank.

SELECT 
    Region,
    Product,
    Sale_Amount,
    RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount DESC) AS Rank_Per_Region
FROM sales_data
ORDER BY Region, Rank_Per_Region;

-----Calculate the difference in sales between the top-ranked product and the second-ranked product in each region.

WITH Ranked_Sales AS
(
    SELECT 
        Region,
        Product,
        Sale_Amount,
        RANK() OVER (PARTITION BY Region ORDER BY Sale_Amount DESC) AS Rank_Per_Region
    FROM sales_data
)
SELECT 
    Region,
    Product,
    Sale_Amount,
    Rank_Per_Region,
    CASE
        WHEN Rank_Per_Region = 1 THEN
            Sale_Amount - 
            (SELECT Sale_Amount 
             FROM Ranked_Sales 
             WHERE Region = rs.Region AND Rank_Per_Region = 2)
        ELSE NULL
    END AS Sales_Difference_To_Second_Rank
FROM Ranked_Sales rs
ORDER BY Region, Rank_Per_Region;

-----OVER () without PARTITION BY – Full Table Analysis - Part:1

SELECT *,
  RANK() OVER (ORDER BY sale_amount DESC) AS global_rank
FROM sales_data;

SELECT *,
sale_amount * 100.0 / SUM(sale_amount) OVER () AS pct_of_total
FROM sales_data;

SELECT *,
  SUM(sale_amount) OVER (ORDER BY sale_amount) AS running_total
FROM sales_data;

-----OVER () without PARTITION BY – Full Table Analysis - Part:2


Select *,
RANK() over (order by sale_amount desc) as Global_Sales_Rank
from sales_data;

SELECT 
  region, 
  sale_amount, 
  sale_date, 
  SUM(sale_amount) OVER () AS Total_Sum,
  FORMAT(pct_of_total, 'N2') AS PCT_Contribution
FROM
(
  SELECT *,
         sale_amount * 100.0 / SUM(sale_amount) OVER () AS pct_of_total
  FROM sales_data
) temp;


Select *,
sum(sale_amount) over (order by sale_amount desc) as Total_Sum
from sales_data;

Select *,
ROW_NUMBER() over (order by sale_amount desc) as Row_Num_
from sales_data;

Select Region, Sale_amount, Sale_date,
max(sale_amount) over () as Max_Sales,
Diff_From_Max_Sales
From
(
Select *,
sale_amount - max(sale_amount) over () as Diff_From_Max_Sales
From Sales_data) temp
order by Region, Sale_Amount;

-----