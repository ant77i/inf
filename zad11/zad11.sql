-- 1
CREATE LOGIN Leo WITH PASSWORD = 'SecurePassword!@#1'
USE VLO2025
CREATE USER Leo FOR LOGIN Leo
ALTER ROLE db_owner ADD MEMBER Leo
GO

CREATE LOGIN GuestB WITH PASSWORD = 'SecurePassword!@#2'
USE VLO2025
CREATE USER GuestB FOR LOGIN GuestB
GRANT SELECT ON SCHEMA::HR TO GuestB
GO
-- 1a
GRANT EXECUTE ON SCHEMA::HR TO GuestB
GO
--


CREATE TABLE HR.Dane (
    Klucz INT PRIMARY KEY,
    Nazwa NVARCHAR(100),
    Wartosc DECIMAL(10,2),
    Czas DATETIME,
    Liczba INT
)

CREATE TABLE HR.Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(255) NULL,
    Phone NVARCHAR(50) NULL
)

CREATE TABLE HR.FinancialTransactions (
    TransactionID INT PRIMARY KEY,
    Amount DECIMAL(10,2),
    TransactionDate DATETIME,
    Description NVARCHAR(255),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES HR.Customers(CustomerID)
)


CREATE TABLE HR.AuditLogs (
    LogID INT PRIMARY KEY,
    OperationType NVARCHAR(50),
    TableName NVARCHAR(100),
    OldValue NVARCHAR(1000) NULL,
    NewValue NVARCHAR(1000) NULL,
    ChangedBy NVARCHAR(100),
    ChangeDate DATETIME
)

CREATE TABLE HR.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(255),
    Category NVARCHAR(100),
    Price DECIMAL(10,2),
    StockQuantity INT
)

CREATE TABLE HR.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES HR.Customers(CustomerID)
)

CREATE TABLE HR.OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES HR.Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES HR.Products(ProductID)
)

CREATE TABLE HR.Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    HireDate DATETIME,
    Position NVARCHAR(100)
)

CREATE TABLE HR.Invoices (
    InvoiceID INT PRIMARY KEY,
    CustomerID INT,
    InvoiceDate DATETIME,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES HR.Customers(CustomerID)
)

CREATE TABLE HR.Payments (
    PaymentID INT PRIMARY KEY,
    InvoiceID INT,
    PaymentDate DATETIME,
    Amount DECIMAL(10,2),
    FOREIGN KEY (InvoiceID) REFERENCES HR.Invoices(InvoiceID)
)
GO

-- 2
CREATE VIEW HR.v_Customers AS
	SELECT 
		C.CustomerID,
		CONCAT(C.FirstName, ' ', C.LastName) AS FullName,
		C.Email,
		C.Phone,
		I.InvoiceID,
		I.InvoiceDate,
		I.TotalAmount,
		PY.PaymentID,
		PY.PaymentDate,
		PY.Amount
		FROM HR.Customers AS C
			LEFT JOIN HR.Invoices AS I
				ON C.CustomerID = I.CustomerID
			LEFT JOIN HR.Payments AS PY
				ON PY.InvoiceID = I.InvoiceID;
GO

CREATE VIEW HR.v_Products AS
	SELECT 
		P.ProductID,
		P.ProductName,
		P.Price AS ProductPrice,
		P.Category,
		P.StockQuantity,
		OD.Price AS OrderPrice,
		OD.Quantity,
		O.OrderDate,
		O.TotalAmount
		FROM HR.Products AS P
			LEFT JOIN HR.OrderDetails AS OD
				ON P.ProductID = OD.ProductID
			LEFT JOIN HR.Orders AS O
				ON O.OrderID = OD.OrderID
GO
--

-- 3
CREATE PROCEDURE HR.addRecord
	@CustomerID INT,
	@FirstName NVARCHAR(100),
	@LastName NVARCHAR(100),
	@Email NVARCHAR(255),
	@Phone NVARCHAR(50)
	AS
	BEGIN
		INSERT INTO HR.Customers VALUES (Custom
	