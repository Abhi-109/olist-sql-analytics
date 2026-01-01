# Data Quality & Integrity Checks

## Referential Integrity
All foreign key relationships were validated.
No orphan records were found across orders, order_items, products, sellers, or payments.

## Null Sanity Checks
Critical timestamps such as order_purchase_timestamp contained no null values.
Non-critical fields contained expected nulls and were retained.

## Temporal Integrity Checks
Temporal integrity checks revealed no severe lifecycle violations such as delivery before purchase.
Minor inconsistencies were observed in intermediate timestamps due to system logging delays,
affecting less than 1.5% of records. These were retained and treated as expected real-world data noise.
