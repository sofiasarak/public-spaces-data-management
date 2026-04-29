-- Question: Which countries have the highest share of green area, averaged across cities? How does this relate to country GDP?

-- Become familiar with the table:
SELECT * FROM Green_Areas;

-- 2020 green area
SELECT green_area_share AS Share_2020 FROM Green_Areas 
    WHERE year = 2020;

-- 1990 green area
SELECT green_area_share AS Share_1990 FROM Green_Areas 
    WHERE year = 1990; 

-- JOINS

-- Join Green_Areas to the City table and County table using city_code

-- select columns from Country + Green_Areas + City join
SELECT year, green_area_share, city_name, country_or_territory_code, country_or_territory_name, annual_gdp FROM
    
    -- initiate Country join
    Country C JOIN 
    
    -- join between Green_Areas and City
    (SELECT year, green_area_share, city_name, country_or_territory_code FROM Green_Areas G 
    JOIN City C USING (city_code)) 
    
    -- finish join with Country
    J USING (country_or_territory_code)
    
    -- select only 2020
    WHERE year = 2020
    
    -- sort  by GDP
    ORDER BY annual_gdp DESC;
 
  
-- Repeat the above operation, but order by green_area_share instead
SELECT year, green_area_share, city_name, country_or_territory_code, country_or_territory_name, annual_gdp FROM
    Country C JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE year = 2020
    ORDER BY green_area_share DESC;

-- AGGREGATION

-- Calculate average green space in major cities, by country 

-- select columns from Country + Green_Areas + City join WITH averaged green_area_share
SELECT AVG(green_area_share) AS Avg_green_area, ANY_VALUE(country_or_territory_name), ANY_VALUE(annual_gdp) FROM
    Country C 
    
    -- second, nested join
    JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    
    -- select only 2020
    WHERE year = 2020
    
    -- group by country
    GROUP BY country_or_territory_name
    
    -- order by average green area 
    ORDER BY Avg_green_area DESC
    
    -- keep top 10
    LIMIT 10;

-- Repeat the above operation, but order by GDP instead
SELECT AVG(green_area_share) AS Avg_green_area, ANY_VALUE(country_or_territory_name) AS country_or_territory_name, ANY_VALUE(annual_gdp) AS annual_gdp FROM
    Country C JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE year = 2020
    GROUP BY country_or_territory_name
    ORDER BY annual_gdp DESC -- order by gdp
    LIMIT 10;


-- ADDITIONAL QUERY (not finished yet)
-- Question: Which city has the highest share of area dedicated to open space? How does this to its share of population with access to it?
SELECT * FROM Open_space
    ORDER BY open_space_area_share DESC
    LIMIT 5;

SELECT * FROM Open_space
    ORDER BY open_space_pop DESC
    LIMIT 5;

-- join with city and country!