-- zad 1
DELETE FROM Sales.Customer WHERE CustomerID = 50000
--

-- zad 2
DELETE FROM Sales.SalesOrderHeader WHERE SalesOrderID = 75123
--

-- zad 3
DELETE FROM Production.Product WHERE Name = 'Bikes' AND ProductSubcategoryID = 1
-- 

-- zad 4
DELETE FROM Sales.SalesOrderHeader WHERE OrderDate < '01-01-2022'
-- usuwa wszystko bo najnowsza data to 2014

-- zad 5
DELETE FROM HumanResources.Employee WHERE BusinessEntityID = 3000
--

-- zad 6
DELETE FROM Sales.SalesOrderHeader WHERE CustomerID = 30000
--

-- zad 7
DELETE FROM Production.Product WHERE ListPrice > 10000
--

-- zad 8
DELETE FROM HumanResources.Employee WHERE BusinessEntityID NOT IN 
(
    SELECT SalesPersonID FROM Sales.SalesOrderHeader
)
--

-- zad 9
SELECT * FROM 

    Sales.SalesOrderDetail AS SOD
    JOIN Production.Product AS P
    ON SOD.ProductID = P.ProductID
    JOIN Production.ProductSubcategory AS PS
    ON P.ProductSubcategoryID = PS.ProductSubcategoryID
    JOIN Production.ProductCategory AS PC
    ON PS.ProductCategoryID = PC.ProductCategoryID

WHERE PC.ProductCategoryID = 2
--
-- w treści zadania błąd
-- ProductCategoryID = 3 nie odpowiada 'Components', ID = 2 to 'Components'

-- zad 10
DELETE FROM Person.Person WHERE LastName LIKE 'Test%'
--