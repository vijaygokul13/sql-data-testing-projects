-----


--select * from sales_data;


--select * from sales_targets;


--CREATE TABLE sales_targets (
--    Region VARCHAR(50),
--    Salesperson VARCHAR(50),
--    Month VARCHAR(7), -- Format: 'YYYY-MM'
--    Target_Amount DECIMAL(10, 2)
--);


--INSERT INTO sales_targets (Region, Salesperson, Month, Target_Amount) VALUES
--('North', 'Amit', '2024-01', 4000.00),
--('North', 'Amit', '2024-02', 3500.00),
--('North', 'Amit', '2024-04', 2500.00),
--('South', 'Priya', '2024-01', 3000.00),
--('South', 'Priya', '2024-06', 3200.00),
--('South', 'Priya', '2024-12', 3000.00),
--('East', 'Ravi', '2024-01', 2000.00),
--('East', 'Ravi', '2024-08', 1200.00),
--('West', 'Sneha', '2024-01', 3500.00),
--('West', 'Sneha', '2024-05', 1000.00),
--('Central', 'Anjali', '2024-09', 1800.00),
--('West', 'Deepak', '2024-10', 2200.00),
--('North', 'Deepak', '2024-02', 2000.00),
--('South', 'Rahul', '2024-03', 1000.00),
--('Central', 'Meena', '2024-07', 1000.00),
--('East', 'Meena', '2025-01', 1000.00);


---- PRODUCTS table
--CREATE TABLE products (
--    product VARCHAR(50) PRIMARY KEY,
--    category VARCHAR(50),
--    price DECIMAL(10,2)
--);


---- SALESPERSONS table
--CREATE TABLE salespersons (
--    name VARCHAR(50) PRIMARY KEY,
--    hire_date DATE
--);


---- REGIONS table
--CREATE TABLE regions (
--    region VARCHAR(50) PRIMARY KEY,
--    region_name VARCHAR(100)
--);


---- CUSTOMERS table (optional for future use)
--CREATE TABLE customers (
--    customer_id INT PRIMARY KEY,
--    name VARCHAR(50),
--    join_date DATE,
--    age INT,
--    loyalty_score INT
--);


--INSERT INTO products (product, category, price) VALUES
--('Laptop', 'Electronics', 2000.00),
--('Tablet', 'Electronics', 1000.00),
--('Monitor', 'Electronics', 1600.00),
--('Printer', 'Electronics', 650.00),
--('Mouse', 'Accessories', 300.00),
--('Keyboard', 'Accessories', 500.00),
--('Headphones', 'Accessories', 350.00),
--('Webcam', 'Accessories', 750.00),
--('Scanner', 'Electronics', 1200.00),
--('Chair', 'Furniture', 2200.00),
--('Desk', 'Furniture', 3000.00),
--('Docking Station', 'Electronics', 650.00);


--INSERT INTO salespersons (name, hire_date) VALUES
--('Amit', '2020-01-15'),
--('Priya', '2019-06-10'),
--('Ravi', '2021-03-05'),
--('Sneha', '2020-11-20'),
--('Anjali', '2018-09-25'),
--('Rahul', '2022-02-28'),
--('Meena', '2023-01-12'),
--('Deepak', '2021-05-30');


--INSERT INTO regions (region, region_name) VALUES
--('North', 'Northern Region'),
--('South', 'Southern Region'),
--('East', 'Eastern Region'),
--('West', 'Western Region'),
--('Central', 'Central Region');


--INSERT INTO customers (customer_id, name, join_date, age, loyalty_score) VALUES
--(101, 'Ramesh', '2023-01-01', 32, 80),
--(102, 'Sita', '2022-06-12', 27, 65),
--(103, 'Karan', '2021-08-25', 45, NULL),
--(104, 'Priyanka', '2024-03-10', 39, 95),
--(105, 'Nikhil', '2023-11-05', 30, 55);


-----Simple Case - Classify some products into categories based on fixed rules.


SELECT 
    Sale_ID,
    Product,
    CASE Product
        WHEN 'Laptop' THEN 'Electronics'
        WHEN 'Tablet' THEN 'Electronics'
        WHEN 'Monitor' THEN 'Electronics'
        WHEN 'Chair' THEN 'Furniture'
		WHEN 'Desk' THEN 'Furniture'
        ELSE 'Other'
    END AS Product_Category
FROM sales_data;


