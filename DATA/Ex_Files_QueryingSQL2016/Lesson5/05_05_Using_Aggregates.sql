--******************************************
-- 05_05_Using_aggregates.sql
--******************************************

USE AdventureWorks2014;
GO

-- Use COUNT to determine the number of records that match a criteria 
-- in this case, we want to know how many employees we have in the table
-- so we use the COUNT(*) clause
SELECT COUNT(*)
FROM HumanResources.Employee;
GO

-- Use COUNT with DISTINCT to determine the number of records that match a criteria 
-- in this case, we want to know how many titles we have for employees
-- so we use the COUNT(DISTINCT JobTitle) clause
SELECT COUNT(DISTINCT JobTitle) AS [Number of Titles]
FROM
HumanResources.Employee;
GO

-- Use the average (AVG) function to calculate the average number of vacation hours
-- that employees have accumulated
SELECT AVG(VacationHours) AS [Avg Vacation Hours]
FROM HumanResources.Employee;
GO

-- Use MAX to return the maximum value in an expression
-- In this case we check to see what the maximum number of vacation
-- hours an employee has accumulated
-- MAX ignores NULL values but will work on character values
-- and uses the configured collating sequence of the SQL instance
SELECT MAX(VacationHours) AS [Max Vacation]
FROM HumanResources.Employee;
GO

-- Use MIN to return the minimum value in an expression
-- In this case we check to see what the lowest number of vacation
-- hours an employee has accumulated
-- MIN ignores NULL values but will work on character values
-- and uses the configured collating sequence of the SQL instance
SELECT MIN(VacationHours) AS [Min Vacation]
FROM HumanResources.Employee;
GO

-- Use SUM to return the cumulative value in an expression
-- In this case we check to see what the total number of vacation
-- hours all employees have accumulated
SELECT SUM(VacationHours) AS [Total Vacation]
FROM HumanResources.Employee;
GO

-- Use VAR to return the statistical variance of all values in an expression
-- In this case we check to see what the variance is in vacation
-- hours all employees have accumulated
SELECT VAR(VacationHours) AS [Variance]
FROM HumanResources.Employee;
GO

-- You can also mix aggregates in the same query by specifying the function
-- and including the appropriate field name in the parentheses.
-- Here we will check the MIN, MAX, and SUM of vacation hours along with
-- the SUM of sick days and the date of the last employee hire
SELECT MIN(VacationHours) AS [MIN Vacation], 
	MAX(VacationHours) AS [MAX Vacation], 
	SUM(VacationHours) AS [SUM Vacation], 
	SUM(SickLeaveHours) AS [SUM SickLeave], 
	MAX(HireDate) AS [Last Hire Date]
FROM HumanResources.Employee;
GO
