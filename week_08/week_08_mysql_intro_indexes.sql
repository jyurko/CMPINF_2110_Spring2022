-- load in the data from the NFL homework assignment

CREATE DATABASE nfl_big;

USE nfl_big;

-- import the full data set using the Data Import Wizard

-- modify the data type to CHAR(3) for home_team
-- add in a primary key that is auto incremented

SELECT * FROM all_data;

-- SELECT all rows where home team corresponds to Pittsburgh
SELECT * FROM all_data WHERE home_team = 'PIT';

-- explain how the query is executed this is especially useful when
-- we filtering (applying the WHERE clause)
EXPLAIN SELECT * FROM all_data WHERE home_team = 'PIT';

EXPLAIN SELECT * FROM all_data WHERE away_team = 'PIT';

-- define an index to accelerate the where clause query
CREATE INDEX idx_home_team ON all_data (home_team);

-- Execute the query again
SELECT * FROM all_data WHERE home_team = 'PIT';

EXPLAIN SELECT * FROM all_data WHERE home_team = 'PIT';

SHOW INDEXES IN all_data;

-- what if we tried to use away_team as an index?
CREATE INDEX idx_away_team ON all_data (away_team);