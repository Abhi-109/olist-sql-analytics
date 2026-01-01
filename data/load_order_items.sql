LOAD DATA LOCAL INFILE 'D:/Downloads/archive (1)/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  order_id,
  order_item_id,
  product_id,
  seller_id,
  @shipping_limit_date,
  @price,
  @freight_value
)
SET
  shipping_limit_date = NULLIF(@shipping_limit_date, ''),
  price = NULLIF(@price, ''),
  freight_value = NULLIF(@freight_value, '');
