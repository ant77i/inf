-- zad 1
CREATE PROCEDURE GetPeople
AS
BEGIN
	SELECT
		*
	FROM 
		Person.Person;
END;
GO
--

-- zad 2
CREATE PROCEDURE GetPersonInfo
	@FirstName NVARCHAR(50)
AS
BEGIN
	SELECT
		*
	FROM 
		Person.Person
	WHERE
		FirstName = @FirstName;
END;
GO
--

-- zad 3
CREATE PROCEDURE AddPerson
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50)
AS
BEGIN
	INSERT INTO Person.BusinessEntity (rowguid, ModifiedDate)
		VALUES (NEWID(), GETDATE())
	INSERT INTO Person.Person (FirstName, LastName, BusinessEntityID, PersonType)
		VALUES (
			@FirstName, 
			@LastName, 
			(SELECT MAX(BusinessEntityID) FROM Person.BusinessEntity),
			'IN'
			);
END;
GO
--

-- zad 4
CREATE PROCEDURE UpdateLastName
	@ID INT,
	@NewLastName NVARCHAR(50)
AS
BEGIN
	UPDATE Person.Person
		SET LastName = @NewLastName
		WHERE BusinessEntityID = @ID;
END;
GO
--

-- zad 5
CREATE PROCEDURE DeletePerson
	@ID INT
AS
BEGIN
	IF @ID IN (SELECT BusinessEntityID FROM HumanResources.Employee)
		DELETE HumanResources.Employee WHERE BusinessEntityID = @ID;
	IF @ID IN (SELECT BusinessEntityID FROM Person.BusinessEntityContact)
		DELETE Person.BusinessEntityContact WHERE BusinessEntityID = @ID;
	IF @ID IN (SELECT BusinessEntityID FROM Person.EmailAddress)
		DELETE Person.EmailAddress WHERE BusinessEntityID = @ID;
	IF @ID IN (SELECT BusinessEntityID FROM Person.Password)
		DELETE Person.Password WHERE BusinessEntityID = @ID;
	IF @ID IN (SELECT BusinessEntityID FROM Person.PersonPhone)
		DELETE Person.PersonPhone WHERE BusinessEntityID = @ID;
	IF @ID IN (SELECT PersonID FROM Sales.Customer)
		DELETE Sales.Customer WHERE PersonID = @ID;
	IF @ID IN (SELECT BusinessEntityID FROM Sales.PersonCreditCard)
		DELETE Sales.PersonCreditCard WHERE BusinessEntityID = @ID;

	IF @ID IN (SELECT BusinessEntityID FROM Person.Person)
		DELETE Person.Person WHERE BusinessEntityID = @ID;
END;
GO

BEGIN TRANSACTION
EXEC DeletePerson @ID = 309
ROLLBACK;

SELECT * FROM Person.Person
