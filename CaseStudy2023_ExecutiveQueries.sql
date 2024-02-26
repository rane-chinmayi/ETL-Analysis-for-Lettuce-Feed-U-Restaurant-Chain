use SP23_kschrane
go


----1. What are the top 3 locations with respect to profit annually, monthly, weekly and daily?
---  Annual profit

CREATE VIEW AnnualProfit_Location AS
SELECT TOP 3 sd.StoreCity, SUM(sf.ProductNetAmt) AS TotalProfit
FROM StoreDimension sd
INNER JOIN SalesFact sf ON sd.StoreNbr = sf.StoreNbr
INNER JOIN TimeDimension d ON sf.date_key = d.date_key
GROUP BY sd.StoreCity, YEAR(d.FullDate)
ORDER BY TotalProfit DESC;

select * from AnnualProfit_Location;

---  Monthly profit
SELECT TOP 3 sd.StoreCity, SUM(sf.ProductNetAmt) AS TotalProfit
FROM StoreDimension sd
INNER JOIN SalesFact sf ON sd.StoreNbr = sf.StoreNbr
INNER JOIN TimeDimension d ON sf.date_key = d.date_key
GROUP BY sd.StoreCity, YEAR(d.FullDate), MONTH(d.FullDate)
ORDER BY TotalProfit DESC

---  Weekly profit
SELECT TOP 3 sd.StoreCity, SUM(sf.ProductNetAmt) AS TotalProfit
FROM StoreDimension sd
INNER JOIN SalesFact sf ON sd.StoreNbr = sf.StoreNbr
INNER JOIN TimeDimension d ON sf.date_key = d.date_key
GROUP BY sd.StoreCity, YEAR(d.FullDate), DATEPART(wk, d.FullDate)
ORDER BY TotalProfit DESC

--- Daily Profit
SELECT TOP 3 sd.StoreCity, SUM(sf.ProductNetAmt) AS TotalProfit
FROM StoreDimension sd
INNER JOIN SalesFact sf ON sd.StoreNbr = sf.StoreNbr
INNER JOIN TimeDimension d ON sf.date_key = d.date_key
GROUP BY sd.StoreCity, d.FullDate
ORDER BY TotalProfit DESC


---2. How many customers does each location serve annually, monthly, weekly and daily
-- Annual customers by location for TULSA
SELECT DATENAME(YEAR, d.fulldate) as Year, COUNT(DISTINCT sf.ReceiptNbr) AS AnnualCustomerCount
FROM SalesFact sf
JOIN StoreDimension sd ON sf.store_key = sd.store_key
JOIN TimeDimension d ON sf.date_key = d.date_key
where sd.StoreCity = 'Tulsa'
GROUP BY DATENAME(YEAR, d.fulldate)

-- Monthly customer count by location
SELECT DATENAME(MONTH, d.fulldate) as Month , COUNT(DISTINCT sf.ReceiptNbr) AS AnnualCustomerCount
FROM SalesFact sf
JOIN StoreDimension sd ON sf.store_key = sd.store_key
JOIN TimeDimension d ON sf.date_key = d.date_key
where sd.StoreCity = 'Tulsa'
GROUP BY DATENAME(MONTH, d.fulldate)

-- Weekly customer count by location
SELECT DATENAME(WEEKDAY, d.fulldate), COUNT(DISTINCT sf.ReceiptNbr) AS AnnualCustomerCount
FROM SalesFact sf
JOIN StoreDimension sd ON sf.store_key = sd.store_key
JOIN TimeDimension d ON sf.date_key = d.date_key
where sd.StoreCity = 'Tulsa'
GROUP BY  DATENAME(WEEKDAY, d.fulldate)

-- Daily customer count by location
SELECT CONVERT(VARCHAR(10), d.fulldate, 101) AS [Date], COUNT(DISTINCT sf.ReceiptNbr) AS AnnualCustomerCount
FROM SalesFact sf
JOIN StoreDimension sd ON sf.store_key = sd.store_key
JOIN TimeDimension d ON sf.date_key = d.date_key
where sd.StoreCity = 'Tulsa' AND  d.fulldate <= '2022-03-31'
GROUP BY CONVERT(VARCHAR(10), d.fulldate, 101)


