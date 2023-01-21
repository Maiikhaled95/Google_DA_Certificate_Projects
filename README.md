# Google-Portfolio-Project
## Cyclistic Bike Share Project

### Introduction
Welcome to the Cyclistic bike-share analysis case study! In this case study, I need to show how annual members and casual riders use Cyclistic bikes differently. I used the monthly trip data of 2021 to make an analysis for the whole year.I used Postgresql to build my database and start analyzing the dataset.

Firstly, I joined all the monthly tables into one table to work on it using SQL

``` sql
-- Joining all the tables of 2021 into one table to be easily used for querying 
CREATE Table temp_tripdata2021 AS(
SELECT * FROM divvy_tripdata202101
UNION ALL
SELECT * FROM divvy_tripdata202102
UNION ALL
SELECT * FROM divvy_tripdata202103
UNION ALL
SELECT * FROM divvy_tripdata202104
UNION ALL
SELECT * FROM divvy_tripdata202105
UNION ALL
SELECT * FROM divvy_tripdata202106
UNION ALL
SELECT * FROM divvy_tripdata202107
UNION ALL
SELECT * FROM divvy_tripdata202108
UNION ALL
SELECT * FROM divvy_tripdata202109
UNION ALL
SELECT * FROM divvy_tripdata202110
UNION ALL
SELECT * FROM divvy_tripdata202111
UNION ALL
SELECT * FROM divvy_tripdata202112)

-- Counting the total number of records after joining all the tables together into one table
SELECT COUNT(*)
FROM temp_tripdata2021;
```

There were 5,400,660 ride

