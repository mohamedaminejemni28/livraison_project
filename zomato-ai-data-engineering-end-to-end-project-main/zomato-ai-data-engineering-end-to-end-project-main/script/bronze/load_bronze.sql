
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Zomato Data Warehouse)
===============================================================================
Script Purpose:
    Load data from CSV files into the Bronze Layer.

    Actions:
    - Truncate Bronze tables.
    - Load CSV files using COPY.
    - Display inserted rows.
    - Calculate loading duration.
    - Handle errors.

Usage:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time       TIMESTAMPTZ;
    end_time         TIMESTAMPTZ;
    batch_start_time TIMESTAMPTZ;
    batch_end_time   TIMESTAMPTZ;

    row_count        BIGINT;
    error_message    TEXT;
    error_state      TEXT;

BEGIN

    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Zomato Bronze Layer';
    RAISE NOTICE '================================================';


    -- ========================================================================
    -- Loading Food Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.food';

    TRUNCATE TABLE bronze.food;

    RAISE NOTICE '>> Inserting Data Into: bronze.food';

    COPY bronze.food (
        id_key,
        f_id,
        item,
        veg_or_non_veg
    )
    FROM 'data/food.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- Loading Menu Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.menu';

    TRUNCATE TABLE bronze.menu;

    RAISE NOTICE '>> Inserting Data Into: bronze.menu';

    COPY bronze.menu (
        id_key,
        menu_id,
        r_id,
        cuisine,
        price
    )
    FROM 'zomato-ai-data-engineering-end-to-end-project-main/zomato-ai-data-engineering-end-to-end-project-main/data/menu.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- Loading Order Items Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.order_items';

    TRUNCATE TABLE bronze.order_items;

    RAISE NOTICE '>> Inserting Data Into: bronze.order_items';

    COPY bronze.order_items (
        order_item,
        order_id,
        r_id,
        f_id,
        price,
        quantity,
        line_amount
    )
    FROM 'zomato-ai-data-engineering-end-to-end-project-main/zomato-ai-data-engineering-end-to-end-project-main/data/order_items.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- Loading Orders Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.orders';

    TRUNCATE TABLE bronze.orders;

    RAISE NOTICE '>> Inserting Data Into: bronze.orders';

    COPY bronze.orders (
        order_id,
        order_timestamp,
        order_date,
        user_id,
        r_id,
        restaurant_city,
        cuisine,
        items_count,
        sales_qty,
        subtotal,
        discount,
        delivery_fee,
        gst,
        sales_amount,
        currency,
        payment_method,
        order_status,
        customer_rating,
        delivery_time_min
    )
    FROM 'zomato-ai-data-engineering-end-to-end-project-main/zomato-ai-data-engineering-end-to-end-project-main/data/orders.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- Loading Restaurant Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.restaurant';

    TRUNCATE TABLE bronze.restaurant;

    RAISE NOTICE '>> Inserting Data Into: bronze.restaurant';

    COPY bronze.restaurant (
        key_id,
        id,
        name,
        city,
        rating,
        rating_count,
        cost,
        cuisine,
        lic_no,
        link,
        address,
        menu
    )
    FROM 'zomato-ai-data-engineering-end-to-end-project-main/zomato-ai-data-engineering-end-to-end-project-main/data/restaurant.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- Loading Reviews Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.reviews';

    TRUNCATE TABLE bronze.reviews;

    RAISE NOTICE '>> Inserting Data Into: bronze.reviews';

    COPY bronze.reviews (
        review_id,
        order_id,
        user_id,
        restaurant_id,
        rating,
        comment,
        review_date
    )
    FROM 'zomato-ai-data-engineering-end-to-end-project-main/zomato-ai-data-engineering-end-to-end-project-main/data/reviews.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- Loading Users Table
    -- ========================================================================

    start_time := clock_timestamp();

    RAISE NOTICE '>> Truncating Table: bronze.users';

    TRUNCATE TABLE bronze.users;

    RAISE NOTICE '>> Inserting Data Into: bronze.users';

    COPY bronze.users (
        user_id,
        name,
        email,
        password,
        age,
        gender,
        marital_status,
        occupation,
        monthly_income,
        educational_qualifications,
        family_size
    )
    FROM 'zomato-ai-data-engineering-end-to-end-project-main/zomato-ai-data-engineering-end-to-end-project-main/data/users.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS row_count = ROW_COUNT;

    end_time := clock_timestamp();

    RAISE NOTICE '>> Rows Inserted: %', row_count;
    RAISE NOTICE '>> Load Duration: % seconds',
        EXTRACT(EPOCH FROM (end_time - start_time));

    RAISE NOTICE '>> -------------';


    -- ========================================================================
    -- End of Bronze Layer Loading
    -- ========================================================================

    batch_end_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Zomato Bronze Layer Loading Completed';
    RAISE NOTICE 'Total Load Duration: % seconds',
        EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '================================================';


    -- ========================================================================
    -- Error Handling
    -- ========================================================================

EXCEPTION
    WHEN OTHERS THEN

        GET STACKED DIAGNOSTICS
            error_message = MESSAGE_TEXT,
            error_state = RETURNED_SQLSTATE;

        RAISE NOTICE '================================================';
        RAISE NOTICE 'ERROR OCCURRED DURING BRONZE LOADING';
        RAISE NOTICE 'Error Message: %', error_message;
        RAISE NOTICE 'SQLSTATE: %', error_state;
        RAISE NOTICE '================================================';

        RAISE;

END;
$$;

CALL bronze.load_bronze();
