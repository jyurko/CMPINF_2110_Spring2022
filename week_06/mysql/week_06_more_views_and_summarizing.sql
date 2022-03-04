-- query the VIEW created last week

USE shoes_db;

-- a VIEW is queried just like any other table
SELECT * FROM store_per_day_view;

-- further summarize the already summarized data
SELECT SUM(sum_count) AS 'Total count', location_id
FROM store_per_day_view
GROUP BY location_id;

-- the locations table gives us more information per store
SELECT * FROM locations;

-- use a subquery which summarizes the view and then join
-- to the locations table
SELECT location_name, location_summary.total_count AS 'Total count'
FROM (
    SELECT SUM(sum_count) AS total_count, location_id
    FROM store_per_day_view
    GROUP BY location_id
) location_summary
LEFT JOIN locations USING (location_id);

-- further alias the returned columns
SELECT location_name, location_summary.`Total count`
FROM (
    SELECT SUM(sum_count) AS 'Total count', location_id
    FROM store_per_day_view
    GROUP BY location_id
) location_summary
LEFT JOIN locations USING (location_id);

-- create one more view that summarizes the locations further
CREATE VIEW location_summary_view AS 
SELECT location_id, AVG(sum_count) AS avg_count, COUNT(day_id) AS num_days
FROM store_per_day_view
GROUP BY location_id
ORDER BY location_id;

SELECT * FROM location_summary_view;

-- Which days for each store have sum_counts greater than the store average?
SELECT day_id, location_id, sum_count, avg_count
FROM store_per_day_view
LEFT JOIN location_summary_view USING (location_id);

-- remove all rows where the sum count per day is less than the average
SELECT day_id, location_id, sum_count, avg_count
FROM store_per_day_view
LEFT JOIN location_summary_view USING (location_id)
WHERE (sum_count - avg_count) > 0;

-- return a rounded value
SELECT CEILING(avg_count), FLOOR(avg_count), ROUND(avg_count), avg_count
FROM location_summary_view;
