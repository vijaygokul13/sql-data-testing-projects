--CREATE TABLE travel (
--    Source VARCHAR(50),
--    Destination VARCHAR(50),
--    Distance INT
--);

--INSERT INTO travel (Source, Destination, Distance)
--VALUES
--    ('Delhi', 'Mumbai', 1400),
--    ('Mumbai', 'Delhi', 1400),
--    ('Delhi', 'Agra', 200),
--    ('Agra', 'Delhi', 200),
--    ('Agra', 'Kanpur', 270),
--    ('Kanpur', 'Agra', 270),
--    ('Kanpur', 'Kolkata', 1000),
--    ('Kolkata', 'Kanpur', 1000),
--    ('Mumbai', 'Pune', 150),
--    ('Pune', 'Mumbai', 150),
--    ('Pune', 'Hyderabad', 560),
--    ('Hyderabad', 'Pune', 560),
--    ('Hyderabad', 'Chennai', 630),
--    ('Chennai', 'Hyderabad', 630),
--    ('Kolkata', 'Bhubaneswar', 440);

--Select * from travel;


---Find all one-way trips (no return journey exists)

SELECT t1.*
FROM travel t1
LEFT JOIN travel t2
  ON t1.Source = t2.Destination AND t1.Destination = t2.Source
WHERE t2.Source IS NULL;

---Find all round trips (both forward and return journey exist) Using Case Statement

SELECT DISTINCT
    CASE WHEN t1.Source < t1.Destination THEN t1.Source ELSE t1.Destination END AS City1,
    CASE WHEN t1.Source > t1.Destination THEN t1.Source ELSE t1.Destination END AS City2,
    t1.Distance
FROM travel t1
JOIN travel t2
  ON t1.Source = t2.Destination AND t1.Destination = t2.Source;

---Find all round trips (both forward and return journey exist) Using Greatest & Least functions

Select GREATEST(Source), LEAST(Destination), Max(Distance) 
from travel
group by GREATEST(Source), LEAST(Destination) 
having GREATEST(Source)>  LEAST(Destination)

---Find the total number of unique city pairs (ignoring direction)

SELECT COUNT(DISTINCT 
    CASE WHEN Source < Destination 
         THEN Source + '-' + Destination 
         ELSE Destination + '-' + Source END
) AS UniqueCityPairs
FROM travel;

---Calculate total distance traveled from each source

SELECT Source, SUM(Distance) AS TotalDistance
FROM travel
GROUP BY Source;

---List routes with distances greater than 1000 km

SELECT *
FROM travel
WHERE Distance > 1000;

---Find cities that are both Source and Destination

SELECT DISTINCT Source
FROM travel
WHERE Source IN (SELECT Destination FROM travel);

---Find all possible paths from a Source city to Destination city (including indirect trips) Using Recursive CTE

WITH TravelPaths AS (
          -- Anchor: start from Delhi
    SELECT 
        Source, 
        Destination, 
        CAST(Source + ' -> ' + Destination AS VARCHAR(MAX)) AS Route,
        Distance
    FROM travel
    WHERE Source = 'Delhi'

    UNION ALL

           -- Recursive: follow the next hop
    SELECT 
        tp.Source,
        t.Destination,
        CAST(tp.Route + ' -> ' + t.Destination AS VARCHAR(MAX)),
        tp.Distance + t.Distance
    FROM travel t
    JOIN TravelPaths tp
        ON t.Source = tp.Destination
    WHERE tp.Route NOT LIKE '%' + t.Destination + '%'
)

SELECT * FROM TravelPaths
ORDER BY Distance;

---Window Functions:ROW_NUMBER

SELECT 
    Source, 
    Destination, 
    Distance,
    ROW_NUMBER() OVER (
        PARTITION BY source               -- Reset ranking for each source city
        ORDER BY distance DESC            -- Rank by highest distance first
    ) AS Route_Rank
FROM travel;

----

--INSERT INTO travel (Source, Destination, Distance)
--VALUES 
--('Delhi', 'Agra', 200),
--('Delhi', 'Jaipur', 200),
--('Delhi', 'Mumbai', 1400),
--('Delhi', 'Kolkata', 1400),
--('Delhi', 'Lucknow', 1000),
--('Mumbai', 'Pune', 150),
--('Mumbai', 'Nagpur', 830),
--('Mumbai', 'Indore', 830),
--('Mumbai', 'Bangalore', 980),
--('Mumbai', 'Delhi', 1400),
--('Kolkata', 'Ranchi', 400),
--('Kolkata', 'Patna', 600),
--('Kolkata', 'Delhi', 1400),
--('Kolkata', 'Mumbai', 1400),
--('Kolkata', 'Jaipur', 1000);