--3. What are the top 10 most popular products sold by location annually, monthly, weekly and daily?
--Select Store in MI State, Annualy
SELECT TOP 10 pd.MenuName,sf.ProductNbr, SUM(sf.Quantity) as SalesQuantity, sd.StoreState, YEAR(sf.TransDate) as SalesYear
FROM SalesFact sf INNER JOIN StoreDimension sd ON sf.StoreNbr = sd.StoreNbr
					INNER JOIN TimeDimension td ON sf.TransDate = td.fulldate
					INNER JOIN ProductDimension pd ON sf.ProductNbr = pd.ProductNbr
WHERE sd.StoreState = 'MI' AND YEAR(sf.TransDate) = '2022'
GROUP BY sf.ProductNbr,pd.MenuName, sd.StoreState, YEAR(sf.TransDate), pd.MenuName, sd.StoreState
ORDER BY SalesQuantity desc;

--Select Store in MI State, October, Monthly
SELECT TOP 10 pd.MenuName,sf.ProductNbr, SUM(sf.Quantity) as SalesQuantity, sd.StoreState,YEAR(sf.TransDate) as SalesYear, MONTH(sf.TransDate) as SalesMonth
FROM SalesFact sf INNER JOIN StoreDimension sd ON sf.StoreNbr = sd.StoreNbr
					INNER JOIN TimeDimension td ON sf.TransDate = td.fulldate
					INNER JOIN ProductDimension pd ON sf.ProductNbr = pd.ProductNbr
WHERE sd.StoreState = 'MI' AND MONTH(sf.TransDate) = '10'
GROUP BY pd.MenuName, sd.StoreState, YEAR(sf.TransDate), MONTH(sf.TransDate), sf.ProductNbr
ORDER BY SalesQuantity desc;


--Select Store in MI State, week 10
SELECT TOP 10 pd.MenuName,sf.ProductNbr, SUM(sf.Quantity) as SalesQuantity, sd.StoreState,YEAR(sf.TransDate) as SalesYear, DATEPART(wk, sf.TransDate) as SalesWeek
FROM SalesFact sf INNER JOIN StoreDimension sd ON sf.StoreNbr = sd.StoreNbr
					INNER JOIN TimeDimension td ON sf.TransDate = td.fulldate
					INNER JOIN ProductDimension pd ON sf.ProductNbr = pd.ProductNbr
WHERE sd.StoreState = 'MI' AND DATEPART(wk, sf.TransDate) = 10
GROUP BY pd.MenuName, sd.StoreState, YEAR(sf.TransDate), DATEPART(wk, sf.TransDate), sf.ProductNbr
ORDER BY SalesQuantity desc;

--Select Store in MI State, Day
SELECT TOP 10 pd.MenuName,sf.ProductNbr, SUM(sf.Quantity) as SalesQuantity, sd.StoreState, sf.TransDate
FROM SalesFact sf INNER JOIN StoreDimension sd ON sf.StoreNbr = sd.StoreNbr
					INNER JOIN TimeDimension td ON sf.TransDate = td.fulldate
					INNER JOIN ProductDimension pd ON sf.ProductNbr = pd.ProductNbr
WHERE sd.StoreState = 'MI' AND sf.TransDate = '2022-03-31'
GROUP BY sf.ProductNbr, pd.MenuName, sd.StoreState, sf.TransDate
ORDER BY SalesQuantity desc;

--4. Which products have no sales or few sales?
---- Looks like there are no products which have no sales in the Product Dimension table

SELECT pd.MenuName, COUNT(sf.ProductNbr) AS SalesCount
FROM ProductDimension pd
LEFT JOIN SalesFact sf ON pd.ProductNbr = sf.ProductNbr
GROUP BY pd.MenuName
HAVING COUNT(sf.ProductNbr) <= 70000 OR COUNT(sf.ProductNbr) IS NULL;

--5. How is the number of drive-thru lanes impacting sales couple of questions that we are trying to answer:
SELECT sd.NbrDriveThruLanes, SUM(sf.ProductNetAmt) AS TotalSales
FROM SalesFact sf
JOIN StoreDimension sd ON sf.store_key = sd.store_key
GROUP BY sd.NbrDriveThruLanes
ORDER by NbrDriveThruLanes

--Based on the data we can see that stores which have 2 number of drive through lanes generates the maximum sales. But it could also based on other factors.

