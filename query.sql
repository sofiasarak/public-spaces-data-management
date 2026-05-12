-- Question: Is there a relationship between urban resources/health (as indicated by access to open public spaces, green areas, and access to public transportation) and a country’s annual GDP? (or, Do wealthier countries have healthier cities?)

-- Green area query

SELECT AVG(green_area_share) AS avg_green_area, -- average green area share 
ANY_VALUE(country_or_territory_name) AS country, ANY_VALUE(annual_gdp) AS gdp FROM -- select country name and gdp
    
    -- initiate join between Country table and the nested join
    Country C 
    
    -- join Green_Areas table to the City table
    JOIN (SELECT year, green_area_share, city_name, country_or_territory_code FROM 
    Green_Areas G JOIN City C USING (city_code)) 
    
    -- finish join between Country and nested join
    J USING (country_or_territory_code)
    
    -- filter only for the year 2020
    WHERE year = 2020
    
    -- group by country
    GROUP BY country_or_territory_name;
  
-- Open space query

SELECT AVG(open_space_pop) AS avg_open_pop, 
ANY_VALUE(country_or_territory_name) AS country, ANY_VALUE(annual_gdp) AS gdp FROM
    Country C 
    JOIN (SELECT reference_year, open_space_pop, city_name, country_or_territory_code FROM 
    Open_space G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE reference_year = 2020
    GROUP BY country_or_territory_name;

-- Transportation access query

SELECT AVG(transport_pop) AS avg_transport_pop, 
ANY_VALUE(country_or_territory_name) AS country, ANY_VALUE(annual_gdp) AS gdp FROM
    Country C 
    JOIN (SELECT reference_year, transport_pop, city_name, country_or_territory_code FROM 
    Transport G JOIN City C USING (city_code)) J USING (country_or_territory_code)
    WHERE reference_year = 2020
    GROUP BY country_or_territory_name;

