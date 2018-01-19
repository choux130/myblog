--**********************************************
-- 05_02_Sorting_with_ORDER_BY.sql
--**********************************************

USE AdventureWorks2014;
GO

-- Straightforward query with no order specified.
-- Records are returned in the order the database engine determines
SELECT BusinessEntityID, FirstName, MiddleName, LastName
FROM Person.Person;
GO


-- Change the order of the records by ordering the results on BusinessEntityID
SELECT BusinessEntityID, FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY BusinessEntityID;
GO

-- Change the order of the records by ordering the results in reverse order
-- based on the last name field.
SELECT BusinessEntityID, FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY LastName DESC;
GO

-- Change the order of the records by ordering the results alphabetically
-- based on the first name and the last name with the first name taking precedence.
SELECT FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY FirstName, LastName;
GO

-- Change the order of the records by ordering the results alphabetically
-- based on the first name to show the difference between an ORDER BY
-- used on the first name only as opposed to first then last.
-- Note the order, or lack of order, for the last names in this version
SELECT FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY FirstName;
GO

-- Change the order of the records by ordering the results alphabetically
-- based on the first name and then last name but in this instance, 
-- do not use the field name but rather use the ordinal positions 
-- to show how the results sort.
-- NOTE, this is not a good practice and is only demonstrated for awareness
SELECT FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY 1, 3;
GO

-- Change the order of the records by ordering the results
-- based on the BusinessEntityID that isn't included in the output
-- to show that the order is still applied even though the field
-- is not included in the result list.  It's also hard to tell how
-- the order was factored so this could cause confusion in the results.
SELECT FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY BusinessEntityID;
GO

-- Change the order of the records by ordering the results alphabetically
-- based on the middle name to show how the NULL impacts the results.
-- NULL affects the results because it is unknown and will show up in the results
-- ahead of any other value.
SELECT FirstName, MiddleName, LastName
FROM Person.Person
ORDER BY MiddleName;
GO