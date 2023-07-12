CREATE PROCEDURE ListColumns(@TableName varchar(255))
AS
BEGIN
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME= @TableName;
END

DECLARE @table_name varchar(255)='Employee';
EXEC ListColumns @table_name;
