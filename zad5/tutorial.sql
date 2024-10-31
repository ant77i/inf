SELECT * FROM AdventureWorks2022.Sales.SalesOrderHeader

-- 
SELECT SalesOrderNumber, CustomerID, SubTotal, TaxAmt, TotalDue 
    FROM AdventureWorks2022.Sales.SalesOrderHeader

-- dodaj warunek
SELECT SalesOrderNumber, CustomerID, SubTotal, TaxAmt, TotalDue 
    FROM AdventureWorks2022.Sales.SalesOrderHeader
        WHERE CustomerID = 29580

--sortowanie
SELECT SalesOrderNumber, CustomerID, SubTotal, TaxAmt, TotalDue 
    FROM AdventureWorks2022.Sales.SalesOrderHeader
        WHERE CustomerID = 29580
        ORDER BY TotalDue DESC -- asc 

-- grupowanie
SELECT CustomerID, sum(TotalDue) as TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalSpent DESC -- asc

--warunkowanie
SELECT CustomerID, sum(TotalDue) as TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING sum(TotalDue) > 1000
ORDER BY TotalSpent DESC -- asc

-- ograniczenie ilosci wynikow
SELECT top 10 SalesOrderID, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC

--pobieranie unikalnych wartosci z wybranych klumn
SELECT DISTINCT TerritoryID
FROM Sales.SalesOrderHeader

-- zagniezdzone SELECTy
SELECT SalesOrderID, TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales.Customer
    WHERE TerritoryID = 5)

--zapytania warunkowe
SELECT 
    SalesOrderID,
    TotalDue,
    CASE 
        WHEN TotalDue > 1000 THEN 'high'
        WHEN TotalDue > 500 AND TotalDue < 1000 THEN 'mid'
    ELSE 
        'low'
    END AS OrderValueCategory
    FROM Sales.SalesOrderHeader

-- zapytania NOT IN
SELECT ProductID, name
FROM Production.Product
WHERE ProductID NOT IN(
SELECT ProductID FROM Sales.SalesOrderDetail)

-- zaptania na wzorce tekstowe
SELECT FirstName, LastName
FROM Person.Person
WHERE LastName LIKE '__u%'


SELECT
	P.Name,
	OD.OrderQty
FROM AdventureWorks2022.Production.Product AS P
CROSS APPLY (
	SELECT TOP 1 OrderQty
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS OD
	WHERE OD.ProductID = P.ProductID
	ORDER BY OrderQty DESC
) AS OD

