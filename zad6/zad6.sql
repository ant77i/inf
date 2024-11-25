-- zad. 1 pusty wynik
SELECT
	*
FROM Sales.Customer AS C
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOH.CustomerID = C.CustomerID
	JOIN Person.BusinessEntityContact AS BEC
	ON C.PersonID = BEC.PersonID
	JOIN Person.Person AS P
	ON BEC.BusinessEntityID = P.BusinessEntityID
-- 

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

-- zad. 4 pusty wynik
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
-- najpierw zrobiłem tym spodobem a potem się nauczyłem tej klauzuli WITH więc zostawiłem 2 rozwiązania
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
	COUNT(*) AS 'Liczba zamowien',
	SUM(SOH.TotalDue) AS 'Laczna wartosc sprzedazy'
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
	AVG(DATEDIFF(day, SOH.OrderDate, SOH.ShipDate)) AS 'Sredni czas realizacji zamowienia'
FROM Sales.SalesOrderHeader AS SOH
	JOIN Sales.SalesTerritory AS ST
	ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name
ORDER BY ST.Name
--

-- zad. 12
SELECT 
	P.Name,
	MAX(SOD.UnitPrice) * 100.0 / MIN(SOD.UnitPrice)
FROM Sales.SalesOrderDetail AS SOD
	JOIN Production.Product AS P
	ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY MAX(SOD.UnitPrice) * 100.0 / MIN(SOD.UnitPrice) DESC
--

-- zad. 13
SELECT
	P.Name,
	AVG(DATEDIFF(day, POH.OrderDate, SOH.OrderDate)) AS 'Srednia ilosc dni od zakupu od dowstawcy do sprzedazy klientowi'
FROM Production.Product AS P
	JOIN Purchasing.PurchaseOrderDetail AS POD
	ON P.ProductID = POD.ProductID
	JOIN Purchasing.PurchaseOrderHeader AS POH
	ON POD.PurchaseOrderID = POH.PurchaseOrderID
	JOIN Sales.SalesOrderDetail AS SOD
	ON P.ProductID = SOD.ProductID
	JOIN Sales.SalesOrderHeader AS SOH
	ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE POH.OrderDate <= SOH.OrderDate
GROUP BY P.Name
ORDER BY P.Name


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