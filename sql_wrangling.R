# Some issues cropped up once I tried to read the tables into SQL. Let's fix them.

library(tidyverse)

# Load in data
city <-  read_csv("data/city.csv")
country <- read_csv("data/country.csv")
green <- read_csv("data/green_areas.csv")
space <- read_csv("data/public_space.csv")
transport <- read_csv("data/transport_access.csv")

## City -- remove city_code duplicates

# check if and where they exist?
unique(city$city_code)

city <-  city |>
  filter(!duplicated(city_code))

## Country -- drop observations where gdp is NA
# how many countries are missing gdp?
missing <-  country %>% 
       filter(is.na(annual_gdp))
unique(missing$country_or_territory_code)
# only 8! we can drop them (but will keep this in mind during our analysis)

country <- country %>% 
  filter(!is.na(annual_gdp))

## Green spaces -- explore city_code duplicates
green %>% 
  filter(duplicated(city_code))

# Because our data is in long format, all city_codes repeat 3 times (one for each year). In SQL, we will
# set the primary key to be a compound of city_code and year


## Public Space -- explore NAs and year column
# how many NA values are there?
sum(is.na(space$open_space_area_share))
sum(is.na(space$open_space_pop))

# what do those rows looks like?
filter(space, is.na(space$open_space_pop))

# it looks like sometimes there is population data and not area data, and vice versa. I don't want to drop valuable info
# from one column just because the other is missing, so will remove NOT NULL from the SQL

# there were some issues with the year column as well --> warning that is is of class BIGINT?
unique(space$reference_year)
glimpse(space)

## Transport Access -- explore duplicate city_codes
dup <- transport %>% 
  filter(duplicated(city_code))
# looks like some observations have multiple reference years. This only occurs a handful of times, so to keep data consistent
# I will keep the data from the most recent reference year. There are also a few NA city_codes, that I will drop.

# find max reference year of duplicates
dup_max <- dup %>% 
  group_by(city_code) %>% 
  summarize(max_year = max(reference_year))

# attach max year to each city code
dup <- dup %>% 
  left_join(dup_max)

# keep only transport_pop from the max_year
dup <- dup %>% 
  filter(reference_year == max_year)

# now that we know the workflow works, apply it to all of transport
transport_max <- transport %>% 
  group_by(city_code) %>% 
  summarize(max_year = max(reference_year))

transport <- transport %>% 
  left_join(transport_max) %>% 
  filter(reference_year == max_year) %>% 
  filter(!is.na(city_code)) %>% 
  select(!max_year)

# confirm there are no duplicates anymore
transport %>% 
  filter(duplicated(city_code))

## Cleaning done! Re-save clean CSVs and overwrite the old ones
write_csv(city, file.path("data", "city.csv"))
write_csv(country, file.path("data", "country.csv"))
write_csv(green, file.path("data", "green_areas.csv"))
write_csv(space, file.path("data", "public_space.csv"))
write_csv(transport, file.path("data", "transport_access.csv"))

# Now we should be ready to read into SQL :)
