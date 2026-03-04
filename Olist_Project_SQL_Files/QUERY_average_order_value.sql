-- What is the average order value by year
SELECT ROUND(AVG(payment_value), 2) AS avgerage_order_value,
    DATE_TRUNC('year', ord.order_purchase_timestamp) AS year
FROM olist_order_payments_dataset pay
    INNER JOIN olist_orders_dataset ord ON ord.order_id = pay.order_id
WHERE ord.order_status = 'delivered'
GROUP BY year
HAVING COUNT(DISTINCT ord.order_approved_at) > 500;