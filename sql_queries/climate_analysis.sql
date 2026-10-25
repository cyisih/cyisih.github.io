-- ========================================================
-- PROJECT: Global City Climate & Economic Analysis
-- OBJECTIVE: Identify top affordable cities with warm winters
-- AUTHOR: cyisih
-- ========================================================

-- STEP 1: Data Cleaning (Handling missing temperature metrics)
SELECT 
    city, 
    country, 
    COALESCE(avg_temp, 0) as cleaned_temp
FROM climate_table;

-- STEP 2: Advanced Analysis (Finding top 10 cheap, warm cities)
-- Uses JOINs to link climate with cost index, and Window Functions to rank
WITH RankedCities AS (    
    SELECT 
        c.city,
        c.country,
        c.winter_temp,
        e.cost_of_living_index,
        RANK() OVER (ORDER BY e.cost_of_living_index ASC) as affordability_rank
    FROM climate_table c
    JOIN economics_table e ON c.city_id = e.city_id
    WHERE c.winter_temp > 60
)
SELECT * FROM RankedCities WHERE affordability_rank <= 10;
