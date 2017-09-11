--******************************************
-- 09_01_Introducing_Query_Execution_Plans.sql
--******************************************

USE AdventureWorks2014;
GO

-- Smple query to show execution plan for a single SELECT statement
SELECT *
FROM Person.Person;
GO

-- Sub-query that returns a single value
-- These are the simplest sub-queries to work with as they return a single
-- value for use in the outer query.
-- Here we ask for the quantity ordered and the total sale value
-- for the item in the SalesOrderDetail table that has the lowest unit price
-- The subquery can also be executed separately.  Highlight it and run that portion
--SET SHOWPLAN_XML ON
--GO

SELECT OrderQty, LineTotal
FROM Sales.SalesOrderDetail
WHERE UnitPrice = 
	(SELECT MIN(UnitPrice)
	FROM Sales.SalesOrderDetail);
GO

-- Use a subquery that returns multiple values
-- In this case, we cannot use the = operator
-- but instead will use the IN clause due to multiple
-- values being returned.
-- Here we look for the first and last name of sales people
-- who have had sales last year that exceeded $2M 
SELECT FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID IN
	(SELECT BusinessEntityID
	FROM Sales.SalesPerson
	WHERE SalesLastYear > 2000000);
GO



