-----Challenge 1: Calculate Z-Score Normalization for Loyalty Score
--Standardize each customer's loyalty_score using the Z-Score 
--formula : 
--Z = (X - μ) / σ
--Where :
--X = Individual value (e.g., a customer's loyalty score)
--μ = Mean (average) of the column
--σ = Standard deviation of the column


WITH Stats AS (
    SELECT 
        AVG(1.0 * loyalty_score) AS avg_score,
        STDEV(1.0 * loyalty_score) AS std_dev
    FROM data_conversion_practice
    WHERE loyalty_score IS NOT NULL
),
ZScores AS (
    SELECT 
        dcp.record_id,
        dcp.customer_name,
        dcp.loyalty_score,
        s.avg_score,
        s.std_dev,
        CASE 
            WHEN dcp.loyalty_score IS NOT NULL AND s.std_dev != 0 THEN 
                ROUND((dcp.loyalty_score - s.avg_score) / s.std_dev, 2)
            ELSE NULL
        END AS z_score
    FROM data_conversion_practice dcp
    CROSS JOIN Stats s
)
SELECT * FROM ZScores;


-----Challenge 2: Calculate 3-Point Moving Average of Purchase Amount (Rolling Average)
--Objective:
--For each customer, calculate a 3-record moving average of their purchase_amount, ordered by sale_date.
--This will help analyze trends in spending over time — smoothing out sudden spikes or drops.


SELECT 
    t1.record_id,
    t1.customer_name,
    t1.sale_date,
    FLOOR(t1.purchase_amount) as purchase_amount,

	-- Values will be used in the moving average (correlated subquery)
    (
        SELECT STRING_AGG(CAST(floor(t3.purchase_amount) AS VARCHAR), ', ')
        FROM data_conversion_practice t3
        WHERE t3.sale_date <= t1.sale_date
          AND (
              SELECT COUNT(*) 
              FROM data_conversion_practice t4
              WHERE t4.sale_date <= t1.sale_date
                AND t4.sale_date > t3.sale_date
          ) < 3
          AND t3.purchase_amount IS NOT NULL
    ) AS values_used,

    -- 3 row moving average
    floor(AVG(t1.purchase_amount) OVER (
        ORDER BY t1.sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )) AS moving_avg_3

FROM data_conversion_practice t1
WHERE t1.purchase_amount IS NOT NULL
ORDER BY t1.sale_date;


-----Challenge 3: Contribution Analysis — a powerful analytical use case that shows the relative performance 
--of each product in terms of sales contribution per region and month.
--For each product sold in each region per month, calculate:
--Total sales for that product in that region and month
--Total sales in that region and month
--The percentage contribution of the product to total sales in that region and month


SELECT
    region,
    FORMAT(sale_date, 'yyyy-MM') AS sale_month,
    product_name,
    SUM(purchase_amount) AS product_total,

    SUM(SUM(purchase_amount)) OVER (
        PARTITION BY region, FORMAT(sale_date, 'yyyy-MM')
    ) AS region_month_total,

    ROUND(
        100.0 * SUM(purchase_amount) / 
        SUM(SUM(purchase_amount)) OVER (PARTITION BY region, FORMAT(sale_date, 'yyyy-MM')),
        2
    ) AS percent_contribution

FROM data_conversion_practice
WHERE purchase_amount IS NOT NULL AND sale_date IS NOT NULL
GROUP BY
    region,
    FORMAT(sale_date, 'yyyy-MM'),
    product_name
ORDER BY
    region,
    sale_month,
    percent_contribution DESC;


-----Challenge 4: CASE inside Window Functions — focused on ranking customers conditionally, such as by product_category.
--Rank Customers by Purchase Amount, Conditionally by Product Category
--Use CASE inside a window function to assign ranks only to certain product categories (e.g., only "Electronics") 
--while skipping others — or assign different ranking logic per category.


--Version no.1


SELECT 
    customer_name,
    product_category,
    purchase_amount,
    CASE 
        WHEN product_category = 'Electronics' THEN 
            RANK() OVER (PARTITION BY product_category ORDER BY purchase_amount DESC)
        ELSE NULL
    END AS category_rank
FROM data_conversion_practice;


--Version no.2


SELECT 
    customer_name,
    product_category,
    purchase_amount,
    RANK() OVER (PARTITION BY product_category ORDER BY purchase_amount DESC) AS category_rank
FROM data_conversion_practice
where product_category = 'Electronics';


----Version no.3


SELECT 
    customer_name,
    product_category,
    purchase_amount,
    RANK() OVER (
        PARTITION BY product_category 
        ORDER BY 
            CASE 
                WHEN product_category = 'Electronics' THEN purchase_amount
                ELSE 0
            END DESC
    ) AS category_rank
FROM data_conversion_practice;


-----Challenge 5: Tag top 3 loyal customers per region using ranking by using RANK() with PARTITION BY, 
--then add a custom flag or label for the top 3 in each region.
--For each region, rank customers based on loyalty_score (highest to lowest), and tag the top 3 with a label "Top Loyal" and others as "Regular".


SELECT
    customer_name,
    region,
    loyalty_score,
    RANK() OVER (PARTITION BY region ORDER BY loyalty_score DESC) AS loyalty_rank,
    CASE 
        WHEN RANK() OVER (PARTITION BY region ORDER BY loyalty_score DESC) <= 3 THEN 'Top Loyal'
        ELSE 'Regular'
    END AS loyalty_label
FROM 
    data_conversion_practice
WHERE
    loyalty_score IS NOT NULL;

-----