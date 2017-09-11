--******************************************
-- 06_03_ Queries_Using_Character_Functions.sql
--******************************************

USE AdventureWorks2014;
GO


-- Combine character values together using string concatenation. 
-- the + symbol, most commonly used for mathematical addition, is the character
-- used for concatenating (adding) one string with another.
-- NOTE: We do not include a comma field separator in the field list
-- as in a regular query
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Person.Person;
GO

-- Combine character values together using string concatenation. 
-- the + symbol, most commonly used for mathematical addition, is the character
-- used for concatenating (adding) one string with another.
-- NOTE: We do not include a comma field separator in the field list
-- as in a regular query
-- What happens when a field contains a NULL?
SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
FROM Person.Person;
GO

-- Combine character values together using string concatenation. 
-- the + symbol, most commonly used for mathematical addition, is the character
-- used for concatenating (adding) one string with another.
-- NOTE: We do not include a comma field separator in the field list
-- as in a regular query
-- What happens when a field contains a NULL?  In this case, we use the
-- COALESCE function to replace any NULL values with a space
SELECT FirstName + ' ' + COALESCE(MiddleName,'') + ' ' + LastName AS [Full Name]
FROM Person.Person;
GO

-- When it comes to character data, you sometimes may want to know how long a value
-- is.  This might be necessary if your query is extracting text strings and you
-- need to be sure they are the right length for use in an application.  
-- SQL provides the LEN function to return the length of the string
SELECT LastName, LEN(LastName) AS [Last Name Length]
FROM Person.Person;
GO

-- Or perhaps we need to know how large the string is in terms of bytes
-- rather than characters.
SELECT LastName, LEN(LastName) AS [Last Name Length], DATALENGTH(LastName) AS [Last Name Bytes]
FROM Person.Person;
GO

-- We can also replace text in a string
-- with the REPLACE function.  Perhaps you don't want to allow apostrophes
-- in your data so you want to replace them with a blank.  For people with 
-- a last name like mine, O'Brien, this is the most annoying aspect when 
-- filling out online forms and this simple function negates the need
-- to punt back to the user about illegal characters in a name
SELECT LastName, REPLACE(LastName, '''', '')
FROM Person.Person
WHERE LastName LIKE '%''%';
GO

-- We can also repeat characters in a query.  Although is more suitable for 
-- data input rather than returning results form a query.  You might have an
-- application that requires padding of values that fall below a minimum length
-- Here we don't query any field in a table but simply call the function to
-- return a value of 10 letter A's according to the function parameters.
SELECT REPLICATE('A', 10);
GO

-- We can also format strings though the use of functions for change to/from
-- upper and lower case.  Here we convert the first names to all lower case
-- and the last names to all upper case
SELECT LOWER(FirstName), UPPER(LastName)
FROM Person.Person;
GO

-- Sometimes, when data is entered into a database manually, values may have
-- spaces at the beginning or end.  This can cause issues with queries because
-- you might be searching for a name you know exists and are not getting any 
-- results, because there is a space at the beginning or end.  Use the TRIM functions
-- to remove any leading (LTRIM) or trailing (RTRIM) spaces.
-- Here, we combine the functions to perform both trims in one pass
-- Of course, you can't see that the spaces are trimmed because, well,
-- you can't always see spaces at the beginning or end of text.
SELECT RTRIM(LTRIM(FirstName))
FROM Person.Person;
GO

-- And finally, we can use the SUBSTRING function to deal with values within strings.
-- Let's assume you want to extract the first 3 characters from a text value.
-- Use 1 as the starting character and 3 to indicate how many characters
-- You can start anywhere within the string you want
SELECT SUBSTRING(FirstName,1,3), FirstName
FROM Person.Person;
GO

-- Use LEFT or RIGHT to return the number of characters at the beginning or
-- the end, repsectively, or a string
SELECT FirstName, LEFT(FirstName,3), RIGHT(FirstName,3)
FROM Person.Person;
GO