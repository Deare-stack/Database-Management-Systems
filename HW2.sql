-- Title: DB Assignment 2
-- Your Name: Deare
-- Date: 2024/9/19
-- *********************************************************************************
-- PART 1
-- *********************************************************************************
CREATE database Assignmen2;-- Create new database for homework 2 named Assignment2
USE Assignmen2; -- Move into database
-- *********************************************************************************
-- How did I import csv file
-- 1. created CSV files using text editor
-- 2. Entered the data, separating fields with commas (,). 
		-- For example
		-- chefID,name,specialty
		-- 1,John Doe,Italian
-- 3. Saved the file with the .csv extension
-- 4. found my database in Navigator right click and choose 'table data import Wizard' to import my CSV file and right click 'refresh all'.
-- *********************************************************************************
SHOW TABLES;-- show all the table names that I imported in database in assignment 2

-- *********************************************************************************
-- Due to when I import wizard as chefs.csv file did not mention to add PK
-- Therefore I alter the chefs table add primary key chefID and indicate pimary key chefID CAN NOT be NULL.
-- Even though, I know primary key in defult can not be null but I insist to indicate my PK chefID can not be NULL.
-- ALTER TABLE chefs: modify the table chef
-- MODIFY chefID INT NOT NULL: ensures that the chefID column(attribute) is NOT NULL, meaning it cannot contain null values.
-- ADD PRIMARY KEY (chefID): adds the chefID attribute as the primary key for the chefs table.
-- *********************************************************************************

ALTER TABLE chefs
MODIFY chefID INT NOT NULL,
ADD PRIMARY KEY (chefID);


-- *******************************************************************
-- Same reason as chefs entity, as given Rlation model the entity restaurants needs to add PK as restID
-- ALTER TABLE chefs: modify the table restaurants
-- MODIFY restID INT NOT NULL: ensures that the restID column(attribute) is NOT NULL, meaning it cannot contain null values.
-- ADD PRIMARY KEY (restID): adds the restID attribute as the primary key for the restaurants table.
-- *******************************************************************
ALTER TABLE restaurants
MODIFY restID INT NOT NULL,
ADD PRIMARY KEY (restID);

-- *******************************************************************
-- Same reason as above, as given Rlation model the entity foods needs to add PK as foodID
-- ALTER TABLE foods: modify the table foods
-- MODIFY foodID INT NOT NULL: ensures that the foodID column(attribute) is NOT NULL, meaning it cannot contain null values.
-- ADD PRIMARY KEY (foodID): adds the foodID attribute as the primary key for the foods table.
-- *******************************************************************
ALTER TABLE foods
MODIFY foodID INT NOT NULL,
ADD PRIMARY KEY (foodID);
-- *********************************************************************************
-- ADD Foreign Key chefID in works Table: chefID in works references chefID in the chefs table
-- ADD Foreign Key restID in works Table: restID in works references restID in the restaurants table
-- *********************************************************************************
ALTER TABLE works
ADD FOREIGN KEY (chefID) REFERENCES chefs(chefID),
ADD FOREIGN KEY (restID) REFERENCES restaurants(restID);
-- *********************************************************************************
-- ADD Foreign Key restID in serves Table: restID in serves references restID in the restaurants table
-- ADD Foreign Key foodID in serves Table: foodID in serves references foodID in the foods table
-- *********************************************************************************
ALTER TABLE serves
ADD FOREIGN KEY (restID) REFERENCES restaurants(restID),
ADD FOREIGN KEY (foodID) REFERENCES foods(foodID);

-- *********************************************************************************
-- Show the schema of chefs, restaurants, works, foods, serves
-- To double check their PK and FK
-- *********************************************************************************

desc chefs;
desc restaurants;
desc works;
desc foods;
desc serves;

-- *********************************************************************************
-- Show the table with it attribute and its value that I using MySQL Workbench's Import Wizard which are 
-- chefs.csv
-- restaurants.csv
-- works.csv
-- foods.csv
-- serves.csv
-- Because I want to check all the table with its values.
-- *********************************************************************************

SELECT * FROM chefs; 
SELECT* FROM foods;
SELECT * FROM restaurants;
SELECT* FROM serves;
SELECT* FROM works;
-- *********************************************************************************
-- PART 2
-- *********************************************************************************
-- Q1:Average Price of Foods at Each Restaurant
-- Means Calculate average price of foods served in each restaurant
-- I am using inner join to combine 3 table which are restaurants r, serves s , foods f
-- restaurants r:  r is the alias for the restaurants table.
-- serves s: serves s refers to the serves table.
-- foods f: refers to the foods table.
-- AVG(f.price) a aggrigate that can get the average price of all the foods assign all this value as Average_Price
-- r.name The name column from the restaurants table
-- JOIN foods f ON s.foodID = f.foodID: ensures that the query retrieves only the rows where the foodID in the serves table matches the foodID in the foods table.
-- JOIN serves s ON r.restID = s.restID:ensures that the query retrieves only the rows where the restID in the restaurants table matches the restID in the serves table.
-- GROUP BY r.restID, r.name: group 2 row with each restaurant’s restID and name
SELECT r.name as restaurant_name, AVG(f.price) AS Average_Price
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.restID, r.name;

