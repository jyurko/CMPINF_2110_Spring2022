-- CMPINF 2110 Spring 2022 Week 07

-- Dates, datetime, and date functions

-- to get the current datetime we can use the NOW() function
SELECT NOW();

-- the returned format is the MySQL standard of:
-- YYYY-MM-DD hh:mm::ss

-- if we only want the date and not the complete datetime
SELECT CURDATE();

-- or we can call the synonym CURRENT_DATE()
SELECT CURRENT_DATE();

-- just to show these two return the same thing
SELECT NOW(), CURDATE(), CURRENT_DATE();

-- if we just want the (clock) time
SELECT NOW(), CURRENT_TIME(), CURTIME();

-- We can extract features or components from the complete datetime object
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW());

-- also works with just a date and not a datetime object
SELECT YEAR(CURRENT_DATE()), MONTH(CURRENT_DATE()), DAY(CURRENT_DATE());

-- with the complete datetime object we can also extract clock features
-- include Aliases to help the returned field names read easier
SELECT NOW(),
     YEAR(NOW()) AS `Current year`,
     MONTH(NOW()) AS `Current month`,
     DAY(NOW()) AS `Current day`,
     HOUR(NOW()) AS `Current hour`,
     MINUTE(NOW()) AS `Current minute`,
     SECOND(NOW()) AS `Current second`;

-- let's review subqueries, I want a subquery that returns the NOW() datetime as a
-- field in a table
SELECT NOW() AS the_dt;

SELECT * 
FROM (
    SELECT NOW() AS the_dt
) my_table;

-- extract the components of the datetime
SELECT the_dt AS `Current date time`,
    YEAR(the_dt) AS `Current year`,
    MONTH(the_dt) AS `Current month`,
    DAY(the_dt) AS `Current day`,
    HOUR(the_dt) AS `Current hour`
FROM (
    SELECT NOW() AS the_dt
) my_table;

-- YEAR(), MONTH(), and DAY() functions are specific to MySQL and they may not
-- exist in other flavors of SQL

-- the more general SQL standard approach for EXTRACTING components or features
-- of a datetime object is the EXTRACT() function
SELECT EXTRACT(YEAR FROM NOW());

SELECT EXTRACT(YEAR FROM CURRENT_DATE());

SELECT EXTRACT(MONTH FROM CURRENT_DATE());

-- we can alias the extracted results
SELECT EXTRACT(YEAR FROM NOW()) AS `Current year`,
       EXTRACT(MONTH FROM NOW()) AS `Current month`;
       
-- additional components or features of a datetime object exist
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html

-- so let's look at a few additional components
SELECT NOW(), YEAR(NOW()), MONTH(NOW()), MONTHNAME(NOW()), QUARTER(NOW()), WEEK(NOW());

-- MONTHNAME() is the name of the month, DAYNAME() is the name of the day of the week
SELECT NOW(), YEAR(NOW()), MONTH(NOW()), MONTHNAME(NOW()), DAY(NOW()), DAYNAME(NOW());

SELECT NOW(), YEAR(NOW()), MONTH(NOW()), MONTHNAME(NOW()), DAY(NOW()), DAYNAME(NOW()), DAYOFWEEK(NOW());

-- but what if we don't like the format returned by these functions?
-- let's review some useful string manipulation functions within MySQL

-- maybe we want the month name in all upper case
SELECT NOW(), UPPER( MONTHNAME(NOW()) );

-- we can also force all characters to be lower case
SELECT NOW(), MONTH(NOW()), MONTHNAME(NOW()), UPPER(MONTHNAME(NOW())), LOWER(MONTHNAME(NOW()));

-- maybe instead we want just the first 3 letters of the month in all upper case
-- we must create a SUBSTRING from the monthname string
SELECT MONTH(NOW()), 
	   MONTHNAME(NOW()), 
       SUBSTRING(MONTHNAME(NOW()), 1, 3),
       UPPER( SUBSTRING(MONTHNAME(NOW()), 1, 3) ),
       LOWER( SUBSTRING(MONTHNAME(NOW()), 1, 3) );

-- we can use a subquery to allow us to not keep rewriting calling the MONTHNAME() function
-- over and over
SELECT the_month, SUBSTRING(the_month, 1, 3), UPPER(SUBSTRING(the_month, 1, 3)), LOWER(SUBSTRING(the_month, 1, 3))
FROM (
    SELECT MONTHNAME(NOW()) AS the_month
) my_table;

-- Date Format - what if I wanted a completely different format for the date?
-- YYYY-MM-DD
-- what's with: MM/DD/YYYY ?
-- or DD MONTH YYYY ?
-- 2022-02-22 vs 02/22/2222 vs 02 February 2022 vs February 22, 2022

-- we often need to modify the way the date is presented or formatted
-- when it's printed as a string

-- the date format is specified by the DATE_FORMAT() function and the
-- way the date will be printed is controled by the spcecifiers

-- all date format specifiers:
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format

SELECT DATE_FORMAT(NOW(), '%M');

SELECT DATE_FORMAT(NOW(), '%M %Y');

