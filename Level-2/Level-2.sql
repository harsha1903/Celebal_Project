/*Table Creation*/
CREATE TABLE TableA(
StudentId int PRIMARY KEY,
StudentName varchar(50)
);

CREATE TABLE TableB(
StudentId int PRIMARY KEY,
StudentName varchar(50)
);

/*Data Insertion*/
INSERT INTO TableA VALUES
(1,'Rohith'),
(2,'Mohith');

/*Insert Data and Truncate Procedure*/
CREATE PROCEDURE InsertAndTruncate
    @List NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL nvarchar(max)=N'
	INSERT INTO TableB ('+@List+')
	SELECT '+@List+'
    FROM TableA;'
	EXEC sp_executesql @sql; 
    TRUNCATE TABLE TableA;
	SELECT *FROM TableB;
END;

/*Execution*/
DECLARE @ColumnList nvarchar(max)='StudentId,StudentName';
EXEC InsertAndTruncate @Columnlist;
