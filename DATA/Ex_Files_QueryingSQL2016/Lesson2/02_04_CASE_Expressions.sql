USE AdventureWorks2014;
GO

-- Run this portion to see an example of the values
-- that are stored in the PersonType column
-- They are abbreviations and for the most part, users
-- of your resultset, will not understand what these mean
SELECT FirstName, LastName, PersonType 
FROM Person.Person;
GO


-- To alleviate the issues with the abbreviations, we use a CASE statement
-- In this instance, we are using the CASE to match values in the PersonType column
-- the WHEN keyword tells SQL Server that "when" it finds 'SC' in the results
-- it should "then" change it in our displayed output to Store Contact
-- The ELSE statement is a default case when there is a value found that
-- doesn't match one of the WHEN clauses
-- Finish your CASE statement with the END keyword
-- Optionally use the AS keyword to indicate a column alias for the output
SELECT FirstName, LastName,
CASE PersonType
		WHEN 'SC' THEN 'Store Contact'
		WHEN 'IN' THEN 'Individual Customer'
		WHEN 'SP' THEN 'Sales Person'
		WHEN 'EM' THEN 'Employee'
		WHEN 'VC' THEN 'Vendor Contact'
		WHEN 'GC' THEN 'General Contact'
		ELSE 'Unknown Person Type'
END AS [Type of Contact]
FROM Person.Person;
GO