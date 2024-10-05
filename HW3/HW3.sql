/*Title: DB Assignment 3
Your Name: Deare
Date: 2024/10/2
*/

-- *********************************************************************************
-- 1. List names and sellers of products that are no longer available (quantity=0)
-- *********************************************************************************
/*Explanation of each of SQL include what the query does and how it solves the problem:
Retrieves the names of products and merchants, labeling them as products_name and sellers_name in the output. This clarifies what each column represents in the results.
Specifies the primary table (products) from which to start gathering data. The alias p simplifies referencing the table in other parts of the query.
Performs an inner join between products (p) and sell (s) based on the product ID (pid). This ensures that only products that are linked to a sale are considered.
Connects the sell records (s) with their corresponding merchants (m) using the merchant ID (mid). This join retrieves the merchant details for each sale.
Filters the results to show only those products whose quantity_available is zero, effectively showing products that are out of stock.
*/

select p.name as products_name, m.name as sellers_name -- show the rows one with products name as products_name, one with merchants name as sellers_name
from products p -- from products table
join sell s on p.pid=s.pid
join merchants m on s.mid=m.mid
where s.quantity_available=0;

-- *********************************************************************************
-- 2. List names and descriptions of products that are not sold.
-- *********************************************************************************
/*
Explanation of each of SQL include what the query does and how it solves the problem:
Retrieves the names and descriptions of products. It labels them as products_name and products_description in the output, clearly identifying the contents of each column for easy understanding.
Specifies the primary table, products, from which to retrieve data. The alias p is used to simplify references to this table in other parts of the query.
Performs a left join between products (p) and sell (s). This join type ensures all products are shown, including those without matching records in sell. The join is based on the product ID (pid), ensuring that products are attempted to be matched with sales records.
Filters the results to include only those records where there is no corresponding entry in the sell table, as indicated by s.pid being NULL. This condition effectively selects products that have not been sold.
*/

select p.name as products_name, p.description as products_descriptions
from products p
left join sell s on p.pid=s.pid
where s.pid is null;

-- *********************************************************************************
-- 3. How many customers bought SATA drives but not any routers?
-- *********************************************************************************
/*
Explanation of each of SQL include what the query does and how it solves the problem:
This command selects and counts the distinct customer IDs (cid) from the place table. The result is aliased as NumberOfCustomers, providing the total number of unique customers who match the conditions specified in the query.
Specifies the place table as the starting point for the join operations. The table is aliased as p to simplify references to it in the rest of the query.
Joins the place table (p) with the contain table (c). The join is made on the oid column, linking orders in place with their corresponding entries in contain, which details what products are included in each order.
Further joins the contain table (c) to the products table (pr). This join is based on the pid column, connecting the products listed in contain to their detailed descriptions in products.
Adds a condition to filter the products based on their descriptions. Only products whose description contains 'SATA' are considered for the aggregation. This targets only those entries relevant to products associated with SATA technology.
Further refines the selection by excluding any products whose names include the word 'Router'. This ensures that the count excludes customers who have purchased any routers, focusing on a specific subset of products.
*/

SELECT COUNT(DISTINCT p.cid) AS NumberOfCustomers
FROM place p
JOIN contain c ON p.oid = c.oid
JOIN products pr ON c.pid = pr.pid
WHERE pr.description LIKE '%SATA%' -- Adjusted to search description for SATA
AND pr.name NOT LIKE '%Router%';

-- *********************************************************************************
-- 4. HP has a 20% sale on all its Networking products.
-- *********************************************************************************
/*
Explanation of each of SQL include what the query does and how it solves the problem:
Retrieves the merchant's name from the merchant table and renames it as merchants_name for the output.
Selects the product ID from the products table.
Selects the product name from the products table.
Selects the product category from the products table.
Selects the product description from the products table.
Retrieves the current price from the sell table and renames it as current_price for the output.
Calculates 80% of the current price to derive the discounted price, displayed as DiscountedPrice.
Specifies the products table as the source of product data, and aliases it as p for reference in the query.
Joins the products table with the sell table based on the matching product ID (pid).
Joins the sell table with the merchants table based on the matching merchant ID (mid).
Filters the results to include only those products that belong to the 'Networking' category.
Further filters the results to include only products sold by merchants named 'HP'.
*/
SELECT m.name as merchants_name,p.pid, p.name, p.category ,p.description, s.price as current_price, 
s.price * 0.80 AS DiscountedPrice
FROM products p
JOIN sell s ON p.pid = s.pid
join merchants m on s.mid=m.mid
WHERE p.category = 'Networking'
and m.name = 'HP';


