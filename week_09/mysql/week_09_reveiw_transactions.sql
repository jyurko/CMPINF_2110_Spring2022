-- CMPINF 2110 Spring 2022 - Week 09

-- REVIEW TRANSACTIONS

USE simple_shoes_db;

-- we made a single table last time
SELECT * FROM shoes;

-- by default MySQL Workbench AUTOCOMITTS all transactions
SHOW VARIABLES LIKE 'autocommit';

-- let's update the shoes table so that the white shoe
-- has a label 'W'
UPDATE shoes SET shoe_label = 'W' WHERE shoe_id = 4;

-- the change has been committed
SELECT * FROM shoes;

-- the formal way of executing a TRANSACTION is to 
-- START and then COMMIT the transaction

-- update the shoes table so that the white shoe has a 
-- missing label or NULL value
START TRANSACTION;

UPDATE shoes SET shoe_label = NULL WHERE shoe_id = 4;

COMMIT;

-- we have modified the table
SELECT * FROM shoes;

-- before the transaction is commited, it can be ROLLED BACK
-- update and set the white shoe label to 'W' again
START TRANSACTION;

UPDATE shoes SET shoe_label = 'W' WHERE shoe_id = 4;

ROLLBACK;

-- see if any change exists
SELECT * FROM shoes;

-- a TRANSACTION either completely succeeds or it completely fails
-- make two updates and then rollback

START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'W' WHERE shoe_id = 4;

ROLLBACK;

-- what do we see?
SELECT * FROM shoes;

-- the entire transaction is committed or rolledback;
-- this is known as the transactions are ATOMIC


