---- Create travel table
--CREATE TABLE travel (
--    source VARCHAR(50),
--    destination VARCHAR(50),
--    distance INT
--);

---- Insert sample data
--INSERT INTO travel (source, destination, distance) VALUES
--('Agra', 'Delhi', 200),
--('Agra', 'Kanpur', 270),
--('Kanpur', 'Agra', 270),
--('Kanpur', 'Kolkata', 1000),
--('Kolkata', 'Kanpur', 1000),
--('Pune', 'Mumbai', 150),
--('Pune', 'Hyderabad', 560),
--('Hyderabad', 'Pune', 560),
--('Hyderabad', 'Chennai', 630),
--('Chennai', 'Hyderabad', 630),
--('Kolkata', 'Bhubaneswar', 440),
--('Delhi', 'Jaipur', 200),
--('Delhi', 'Kolkata', 1400),
--('Delhi', 'Lucknow', 1000),
--('Mumbai', 'Nagpur', 830),
--('Mumbai', 'Indore', 830n),
--('Mumbai', 'Bangalore', 980),
--('Kolkata', 'Ranchi', 400),
--('Kolkata', 'Patna', 600),
--('Kolkata', 'Delhi', 1400),
--('Kolkata', 'Mumbai', 1400),
--('Kolkata', 'Jaipur', 1000),
--('Jaipur', 'Agra', 240),
--('Lucknow', 'Kanpur', 90),
--('Nagpur', 'Hyderabad', 500),
--('Bangalore', 'Chennai', 350);

-----

---- Create city_info table
--CREATE TABLE city_info (
--    city VARCHAR(50),
--    state VARCHAR(50),
--    population INT,
--    airport_code VARCHAR(10)
--);

---- Insert sample data
--INSERT INTO city_info (city, state, population, airport_code) VALUES
--('Agra', 'UP', 1585000, 'AGR'),
--('Delhi', 'Delhi', 19000000, 'DEL'),
--('Kanpur', 'UP', 3000000, 'KNU'),
--('Kolkata', 'WB', 15000000, 'CCU'),
--('Pune', 'MH', 7400000, 'PNQ'),
--('Mumbai', 'MH', 20000000, 'BOM'),
--('Hyderabad', 'Telangana', 10000000, 'HYD'),
--('Chennai', 'TN', 11000000, 'MAA'),
--('Jaipur', 'Rajasthan', 3100000, 'JAI'),
--('Lucknow', 'UP', 2900000, 'LKO'),
--('Nagpur', 'MH', 2500000, 'NAG'),
--('Bangalore', 'Karnataka', 12000000, 'BLR'),
--('Bhubaneswar', 'Odisha', 1000000, 'BBI'),
--('Ranchi', 'Jharkhand', 1200000, 'IXR'),
--('Patna', 'Bihar', 2400000, 'PAT'),
--('Indore', 'MP', 2000000, 'IDR');

--INSERT INTO travel VALUES 
--('Agra', 'Delhi', 200),
--('Delhi', 'Jaipur', 200),
--('Jaipur', 'Agra', 240);

--INSERT INTO travel VALUES 
--('Pune', 'Hyderabad', 560),
--('Hyderabad', 'Chennai', 630),
--('Chennai', 'Pune', 910); -- adding this missing leg

--INSERT INTO travel VALUES 
--('Kolkata', 'Kanpur', 1000),
--('Kanpur', 'Agra', 270),
--('Agra', 'Kolkata', 1300); -- adding this missing leg

--INSERT INTO travel VALUES 
--('Agra', 'Kanpur', 270),
--('Kanpur', 'Agra', 270);

--WITH RankedDuplicates AS (
--  SELECT *,
--         ROW_NUMBER() OVER (
--           PARTITION BY source, destination, distance
--           ORDER BY source
--         ) AS rn
--  FROM travel
--)
--DELETE FROM RankedDuplicates
--WHERE rn > 1;


-----Basic Recursive Join to Find Reachable Cities from Agra


WITH travel_path (source, destination, distance, path, total_distance) AS (
    SELECT 
        source,
        destination,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.source,
        t.destination,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance
    FROM travel t
    INNER JOIN travel_path tp 
        ON t.source = tp.destination
    WHERE tp.path NOT LIKE '%' + t.destination + '%'
)
SELECT *
FROM travel_path
OPTION (MAXRECURSION 1000);


-----Show all travel paths from Agra to Kolkata, including multi-hop paths and total distance.


WITH travel_path (source, destination, distance, path, total_distance) AS (
    SELECT 
        source,
        destination,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.source,
        t.destination,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance
    FROM travel t
    INNER JOIN travel_path tp 
        ON t.source = tp.destination
    WHERE tp.path NOT LIKE '%' + t.destination + '%'
)
SELECT *
FROM travel_path
WHERE destination = 'Kolkata'
OPTION (MAXRECURSION 1000);


-----Find the Shortest Travel Path from Agra to Kolkata.


