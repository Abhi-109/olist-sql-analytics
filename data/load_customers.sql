LOAD DATA LOCAL INFILE 'D:/Downloads/archive (1)/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id,
 customer_unique_id,
 customer_zip_code_prefix,
 customer_city,
 customer_state);