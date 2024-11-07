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
	P.FirstName,
	P.LastName,
	AVG(SOH.TotalDue)
FROM Sales.SalesPerson AS SP
	JOIN Person.Person AS P
	ON SP.BusinessEntityID = P.BusinessEntityID
	JOIN Sales.PersonCreditCard AS PCC
	ON P.BusinessEntityID = PCC.BusinessEntityID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.CreditCardID = PCC.CreditCardID
WHERE SOH.OrderDate > '2022-01-01'
GROUP BY P.FirstName, P.LastName
--

-- zad. 5
SELECT 
	V.Name,
	P.Name,
	SUM(PV.StandardPrice * PI.Quantity)
FROM Purchasing.Vendor as V
	JOIN Purchasing.ProductVendor as PV
	ON V.BusinessEntityID = PV.BusinessEntityID
	JOIN Production.Product AS P
	ON PV.ProductID = P.ProductID
	JOIN Production.ProductInventory AS PI
	ON PV.ProductID = PI.ProductID
GROUP BY V.Name, P.Name
ORDER BY V.Name DESC
--

-- zad. 6
SELECT 
	P.Name,
	SUM(case when SOH.Status = 4 then 1 else 0 end) AS Zwroty,
	SUM(case when SOH.Status = 4 then 1 else 0 end) * 100 / COUNT(*)  as 'Procenty zwrotow'
FROM Production.Product as P
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY P.Name
--

-- zad. 7
SELECT
	P.Name,
	DATEPART(year, SOH.OrderDate) as Rok,
	SUM(SOD.OrderQty) / (SELECT SUM(SOD.OrderQty) FROM Production.Product WHERE DATEPART(year, SOH.OrderDate)+1 = Rok)
FROM Production.Product as P
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY P.Name, DATEPART(year, SOH.OrderDate)
ORDER BY P.Name, DATEPART(year, SOH.OrderDate)
--

-- zad. 8
SELECT
	P.Name,
	V.Name,
	AVG(PV.StandardPrice) as StandardPrice
FROM Purchasing.Vendor as V
	JOIN Purchasing.ProductVendor as PV
	ON V.BusinessEntityID = PV.BusinessEntityID
	JOIN Production.Product AS P
	ON PV.ProductID = P.ProductID
GROUP BY P.Name, V.Name
ORDER BY P.Name, V.Name
--

-- zad. 9
SELECT
	*
FROM Sales.SalesOrderHeader as SOH
	JOIN Sales.CreditCard as CC
	ON SOH.CreditCardID = CC.CreditCardID