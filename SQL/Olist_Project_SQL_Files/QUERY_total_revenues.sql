-- Total revenue and breakdown of total revenue
WITH payment_rev AS (
    SELECT ord.order_id,
        SUM(pay.payment_value) AS revenue_per_order,
        SUM(SUM(pay.payment_value)) OVER () AS total_revenue
    FROM olist_order_payments_dataset pay
        JOIN olist_orders_dataset ord ON ord.order_id = pay.order_id
    WHERE ord.order_status = 'delivered'
    GROUP BY ord.order_id
),
product_rev AS (
    SELECT pr.order_id,
        SUM(items.price) AS product_price_per_order,
        SUM(items.freight_value) AS freight_price_per_order,
        (SUM(items.price) + SUM(items.freight_value)) AS total_price_per_order,
        SUM((SUM(items.price) + SUM(items.freight_value))) OVER () AS total_price,
        SUM(SUM(items.price)) OVER () AS total_product_price,
        SUM(SUM(items.freight_value)) OVER () AS total_freight_price
    FROM payment_rev AS pr
        JOIN olist_order_items_dataset AS items ON items.order_id = pr.order_id
    GROUP BY pr.order_id
)
SELECT pay.order_id,
    prod.product_price_per_order,
    prod.freight_price_per_order,
    prod.total_price_per_order,
    pay.revenue_per_order,
    prod.total_product_price,
    prod.total_freight_price,
    pay.total_revenue
FROM payment_rev pay
    JOIN product_rev prod ON prod.order_id = pay.order_id;