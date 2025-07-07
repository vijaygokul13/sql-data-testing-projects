-----Basic exercises for Data formatting-conversion-cleaning-transformation

USE retail_db

SELECT product_name, 
       CAST(price AS VARCHAR(10)) AS price_string
FROM products;

SELECT sale_id, 
       product_name, 
       CONVERT(VARCHAR, sale_date, 103) AS formatted_date
FROM sales_data;

SELECT sale_id, 
       product_name, 
       CAST(sale_amount AS INT) AS rounded_amount
FROM sales_data;

SELECT name, 
       CAST(loyalty_score AS FLOAT) AS loyalty_float
FROM customers;

SELECT sale_id, product_name, YEAR(sale_date) AS sale_year
FROM sales_data;

SELECT name, 
       CONVERT(VARCHAR, join_date, 101) AS formatted_join_date
FROM customers;

---

SELECT name + ' (' + region + ')' AS formatted_info
FROM customers;

SELECT CONCAT(name, ' - ', region) AS formatted_info
FROM customers;

SELECT LTRIM(RTRIM(product_name)) AS cleaned_product
FROM products;

SELECT LEFT(product_name, 4) AS short_name
FROM products;

SELECT REPLACE(category, 'Electronics', 'Tech Gadgets') AS updated_category
FROM products;

SELECT UPPER(product_name) AS upper_name
FROM products;

SELECT LOWER(name) AS lower_name
FROM customers;

---

SELECT sale_id, 
       product_name, 
       ROUND(sale_amount, 0) AS rounded_amount
FROM sales_data;

SELECT product_name, 
       ROUND(price, 2) AS formatted_price
FROM products;

SELECT product_name, 
       FORMAT(sale_amount, 'C', 'en-US') AS formatted_amount
FROM sales_data;

SELECT region, 
       FORMAT(target_amount, 'N', 'en-US') AS formatted_target
FROM sales_targets;

---

SELECT sale_id, product_name, YEAR(sale_date) AS sale_year
FROM sales_data;

SELECT sale_id, product_name, 
       MONTH(sale_date) AS sale_month, 
       DAY(sale_date) AS sale_day
FROM sales_data;

SELECT sale_id, product_name, 
       CONVERT(VARCHAR, sale_date, 103) AS formatted_date
FROM sales_data;

SELECT region, salesperson, 
       FORMAT(month, 'MMMM yyyy') AS formatted_target_month
FROM sales_targets;

SELECT name, 
       DATEDIFF(YEAR, join_date, GETDATE()) AS years_since_joining
FROM customers;

---

SELECT name, ISNULL(loyalty_score, 0) AS adjusted_loyalty
FROM customers;

SELECT name, COALESCE(loyalty_score, age, 0) AS fallback_value
FROM customers;

SELECT sale_id, product_name, sale_amount * ISNULL(loyalty_score, 1) AS adjusted_value
FROM sales_data
JOIN customers ON sales_data.region = customers.region;

---

SELECT name, UPPER(name) AS upper_case_name
FROM customers;

SELECT product_name, LOWER(product_name) AS lower_case_name
FROM products;

SELECT product_name, 
       CONCAT(UPPER(LEFT(product_name, 1)), LOWER(SUBSTRING(product_name, 2, LEN(product_name)))) AS title_case_product
FROM products;

SELECT LTRIM(RTRIM(product_name)), 
       UPPER(product_name) AS standardized_product_name
FROM products;

---

SELECT value AS split_product_name
FROM STRING_SPLIT('Laptop,Tablet,Monitor,Keyboard', ',');

SELECT STRING_AGG(product_name, ', ') AS all_products
FROM products;

SELECT STUFF((SELECT ', ' + product_name 
              FROM products 
              FOR XML PATH('')), 1, 2, '') AS all_products;

---

SELECT product_name
FROM products
WHERE product_name LIKE 'L%';

SELECT product_name
FROM products
WHERE product_name LIKE '%s';

SELECT product_name
FROM products
WHERE PATINDEX('%[0-9]%', product_name) > 0;

SELECT customer_id, name
FROM customers
WHERE dbo.RegexMatch(name, '^[A-Za-z]+$');

---

SELECT sale_id, product_name, FORMAT(sale_amount, 'N', 'en-US') AS formatted_amount
FROM sales_data;

SELECT product_name, FORMAT(price, 'C', 'en-US') AS formatted_price
FROM products;

SELECT 
    LEFT(product_name, 15) AS short_name, 
    RIGHT(STR(price, 10, 2), 10) AS formatted_price