-- *********************************************************************************
-- Q2:Maximum Food Price at Each Restaurant
-- Means find the maximum food price at each restaurant.
-- join the restaurants, serves, and foods tables to associate restaurants with the food they serve.
-- MAX(f.price): aggrigation function calculates the highest (maximum) price of the foods served at each restaurant.
-- JOIN serves s ON r.restID = s.restID: joins the restaurants table (r) with the serves table (s) to match the restID (restaurant ID) in both tables.
-- JOIN foods f ON s.foodID = f.foodID: joins the serves table (s) with the foods table (f) to match the foodID in both tables, allows retrieve the food price.
-- groups the results by restaurant ID and restaurant name, so the query calculates the maximum price of food served at each restaurant.
-- *********************************************************************************
SELECT r.name AS restaurant_name, MAX(f.price) AS maximum_price
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.restID, r.name;

-- *********************************************************************************
-- Q3:Count of Different Food Types Served at Each Restaurant
-- Means Count how many distinct food types are served at each restaurant.
-- join the restaurants, serves, and foods tables to associate restaurants with the food they serve.
-- COUNT(DISTINCT f.type): This arrigation function counts the number of distinct (unique) food types served at each restaurant. The DISTINCT keyword ensures that only count each food type once per restaurant.
-- group by the restaurant so the count of unique food types is calculated for each restaurant.
-- *********************************************************************************
SELECT r.name AS restaurant_name, COUNT(DISTINCT f.type) AS Number_OF_Different_Food_Types
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.restID, r.name;

-- *********************************************************************************
-- Q4: Average Price of Foods Served by Each Chef
-- Calculate the average price of foods served at the restaurant where each chef works.
-- c.name: This selects the name of the chef from the chefs table (aliased as c).
-- AVG(f.price): This calculates the average price of the food aliases output as average_food_price
-- JOIN works w ON c.chefID = w.chefID: This joins the chefs table (c) with the works table (w). The condition c.chefID = w.chefID ensures that only the chefs who are listed in the works table are included in the result.
-- JOIN restaurants r ON w.restID = r.restID: This joins the works table (w) with the restaurants table (r), linking each chef to the restaurants where they work.
-- JOIN serves s ON r.restID = s.restID:This joins the restaurants table (r) with the serves table (s), which records which food items are served at which restaurants. 
-- JOIN foods f ON s.foodID = f.foodID: This joins the serves table (s) with the foods table (f) using the foodID so that access the price of each food item served at the restaurant where the chef works.
-- GROUP BY clause groups the results by each chef's chefID and name, ensuring that the average food price is calculated per chef.
-- *********************************************************************************

SELECT c.name AS chef_name, AVG(f.price) AS average_food_price
FROM chefs c
JOIN works w ON c.chefID = w.chefID
JOIN restaurants r ON w.restID = r.restID
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY c.chefID, c.name;

-- *********************************************************************************
-- Q5:Find the Restaurant with the Highest Average Food Price
-- r.name reffers to restaurant table name column aliases output as restaurant_name
-- AVG(f.price) This calculates the average price of the food aliases output as average_food_price
-- JOIN serves s ON r.restID = s.restID: Joins the restaurants table (r) with the serves table (s) based on restID.
-- JOIN foods f ON s.foodID = f.foodID:Joins the serves table with the foods table (f) based on foodID, to get food price information
-- GROUP BY r.restID, r.name: Groups the results by restaurant ID and restaurant name.
-- ORDER BY average_food_price DESC: Sorts the results in descending order of the average food price, so the restaurant with the highest average food price appears at the top.
-- LIMIT 1: limits the result to only one row, which will be the restaurant with the highest average food price.
-- *********************************************************************************
SELECT r.name AS restaurant_name, AVG(f.price) AS average_food_price
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.restID, r.name
ORDER BY average_food_price DESC
LIMIT 1;

-- *********************************************************************************
-- Extra Credit:  Determine which chef has the highest average price of the foods served at the restaurants where they work. 
-- Include the chef’s name, the average food price, and the names of the restaurants where the chef works. Sort the  results by the average food price in descending order.
-- c.name AS chef_name: Retrieves the name of the chef.
-- AVG(f.price) AS average_food_price: calculate the average price of foods same as I mentioned as above
-- GROUP_CONCAT(DISTINCT r.name): Concatenates the distinct restaurant names for each chef into a single string then alias as restaurant_names
-- JOIN works table(w) with chef table(c),join the restaurants table(r) with work table (w), join the serves table (s) with restaruant table(r),join food table (f) with serves table(s)
-- GROUP BY c.chefID, c.name:Ensures that the data is grouped by chef, so each chef's name appears once per entry in the output
-- ORDER BY average_food_price DESC:Sorts the results by the average food price in descending order. This ensures that the chef with the highest average food price appears at the top of the list.
-- *********************************************************************************

SELECT c.name AS chef_name, AVG(f.price) AS average_food_price, GROUP_CONCAT(DISTINCT r.name) AS restaurant_names
FROM chefs c
JOIN works w ON c.chefID = w.chefID
JOIN restaurants r ON w.restID = r.restID
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY c.chefID, c.name
ORDER BY average_food_price DESC;