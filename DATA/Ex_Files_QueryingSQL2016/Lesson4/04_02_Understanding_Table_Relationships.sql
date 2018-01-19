--************************************************
-- 04_02_Understanding_Table_Relationships.sql
--************************************************

USE AdventureWorks2014;
GO

SELECT per.FirstName, per.LastName, hre.LoginID
FROM Person.Person as per
JOIN HumanResources.Employee AS hre ON hre.BusinessEntityID = per.BusinessEntityID;
GO