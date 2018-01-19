USE AdventureWorks2014;
GO

-- Write a simple SELECT statement that uses string concatenation
-- this query will create an output column called Name
-- and concatenates the last name and first name along with a comma
-- the (+) symbol, also known as the addition operator
-- is what T-SQL uses for string concatenation
SELECT LastName + ', ' + FirstName AS Name
FROM Person.Person;
GO

-- Write a SELECT statement that returns a person's full name in a single column
SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
FROM Person.Person;
GO


-- Write a SELECT statement that returns a the first, middle, and last names
-- of the entries in the Person table
-- This demonstrates a simple query returning specific columns
-- but also demonstrates how we use commas to separate the column names
SELECT FirstName, MiddleName, LastName
FROM Person.Person;
GO

-- Write a SELECT statement that returns a person's full name in a single column
-- This code contains logic errors due to the use of the commas
-- We typically separate column names with the comman in our SELECT satements
-- however, in this instance, we want to use concatenation.
-- This demonstrates a syntax error indicating that when we use concatenation
-- we don't separate the column names with commas
SELECT FirstName, + ' ' + MiddleName, + ' ' + LastName AS [Full Name]
FROM Person.Person;
GO