-- *********************************************************************************
-- 5. What did Uriel Whitney order from Acer? (make sure to at least retrieve product names and prices).
-- *********************************************************************************
/*
Explanation of each of SQL include what the query does and how it solves the problem:
Retrieves the name of the product from the products table and aliases it as product_name in the output.
Selects the price of the product from the sell table.
Retrieves the name of the merchant from the merchants table and aliases it as merchant_name in the output.
Retrieves the full name of the customer from the customers table and aliases it as customer_name in the output.
Specifies the customers table as the source of customer data, with an alias c for use in the query.
Joins the customers table to the place table, linking customers to their orders via the place table using the customer ID (cid).
Joins the place table to the orders table, linking the place records to specific orders using the order ID (oid).
Joins the orders table to the contain table, linking orders to the products included in those orders using the order ID (oid).
Joins the contain table to the products table, linking the products contained in orders to their details in the products table using the product ID (pid).
Joins the products table to the sell table, linking the products to their pricing information using the product ID (pid).
Joins the sell table to the merchants table, linking the sales records to the merchants using the merchant ID (mid).
Filters the results to include only records associated with the customer named "Uriel Whitney".
Further filters the results to include only those transactions involving the merchant named "Acer".
*/
SELECT p.name AS product_name, 
       s.price AS price,
       m.name as merchant_name,
       c.fullname as customer_name
FROM customers c
JOIN place pl ON c.cid = pl.cid  -- Link customers to orders via place table
JOIN orders o ON pl.oid = o.oid  -- Link place records to orders
JOIN contain co ON o.oid = co.oid  -- Link orders to products
JOIN products p ON co.pid = p.pid  -- Link contain records to products
JOIN sell s ON p.pid = s.pid  -- Get pricing information from sell table
JOIN merchants m ON s.mid = m.mid  -- Link sell records to merchants
WHERE c.fullname = 'Uriel Whitney'  -- Filter for Uriel Whitney
AND m.name = 'Acer';  -- Filter for Acer as the merchant

-- *********************************************************************************
-- 6. List the annual total sales for each company (sort the results along the company and the year attributes).
-- *********************************************************************************
/*
Explanation of each of SQL include what the query does and how it solves the problem:
Begins the query and specifies the columns to be displayed in the result set.
Retrieves the name of the company from the merchants table and aliases it as Company in the output.
Extracts the year part from the order_date column of the place table and aliases it as Year.
Calculates the total sales by multiplying the price by the quantity available from the sell table, then summing up these values for each group.
Specifies the merchants table as the starting point of the join sequence, with an alias m for use in the query.
Joins the merchants table to the sell table, linking records based on the merchant ID (mid).
Joins the sell table to the products table, linking products to their sales information using the product ID (pid).
Joins the products table to the contain table, linking products to orders they are contained in.
Joins the contain table to the orders table, establishing a connection between product containers and their respective orders.
Joins the orders table to the place table, completing the link from the original order placement to the actual order details.
Groups the results by company name and year, for aggregate calculations.
Orders the result set by company name and year, for orderly presentation.
*/

select 
m.name AS Company, 
EXTRACT(YEAR FROM pl.order_date) AS Year, 
SUM(s.price * s.quantity_available) AS TotalSales
from merchants m
JOIN sell s ON m.mid = s.mid
join products p on s.pid = p.pid
join contain co on p.pid = co.pid
join orders o on co.oid = o.oid
join place pl on o.oid= pl.oid
GROUP BY m.name, EXTRACT(YEAR FROM pl.order_date)
ORDER BY m.name, EXTRACT(YEAR FROM pl.order_date);


-- *********************************************************************************
-- 7. Which company had the highest annual revenue and in what year?
-- *********************************************************************************
/*
Explanation of each of SQL include what the query does and how it solves the problem:
Specifies the columns to be displayed in the query results.
Displays the merchant's name as "Company".
Extracts the year from the order date and labels it as "Year".
Calculates the total sales by multiplying the price by the quantity available and labels it as "TotalSales".
Identifies the table merchants and uses alias m for referencing in the query.
Joins the sell table to merchants based on the merchant ID (mid).
Joins the products table to sell based on the product ID (pid).
Joins the contain table to products based on the product ID (pid).
Joins the orders table to contain based on the order ID (oid).
Joins the place table to orders based on the order ID (oid).
Groups the results by company name and the year of the order date.
Orders the results by the TotalSales in descending order.
Restricts the output to just one row, showing the company with the highest total sales for any year.
*/
select 
m.name AS Company, 
EXTRACT(YEAR FROM pl.order_date) AS Year, 
SUM(s.price * s.quantity_available) AS TotalSales
from merchants m
JOIN sell s ON m.mid = s.mid
join products p on s.pid = p.pid
join contain co on p.pid = co.pid
join orders o on co.oid = o.oid
join place pl on o.oid= pl.oid
GROUP BY m.name, EXTRACT(YEAR FROM pl.order_date)
ORDER BY TotalSales desc
LIMIT 1;

