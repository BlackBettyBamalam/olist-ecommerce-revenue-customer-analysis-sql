-- Total number of customers who purchase more than once (and % of total customers)
SELECT CONCAT(
        ROUND(
            (
                (
                    COUNT(cus.customer_id)::numeric - COUNT(DISTINCT cus.customer_unique_id)::numeric
                ) / COUNT(cus.customer_id)::numeric * 100
            ),
            2
        ),
        '%'
    ) AS return_customers_pct,
    COUNT(cus.customer_id) AS total_customers,
    COUNT(cus.customer_id) - COUNT(DISTINCT cus.customer_unique_id) AS return_customers
FROM olist_customers_dataset AS cus
    JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
    AND ord.order_status = 'delivered';