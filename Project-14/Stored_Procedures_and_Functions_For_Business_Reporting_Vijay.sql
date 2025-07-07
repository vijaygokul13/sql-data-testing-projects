-----Challenge 1: CREATE & EXECUTE a Basic Stored Procedure with Input Parameter
--Create a stored procedure
--Use input parameters
--Execute it
--You want to fetch all customer records from a specific region (e.g., 'North') using a stored procedure.


CREATE PROCEDURE GetCustomersByRegion
    @Region NVARCHAR(50)
AS
BEGIN
    SELECT customer_name, region, purchase_amount, loyalty_score
    FROM data_conversion_practice
    WHERE region = @Region
END

EXEC GetCustomersByRegion @Region = 'North';


-----Challenge 2: Stored Procedure with OUTPUT Parameter
--Get Customer Info by Email (with OUTPUTs)
--Retrieve a customer's:
--Name
--Region
--Loyalty Score
--→ Based on their email address
--→ Return all values via OUTPUT parameters.

CREATE PROCEDURE GetCustomerDetailsByEmail
    @Email NVARCHAR(100),
    @CustomerName NVARCHAR(100) OUTPUT,
    @Region NVARCHAR(50) OUTPUT,
    @LoyaltyScore DECIMAL(5, 2) OUTPUT
AS
BEGIN
    SELECT 
        @CustomerName = customer_name,
        @Region = region,
        @LoyaltyScore = loyalty_score
    FROM data_conversion_practice
    WHERE email = @Email
END

---

DECLARE 
    @Name NVARCHAR(100),
    @Reg NVARCHAR(50),
    @Score DECIMAL(5, 2);

EXEC GetCustomerDetailsByEmail
    @Email = 'ramesh@example.com',
    @CustomerName = @Name OUTPUT,
    @Region = @Reg OUTPUT,
    @LoyaltyScore = @Score OUTPUT;

SELECT 
    @Name AS Cust_Name,
    @Reg AS Region_1,
    @Score AS Loyalty_Score;



-----Challenge 3: Stored Procedure with OUTPUT Parameter. Get Customer's Purchase Summary
--Your team needs a stored procedure that takes a customer's name and returns:
--Total number of purchases they made (@TotalPurchases)
--Total amount spent by that customer (@TotalSpent)
--Average discount they received (@AvgDiscount)


ALTER PROCEDURE GetCustomerPurchaseSummary
    @CustomerName NVARCHAR(100),
    @TotalPurchases INT OUTPUT,
    @TotalSpent DECIMAL(18, 2) OUTPUT,
    @AvgDiscount FLOAT OUTPUT
AS
BEGIN
    SELECT 
        @TotalPurchases = COUNT(*),
        @TotalSpent = SUM(purchase_amount),
        @AvgDiscount = AVG(discount_percentage)
    FROM data_conversion_practice
    WHERE customer_name = @CustomerName
	and purchase_amount is not null;
END;


---

DECLARE 
    @Purchases INT,
    @Spent DECIMAL(18, 2),
    @Discount FLOAT;

EXEC GetCustomerPurchaseSummary
    @CustomerName = 'sita verma',
    @TotalPurchases = @Purchases OUTPUT,
    @TotalSpent = @Spent OUTPUT,
    @AvgDiscount = @Discount OUTPUT;

SELECT 
    @Purchases AS TotalPurchases,
    @Spent AS TotalSpent,
    @Discount AS AvgDiscountReceived;


---Challenge 4: Stored Procedure with OUTPUT Parameters
--Create a stored procedure that takes product ID as input and returns the following using OUTPUT parameters:
--Product Name
--Product Category
--Total Purchase Amount (for all customers who bought it)


ALTER PROCEDURE GetProductDetailsByProductID
    @productid NVARCHAR(10),  -- must match actual data type in your table
    @productname NVARCHAR(50) OUTPUT,
    @productcategory NVARCHAR(50) OUTPUT,
    @totalpurchase DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT 
        @productname = product_name,
        @productcategory = product_category,
        @totalpurchase = SUM(purchase_amount)
    FROM data_conversion_practice
    WHERE product_id = @productid
      AND purchase_amount IS NOT NULL
    GROUP BY product_name, product_category
END

---

DECLARE 
    @P_Name NVARCHAR(50),
    @P_Category NVARCHAR(50),
    @P_Total DECIMAL(10,2)