FROM products;

SELECT sale_id, 
       CONVERT(VARCHAR, sale_date, 103) AS formatted_sale_date
FROM sales_data;

SELECT STRING_AGG(product_name, ', ') AS csv_product_list
FROM products;


-----Complex exercises for Data formatting-conversion-cleaning-transformation


USE practice_db;

----Challenge 1. Data Formatting & Conversion → Type Conversion
--Challenge Title: Convert Purchase Amount Types
--Description: Show purchase_amount as INT, VARCHAR, and back to FLOAT using CAST() and CONVERT(). Compare values before and after.


SELECT 
    record_id,
    ISNULL(purchase_amount, 0.00) AS original_amount,
    CAST(ISNULL(purchase_amount, 0.00) AS INT) AS as_integer,
    CAST(ISNULL(purchase_amount, 0.00) AS VARCHAR(20)) AS as_string,
    CAST(CAST(ISNULL(purchase_amount, 0.00) AS VARCHAR(20)) AS FLOAT) AS as_float_back
FROM 
    data_conversion_practice;


----Challenge 2. Data Cleaning & Transformation → Standardizing Values
--Challenge Title: Region Standardization
--Description: Standardize the region column by converting all values to Proper Case (e.g., "north" → "North")


SELECT 
    record_id,
    region AS original_region,
    UPPER(LEFT(region, 1)) + LOWER(SUBSTRING(region, 2, LEN(region))) AS standardized_region
FROM 
    data_conversion_practice;


----Challenge 3. Date and Time Functions → GETDATE & DATEDIFF
--Challenge Title: Customer Membership Age
--Description: Calculate how many days/months/years each customer has been active since their join_date using GETDATE() and DATEDIFF().


SELECT 
    record_id,
    customer_name,
    join_date,
    CASE 
        WHEN join_date IS NULL THEN NULL
        ELSE DATEDIFF(DAY, join_date, GETDATE())
    END AS days_active,
    CASE 
        WHEN join_date IS NULL THEN NULL
        ELSE DATEDIFF(MONTH, join_date, GETDATE())
    END AS months_active,
    CASE 
        WHEN join_date IS NULL THEN NULL
        ELSE DATEDIFF(YEAR, join_date, GETDATE())
    END AS years_active,
	CONCAT(
	DATEDIFF(YEAR, join_date, GETDATE()), ' years, ',
	DATEDIFF(MONTH, join_date, GETDATE()) % 12, ' months'
	) AS membership_duration
FROM 
    data_conversion_practice;


----Challenge 4. Data Formatting & Conversion → String Manipulation
--Challenge Title: Split Customer Name
--Description: Extract first name and last name from customer_name. Show them as two columns.


SELECT 
    record_id,
    customer_name,
    CASE 
        WHEN customer_name IS NULL THEN NULL
        ELSE LEFT(customer_name, CHARINDEX(' ', customer_name + ' ') - 1)
    END AS first_name,
    CASE 
        WHEN customer_name IS NULL THEN NULL
        ELSE RIGHT(customer_name, 
            LEN(customer_name) - CHARINDEX(' ', customer_name + ' '))
		END AS last_name
FROM 
    data_conversion_practice;


-----Challenge 5. Data Cleaning & Transformation → Replacing Nulls
--Challenge Title: Null Fallback for Loyalty Score
--Description: Replace NULL values in loyalty_score with 0 using ISNULL() or COALESCE().

--version:1

SELECT 
    record_id,
    customer_name,
    loyalty_score AS original_loyalty_score,
    ISNULL(loyalty_score, 0) AS cleaned_loyalty_score
FROM 
    data_conversion_practice;


---version:2


SELECT 
    record_id,
    customer_name,
    loyalty_score AS original_loyalty_score,
    COALESCE(loyalty_score, 0) AS cleaned_loyalty_score
FROM 
    data_conversion_practice;


-----Challenge 6. Data Formatting & Conversion → Text Case & Standardization
--Challenge Title: Product Name Formatting
--Description: Display product_name in:
--UPPERCASE
--lowercase
--Proper Case (simulate title case)


SELECT
    record_id,
    product_name,
    UPPER(product_name) AS upper_name,
    LOWER(product_name) AS lower_name,
    CONCAT (UPPER(LEFT(product_name, 1)), LOWER(SUBSTRING(product_name, 2, LEN(product_name)))) AS proper_case_name
FROM data_conversion_practice;


