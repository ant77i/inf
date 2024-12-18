SELECT * FROM Sales.CreditCard

-- podstawowa sk³adnia dodawania danych
INSERT INTO Sales.CreditCard (CardType, CardNumber, ExpMonth, ExpYear)
	VALUES ('MasterCard', 11111111111111, 9, 2027)

-- wstawianie wartoœci do wszystkich kolumn
INSERT INTO Sales.CreditCard
	VALUES ('MasterCard', 11111311161111, 9, 2027, '2024-11-27 12:06:59.675')

-- wstawianie wiele wierszy naraz
INSERT INTO Sales.CreditCard (CardType, CardNumber, ExpMonth, ExpYear)
	VALUES 
		('MasterCard', 11151341161111, 9, 2027),
		('MasterCard', 11111311161311, 9, 2027),
		('MasterCard', 11511361161611, 9, 2027)

-- aktualizacje za pomoc¹ update
UPDATE Sales.CreditCard
	SET CardType = 'Visa'
	WHERE CardNumber = '11511361161611'

SELECT * FROM Sales.SalesTaxRate

UPDATE Sales.SalesTaxRate
	SET TaxRate = TaxRate / 2.34

UPDATE Sales.SalesTaxRate
	SET TaxRate = TaxRate * 2.34
	WHERE TaxRate < 7