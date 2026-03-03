-- median customer lifetime value (LTV) by year
WITH median AS (
    SELECT year,
        unique_customer,
        revenue_per_customer,
        ROW_NUMBER() OVER (
            PARTITION BY year
            ORDER BY revenue_per_customer
        ) AS rn,
        COUNT(*) OVER (PARTITION BY year) AS cnt
    FROM (
            SELECT DATE_TRUNC('year', ord.order_purchase_timestamp) AS year,
                cus.customer_unique_id unique_customer,
                SUM(pay.payment_value) AS revenue_per_customer
            FROM olist_customers_dataset AS cus
                INNER JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
                INNER JOIN olist_order_payments_dataset AS pay ON pay.order_id = ord.order_id
            WHERE ord.order_status = 'delivered'
            GROUP BY cus.customer_unique_id,
                year
            ORDER BY revenue_per_customer DESC
        ) AS ltv
)
SELECT year,
    ROUND(AVG(revenue_per_customer), 2) AS avg_ltv
FROM median
WHERE rn IN(
        FLOOR((cnt + 1) / 2),
        FLOOR((cnt + 2) / 2)
    )
GROUP BY year
ORDER BY year