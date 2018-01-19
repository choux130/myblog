--*****************************************
-- 04_04_Using_JOINS_in_a_Query.sql
--*****************************************

USE AdventureWorks2014;
GO

-- Select the product name from the Production.Product table
-- combine that with the comments and product review ID from the ProductReview table
-- using the ProductReviewID to establish the relationship
SELECT p.Name, pr.ProductReviewID, pr.Comments
FROM Production.Product p
INNER JOIN Production.ProductReview pr
ON p.ProductID = pr.ProductID;
GO

-- return the product name from the Production.Product table
-- just so we can see how many records are in that table
SELECT p.Name
FROM Production.Product AS p;
GO

-- return the product reviews from the Production.ProductReview table
-- just so we can validate the number of records in the first query
SELECT *
FROM Production.ProductReview;
GO


-- Using a left outer join, we will return all the rows in one table
-- regardless of whether there is a match in the other table
-- NOTE the placement of the table names in the FROM and JOIN clauses
-- determine which table is the LEFT.  In this case, Product is the left table
SELECT  p.Name, pr.ProductReviewID, pr.Comments
FROM Production.Product p
LEFT OUTER JOIN Production.ProductReview pr
ON p.ProductID = pr.ProductID;
GO

-- Using a left outer join, we will return all the rows in one table
-- regardless of whether there is a match in the other table
-- NOTE the placement of the table names in the FROM and JOIN clauses
-- determine which table is the LEFT.  In this case, ProductReview is the left table
SELECT  p.Name, pr.ProductReviewID, pr.Comments
FROM Production.ProductReview pr
LEFT OUTER JOIN Production.Product p
ON p.ProductID = pr.ProductID;
GO


-- Using a right outer join, we will return all the rows in one table
-- regardless of whether there is a match in the other table
-- In this case, the Product table is listed first
-- in JOIN clause.  Also, the ProductReview table only has four entries total
SELECT p.Name, pr.ProductReviewID, pr.Comments
FROM Production.Product p
RIGHT OUTER JOIN Production.ProductReview pr
ON p.ProductID = pr.ProductID;
GO


-- Using a right outer join, we will return all the rows in one table
-- regardless of whether there is a match in the other table
-- In this case, the ProductReview table is listed first
SELECT p.Name, pr.ProductReviewID, pr.Comments
FROM Production.ProductReview pr
RIGHT OUTER JOIN Production.Product p
ON p.ProductID = pr.ProductID;
GO


-- Using a full outer join, we will retain the nonmatching rows
-- regardless of whether there is a match in the other table
-- the results look similar to the LEFT OUTER JOIN in this instance because if the way
-- the data exists in these tables.
SELECT p.Name, pr.ProductReviewID, pr.Comments
FROM Production.Product p
FULL OUTER JOIN Production.ProductReview pr
ON p.ProductID = pr.ProductID;
GO

