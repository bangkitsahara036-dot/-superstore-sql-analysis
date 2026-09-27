# SQL Data Modeling & Analysis — Superstore Sales Database

## Overview
This project transforms a single flat retail dataset (9,994 rows) into a normalized relational database, then answers a set of business questions using SQL Server (T-SQL) — covering shipping performance, product profitability, customer behavior, and sales trends.

## Dataset
- **Source:** Sample Superstore dataset (Kaggle)
- **Original size:** 9,994 rows, 21 columns (flat/denormalized)
- **Time span:** 2014–2017

## Database Design
The flat dataset was split into 4 relational tables to eliminate data redundancy:

| Table | Rows | Key |
|---|---|---|
| `Customers` | 793 | PK: `CustomerID` |
| `Products` | 1,862 | PK: `ProductID` |
| `Orders` | 5,009 | PK: `OrderID`, FK: `CustomerID` |
| `OrderDetails` | 9,994 | FK: `OrderID`, `ProductID` (fact table) |


**Design note:** Shipping address (City, State, Region) was found to be an **order-level attribute**, not a customer-level one — 780 out of 793 customers shipped to more than one city. This was placed in the `Orders` table rather than `Customers`, following normalization principles.

## Business Questions Answered
1. Which shipping mode is used most often, and how does average delivery time compare across modes?
2. Which product categories/sub-categories are most profitable?
3. Which products have high sales but negative profit (over-discounting)?
4. Who are the top customers by profit, and which customer segment drives the most profit?
5. What are the monthly sales trends, and which regions perform best?
6. What is the month-over-month sales growth rate?

Full queries are available in [`SQLPROJECT.sql`](SQLPROJECT.sql).

## Key Findings
- Profitability: Technology with $145,454 Total Profit
- Shipping: Same Day is fastest (~0 days), Standard Class takes longest (~5 days)
- Customer: Tamara generated the highest individual profit (~$8,981); the Consumer segment contributed the most profit overall.
- Trend: Sales show a clear seasonal pattern, peaking in November-December — likely driven by year-end holiday shopping.

## Tools
- Microsoft SQL Server / SSMS

## Files
- `SQLPROJECT.sql` — table queries and 13 business-question analyses
- `data/` — the 4 normalized CSV files

## Author
Sahara Bangkit 
[Your Name] — Final-year Statistics student
[LinkedIn] · [Email]