EXEC GetProductDetailsByProductID 
    @productid = 'P001',
    @productname = @P_Name OUTPUT,
    @productcategory = @P_Category OUTPUT,
    @totalpurchase = @P_Total OUTPUT

SELECT
    @P_Name AS Prod_Name,
    @P_Category AS Prod_Category,
    @P_Total AS Total_Sale


-----Challenge 5: Create a stored procedure that returns the total purchase amount and average loyalty score for a specific region, 
--using output parameters.


ALTER PROCEDURE GetTotalPurchase_AvgScore_ByRegion
    @region NVARCHAR(50),
    @total_purchase DECIMAL(10,2) OUTPUT,
    @average_score DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT 
        @total_purchase = SUM(dc1.purchase_amount),
        @average_score = AVG(dc1.loyalty_score)
    FROM data_conversion_practice dc1
    WHERE dc1.region = @region
END

--

DECLARE 
    @T_Purchase DECIMAL(10,2),
    @A_Score DECIMAL(10,2)

EXEC GetTotalPurchase_AvgScore_ByRegion 
    @region = 'south',
    @total_purchase = @T_Purchase OUTPUT,
    @average_score = @A_Score OUTPUT

SELECT
    @T_Purchase AS total_sale,
    @A_Score AS average_score


-----Challenge 6: Output Parameters with Aggregated Performance Insights
--You work for a business that wants to track the performance of a specific product category across the company.
--They need a procedure where they can pass a @product_category and get:
--Total number of products sold in that category (@product_count)
--Average purchase amount (@average_purchase)
--Create a stored procedure named: GetCategoryPerformanceStats
--Accept one input parameter: @category_name
--Return two output parameters:
--@product_count (INT)
--@average_purchase (DECIMAL(10,2))


alter procedure GetCategoryPerformanceStats
@category varchar (50),
@product_count  INT output,
@average_purchase DECIMAL(10,2) output
As
Begin
select 
@product_count = count(record_id),
@average_purchase = round(avg(purchase_amount),2)
from data_conversion_practice dc1
where dc1.product_category = @category
End

---

declare
@P_Count int,
@A_Purchase decimal(10,2)

exec GetCategoryPerformanceStats
@category = 'Electronics',
@product_count = @P_Count output,
@average_purchase = @A_Purchase output

select
@P_Count as total_sale_count,
@A_Purchase as average_sale_amount


-----Challenge 7: Create Scalar Function
--Get loyalty category of a customer based on their loyalty score”
--Categories:
--90 and above → 'Platinum'
--70 to 89 → 'Gold'
--50 to 69 → 'Silver'
--< 50 → 'Bronze'


