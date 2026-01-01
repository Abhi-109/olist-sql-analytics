LOAD DATA LOCAL INFILE 'D:/Downloads/archive (1)/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  seller_id,
  seller_zip_code_prefix,
  seller_city,
  seller_state
);