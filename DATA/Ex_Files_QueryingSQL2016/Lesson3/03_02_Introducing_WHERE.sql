USE AdventureWorks2014;
GO

-- Using specific fields in the SELECT clause to filter the attributes to be returned
SELECT LoginID, JobTitle, MaritalStatus 
FROM HumanResources.Employee;
GO


-- Use the WHERE clause to return only the records in the Employee table
-- where the employees are married
SELECT LoginID, JobTitle, MaritalStatus
FROM HumanResources.Employee
WHERE MaritalStatus  ='M';
GO


-- Use the WHERE clause to return only the records in the Employee table
-- where the employees are male
SELECT LoginID, JobTitle, Gender
FROM HumanResources.Employee
WHERE Gender  ='M';
GO


-- Use the WHERE clause to return only the records in the Employee table
-- where employees have 99 hours of vacation time
SELECT *
FROM HumanResources.Employee
WHERE VacationHours = 99;
GO