-- zad 1
DELETE FROM Sales.Customer WHERE CustomerID = 50000
--

-- zad 2
DELETE FROM Sales.SalesOrderHeader WHERE SalesOrderID = 75123
--

BEGIN TRANSACTION;
-- zad 3
INSERT INTO Production.Product (Name, ProductNumber, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, ProductSubcategoryID)
	VALUES ('Rower', 'RW-0007', 1, 1, 1, 1, 1, GETDATE(), 1)
SELECT * FROM Production.Product WHERE Name = 'Rower'
DELETE FROM Production.Product WHERE ProductSubcategoryID = 1 AND Name = 'Rower'
-- 
ROLLBACK;


-- zad 4
DELETE FROM Sales.SalesOrderHeader WHERE OrderDate < '01-01-2022'
-- usuwa wszystko bo najnowsza data to 2014

-- zad 5
DELETE FROM HumanResources.Employee WHERE BusinessEntityID = 3000
--

-- zad 6
DELETE FROM Sales.SalesOrderHeader WHERE CustomerID = 30000
--


BEGIN TRANSACTION;
-- zad 7
INSERT INTO Production.Product (Name, ProductNumber, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate)
	VALUES ('Rower', 'RW-0007', 1, 1, 1, 10001, 1, GETDATE())
DELETE FROM Production.Product WHERE ListPrice > 10000
--
ROLLBACK;

-- zad 8
DELETE FROM HumanResources.Employee WHERE BusinessEntityID NOT IN 
(
    SELECT SalesPersonID FROM Sales.SalesOrderHeader
)
--

-- zad 9
BEGIN TRANSACTION;
DELETE Sales.SalesOrderDetail FROM 

    Sales.SalesOrderDetail AS SOD
    JOIN Production.Product AS P
    ON SOD.ProductID = P.ProductID
    JOIN Production.ProductSubcategory AS PS
    ON P.ProductSubcategoryID = PS.ProductSubcategoryID
    JOIN Production.ProductCategory AS PC
    ON PS.ProductCategoryID = PC.ProductCategoryID

WHERE PC.ProductCategoryID = 2
ROLLBACK;
--
-- w treści zadania błąd
-- ProductCategoryID = 3 nie odpowiada 'Components', ID = 2 to 'Components'

-- zad 10
BEGIN TRANSACTION;
DELETE FROM Person.Person WHERE LastName LIKE 'Test%'
ROLLBACK;
--