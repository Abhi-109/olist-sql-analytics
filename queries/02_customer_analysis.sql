-- Top 10 customers by lifetime revenue excluding canceled orders
SELECT
    c.customer_id,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_id
ORDER BY total_revenue DESC
LIMIT 10;



-- Classify customers into one-time and repeat buyers based on delivered orders
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS order_count,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'one_time'
        ELSE 'repeat'
    END AS customer_type
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_id;
