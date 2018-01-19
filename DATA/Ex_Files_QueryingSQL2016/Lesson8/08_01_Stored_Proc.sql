--******************************************
-- 08_01_Stored_Proc.sql
--******************************************

USE AdventureWorks2014;
GO

-- Here we will create the stored procedure by providing a name for the 
-- procedure.  Note the use of usp as the prefix to indicate this is a
-- user defined stored procedure.  Never use sp_ as that is the prefix
-- used by SQL Server for system stored procedures
-- @LastName and @FirstName are parameters that will be used to store
-- the last and first names passed in from a caller to the stored procedure
CREATE PROCEDURE HumanResources.uspGetEmployeesByName 
    @LastName nvarchar(50), 
    @FirstName nvarchar(50) 
AS 

    SET NOCOUNT ON; -- this is used so the stored procedure doesn't return the row count
	
	-- this portion sets up the actual query that will be executed
    SELECT FirstName, LastName, Department
    FROM HumanResources.vEmployeeDepartmentHistory
    WHERE FirstName = @FirstName AND LastName = @LastName -- here are the parameters being used
    AND EndDate IS NULL;
GO


-- call the stored procedure that we just created
-- You can use EXECUTE or the shorter EXEC command
EXECUTE HumanResources.uspGetEmployeesByName'Ackerman', N'Pilar';


-- Using the shortened EXEC command
EXEC HumanResources.uspGetEmployeesByName @LastName = N'Ackerman', @FirstName = N'Pilar';
GO
