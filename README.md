# Olist E-Commerce SQL Analytics

## Problem Statement

The objective of this project is to analyze a real-world e-commerce dataset to understand customer behavior, revenue trends, product and seller performance, and payment patterns in a marketplace environment.

The analysis focuses on identifying revenue concentration, customer retention issues, inactivity and churn risk, time-based revenue dynamics, and operational dependencies on top products, sellers, and payment methods to support data-driven business decisions.

---

## Dataset

This project uses the Brazilian Olist E-Commerce dataset, which contains transactional data covering customers, orders, order items, products, sellers, payments, and timestamps for the full order lifecycle.

The dataset represents a real-world marketplace environment with multiple entities and complex relationships, making it suitable for end-to-end SQL analytics and business analysis.

---

## Tech Stack

- MySQL 8.4  
- SQL (CTEs, subqueries, window functions)  
- MySQL Workbench  
- Git & GitHub  

---

## Database Schema Overview

The database follows a normalized transactional schema including:

- customers  
- orders  
- order_items  
- products  
- sellers  
- payments  

Primary keys, foreign keys, and indexes were defined to ensure referential integrity, enforce data consistency, and improve query performance.

---

## Data Preparation & Validation

The following steps were performed before analysis:

- Loaded raw CSV files using `LOAD DATA LOCAL INFILE`
- Verified row counts across all tables
- Performed orphan checks to ensure referential integrity
- Conducted null sanity checks on critical columns
- Validated temporal consistency across order lifecycle timestamps

These steps ensured the analysis was performed on reliable and consistent data.

---

## Analysis Scope

The analysis was performed entirely using SQL and covers:

- Customer revenue contribution and concentration
- One-time vs repeat customer behavior
- Customer inactivity and churn risk
- Monthly revenue trends and volatility
- Month-over-month revenue growth
- Top product performance by month
- Seller revenue concentration
- Payment behavior and installment impact

Advanced SQL techniques such as CTEs, subqueries, and window functions were used extensively.

---

## Key Questions Answered

- Who are the highest-value customers and how concentrated is revenue?
- How many customers are one-time buyers versus repeat buyers?
- What proportion of customers are inactive and at churn risk?
- How has revenue evolved over time and how volatile is growth?
- Which products dominate revenue on a monthly basis?
- How dependent is the marketplace on top sellers?
- How significant are installment payments in total revenue?

---

## Key Insights
Detailed business insights and recommendations are documented in:
`insights/final_insights.md`

---

## Repository Structure

schema/        -- table creation scripts  
queries/       -- analytical SQL queries (Q1–Q9)  
insights/      -- final business insights  
README.md

---

## Conclusion
This project demonstrates end-to-end SQL analytics skills, including schema design, data ingestion, validation, advanced querying, and business insight generation on a real-world e-commerce dataset.
