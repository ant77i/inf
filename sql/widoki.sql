SELECT * FROM Audit.PersonChanges
GO;

-- podstawowy widok
CREATE VIEW vw_EmployeesInfo AS
	SELECT P.FirstName, P.LastName,E.JobTitle
	FROM HumanResources.Employee E
		JOIN Person.Person P
			ON E.BusinessEntityID = P.BusinessEntityID;
GO;

-- wywo³ywanie
SELECT * FROM vw_EmployeesInfo
GO;

-- raport sprzedazy klientow
CREATE VIEW vw_CustomerSalesReport AS
	SELECT 
		C.CustomerID,
		CONCAT(P.FirstName, ' ', P.LastName) AS FullName,
		A.AddressLine1,
		A.City,
		A.StateProvinceID,
		A.PostalCode,
		SOH.SalesOrderID,
		SOH.OrderDate,
		SOH.DueDate,
		SOH.ShipDate,
		SOH.TotalDue AS OrderTotal,
		SOD.ProductID,
		PR.Name AS ProductName,
		PR.ListPrice,
		SOD.OrderQty,
		SOD.LineTotal AS ProductTotal,
		PC.Name AS ProductCategory
		FROM Sales.Customer AS C
			JOIN Person.Person AS P
				ON C.CustomerID = P.BusinessEntityID
			JOIN Sales.SalesOrderHeader AS SOH
				ON C.CustomerID = SOH.CustomerID
			JOIN Sales.SalesOrderDetail AS SOD
				ON SOH.SalesOrderID = SOD.SalesOrderID
			JOIN Production.Product AS PR
				ON SOD.ProductID = PR.ProductID
			JOIN Production.ProductSubcategory AS PRS
				ON PR.ProductSubcategoryID = PRS.ProductSubcategoryID
			JOIN Production.ProductCategory AS PC
				ON PRS.ProductCategoryID = PC.ProductCategoryID
			LEFT JOIN Person.Address AS A
				ON SOH.BillToAddressID = A.AddressID
GO;

SELECT * FROM vw_CustomerSalesReport
GO;

SELECT 
	CustomerID,
	FullName,
	AddressLine1,
	City,
	SP.Name AS ProvinceName,
	PostalCode,
	SalesOrderID,
	OrderDate,
	DueDate,
	ShipDate,
	OrderDate,
	ProductID,
	ProductName,
	ListPrice,
	OrderQty,
	ProductTotal,
	ProductCategory
	FROM vw_CustomerSalesReport
	JOIN Person.StateProvince AS SP
		ON vw_CustomerSalesReport.StateProvinceID = SP.StateProvinceID