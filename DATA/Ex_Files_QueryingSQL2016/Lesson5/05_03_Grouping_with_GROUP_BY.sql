--********************************************
-- 05_03_Grouping_with_GROUP_BY.sql
--********************************************

USE AdventureWorks2014;
GO

-- Use GROUP BY to group the results returned
-- in this case, by City name.
SELECT City
FROM Person.Address
GROUP BY City;
GO

-- Return all the records in the Address table just to show the difference in the row count
-- that takes place when using GROUP BY.  Use ORDER BY to show the number of times a city
-- name repeats in the table as well.
SELECT City 
FROM Person.Address
ORDER BY City;
GO


-- This query will generate an error because the AddressLine1 field is not
-- part of an aggregate function, like COUNT in the first query, nor is it 
-- part of the GROUP BY clause
SELECT City, AddressLine1
FROM Person.Address
GROUP BY City;
GO


-- This query fixes the error because the AddressLine1 field is now
-- part of the GROUP BY clause.  It doesn't make much sense because the 
-- grouping isn't logical on the AddressLine1 field, but we can see how 
-- the inclusion in the GROUP BY clause, allows us to return multiple fields.
-- Also notice that the city names are now expanded rather than just one entry per city
SELECT City, AddressLine1
FROM Person.Address
GROUP BY City, AddressLine1;
GO


-- Return the city name and the number of addresses in the table
-- that are in each city.  Rename the number of cities column to Totals
SELECT City, COUNT(*) AS Totals
FROM Person.Address
GROUP BY City;
GO