-----Searched CASE - Categorize sales as High, Medium, or Low based on Sale_Amount


SELECT 
    Sale_ID,
    Product,
    Sale_Amount,
    CASE 
        WHEN Sale_Amount >= 2000 THEN 'High'
        WHEN Sale_Amount BETWEEN 1000 AND 1999.99 THEN 'Medium'
        ELSE 'Low'
    END AS Sale_Category
FROM sales_data;


-----CASE in ORDER BY Clause - Sort products by priority: Laptop > Tablet > Monitor > Others


SELECT 
    Product,
    Sale_Amount
FROM sales_data
ORDER BY 
    CASE 
        WHEN Product = 'Laptop' THEN 1
        WHEN Product = 'Tablet' THEN 2
        WHEN Product = 'Monitor' THEN 3
        ELSE 4
    END;


-----CASE in GROUP BY and Aggregations - Total sales split by product category – "Computer Devices" vs "Accessories"


SELECT 
  CASE 
    WHEN Product IN ('Laptop', 'Tablet', 'Monitor') THEN 'Computer Devices'
    ELSE 'Accessories'
  END AS Product_Category,
  SUM(Sale_Amount) AS Total_Sales
FROM sales_data
GROUP BY 
  CASE 
    WHEN Product IN ('Laptop', 'Tablet', 'Monitor') THEN 'Computer Devices'
    ELSE 'Accessories'
  END;


-----Nested CASE Statements -Multi-level product performance classification


SELECT 
  Sale_ID,
  Product,
  Sale_Amount,
  CASE 
    WHEN Product = 'Laptop' AND Sale_Amount >= 2000 THEN 'High-end Laptop'
    WHEN Product = 'Tablet' AND Sale_Amount < 1000 THEN 'Budget Tablet'
    WHEN Product = 'Monitor' THEN 
        CASE 
            WHEN Sale_Amount >= 1500 THEN 'Premium Monitor'
            ELSE 'Standard Monitor'
        END
    ELSE 'Standard Product'
  END AS Product_Category
FROM sales_data
ORDER BY Product, Sale_Amount DESC;


-----CASE in WHERE Clause


DECLARE @ProductFilter VARCHAR(50) = 'Laptop';

SELECT 
  Sale_ID,
  Product,
  Sale_Amount,
  Sale_Date
FROM sales_data
WHERE 
  Product = 
    CASE 
      WHEN @ProductFilter = 'All' THEN Product  -- matches all
      ELSE @ProductFilter
    END;


-----CASE in JOIN Conditions (Advance) 
--For each salesperson in Jan 2024, show their total sales, target, 
--and a performance label (‘Above Target’, ‘Met Target’, ‘Below Target’)


SELECT
    s.Region,
    s.Salesperson,
    s.Sale_Month,
    s.Total_Sales,
    t.Target_Amount,
    CASE
        WHEN s.Total_Sales > t.Target_Amount THEN 'Above Target'
        WHEN s.Total_Sales = t.Target_Amount THEN 'Met Target'
        WHEN s.Total_Sales < t.Target_Amount THEN 'Below Target'
        ELSE 'No Target Data'
    END AS Performance
FROM
    (
        SELECT
            Region,
            Salesperson,
            FORMAT(Sale_Date, 'yyyy-MM') AS Sale_Month,
            SUM(Sale_Amount) AS Total_Sales
        FROM
            sales_data
        WHERE
            Sale_Date >= '2024-01-01' AND Sale_Date < '2024-02-01'
        GROUP BY
            Region, Salesperson, FORMAT(Sale_Date, 'yyyy-MM')
    ) s
LEFT JOIN sales_targets t
    ON s.Region = t.Region
    AND s.Salesperson = t.Salesperson
    AND s.Sale_Month = t.Month;


-----Case Study including Product Price Binning + NULL Handling using CASE + JOIN + AGGREGATES + SUBQUERIES
--Management wants to classify product sales into price categories (High / Medium / Low) and 
--summarize how many sales and total revenue fall under each bin, by salesperson and region, for the year 2024 only.
--They also want:
--NULL-safe CASE handling in case some products have missing prices.
--Only actual sales (not target) should be considered.
--Binning logic:
--High: Price > 1500
--Medium: Price BETWEEN 800 AND 1500
--Low: Price < 800
--Unknown: NULL price


