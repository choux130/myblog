#---
# layout: post
# title: "Start Learning Microsoft SQL Server, T-SQL"
# date: 2017-06-27
# author: Yin-Ting
# categories: [SQL]
# tags: [Commands]
#---

## References
1. [w3schools - SQL](https://www.w3schools.com/SQL/deFault.asp)
2. [LinkdedIn Learning - Microsoft SQL Server 2016: Query Data](https://www.linkedin.com/learning/microsoft-sql-server-2016-query-data/using-the-exercise-files)
3. [Transact-SQL Reference (Database Engine)](https://docs.microsoft.com/en-us/sql/t-sql/language-reference)

# Microsoft SQL Server 2016: Query Data
* SQL server Management Studio (free? )
* Relations in SQL server
  * A relation is represented as Table
  * A tuple is represented as a Row (record) in a Table
  * An attribute is represented as a Column (field) in a Table
  * Attributes have a name and a data type
* Keywords order
  * SELECT
  * FROM
  * WHERE
  * GROUP BY
  * HAVING
  * ORDER BY
  for SQL the order is
  * FROM
  * WHERE
  * GROUP BY
  * HAVING
  * ORDER BY
  * SELECT
* SELECT
  ```sql
  USE databasename;
  GO

  SELECT *
  -- the 'schemaname' is to avoid duplicated 'tablename' in a database
  FROM schemaname.tablename;
  GO


  SELECT fieldname1, fieldname2
  FROM schemaname.tablename;
  GO
  ```
  * If we type FROM first, then when we type SELECT it will have a drop-down list of fields name for us to automatically complete the code. We can use TAB to choose the one be selected instead of clicking with mouse.

* Table and Column Alias (AS)
  ```sql
  USE databasename;
  GO

  -- Table Alias
  SELECT st.fieldname1, st.fieldname2
  FROM schemaname.tablename AS st;
  GO

  -- Column Alias
  SELECT st.fieldname1 AS [fname_1], st.fieldname2 AS [fname_2]
  FROM schemaname.tablename AS st;
  GO
  ```
* String Concatenation
  ```sql
  USE databasename;
  GO

  SELECT lastname + ', ' + firstname AS name
  FROM Person.Person
  GO

  SELECT lastname, middlename, firstname
  FROM Person.Person
  GO

  --- If any field is NULL then concatenation will be NULL.
  SELECT lastname + ' ' + middlename +' ' + firstname AS [full name]
  FROM Person.Person
  GO

  SELECT lastname, + ' ' + middlename, + ' ' + firstname AS [full name]
  FROM Person.Person
  GO
  --- the column names will be lastname, (no column name), full name
  --- because columns are seperated by ","
  ```
* CASE
  ```sql
  USE databasename;
  GO

  SELECT FirstName, LastName, PersonType
  FROM Person.Person;
  GO

  SELECT FirstName, LastName,
  CASE PersonType
    WHEN 'SC' THEN 'Store Contact'
    WHEN 'IN' THEN 'Individual Customer'
    WHEN 'SP' THEN 'Sales Person'
    WHEN 'EM' THEN 'Employee'
    WHEN 'VC' THEN 'Vendor Contact'
    WHEN 'GC' THEN 'General Contact'
    ELSE 'Unknown Person Type' --- put ELSE all the time!
  END AS [Type of Contact]
  FROM Person.Person;
  GO
  --- Expand abbreviation for better understanding for people not knowing the data as you do
  ```
* DISTINCT
  ```sql
  USE databasename;
  GO

  SELECT DISTICT PersonType
  FROM Person.Person
  GO

  SELECT DISTICT PersonType, EmailPromotion
  FROM Person.Person
  GO
  ```
* WHERE
  ```sql
  USE databasename;
  GO

  SELECT LoginID, JobTitle, MaritalStatus
  FROM HumanResources.Employee
  WHERE MaritalStatus = "M";
  GO

  SELECT LoginID, JobTitle
  FROM HumanResources.Employee
  WHERE Gender = "M";
  --- no need to have Gender in SELECT
  GO

  -- WHERE clause relational operator (conditional operator or comparison operator)
  SELECT LoginID, JobTitle, OrganizationLevel
  FROM HumanResources.Employee
  WHERE OrganizationLevel <= 2;
  GO

  SELECT FirstName, Lastname, PersonType
  FROM Person.Person
  WHERE PersonType = 'SC'
  OR PersonType = 'VC';
  GO

  SELECT FirstName, Lastname, PersonType, EmailPromotion
  FROM Person.Person
  WHERE PersonType = 'SC'
  AND EmailPromotion = 2;
  GO

  SELECT FirstName, Lastname
  FROM Person.Person
  WHERE FirstName IN('Fred','Mary','George');
  GO

  SELECT LoginID, SickLeaveHours
  FROM HumanResources.Employee
  WHERE SickLeaveHours BETWEEN 40 AND 99;
  -- include 40 and 99
  GO

  -- filter text
  SELECT LoginID, JobTitle
  FROM HumanResources.Employee
  WHERE JobTitle LIKE '%manger%';
  GO
  -- not case sensitive
  -- could be any characters in front or after the keyword, manger.

  SELECT *
  FROM Person.Person
  WHERE FirstName LIKE '_ary';
  GO
  -- any single character in front of 'ary', like 'Gary', 'Mary'

  SELECT *
  FROM Person.Person
  WHERE FirstName LIKE '[g-m]ary';
  GO
  -- specific range of character, only 'g' to 'm'

  SELECT *
  FROM Person.Person
  WHERE FirstName LIKE '[^g]ary';
  GO
  -- any letter not 'g'

  SELECT *
  FROM Person.Person
  WHERE FirstName NOT LIKE '_ary';
  GO
  -- not end in 'ary'

  -- NULL, it is none defined, can not be compared
  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  WHERE MiddleName <> 'A'; -- not equal, it won't include NULL value
  Go

  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  WHERE MiddleName <> 'A'
  OR MiddleName IS NULL; -- can not use equal, only can use IS NULL
  Go

  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  WHERE MiddleName IS NULL; -- can not use equal, only can use IS NULL
  Go

  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  WHERE MiddleName IS NOT NULL; -- can not use equal, only can use IS NULL
  Go
  ```
* Query Multiple Tables
  * Normalization
    1. Means Organizing your data.
    2. To Reduce data duplication and increase data integrity.
    3. There are 5 common levels of normalization.
    4. Most DBAs will get to about the third normal form. Because the fourth and the fifth need extra work and not impact your database functionalities.
    5. Each additional level add more considerations around data storage and design of tables.
  * First Normal Form (1NF)
    The table contains no repeating group (columns).
  * Second Normal Form (2NF)
    All attributes depend on the primary key.
    This means that values in different columns have dependencies on other columns.
  * Third Normal Form (3NF)
    No attributes in a table that DO NOT depend on the primary key.
  * Relationship between multiple tables
    * Primary Keys
      To ensure uniqueness in a table.
    * Foreign Keys
      Are placed into a related table.
      They DO NOT create uniqueness in the related table.
      They are considered foreign because they are from another table (a foreign table).
  ```sql
  USE databasename;
  GO

  SELECT pre.FirstName, pre.LastName, hre.LoginID
  From Person.Person as pre
  JOIN HumanResources.Employee as hre
  ON hre.BusinessEntitiyID = pre.BusinessEntitiyID;
  GO
  ```
  * JOIN
    * INNER JOIN = JOIN (the default)
    * OUTER JOIN (LEFT, RIGHT, FULL)
    * FULL JOIN
    * CROSS JOIN
    * SELF JOIN
  ```sql
  USE databasename;
  GO

  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.Product p
  INNER JOIN Production.ProductReview pr
  ON p.ProductID = pr.ProductID;
  GO

  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.Product p
  LEFT OUTER JOIN Production.ProductReview pr
  ON p.ProductID = pr.ProductID;
  GO

  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.ProductReview pr
  LEFT OUTER JOIN Production.Product p
  ON p.ProductID = pr.ProductID;
  GO

  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.Product p
  RIGHT OUTER JOIN Production.ProductReview pr
  ON p.ProductID = pr.ProductID;
  GO

  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.ProductReview pr
  RIGHT OUTER JOIN Production.Product p
  ON p.ProductID = pr.ProductID;
  GO

  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.Product p
  FULL OUTER JOIN Production.ProductReview pr
  ON p.ProductID = pr.ProductID;
  GO
  ```

* Grouping and Sorting
  ```sql
  USE databasename;
  GO

  -- The default is ASC
  SELECT BusinessEntitiyID, FirstName, MiddleName, LastName
  FROM Person.Person
  ORDER BY BusinessEntitiyID DESD;
  GO

  SELECT BusinessEntitiyID, FirstName, MiddleName, LastName
  FROM Person.Person
  ORDER BY FirstName, LastName;
  GO

  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  ORDER BY 1, 3; -- means FirstName and LastName
  GO

  -- It is ok to order by the attributes not included
  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  ORDER BY BusinessEntitiyID;
  GO

  SELECT FirstName, MiddleName, LastName
  FROM Person.Person
  ORDER BY MiddleName; -- with NULL, put all the NULL value first
  GO
  ```
* GROUP BY
  ```sql
  USE databasename;
  GO

  SELECT City
  FROM Person.Address
  GROUP BY City; -- it is like distinct
  GO

  SELECT City
  FROM Person.Address
  ORDER BY City;
  GO


  SELECT City, AddressLine1
  FROM Person.Address
  GROUP BY City; -- it is like DISTINCT
  GO
  -- error!

  SELECT City, AddressLine1
  FROM Person.Address
  GROUP BY City, AddressLine1; -- It is like ORDER BY
  GO

  SELECT City, COUNT(*) AS Totals
  FROM Person.Address
  GROUP BY City;
  GO

  ```
* TOP
  ```sql
  USE databasename;
  GO

  SELECT TOP 20 * -- no order
  FROM Person.Address;
  GO

  SELECT TOP 20 AddressID, City -- no order
  FROM Person.Address;
  GO

  SELECT TOP 20 PERCENT AddressID, City -- no order
  FROM Person.Address;
  GO

  SELECT TOP (10) WITH TIES TaxRate
  FROM Sales.SalesTaxRate
  ORDER BY TaxRate DESC;
  GO

  SELECT TOP (10) TaxRate -- still with tie, because it just do TOP 10
  FROM Sales.SalesTaxRate
  ORDER BY TaxRate DESC;
  GO

  SELECT TOP (20) WITH TIES TaxRate
  FROM Sales.SalesTaxRate
  ORDER BY TaxRate DESC; -- the rows may more than 20
  GO
  ```
* AGGREGATE
  ```sql
  USE databasename;
  GO

  -- return total number of the row with no heading
  SELECT COUNT(*)
  FROM HumanResources.Employee;
  GO

  SELECT COUNT(DISTINCT JobTitle) AS [Number of Titles]
  FROM HumanResources.Employee;
  GO

  -- total number of row equal to the previous one
  SELECT COUNT(JobTitle) AS [Number of Titles]
  FROM HumanResources.Employee;
  GO

  SELECT AVG(VacationHours) AS [Avg Vacation Hours]
  FROM HumanResources.Employee;
  GO

  -- They all ignore NULL but will work on character value on the colation sequence that you have configured for your SQL instance.
  SELECT MAX(VacationHours) AS [MAX Vacation]
  FROM HumanResources.Employee;
  GO

  SELECT MIN(VacationHours) AS [Min Vacation]
  FROM HumanResources.Employee;
  GO

  SELECT SUM(VacationHours) AS [Total Vacation]
  FROM HumanResources.Employee;
  GO

  SELECT VAR(VacationHours) AS [Variance Vacation]
  FROM HumanResources.Employee;
  GO

  SELECT MIN(VacationHours) AS [Min Vacation],
    MAX(VacationHours) AS [MAX Vacation],
    SUM(VacationHours) AS [Total Vacation],
    SUM(SickLeaveHours) AS [SUM SickLeave],
    MAX(HireDate) AS [Last Hire Date]
  FROM HumanResources.Employee;
  GO
  ```
* Date and Time
  ```sql
  USE databasename
  GO

  SELECT LoginID, HireDate
  FROM HumanResources.Employee;
  GO

  SELECT LoginID, HireDate
  FROM HumanResources.Employee
  WHERE HireDate = "20090114"; -- language neutral format. recommended
  GO

  SELECT LoginID, HireDate
  FROM HumanResources.Employee
  WHERE HireDate = "01-14-2009"; -- using US-based format
  GO

  SELECT LoginID, HireDate
  FROM HumanResources.Employee
  WHERE HireDate = "14-01-2009"; -- using Canadian/ International format
  GO

  SELECT LoginID, HireDate
  FROM HumanResources.Employee
  WHERE HireDate BETWEEN "20000101" AND "20151231";
  GO

  SELECT LoginID, HireDate
  FROM HumanResources.Employee
  WHERE HireDate >= "20000101" AND HireDate <= "20151231";
  GO

  -- only return month
  SELECT DATEPART(MONTH, HireDate) AS [Date Part] -- can also be YEAR or DAY
  FROM HumanResources.Employee;
  GO

  -- return the name of the month
  SELECT DATENAME(MONTH, HireDate) AS [Month]
  FROM HumanResources.Employee;
  GO

  SELECT DATENAME(WEEKDAY, HireDate) AS [Day]
  FROM HumanResources.Employee;
  GO

  SELECT DATEDIFF(YEAR, MIN(HireDate), MAX(HireDate))
  FROM HumanResources.Employee;
  GO

  SELECT HireDate, DATEADD(MONTH, 2, HireDate) AS [Modified Date]
  FROM HumanResources.Employee;
  GO

  SELECT SYSDATETIME();
  GO

  SELECT SYSDATETIMEOFFSET(); -- return also time zone
  GO

  SELECT TIMEFROMPARTS(22,45,0,0); -- turn integer to time format
  GO
  ```
* Character Data Type
  ```sql
  USE databasename
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName = N'Adams' -- to reflect Unicode to prevent the use of casting (conversion of datatype)
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName LIKE N'A%' -- start with "A"
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName LIKE N'Ab%' -- It is not case sensitive
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE FirstName LIKE N'%im' OR FirstName LIKE N'%im%';
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName LIKE N'%_D%';
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName LIKE N'%[ABC]%';
  GO

  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName LIKE N'%[A-F]%';
  GO


  SELECT FirstName, LastName
  FROM Person.Person
  WHERE LastName LIKE N'%[^A-F]%'; -- do not start with A-F
  GO
  ```
* Character Data Function
  ```sql
  SELECT FirstName + ' ' + LastName AS [Full Name]
  FROM Person.Person;
  GO

  -- NULL + 'string_character' = NULL
  SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
  FROM Person.Person;
  GO

  -- Replace NULL value with a empty character, ''
  SELECT FirstName + ' ' + COALESCE(MiddleName, '') + ' ' + LastName AS [Full Name]
  FROM Person.Person;
  GO

  SELECT LastName, LEN(LastName) AS [Lastname Length]
  FROM Person.Person;
  GO

  SELECT LastName, LEN(LastName) AS [Lastname Length], DATALENGHTH(LastName)
  AS [Lastname data byte]
  FROM Person.Person;
  GO

  -- do not want to allow apostrophes in your data, so you want to replace it with a blank
  SELECT LastName, REPLACE(LastName, '''', '')
  FROM Person.Person
  WHERE LastName LIKE '%''%';
  GO

  SELECT REPLICATE('A',10); -- "AAAAAAAAAA"
  GO

  SELECT LOWER(LastName), UPPER(LastName)
  FROM Person.Person;
  GO

  -- remove any spaces from the right and left hand side
  SELECT RTRIM(LTRIM(FirstName))
  FROM Person.Person;
  GO

  -- extract the first to the third character
  SELECT SUBSTRING(FirstName,1,3), FirstName
  FROM Person.Person;
  GO

  -- extract the first and the last 3 character
  SELECT FirstName, LEFT(FirstName, 3), RIGHT(FirstName, 3)
  FROM Person.Person;
  GO
  ```
* Subquery
  ```sql
  SELECT OrderQty, LineTotal,
  FROM Sales.SalesOrderDetail
  WHERE UnitPrice =
      (SELECT MIN(UnitPrice)
      FROM Sales.SalesOrderDetail);
  GO

  SELECT FirtName, LastName
  FROM Person.Person
  WHERE BusinessEntityID IN
    (SELECT BusinessEntityID
    FROM Sales.SalesPerson
    WHERE SalesLastYear > 2000000);
  GO

  -- correlated subquery, have to use table alias
  SELECT OrderQty, LineTotal,
  FROM Sales.SalesOrderDetail AS s1
  WHERE UnitPrice =
      (SELECT MIN(UnitPrice)
      FROM Sales.SalesOrderDetail s2
      WHERE s1.SalesOrderID = s2.SalesOrderID);
  GO
  ```
* EXISTS
  ```sql
  -- kind of another way to use INNER JOIN
  SELECT AccountNumber
  FROM Sales.Customer AS c
  WHERE EXISTS
      (SELECT *
      FROM Sales.SalesOrderHeader AS soh
      WHERE c.CustomerID = soh.CustomerID
      AND OnlineOrderFlag = 1);
  GO

  SELECT AccountNumber
  FROM Sales.Customer AS c
  WHERE NOT EXISTS
      (SELECT *
      FROM Sales.SalesOrderHeader AS soh
      WHERE c.CustomerID = soh.CustomerID
      AND OnlineOrderFlag = 1);
  GO
  ```
* Views
  1. Are considered as virtual tables
  2. Their contents are defined by a query
  3. It is read only representation
  4. Three types of views (indexed, partitioned and systems)
* Common Table Expression (CTE)
  Temporary Table only exist in memory only and not in database as an object that you could reference later. But they can reference themselves in a query.
  ```sql
  -- need to run whole the code at one time
  USE databasename;
  GO

  WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
  AS
  (
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
  )

  -- outer query
  SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
  FROM Sales_CTE
  GROUP BY SalesYear, SalesPersonID
  ORDER BY SalesPersonID, SalesYear;
  GO
  ```
* Stored Procedures of T-SQL
  ```sql
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
  ```
* Programming elements for T-SQL
  ```sql
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
  ```
* Implement Transaction (insert, update, delete)
  ```sql
  --******************************************
  -- 08_03_Implement_Transactions.sql
  --******************************************


  -- Transactions are used to wrap statements that should be executed
  -- successfully to prevent data corruption. They are mostly used with
  -- INSERT, UPDATE, and DELETE statements that modify data as opposed
  -- to SELECT statements where we just return information.
  -- In this example we will attempt to delete a job candidate from
  -- the JobCandidate table with the ID of 13.
  -- We want this delete statement to complete successfully or be rolled back if
  -- there are any issues with completing the command.  The main reason is that
  -- SQL Server stores the data on disk and all the data associated with a specific
  -- record may not stored all in one place.  If we delete only part of the information
  -- for this record, then we corrupt data.

  -- This statement marks the beginning of the transaction
  BEGIN TRANSACTION;

  USE AdventureWorks2014;

  -- Nothing is recorded in the transaction log until this statement begins executing
  DELETE FROM AdventureWorks2014.HumanResources.JobCandidate
      WHERE JobCandidateID = 13;

  -- if we reach this point, then we assume the statement executed succesfully and we update
  -- the transaction log appropriately and commit the changes to the database.
  COMMIT TRANSACTION;
  GO


  -- We can also mark a transaction by using a name.
  -- This name will be placed in the transaction log so that
  -- you can have a visually apparent, friendly name that indicats
  -- what the transaction was doing.
  -- We have also given this transaction a name called CandidateDelete
  BEGIN TRANSACTION CandidateDelete
      WITH MARK N'Deleting a Job Candidate';
  GO
  USE AdventureWorks2014;
  GO
  DELETE FROM AdventureWorks2014.HumanResources.JobCandidate
      WHERE JobCandidateID = 14;
  GO
  COMMIT TRANSACTION CandidateDelete;
  GO
  ```
* ERROR Handling
  ```sql
  USE AdventureWorks2014;
  GO

  BEGIN TRY
      -- Generate a divide-by-zero error.
      SELECT 1/0;
  END TRY
  BEGIN CATCH
      SELECT
          ERROR_NUMBER() AS ErrorNumber
          ,ERROR_SEVERITY() AS ErrorSeverity
          ,ERROR_STATE() AS ErrorState
          ,ERROR_PROCEDURE() AS ErrorProcedure
          ,ERROR_LINE() AS ErrorLine
          ,ERROR_MESSAGE() AS ErrorMessage;
  END CATCH;
  GO



  USE AdventureWorks2014;
  GO
  BEGIN TRANSACTION;

  BEGIN TRY
      -- Generate a constraint violation error.
      DELETE FROM Production.Product
      WHERE ProductID = 980;
  END TRY
  BEGIN CATCH
      SELECT
          ERROR_NUMBER() AS ErrorNumber
          ,ERROR_SEVERITY() AS ErrorSeverity
          ,ERROR_STATE() AS ErrorState
          ,ERROR_PROCEDURE() AS ErrorProcedure
          ,ERROR_LINE() AS ErrorLine
          ,ERROR_MESSAGE() AS ErrorMessage;

      IF @@TRANCOUNT > 0
          ROLLBACK TRANSACTION;
  END CATCH;

  IF @@TRANCOUNT > 0
      COMMIT TRANSACTION;
  GO
  ```
* Query exception Plan
  ```sql
  --******************************************
  -- 09_01_Introducing_Query_Execution_Plans.sql
  --******************************************

  USE AdventureWorks2014;
  GO

  -- Smple query to show execution plan for a single SELECT statement
  SELECT *
  FROM Person.Person;
  GO

  -- Sub-query that returns a single value
  -- These are the simplest sub-queries to work with as they return a single
  -- value for use in the outer query.
  -- Here we ask for the quantity ordered and the total sale value
  -- for the item in the SalesOrderDetail table that has the lowest unit price
  -- The subquery can also be executed separately.  Highlight it and run that portion
  --SET SHOWPLAN_XML ON
  --GO

  SELECT OrderQty, LineTotal
  FROM Sales.SalesOrderDetail
  WHERE UnitPrice =
  	(SELECT MIN(UnitPrice)
  	FROM Sales.SalesOrderDetail);
  GO

  -- Use a subquery that returns multiple values
  -- In this case, we cannot use the = operator
  -- but instead will use the IN clause due to multiple
  -- values being returned.
  -- Here we look for the first and last name of sales people
  -- who have had sales last year that exceeded $2M
  SELECT FirstName, LastName
  FROM Person.Person
  WHERE BusinessEntityID IN
  	(SELECT BusinessEntityID
  	FROM Sales.SalesPerson
  	WHERE SalesLastYear > 2000000);
  GO
  ```
* Query Statistics
  ```sql
  --******************************************
  -- 09_02_Viewing_Statistics.sql
  --******************************************

  USE AdventureWorks2014;
  GO

  -- set the statistics options to on in order to display information
  -- related to the query processing.
  -- Uncomment each SET STATISTICS statement below to see what it does.

  -- Displays the number of milliseconds required to
  -- parse, compile, and execute each statement.
  --SET STATISTICS TIME ON


  -- Causes SQL Server to display information regarding the amount
  -- of disk activity generated by Transact-SQL statements.
  --SET STATISTICS IO ON


  -- Displays the profile information for a statement.
  -- STATISTICS PROFILE works for ad hoc queries, views, and stored procedures.
  --SET STATISTICS PROFILE ON


  -- Causes Microsoft SQL Server to execute Transact-SQL statements
  -- and generate detailed information about how the statements were
  -- executed in the form of a well-defined XML document
  --SET STATISTICS XML ON
  GO

  -- Smple query to show execution plan for a single SELECT statement
  SELECT *
  FROM Person.Person;
  GO

  -- You can also set the STATISTICS to OFF once your query has executed.
  --SET STATISTICS TIME OFF
  --SET STATISTICS IO OFF
  --SET STATISTICS PROFILE OFF
  --SET STATISTICS XML OFF

  -- Select the product name from the Production.Product table
  -- combine that with the comments and product review ID from the ProductReview table
  -- using the ProductReviewID to establish the relationship
  SELECT p.Name, pr.ProductReviewID, pr.Comments
  FROM Production.Product p
  INNER JOIN Production.ProductReview pr
  ON p.ProductID = pr.ProductID;
  GO
  ```
