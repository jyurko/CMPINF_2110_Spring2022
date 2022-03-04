-- CMPINF 2110 Spring 2022 Week 07

-- intro to SQL data types

CREATE DATABASE dtypes_db;

USE dtypes_db;

-- MySQL documentation for 
-- integer datatypes: https://dev.mysql.com/doc/refman/8.0/en/integer-types.html
-- CHAR vs VARCHAR: https://dev.mysql.com/doc/refman/8.0/en/char.html
-- all string data types: https://www.w3schools.com/mysql/mysql_datatypes.asp

-- create a table to store information about states in the USA
CREATE TABLE states (
id int NOT NULL AUTO_INCREMENT,
symbol CHAR(2) NOT NULL,
state_name_fixed CHAR(50),
state_name VARCHAR(50),
notes VARCHAR(255),
long_notes TEXT,
PRIMARY KEY (id)
);

-- insert 1 row into the states table
INSERT INTO states (symbol, state_name_fixed, state_name, notes)
VALUES ('PA', 'Pennsylvania', 'Pennsylvania', 'I live in PA');

SELECT * FROM states;

-- add in a row for Texas but allow white spaces or trailing white spaces
-- at the end of the string
INSERT INTO states (symbol, state_name_fixed, state_name, notes)
VALUES ('TX', 'Texas     ', 'Texas     ', 'Texas with lots of spaces');

SELECT * FROM states;

-- count the length of the string with the CHAR_LENGTH() function
SELECT id, state_name_fixed, state_name,
       CHAR_LENGTH(state_name_fixed) AS `CHAR length`,
       CHAR_LENGTH(state_name) AS `VARCHAR length`
FROM states;

-- CHAR data types have the trailing white spaces TRIMMED upon retrieval
-- VARCHAR does NOT automatically trim white spaces

-- but we can always force TRIMMING of strings with the TRIM() function
SELECT id, state_name_fixed, state_name,
       CHAR_LENGTH(state_name_fixed) AS `CHAR length`,
       CHAR_LENGTH(state_name) AS `VARCHAR length`,
       CHAR_LENGTH(TRIM(state_name)) AS `Trimmed VARCHAR length`
FROM states;

-- TRIM() removes all white spaces BEFORE and AFTER the text
-- if we only wanted to trim whitespaces before the text we use LTRIM()
-- if we only wanted to trim whitespaces after the text we use RTRIM()

-- how does trimming impact white space "in the middle"?
INSERT INTO states (symbol, state_name_fixed, state_name, notes)
VALUES ('NM', 'New Mexico', 'New Mexico', 'I have not lived in New Mexico');

SELECT * FROM states;

-- lets check the length of the strings after trimming
SELECT id, state_name_fixed, state_name,
       CHAR_LENGTH(state_name_fixed) AS `CHAR length`,
       CHAR_LENGTH(state_name) AS `VARCHAR length`,
       CHAR_LENGTH(TRIM(state_name)) AS `Trimmed VARCHAR length`
FROM states;

-- add in new mexico again but with a lot of weird spaces
INSERT INTO states (symbol, state_name_fixed, state_name, notes)
VALUES ('NM', 'New     Mexico', 'New     Mexico', 'Big new mexico');

SELECT * FROM states;

-- check the character string length
SELECT id, state_name_fixed, state_name,
       CHAR_LENGTH(state_name_fixed) AS `CHAR length`,
       CHAR_LENGTH(state_name) AS `VARCHAR length`,
       CHAR_LENGTH(TRIM(state_name)) AS `Trimmed VARCHAR length`
FROM states;

-- replace a string pattern with another pattern
SELECT id, state_name, REPLACE(state_name, '     ', ' ')
FROM states;

-- remove any white space
SELECT id, state_name, REPLACE(state_name, ' ', '')
FROM states;

-- what happens if we try to insert a value that exceeds that maximum allowable
-- size for the string
-- first see what happens when we try insert to the CHAR data type
INSERT INTO states (symbol, state_name_fixed, state_name)
VALUES ('UU', 'a fake very long state name that exceeds the maximum number of characters or legnth of the string as specified when we created the table', 'UUUUU');

-- lets now try with the VARCHAR column
INSERT INTO states (symbol, state_name_fixed, state_name)
VALUES ('UU', 'UUUUU',
'a fake very long state name that exceeds the maximum number of characters or legnth of the string as specified when we created the table');

