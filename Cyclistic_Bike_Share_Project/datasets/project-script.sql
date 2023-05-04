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

-- Checking if there is any duplicates in the dataset
SELECT DISTINCT COUNT(*)
FROM temp_tripdata2021;

-- Viewing the dataset to check if there is any null values
SELECT *
FROM temp_tripdata2021
Limit 10;

-- Counting the total number of records without null values
SELECT count(*)
FROM temp_tripdata2021
WHERE start_station_name IS NOT NULL
AND start_station_id IS NOT NULL
AND end_station_name IS NOT NULL
AND end_station_id IS NOT NULL
AND start_lat IS NOT NULL
AND start_lng IS NOT NULL
AND end_lat IS NOT NULL
AND end_lng IS NOT NULL;

-- Creating the table to start analyzing the data after cleaning and removing null values
create table F_tripdata2021 AS(
SELECT *
FROM temp_tripdata2021
WHERE start_station_name IS NOT NULL
AND start_station_id IS NOT NULL
AND end_station_name IS NOT NULL
AND end_station_id IS NOT NULL
AND start_lat IS NOT NULL
AND start_lng IS NOT NULL
AND end_lat IS NOT NULL
AND end_lng IS NOT NULL);

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

-- Viewing the needed dataset in the updated table
SELECT *
FROM F_tripdata2021
Limit 10;

-- Querying the most frequent time of starting the ride for riders
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

-- Querying the most frequent time of starting the ride for riders
SELECT 
	ended_at,
	COUNT(ended_at) AS rides
FROM
	F_tripdata2021
GROUP BY
	ended_at
Having 
	COUNT(ended_at) > 1
ORDER BY 
	rides DESC
LIMIT 5;

-- Querying the most and least frequent months for riders
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

-- Querying the most and least frequent days for riders
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

-- Calculating the number of rides by riders
SELECT
	member_casual AS riders,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	riders
ORDER BY
	rides DESC;
	
-- Calculating the number of rides by bike type
SELECT
	rideable_type,
	COUNT(*) AS rides
FROM
	F_tripdata2021
GROUP BY
	 rideable_type
ORDER BY
	rides DESC;

-- Calculating The number of rides for riders by bike type
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
	
-- Calculating the number of rides for riders by month
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

-- Calculating the number of rides for riders by day
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
	
-- Calculating the percentage of riders
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
	
-- -- Calculating the percentage of riders by bike type
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
