-- Revenue by product distribution
WITH product_revenue AS (
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
    ORDER BY revenue_by_product DESC
),
ranked AS (
    SELECT product,
        revenue_by_product,
        NTILE(10) OVER (
            ORDER BY revenue_by_product DESC
        ) AS decile
    FROM product_revenue
)
SELECT decile AS product_percentile,
    CONCAT(
        ROUND(
            SUM(revenue_by_product) / SUM(SUM(revenue_by_product)) OVER () * 100,
            2
        ),
        '%'
    ) AS percent_of_total_revenue,
    SUM(revenue_by_product) AS revenue_by_percentile
FROM ranked
GROUP BY product_percentile
ORDER BY product_percentile;