-----Challenge 7: Reusable SQL script to convert multi-word customer_name entries 
--(e.g., "amit kumar verma" → "Amit Kumar Verma") into Title Case using T-SQL. 
--Simulate Proper Case (Title Case) for any number of words


---Start

WITH SplitAndCapitalize AS ( --Create a CTE to split each customer_name into words and capitalize them
    SELECT 
        record_id,
        value AS word,
        ROW_NUMBER() OVER (PARTITION BY record_id ORDER BY (SELECT NULL)) AS rn,
        LEFT(value, 1) AS first_char,
        SUBSTRING(value, 2, LEN(value)) AS remaining_chars
    FROM data_conversion_practice
    CROSS APPLY STRING_SPLIT(customer_name, ' ')
),
TitleCase AS (
    SELECT 
        record_id,
        rn,
        CONCAT(UPPER(first_char), LOWER(remaining_chars)) AS capitalized_word
    FROM SplitAndCapitalize
),
Recombined AS (
    SELECT 
        record_id,
        STRING_AGG(capitalized_word, ' ') WITHIN GROUP (ORDER BY rn) AS proper_case_name
    FROM TitleCase
    GROUP BY record_id
)
-- Final Output
SELECT 
    dcp.record_id,
    dcp.customer_name AS original_name,
    r.proper_case_name AS title_case_name
FROM data_conversion_practice dcp
JOIN Recombined r ON dcp.record_id = r.record_id;

---End


-----Challenge 8: Data Formatting & Conversion → Delimited Strings
--Challenge Title: Extract Recent Price from History
--Description: Each product's price_change_history column contains a semicolon-delimited list of historical prices like '1200;1100;1150'.
--Your task is to extract the latest (last) price from this string.


SELECT 
    record_id,
    customer_name,
    price_change_history,
    -- Extract the last price from semicolon-delimited history
    TRY_CAST(
        RIGHT(price_change_history, 
              CHARINDEX(';', REVERSE(price_change_history) + ';') - 1
        ) AS DECIMAL(10,2)
    ) AS latest_price
FROM data_conversion_practice
WHERE price_change_history IS NOT NULL;


-----Challenge 9: Extract First Name and Last Name
--Goal: From the customer_name, extract the first word as First Name and the last word as Last Name, 
--even if there are more than two words (e.g., "amit kumar verma" → First Name: "amit", Last Name: "verma").


SELECT
  record_id,
  customer_name,
  CHARINDEX(' ', customer_name + ' ') as first_name_position_no,
  LEFT(customer_name, CHARINDEX(' ', customer_name + ' ') - 1) AS first_name,
  REVERSE(customer_name) as reverse_name,
  CHARINDEX(' ', REVERSE(customer_name) + ' ') as last_name_position_no,
  LEFT(REVERSE(customer_name), CHARINDEX(' ', REVERSE(customer_name) + ' ') - 1) as reverse_last_name,
  REVERSE(LEFT(REVERSE(customer_name), CHARINDEX(' ', REVERSE(customer_name) + ' ') - 1)) AS final_last_name
FROM data_conversion_practice
WHERE customer_name LIKE '% %';  -- Ignore single-word names


-----Challenge 10: Replace Missing Values for Reporting
--You're generating a customer loyalty report. However, some users don’t have a loyalty_score.
--For reporting and analytics:
--If loyalty_score is NULL, show "No Score" instead.
--If it’s numeric, show it as-is (as a string).
--Additionally, show:
--A fallback using ISNULL()
--A fallback using COALESCE()
--A fallback using CASE logic for comparison


SELECT 
    record_id,
    customer_name,
    loyalty_score,

    -- 1. ISNULL fallback
    ISNULL(CAST(loyalty_score AS VARCHAR), 'No Score') AS using_ISNULL,

    -- 2. COALESCE fallback
    COALESCE(CAST(loyalty_score AS VARCHAR), 'No Score') AS using_COALESCE,

    -- 3. CASE logic (alternative to ISNULL/COALESCE)
    CASE 
        WHEN loyalty_score IS NULL THEN 'No Score' 
        ELSE CAST(loyalty_score AS VARCHAR)
    END AS using_CASE
FROM data_conversion_practice;


-----Challenge 11: NULL Handling in Aggregations and Comparisons
--You're generating insights like average loyalty score and total purchase amount for active customers by region.
--But:
--Some loyalty_score values are NULL
--Some purchase_amount values are also NULL
--You need to:
--Ensure null values don’t distort the results
--Replace nulls with default values (e.g., 0) where needed
--Count how many rows had NULLs


