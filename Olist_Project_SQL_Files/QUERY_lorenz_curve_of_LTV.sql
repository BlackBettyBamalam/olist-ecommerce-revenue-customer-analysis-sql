-- Lorenz curve of customer LTV 
WITH ltv AS (
    SELECT cus.customer_unique_id AS unique_customer,
        SUM(pay.payment_value) AS ltv
    FROM olist_customers_dataset AS cus
        INNER JOIN olist_orders_dataset AS ord ON ord.customer_id = cus.customer_id
        INNER JOIN olist_order_payments_dataset AS pay ON pay.order_id = ord.order_id
    WHERE ord.order_status = 'delivered'
    GROUP BY cus.customer_unique_id
    ORDER BY ltv ASC
),
ranked AS (
    SELECT unique_customer,
        ltv,
        ROW_NUMBER() OVER (
            ORDER BY ltv
        ) AS customer_rank,
        COUNT(*) OVER () AS total_customers,
        SUM(ltv) OVER () AS total_revenue,
        SUM(ltv) OVER (
            ORDER BY ltv
        ) AS cumulative_revenue
    FROM ltv
)
SELECT customer_rank::numeric / total_customers AS cumulative_customer_pct,
    cumulative_revenue / total_revenue AS cumulative_revenue_pct
FROM ranked
ORDER BY customer_rank;