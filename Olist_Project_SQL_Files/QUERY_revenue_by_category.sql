-- revenue by product category
SELECT prod.product_category_name AS category,
    SUM(items.price) AS revenue,
    SUM(SUM(items.price)) OVER () AS total_revenue
FROM olist_orders_dataset ord
    JOIN olist_order_items_dataset items ON items.order_id = ord.order_id
    JOIN olist_products_dataset prod ON prod.product_id = items.product_id
WHERE ord.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC;