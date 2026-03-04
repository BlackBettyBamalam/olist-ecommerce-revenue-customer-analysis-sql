-- Repeat Purchase Rate +
-- how many return customers per month
SELECT DATE_TRUNC('month', ord.order_purchase_timestamp) AS month,
    COUNT(cus.customer_unique_id) AS total_customers,
    COUNT(cus.customer_unique_id) - COUNT(DISTINCT cus.customer_unique_id) AS return_customers,
    CONCAT(
        ROUND(
            (
                (
                    COUNT(cus.customer_unique_id) - COUNT(DISTINCT cus.customer_unique_id)
                )::numeric
            ) / (COUNT(cus.customer_unique_id))::numeric * 100,
            2
        ),
        '%'
    ) AS repeat_purchase_rate
FROM olist_customers_dataset cus
    INNER JOIN olist_orders_dataset ord ON ord.customer_id = cus.customer_id
GROUP BY month
HAVING COUNT(ord.order_purchase_timestamp) > 500;