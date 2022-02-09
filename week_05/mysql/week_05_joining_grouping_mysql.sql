-- week 05 - more SQL commands

-- tell workbench to "activate" the shoes_db database
USE shoes_db;

-- all columns from shoes
SELECT * FROM shoes;

-- check the DISTINCT or unique values of a variable
SELECT DISTINCT shoe_id FROM shoes;

-- a more useful application of DISTINCT is in the
-- shoes_per_day table where shoe_id is a FOREIGN KEY
SELECT * FROM shoes_per_day;

SELECT DISTINCT shoe_id FROM shoes_per_day;

-- What if I wanted to know the DISTINCT values of
-- shoe_color in shoes_per_day table?

-- we need to JOIN the tables to bring in a column 
-- NOT in the shoes_per_day table
SELECT * 
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id;

-- apply DISTINCT keyword to the field of interest
SELECT DISTINCT shoe_color 
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id;

-- created the TIDY DATA by join three tables
SELECT *
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
LEFT JOIN locations ON shoes_per_day.location_id = locations.location_id;

-- we can select a few columns to return from our compiled
-- tidy data
SELECT day_id, location_name, shoe_color, count
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
LEFT JOIN locations ON shoes_per_day.location_id = locations.location_id;

-- it's very easy to ALIAS the returned column names
SELECT day_id AS 'Day Number',
       location_name AS 'Store name',
       shoe_color AS 'Shoe color',
       count AS 'Number of shoes'
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
LEFT JOIN locations ON shoes_per_day.location_id = locations.location_id;

-- ALIAS names in the returned table are not preserved 
-- or saved they do not overwrite the field names in the tables!!!!!
SELECT * FROM locations;

-- SQL convention: commas written at the start of a new line
-- instead of at the end of a line
SELECT day_id AS 'Day Number'
       , location_name AS 'Store name'
       , shoe_color AS 'Shoe color'
       -- , count AS 'Number of shoes'
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
LEFT JOIN locations ON shoes_per_day.location_id = locations.location_id;

-- put the commas wherever -- be very careful!!!!!!!!!
SELECT day_id AS 'Day Number', , location_name AS 'Store name'
       shoe_color AS 'Shoe color',
       count AS 'Number of shoes'
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
LEFT JOIN locations ON shoes_per_day.location_id = locations.location_id;

-- how can we filter a SQL statement?
-- select all rows from shoes_per_day where shoe_id = 3?
SELECT * FROM shoes_per_day WHERE shoe_id = 3;

SELECT * FROM shoes WHERE shoe_id = 3;

-- I want to return all rows in shoes_per_day where
-- shoe_id = 3 and count < 7
SELECT * 
FROM shoes_per_day
WHERE shoe_id = 3 AND count < 7;

-- I want to return all rows from shoes_per_day with
-- RED shoes, the following will NOT execute
SELECT *
FROM shoes_per_day
WHERE shoe_color = 'Red'
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id;

-- there is an order of operations, any filtering or WHERE clause
-- (conditional subset) that is applied AFTER the VIRTUAL TABLE
-- has been created
SELECT *
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
WHERE shoe_color = 'Red';

-- very tedious to specify the JOINS when we have LONG table names
-- we can provide ALIAS for the tables as well
SELECT *
FROM shoes_per_day spd
LEFT JOIN shoes s ON spd.shoe_id = s.shoe_id;

-- join shoes_per_day with shoes and select a few columns
SELECT day_id, shoe_id, count 
FROM shoes_per_day spd
LEFT JOIN shoes s ON spd.shoe_id = s.shoe_id;

-- to overcome the ambiquity we must specify the TABLE
-- the returned KEY comes from
SELECT day_id, s.shoe_id, count 
FROM shoes_per_day spd
LEFT JOIN shoes s ON spd.shoe_id = s.shoe_id;

-- include the locations table and select a few columns
-- with aliases
SELECT day_id AS 'Day Number',
       s.shoe_id AS 'Shoe ID', shoe_color AS 'Shoe color',
       l.location_id AS 'Location ID', location_name AS 'Store name',
       count AS 'Number of shoes'
FROM shoes_per_day spd
LEFT JOIN shoes s ON spd.shoe_id = s.shoe_id
LEFT JOIN locations l ON spd.location_id = l.location_id;

