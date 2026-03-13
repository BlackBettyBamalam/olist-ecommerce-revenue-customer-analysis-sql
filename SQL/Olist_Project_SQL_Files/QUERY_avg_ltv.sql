-- Average customer lifetime value (LTV)
WITH ltv AS (
    SELECT cus.customer_unique_id,
        SUM(pay.payment_value) AS revenue_per_customer
    FROM olist_customers_dataset AS cus
        INNER JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
        INNER JOIN olist_order_payments_dataset AS pay ON pay.order_id = ord.order_id
    WHERE ord.order_status = 'delivered'
    GROUP BY cus.customer_unique_id
    ORDER BY revenue_per_customer DESC
)
SELECT ROUND(AVG(revenue_per_customer), 2) AS avg_ltv
FROM ltv;