SELECT
    sd.Region,
    sd.Salesperson,
    CASE 
        WHEN p.price IS NULL THEN 'Unknown'
        WHEN p.price > 1500 THEN 'High'
        WHEN p.price BETWEEN 800 AND 1500 THEN 'Medium'
        WHEN p.price < 800 THEN 'Low'
    END AS Price_Category,
    COUNT(*) AS Sale_Count,
    SUM(sd.Sale_Amount) AS Total_Revenue
FROM
    sales_data sd
LEFT JOIN
    products p ON sd.Product = p.product
WHERE
    YEAR(sd.Sale_Date) = 2024
GROUP BY
    sd.Region,
    sd.Salesperson,
    CASE 
        WHEN p.price IS NULL THEN 'Unknown'
        WHEN p.price > 1500 THEN 'High'
        WHEN p.price BETWEEN 800 AND 1500 THEN 'Medium'
        WHEN p.price < 800 THEN 'Low'
    END
ORDER BY
    sd.Region,
    sd.Salesperson,
    Price_Category;


-----Using CASE  with JOIN + Aggregates to Compare Actual vs Target Sales Performance
--Evaluate whether each salesperson has met, exceeded, or missed their monthly sales targets using:


WITH sales_summary AS (
    SELECT 
        Region,
        Salesperson,
        FORMAT(Sale_Date, 'yyyy-MM') AS Sale_Month,
        SUM(Sale_Amount) AS Total_Sales
    FROM sales_data
    GROUP BY Region, Salesperson, FORMAT(Sale_Date, 'yyyy-MM')
)

SELECT 
    COALESCE(s.Region, t.Region) AS Region,
    COALESCE(s.Salesperson, t.Salesperson) AS Salesperson,
    COALESCE(s.Sale_Month, t.Month) AS Sale_Month,
    ISNULL(s.Total_Sales, 0) AS Total_Sales,
    ISNULL(t.Target_Amount, 0) AS Target_Amount,
    CASE 
        WHEN t.Target_Amount IS NULL THEN 'No Target Assigned'
        WHEN s.Total_Sales IS NULL THEN 'No Sales'
        WHEN s.Total_Sales < t.Target_Amount THEN 'Target Missed'
        WHEN s.Total_Sales = t.Target_Amount THEN 'Target Met'
        WHEN s.Total_Sales > t.Target_Amount THEN 'Target Exceeded'
    END AS Performance_Status
FROM 
    sales_summary s
FULL OUTER JOIN 
    sales_targets t
    ON s.Region = t.Region 
    AND s.Salesperson = t.Salesperson 
    AND s.Sale_Month = t.Month
ORDER BY 
    Region, Salesperson, Sale_Month;


-----Using Multiple CASE Statements for Data Binning, Product Categories, and Salesperson Performance
--In this case study, we’ll enrich the sales report by:
--Classifying products into broader product categories using one CASE.
--Binning Sale_Amount into High / Medium / Low sales ranges using another CASE.
--Adding a custom sales performance label based on the salesperson's average sales.


WITH salesperson_avg AS (
    SELECT 
        Salesperson,
        AVG(Sale_Amount) AS Avg_Sale
    FROM sales_data
    GROUP BY Salesperson
)

SELECT 
    s.Sale_ID,
    s.Salesperson,
    s.Product,
    s.Sale_Amount,
    s.Sale_Date,
    CASE 
        WHEN Product IN ('Mouse', 'Keyboard', 'Headphones', 'Webcam', 'Docking Station') THEN 'Accessories'
        WHEN Product IN ('Chair', 'Desk') THEN 'Furniture'
        WHEN Product IN ('Laptop', 'Monitor', 'Tablet', 'Printer', 'Scanner') THEN 'Computing'
        ELSE 'Others'
    END AS Product_Category,
    CASE 
        WHEN Sale_Amount < 800 THEN 'Low'
        WHEN Sale_Amount BETWEEN 800 AND 2000 THEN 'Medium'
        WHEN Sale_Amount > 2000 THEN 'High'
        ELSE 'Unknown'
    END AS Sale_Tier,
    CASE 
        WHEN a.Avg_Sale < 1000 THEN 'Poor Performer'
        WHEN a.Avg_Sale BETWEEN 1000 AND 2000 THEN 'Moderate Performer'
        WHEN a.Avg_Sale > 2000 THEN 'Strong Performer'
        ELSE 'Not Classified'
    END AS Salesperson_Performance