WITH travel_path (source, destination, distance, path, total_distance) AS (
    SELECT 
        source,
        destination,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.source,
        t.destination,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance
    FROM travel t
    INNER JOIN travel_path tp 
        ON t.source = tp.destination
    WHERE tp.path NOT LIKE '%' + t.destination + '%'
)
SELECT TOP 1 *
FROM travel_path
WHERE destination = 'Kolkata'
ORDER BY total_distance ASC
OPTION (MAXRECURSION 1000);


-----Find all travel paths between any two cities ( Dynamic Source and Destination ) 


DECLARE @StartCity VARCHAR(50) = 'Agra';
DECLARE @EndCity VARCHAR(50) = 'Kolkata';

WITH travel_path (source, destination, distance, path, total_distance) AS (
    SELECT 
        source,
        destination,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance
    FROM travel
    WHERE source = @StartCity

    UNION ALL

    SELECT 
        tp.source,
        t.destination,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance
    FROM travel t
    INNER JOIN travel_path tp 
        ON t.source = tp.destination
    WHERE tp.path NOT LIKE '%' + t.destination + '%'
)
SELECT *
FROM travel_path
WHERE destination = @EndCity
ORDER BY total_distance
OPTION (MAXRECURSION 1000);


-----Find All Round Trips from a City -
--Find all travel paths that start and end at the same city 


WITH TravelPaths AS (
    SELECT 
        source AS start_city,
        destination AS current_city,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        level + 1
    FROM TravelPaths tp
    JOIN travel t
        ON tp.current_city = t.source
    WHERE 
        -- prevent visiting Agra in middle of path
        (CHARINDEX(t.destination, tp.path) = 0 AND t.destination <> 'Agra') 
        OR (t.destination = tp.start_city AND level >= 2)
)
SELECT *
FROM TravelPaths
WHERE current_city = start_city
  AND level >= 2
  -- confirm Agra only appears at start and end
  AND path NOT LIKE '% - Agra - %'
OPTION (MAXRECURSION 1000);


-----Limiting by Max Hops - Starting and ending at Agra, With maximum 3 stops (i.e., 4 cities total including Agra twice)
--And no revisiting of any city (except Agra at the end)


WITH TravelPaths AS (
    SELECT 
        source AS start_city,
        destination AS current_city,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        tp.level + 1
    FROM TravelPaths tp
    JOIN travel t ON tp.current_city = t.source
    WHERE 
        -- avoid revisiting same city (except to return to start)
        (
            CHARINDEX(t.destination, tp.path) = 0
            OR (t.destination = tp.start_city AND tp.level >= 2)
        )
        AND tp.level < 4  -- 💡 Stop expanding after 3 stops (4 legs)
)
SELECT *
FROM TravelPaths
WHERE 
    current_city = start_city
    AND level >= 2  -- must make at least 1 stop before returning
ORDER BY total_distance
OPTION (MAXRECURSION 1000);


-----Step 7: Find the Shortest Round Trip from a City (e.g., Agra)
--Find the shortest round trip that starts and ends at a given city (e.g., Agra) with no city revisited (except the start at the end).


with travel_path as 
(
select 
source as start_city,
destination as current_city,
distance,
cast (source + ' - ' + destination as varchar(max)) as path,
distance as total_distance,
1 as level
from travel
where source = 'Agra'

union all

select 
tp.start_city,
t.destination as current_city,
t.distance,
cast (tp.path + ' - ' + t.destination as varchar(max)) as path,
tp.total_distance + t.distance as total_distance,
level + 1
from travel t
inner join travel_path tp
on tp.current_city = t.source
where 
(
CHARINDEX (t.destination, tp.path) = 0 
	and t.destination <> 'Agra'
)
or (t.destination = tp.start_city 
	and level >=2)
)
select top 1 *
from travel_path
where current_city = start_city
and level >=2
and path not like '% - Agra - %'
order by total_distance
option (maxrecursion 1000);


-----Find All Round Trips Within a Certain Distance (e.g., <= 3000 km)


WITH travel_path AS (
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        level + 1
    FROM travel t
    INNER JOIN travel_path tp
        ON tp.current_city = t.source
    WHERE 
        (
            CHARINDEX(t.destination, tp.path) = 0 
            AND t.destination <> 'Agra'
        )
        OR 
        (
            t.destination = tp.start_city 
            AND level >= 2
        )
)

SELECT *
FROM travel_path
WHERE 
    current_city = start_city
    AND level >= 2
    AND total_distance <= 3000
    AND path NOT LIKE '% - Agra - %'
ORDER BY total_distance
OPTION (MAXRECURSION 1000);


----- Find All Round Trips Within Max Hops AND Max Distance (Combined Filter)


WITH travel_path AS (
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        level + 1
    FROM travel t
    INNER JOIN travel_path tp
        ON tp.current_city = t.source
    WHERE 
        (
            CHARINDEX(t.destination, tp.path) = 0 
            AND t.destination <> 'Agra'
        )
        OR 
        (
            t.destination = tp.start_city 
            AND level >= 2
        )
)

SELECT *
FROM travel_path
WHERE 
    current_city = start_city
    AND level >= 2
    AND level <= 3
    AND total_distance <= 3000
    AND path NOT LIKE '% - Agra - %'
