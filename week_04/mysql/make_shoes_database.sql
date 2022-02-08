-- comments are started with 2 minus signs
-- this is a comment in MySQL

-- SQL is NOT case sensitive
-- thisVariableName is the SAME as thisvariablename and THISVARIABLENAME
-- by convention we will type SQL KEYWORDS in UPPERCASE all other variables
-- will be typed in lower case

-- SQL works with ACTIONS or CLAUSES or VERBS

-- Let's create a data base
CREATE DATABASE shoes_db;

-- we need to tell SQL which database we want to work with
-- the VERB is USE
USE shoes_db;

-- import a table with the data import wizard tool to bring in the 
-- locations table

-- use the variable defintions panel to make the location_id the primary key

-- clicking on the table icon in the schemas panel will SELECT all columns
SELECT * FROM locations;

-- to select one column or FIELD from the a table we just type in that
-- field name
SELECT location_id FROM locations;

-- select multiple columns we separate the column names with commas
SELECT location_id, location FROM locations;

-- if we want to FILTER or conditionally subset OR select rows
-- we must specify WHERE a condition applies

-- select all rows where location equals D 
SELECT location_id, location, location_name FROM locations WHERE location = 'D';

-- we can spread the actions across multiple lines
SELECT location_id, location, location_name
FROM locations
WHERE location = 'D';

-- if we want to find rows where location is D OR P so dunkin donuts
-- or panera bread
SELECT location_id, location, location_name
FROM locations
WHERE location = 'D' OR location = 'P';

-- the isin() method comes from SQL's IN operator
-- so instead of using OR we can just include a collection 
-- to search in
SELECT location_id, location, location_name
FROM locations
WHERE location IN ('D', 'P');

-- finding all rows where location is NOT dunkin or panera
-- include the NOT operator
SELECT location_id, location, location_name
FROM locations
WHERE location NOT IN ('D', 'P');

-- create our own table with code rather than using the import wizard
CREATE TABLE shoe_info_table (
shoe_id int NOT NULL,
shoe text NOT NULL,
shoe_color text NOT NULL,
PRIMARY KEY (shoe_id)
);

-- to populate a table we must INSERT INTO the table
-- we insert one ROW at a time in SQL a row is called a RECORD
-- the line of code below produces an ERROR because we defined the
-- table to require ALL fields in every RECORD
INSERT INTO shoe_info_table VALUES (1);

-- insert the first row or RECORD to the shoe info table
-- mess up the column order
-- the line of code below produces an ERROR
INSERT INTO shoe_info_table VALUES ('Black', 'B', 1);

-- the correct first record
INSERT INTO shoe_info_table VALUES (1, 'B', 'Black');

-- add the second row, but let's identify the specific columns
-- the values correspond to
INSERT INTO shoe_info_table (shoe_id, shoe, shoe_color) 
VALUES (2, 'O', 'Other');

-- multiple records can be inserted together we just separate
-- by commas
INSERT INTO shoe_info_table (shoe_id, shoe, shoe_color)
VALUES (3, 'R', 'Red'), (4, 'W', 'White');

-- when we create the table we instruct the table to AUTO INCREMENT
-- integers. this is really useful for PRIMARY KEYS

-- recreate the shoes table but this time force an AUTO INCREMENT
-- on the shoe_id PRIMARY KEY
CREATE TABLE shoes (
shoe_id int NOT NULL AUTO_INCREMENT,
shoe text,
shoe_color text NOT NULL,
PRIMARY KEY (shoe_id)
);

-- insert rows and populate the table
INSERT INTO shoes (shoe_id, shoe, shoe_color) VALUES (DEFAULT, 'B', 'Black');

-- with auto increment we do not even need to include that column
INSERT INTO shoes (shoe, shoe_color) VALUES ('O', 'Other');

-- we allowed the shoe column to have MISSINGS so let's see how that works
-- in SQL a MISSING is referred to as a NULL value
INSERT INTO shoes (shoe, shoe_color) VALUES (NULL, 'Red');

-- we don't even need the column included in the insert statement for it
-- to be missing
INSERT INTO shoes (shoe_color) VALUES ('White');

-- we can UPDATE a table, we can override values or override
-- records
-- we must use a CONDITION so a WHERE clause to identify the record
-- and we must SET the value of a field
-- the below won't work by default because of SAFE MODE
UPDATE shoes SET shoe = 'R' WHERE shoe_color = 'Red';

-- to update a record we must know the primary key value
UPDATE shoes SET shoe = 'R' WHERE shoe_id = 3;

UPDATE shoes SET shoe = 'W' WHERE shoe_id = 4;

-- create the LINK or relationship table which acts as the long format
-- tidy data with one row based on the observational unit
CREATE TABLE shoes_per_day (
id int NOT NULL AUTO_INCREMENT,
day_id int NOT NULL,
location_id int NOT NULL,
shoe_id int NOT NULL,
count int,
PRIMARY KEY (id),
FOREIGN KEY (location_id) REFERENCES locations(location_id),
FOREIGN KEY (shoe_id) REFERENCES shoes(shoe_id)
);

-- populate with the data import wizard

-- how do we use or QUERY the data base to get the data for analysis?

-- we must JOIN the tables through their RELAIONSHIPS
SELECT *
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id;

-- chain another merge with the locations
SELECT *
FROM shoes_per_day
LEFT JOIN shoes ON shoes_per_day.shoe_id = shoes.shoe_id
LEFT JOIN locations ON shoes_per_day.location_id = locations.location_id;