-- Tworzenie nowych tabel Schem i wbudowanego triggera

IF NOT EXISTS (SELECT 1 FROM SYS.SCHEMAS WHERE name = 'Audit')
BEGIN
	EXEC('CREATE SCHEMA Audit')
END;

CREATE TABLE Audit.CustomerChanges (
	ChangeID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT NOT NULL,
	ChangeType NVARCHAR(10) NOT NULL,
		CHECK (ChangeType IN ('INSERT', 'UPDATE', 'DELETE')),
	OldValue NVARCHAR(MAX) NULL,
	NewValue NVARCHAR(MAX) NULL,
	ChangedBy NVARCHAR(100) NOT NULL,
	ChangeDate DATETIME DEFAULT GETDATE() NOT NULL
)
GO

DROP TABLE Audit.CustomerChanges
GO

CREATE INDEX idx_CustomerChanges_CustomerID
	ON Audit.CustomerChanges (CustomerID);
GO

CREATE INDEX idx_CustomerChanges_ChangeDate
	ON Audit.CustomerChanges (ChangeDate DESC);
GO

CREATE TRIGGER trg_CustomerAudit
	ON Sales.Customer
	AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
	-- DLA INSERTA

	INSERT INTO Audit.CustomerChanges
		(CustomerID, ChangeType, NewValue, ChangedBy)
		SELECT
			i.CustomerID,
			'INSERT',
			CONCAT('Name: ', i.PersonID, ', TerritoryID: ', i.TerritoryID),
			SUSER_NAME()
		FROM inserted i;

	-- DLA UPDATEA

	INSERT INTO Audit.CustomerChanges
		(CustomerID, ChangeType, OldValue, NewValue, ChangedBy)
		SELECT
			i.CustomerID,
			'UPDATE',
			CONCAT('Old Name: ', d.PersonID, ', TerritoryID: ', d.TerritoryID),
			CONCAT('New Name: ', i.PersonID, ', TerritoryID: ', i.TerritoryID),
			SUSER_NAME()
		FROM deleted d
		JOIN inserted i ON d.CustomerID = i.CustomerID

	-- DLA DELETEA

	INSERT INTO Audit.CustomerChanges
		(CustomerID, ChangeType, OldValue, ChangedBy)
		SELECT
			d.CustomerID,
			'DELETE',
			CONCAT('Name: ', d.PersonID, ', TerritoryID: ', d.TerritoryID),
			SUSER_NAME()
		FROM deleted d;
END;

INSERT INTO Sales.Customer
	(PersonID, StoreID, TerritoryID, ModifiedDate)
VALUES (NULL, NULL, 5, GETDATE());
GO

SELECT * FROM Audit.CustomerChanges