SELECT DATE_FORMAT(NOW(), '%M %y');

SELECT DATE_FORMAT(NOW(), '%M %d %Y');

-- specifier order matters
SELECT DATE_FORMAT(NOW(), '%d %M %Y');

SELECT DATE_FORMAT(NOW(), '%d %b %Y');

SELECT DATE_FORMAT(NOW(), '%d %m %Y');

-- what happens if we place other characters between the specifiers
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y');

SELECT DATE_FORMAT(NOW(), '%m-%d-%Y');

-- ALIAS if we want
SELECT DATE_FORMAT(NOW(), '%m-%d-%Y') AS `The date`;

-- there are many different formats for the date
SELECT GET_FORMAT(DATE, 'USA'), GET_FORMAT(DATE, 'EUR'), GET_FORMAT(DATE, 'JIS');

-- we can supply the GET_FORMAT() result to the DATE_FORMAT() function
SELECT DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'USA')),
       DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'EUR')),
       DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'JIS'));

-- Date Arithmetic -- the math usually doesn't add up

-- for example, let's add 1 day to todays date
SELECT the_dt AS `current timestamp`,
       YEAR(the_dt) AS `year`,
       MONTH(the_dt) AS `month`,
       DAY(the_dt) AS `today`,
       DAY(the_dt) + 1 AS `tomorrow`
FROM (
    SELECT NOW() AS the_dt
) my_table;

-- but what if we want to add 7 days (1 week) to today?
SELECT the_dt AS `current timestamp`,
       YEAR(the_dt) AS `year`,
       MONTH(the_dt) AS `month`,
       DAY(the_dt) AS `today`,
       DAY(the_dt) + 7 AS `next week`,
       DAY(the_dt) * 100 - 23 AS `something`
FROM (
    SELECT NOW() AS the_dt
) my_table;

-- we just add in an integer to the current day in the month...
-- is next week Feb 29?

-- our datetime arthmetic must KNOW the calendar
-- we can ADD to a date with the DATE_ADD() function
-- we can SUBTRACT from a date with the DATE_SUB() function

-- we must specify the INTERVAL and units when adding/subtracting
SELECT NOW() AS `today`, DATE_ADD(NOW(), INTERVAL 1 DAY) AS `tomorrow`;

-- we can add 7 days
SELECT NOW() AS `today`, DATE_ADD(NOW(), INTERVAL 7 DAY) AS `next week`;

-- can go backwards with DATE_SUB()
SELECT NOW() AS `today`, DATE_SUB(NOW(), INTERVAL 1 DAY) AS `yesterday`;

-- we can of course extract out any component that we want
SELECT `today`, DAY(`today`) AS `todays_day`, `yesterday`, DAY(`yesterday`) AS `yesterdays_day`
FROM (
SELECT NOW() AS `today`, DATE_SUB(NOW(), INTERVAL 1 DAY) AS `yesterday`
) my_table;

-- if we wanted, we could change the format of the added or subtracted dates
-- using the same approach as previously

-- the number of days between dates or the DATEDIFF()

-- MySQL's default date format is YYYY-MM-DD so if we type a string
-- in that format into a DATE related function MySQL will automatically
-- convert it to a date
-- arguments to DATEDIFF(<end date>, <start date>)
SELECT DATEDIFF('2022-02-22', '2022-02-01');

SELECT DATEDIFF('2022-02-01', '2022-02-22');

-- if we want to know the number of days from NOW() to some date in the future
SELECT DATEDIFF('2022-03-01', NOW());

SELECT DATEDIFF('2022-03-01', CURRENT_DATE());

-- we could be more formal when we create the date with the STR_TO_DATE() function
-- STR_TO_DATE() requires a string and the format associated with the string
SELECT '2022-03-01' AS my_string, STR_TO_DATE('2022-03-01', '%Y-%m-%d') AS my_date;

-- but we can extract date components from a date object
SELECT '2022-03-01' AS my_string, MONTHNAME(STR_TO_DATE('2022-03-01', '%Y-%m-%d'));

-- when using STR_TO_DATE() we must be very careful with the entered string and
-- the entered date format
SELECT STR_TO_DATE('2022-03-01', '%Y-%M-%d');

-- maybe we want to categorize the status of an order and we want to know
-- if the number of days between shipping and the received order is
-- "good" or "bad"

-- we are going to use the IF() function just like we used np.where() in Python
-- the IF() function reads as "if else", if the condition is TRUE return a value
-- ELSE return something else
-- IF(<condition>, <true return>, <false return>)

SELECT DATEDIFF('2022-02-22', '2022-02-15') > 5;

SELECT IF( DATEDIFF('2022-02-22', '2022-02-15') > 5, 'bad', 'good');

SELECT IF( DATEDIFF('2022-02-22', '2022-02-15') > 5, 'bad', 'good') AS `shipping result`;

-- I just set this up so the TRUE is BAD
SELECT IF( DATEDIFF('2022-02-22', '2022-02-15') > 5, 'the true returned value', 'the false returend value') AS `shipping result`;

