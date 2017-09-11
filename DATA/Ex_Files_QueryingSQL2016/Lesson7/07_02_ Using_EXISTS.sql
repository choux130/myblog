--******************************************
-- 07_02_ Using_EXISTS.sql
--******************************************

USE AdventureWorks2014;
GO


-- Using EXISTS predicate to check for existence of records in a subquery
-- In this instance, we are looking for customer account numbers who place orders online.
-- We do this by using EXISTS to check which records in the subquery,
-- in this case the SalesOrderHeader table, match the customer IDs and that also have
-- the online order flag set to 1.
-- We might run such a query to determine which customers place online orders so that
-- we can send them specials or other notification types.
SELECT AccountNumber
FROM Sales.Customer AS c
WHERE EXISTS
	(SELECT *
	FROM Sales.SalesOrderHeader AS soh
	WHERE c.CustomerID = soh.CustomerID
	AND OnlineOrderFlag = 1);
GO



-- We can also negate the results if we are looking for records that are NOT in the subquery
-- In this instance, we are looking for customer account numbers who do NOT place orders online.
-- We do this by using NOT EXISTS to check which records in the subquery.
SELECT AccountNumber
FROM Sales.Customer AS c
WHERE NOT EXISTS
	(SELECT *
	FROM Sales.SalesOrderHeader AS soh
	WHERE c.CustomerID = soh.CustomerID
	AND OnlineOrderFlag = 1);
GO