SELECT 
    region,
    
    -- Average loyalty score excluding NULLs (normal AVG handles it)
    AVG(loyalty_score) AS avg_loyalty_score,

    -- Total purchase amount with NULLs replaced by 0
    SUM(ISNULL(purchase_amount, 0)) AS total_purchase_amount,

    -- Count of customers with NULL loyalty_score
    SUM(CASE WHEN loyalty_score IS NULL THEN 1 ELSE 0 END) AS null_loyalty_count,

    -- Count of customers with NULL purchase_amount
    SUM(CASE WHEN purchase_amount IS NULL THEN 1 ELSE 0 END) AS null_purchase_count

FROM data_conversion_practice
WHERE is_active = 1
GROUP BY region;


-----Challenge #12: Clean Dirty Text Fields in Reports ( Working with TRIM(), REPLACE(), LEN(), LTRIM(), RTRIM() )
--For each active record:
--Clean description field:
--Remove extra spaces (leading, trailing)
--Replace multiple spaces with a single space
--Replace dashes - with nothing
--Show the original vs cleaned description
--Show length before and after cleaning
--Flag if the cleaned field is empty or just whitespace


SELECT 
    record_id,
    customer_name,
    
    -- Original description
    CAST(description AS VARCHAR(MAX)) AS original_desc,

    -- Cleaned: remove dashes, trim spaces
    LTRIM(RTRIM(REPLACE(CAST(description AS VARCHAR(MAX)), '-', ' '))) AS cleaned_desc,

    -- Length before and after
    LEN(CAST(description AS VARCHAR(MAX))) AS original_length,
    LEN(LTRIM(RTRIM(REPLACE(CAST(description AS VARCHAR(MAX)), '-', '')))) AS cleaned_length,

    -- Flag if cleaned description becomes empty
    CASE 
        WHEN LEN(LTRIM(RTRIM(REPLACE(CAST(description AS VARCHAR(MAX)), '-', '')))) = 0 THEN 'Empty After Cleaning'
        ELSE 'Valid'
    END AS cleaned_status

FROM data_conversion_practice
WHERE is_active = 1;


-----Challenge #13: Extracting & Tagging Data with SUBSTRING(), LEFT(), RIGHT()
--The business wants to extract meaningful parts of key fields for analytics and tagging. You’ll use SUBSTRING, LEFT, RIGHT, and CHARINDEX to:
--Extract country code from phone numbers
--Extract product type from product_id
--Categorize customer name based on initial alphabet
--Extract first tag from comma-separated csv_tags


SELECT 
    record_id,
    customer_name,
    phone_number,
    product_id,
    csv_tags,

    -- 1. Country code from phone number
    LEFT(phone_number, CHARINDEX('-', phone_number) - 1) AS country_code,

    -- 2. Customer name initial group
    CASE 
        WHEN UPPER(LEFT(customer_name, 1)) BETWEEN 'A' AND 'M' THEN 'A-M'
        WHEN UPPER(LEFT(customer_name, 1)) BETWEEN 'N' AND 'Z' THEN 'N-Z'
        ELSE 'Unknown'
    END AS name_group,

    -- 3. First tag from CSV list
    LEFT(csv_tags, CHARINDEX(',', csv_tags + ',') - 1) AS first_tag,

    -- 4. Product type code
    LEFT(product_id, 2) AS product_type_code

FROM data_conversion_practice
WHERE is_active = 1;


-----Challenge #14: Split Delimited Strings into Rows Using STRING_SPLIT() + CROSS APPLY
--The analytics team wants to normalize the csv_tags column, which stores comma-separated tags, so that:
--Each tag appears in a separate row
--We can later analyze tag frequency, customer interest, etc.


SELECT 
    dcp.record_id,
    dcp.customer_name,
    dcp.product_name,
    dcp.product_category,
    tag.value AS individual_tag
FROM data_conversion_practice dcp
CROSS APPLY STRING_SPLIT(dcp.csv_tags, ',') AS tag
WHERE dcp.is_active = 1;


-----Challenge #15: Aggregate Tags Using STRING_AGG()
--Now that individual tags have been split, the business wants to:
--Group them back by product category or product name
--Get a unique, comma-separated list of tags used per category
--This is useful for dashboards, exports, and tag-based filtering.


