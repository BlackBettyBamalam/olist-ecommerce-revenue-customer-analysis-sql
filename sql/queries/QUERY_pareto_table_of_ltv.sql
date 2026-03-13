-- Pareto table of LTV in 1/10 groups 
-- (how much of revenue is top 10% of spenders responsible for?)
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
        NTILE(10) OVER (
            ORDER BY ltv DESC
        ) AS decile
    FROM ltv
)
SELECT decile AS percentile,
    CONCAT(
        ROUND(SUM(ltv) / SUM(SUM(ltv)) OVER () * 100, 2),
        '%'
    ) AS percent_of_total_revenue,
    SUM(ltv) AS revenue_per_percentile,
    SUM(SUM(ltv)) OVER () AS total_revenue
FROM ranked
GROUP BY decile
ORDER BY decile ASC;