-- OTHER WAYS to execute the joins

-- IMPLICIT SYNTAX or the IMPLICIT JOIN
-- I HATE the implicit join

SELECT day_id, s.shoe_id, shoe_color, count 
FROM shoes_per_day spd, shoes s 
WHERE spd.shoe_id = s.shoe_id;

-- the implicit join can include more than 2 tables
SELECT day_id, 
       s.shoe_id, shoe_color, 
       l.location_id, location_name,
       count
FROM shoes_per_day spd, shoes s, locations l 
WHERE spd.shoe_id = s.shoe_id AND spd.location_id = l.location_id;

-- if we neglected WHERE locations
SELECT day_id, 
       s.shoe_id, shoe_color, 
       l.location_id, location_name,
       count
FROM shoes_per_day spd, shoes s, locations l
WHERE spd.shoe_id = s.shoe_id;

-- NATURAL JOIN -- I REALLY HATE the natural join
SELECT *
FROM shoes_per_day 
NATURAL JOIN shoes;

-- the USING clause is a very handy approach to joing
-- IF AND ONLY IF the KEYS have the same name in the
-- two tables
SELECT *
FROM shoes_per_day spd 
LEFT JOIN shoes s USING (shoe_id);

-- if we needed to join two tables ON multiple columns
-- the syntax is USING (key_1, key_2, key_3, ...)

-- it's easy to create the TIDY DATA
SELECT * 
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id);

-- work with tidy data and return all rows where the
-- count is between a lower bound and an upper bound
-- for example, we want count >= 5 AND count <= 9
SELECT *
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE count >= 5 AND count <= 9;

-- this can be streamlined with the BETWEEN operator
-- BETWEEN is an INCLUSIVE filtering
SELECT *
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE count BETWEEN 5 AND 9;

-- find all rows associated with Noodles & Company
SELECT * 
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE location_name = 'Noodles & Company';

-- the LIKE keyword searches for patterns in text
SELECT *
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE location_name LIKE 'N%';

-- DISTINCT can help us here
SELECT DISTINCT location_name
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE location_name LIKE 'N%';

-- search for patterns where the ENDING character 
-- is specified
SELECT DISTINCT location_name
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE location_name LIKE '%y';

-- LIKE a pattern that CONTAINS
SELECT DISTINCT location_name
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE location_name LIKE '%oo%';

SELECT DISTINCT location_name
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE location_name LIKE '%e%';

-- can also specify an exact NUMBER of characters
-- with underscores
SELECT DISTINCT shoe_color
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE shoe_color LIKE '_t___';

-- REGULAR EXPRESSIONS

-- find all shoe colors that begin with the letter b
SELECT DISTINCT shoe_color
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE shoe_color REGEXP '^b';

-- find all shoe_color that end with e
SELECT DISTINCT shoe_color
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE shoe_color REGEXP 'e$';

-- find all shoe colors that end with e OR end with k
SELECT DISTINCT shoe_color
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
WHERE shoe_color REGEXP 'e$|k$';

-- APPLYING functions to summarize data
-- what is the max value of the count column in shoes_per_day?
SELECT MAX(count) FROM shoes_per_day;

-- how can we check? 
SELECT count FROM shoes_per_day;

-- we can arrange or SORT the rows BY a column
SELECT *
FROM shoes_per_day
ORDER BY count;

-- order by count in descesnding order
SELECT * 
FROM shoes_per_day
ORDER BY count DESC;

-- the ORDER BY clause can work with multiple columns
-- order by day_id and descending order for count
SELECT *
FROM shoes_per_day
ORDER BY day_id, count DESC;

-- when we JOIN multiple tables together the ORDER BY
-- clause should come at the end
SELECT * 
FROM shoes_per_day spd
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
ORDER BY day_id, count DESC;

-- MAX, MIN, AVERAGE of a variable in a table
SELECT MAX(count), MIN(count), AVG(count) FROM shoes_per_day;

-- use ALIASES to modify the returned fields
SELECT MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day;

-- the COUNT() function is a handy way of finding out
-- the number of rows in a table
SELECT COUNT(*) FROM shoes_per_day;