WITH SplitTags AS (
    SELECT 
        dcp.product_category,
        TRIM(tag.value) AS individual_tag
    FROM data_conversion_practice dcp
    CROSS APPLY STRING_SPLIT(dcp.csv_tags, ',') AS tag
    WHERE dcp.is_active = 1
),
DistinctTags AS (
    SELECT DISTINCT product_category, individual_tag
    FROM SplitTags
)
SELECT 
    product_category,
    STRING_AGG(individual_tag, ', ') 
        WITHIN GROUP (ORDER BY individual_tag) AS all_tags_sorted
FROM DistinctTags
GROUP BY product_category;


-----Challenge #16: Calculate Customer Tenure Buckets & Activity Windows
--The marketing team wants to categorize customers based on:
--How long ago they joined (join_date)
--Classify them into tenure buckets:
--New → Less than 1 year
--Active → 1 to 3 years
--Loyal → 3+ years
--They also want to track:
--Total months since joining
--Whether they made any sale in the last 90 days (based on sale_date)


SELECT 
    record_id,
    customer_name,
    join_date,
    DATEDIFF(YEAR, join_date, GETDATE()) AS tenure_years,
    DATEDIFF(MONTH, join_date, GETDATE()) AS tenure_months,
    
    CASE 
        WHEN DATEDIFF(YEAR, join_date, GETDATE()) < = 2 THEN 'New'
        WHEN DATEDIFF(YEAR, join_date, GETDATE()) BETWEEN 3 AND 5 THEN 'Senior'
        ELSE 'Loyal'
    END AS tenure_bucket,

    sale_date,
    CASE 
        WHEN sale_date IS NULL THEN 'No Sale'
        WHEN DATEDIFF(DAY, sale_date, GETDATE()) <= 90 THEN 'Yes'
        ELSE 'No'
    END AS recent_activity
FROM data_conversion_practice
WHERE join_date IS NOT NULL;


-----Challenge #17: Currency Formatting and Locale-based Reporting
--Your business team wants a customer-facing sales report that includes:
--Cleanly formatted currency values (e.g., ₹1,200.75, $3,000.99)
--Prices shown with proper decimal precision (2 digits after decimal)
--A combined formatted string showing:
--"Ramesh Sharma spent ₹1,200.75 on Laptop"
--They want this report to be user-friendly and export-ready.


SELECT 
    record_id,
    customer_name,
    product_name,
    currency_code,
	purchase_amount,
    ROUND(purchase_amount, 2) AS rounded_amount,
    FORMAT(purchase_amount, 'N2') AS formatted_amount,  -- locale-aware formatting (e.g., 1,200.75)
    CONCAT(customer_name, ' spent ', 
           COALESCE(
             CASE currency_code
               WHEN 'INR' THEN 'Rs'
               WHEN 'USD' THEN '$'
               WHEN 'EUR' THEN '€'
               WHEN 'GBP' THEN '£'
               WHEN 'JPY' THEN '¥'
               WHEN 'CAD' THEN 'C$'
               WHEN 'AUD' THEN 'A$'
               WHEN 'CHF' THEN 'Fr.'
               WHEN 'MXN' THEN 'Mex$'
               WHEN 'SGD' THEN 'S$'
               ELSE ''
             END, ''), FORMAT(purchase_amount, 'N2'), ' on ', product_name) 
    AS formatted_output_summary
FROM data_conversion_practice
WHERE purchase_amount IS NOT NULL;


-----Challenge #18: Parsing & Flattening Delimited Price History
--Your product pricing team stores price history in a semi-structured format — a semicolon-separated string in the column price_change_history:
--"1200;1100;1150"
--They want to:
--Split these prices into separate rows (1 row per price)
--Track how many times a price was updated per product
--Add a position indicator (1st update, 2nd update, etc.)


WITH FlattenedPrices AS (
    SELECT 
        dcp.record_id,
        dcp.customer_name,
        dcp.product_name,
        TRY_CAST(value AS DECIMAL(10,2)) AS price,
        ROW_NUMBER() OVER (PARTITION BY dcp.record_id ORDER BY (SELECT NULL)) AS price_version
    FROM data_conversion_practice dcp
    CROSS APPLY STRING_SPLIT(dcp.price_change_history, ';')
    WHERE dcp.price_change_history IS NOT NULL
)
SELECT * FROM FlattenedPrices
ORDER BY record_id, price_version;


-----Challenge #19: Cleaning & Standardizing Phone Numbers
--Your dataset contains phone numbers in various international formats:
--+91-9876543210  
--+1-5551234567  
--+44-7701234567  
--+49-1709876543  
--The operations team wants to:
--Remove all non-numeric characters (like +, -)
--Extract: Country Code (first few digits)
--Local Number (remaining digits)
--Display a standardized 2-column report for SMS system input.