-- *********************************************************************************
-- 8. On average, what was the cheapest shipping method used ever?
-- *********************************************************************************
/*Explanation of each of SQL include what the query does and how it solves the problem:
Specifies the columns to be displayed in the query results.
Selects unique merchant names, labeled as "MerchantName".
Specifies the product category to be included in the results.
Calculates the total sales by multiplying the price by the quantity available, labeled as "TotalSales".
Identifies 'merchants' as the source table, aliased as 'm'.
Joins the 'sell' table to 'merchants' on matching merchant IDs.
Joins the 'products' table to 'sell' on matching product IDs.
Groups the results by merchant name and product category.
Orders the results first by product category in descending order, then by total sales also in descending order.
Limits the output to the top 5 results based on the specified order.
*/
SELECT 
  shipping_method,
  AVG(shipping_cost) AS AverageShippingCost
FROM orders
GROUP BY shipping_method
ORDER BY AverageShippingCost ASC
LIMIT 1;

-- *********************************************************************************
-- 9. What is the best sold ($) category for each company?
-- *********************************************************************************

/*
Explanation of each of SQL include what the query does and how it solves the problem:
Lists the columns to be included in the output: merchant name, customer ID, customer name, and total spent.
Uses a subquery to perform calculations, aliased as sub.
Begins selection within the subquery.
In the subquery, selects and renames columns to identify the merchant, customer ID, customer name, and calculate total spent.
Calculates total amount spent by each customer per merchant.
Assigns a rank to each customer based on total spent, partitioned by merchant.
Specifies the tables and joins needed to gather all necessary information.
Groups the results by merchant name, customer ID, and customer name to prepare for the SUM operation.
Filters the subquery results to include only the top-ranked (highest spending) customers per merchant.
Orders the final results by merchant name and the total spent in descending order.
*/
SELECT
    DISTINCT(m.name) AS MerchantName,
    p.category,
    SUM(s.price * s.quantity_available) AS TotalSales
FROM merchants m
JOIN sell s ON m.mid = s.mid
JOIN products p ON s.pid = p.pid
GROUP BY m.name, p.category
ORDER BY p.category desc,TotalSales desc
limit 5;

-- *********************************************************************************
-- 10. 	For each company find out which customers have spent the most and the least amounts.
-- *********************************************************************************
-- 10-1: Customers who have spent most amount of money on each company
SELECT MerchantName, cosid, costumerName, TotalSpent -- Lists the columns to be included in the output: merchant name, customer ID, customer name, and total spent.
FROM ( -- Uses a subquery to perform calculations, aliased as sub.
    SELECT -- In the subquery, selects and renames columns to identify the merchant, customer ID, customer name, and calculate total spent.
        m.name AS MerchantName, 
        c.cid AS cosid, 
        c.fullname AS costumerName, 
        SUM(s.price) AS TotalSpent,
        RANK() OVER (PARTITION BY m.name ORDER BY SUM(s.price) DESC) AS ranking-- Calculates total amount spent by each customer per merchant.
    FROM customers c
    JOIN place pl ON c.cid = pl.cid -- Specifies the tables and joins needed to gather all necessary information.
    JOIN orders o ON pl.oid = o.oid
    JOIN contain co ON o.oid = co.oid
    JOIN products p ON co.pid = p.pid
    JOIN sell s ON p.pid = s.pid
    JOIN merchants m ON s.mid = m.mid
    GROUP BY m.name, c.cid, c.fullname -- Groups the results by merchant name, customer ID, and customer name to prepare for the SUM operation.
) sub
WHERE ranking = 1 -- Filters the subquery results to include only the top-ranked (highest spending) customers per merchant.
ORDER BY MerchantName, TotalSpent DESC;
-- *********************************************************
-- 10-2: customers who has spent least amount of money on each company
-- Similar to the find costomer who has spent most money on each companythe only diffrence is Totalspent in ascending order.

-- Main SELECT statement: Retrieves the desired columns from a subquery
SELECT MerchantName, cosid, costumerName, TotalSpent
FROM (
    -- Start of subquery to calculate total spent and rank customers per merchant
    SELECT 
        m.name AS MerchantName, -- The merchant's name
        c.cid AS cosid, -- The customer's ID
        c.fullname AS costumerName, -- The customer's full name
        SUM(s.price) AS TotalSpent, -- The total amount spent by the customer at the merchant
        RANK() OVER (PARTITION BY m.name ORDER BY SUM(s.price) ASC) AS ranking -- Rank customers by total spent ascendingly per merchant
    FROM customers c -- From customers table
    JOIN place pl ON c.cid = pl.cid -- Join 'place' table to link customers to orders
    JOIN orders o ON pl.oid = o.oid -- Join 'orders' table to fetch order details
    JOIN contain co ON o.oid = co.oid -- Join 'contain' table to relate orders to products
    JOIN products p ON co.pid = p.pid -- Join 'products' table to access product details
    JOIN sell s ON p.pid = s.pid -- Join 'sell' table to get pricing information
    JOIN merchants m ON s.mid = m.mid -- Join 'merchants' table to link sales to specific merchants
    GROUP BY m.name, c.cid, c.fullname -- Group results by merchant name and customer details
) sub -- Alias for the subquery
WHERE ranking = 1 -- Filter to include only the top-ranked customers (those who spent the least)
ORDER BY MerchantName, TotalSpent ASC; -- Order the results by merchant name and total spent