CREATE FUNCTION dbo.GetLoyaltyCategory
(
    @score INT
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @category VARCHAR(20)

    IF @score >= 90
        SET @category = 'Platinum'
    ELSE IF @score >= 70
        SET @category = 'Gold'
    ELSE IF @score >= 50
        SET @category = 'Silver'
    ELSE
        SET @category = 'Bronze'

    RETURN @category
END

---

SELECT 
    customer_name,
    loyalty_score,
    dbo.GetLoyaltyCategory(loyalty_score) AS loyalty_level
FROM data_conversion_practice
WHERE loyalty_score IS NOT NULL;


-----Challenge 8: Write a scalar function named GetDiscountCategory that returns a discount label 
--(High, Medium, Low, or No Discount) based on the discount_percentage.
--| discount\_percentage | Category      |
--| -------------------- | ------------- |
--| >= 30                | 'High'        |
--| >= 10 and < 30       | 'Medium'      |
--| > 0 and < 10         | 'Low'         |
--| = 0 or NULL          | 'No Discount' |
--Create the function dbo.GetDiscountCategory(@discount_percent FLOAT)
--Use IF...ELSE or CASE logic inside
--Return a VARCHAR(20) discount category


ALTER FUNCTION dbo.GetDiscountCategory
(
    @discount_percent FLOAT
)
RETURNS VARCHAR(20)
AS 
BEGIN
    DECLARE @category VARCHAR(20)

    IF @discount_percent IS NULL
        SET @category = 'No Discount'
    ELSE IF @discount_percent = 0
        SET @category = 'No Discount'
    ELSE IF @discount_percent >= 30
        SET @category = 'High'
    ELSE IF @discount_percent >= 10 AND @discount_percent < 30
        SET @category = 'Medium'
    ELSE IF @discount_percent > 0 AND @discount_percent < 10
        SET @category = 'Low'

    RETURN @category
END

---

SELECT 
    customer_name,
    discount_percentage,
    dbo.GetDiscountCategory(discount_percentage) AS discount_label
FROM data_conversion_practice;


-----Challenge 9: Create a Scalar Function to Generate a Customer Tier Label
--Based on multiple conditions, assign a Customer Tier such as Platinum, Gold, Silver, Bronze, or New.
--Logic to Implement: Create a function dbo.GetCustomerTier that takes:
--@loyalty_score (FLOAT)
--@purchase_amount (DECIMAL(10,2))
--@join_date (DATE)
--And returns:
--Tier (VARCHAR(20))
--Tier Rules (combine all conditions):
--Platinum loyalty_score >= 90 AND purchase_amount >= 3000 AND joined > 2 years ago
--Gold loyalty_score >= 75 AND purchase_amount >= 1500 AND joined > 1 year ago
--Silver loyalty_score >= 60 AND purchase_amount >= 800
--Bronze loyalty_score >= 40 OR purchase_amount >= 500
--New Otherwise


CREATE FUNCTION dbo.GetCustomerTier
(
    @loyalty_score FLOAT,
    @purchase_amount DECIMAL(10,2),
    @join_date DATE
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @tier VARCHAR(20)

    IF @loyalty_score >= 90 AND @purchase_amount >= 3000 AND DATEDIFF(YEAR, @join_date, GETDATE()) >= 2
        SET @tier = 'Platinum'
    ELSE IF @loyalty_score >= 75 AND @purchase_amount >= 1500 AND DATEDIFF(YEAR, @join_date, GETDATE()) >= 1
        SET @tier = 'Gold'
    ELSE IF @loyalty_score >= 60 AND @purchase_amount >= 800
        SET @tier = 'Silver'
    ELSE IF @loyalty_score >= 40 OR @purchase_amount >= 500
        SET @tier = 'Bronze'
    ELSE
        SET @tier = 'New'

    RETURN @tier
END

---

SELECT 
    customer_name,
    loyalty_score,
    purchase_amount,
    join_date,
    dbo.GetCustomerTier(loyalty_score, purchase_amount, join_date) AS customer_tier
FROM data_conversion_practice
WHERE loyalty_score IS NOT NULL 
  AND purchase_amount IS NOT NULL 
  AND join_date IS NOT NULL;


-----Challenge 10: Table-Valued Function (TVF) – Return Products by Category & Min Discount Filter
--You are building a reusable function to retrieve products within a specific category that also have a minimum discount percentage.
--This can help teams filter for promotions or category-based campaigns.


CREATE FUNCTION dbo.fn_GetProductsByCategoryAndDiscount
(
    @Category VARCHAR(50),
    @MinDiscount FLOAT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        product_name,
        product_category,
        purchase_amount,
        discount_percentage,
        region,
        sale_date
    FROM data_conversion_practice
    WHERE 
        product_category = @Category
        AND discount_percentage >= @MinDiscount
        AND purchase_amount IS NOT NULL
);


SELECT *
FROM dbo.fn_GetProductsByCategoryAndDiscount('Electronics', 10)
ORDER BY discount_percentage DESC;


-----Challenge 11: Get High-Value Purchases by Region
--Create a table-valued function that returns all purchase records from a specific region where the 
--purchase amount is greater than or equal to a given threshold.


create function fn_GetHighValuePurchasesByRegion
(
    @Region NVARCHAR(50),
    @MinPurchaseAmount DECIMAL(10,2)
)
returns table
as
return
(
select 
dc1.customer_name,
dc1.region,
dc1.purchase_amount,
dc1.product_name,
dc1.sale_date
from data_conversion_practice dc1
where dc1.region = @Region
and dc1.purchase_amount > = @MinPurchaseAmount
and dc1.purchase_amount is not null
);


SELECT * 
FROM dbo.fn_GetHighValuePurchasesByRegion('south', 2000); -- No Data in North


-----Challenge 12: Create a Table-Valued Function with Derived Column & Multiple Filters
--Create a table-valued function that returns all sales above a given discount and within a specified region, 
--along with a derived column that calculates the final amount after discount.


create function fn_GetRegionWiseDiscountedSales
(
@Region varchar(20),
@MinDiscount float
)
returns table
as
return
(
select 
dc1.customer_name,
dc1.region,
dc1.product_name,
dc1.purchase_amount,
dc1.discount_percentage,
dc1.purchase_amount - (dc1.purchase_amount * dc1.discount_percentage / 100) as final_amount_after_discount
from data_conversion_practice dc1
where dc1.region = @Region
and dc1.discount_percentage > = @MinDiscount
and dc1.purchase_amount is not null
and dc1.discount_percentage is not null
);


SELECT * 
FROM dbo.fn_GetRegionWiseDiscountedSales('West', 5);


-----Challenge 13: Create a Table-Valued Function that returns top N products by total sales in a given 
--region using JOIN + RANK() window function.


alter function fn_GetTopProductsByRegion
(
@Region NVARCHAR(50),
@TopN INT 
)
returns table
as
return
(

with cte1 as 
(
select 
dc1.product_name,
sum(dc1.purchase_amount) as total_sales,
count(*) as total_unit_sold
from data_conversion_practice dc1
where dc1.purchase_amount is not null
group by dc1.product_name
),
cte2 as
(
select 
cte1.product_name,
dc2.product_category,
dc2.region,
cte1.total_sales,
cte1.total_unit_sold,
RANK() over (partition by dc2.region order by total_sales desc) as ranking
from data_conversion_practice dc2
join cte1
on cte1.product_name = dc2.product_name
)
select * from cte2
where cte2.region = @Region
and cte2.ranking <= @TopN


);

select * from fn_GetTopProductsByRegion ('west', 3);


-----Challenge 14: Create a stored procedure named InsertPurchaseWithCheck 
--that:
--Accepts inputs: @CustomerName, @PurchaseAmount
--Inside TRY, attempts to insert a record into a new table purchase_logs
--Inside CATCH, logs the error message using SELECT ERROR_MESSAGE()


CREATE TABLE purchase_logs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100),
    purchase_amount DECIMAL(10, 2),
    log_time DATETIME DEFAULT GETDATE()
);


