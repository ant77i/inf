-- zad. 1
SELECT
	*
FROM Sales.Customer AS C
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.CustomerID = C.CustomerID
	JOIN Person.BusinessEntityContact AS BEC
	ON C.PersonID = BEC.PersonID
	JOIN Person.Person AS P
	ON BEC.BusinessEntityID = P.BusinessEntityID
-- BEC i P nie maj¹ elementów wspólnych

-- zad. 2
SELECT 
	P.Name,
	COUNT(SOD.ProductID) AS 'Liczba zamówieñ',
	SUM(SOD.OrderQty) AS 'Iloœæ sprzedanych sztuk',
	SUM(SOD.LineTotal) AS '£¹czna wartoœæ sprzeda¿y'
FROM Sales.SalesOrderDetail AS SOD
	JOIN Production.Product AS P
	ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY COUNT(SOD.ProductID) DESC
--

-- zad. 3
SELECT
	P.Name,
	ST.Name,
	SUM(SOD.LineTotal) AS '£¹czna sprzeda¿ dla produktu',
	AVG(SOD.OrderQty) AS 'Œrednia iloœæ sprzedanych sztuk'
FROM Production.Product AS P
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
	JOIN Sales.SalesTerritory AS ST
	ON SOH.TerritoryID = ST.TerritoryID
GROUP BY P.Name, ST.Name
ORDER BY ST.Name
--

-- zad. 4
SELECT
	*