WITH Cleaned AS (
    SELECT
        record_id,
        phone_number AS original_number,
        REPLACE(REPLACE(phone_number, '+', ''), '-', '') AS cleaned_number
    FROM data_conversion_practice
),
SplitPhone AS (
    SELECT
        record_id,
        original_number,
        cleaned_number,
        LEFT(cleaned_number, LEN(cleaned_number) - 10) AS country_code,
        RIGHT(cleaned_number, 10) AS local_number
    FROM Cleaned
)
SELECT * FROM SplitPhone
ORDER BY record_id;


-----Challenge #20: Splitting CSV Tags into Rows for Tag-Based Analytics
--Your dataset stores product tags in a CSV format under the column csv_tags, 
--e.g.:
--"laptop,tech,gaming"  
--"furniture,office,wood"  
--"electronics,print,color"
--The marketing team wants to:
--Split tags into individual rows
--See how many products are associated with each distinct tag
--Create a ready-to-use report for tag-based filtering & segmentation


WITH TagSplit AS (
    SELECT
        record_id,
        product_name,
        TRIM(value) AS tag
    FROM data_conversion_practice
    CROSS APPLY STRING_SPLIT(csv_tags, ',')
    WHERE csv_tags IS NOT NULL
)
-- Tag Analytics
SELECT 
    tag,
    COUNT(DISTINCT record_id) AS product_count
FROM TagSplit
GROUP BY tag
ORDER BY product_count DESC, tag;


-----Challenge #21: NULL Fallbacks & Aggregation Behavior
--In your data:
--Some fields like loyalty_score, purchase_amount, sale_date, email, null_test_column contain NULLs
--Reports must show default values, and aggregations must ignore/handle NULLs properly


---Step 1: Fallback Handling with ISNULL() and COALESCE()

SELECT 
    record_id,
    customer_name,
    ISNULL(loyalty_score, 0) AS loyalty_score_cleaned,
    COALESCE(purchase_amount, 999.99) AS purchase_amount_cleaned,
    COALESCE(null_test_column, 'N/A') AS null_column_cleaned
FROM data_conversion_practice;

---Step 2: Aggregation Behavior with NULLs

SELECT 
    AVG(loyalty_score) AS avg_loyalty,         -- excludes NULLs by default
    SUM(ISNULL(purchase_amount, 0)) AS total_purchase,
    COUNT(email) AS count_with_email           -- skips NULLs
FROM data_conversion_practice;


-----Challenge #22: Pattern Matching & Text Search using LIKE and PATINDEX
--Your company wants to analyze customer notes, email domains, and detect unwanted patterns 
--(like missing '@' in emails, or detect words like “test”, “demo”, etc. in descriptions).
--Let’s use SQL pattern matching to clean or analyze such fields.


---Step 1: Find Rows with Specific Substrings

SELECT 
    record_id,
    email
FROM data_conversion_practice
WHERE email LIKE '%@gmail.%';

---Step 2: Detect “test” or “demo” in Notes or Descriptions

SELECT 
    record_id,
    description,
    notes
FROM data_conversion_practice
WHERE 
    description LIKE '%test%' 
    OR description LIKE '%demo%'
    OR PATINDEX('%test%', notes) > 0
    OR PATINDEX('%demo%', notes) > 0;

---Step 3: Detect Invalid Email Format (Missing '@')

SELECT 
    record_id,
    email
FROM data_conversion_practice
WHERE email NOT LIKE '%@%';

--- Step 4: Optional — Find Phone Numbers Not Starting with a Specific Pattern (e.g., not starting with '98')

SELECT 
    record_id,
    phone_number
FROM data_conversion_practice
WHERE phone_number NOT LIKE '+91%';


-----Challenge #23: Clean Report Output — Handling NULLs, Percentages, and Currency
--You need to prepare a clean final report for the business team. This report must:
--Show blank instead of NULLs
--Display loyalty scores as percentages
--Format purchase_amount with currency symbol
--Show a clean output that can be exported or printed.


---Step 1: Replace NULLs with Blank or Default Text

SELECT 
    record_id,
    customer_name,
    ISNULL(CAST(age AS VARCHAR), 'N/A') AS age,
    ISNULL(email, 'Not Provided') AS email
FROM data_conversion_practice;

---Step 2: Format Loyalty Score as Percentage with Symbol (e.g., 80.5 → "80.5%")

