CREATE TABLE olist_products_dataset (
    product_id VARCHAR(40) PRIMARY KEY,
    product_category_name TEXT,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);
CREATE TABLE olist_customers_dataset (
    customer_id VARCHAR(40) PRIMARY KEY,
    customer_unique_id VARCHAR(40),
    customer_zip_code_prefix VARCHAR(10),
    customer_city TEXT,
    customer_state VARCHAR(5)
);
CREATE TABLE olist_orders_dataset (
    order_id VARCHAR(40) PRIMARY KEY,
    customer_id VARCHAR(40),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date DATE,
    FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id)
);
CREATE TABLE olist_order_payments_dataset (
    order_id VARCHAR(40),
    payment_sequential INTEGER,
    payment_type VARCHAR(40),
    payment_installments INTEGER,
    payment_value NUMERIC,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);
CREATE TABLE olist_order_items_dataset (
    order_id VARCHAR(40),
    order_item_id INTEGER,
    product_id VARCHAR(40),
    seller_id VARCHAR(40),
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id)
);