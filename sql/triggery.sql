-- Tworzenie nowej schemy i tabeli do logowania zmian za pomoca triggera
CREATE SCHEMA Audit;
GO

CREATE TABLE Audit.PersonChanges (
	ChangeID INT IDENTITY PRIMARY KEY,
	ChangeType NVARCHAR(20),
	ChangeDate DATETIME,
	PersonID INT,
	OldValue NVARCHAR(50),
	NewValue NVARCHAR(50)
)
GO

-- Tworzenie triggera
CREATE TRIGGER trg_AfterInsertPerson
	ON Person.Person
	AFTER INSERT 
	AS
	BEGIN
		INSERT INTO Audit.PersonChanges (ChangeType, ChangeDate, PersonID, OldValue, NewValue)
		SELECT
			'INSERT',
			GETDATE(),
			i.BusinessEntityID,
			Null,
			i.FirstName
		FROM
			inserted i;
	END;
GO

SELECT * FROM Audit.PersonChanges

INSERT INTO Person.BusinessEntity (rowguid, ModifiedDate)
	VALUES (NEWID(), GETDATE())
INSERT INTO Person.Person (BusinessEntityID, FirstName, LastName, PersonType)
	VALUES ((SELECT MAX(BusinessEntityID) FROM Person.BusinessEntity), 'Jan', 'Jan', 'IN')