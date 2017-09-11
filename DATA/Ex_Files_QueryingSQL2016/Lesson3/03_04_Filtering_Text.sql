--********************************************
-- 04_04_Filtering_Text.sql
--********************************************

USE AdventureWorks2014;
GO


-- Use the WHERE clause to return only the records in the Employee table
-- where the employees are a manager of some type
-- this example uses the % character for any number of characters
SELECT LoginID, JobTitle
FROM HumanResources.Employee
WHERE JobTitle LIKE '%manager%';
GO

-- Use the LIKE keyword to return records from the Person table
-- where users' first names end in ary
-- this example uses the _ character to represent a single character
SELECT *
FROM Person.Person
WHERE FirstName LIKE '_ary';
GO

-- Use the LIKE keyword to return records from the Person table
-- where users' first names end in ary
-- this example uses the [] characters to represent a single character
-- found within the list of characters in the []
SELECT *
FROM Person.Person
WHERE FirstName LIKE '[g-m]ary';
GO

-- Use the LIKE keyword to return records from the Person table
-- where users' first names end in ary
-- this example uses the [^] characters to represent a single character
-- to exclude in the name searched
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE '[^g]ary';
GO

-- Use the NOT LIKE keywords to return records from the Person table
-- where users' first names do NOT end in ary
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName NOT LIKE '_ary';
GO
