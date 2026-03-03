SELECT SUM(pay.payment_value) AS revenue,
    EXTRACT(
        MONTH
        FROM ord.order_purchase_timestamp
    ) AS month,
    EXTRACT(
        YEAR
        FROM ord.order_purchase_timestamp
    ) AS year
FROM olist_orders_dataset AS ord
    INNER JOIN olist_order_payments_dataset AS pay ON pay.order_id = ord.order_id
WHERE ord.order_status = 'delivered'
GROUP BY year,
    month
HAVING COUNT(pay.order_id) > 500
ORDER BY year,
    month