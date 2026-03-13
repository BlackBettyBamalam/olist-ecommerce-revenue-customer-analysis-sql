-- Number of customers who return after their first purchase
-- CTE 1: find first purchase of each unique customer
WITH first_purchase AS (
    SELECT cus.customer_unique_id,
        MIN(order_purchase_timestamp) AS first_order_date
    FROM olist_customers_dataset AS cus
        JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
    WHERE ord.order_status = 'delivered'
    GROUP BY cus.customer_unique_id
),
-- CTE 2: set first purchase to 'new' and subsiquent purchases from the same customer to 'returning'
orders_labeled AS (
    SELECT DATE_TRUNC('month', ord.order_purchase_timestamp) AS order_month,
        cus.customer_unique_id,
        fp.first_order_date,
        CASE
            WHEN DATE_TRUNC('month', ord.order_purchase_timestamp) = DATE_TRUNC('month', fp.first_order_date) THEN 'new'
            ELSE 'returning'
        END AS customer_type
    FROM first_purchase AS fp
        JOIN olist_customers_dataset AS cus ON cus.customer_unique_id = fp.customer_unique_id
        JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
    ORDER BY order_month
) -- aggregation query:
SELECT order_month,
    COUNT(DISTINCT customer_unique_id) FILTER (
        WHERE customer_type = 'new'
    ) AS new_customers,
    COUNT(DISTINCT customer_unique_id) FILTER (
        WHERE customer_type = 'returning'
    ) AS returning_customers,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    CONCAT(
        ROUND(
            COUNT(DISTINCT customer_unique_id) FILTER (
                WHERE customer_type = 'returning'
            )::numeric / COUNT(DISTINCT customer_unique_id)::numeric * 100,
            2
        ),
        '%'
    ) AS returning_customer_pct
FROM orders_labeled
GROUP BY order_month
ORDER BY order_month;