ORDER BY total_distance
OPTION (MAXRECURSION 1000);


-----Find All Distinct Loops (Round Trips) from Any City (Not Just Agra) - All Round Trips from All Cities (Dynamic Start City)


WITH travel_path AS (
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        level + 1
    FROM travel t
    INNER JOIN travel_path tp
        ON tp.current_city = t.source
    WHERE 
        (
            CHARINDEX(t.destination, tp.path) = 0 
            AND t.destination <> tp.start_city
        )
        OR 
        (
            t.destination = tp.start_city 
            AND level >= 2
        )
)

SELECT *
FROM travel_path
WHERE 
    current_city = start_city
    AND level >= 2
    AND path NOT LIKE '% - ' + start_city + ' - %'  -- avoids revisiting start city before the end
ORDER BY start_city, total_distance
OPTION (MAXRECURSION 1000);


-----Step 11: Detect Cycles (Closed Loops) Without Returning to Start (Advanced)
--This is useful in cases like network routing or delivery systems where you need to return to any previously visited city, not just the start.


WITH travel_path AS 
(
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)),
        tp.total_distance + t.distance,
        tp.level + 1
    FROM travel_path tp
    JOIN travel t ON tp.current_city = t.source
    WHERE 
        (
            (' - ' + tp.path + ' - ') NOT LIKE '% - ' + t.destination + ' - %'
            OR (t.destination = tp.start_city AND tp.level >= 2)
        )
        AND tp.level < 6  -- ✅ Limit hops
)
SELECT *
FROM travel_path
WHERE 
    current_city = start_city
    AND level >= 2
    AND path NOT LIKE '% - Agra - %Agra%'  -- ✅ prevent extra loops
    AND total_distance <= 3000             -- ✅ optional distance limit
OPTION (MAXRECURSION 1000);

-----Find the Longest Round Trip (Maximum Distance) Starting and Ending at Agra


WITH travel_path AS (
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        tp.level + 1
    FROM travel_path tp
    JOIN travel t
        ON tp.current_city = t.source
    WHERE 
        (
            CHARINDEX(' - ' + t.destination + ' - ', ' - ' + tp.path + ' - ') = 0
            AND t.destination <> tp.start_city
        )
        OR (
            t.destination = tp.start_city 
            AND tp.level >= 2
        )
)
SELECT TOP 1 *
FROM travel_path
WHERE current_city = start_city
  AND level >= 2
  AND path NOT LIKE '% - Agra - %'  -- Agra should appear only at start and end
ORDER BY total_distance DESC
OPTION (MAXRECURSION 1000);



-----Performance-Oriented Joins-related-query.
--Find all round trips that start and end at Agra, visiting up to 4 other cities (max 5 stops total including Agra twice), 
--without revisiting any city in between — and return the top 3 shortest round trips based on total distance.

--Step:1

WITH travel_path AS 
(
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        tp.start_city,
        t.destination AS current_city,
        t.distance,
        CAST(tp.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        tp.total_distance + t.distance AS total_distance,
        tp.level + 1
    FROM travel_path tp
    INNER JOIN travel t ON tp.current_city = t.source
    WHERE 
        (CHARINDEX(t.destination, tp.path) = 0 AND t.destination <> 'Agra')
        OR (t.destination = tp.start_city AND tp.level >= 2)
)
SELECT TOP 3 *
FROM travel_path
WHERE current_city = start_city
  AND level >= 2
  AND path NOT LIKE '% - Agra - %'
ORDER BY total_distance
OPTION (MAXRECURSION 1000);

--Step:2

CREATE NONCLUSTERED INDEX idx_travel_source ON travel(source);

CREATE NONCLUSTERED INDEX idx_travel_dest ON travel(destination);

--Step:3

WITH paths_from_agra AS 
(
    SELECT 
        source AS start_city,
        destination AS current_city,
        distance,
        CAST(source + ' - ' + destination AS VARCHAR(MAX)) AS path,
        distance AS total_distance,
        1 AS level
    FROM travel
    WHERE source = 'Agra'

    UNION ALL

    SELECT 
        p.start_city,
        t.destination AS current_city,
        t.distance,
        CAST(p.path + ' - ' + t.destination AS VARCHAR(MAX)) AS path,
        p.total_distance + t.distance AS total_distance,
        p.level + 1
    FROM paths_from_agra p
    JOIN travel t ON p.current_city = t.source
    WHERE 
        (CHARINDEX(t.destination, p.path) = 0 AND t.destination <> 'Agra')
        OR (t.destination = p.start_city AND p.level >= 2)
),
valid_round_trips AS (
    SELECT *
    FROM paths_from_agra
    WHERE 
        current_city = start_city
        AND level >= 2
        AND level <= 5  
        AND path NOT LIKE '% - Agra - %'
),
final_result AS (
    SELECT *
    FROM valid_round_trips
)
SELECT TOP 3 *
FROM final_result
ORDER BY total_distance
OPTION (MAXRECURSION 500);  -- Reduced recursion for safety

-----