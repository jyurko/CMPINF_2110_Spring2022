-- Transactions

-- SELECT/UPDATE/INSERT or modify the database in anyway

-- make a simple database related to our shoes counting example

CREATE DATABASE simple_shoes_db;

USE simple_shoes_db;

-- make a table
CREATE TABLE shoes (
shoe_id INT NOT NULL AUTO_INCREMENT,
shoe_label TEXT,
shoe_color TEXT,
PRIMARY KEY (shoe_id)
);

-- populate records into the table
INSERT INTO shoes (shoe_color) VALUES
('black'), ('red'), ('blue'), ('white');

SELECT * FROM shoes;

-- UPDATE the table by setting shoe_label to 'R' where shoe_color is Red
UPDATE shoes SET shoe_label = 'R' WHERE shoe_id = 2;

SELECT * FROM shoes;

-- TRANSACTION --> unit of work or set of MySQL Commands that 
-- modify/update/insert/select rows/columns from tables in a database

SHOW VARIABLES LIKE 'autocommit';

-- the formal way a TRANSACTION is processed is:

-- STARTS, <set of commands>, COMMIT;

START TRANSACTION;

SELECT * FROM shoes;

COMMIT;

-- but COMMITTING an UPDATE is a big deal 
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;

COMMIT;

-- the only to change a commit transaction is to run another transaction

-- if the transaction fails maybe to loss of connection, loss of internet
-- what if multiple transactions hit the database at basically the same time

-- start, action, commit the transaction because we can if we need to
-- ROLLBACK a commit

-- ROLLBACK works because behind the scenes there's a LOG FILE that contains
-- all transactions that the database must process

-- create a transaction that will update the value of shoe label for 2 shoes

START TRANSACTION;

UPDATE shoes SET shoe_label = 'R' WHERE shoe_id = 2;

UPDATE shoes SET shoe_label = 'W' WHERE shoe_id = 4;

-- UNDO the changes or ROLLBACK the transaction
ROLLBACK;

-- a Transaction is ATOMIC - the transaction either completely succeeds
-- and therefore committed OR the transaction completely fails

-- don't include START TRANSACTION
UPDATE shoes SET shoe_label = 'R' WHERE shoe_id = 2;

-- we cannot rollback a COMMMITTED transaction
ROLLBACK;

-- the goal of understanding transacations is that we make sure the
-- database is CONSISTENT for all users and it is DURABLE