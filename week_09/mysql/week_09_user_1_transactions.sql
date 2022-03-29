-- CMPINF 2110 SPRING 2022 - Week 09

-- USER 1

-- we want to work with the simple_shoes_db database
USE simple_shoes_db;

-- user 1 will simply query all rows in shoes
-- user 2 modifying the table

-- all transactions will be wrapped in the formal
-- START / COMMIT "package"

-- user 1 selects all rows
START TRANSACTION;

SELECT * FROM shoes;

COMMIT;

-- behind the scenes SQL LOCKS tables between transactions
-- SQL creates isolations between transactions hitting the same table

-- user 1 queries all rows in shoes again BUT user 2's
-- transaction will be rolled back

-- the isolation between transactions is trying to prevent 
-- CONCURRENCY PROBLEMS

-- the simplest concurrency problem is DIRTY READ

-- A: atomicity
-- C: consistency
-- I: isolation
-- D: durability

-- if we did not isolate transactions from each other, users
-- can be surprised within a single transaction

-- LOCKING is how the transactions are isolated but we can
-- modify the isolation LEVEL

SHOW VARIABLES LIKE 'transaction_isolation';

-- let's set the isolation level to the LOWEST level
-- which protects against NOTHING
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SHOW VARIABLES LIKE 'transaction_isolation';

-- user 1 will again just query all rows from the table
START TRANSACTION;

SELECT * FROM shoes;

COMMIT;

-- what happens if two users try to modify the same row
START TRANSACTION;

UPDATE shoes SET shoe_label = 'RR' WHERE shoe_id = 2;

ROLLBACK;

-- to deal with DIRTY READS we need the READ COMMITTED 
-- ISOLATION LEVEL
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

SHOW VARIABLES LIKE 'transaction_isolation';

-- query all rows again
START TRANSACTION;

SELECT * FROM shoes;

COMMIT;

-- but read committed is still susceptiable to problems

-- have user 1 query all rows twice within the same transaction
-- user 1 starts transaction before user 2 and selects all columns
-- after the first select, user 2 starts updated the data and commits
START TRANSACTION;

SELECT * FROM shoes;

SELECT * FROM shoes;

COMMIT;

-- the read committed isolation level is susceptiable to 
-- NON-REPEATABLE READS

-- to prevent non-repeatable reads we must set the isolation level
-- to REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SHOW VARIABLES LIKE 'transaction_isolation';

-- run the exact same query as before but now with the
-- repeatable read isolation level
START TRANSACTION;

SELECT * FROM shoes;

SELECT * FROM shoes;

COMMIT;

-- once both transaction are committed, user 1 is now able
-- to see the changes committed from user 2
SELECT * FROM shoes;

-- repeatable read makes sure data does NOT change mid transaction
-- so no surprises!!!!!!!!!!

-- one more isolation level - it's the most strict and it effectively
-- turns the multisession or multi-user environment into a single
-- user environment

-- SERIALIZE all transactions, no transaction can be started until
-- the other transactions stop

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SHOW VARIABLES LIKE 'transaction_isolation';

-- user 2 starts a transaction and then commits 
-- see what happens with user 1's transaction

START TRANSACTION;

SELECT * FROM shoes;

COMMIT;

-- reset to the defeault isolation level
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SHOW VARIABLES LIKE 'transaction_isolation';