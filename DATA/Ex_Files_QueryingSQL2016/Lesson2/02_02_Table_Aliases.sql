USE AdventureWorks2014;
GO

-- This exercise file demonstrates creating table aliases and column aliases


-- Write a SELECT statement for the Employee table
-- selecting specific attributes and using an alias for the table
-- In this instance, we are using the AS hre clause in the FROM
-- portion.  This creates an alias for the HumanResource.Employee table
-- We can then use the alias in our SELECT statement
SELECT hre.LoginID, hre.JobTitle, hre.HireDate
FROM HumanResources.Employee AS hre;
GO


-- Write a SELECT statement for the Employee table
-- selecting specific attributes and using an alias for the table
-- but include aliases for the attribute column names as well
SELECT hre.LoginID AS [login], hre.JobTitle AS [Title],hre.HireDate AS [Date Hired]
FROM HumanResources.Employee AS hre;
GO