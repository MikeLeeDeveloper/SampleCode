DECLARE @TableName NVARCHAR(MAX) = ''
	
DECLARE @MergeTarget NVARCHAR(MAX) = ''
DECLARE @MergeSource NVARCHAR(MAX) = ''

-- Get max column Name for spacing
DECLARE @MaxFieldLength INT = 
(
	SELECT MAX(LEN(c.[Name]))
	FROM sys.columns as c
	WHERE c.[object_id] = OBJECT_ID(@TableName)
)

-- Get Column Names
SELECT [ColumnName] =			c.[name]
      ,[DataType] =				t.[Name]
      ,[MaxLength] =			c.[max_length]
	  ,[Precision] =			c.[precision]
	  ,[Scale] =				c.[scale]
	  ,[SortOrder] =			c.[column_id]
	  ,[DeclareStatement] =		'DECLARE @' + LEFT(REPLACE(c.[Name],'+','_') + SPACE(@MaxFieldLength), @MaxFieldLength) + ' ' + UPPER(t.[Name])
									+ CASE
										WHEN UPPER(t.[Name]) IN ('CHAR','VARCHAR')
											THEN '(' + CONVERT(VARCHAR(MAX),c.[max_length]) + ')'
										WHEN UPPER(t.[Name]) IN ('DECIMAL')
											THEN '(' + CONVERT(VARCHAR(MAX),c.[precision]) + ',' + CONVERT(VARCHAR(MAX),c.[scale]) + ')'
										ELSE 
											''
									END
									-- Comment line below if no null values
									+ ' = NULL'
	  ,[InsertStatement] =		',[' + c.[name] + '] = @' + REPLACE(c.[Name],'+','_')
	  -- 
	  ,[MergeUpdateStatement] = ',' + @MergeTarget + '.[' + c.[name] + '] = ' + @MergeSource+ '.[' + c.[name] + ']'
FROM sys.columns as c
INNER JOIN sys.types as t ON c.[user_type_id] = t.[user_type_id]
WHERE c.[object_id] = OBJECT_ID(@TableName)
-- Uncomment line below to exclude identity column
--AND c.[is_identity] != 1
ORDER BY c.[name] ASC
-- Uncomment line below to order by table order
--ORDER BY c.[column_id] ASC
