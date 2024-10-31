-- Podstawowy JOIN
SELECT 
	C.CustomerID,
	C.PersonID,
	SOH.SalesOrderNumber,
	SOH.TotalDue
FROM Sales.Customer AS C
	JOIN Sales.SalesOrderHeader AS SOH
	ON C.CustomerID = SOH.CustomerID

-- LEFT JOIN
SELECT
	C.CustomerID,
	C.PersonID,
	SOH.SalesOrderNumber,
	SOH.TotalDue
FROM Sales.Customer AS C
	LEFT JOIN Sales.SalesOrderHeader AS SOH
	ON C.CustomerID = SOH.CustomerID

-- RIGHT JOIN
SELECT
	C.CustomerID,
	C.PersonID,
	SOH.SalesOrderNumber,
	SOH.TotalDue
FROM Sales.Customer AS C
	RIGHT JOIN Sales.SalesOrderHeader AS SOH
	ON C.CustomerID = SOH.CustomerID

-- CROSS JOIN
SELECT 
	C.CustomerID,
	C.PersonID,
	P.ProductID,
	P.Name as ProductName
FROM Sales.Customer AS C
	CROSS JOIN Production.Product AS P