-- we can use a subquery to help streamline the above line of code
SELECT IF(num_days > 5, 'taking too long', 'good job')
FROM (
    SELECT DATEDIFF('2022-02-22', '2022-02-15') AS num_days
) my_table;

-- what if we wanted multiple conditions?
-- for example, maybe the status can be "bad" or "ok" or "good"

-- we can create a CASE TABLE, which makes use of the WHEN clause and THEN specifies the result

SELECT 
    CASE
        WHEN num_days < 3 THEN 'good'
        WHEN num_days BETWEEN 3 AND 5 THEN 'ok'
        WHEN num_days > 5 THEN 'bad'
    END AS `shipping result`
FROM (
    SELECT DATEDIFF('2022-02-22', '2022-02-15') AS num_days
) my_table;

-- WHY DOES THIS MATTER????????

-- NORMALIZATION!!!!!!!!!!!!

-- we want the base tables in our database to have ZERO redundency!!!!
-- we want NO derived quantities in the base tables
-- derived quantities are intended for QUERIES or VIEWS

-- let's make a small data base which will store a table orders
-- and a table for shipments
CREATE DATABASE few_orders_db;

USE few_orders_db;

-- create a "bad" table which has redundent or derived features inside
-- the base table within the database
CREATE TABLE bad_orders_table (
order_id int NOT NULL AUTO_INCREMENT,
received_date date NOT NULL,
received_year int,
received_month int,
received_day int,
PRIMARY KEY (order_id)
);

-- populate a few orders into our table
INSERT INTO bad_orders_table (received_date, received_year, received_month, received_day) 
VALUES (STR_TO_DATE('2022-02-22', '%Y-%m-%d'), 2022, 2, 22), 
       (STR_TO_DATE('2022-02-22', '%Y-%m-%d'), 2022, 2, 21), 
       (STR_TO_DATE('2022-02-21', '%Y-%m-%d'), 2022, 2, 21), 
       (STR_TO_DATE('2022-02-19', '%Y-%m-%d'), 2022, 2, 19);
       
-- we inserted data into the table!!!!
SELECT * FROM bad_orders_table;

-- I want to know the day of the month for each order
SELECT received_month AS `Month`, received_day AS `Day` FROM bad_orders_table;

-- because lets see how the orders table should be structured
CREATE TABLE orders_table (
order_id int NOT NULL AUTO_INCREMENT,
received_date date NOT NULL,
PRIMARY KEY (order_id)
);

-- now populate the orders table
INSERT INTO orders_table (received_date) 
VALUES (STR_TO_DATE('2022-02-22', '%Y-%m-%d')), 
       (STR_TO_DATE('2022-02-22', '%Y-%m-%d')), 
       (STR_TO_DATE('2022-02-21', '%Y-%m-%d')), 
       (STR_TO_DATE('2022-02-19', '%Y-%m-%d'));
       
-- query the orders table
SELECT * FROM orders_table;

-- but the query can extract or derive the date components
SELECT order_id AS `ID`,
       received_date AS `Order date`,
       YEAR(received_date) AS `Order year`,
       MONTH(received_date) AS `Order month`,
       DAY(received_date) AS `Order day`
FROM orders_table;

-- creating a shipping table that stores the shipping date associated with
-- the order
CREATE TABLE shipping_table (
ship_id int NOT NULL AUTO_INCREMENT,
order_id int NOT NULL,
ship_date date,
PRIMARY KEY (ship_id),
FOREIGN KEY (order_id) REFERENCES orders_table(order_id)
);

-- populate shipment information
INSERT INTO shipping_table (order_id, ship_date) 
VALUES (1, STR_TO_DATE('2022-03-22', '%Y-%m-%d')), 
       (2, STR_TO_DATE('2022-02-24', '%Y-%m-%d')), 
       (3, STR_TO_DATE('2022-02-23', '%Y-%m-%d')), 
       (4, STR_TO_DATE('2022-02-22', '%Y-%m-%d'));
       
-- look at the shipping table
SELECT * FROM shipping_table;

-- join the orders and shipping table together
SELECT *
FROM orders_table
LEFT JOIN shipping_table USING (order_id);

-- calculate the number of days between shipment and receiving the order
SELECT order_id, ship_id,
       received_date AS `Order date`,
       ship_date AS `Shipping date`,
       DATEDIFF(ship_date, received_date) AS `number of days`
FROM orders_table
LEFT JOIN shipping_table USING (order_id);

-- let's categorize the shipment as "good", "ok", or "bad" timing
SELECT order_id, ship_id,
       `Order date`, `Shipping date`,
       `number of days`,
       CASE
           WHEN `number of days` < 3 THEN 'good'
           WHEN `number of days` BETWEEN 3 AND 5 THEN 'ok'
           WHEN `number of days` > 5 THEN 'bad'
       END as `shipping result`
FROM (
SELECT order_id, ship_id,
       received_date AS `Order date`,
       ship_date AS `Shipping date`,
       DATEDIFF(ship_date, received_date) AS `number of days`
FROM orders_table
LEFT JOIN shipping_table USING (order_id)
) my_table;
