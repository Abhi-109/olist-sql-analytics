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


-- Which customers have not made a delivered purchase in the last 6 months of the dataset?
-- Customers inactive for more than 6 months based on last delivered purchase
SELECT
    customer_id,
    last_purchase_date
FROM (
    SELECT
        o.customer_id,
        MAX(o.order_purchase_timestamp) AS last_purchase_date
    FROM orders o
    WHERE o.order_status = 'delivered'
    GROUP BY o.customer_id
) t
WHERE last_purchase_date <
      (
          SELECT MAX(order_purchase_timestamp)
          FROM orders
          WHERE order_status = 'delivered'
      ) - INTERVAL 6 MONTH;
