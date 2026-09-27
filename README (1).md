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

![ERD Diagram](images/erd_diagram.png)

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
- **Shipping:** Same Day delivery is fastest; Standard Class takes the longest on average — showing a clear speed-vs-cost trade-off across ship modes.
- **Profitability:** [add top category/sub-category from your query results]
- **Customer:** [add top customer name and top segment from your query results]
- **Trend:** Sales show a clear seasonal pattern, peaking toward the end of the year (Nov–Dec) — consistent with year-end holiday shopping behavior.

## Tools
- Microsoft SQL Server / SSMS
- T-SQL (window functions, CTEs, aggregations, multi-table joins)

## Files
- `SQLPROJECT.sql` — table queries and 13 business-question analyses
- `data/` — the 4 normalized CSV files

## Author
[Your Name] — Final-year Statistics student
[LinkedIn] · [Email]
