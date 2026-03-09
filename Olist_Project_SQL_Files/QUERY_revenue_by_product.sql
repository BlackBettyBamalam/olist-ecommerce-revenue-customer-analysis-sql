-- revenue by product
SELECT items.product_id AS product,
    prod.product_category_name,
    SUM(items.price) AS revenue_by_product,
    SUM(SUM(items.price)) OVER () AS total_revenue
FROM olist_order_items_dataset items
    JOIN olist_orders_dataset ord ON ord.order_id = items.order_id
    JOIN olist_products_dataset prod ON prod.product_id = items.product_id
WHERE ord.order_status = 'delivered'
GROUP BY product,
    prod.product_category_name
ORDER BY revenue_by_product DESC;