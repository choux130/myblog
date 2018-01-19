USE AdventureWorks2014;
GO

SELECT *
FROM Person.Person;
GO

SELECT PersonType
FROM Person.Person;
GO

SELECT DISTINCT PersonType
FROM Person.Person;
GO

SELECT DISTINCT PersonType, EmailPromotion
FROM Person.Person;
GO