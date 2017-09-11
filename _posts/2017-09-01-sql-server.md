---
layout: post
title: "Learning Microsoft SQL Server"
date: 2017-09-01
author: Yin-Ting
categories: [SQL]
tags: [SQL Server]
---
### Overview
This post is about the SQL Server commands. All of the contents are based on the code in [w3schools - SQL](https://www.w3schools.com/SQL/deFault.asp) with the sample database, [Northwind](http://www.zentut.com/sql-tutorial/sql-sample-database/). To make myself easier to look up the commands I want in the future, I picked out the ones I have been used a lot in my work and add some notes on it. I also borrowed some materials from the course [LinkdedIn Learning - Microsoft SQL Server 2016: Query Data](https://www.linkedin.com/learning/microsoft-sql-server-2016-query-data/using-the-exercise-files). The lecturer of this course, [Gerry O'Brien](https://www.linkedin.com/in/gerryob/), did a great job on teaching this course and provided me a terrific starting point on learning Microsoft SQL Server. If you are interested in the complete commands taught in the course. Please check out, [Exercise Folder of the course]({{ site.baseurl }}/DATA/Ex_Files_QueryingSQL2016). All the example codes can be executed on [w3schools - SQL Try it Editor](https://www.w3schools.com/sql/trysql.asp?filename=trysql_select_all) or test the code on the [SQL Fiddle](http://www.sqlfiddle.com/) by creating new tables by ourselves.

***

### Details
* **<font size="4">References</font>** <br />
  1. [LinkdedIn Learning - Microsoft SQL Server 2016: Query Data](https://www.linkedin.com/learning/microsoft-sql-server-2016-query-data/using-the-exercise-files)
  2. [Exercise Folder of the course]({{ site.baseurl }}/DATA/Ex_Files_QueryingSQL2016)
  3. [Transact-SQL Reference (Database Engine)](https://docs.microsoft.com/en-us/sql/t-sql/language-reference)
  4. [w3schools - SQL](https://www.w3schools.com/SQL/deFault.asp)
  5. [SQL Fiddle](http://www.sqlfiddle.com/)
  6. [zentut - SQL Tutorial](http://www.zentut.com/sql-tutorial/)

* **<font size="4">Example Database : <em>Northwind</em></font>** <br />
  * [Northwind database documentation - dbdesc](http://dbdesc.com/output_samples/htmlbrowse_northwind.html)
  * [Entity Relationship Diagram (ERD)](http://www.zentut.com/wp-content/uploads/downloads/2013/06/Northwind-Sample-Database-Diagram.pdf) <br />
    <a href = "{{ site.baseurl }}/assets/post_image/ERD.png">
    <img src="{{ site.baseurl }}/assets/post_image/ERD.png" style="width:1000px"/></a>

* **<font size="4">Common SQL Server Commands</font>** <br />
  * **Data Overview** (`SELECT`, `TOP`, `DISTINCT`, `ORDER BY`, `GROUP BY`, `COUNT()`, `AVG()`)
      ```sql
      SELECT TOP 3 *
      FROM Customers
      ```
      ```sql
      SELECT DISTINCT Country
      FROM Customers
      ```
      ```sql
      SELECT COUNT(*) AS Total
      FROM Customers
      ```
      ```sql
      SELECT * FROM Customers
      ORDER BY country DESC, city
      ```
      ```sql
      SELECT country, city, count(*) AS Total_by_country_city
      FROM Customers
      GROUP BY country, city
      ```
      ```sql
      SELECT ProductID, AVG(Quantity) AS AVG_Qty
      FROM OrderDetails
      GROUP BY ProductID
      ```

  * **Subset Data with conditions** (`WHERE`, `IN`, `<>`, `IS NULL`, ...)
      ```sql
      SELECT * FROM Customers
      WHERE Country IN ('UK', 'USA')
          AND Country IS NOT NULL
      ```
      ```sql
      SELECT * FROM OrderDetails
      WHERE Quantity > 20
      ```
  * **Subquery** (`SELECT` in `WHERE`)
      ```sql
      SELECT * FROM OrderDetails
      WHERE OrderID =
      (
          SELECT OrderID FROM Orders
          WHERE OrderDate > '1996-07-04'
      )
      ```
      ```sql
      -- Correlated subquery, have to use table alias
      SELECT * FROM OrderDetails o1
      WHERE Quantity =
      (
          SELECT MAX(Quantity) FROM OrderDetails o2
          WHERE o1.ProductID = o2.ProductID
      )
      ```
  * **Common Table Expression (CTE)** (`WITH`) <br />
     <span>It is a temporary table saved only in memory and can be referred in the later query.</span>
     ```sql
     -- Need to run whole code in one time
     WITH temp_tab AS
     (
        SELECT * FROM OrderDetails o1
        WHERE Quantity =
        (
            SELECT MAX(Quantity) FROM OrderDetails o2
            WHERE o1.ProductID = o2.ProductID
        )
      )
      SELECT * FROM temp_tab
      ORDER BY Quantity
     ```
  * **Create New Columns from Other Columns** (`CASE`) <br />
     <span> It is how <em>if and then</em> logic works in SQL Server. </span>
     ```sql
     SELECT ShipperID, Phone,
     CASE ShipperName
        WHEN 'Speedy Express' THEN 'SE'
        WHEN 'United Package' THEN 'UP'
        WHEN 'Federal Shipping' THEN 'FS'
     END AS shippername_short
     FROM Shippers
     ```
     ```sql
     SELECT *,
     CASE
	      WHEN BirthDate < '1960-01-01' THEN 'Senior'
	      ELSE 'Not Senior'
     END AS age_category
     FROM Employees
    ```
  * **Join Multiple tables through Columns** (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`, ...)
      ```sql
      SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName
      FROM ((Orders
          INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
          INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID)
      ```
      ```sql
      SELECT A.CustomerName AS CustomerName1, B.CustomerName AS CustomerName2, A.City
      FROM Customers A, Customers B
      WHERE A.CustomerID <> B.CustomerID
          AND A.City = B.City
      ORDER BY A.City
      ```
      <a href = "{{ site.baseurl }}/assets/post_image/sql_join_1.png">
      <img src="{{ site.baseurl }}/assets/post_image/sql_join_1.png" style="width:600px"/></a>
      <a href = "{{ site.baseurl }}/assets/post_image/sql_join_2.png">
      <img src="{{ site.baseurl }}/assets/post_image/sql_join_2.png" style="width:400px" /></a>
      <span>The above images are from <a href = "https://stackoverflow.com/questions/406294/left-join-vs-left-outer-join-in-sql-server">here</a> and <a href = "https://stackoverflow.com/questions/30358982/sql-server-replaces-left-join-for-left-outer-join-in-view-query">here</a>.</span>

  * **Combine Rows from Multiple Tables** (`UNION`, `INTERSECT`, `EXCEPT`)
      ```sql
      -- only return distinct values
      SELECT City FROM Customers
      UNION
      SELECT City FROM Suppliers
      ORDER BY City
      ```
      ```sql
      -- return duplicated values
      SELECT City FROM Customers
      UNION
      SELECT City FROM Suppliers
      ORDER BY City
      ```
      <a href = "{{ site.baseurl }}/assets/post_image/union.png">
      <img src="{{ site.baseurl }}/assets/post_image/union.png" style="width:400px" /></a>
      <span>The above image is from <a href = "http://csharp-video-tutorials.blogspot.com/2015/09/difference-between-union-intersect-and.html">here</a>.</span>
  * **Table Transformation. From Long to Wide or from Wide to Long** (`PIVOT`, `UNPIVOT`) <br />
      [Example code in SQL Fiddle - PIVOT](http://www.sqlfiddle.com/#!6/3e694c/10) <br />
      [Example code in SQL Fiddle - UNPIVOT](http://www.sqlfiddle.com/#!6/2b0df/1)
      ```sql
      CREATE TABLE un_tab
      ([Name] varchar(7), [Subject] varchar(7), [Grade] numeric(10,5))

      INSERT INTO un_tab
          ([Name], [Subject], [Grade])
      VALUES
      ('Andy', 'Math', 60),
      ('Andy', 'Science', 70),
      ('Andy', 'English', 80),
      ('Judy', 'Math', 20),
      ('Judy', 'Science', 80),
      ('Judy', 'English', 100),
      ('Joe', 'Math', 90),
      ('Joe', 'Science', 70),
      ('Joe', 'English', 90)

      SELECT *
      FROM un_tab
      PIVOT
      (
          min(Grade)
          FOR Subject IN ([Math], [Science], [English])
      ) AS tab
      ```
      ```sql
      CREATE TABLE tab
	       ([Name] varchar(7), [Math] numeric(10,5), [Science] numeric(10,5), [English] numeric(10,5))

      INSERT INTO tab
	       ([Name], [Math], [Science], [English])
      VALUES
	       ('Andy', 60, 70, 80),
	       ('Judy', 20, 80, 100),
	       ('Joe', 90, 70, 90)

      SELECT Name, Subject, Grade
      FROM tab
      UNPIVOT
      (
          Grade
          FOR Subject IN (Math, Science, English)
      ) AS un_tab
      ```
  * **Add new rows to a table using `IF` to avoid duplication** (`EXIST`, `IF`, `BEGIN`, `END`)
      [Example code in SQL Fiddle - EXISTS](http://www.sqlfiddle.com/#!6/f1c52/30)
      ```sql
      CREATE TABLE tab
          ([Name] varchar(7), [Math] numeric(10,5), [Science] numeric(10,5), [English] numeric(10,5))

      INSERT INTO tab
          ([Name], [Math], [Science], [English])
      VALUES
          ('Andy', 60, 70, 80),
          ('Judy', 20, 80, 100),
          ('Joe', 90, 70, 90)

      IF NOT EXISTS
      (
          SELECT 1
          FROM tab
          WHERE Name = 'Andy'
      )
      BEGIN
          INSERT INTO tab
          ( Name, Math, Science, English)
      VALUES ('Andy', 60, 70, 80)
      END
      ```
  * **Stored Procedures** (' @ ') <br />
      It is like define a function for future uses. <br />
      [Example code in SQL Fiddle - @](http://www.sqlfiddle.com/#!6/a93e2/16)
      ```sql
      CREATE TABLE tab
          ([Name] varchar(7), [Math] numeric(10,5), [Science] numeric(10,5), [English] numeric(10,5))

      INSERT INTO tab
          ([Name], [Math], [Science], [English])
      VALUES
          ('Andy', 60, 70, 80),
          ('Judy', 20, 80, 100),
          ('Joe', 90, 70, 90)

      CREATE PROCEDURE pp @Name nvarchar(50)
      AS
      BEGIN
          SELECT * FROM tab
          WHERE Name = @Name
      END;

      EXEC pp @Name = 'Andy';
      ```