-- APPLY the summary functions just for shoe_id = 2
SELECT shoe_id,
       MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day
WHERE shoe_id = 2;

-- check the rows for shoe_id = 2
SELECT shoe_id, count FROM shoes_per_day WHERE shoe_id = 2;

-- the GROUP BY operation performs SPLIT-APPLY-COMBINE
SELECT shoe_id,
       MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day
GROUP BY shoe_id;

-- group by multiple variables, we just include more variable
-- names in the GROUP BY clause
-- for example group by shoe_id and location_id:
SELECT shoe_id, location_id,
       MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day
GROUP BY shoe_id, location_id;

-- we can include JOINS in our grouping and summarizing actions
SELECT shoe_id, location_id, 
       shoe_color, location_name,
       MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
GROUP BY shoe_id, location_id;

-- we can order as well after grouping and summarizing
-- for example, let's order by the location_id
SELECT shoe_id, location_id, 
       shoe_color, location_name,
       MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
GROUP BY shoe_id, location_id
ORDER BY location_id;

-- how can we filter or conditionally subset a grouped
-- table?
-- we cannot use WHERE, when we work with grouped 
-- and summarized tables we must use HAVING

-- lets find all rows where the average is greater than 8
SELECT shoe_id, location_id, 
       shoe_color, location_name,
       MAX(count) AS highest,
       MIN(count) AS lowest,
       AVG(count) AS average,
       SUM(count) AS total,
       COUNT(id) AS 'Number of rows'
FROM shoes_per_day
LEFT JOIN shoes s USING (shoe_id)
LEFT JOIN locations l USING (location_id)
GROUP BY shoe_id, location_id
HAVING average > 8;

-- we want to calculate the SUMMED total of a value
-- per group
SELECT shoe_id, SUM(count) AS total
FROM shoes_per_day
GROUP BY shoe_id;

-- MySQL allows including the "ROLLUP"
SELECT shoe_id, SUM(count) AS total
FROM shoes_per_day
GROUP BY shoe_id WITH ROLLUP;

-- easy to do with multiple variables defining the group
SELECT shoe_id, location_id, SUM(count) AS total
FROM shoes_per_day
GROUP BY shoe_id, location_id WITH ROLLUP;

-- SUBQUERIES --

-- find all rows where the count is greater than the average count

-- what is the average count?
SELECT AVG(count) FROM shoes_per_day;

-- find all rows where count is greater than 8
SELECT *
FROM shoes_per_day
WHERE count > 8;

-- replace 8 with the result of a SUBQUERY
SELECT *
FROM shoes_per_day
WHERE count > (SELECT AVG(count) FROM shoes_per_day);

-- a subquery can contain WHERE clause
-- find all rows where the count is greater than the
-- average value where shoe_id = 2
SELECT *
FROM shoes_per_day
WHERE count > (SELECT AVG(count) FROM shoes_per_day WHERE shoe_id=2);

-- the above subquery is NOT count > 8
SELECT AVG(count) FROM shoes_per_day WHERE shoe_id=2;

-- embed grouping and summarizing within the subquery
-- essentially average an average

-- demonstrate the "inner grouping"
SELECT day_id, location_id, SUM(count) AS sum_count
FROM shoes_per_day
GROUP BY day_id, location_id;

-- embedd the above query as a subquery
SELECT location_id, 
       AVG(sum_count) AS avg_count,
       COUNT(day_id) AS num_days
FROM (
 SELECT day_id, location_id, SUM(count) AS sum_count
 FROM shoes_per_day
 GROUP BY day_id, location_id
) AS store_per_day
GROUP BY location_id;

-- create a view or a "window into the data"
-- to answer a very specific question

-- create a view for the number of people in a store on a day
CREATE VIEW store_per_day_view AS
SELECT day_id, location_id, SUM(count) AS sum_count
FROM shoes_per_day
GROUP BY day_id, location_id;

-- we essentially interact with a VIEW like a regular table
SELECT location_id, AVG(sum_count) AS avg_count, COUNT(day_id) AS num_days
FROM store_per_day_view
GROUP BY location_id;

-- we can join using a VIEW
SELECT *
FROM store_per_day_view
LEFT JOIN locations l USING (location_id);