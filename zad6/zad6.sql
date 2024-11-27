-- https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Purchasing_11/module.html
-- ta strona ratuje życie 
-- !!!


-- zad. 1   
SELECT
	P.FirstName,
	P.LastName,
	COUNT(*) AS 'Liczba zamówień',
	SUM(SOH.TotalDue) AS 'Łączna kwota zakupów'
FROM Sales.SalesOrderHeader AS SOH
	JOIN Sales.Customer AS C
	ON SOH.CustomerID = C.CustomerID
	JOIN Person.Person AS P
	ON C.PersonID = P.BusinessEntityID
WHERE YEAR(SOH.OrderDate) >= 2014
GROUP BY P.FirstName, P.LastName
ORDER BY COUNT(*) DESC
-- https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Business_Entities_82/module.html

-- zad. 2
SELECT 
	P.Name,
	COUNT(*) AS 'Liczba zamówień',
	SUM(SOD.OrderQty) AS 'Ilość sprzedanych sztuk',
	SUM(SOD.LineTotal) AS 'Łączna wartość sprzedaży'
FROM Sales.SalesOrderDetail AS SOD
	JOIN Production.Product AS P
	ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY COUNT(*) DESC
--

-- zad. 3
SELECT
	ST.Name,
	P.Name,
	SUM(SOD.LineTotal) AS 'Łączna sprzedaż',
	AVG(SOD.OrderQty) AS 'Średnia ilość sprzedanych sztuk na jedno zamówienie'
FROM Production.Product AS P
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
	JOIN Sales.SalesTerritory AS ST
	ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name, P.Name
ORDER BY ST.Name, P.Name
--

-- zad. 4 
SELECT
	P.FirstName,
	P.LastName,
	--YEAR(SOH.OrderDate)
	AVG(SOH.TotalDue) AS 'Średnia sprzedaż'
FROM Sales.SalesPerson AS SP
	JOIN Person.Person AS P
	ON SP.BusinessEntityID = P.BusinessEntityID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SP.BusinessEntityID = SOH.SalesPersonID
WHERE YEAR(SOH.OrderDate) >= 2014
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
ORDER BY V.Name, P.Name ASC
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
-- albo nikt nie zwraca 
-- albo flaga "czy zamówienie jest zwrócone" jest przechowywana w innym miejscu
-- ¯\_(:P)_/¯

-- zad. 7 na dwa sposoby 
SELECT
	P.Name,
	YEAR(SOH.OrderDate) AS Rok,
	--SUM(SOD.LineTotal),
	--LAG(SUM(SOD.OrderQty)) OVER (PARTITION BY P.ProductID ORDER BY YEAR(SOH.OrderDate)),
	CASE
		WHEN LAG(SUM(SOD.LineTotal)) OVER (PARTITION BY P.ProductID ORDER BY YEAR(SOH.OrderDate)) IS NOT NULL THEN
			(SUM(SOD.LineTotal) - LAG(SUM(SOD.LineTotal)) OVER (PARTITION BY P.ProductID ORDER BY YEAR(SOH.OrderDate)))
			 * 100.0 / LAG(SUM(SOD.LineTotal)) OVER (PARTITION BY P.ProductID ORDER BY YEAR(SOH.OrderDate))
		ELSE
			NULL
	END AS 'Procentowa różnica sprzedaży'
FROM Production.Product as P
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY P.Name, P.ProductID, YEAR(SOH.OrderDate)
ORDER BY P.Name, YEAR(SOH.OrderDate) DESC
-- najpierw zrobiłem tym sposobem, a potem się nauczyłem tej klauzuli WITH więc zostawiłem 2 rozwiązania
-- oba są poprawne

