-- What is the Average Monthly Growth Rate of revenue?
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', ord.order_purchase_timestamp) AS month,
        SUM(pay.payment_value) AS revenue
    FROM olist_orders_dataset AS ord
        INNER JOIN olist_order_payments_dataset AS pay ON pay.order_id = ord.order_id
    WHERE ord.order_status = 'delivered'
    GROUP BY 1
    HAVING COUNT(pay.order_id) > 500 -- to remove insignificant months (e.g. starting month, ending month)
    ORDER BY 1
),
monthly_growth AS (
    SELECT month,
        revenue,
        (
            revenue - LAG(revenue, 1, 0) OVER (
                ORDER BY month
            )
        ) / LAG(revenue) OVER (
            ORDER BY month
        ) AS growth_rate -- (current period - prior period) / prior period = growth_rate
    FROM monthly_revenue
)
SELECT CONCAT(ROUND(AVG(growth_rate) * 100, 2), '%') AS avg_monthly_growth_percent
FROM monthly_growth
WHERE growth_rate IS NOT NULL;