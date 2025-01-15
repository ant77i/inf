-- zad 1
ALTER TABLE Person.Person ADD NickName NVARCHAR(50)
--

-- zad 2
ALTER TABLE Person.PersonPhone ALTER COLUMN PhoneNumber NVARCHAR(30)
--

-- zad 3
ALTER TABLE Sales.Customer ADD IsActive BIT
ALTER TABLE Sales.Customer ADD CONSTRAINT DF_Is_Active DEFAULT 1 FOR IsActive
--

-- zad 4
BEGIN TRANSACTION;
ALTER TABLE Person.Person DROP COLUMN Suffix
ROLLBACK;
--

-- zad 5
ALTER TABLE Sales.SalesOrderHeader ADD CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Sales.Customer (CustomerID)
--

-- zad 6
ALTER TABLE Production.ProductDocument ADD CONSTRAINT PK_ProductID PRIMARY KEY (ProductID)
-- ProductDocument juz ma primary key nie wiem co tu zrobic

-- zad 7
BEGIN TRANSACTION;
ALTER TABLE Person.EmailAddress ADD CONSTRAINT UQ_EmailAddress UNIQUE (EmailAddress)
ROLLBACK;
--

-- zad 8
BEGIN TRANSACTION;
ALTER TABLE Person.Person ADD DateCreated DATETIME NOT NULL DEFAULT GETDATE()
ROLLBACK;
--
SELECT * FROM Person.Person

-- zad 9
BEGIN TRANSACTION;
--ALTER TABLE Person.Person RENAME COLUMN MiddleName TO MiddleInitial		-- to nie dzia³aaaaaa RENAME NIE DZIALAA
EXEC sp_rename 'Person.Person.MiddleName', 'MiddleInitial', 'COLUMN'
SELECT * FROM Person.Person
ROLLBACK;

-- zad 10
BEGIN TRANSACTION;
ALTER TABLE Person.EmailAddress DROP CONSTRAINT UQ_EmailAddress
ROLLBACK;
