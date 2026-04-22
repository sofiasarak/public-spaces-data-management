-- Question: Which countries have the highest share of green areas, averaged across cities? How does this relate to country GDP?

SELECT * FROM Green_Areas;

-- 2020 green area
SELECT green_area_share AS Share_2020 FROM Green_Areas 
    WHERE year = 2020;

-- 1990 green area
SELECT green_area_share AS Share_1990 FROM Green_Areas 
    WHERE year = 1990; 

-- join between green area share and city 
SELECT year, green_area_share, city_name, country_or_territory_code, country_or_territory_name, annual_gdp FROM
    Country C JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE year = 2020
    ORDER BY annual_gdp DESC;

SELECT year, green_area_share, city_name, country_or_territory_code, country_or_territory_name, annual_gdp FROM
    Country C JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE year = 2020
    ORDER BY green_area_share DESC;

-- calculate average green space in major cities, by country 
SELECT AVG(green_area_share) AS Avg_green_area, ANY_VALUE(country_or_territory_name), ANY_VALUE(annual_gdp) FROM
    Country C JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE year = 2020
    GROUP BY country_or_territory_name
    ORDER BY Avg_green_area DESC -- order by green area
    LIMIT 10;

-- calculate average green space in major cities, by country 
SELECT AVG(green_area_share) AS Avg_green_area, ANY_VALUE(country_or_territory_name) AS country_or_territory_name, ANY_VALUE(annual_gdp) AS annual_gdp FROM
    Country C JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE year = 2020
    GROUP BY country_or_territory_name
    ORDER BY annual_gdp DESC -- order by gdp
    LIMIT 10;

-- Question: Which city has the highest share of area dedicated to open space? How does this to its share of population with access to it?
SELECT * FROM Open_space
    ORDER BY open_space_area_share DESC
    LIMIT 5;

SELECT * FROM Open_space
    ORDER BY open_space_pop DESC
    LIMIT 5;

-- join with city and country!