SELECT * FROM purchase_logs;


CREATE PROCEDURE InsertPurchaseWithCheck
    @CustomerName NVARCHAR(100),
    @PurchaseAmount DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        -- Check if purchase amount is not negative
        IF @PurchaseAmount < 0
        BEGIN
            RAISERROR ('Purchase amount cannot be negative.', 16, 1);
        END

        -- Insert into the log table
        INSERT INTO purchase_logs (customer_name, purchase_amount)
        VALUES (@CustomerName, @PurchaseAmount);

        PRINT 'Purchase record inserted successfully.';
    END TRY

    BEGIN CATCH
        -- Handle any error
        SELECT 
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_LINE() AS ErrorLine,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState;
    END CATCH
END


EXEC InsertPurchaseWithCheck 
    @CustomerName = 'Suresh Kumar',
    @PurchaseAmount = 1500.00;

EXEC InsertPurchaseWithCheck 
    @CustomerName = 'Test Error',
    @PurchaseAmount = -500.00;


-----Challenge 15: Handle Runtime Error Using TRY...CATCH – Division by Zero
--You are creating a procedure that calculates the average purchase amount per loyalty point for a given region.
--But if the total loyalty score is zero or NULL, it will cause a division by zero error.
--You need to: Use TRY...CATCH to handle this error gracefully.
--Return a custom message or default value instead of crashing the procedure.
--Steps:
--Create a stored procedure: GetAvgPurchasePerLoyaltyPoint_ByRegion.
--Take one input parameter: @region NVARCHAR(50).
--Inside the procedure: Calculate total_purchase_amount and total_loyalty_score for that region.
--Use TRY...CATCH block. Divide purchase by loyalty score.
--If error (e.g., divide by 0), catch it and show:'Division by zero occurred. Loyalty score is zero or null.'
--Use PRINT or SELECT to show error or result clearly.


CREATE PROCEDURE GetAvgPurchasePerLoyaltyPoint_ByRegion
    @region NVARCHAR(50)
