-- Title: DB Assignment 6
-- Your Name: Deare
-- Date: 2024/12/8

use ok;
-- when set, it prevents potentially dangerous updates and deletes
set SQL_SAFE_UPDATES=0;

-- when set, it disables the enforcement of foreign key constraints.
set FOREIGN_KEY_CHECKS=0;

SHOW SESSION VARIABLES LIKE '%timeout%';       
SET GLOBAL mysqlx_connect_timeout = 600;
SET GLOBAL mysqlx_read_timeout = 600;

-- create table
 CREATE TABLE accounts (
   account_num CHAR(5) PRIMARY KEY,    -- 5-digit account number (e.g., 00001, 00002, ...)
   branch_name VARCHAR(50),            -- Branch name (e.g., Brighton, Downtown, etc.)
   balance DECIMAL(10, 2),             -- Account balance, with two decimal places (e.g., 1000.50)
   account_type VARCHAR(50)            -- Type of the account (e.g., Savings, Checking)
 );
 
 -- Create Stored Procedures
DELIMITER $$

CREATE PROCEDURE generate_accounts()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE branch_name VARCHAR(50);
  DECLARE account_type VARCHAR(50);
  
  -- Loop to generate 50,000 account records
  WHILE i <= 50000  DO
    -- Randomly select a branch from the list of branches
    SET branch_name = ELT(FLOOR(1 + (RAND() * 6)), 'Brighton', 'Downtown', 'Mianus', 'Perryridge', 'Redwood', 'RoundHill');
    
    -- Randomly select an account type
    SET account_type = ELT(FLOOR(1 + (RAND() * 2)), 'Savings', 'Checking');
    
    -- Insert account record
    INSERT INTO accounts (account_num, branch_name, balance, account_type)
    VALUES (
      LPAD(i, 5, '0'),                   -- Account number as just digits, padded to 5 digits (e.g., 00001, 00002, ...)
      branch_name,                       -- Randomly selected branch name
      ROUND((RAND() * 100000), 2),       -- Random balance between 0 and 100,000, rounded to 2 decimal places
      account_type                       -- Randomly selected account type (Savings/Checking)
    );

    SET i = i + 1;
  END WHILE;
END$$

-- Reset the delimiter back to the default semicolon
DELIMITER ;

-- drop the primary key if needed
alter table accounts drop primary key;
alter table accounts add primary key(account_num);

--  Use the generate_accounts procedure to populate the table
CALL generate_accounts();

select count(*) from accounts;
-- Display first 10 records
select * from accounts limit 10;

select branch_name, count(*)
from accounts
group by branch_name
order by branch_name;

-- 3. create composite indeces on the branch_name and account_type
CREATE INDEX idx_branch_name_account_type ON accounts(branch_name, account_type);

DROP INDEX idx_branch_name_account_type ON accounts;
-- create index balance
CREATE INDEX idx_balance ON accounts(balance);
DROP INDEX idx_balance ON accounts;
-- 3-1 query performance

-- ponit query for testing composite index branch_name, account_type
SELECT * FROM accounts WHERE branch_name = 'Downtown' AND account_type = 'Savings';

-- range query  for testing composite index branch_name, account_type

SELECT * FROM accounts 
WHERE branch_name = 'Downtown' 
AND account_type IN ('Checking', 'Savings');


-- point query 1 for single index balance

SELECT * FROM accounts WHERE balance = 15000;

-- range query for single index balance
SELECT SYSDATE(6);
SELECT * FROM accounts WHERE balance BETWEEN 10000 AND 20000;
SELECT SYSDATE(6);




--  4. compare point queries and range queries
-- create composite indeces on the branch_name and balance
CREATE INDEX idx_branch_name_balance ON accounts(branch_name, balance);

-- point query example 1:
SELECT count(*) FROM accounts  WHERE branch_name = 'Downtown' AND balance = 50000;

-- range query example 2:
SELECT count(*) FROM accounts  WHERE branch_name = 'Downtown' AND balance BETWEEN 10000 AND 5000;



-- creating an index on account_type and account_balance
   CREATE INDEX idx_account_type_balance ON accounts(account_type, balance);
   DROP INDEX idx_account_type_balance ON accounts;
   
   -- creating an index on branch name and balance
   CREATE INDEX idx_branch_balance ON accounts (branch_name, balance);
   DROP INDEX idx_branch_balance ON accounts;
   
   -- creating an index on branch name and acount type
   CREATE INDEX idx_branch_type ON accounts (branch_name, account_type);
   DROP INDEX idx_branch_type ON accounts;

DELIMITER $$
 DROP procedure if EXISTS calculate_avg_exec_time;
CREATE PROCEDURE calculate_avg_exec_time(query_string TEXT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE start_time DATETIME(6);
    DECLARE end_time DATETIME(6);
    DECLARE total_time BIGINT DEFAULT 0;
    DECLARE exec_time BIGINT;
    DECLARE avg_time BIGINT;
    DECLARE stmt_var TEXT;

    -- Loop to execute the query 10 times
    WHILE i <= 10 DO
        -- Capture the start time
        SET start_time = NOW(6);

        -- Check if the query string is not empty
        IF query_string IS NOT NULL AND query_string != '' THEN
            -- Assign the query string to stmt_var
            SET @stmt_var = query_string;

            -- Prepare the statement dynamically
            PREPARE stmt FROM @stmt_var;  -- Using 'stmt_var' to prepare the query
            
            -- Execute the prepared statement
            EXECUTE stmt;
            
            -- Deallocate the prepared statement after execution
            DEALLOCATE PREPARE stmt;
        ELSE
            -- If the query string is null or empty, raise an error
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Query string is null';
        END IF;

        -- Capture the end time
        SET end_time = NOW(6);

        -- Calculate the time difference in microseconds
        SET exec_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time);

        -- Accumulate the total execution time
        SET total_time = total_time + exec_time;

        -- Increment the counter
        SET i = i + 1;
    END WHILE;

    -- Calculate the average execution time
    SET avg_time = total_time / 10;

    -- Return the average execution time
    SELECT avg_time AS non_indexed_point_query_2_time; -- 100,000 records
END$$

DELIMITER ;


-- point query 1
call calculate_avg_exec_time('select * from accounts where branch_name = ''Mianus'' and account_type = ''Savings''');

-- point query 2
call calculate_avg_exec_time('SELECT count(*) FROM accounts  WHERE branch_name = ''RoundHill'' AND balance BETWEEN 1000 AND 50000');

-- range query 1
call calculate_avg_exec_time('select count(*) from accounts where account_type = ''Savings'' and balance > 30000');

-- range query 2
call calculate_avg_exec_time('SELECT * FROM accounts WHERE account_type = ''savings''AND balance BETWEEN 5000 AND 20000');

-- -- Timing analysis
set @start_time = now(6);

select count(*) 
from accounts
where account_type = 'savings' and balance > 20000; 

SET @end_time = NOW(6);
SELECT 
TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) AS execution_time_microseconds,
TIMESTAMPDIFF(SECOND, @start_time, @end_time) AS execution_time_seconds;








