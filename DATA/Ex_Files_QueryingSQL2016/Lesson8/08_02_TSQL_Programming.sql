--******************************************
-- 08_02_TSQL_Programming.sql
--******************************************


-- Using the concept of creating a view and then querying that view,
-- we show how the batches are created through the use of the GO keyword.
-- This is the first batch that the DB engine will execute.
USE AdventureWorks2014;
GO

-- After executing the previous batch, where we tell SQL Server what database to use
-- we create our view.  Note that this will be the second batch executed in the entire
-- sql script that we have created here.
CREATE VIEW HumanResources.vEmployeeDetails
AS
SELECT p.Title, p.FirstName, p.LastName, e.JobTitle, e.HireDate
FROM Person.Person AS p
INNER JOIN HumanResources.Employee AS e ON p.BusinessEntityID = e.BusinessEntityID
WHERE p.PersonType = 'EM';
GO


-- finally, this third batch will be executed.   It's important to note that if we attempt
-- to execute this portion of the batch before any of the others above, we will receive
-- an error message that HumanResources.vEmployeeDetails is an invalid object name.
-- That is because until you run the previous CREATE VIEW statement, this view doesn't exist.
-- However, if we run the entire script at once, all is well and good because the batches
-- are executed in order from top to bottom.
-- NOTE: SQL Server's intellisense knows about this view even before we execute it though.
SELECT *
FROM HumanResources.vEmployeeDetails;
GO

-- Demonstrate variables using a stored procedure
-- The @ symbol is used to designate a variable and is followed
-- by the name used for the variable.
-- NOTE: Variables MUST be declared before they are used.  In this case
-- the @LastName variable is declared in the CREATE PROCEDURE portion 
-- which makes it available in the SELECT portion
-- You can also use the DECLARE keyword to declare a variable
-- such as DECLARE @LastName nvarchar(50)

CREATE PROCEDURE HumanResources.uspGetEmployeesByLastName 
    @LastName nvarchar(50) 
AS 

    SET NOCOUNT ON; -- this is used so the stored procedure doesn't return the row count
	
	-- this portion sets up the actual query that will be executed
    SELECT FirstName, LastName, Department
    FROM HumanResources.vEmployeeDepartmentHistory
    WHERE LastName = @LastName -- here is the parameter being used
    AND EndDate IS NULL;
GO

-- call the stored procedure that we just created
-- You can use EXECUTE or the shorter EXEC command
EXECUTE HumanResources.uspGetEmployeesByLastName 'Ackerman';


-- You can use IF...ELSE to control flow based on Boolean conditions
-- Boolean conditions are either a true or a false result
-- This sample is taken directly from the SQL Server Books Online samples
-- and demonstrates the use of IF...ELSE
-- Here we are checking to see if the number of products, with the text
-- Touring-3000 in the name, is greater than 5.  If the result is true,
-- then we print out a statement to the results window based on the 
-- the result returned.  The ELSE clause prints a different message 
-- for a false result
USE AdventureWorks2014;
GO

IF 
(SELECT COUNT(*) FROM Production.Product WHERE Name LIKE 'Touring-3000%' ) > 5
PRINT 'There are more than 5 Touring-3000 bicycles.'
ELSE PRINT 'There are 5 or less Touring-3000 bicycles.' ;
GO


-- Using BEGIN and END can help us control groups of statements. 
-- This is similar to batching
USE AdventureWorks2014;
GO

-- declare some variables for use in the script
DECLARE @AvgWeight decimal(8,2), @BikeCount int

-- set up and IF statement like above, checking the number of Touring-3000 products
-- and then setup a statement block using BEGIN.
IF 
(SELECT COUNT(*) FROM Production.Product WHERE Name LIKE 'Touring-3000%' ) > 5
BEGIN
	-- Set a value for the @BikeCount variable based on a query for the count of those products
   SET @BikeCount = 
        (SELECT COUNT(*) 
         FROM Production.Product 
         WHERE Name LIKE 'Touring-3000%');

    -- Set a value for the @AvgWeight variable using the AVG math function
   SET @AvgWeight = 
        (SELECT AVG(Weight) 
         FROM Production.Product 
         WHERE Name LIKE 'Touring-3000%');

    -- print out messages based on the results
   PRINT 'There are ' + CAST(@BikeCount AS varchar(3)) + ' Touring-3000 bikes.'
   PRINT 'The average weight of the top 5 Touring-3000 bikes is ' + CAST(@AvgWeight AS varchar(8)) + '.';


-- This END keyword marks the end of the statement block that was started with BEGIN
END

-- Setup the messages for the case of a false return from IF
ELSE 
BEGIN
SET @AvgWeight = 
        (SELECT AVG(Weight)
         FROM Production.Product 
         WHERE Name LIKE 'Touring-3000%' );
   PRINT 'Average weight of the Touring-3000 bikes is ' + CAST(@AvgWeight AS varchar(8)) + '.' ;
END ;
GO