SELECT * FROM Audit.PersonChanges

-- dodawanie nowej kolumny do tabeli
ALTER TABLE Audit.PersonChanges ADD UserName NVARCHAR(50)

-- usuwanie kolumny
ALTER TABLE Audit.PersonChanges DROP COLUMN UserName

-- modyfikacja istniejacej kolumny
ALTER TABLE Audit.PersonChanges ALTER COLUMN UserName NVARCHAR(5)

-- dodawanie klucza obcego
ALTER TABLE Audit.PersonChanges ADD CONSTRAINT FK_Person_Person FOREIGN KEY (PersonID) REFERENCES Person.Person (BusinessEntityID)

-- usuwanie klucza obcego
ALTER TABLE Audit.PersonChanges DROP CONSTRAINT FK_Person_Person

-- zmiana domyslnych wartosci 
ALTER TABLE Audit.PersonChanges ADD CONSTRAINT DF_User_Name DEFAULT 'NN' FOR UserName

-- usuwanie domyslnych wartosci 
ALTER TABLE Audit.PersonChanges DROP CONSTRAINT DF_User_Name 
