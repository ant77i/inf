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