AS
BEGIN
    DECLARE 
        @total_purchase DECIMAL(10,2),
        @total_loyalty FLOAT,
        @avg_per_point DECIMAL(10,2)

    BEGIN TRY
        -- Calculate totals
        SELECT 
            @total_purchase = SUM(purchase_amount),
            @total_loyalty = SUM(loyalty_score)
        FROM data_conversion_practice
        WHERE region = @region

        -- Attempt division
        SET @avg_per_point = @total_purchase / @total_loyalty

        -- Display result
        SELECT 
            @region AS region,
            @total_purchase AS total_purchase_amount,
            @total_loyalty AS total_loyalty_score,
            @avg_per_point AS avg_purchase_per_loyalty_point
    END TRY

    BEGIN CATCH
        -- Handle any error (e.g., divide by zero)
        SELECT 
            ERROR_MESSAGE() AS error_message,
            'Loyalty score might be zero or null – division by zero avoided.' AS note,
            @region AS region
    END CATCH
END


EXEC GetAvgPurchasePerLoyaltyPoint_ByRegion @region = 'east';


-----Challenge 16: Stored Procedure: Handle incorrect data type conversion gracefully
--You want to convert the sale_time column (which is stored as a TIME or VARCHAR) into INT (just for demo), 
--but if any invalid conversion or null appears, handle it using TRY...CATCH.
--Try converting sale_time into minutes (HH * 60 + MM)
--Use TRY...CATCH to handle conversion or null issues
--Show either valid results or the error message


CREATE PROCEDURE GetSaleTimeInMinutes_ByCustomer
    @customer_name NVARCHAR(100)
AS
BEGIN
    DECLARE 
        @sale_time_str NVARCHAR(20),
        @hours INT,
        @minutes INT,
        @total_minutes INT

    BEGIN TRY
        -- Get the time string
        SELECT @sale_time_str = CONVERT(NVARCHAR, sale_time)
        FROM data_conversion_practice
        WHERE customer_name = @customer_name

        -- Extract HH and MM
        SET @hours = CAST(LEFT(@sale_time_str, 2) AS INT)
        SET @minutes = CAST(SUBSTRING(@sale_time_str, 4, 2) AS INT)

        -- Calculate total minutes
        SET @total_minutes = @hours * 60 + @minutes

        -- Output result
        SELECT 
            @customer_name AS customer_name,
            @sale_time_str AS original_time,
            @total_minutes AS time_in_minutes
    END TRY

    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS error_message,
            'Possible null or malformed time for this customer.' AS note,
            @customer_name AS customer_name
    END CATCH
END


EXEC GetSaleTimeInMinutes_ByCustomer @customer_name = 'priyanka joshi';


-----Challenge 4 – Nested TRY...CATCH with Custom Error Logging Table
--You’re collecting sales data per customer. 
--If an error occurs (like invalid product name or null purchase amount), the system should: Handle the error gracefully.
--Log the error message and context into a custom table called error_log.
--Use nested TRY...CATCH to separate logic and logging
--Insert errors into a custom log table with:
--customer name
--error message
--timestamp


CREATE TABLE error_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100),
    error_message NVARCHAR(4000),
    error_time DATETIME DEFAULT GETDATE()
);

select * from error_log;


CREATE PROCEDURE GetCustomerPurchaseReport
    @customer_name NVARCHAR(100)
AS
BEGIN
    DECLARE 
        @purchase_amount DECIMAL(10,2),
        @product_name NVARCHAR(100)

    BEGIN TRY
        -- Try to get purchase details
        SELECT 
            @purchase_amount = purchase_amount,
            @product_name = product_name
        FROM data_conversion_practice
        WHERE customer_name = @customer_name

        -- Simulate an error if data is missing (optional)
        IF @purchase_amount IS NULL OR @product_name IS NULL
            THROW 51000, 'Missing purchase data for customer.', 1;

        -- If all good, return the results
        SELECT 
            @customer_name AS customer_name,
            @product_name AS product,
            @purchase_amount AS purchase_amount
    END TRY

    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();

        -- Nested try-catch to insert error log
        BEGIN TRY
            INSERT INTO error_log (customer_name, error_message)
            VALUES (@customer_name, @ErrMsg);
        END TRY
        BEGIN CATCH
            PRINT 'Failed to log the error: ' + ERROR_MESSAGE();
        END CATCH;

        -- Return error message to caller
        SELECT 
            'Error occurred while fetching customer data.' AS status,
            @ErrMsg AS error_message
    END CATCH
END


-- This should work fine:
EXEC GetCustomerPurchaseReport @customer_name = 'sita verma';


-- This may trigger the error logic if record is missing or has NULLs
EXEC GetCustomerPurchaseReport @customer_name = 'karan mehta';


SELECT * FROM error_log ORDER BY error_time DESC;


-----