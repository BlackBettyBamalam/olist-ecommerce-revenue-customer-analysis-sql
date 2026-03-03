-- How many new customers are aquired each month
SELECT COUNT(DISTINCT customer_unique_id) AS new_customers,
    DATE_TRUNC('month', ord.order_purchase_timestamp) AS month
FROM olist_customers_dataset AS cus
    INNER JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id --WHERE ord.order_status = 'delivered'
GROUP BY month
HAVING COUNT(DISTINCT customer_unique_id) > 500
ORDER BY month
    /*
     I have 2 queries that do the same thing.
     Probably should pick the shorter one but I need to check
     for explicitness.
     I also need to decide whether to include all
     orders or only delivered orders.
     */