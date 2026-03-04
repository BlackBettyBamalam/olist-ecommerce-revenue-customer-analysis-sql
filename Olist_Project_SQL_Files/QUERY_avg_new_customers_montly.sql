-- average new customers per month
WITH customers AS (
    SELECT COUNT(DISTINCT customer_unique_id) AS new_customers,
        DATE_TRUNC('month', ord.order_purchase_timestamp) AS month
    FROM olist_customers_dataset AS cus
        INNER JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
    WHERE ord.order_status = 'delivered'
    GROUP BY month
    HAVING COUNT(DISTINCT customer_unique_id) > 500
)
SELECT ROUND(AVG(new_customers), 2) AS avg_new_customers_per_month
FROM customers;