FROM sales_data s
LEFT JOIN salesperson_avg a
    ON s.Salesperson = a.Salesperson
ORDER BY 
    s.Salesperson, s.Sale_Date;


-----Custom Sorting & Ranking with CASE
--Management wants a ranked sales report with:
--Priority Sorting:
--Show sales from North, West, and East first (in that order),
--Then show South, then Central.
--Achieved using CASE in ORDER BY.
--Custom Ranking:
--Rank sales within each Region based on:
--High-value products like Laptop, Monitor, Desk first,
--Then moderate ones like Tablet, Scanner, Chair,
--Then the rest.
--Achieved by assigning a priority number with CASE and using ROW_NUMBER().


WITH ranked_sales AS (
    SELECT 
        Sale_ID,
        Region,
        Salesperson,
        Product,
        Sale_Amount,
        Sale_Date,
        CASE 
            WHEN Region = 'North' THEN 1
            WHEN Region = 'West' THEN 2
            WHEN Region = 'East' THEN 3
            WHEN Region = 'South' THEN 4
            WHEN Region = 'Central' THEN 5
            ELSE 6
        END AS Region_Sort_Order,
        CASE 
            WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 1
            WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 2
            ELSE 3
        END AS Product_Importance,
        ROW_NUMBER() OVER (
            PARTITION BY Region 
            ORDER BY 
                CASE 
                    WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 1
                    WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 2
                    ELSE 3
                END,
                Sale_Amount DESC
        ) AS Region_Custom_Rank

    FROM sales_data
)

SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    Sale_Amount,
    Sale_Date,
    Region_Custom_Rank
FROM ranked_sales
ORDER BY 
    Region_Sort_Order,
    Region_Custom_Rank;


-----Combining CASE with Mathematical Expressions
--Management wants to evaluate adjusted revenue where:
--High-end products (Laptop, Monitor, Desk) get a 10% bonus on their sale amount.
--Mid-tier products (Tablet, Scanner, Chair) get a 5% bonus.
--Others get no bonus.
--Additionally, we want to:
--Calculate bonus value.
--Show adjusted sale value = original + bonus.
--Mark if the adjusted sale is above ₹2,000 using CASE.


SELECT 
    Sale_ID,
    Region,
    Salesperson,
    Product,
    Sale_Amount,

    -- Bonus percentage logic using CASE
    CASE 
        WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 0.10
        WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 0.05
        ELSE 0.00
    END AS Bonus_Percentage,

    -- Bonus amount using CASE inside mathematical expression
    ROUND(Sale_Amount * 
        CASE 
            WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 0.10
            WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 0.05
            ELSE 0.00
        END, 2
    ) AS Bonus_Amount,

    -- Final adjusted sale value
    ROUND(Sale_Amount + 
        Sale_Amount * 
        CASE 
            WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 0.10
            WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 0.05
            ELSE 0.00
        END, 2
    ) AS Adjusted_Sale_Amount,

    -- Marking high adjusted value
    CASE 
        WHEN Sale_Amount + Sale_Amount * 
            CASE 
                WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 0.10
                WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 0.05
                ELSE 0.00
            END > 2000 THEN 'High Sale'
        ELSE 'Regular Sale'
    END AS Sale_Category

FROM sales_data
ORDER BY Adjusted_Sale_Amount DESC;


-----Performance Tips for CASE in Large Queries
--The sales_data table has grown large (imagine millions of records). We are calculating:
--Bonus Category
--Adjusted Sale Amount
--Sale Type using CASE logic multiple times.
--You want to do this efficiently without repeating CASE logic.

WITH sales_with_bonus AS (
    SELECT 
        *,
        CASE 
            WHEN Product IN ('Laptop', 'Monitor', 'Desk') THEN 0.10
            WHEN Product IN ('Tablet', 'Scanner', 'Chair') THEN 0.05
            ELSE 0.00
        END AS Bonus_Percentage
    FROM sales_data
)

SELECT 
    Sale_ID,
    Salesperson,
    Product,
    Sale_Amount,
    Bonus_Percentage,
    format(Sale_Amount * Bonus_Percentage, 'N2') AS Bonus_Amount,
    format(Sale_Amount + Sale_Amount * Bonus_Percentage, 'N2') AS Adjusted_Sale_Amount
FROM sales_with_bonus
ORDER BY Adjusted_Sale_Amount DESC;


-----

