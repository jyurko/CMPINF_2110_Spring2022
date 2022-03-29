-- cmpinf 2110 spring 2022 - Week 09

-- user 2

-- also work with simple_shoes_db database
USE simple_shoes_db;

-- user 2 will update the shoe labels

START TRANSACTION;

UPDATE shoes SET shoe_label = 'B' WHERE shoe_id = 1;
UPDATE shoes SET shoe_label = 'B' WHERE shoe_id = 3;

COMMIT;

-- user 2 updates 2 more rows in the shoes table
-- but the changes are rolled back instead of committed
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'w' WHERE shoe_id = 4;

ROLLBACK;

-- user 1 now has the lowest isolation level READ UNCOMMITTED
-- make 2 changes but rollback those changes

START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'w' WHERE shoe_id = 4;

ROLLBACK;

SHOW VARIABLES LIKE 'transaction_isolation';

-- user 2 makes a update and user 1 makes an update as well
-- user 2 starts then user 1 makes an update after user 2
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'w' WHERE shoe_id = 4;

ROLLBACK;

-- user 1 now has the read committed isolation level
-- make two changes and rollback
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'w' WHERE shoe_id = 4;

ROLLBACK;

-- however once the transaction is committed
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'w' WHERE shoe_id = 4;

COMMIT;

-- what does user 2 see?
SELECT * FROM shoes;

-- user 1 now had read committed and will attempt 2 SELECTs
-- within the same transaction
START TRANSACTION;

UPDATE shoes SET shoe_label = 'R' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'W' WHERE shoe_id = 4;

COMMIT;

-- user 1 now has repeatable read isolation level
-- make 2 updates after user 1 has selected data the
-- first time
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;
UPDATE shoes SET shoe_label = 'w' WHERE shoe_id = 4;

COMMIT;

-- user 1 now has the serializable isolation level
-- update just a single row

-- user 2 starts the transaction before user 1
START TRANSACTION;

UPDATE shoes SET shoe_label = 'r' WHERE shoe_id = 2;

COMMIT;