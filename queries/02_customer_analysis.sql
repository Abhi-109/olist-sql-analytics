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


-- Customer inactivity distribution based on 6-month rule
SELECT
    customer_status,
    COUNT(*) AS customer_count
FROM (
    SELECT
        o.customer_id,
        CASE
            WHEN MAX(o.order_purchase_timestamp) <
                 (
                     SELECT MAX(order_purchase_timestamp)
                     FROM orders
                     WHERE order_status = 'delivered'
                 ) - INTERVAL 6 MONTH
            THEN 'inactive'
            ELSE 'active'
        END AS customer_status
    FROM orders o
    WHERE o.order_status = 'delivered'
    GROUP BY o.customer_id
) t
GROUP BY customer_status;

-- Monthly revenue trend for delivered orders
WITH revenue_base AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        (oi.price + oi.freight_value) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    year,
    month,
    SUM(revenue) AS monthly_revenue
FROM revenue_base
GROUP BY year, month
ORDER BY year, month;

-- Month-over-month revenue growth for delivered orders
WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    year,
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY year, month) AS previous_month_revenue,
    (
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year, month))
        / LAG(monthly_revenue) OVER (ORDER BY year, month)
    ) * 100 AS mom_growth_percent
FROM monthly_revenue
ORDER BY year, month;


-- For each month, find the top 5 products by total revenue
WITH monthly_product_revenue AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        oi.product_id,
        SUM(oi.price + oi.freight_value) AS monthly_product_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp),
        oi.product_id
),
ranked_products AS (
    SELECT
        year,
        month,
        product_id,
        monthly_product_revenue,
        RANK() OVER (
            PARTITION BY year, month
            ORDER BY monthly_product_revenue DESC
        ) AS product_rank
    FROM monthly_product_revenue
)
SELECT
    year,
    month,
    product_id,
    monthly_product_revenue,
    product_rank
FROM ranked_products
WHERE product_rank <= 5
ORDER BY year, month, product_rank;



-- Top 10 sellers by delivered revenue and their contribution to total marketplace revenue
WITH seller_revenue AS (
    SELECT
        oi.seller_id,
        SUM(oi.price + oi.freight_value) AS seller_revenue
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
ranked_sellers AS (
    SELECT
        seller_id,
        seller_revenue,
        RANK() OVER (ORDER BY seller_revenue DESC) AS revenue_rank
    FROM seller_revenue
),
total_marketplace_revenue AS (
    SELECT
        SUM(seller_revenue) AS total_revenue
    FROM seller_revenue
)
SELECT
    rs.seller_id,
    rs.seller_revenue,
    rs.revenue_rank,
    (rs.seller_revenue / tmr.total_revenue) * 100 AS revenue_contribution_percent
FROM ranked_sellers rs
CROSS JOIN total_marketplace_revenue tmr
WHERE rs.revenue_rank <= 10
ORDER BY rs.revenue_rank;

-- How does revenue vary by payment type, and how significant are installment-based payments in total revenue?

WITH payment_revenue AS (
    SELECT
        CASE
            WHEN payment_installments > 1 THEN 'installment'
            WHEN payment_installments = 1 OR payment_installments IS NULL THEN 'non_installment'
        END AS payment_category,
        SUM(payment_value) AS total_revenue
    FROM payments p
    JOIN orders o ON p.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        CASE
            WHEN payment_installments > 1 THEN 'installment'
            WHEN payment_installments = 1 OR payment_installments IS NULL THEN 'non_installment'
        END
),
total_revenue AS (
    SELECT SUM(total_revenue) AS grand_total FROM payment_revenue
)
SELECT
    pr.payment_category,
    pr.total_revenue,
    (pr.total_revenue / tr.grand_total) * 100 AS revenue_contribution_percent
FROM payment_revenue pr, total_revenue tr;