--
WITH RocznaSprzedaz AS (
	SELECT 
		P.Name AS ProductName,
		YEAR(SOH.OrderDate) AS Rok,
		SUM(SOD.LineTotal) AS TotalSales
	FROM Production.Product as P
		JOIN Sales.SalesOrderDetail AS SOD
		ON P.ProductID = SOD.ProductID
		JOIN Sales.SalesOrderHeader AS SOH
		ON SOD.SalesOrderID = SOH.SalesOrderID
	GROUP BY P.Name, YEAR(SOH.OrderDate)
)
SELECT
	ProductName,
	Rok,
	--TotalSales,
	--LAG(SUM(SOD.OrderQty)) OVER (PARTITION BY P.ProductID ORDER BY YEAR(SOH.OrderDate)),
	CASE
		WHEN LAG(TotalSales) OVER (PARTITION BY ProductName ORDER BY Rok) IS NOT NULL THEN
			(TotalSales - LAG(TotalSales) OVER (PARTITION BY ProductName ORDER BY Rok))
			 * 100.0 / LAG(TotalSales) OVER (PARTITION BY ProductName ORDER BY Rok)
		ELSE
			NULL
	END AS 'Procentowa różnica sprzedaży'
FROM 
	RocznaSprzedaz as curr
ORDER BY ProductName, Rok DESC
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
	CC.CardType,
	COUNT(*) AS 'Liczba zamowień',
	SUM(SOH.TotalDue) AS 'Łączna wartość sprzedaży'
FROM Sales.SalesOrderHeader as SOH
	JOIN Sales.CreditCard as CC
	ON SOH.CreditCardID = CC.CreditCardID
GROUP BY CC.CardType
ORDER BY CC.CardType ASC
--

-- zad. 10
SELECT
	P.Name,
	P.Class
FROM Production.Product AS P
WHERE P.ProductID NOT IN (
	SELECT SOD.ProductID
	FROM Sales.SalesOrderDetail AS SOD
)
ORDER BY P.Name
--

-- zad. 11
SELECT
	ST.Name,
	AVG(DATEDIFF(day, SOH.OrderDate, SOH.ShipDate)) AS 'Średni czas realizacji zamówienia'
FROM Sales.SalesOrderHeader AS SOH
	JOIN Sales.SalesTerritory AS ST
	ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name
ORDER BY ST.Name
--

-- zad. 12
SELECT 
	P.Name,
	(MAX(SOD.UnitPrice) - MIN(SOD.UnitPrice)) * 100.0 / MIN(SOD.UnitPrice) AS 'Przyrost ceny sprzedaży'
FROM Sales.SalesOrderDetail AS SOD
	JOIN Production.Product AS P
	ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY (MAX(SOD.UnitPrice) - MIN(SOD.UnitPrice)) * 100.0 / MIN(SOD.UnitPrice) DESC
--

-- zad. 13
SELECT
	P.Name,
	ABS(AVG(DATEDIFF(day, POH.OrderDate, SOH.OrderDate))) AS 'Średnia ilość dni od zakupu od dostawcy do sprzedaży klientowi'
FROM Production.Product AS P
	JOIN Purchasing.PurchaseOrderDetail AS POD
	ON P.ProductID = POD.ProductID
	JOIN Purchasing.PurchaseOrderHeader AS POH
	ON POD.PurchaseOrderID = POH.PurchaseOrderID
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY P.Name
ORDER BY P.Name
--

-- zad. 14
SELECT
	SUM(case when C.StoreID is NULL then 1 else 0 end) * 100.0 / COUNT(*) as 'Klient firmowy',
	SUM(case when C.StoreID is NULL then 0 else 1 end) * 100.0 / COUNT(*) as 'Klient indywidualny'
FROM Sales.Customer AS C
	JOIN Sales.SalesOrderHeader AS SOH
	ON C.CustomerID = SOH.CustomerID
--

-- zad. 15
SELECT
	TerritoryName,
	ProductName,
	Quantity
FROM (
	SELECT
		ST.Name AS TerritoryName,
		P.Name AS ProductName,
		SUM(SOD.OrderQty) AS Quantity,
		ROW_NUMBER() OVER (PARTITION BY ST.Name ORDER BY SUM(SOD.OrderQty) DESC) AS rn
	FROM Sales.SalesOrderDetail AS SOD
		JOIN Sales.SalesOrderHeader AS SOH
		ON SOD.SalesOrderID = SOH.SalesOrderID
		JOIN Sales.SalesTerritory AS ST
		ON SOH.TerritoryID = ST.TerritoryID
		JOIN Production.Product AS P
		ON SOD.ProductID = P.ProductID
	GROUP BY ST.Name, P.Name
) sub
WHERE rn = 1