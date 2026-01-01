-- Row counts
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM payments;

-- Orphan checks
SELECT COUNT(*) FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) FROM order_items oi
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) FROM payments p
LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Null sanity
SELECT
  SUM(order_purchase_timestamp IS NULL) AS null_purchase_ts
FROM orders;

-- Temporal sanity

-- order_approved_at should not be before order_purchase_timestamp
SELECT COUNT(*) AS approval_before_purchase
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;

-- order_delivered_carrier_date should not be before order_approved_at
SELECT COUNT(*) AS carrier_before_approval
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_approved_at IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;

-- order_delivered_customer_date should not be before order_delivered_carrier_date
SELECT COUNT(*) AS customer_before_carrier
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;


-- order_estimated_delivery_date should not be before order_purchase_timestamp
SELECT COUNT(*) AS delivered_before_purchase
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;


-- order_estimated_delivery_date should not be before order_purchase_timestamp
SELECT COUNT(*) AS estimate_before_purchase
FROM orders
WHERE order_estimated_delivery_date < order_purchase_timestamp;

-- Delivered orders should have a non-null order_delivered_customer_date
SELECT COUNT(*) AS delivered_without_timestamp
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

