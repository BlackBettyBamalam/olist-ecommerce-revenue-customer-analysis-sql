-- how many return customers per month
SELECT DATE_TRUNC('month', ord.order_purchase_timestamp) AS month,
    COUNT(cus.customer_unique_id) - COUNT(DISTINCT cus.customer_unique_id) AS return_customers
FROM olist_customers_dataset cus
    INNER JOIN olist_orders_dataset ord ON ord.customer_id = cus.customer_id
GROUP BY month
HAVING COUNT(ord.order_purchase_timestamp) > 500