/*
===============================================================================
DDL Script: Create Bronze Tables (PostgreSQL)
===============================================================================
*/

-- Create Bronze Schema
CREATE SCHEMA IF NOT EXISTS bronze;

-- Drop existing table
DROP TABLE IF EXISTS bronze.food;

-- Create Food Table
CREATE TABLE bronze.food (
    id_key          INT,
    f_id            VARCHAR(50),
    item            VARCHAR(50),
    veg_or_non_veg  VARCHAR(50)
);

-- dropping existing table  

DROP TABLE IF EXISTS bronze.menu;

CREATE TABLE bronze.menu(
		id_key   INT,
		menu_id  VARCHAR(50),
		r_id     VARCHAR(50),
		cuisine  VARCHAR(50),
		price  	 FLOAT
		
);

-- dropping existing table  
--table order_items
DROP TABLE IF EXISTS bronze.order_items;

CREATE TABLE bronze.order_items(
		order_item   INT,
		order_id     INT,

		r_id  VARCHAR(50),
		f_id     VARCHAR(50),
		price  		INT,
		quantity  	 INT,
		line_amount	INT
		
);


--table orders
DROP TABLE IF EXISTS bronze.orders;

CREATE TABLE bronze.orders(
		order_item   INT,
		order_id     INT,

		r_id  VARCHAR(50),
		f_id     VARCHAR(50),
		price  		INT,
		quantity  	 INT,
		line_amount	INT
		
);



/*
===============================================================================
DDL Script: Create Bronze Orders Table (PostgreSQL)
===============================================================================
*/

-- Create Bronze Schema
CREATE SCHEMA IF NOT EXISTS bronze;

-- Drop table if it exists
DROP TABLE IF EXISTS bronze.orders;

-- Create Orders Table
CREATE TABLE bronze.orders (
    order_id           INT,
    order_timestamp    TIMESTAMP,
    order_date         DATE,
    user_id            INT,
    r_id               VARCHAR(50),
    restaurant_city    VARCHAR(150),
    cuisine            VARCHAR(150),
    items_count        INT,
    sales_qty          INT,
    subtotal           NUMERIC(10,2),
    discount           NUMERIC(10,2),
    delivery_fee       NUMERIC(10,2),
    gst                NUMERIC(10,2),
    sales_amount       NUMERIC(10,2),
    currency           VARCHAR(10),
    payment_method     VARCHAR(50),
    order_status       VARCHAR(50),
    customer_rating    INT,
    delivery_time_min  INT
);


/*
===============================================================================
DDL Script: Create Bronze Restaurants Table (PostgreSQL)
===============================================================================
Script Purpose:
    Create the restaurants table in the Bronze layer.
    Preserve raw source data without transformations.
===============================================================================
*/

-- Create Bronze Schema
CREATE SCHEMA IF NOT EXISTS bronze;

-- Drop existing table
DROP TABLE IF EXISTS bronze.restaurant;

-- Create Restaurants Table
CREATE TABLE bronze.restaurant (
	key_id			INT,
    id              INT,
    name            VARCHAR(255),
    city            VARCHAR(150),
    rating          VARCHAR(50),
    rating_count    VARCHAR(100),
    cost            VARCHAR(50),
    cuisine         VARCHAR(255),
    lic_no          VARCHAR(50),
    link            TEXT,
    address         TEXT,
    menu            VARCHAR(255)
);




/*

Script Purpose:
    Create the reviews table in the Bronze layer.
    Preserve raw customer review data without transformations.
===============================================================================
*/


-- Drop existing table
DROP TABLE IF EXISTS bronze.reviews;

-- Create Reviews Table
CREATE TABLE bronze.reviews (
    review_id       INT,
    order_id        INT,
    user_id         INT,
    restaurant_id   INT,
    rating          INT,
    comment         TEXT,
    review_date     DATE
);






/*

===============================================================================
Script Purpose:
    Create the users table in the Bronze layer.
    Preserve raw source data without transformations.
===============================================================================
*/

-- Drop existing table
DROP TABLE IF EXISTS bronze.users;

-- Create Users Table
CREATE TABLE bronze.users (
    user_id                     INT,
    name                        VARCHAR(150),
    email                       VARCHAR(255),
    password                    VARCHAR(255),
    age                         INT,
    gender                      VARCHAR(50),
    marital_status              VARCHAR(50),
    occupation                  VARCHAR(100),
    monthly_income              VARCHAR(100),
    educational_qualifications  VARCHAR(100),
    family_size                 INT
);





