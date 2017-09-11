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