-- add a column to our table
SELECT * FROM states;

-- the CLAUSE or VERB for adding a column is to ALTER the table
ALTER TABLE `dtypes_db`.`states`
ADD COLUMN `admit_year` INT NOT NULL AFTER `long_notes`;

-- look at the table
SELECT * FROM states;

-- instead of using NOT NULL let's allow the column to have missings
-- use the variabel definition table in the GUI to add the column
-- copy and paste the autogenerated code
ALTER TABLE `dtypes_db`.`states` 
ADD COLUMN `admit_year_again` INT NULL AFTER `admit_year`;

SELECT * FROM states;

-- UPDATE the table to add in values for the admit_year_again
-- so we go from MISSING to a non-missing value
-- workbench prevents this from working because of safe mode
UPDATE states SET admit_year_again = 1787 WHERE symbol = 'PA'; 

SELECT * FROM states;

-- update using the PK
UPDATE states SET admit_year_again = 1787 WHERE id = 1;

SELECT * FROM states;

-- before updating the admit year for texas lets add in MA
INSERT INTO states (symbol, state_name_fixed, state_name, notes, admit_year)
VALUES ('MA', 'Massachusetts', 'Massachusetts', 'I lived in MA', 1788);

SELECT * FROM states;

-- update the admit year for Texas and Massachusetts we can use CASE WHEN THEN TABLES
-- to update based on a condition
UPDATE states SET admit_year_again = 
    CASE WHEN id = 2 THEN 1845
         WHEN id = 5 THEN 1788
    END 
WHERE id IN (2, 5);

SELECT * FROM states;

-- whenever we query a table we can actually control the returned result
-- for missings
SELECT id, symbol, admit_year_again
FROM states;

-- the IFNULL() function allows us to override the missing return
SELECT id, symbol, 
       IFNULL(admit_year_again, 'Not sure')
FROM states;

-- please be careful with the IFNULL() function it modifies effectively
-- the returned columns data type

-- another import number data type is the DECIMAL()
-- the format for DECIMAL is:

-- DECIMAL(9, 2) --> 1234567.89

-- DECIMAL(<total number of digits>, <number of digits to the right of the decimal>)

-- JSON -> enables multivalued entries
-- very useful for receiving data from mobile devices and the internet

-- JSON is basically a Python dictionary
-- it is KEY-VALUE paired

-- JSON is entered within CURLY BRACES, {}

-- add a column for holding information associated with the state bird

ALTER TABLE dtypes_db.states
ADD COLUMN state_bird JSON NULL AFTER admit_year_again;

SELECT * FROM states;

-- add information about the state bird of PA
UPDATE states SET 
state_bird = '
{
"name": "Ruffed Grouse",
"two_term_name": "Bonasa umbellus",
"year": 1931
}
'
WHERE id = 1;

SELECT id, symbol, state_bird FROM states;

-- add in another JSON column to see a shortcut for entering JSON information
ALTER TABLE `dtypes_db`.`states`
ADD COLUMN `state_bird_again` JSON NULL AFTER `state_bird`;

-- enter the JSON data using the JSON_OBJECT() function
UPDATE states SET state_bird_again = JSON_OBJECT(
'name', 'Ruffed Grouse', 
'two_tern_name', 'Bonasa umbellus',
'year', 1931
)
WHERE id = 1;

SELECT id, symbol, state_bird, state_bird_again FROM states;

-- extract the VALUE from a KEY in a JSON object from a table
-- we do so with the JSON_EXTRACT() function
SELECT id, symbol, 
       JSON_EXTRACT(state_bird, '$.name')
FROM states
WHERE symbol = 'PA';

-- first instead of using the JSON_EXTRACT() function we use the
-- column path operator: ->
SELECT id, symbol,
       state_bird -> '$.name'
FROM states
WHERE symbol = 'PA';

-- to remove the quotes we need the "super operator" ->>
SELECT id, symbol,
       state_bird ->> '$.name'
FROM states
WHERE symbol = 'PA';

-- we can use the super operator within SQL functions
SELECT id, symbol,
       state_bird ->> '$.name'
FROM states;

-- wrap the super operator with IFNULL()
SELECT id, symbol,
       IFNULL(state_bird ->> '$.name', 'Must look up') AS 'state bird'
FROM states;