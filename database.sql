-- CITY TABLE
CREATE TABLE City (
         city_code VARCHAR PRIMARY KEY,
         city_name VARCHAR NOT NULL,
         country_or_territory_code INT NOT NULL);

COPY City FROM 'city.csv' (header TRUE);

-- works!!

-- COUNTRY TABLE
CREATE TABLE  Country (
        country_or_territory_code INT PRIMARY KEY,
        country_or_territory_name VARCHAR UNIQUE NOT NULL,
        sdg_region VARCHAR, 
        sdg_sub_region VARCHAR, 
        annual_gdp REAL);

COPY Country FROM 'country.csv' (header TRUE);
-- works!!

-- GREEN AREAS TABLE
CREATE TABLE Green_Areas (
    city_code VARCHAR,
    year INT,
    green_area_share REAL NOT NULL,
    PRIMARY KEY (city_code, year));

COPY Green_Areas FROM 'green_areas.csv' (header TRUE);

-- set compound primary key
-- works!!

-- PUBLIC SPACE TABLE
CREATE TABLE Open_space (
    city_code VARCHAR PRIMARY KEY,
    open_space_area_share REAL,
    open_space_pop REAL,
    reference_year INT);

COPY Open_space FROM 'public_space.csv' (header TRUE, nullstr "NA");

-- ask Annie how to deal with NAs?

--  TRANSPORTATION ACCESS TABLE
-- drop duplicate keys in city-code
CREATE TABLE Transport (
    city_code VARCHAR PRIMARY KEY,
    transport_pop REAL NOT NULL,
    reference_year INT);

COPY Transport FROM 'transport_access.csv' (header TRUE);
-- works!!

