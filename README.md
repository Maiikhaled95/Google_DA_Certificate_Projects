## Cyclistic Bike Share Project

### Introduction
Welcome to the Cyclistic bike-share analysis case study! In this case study, I need to show how annual members and casual riders use Cyclistic bikes differently. I used the monthly trip data of 2021 to make an analysis for the whole year.I used Postgresql to build my database and start analyzing the dataset.

Firstly, I joined all the monthly tables into one table to work on it using SQL

``` sql
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

There were __5,400,660__ ride

Then, I started to check the table from any duplicates or null values

```sql
SELECT DISTINCT COUNT(*)
FROM temp_tripdata2021;
```
There is no duplicate in the table

```sql
-- Viewing the dataset to check if there is any null values
SELECT *
FROM temp_tripdata2021
```

Most of the null values in these columns (start_station_name, start_station_id, end_station_name, end_station_id)

To count the null values in these previous columns

``` sql
SELECT COUNT(*)
FROM temp_tripdata2021
WHERE start_station_name IS NULL
AND start_station_id IS NULL
AND end_station_name IS NULL
AND end_station_id IS NULL;
```

There were __407,124__ ride

To count the non-null values in the table

``` sql
SELECT COUNT(*)
FROM temp_tripdata2021
WHERE start_station_name IS NOT NULL
AND start_station_id IS NOT NULL
AND end_station_name IS NOT NULL
AND end_station_id IS NOT NULL;
```

There were __4,435,515__

To create the final table without null values, drop the non-important columns as there are not needed for analysis and delete the first table

``` sql
create table F_tripdata2021 AS(
SELECT *
FROM temp_tripdata2021
WHERE start_station_name IS NOT NULL
AND start_station_id IS NOT NULL
AND end_station_name IS NOT NULL
AND end_station_id IS NOT NULL);

Alter table F_tripdata2021
Drop column start_station_name,
Drop column start_station_id,
Drop column end_station_name,
Drop column end_station_id,
Drop column start_lat,
Drop column start_lng,
Drop column end_lat,
Drop column end_lng;

-- Deleting the temporary table
DROP TABLE temp_tripdata2021;
```

```sql
-- Viewing the final table
SELECT *
FROM F_tripdata2021;
```

Then, I started the analysis process after cleaning the dataset.

```sql
SELECT 
	started_at,
	COUNT(started_at) AS rides
FROM
	F_tripdata2021
GROUP BY
	started_at
Having 
	COUNT(started_at) > 1
ORDER BY 
	rides DESC
LIMIT 5;
```
The most frequent time to use the bike is around __17:45__ 

``` sql
SELECT 
	to_char(started_at,'Month') AS month,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	month
Having 
	COUNT(*) > 1
ORDER BY 
	rides DESC
LIMIT 12;
```

The most month for using the bike is __July__ and the least month is __February__

```sql
SELECT 
	to_char(started_at,'Day') AS day,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	day
Having 
	COUNT(*) > 1
ORDER BY 
	rides DESC
LIMIT 7;
```

The most day for using the bike is __Saturday__ and the least month is __Monday__

```sql
SELECT
	member_casual AS riders,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	riders
ORDER BY
	rides DESC;
```

The total number of rides for __member__ riders is __2,483,545__ and __1,951,970__ for __casual__ riders
	
```sql
SELECT
	rideable_type,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	 rideable_type
ORDER BY
	rides DESC;
```

The total number of rides for __classic__ bike is __3,147,786__, __994,319__ for __electric__ bike and __293,410__ for __docked__ bike

```sql
SELECT
	member_casual AS riders,
	rideable_type,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	riders, rideable_type
ORDER BY
	riders DESC, rides DESC;
```
The number of rides for member rides is 

```sql
SELECT
    member_casual AS rider,
    to_char(started_at,'month') AS month,
    count(*) AS rides	
FROM
	F_tripdata2021
GROUP BY
	rider, month
ORDER BY 
    rider ASC, rides DESC;
```

```sql
SELECT
    member_casual AS rider,
    to_char(started_at,'day') AS day,
    count(*) AS rides	
FROM
	F_tripdata2021
GROUP BY
	rider, day
ORDER BY 
    rider ASC, rides DESC;
```
	
```sql
SELECT 
	member_casual AS riders,
	CONCAT(COUNT(ride_id)*100/
	(SELECT COUNT(*)
	 FROM F_tripdata2021),'%') AS Percentage
FROM 
	F_tripdata2021
GROUP BY
	riders
ORDER BY
	Percentage DESC;
```
	
``` sql
SELECT 
	member_casual AS riders,
	rideable_type,
	CONCAT(COUNT(ride_id)*100/
	(SELECT COUNT(*)
	 FROM F_tripdata2021),'%') AS Percentage
FROM 
	F_tripdata2021
GROUP BY
	riders,rideable_type
ORDER BY
	riders DESC,
	Percentage DESC;
```
	
-- Calculating the average length of the ride by member_casual
SELECT
	member_casual AS rider,
	Extract(minute from AVG(ended_at - started_at))AS average_ride_length
FROM
	F_tripdata2021
GROUP BY
	rider
Order by 
	rider ASC;

-- Calculating the average length of the ride by day for riders
SELECT
	member_casual AS rider,
	to_char(started_at,'Day') AS day,
	Extract(minute from AVG(ended_at - started_at))AS average_ride_length
FROM
	F_tripdata2021
GROUP BY
	rider,day
Order by 
	rider DESC,
	average_ride_length DESC;

-- Calculating the average length of the ride by month for riders
SELECT
	member_casual AS rider,
	to_char(started_at,'month') AS month,
	Extract(minute from AVG(ended_at - started_at))AS average_ride_length
FROM
	F_tripdata2021
GROUP BY
	rider,month
Order by
	rider DESC,
	average_ride_length DESC;
