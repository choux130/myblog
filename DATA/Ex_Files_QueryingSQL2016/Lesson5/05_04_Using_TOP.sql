--******************************************
-- 05_04_Using_TOP.sql
--******************************************

USE AdventureWorks2014;
GO

-- Return all the rows in the Address table to see what the actual
-- row count is.  We will compare this with the next query that
-- uses the TOP keyword to return a specified number of rows
SELECT *
FROM Person.Address;
GO

-- Return the TOP 20 rows in the Address table including all fields
SELECT TOP 20 *
FROM Person.Address;
GO

-- Return the TOP 20 rows in the Address table but only include the 
-- AddressID and City fields to see how you don't need to return
-- all the fields in the table and that the SELECT statement is 
-- the same as any other, with the exception of using the TOP clause
-- Also notice the difference in the returned records from the previous
-- query using TOP.
SELECT TOP 20 AddressID, City
FROM Person.Address;
GO

-- Return the TOP 20 percent of rows in the Address table including all fields
-- Note the row count and compare it to the total row count of 19614 rows
-- 3923 is 20% of 19,614
SELECT TOP 20 PERCENT AddressID, City
FROM Person.Address;
GO


-- Use the ORDER BY clause to change the returned records by looking for 
-- the highest tax rates in the SalesTaxRate table.  ORDER BY must be used
-- to control the returned results.  In this case, we choose descending
-- to get the highest tax rates in the table and sort from highest to lowest.
SELECT TOP (10) WITH TIES TaxRate
FROM Sales.SalesTaxRate
ORDER BY TaxRate DESC;
GO

-- Use the ORDER BY clause again but this time, do not indicate a sort order
-- instead relying on the default ascending order
SELECT TOP (10) TaxRate
FROM Sales.SalesTaxRate
ORDER BY TaxRate;
GO

-- Use the ORDER BY clause to change the returned records by looking for 
-- the highest tax rates in the SalesTaxRate table.  ORDER BY must be used
-- to control the returned results.  In this case, we choose descending
-- to get the highest tax rates in the table and sort from highest to lowest.
-- We also choose to return 20 rows to demonstrate the use of WITH TIES
-- which tells SQL we want to include values that are tied, as in this case
-- the tax rate of $7.00.  This results in more than 20 records returned however
-- to represent the tied values.
SELECT TOP (20) WITH TIES TaxRate
FROM Sales.SalesTaxRate
ORDER BY TaxRate DESC;
GO