LOAD DATA LOCAL INFILE 'D:/Downloads/archive (1)/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  order_id,
  payment_sequential,
  payment_type,
  @payment_installments,
  @payment_value
)
SET
  payment_installments = NULLIF(@payment_installments, ''),
  payment_value = NULLIF(@payment_value, '');
