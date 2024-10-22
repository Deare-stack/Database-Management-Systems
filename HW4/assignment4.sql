/* Title: DB Assignment 4
Your Name: Deare
Date: 2024-10-19
Part 1: Import tables, alter tables, add values, alter data types and add constraints
*/

-- *******************************************************************
-- This Query tab contains required constraints
-- *******************************************************************
/*
CREATE DATABASE Assignment4;

use Assignment4;

-- Added UNIQUE key , primary key and foreign key for each table

Alter table actor
add primary key (actor_id);

alter table country
add primary key(country_id);

alter table category
-- add primary key (category_id),
ADD CONSTRAINT CHK_Category_Name CHECK (name IN ('Animation', 'Comedy', 'Family', 'Foreign', 'Sci-Fi', 
'Travel', 'Children', 'Drama', 'Horror', 'Action', 'Classics', 'Games', 'New', 
'Documentary', 'Sports', 'Music'));-- Category names come from the set
--  {Animation, Comedy, Family, Foreign, Sci-Fi, Travel, Children, Drama, Horror, Action, Classics, Games, New, Documentary, Sports, Music}

alter table language
add primary key (language_id);

alter table city
add primary key (city_id),
add foreign key (country_id) references country(country_id);

alter table address
add primary key (address_id),
add foreign key (city_id) references city(city_id);

-- *******************************************************************
-- Required contains for film table added constraints as below:

-- A film’s special_features attribute comes from the set {Behind the Scenes, Commentaries, Deleted Scenes, Trailers}
-- All dates must be valid
-- Rental duration is a positive number of days between 2 and 8
-- Rental rate per day is between 0.99 and 6.99
-- Film length is between 30 and 200 minutes
-- Ratings are {PG, G, NC-17, PG-13, R}
-- Replacement cost is between 5.00 and 100.00
-- *******************************************************************
alter table film
MODIFY release_year YEAR,-- change data type to year make sure it valid
modify language_id int,
modify rental_duration int,
modify length int,
add primary key (film_id),
add foreign key (language_id) references language(language_id);
add CONSTRAINT CHK_Special_Features CHECK (special_features IN ('Behind the Scenes', 'Commentaries', 'Deleted Scenes', 'Trailers'));
ADD CONSTRAINT CHK_rental_duration CHECK (rental_duration BETWEEN 2 AND 8);
ADD CONSTRAINT CHK_rental_rate CHECK (rental_rate BETWEEN 0.99 AND 6.99);
ADD CONSTRAINT CHK_Film_Length CHECK (length BETWEEN 30 AND 200);
ADD CONSTRAINT CHK_Film_Rating CHECK (rating IN ('PG', 'G', 'NC-17', 'PG-13', 'R'));
ADD CONSTRAINT CHK_Replacement_Cost CHECK (replacement_cost BETWEEN 5.00 AND 100.00);

alter table film_actor
add PRIMARY KEY (actor_id, film_id),-- Assuming many actor can perform many films.(many to many relationship)
add FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
add FOREIGN KEY (film_id) REFERENCES film(film_id);

alter table store
add primary key (store_id),
add foreign key (address_id) references address(address_id);


alter table inventory
add primary key(inventory_id),
add foreign key(film_id) references film(film_id),
add foreign key(store_id) references store(store_id);


alter table film_category
add PRIMARY KEY (film_id, category_id),-- assuming many films can have many category(many to many relationships)
add FOREIGN KEY (film_id) REFERENCES film(film_id),
add FOREIGN KEY (category_id) REFERENCES category(category_id);

alter table staff
add primary key (staff_id),
add foreign key (address_id) references address(address_id),
add foreign key (store_id) references store(store_id);

alter table customer
add primary key (customer_id),
add foreign key (store_id) references store(store_id),
add foreign key (address_id) references address(address_id);
ADD CONSTRAINT CHK_active CHECK (active IN (0, 1));-- -- Active is from the set {0,1} where 1 means active and 0 inactive
*/

/*
alter table rental
add primary key (rental_id),
add UNIQUE (customer_id, inventory_id),-- assuming multiple rentals by the same customer and multiple rentals of the same inventory item
add FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
add FOREIGN KEY (customer_id) REFERENCES customer(customer_id);
-- Already has duplicate values within the rental_date therefore can not add a unique constraint onto rental_date
-- Also I am assuming a customer might want to rent multiple films at the same time. So rental_date can not be unique as the schem.png picture showed.

alter table payment
add primary key(payment_id),
add foreign key (customer_id) references customer(customer_id),
add foreign key (staff_id) references staff(staff_id),
add foreign key (rental_id) references rental(rental_id),
add CONSTRAINT CHK_Amount_Non_Negative CHECK (amount >= 0);-- add constraint amount should be >= 0
*/