SELECT 
    record_id,
    customer_name,
    CONCAT(CAST(loyalty_score AS VARCHAR), '%') AS loyalty_percentage
FROM data_conversion_practice
WHERE loyalty_score IS NOT NULL;

---Step 3: Format purchase_amount with Currency Code

SELECT 
    record_id,
    customer_name,
    CONCAT(currency_code, ' ', FORMAT(purchase_amount, 'N2')) AS formatted_amount
FROM data_conversion_practice
WHERE purchase_amount IS NOT NULL;

---Combine All — Create a Clean Report Output

SELECT 
    record_id,
    customer_name,
    ISNULL(CAST(age AS VARCHAR), 'N/A') AS age,
    ISNULL(CONCAT(CAST(loyalty_score AS VARCHAR), '%'), 'No Score') AS loyalty,
    ISNULL(CONCAT(currency_code, ' ', FORMAT(purchase_amount, 'N2')), 'Not Available') AS amount,
    ISNULL(email, 'Not Provided') AS email
FROM data_conversion_practice;


-----Challenge #24: Safe Type Conversion Using TRY_CAST(), TRY_CONVERT(), and TRY_PARSE()
--Your data includes a column null_test_column (currently all NULL) and free-text fields that might sometimes hold numeric or date values. 
--You’re tasked with safely converting values without throwing errors if the data is bad or NULL.


WITH conversion_test_data AS (
    SELECT '123' AS test_value 
	UNION ALL
    SELECT '45.67' 
	UNION ALL
    SELECT '2024-01-01' 
	UNION ALL
    SELECT 'abc123' 
	UNION ALL
    SELECT 'NULL' 
	UNION ALL
    SELECT NULL
	UNION ALL
	SELECT '456.78654'
)
SELECT 
    test_value,
    TRY_CAST(test_value AS INT) AS as_integer,
    TRY_CAST(test_value AS DECIMAL(10,2)) AS as_decimal,
	 TRY_CONVERT(DATE, test_value) AS as_date,
	  TRY_PARSE(test_value AS MONEY USING 'en-US') AS as_money,
    TRY_PARSE(test_value AS DATETIME USING 'en-US') AS parsed_date
FROM conversion_test_data;


-----Challenge #25: Pattern Matching Using LIKE, PATINDEX, and Simulated Regex Behavior
--You are tasked with finding and flagging records from the data_conversion_practice table where the special_character_test column:
--Contains symbols like @, #, *, %, etc.
--Matches specific prefix, suffix, or embedded patterns
--Uses basic pattern recognition (simulated regex)


---Task 1: Detect Records with Special Characters Using LIKE

SELECT 
    record_id,
    special_character_test
FROM data_conversion_practice
WHERE 
    special_character_test LIKE '%[%!@#$%^&*()_+=<>?{}|~]%' ESCAPE '\';

---Task 2: Identify Records Where special_character_test Starts with Special Characters

SELECT 
    record_id,
    special_character_test
FROM data_conversion_practice
WHERE 
    special_character_test LIKE '[^a-zA-Z0-9]%';

---Task 3: Use PATINDEX() to Find Position of Patterns

SELECT 
    record_id,
    special_character_test,
    PATINDEX('%[!@#$%^&*()]%', special_character_test) AS position_of_special_char
FROM data_conversion_practice
WHERE PATINDEX('%[!@#$%^&*()]%', special_character_test) > 0;


-----Challenge #26: Currency & Percentage Formatting for Dashboards and Reports
--You are preparing a clean, formatted report for a business dashboard from the data_conversion_practice table. You need to:
--Format purchase_amount as currency based on currency_code.
--Display discount_percentage as a percentage.
--Round values properly for reporting using ROUND(), CEILING(), FLOOR().
--Format final outputs in readable strings using FORMAT().


---Task 1: Format purchase_amount as Currency (with rounding)

SELECT 
    record_id,
    customer_name,
    currency_code,
    purchase_amount,
    FORMAT(ROUND(purchase_amount, 2), 'N2') AS formatted_amount
FROM data_conversion_practice
WHERE purchase_amount IS NOT NULL;

---Task 2: Add Currency Symbol Prefix Based on currency_code