---
SELECT * 
FROM (
    SELECT 
        Source, 
        Destination, 
        Distance,
        RANK() OVER (
            PARTITION BY Source 
            ORDER BY Distance DESC
        ) AS Distance_Rank
    FROM travel
) AS temp
WHERE Distance_Rank <= 2
ORDER BY Source, Distance_Rank;

---

WITH RankedTravel AS (
    SELECT 
        Source, 
        Destination, 
        Distance,
        RANK() OVER (
            PARTITION BY Source 
            ORDER BY Distance DESC
        ) AS Distance_Rank
    FROM travel
)
SELECT * 
FROM RankedTravel
WHERE Distance_Rank <= 2
ORDER BY Source, Distance_Rank;

---

WITH DuplicateRows AS (
    SELECT 
        Source, 
        Destination, 
        Distance,
        ROW_NUMBER() OVER (
            PARTITION BY Source, Destination, Distance
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM travel
)
SELECT * FROM DuplicateRows
WHERE rn > 1;

---

WITH DuplicateRows AS (
    SELECT 
        Source, 
        Destination, 
        Distance,
        ROW_NUMBER() OVER (
            PARTITION BY Source, Destination, Distance
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM travel
)
DELETE t
FROM travel t
JOIN DuplicateRows d
  ON t.Source = d.Source
 AND t.Destination = d.Destination
 AND t.Distance = d.Distance
WHERE d.rn > 1;

---

SELECT 
    Source,
    Destination,
    Distance,
    LEAD(Distance) OVER (
        PARTITION BY Source 
        ORDER BY Distance
    ) AS Next_Distance
FROM travel;

SELECT 
    Source,
    Destination,
    Distance,
    LAG(Distance) OVER (
        PARTITION BY Source 
        ORDER BY Distance
    ) AS Prev_Distance
FROM travel;


---

WITH Diff_ AS (
    SELECT 
        Source,
        Destination,
        Distance,
        ISNULL(LAG(Distance) OVER (PARTITION BY Source ORDER BY Distance), 0) AS LAG_VALUE
    FROM travel
)
SELECT 
    Source, 
    Destination, 
    Distance, 
    LAG_VALUE, 
    (Distance - LAG_VALUE) AS Difference
FROM Diff_;

---
With Next_Distance As
(
	Select 
		Source,
		Destination,
		Distance,
		Isnull((LEAD(Distance) over (partition by source order by distance)),0) as LEAD_
	from travel
)
Select 
	Source,
	Destination,
	Distance,
	LEAD_ as Next_Distance,
	ABS((LEAD_ - Distance)) as DIFF
from Next_Distance;

---
SELECT
    Source,
    Destination,
    Distance,
    Prev_Distance,
    CASE
        WHEN Prev_Distance = 0 THEN 0
        ELSE ABS(Distance - Prev_Distance)
    END AS Diff_With_Prev,
    
    CASE
        WHEN Prev_Distance = 0 THEN 'No Change'
        WHEN Distance > Prev_Distance THEN 'Increasing'
        WHEN Distance < Prev_Distance THEN 'Decreasing'
        ELSE 'No Change'
    END AS Trend_With_Prev,
    
    Next_Distance,
    CASE
        WHEN Next_Distance = 0 THEN 0
        ELSE ABS(Next_Distance - Distance)
    END AS Diff_With_Next,
    
    CASE
        WHEN Next_Distance = 0 THEN 'No Change'
        WHEN Distance > Next_Distance THEN 'Decreasing'
        WHEN Distance < Next_Distance THEN 'Increasing'
        ELSE 'No Change'
    END AS Trend_With_Next,
	CASE 
    WHEN Distance > Prev_Distance AND Distance > Next_Distance THEN 'Peak Point'
    WHEN Distance < Prev_Distance AND Distance < Next_Distance THEN 'Valley'
    ELSE 'Flat'
END AS Overall_Trend

FROM (
    SELECT 
        Source,
        Destination,
        Distance,
        ISNULL(LAG(Distance) OVER (PARTITION BY Source ORDER BY Distance), 0) AS Prev_Distance,
        ISNULL(LEAD(Distance) OVER (PARTITION BY Source ORDER BY Distance), 0) AS Next_Distance
    FROM travel
) temp
WHERE Source = 'Kolkata';

---

SELECT 
  Source,
  Destination,
  Distance,
  NTILE(3) OVER (ORDER BY Distance) AS Distance_Tier
FROM travel;

---