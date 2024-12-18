-- Procedury
CREATE PROCEDURE GetCustomerOrders
	@CustomerID INT
	AS
	BEGIN
		SELECT
			SOH.SalesOrderID,
			SOH.OrderDate,
			SOH.TotalDue,
			SOH.ShipDate
		FROM 
			Sales.SalesOrderHeader AS SOH
		WHERE
			CustomerID = @CustomerID;
	END;
GO

-- procedura 2 aktualizowanie pracownika
CREATE PROCEDURE UpdateEmployeeInfo
	@BusinessEntityID INT,
	@JobTitle NVARCHAR(50),
	@HireDate DATE
AS
BEGIN
	UPDATE HumanResources.Employee
	SET
		JobTitle = @JobTitle,
		HireDate = @HireDate,
		ModifiedDate = GETDATE()
	WHERE
		BusinessEntityID = @BusinessEntityID;
END;
GO

-- modyfikacja procedury
ALTER PROCEDURE UpdateEmployeeInfo
	@BusinessEntityID INT,
	@JobTitle NVARCHAR(50),
	@Gender NCHAR(1),
	@HireDate DATE
AS
BEGIN
	UPDATE HumanResources.Employee
	SET
		JobTitle = @JobTitle,
		HireDate = @HireDate,
		Gender = @Gender,
		ModifiedDate = GETDATE()
	WHERE
		BusinessEntityID = @BusinessEntityID;
END;
GO

IF OBJECT_ID('UpdateEmployeeInfo') IS NOT NULL
	DROP PROCEDURE UpdateEmployeeInfo;
GO