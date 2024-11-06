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
-- BEC i P nie maja elementow wspolnych

-- zad. 2
SELECT 
	P.Name,
	COUNT(SOD.ProductID) AS 'Liczba zamowien',
	SUM(SOD.OrderQty) AS 'Ilosc sprzedanych sztuk',
	SUM(SOD.LineTotal) AS 'Laczna wartosc sprzedazy'
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
	SUM(SOD.LineTotal) AS 'Laczna sprzedaz dla produktu',
	AVG(SOD.OrderQty) AS 'Srednia ilosc sprzedanych sztuk'
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
FROM Sales.SalesPerson AS SP
	JOIN Person.Person AS P
	ON SP.BusinessEntityID = P.BusinessEntityID
	JOIN Sales.PersonCreditCard AS PCC
	ON P.BusinessEntityID = PCC.BusinessEntityID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.CreditCardID = PCC.CreditCardID
--WHERE SOH.OrderDate > '2022-01-01'
--GROUP BY P.FirstName, P.LastName
--