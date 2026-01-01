LOAD DATA LOCAL INFILE 'D:/Downloads/archive (1)/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  order_id,
  customer_id,
  order_status,
  @order_purchase_timestamp,
  @order_approved_at,
  @order_delivered_carrier_date,
  @order_delivered_customer_date,
  @order_estimated_delivery_date
)
SET
  order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
  order_approved_at = NULLIF(@order_approved_at, ''),
  order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
  order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
  order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');
