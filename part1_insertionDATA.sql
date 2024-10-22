/* Title: DB Assignment 4
Your Name: Deare
Date: 2024-10-19
*/

/*
CREATE DATABASE Assignment4;

use Assignment4;

-- film table release_year YEARactoractoractoraddress
-- Add UNIQUE key , primary key and foreign key for each table

Alter table actor
add primary key (actor_id);

alter table country
add primary key(country_id);

alter table category
-- add primary key (category_id),
ADD CONSTRAINT CHK_Category_Name CHECK (name IN ('Animation', 'Comedy', 'Family', 'Foreign', 'Sci-Fi', 
'Travel', 'Children', 'Drama', 'Horror', 'Action', 'Classics', 'Games', 'New', 
'Documentary', 'Sports', 'Music'));

alter table language
add primary key (language_id);

alter table city
add primary key (city_id),
add foreign key (country_id) references country(country_id);

alter table address
add primary key (address_id),
add foreign key (city_id) references city(city_id);

alter table film
-- MODIFY release_year YEAR,
-- modify language_id int,
-- modify rental_duration int,
-- modify length int,
-- add primary key (film_id),
-- add foreign key (language_id) references language(language_id);
 -- add CONSTRAINT CHK_Special_Features CHECK (special_features IN ('Behind the Scenes', 'Commentaries', 'Deleted Scenes', 'Trailers'));
-- ADD CONSTRAINT CHK_rental_duration CHECK (rental_duration BETWEEN 2 AND 8);
-- ADD CONSTRAINT CHK_rental_rate CHECK (rental_rate BETWEEN 0.99 AND 6.99);
-- ADD CONSTRAINT CHK_Film_Length CHECK (length BETWEEN 30 AND 200);
-- ADD CONSTRAINT CHK_Film_Rating CHECK (rating IN ('PG', 'G', 'NC-17', 'PG-13', 'R'));
ADD CONSTRAINT CHK_Replacement_Cost CHECK (replacement_cost BETWEEN 5.00 AND 100.00);

alter table film_actor
add PRIMARY KEY (actor_id, film_id),
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
add PRIMARY KEY (film_id, category_id),
add FOREIGN KEY (film_id) REFERENCES film(film_id),
add FOREIGN KEY (category_id) REFERENCES category(category_id);

alter table staff
add primary key (staff_id),
add foreign key (address_id) references address(address_id),
add foreign key (store_id) references store(store_id);

alter table customer
-- add primary key (customer_id),
-- add foreign key (store_id) references store(store_id),
-- add foreign key (address_id) references address(address_id);
ADD CONSTRAINT CHK_active CHECK (active IN (0, 1));
*/

-- don't run this now
alter table rental
add primary key (rental_id),
add unique key (rental_date),
add inventory_id INT UNIQUE, 
add customer_id INT UNIQUE,
-- is this separately declared its unique key indicates a one-to-one relationship with inventory and customer table? is this correct to declare separately? or do I need to composite in a unique key?
add FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
add FOREIGN KEY (customer_id) REFERENCES customer(customer_id);

-- don't run this now
alter table payment
add primary key(payment_id),
add foreign key (customer_id) references customer(customer_id),
add foreign key (staff_id) references staff(staff_id),
add foreign key (rental_id) references rental(rental_id),
add CONSTRAINT CHK_Amount_Non_Negative CHECK (amount >= 0);