SELECT 
    record_id,
    customer_name,
    currency_code,
    purchase_amount,
    CASE currency_code
        WHEN 'INR' THEN 'Rs' + FORMAT(purchase_amount, 'N2')
        WHEN 'USD' THEN '$' + FORMAT(purchase_amount, 'N2')
        WHEN 'EUR' THEN '€' + FORMAT(purchase_amount, 'N2')
        WHEN 'GBP' THEN '£' + FORMAT(purchase_amount, 'N2')
        WHEN 'JPY' THEN '¥' + FORMAT(purchase_amount, 'N2')
        WHEN 'AUD' THEN 'A$' + FORMAT(purchase_amount, 'N2')
        WHEN 'CAD' THEN 'C$' + FORMAT(purchase_amount, 'N2')
        WHEN 'CHF' THEN 'CHF ' + FORMAT(purchase_amount, 'N2')
        WHEN 'MXN' THEN 'MX$' + FORMAT(purchase_amount, 'N2')
        WHEN 'SGD' THEN 'S$' + FORMAT(purchase_amount, 'N2')
        ELSE FORMAT(purchase_amount, 'N2')
    END AS currency_display
FROM data_conversion_practice
WHERE purchase_amount IS NOT NULL;

---Task 3: Format discount_percentage as Percentage

SELECT 
    record_id,
    customer_name,
    discount_percentage,
    FORMAT(discount_percentage / 100.0, 'P') AS formatted_discount
FROM data_conversion_practice
WHERE discount_percentage IS NOT NULL;

---Task 4: Use ROUND(), FLOOR(), and CEILING() for price approximation

SELECT 
    record_id,
    purchase_amount,
    ROUND(purchase_amount, 0) AS rounded,
    FLOOR(purchase_amount) AS floor_value,
    CEILING(purchase_amount) AS ceiling_value
FROM data_conversion_practice
WHERE purchase_amount IS NOT NULL;


-----Challenge 27: Full Customer Data Clean-Up for Reporting Dashboard
--Goal: Prepare a clean, formatted output of customer records for reporting purposes.


SELECT 
    record_id,
	-- Convert to Proper Case (First letter of each word capitalized)
concat(upper(left(dc1.customer_name,1)), lower(substring(dc1.customer_name, 2 ,CHARINDEX(' ', dc1.customer_name + ' ') -2 )))
	As first_name,
concat(upper(SUBSTRING(customer_name , CHARINDEX(' ', dc1.customer_name + ' ') + 1, 1)),
	lower(SUBSTRING(customer_name , CHARINDEX(' ', dc1.customer_name + ' ') + 2, len(dc1.customer_name))))
	As last_name,
(
CONCAT( UPPER(LEFT(customer_name, 1)),
    LOWER(SUBSTRING(customer_name, 2, CHARINDEX(' ', customer_name + ' ') - 2)),
    ' ',
    UPPER(SUBSTRING(customer_name, CHARINDEX(' ', customer_name + ' ') + 1, 1)),
    LOWER(SUBSTRING(customer_name, CHARINDEX(' ', customer_name + ' ') + 2, 
	LEN(customer_name)))
)) AS FullName,
    -- Handle NULL age
    ISNULL(CAST(age AS VARCHAR), '-') AS Age,
    -- Round loyalty score or show NA
    CASE 
        WHEN loyalty_score IS NULL THEN 'NA'
        ELSE CAST(ROUND(loyalty_score, 0) AS VARCHAR)
    END AS LoyaltyScore,
    -- Format purchase amount as ₹Currency or show fallback
    CASE 
        WHEN purchase_amount IS NULL THEN 'Not Available'
        ELSE CONCAT(currency_code, ' ', FORMAT(purchase_amount, 'N2'))
    END AS TotalPurchase,
    -- Concatenate product name + category
    CONCAT(product_name, ' (', product_category, ')') AS ProductDetails,
    -- Format sale_date as dd-MMM-yyyy hh:mm AM/PM
    FORMAT(sale_date, 'dd-MMM-yyyy hh:mm tt') AS SaleDate,
    -- Append % to discount or fallback
    CASE 
        WHEN discount_percentage IS NULL THEN 'No Discount'
        ELSE CONCAT(CAST(discount_percentage AS VARCHAR), '%')
    END AS DiscountApplied,
    -- Replace comma with pipe in csv_tags
    REPLACE(csv_tags, ',', ' | ') AS TagsFormatted,
    -- Remove all special characters from notes (keep alphanumeric and spaces only)
    -- (uses nested REPLACE chain; alternatively use TRANSLATE if available)
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        notes, '-', ''), '_', ''), '@', ''), '!', ''), '#', ''), '$', ''), '%', ''), '^', ''), '*', ''), '&', '') 
		AS CleanNotes
FROM data_conversion_practice dc1
WHERE is_active = 1;


-----