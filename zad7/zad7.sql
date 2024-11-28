SELECT * FROM Person.Address

-- zad 1
INSERT INTO Person.BusinessEntity (rowguid, ModifiedDate)
	VALUES (NEWID(), GETDATE())
INSERT INTO Person.Person (BusinessEntityID, FirstName, LastName, EmailPromotion, PersonType)
	VALUES ((SELECT MAX(BusinessEntityID) FROM Person.BusinessEntity),'Jan', 'Kowalski', 1, 'IN')
--

-- zad 2
INSERT INTO Person.Address (AddressLine1, City, PostalCode, StateProvinceID)
	VALUES ('Polna 1', 'Warszawa', '000-01', 102)
--

-- zad 3
INSERT INTO Production.Product (Name, ProductNumber, StandardCost, ListPrice, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate)
	VALUES ('Custom Product', 'CP-001', 50.0, 100.0, 1.0, 1.0, 1.0, 1.0)
--

-- zad 4
INSERT INTO HumanResources.Department (Name, GroupName)
	VALUES ('Research', 'Science')
--

-- zad 5
INSERT INTO HumanResources.Employee (NationalIDNumber, LoginID, JobTitle, BusinessEntityID, BirthDate, MaritalStatus, Gender, HireDate)
	VALUES (123456789, 
		'adventure-works\jan.kowalski', 
		'Developer', 
		(SELECT BusinessEntityID FROM Person.Person WHERE FirstName = 'Jan' AND LastName = 'Kowalski'),
		'1953-12-04',
		'S',
		'M',
		GETDATE()
		)
--

-- zad 6
INSERT INTO Sales.SalesOrderHeader (OrderDate, DueDate, CustomerID, BillToAddressID, ShipToAddressID, ShipMethodID)
	VALUES (
			GETDATE(), 
			GETDATE(), 
			(SELECT MAX(CustomerID) FROM Sales.Customer),
			(SELECT MAX(AddressID) FROM Person.Address),
			(SELECT MAX(AddressID) FROM Person.Address),
			(SELECT MAX(ShipMethodID) FROM Purchasing.ShipMethod)
	)
--

-- zad 7
INSERT INTO Purchasing.Vendor (Name, CreditRating, PreferredVendorStatus, BusinessEntityID, AccountNumber)
	VALUES (
			'ABC Supplies',
			2, 
			1,
			(SELECT MAX(BusinessEntityID) FROM Person.BusinessEntity),
			'111111111111111'
			)
--

-- zad 8
INSERT INTO Production.Location (Name, CostRate, Availability)
	VALUES (
			'Warehouse 5',
			15.0,
			100.0
			)
--

-- zad 9
INSERT INTO Sales.SpecialOffer (Description, DiscountPct, Type, Category, StartDate, EndDate)
	VALUES (
			'Holiday Sale',
			0.1,
			'Holidays',
			'Reseller',
			GETDATE(),
			GETDATE()
			)
--

-- zad 10
INSERT INTO Production.ProductCategory (Name)
	VALUES (
			'Sports Equipment'
			)
--

-- zad 11
UPDATE Person.Person
	SET LastName = 'Nowak'
	WHERE FirstName = 'Jan'
--

-- zad 12
UPDATE Production.Product
	SET ListPrice = ListPrice + 10.0
	WHERE Name = 'Custom Product'
--

-- zad 13
UPDATE Person.Address
	SET City = 'Kraków'
	WHERE PostalCode = '000-01'
--

-- zad 14
UPDATE HumanResources.Department
	SET Name = 'Advanced Research'
	WHERE Name = 'Research'
--

-- zad 15
UPDATE Production.Location
	SET Availability = 90.0
	WHERE Name = 'Warehouse 5'
--