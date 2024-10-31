-- 1
SELECT *
FROM AdventureWorks2022.Production.Product 
WHERE Product.Name LIKE '%Mountain%'

-- 2
SELECT 
	CustomerID, 
	MAX(OrderDate)
FROM AdventureWorks2022.Sales.SalesOrderHeader
GROUP BY CustomerID

-- 3
SELECT
	DATEPART(month, OrderDate) as OrderMonth,
	COUNT(*) as Count
FROM AdventureWorks2022.Sales.SalesOrderHeader
WHERE DATEPART(year, OrderDate) = 2013
GROUP BY DATEPART(month, OrderDate)
ORDER BY OrderMonth ASC

-- 4
SELECT
	*
FROM AdventureWorks2022.Person.Person
WHERE LastName LIKE '%son'

-- 5
SELECT
	*
FROM AdventureWorks2022.Sales.SalesOrderDetail
WHERE UnitPrice BETWEEN 500 AND 1000



-- 6
SELECT
	*
FROM AdventureWorks2022.Sales.SalesOrderHeader
WHERE TotalDue < (
	SELECT AVG(TotalDue)
	FROM AdventureWorks2022.Sales.SalesOrderHeader
)

-- 7
SELECT TOP 10 
	*
FROM AdventureWorks2022.Production.Product
ORDER BY StandardCost DESC

-- 8
SELECT
	*
FROM AdventureWorks2022.Production.Product
WHERE ListPrice = (
	SELECT MIN(ListPrice)
	FROM AdventureWorks2022.Production.Product
)

-- 9
SELECT
	*
FROM AdventureWorks2022.Sales.SalesOrderHeader
WHERE CreditCardApprovalCode IS NOT NULL


-- 10 
SELECT
	COUNT(CustomerID) AS 'Count'
FROM Sales.Customer

-- 11
SELECT
	*
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2012-01-01' AND '2012-12-31'

-- 12
SELECT
	*
FROM Production.Product
WHERE StandardCost > 1000

-- 13
SELECT
	*
FROM Person.Person
WHERE FirstName LIKE 'A%'