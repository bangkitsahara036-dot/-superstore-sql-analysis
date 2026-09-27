SELECT * FROM [dbo].[Customers];

SELECT * FROM [dbo].[OrderDetails];

SELECT * FROM [dbo].[Orders];

SELECT * FROM [dbo].[Products];

-- SUPERSTORE BUSINESS ANALYSIS
-- Business questions answered using SQL Server
-- Tables: Customers, Products, Orders, OrderDetails

-- 1. SHIPPING PERFORMANCE

-- 1a. Metode pengiriman mana yang paling sering dipakai?
SELECT ShipMode, COUNT(*) AS TotalOrders 
FROM Orders
GROUP BY ShipMode
ORDER BY TotalOrders DESC;

-- 1b. Rata-rata berapa hari dari Order Date ke Ship Date, per Ship Mode?
SELECT ShipMode,
       AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS AvgShippingDays
FROM Orders
GROUP BY ShipMode
ORDER BY AvgShippingDays;

-- 2. PRODUCT & PROFITABILITY

-- 2a. Kategori produk mana yang paling menguntungkan?
SELECT p.Category,
       SUM(od.Sales)   AS TotalSales,
       SUM(od.Profit)  AS TotalProfit,
       ROUND(SUM(od.Profit) * 100.0 / SUM(od.Sales), 2) AS ProfitMarginPct
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalProfit DESC;

-- 2b. Sub-kategori mana yang paling menguntungkan?
SELECT p.Category, p.SubCategory,
       SUM(od.Sales)  AS TotalSales,
       SUM(od.Profit) AS TotalProfit
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.Category, p.SubCategory
ORDER BY TotalProfit DESC;

-- 2c. Produk dengan sales tinggi TAPI profit rendah/negatif (indikasi diskon berlebihan)
SELECT TOP 10
       p.ProductName,
       SUM(od.Sales)    AS TotalSales,
       SUM(od.Profit)   AS TotalProfit,
       AVG(od.Discount) AS AvgDiscount
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
HAVING SUM(od.Profit) < 0        -- hanya produk yang rugi
ORDER BY TotalSales DESC;



-- 3. CUSTOMER ANALYSIS

-- 3a. Top 10 customer berdasarkan total profit yang mereka hasilkan
SELECT TOP 10
       c.CustomerName,
       SUM(od.Profit) AS TotalProfit
FROM OrderDetails od
JOIN Orders o    ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalProfit DESC;

-- 3b. Segment customer mana (Consumer/Corporate/Home Office) yang paling menguntungkan?
SELECT c.Segment,
       COUNT(DISTINCT o.OrderID) AS TotalOrders,
       SUM(od.Sales)             AS TotalSales,
       SUM(od.Profit)            AS TotalProfit
FROM OrderDetails od
JOIN Orders o    ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Segment
ORDER BY TotalProfit DESC;

-- 3c. Customer yang pernah order lebih dari 1 kategori produk berbeda
-- (menunjukkan cross-selling / loyalitas pelanggan)
SELECT c.CustomerName,
       COUNT(DISTINCT p.Category) AS CategoryVariety
FROM OrderDetails od
JOIN Orders o    ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p  ON od.ProductID = p.ProductID
GROUP BY c.CustomerName
HAVING COUNT(DISTINCT p.Category) > 1
ORDER BY CategoryVariety DESC;



-- 4. TREND ANALYSIS

-- 4a. Tren penjualan bulanan (per tahun-bulan)
SELECT FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
       SUM(od.Sales)  AS TotalSales,
       SUM(od.Profit) AS TotalProfit
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY YearMonth;

-- 4b. Region mana yang paling banyak order & paling profitable?
SELECT o.Region,
       COUNT(DISTINCT o.OrderID) AS TotalOrders,
       SUM(od.Sales)             AS TotalSales,
       SUM(od.Profit)            AS TotalProfit
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY o.Region
ORDER BY TotalProfit DESC;

-- 4c. Growth rate penjualan bulan-ke-bulan (pakai window function LAG)
-- Membandingkan sales bulan ini vs bulan sebelumnya
WITH MonthlySales AS (
    SELECT FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
           SUM(od.Sales) AS TotalSales
    FROM OrderDetails od
    JOIN Orders o ON od.OrderID = o.OrderID
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
)
SELECT YearMonth,
       TotalSales,
       LAG(TotalSales) OVER (ORDER BY YearMonth) AS PrevMonthSales,
       ROUND(
           (TotalSales - LAG(TotalSales) OVER (ORDER BY YearMonth)) * 100.0
           / NULLIF(LAG(TotalSales) OVER (ORDER BY YearMonth), 0), 2
       ) AS GrowthPct
FROM MonthlySales
ORDER BY YearMonth;


-- 5. BONUS: RANKING PAKAI WINDOW FUNCTION 

-- Ranking produk terlaris per kategori (top 3 tiap kategori)

