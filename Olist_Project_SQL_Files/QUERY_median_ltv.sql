-- median customer lifetime value (LTV) by year
WITH median AS (
    SELECT unique_customer,
        revenue_per_customer,
        ROW_NUMBER() OVER (
            ORDER BY revenue_per_customer
        ) AS rn,
        COUNT(*) OVER () AS cnt
    FROM (
            SELECT cus.customer_unique_id unique_customer,
                SUM(pay.payment_value) AS revenue_per_customer
            FROM olist_customers_dataset AS cus
                INNER JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
                INNER JOIN olist_order_payments_dataset AS pay ON pay.order_id = ord.order_id
            WHERE ord.order_status = 'delivered'
            GROUP BY cus.customer_unique_id
            ORDER BY revenue_per_customer DESC
        ) AS ltv
)
SELECT ROUND(AVG(revenue_per_customer), 2) AS median_ltv
FROM median
WHERE rn IN(
        FLOOR((cnt + 1) / 2),
        FLOOR((cnt + 2) / 2)
    );