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