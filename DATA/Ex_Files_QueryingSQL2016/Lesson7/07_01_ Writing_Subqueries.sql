--******************************************
-- 07_01_ Writing_Subqueries.sql
--******************************************

USE AdventureWorks2014;
GO


-- Sub-query that returns a single value
-- These are the simplest sub-queries to work with as they return a single
-- value for use in the outer query.
-- Here we ask for the quantity ordered and the total sale value
-- for the item in the SalesOrderDetail table that has the lowest unit price
-- The subquery can also be executed separately.  Highlight it and run that portion
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

-- Use a correlated subquery that references a field in the
-- SalesOrderDetail table and returns the minimum price
-- This query correlates the SalesOrderID between the two queries
-- even though they are the same table.
-- The results will be more than one row, which is in contrast
-- to the first query we executed above which returned one row.
SELECT OrderQty, LineTotal
FROM Sales.SalesOrderDetail AS s1
WHERE UnitPrice = 
	(SELECT MIN(UnitPrice)
	FROM Sales.SalesOrderDetail s2
	WHERE s1.SalesOrderID = s2.SalesOrderID);
GO


