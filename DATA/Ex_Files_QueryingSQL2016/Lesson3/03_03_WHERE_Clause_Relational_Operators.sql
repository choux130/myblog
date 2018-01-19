--*********************************************
-- 04_03_WHERE_Clause_Relational_Operators.sql
--*********************************************

USE AdventureWorks2014;
GO

-- Use the WHERE clause to return only the records in the Employee table
-- where the employees are married
SELECT LoginID, JobTitle, MaritalStatus
FROM HumanResources.Employee
WHERE MaritalStatus  ='M';
GO

-- Use the WHERE clause to return only the records in the Employee table
-- where the employees' level in the organization is above 2
SELECT LoginID, JobTitle, OrganizationLevel
FROM HumanResources.Employee
WHERE OrganizationLevel > 2;
GO

-- Use the WHERE clause to return only the records in the Employee table
-- where the employees' level in the organization is less than or equal to 2
SELECT LoginID, JobTitle, OrganizationLevel
FROM HumanResources.Employee
WHERE OrganizationLevel  <= 2;
GO


-- Use the OR operator to return records from the Person table
-- where the contact type is either single contact (SC) or vendor contact (VC)
SELECT FirstName, LastName, PersonType
FROM Person.Person
WHERE PersonType = 'SC' 
OR PersonType = 'VC';
GO

-- Use the AND operator to return records from the Person table
-- where the contact type is single contact (SC)
-- and they are in category 2 for email promotions
SELECT FirstName, LastName, PersonType, EmailPromotion
FROM Person.Person
WHERE PersonType = 'SC' 
AND EmailPromotion = 2;
GO

-- Use the IN operator to return records from the Person table
-- where the persons' first name is in a range of names supplied
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName IN('Fred', 'Mary', 'George');
GO

-- Use the BETWEEN operator to return records from the Employee table
-- where the employees' have sick leave time between 40 and 99 hours
SELECT LoginID, SickLeaveHours
FROM HumanResources.Employee
WHERE SickLeaveHours BETWEEN 40 AND 99;
GO