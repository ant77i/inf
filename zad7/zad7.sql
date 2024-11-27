SELECT * FROM Person.Address

-- zad 1
INSERT INTO Person.BusinessEntity (rowguid, ModifiedDate)
	VALUES (NEWID(), GETDATE())
INSERT INTO Person.Person (BusinessEntityID, FirstName, LastName, EmailPromotion, PersonType)
	VALUES ((SELECT MAX(BusinessEntityID) FROM Person.BusinessEntity),'Jan', 'Kowalski', 1, 'IN')

-- zad 2
SELECT * FROM Person.StateProvince
INSERT INTO Sales.SalesTerritory (Name, CountryRegionCode, [Group])
	VALUES ('Poland', 'PL', 'Europe')
INSERT INTO Person.StateProvince (StateProvinceCode, CountryRegionCode, Name, TerritoryID)
	VALUES ('96', 'PL', 'Mazowieckie', 11)
DELETE 
INSERT INTO Person.Address (AddressLine1, City, PostalCode, StateProvinceID)
	VALUES ('Polna 1', 'Warszawa', 00001, )