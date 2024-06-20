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
	  ,[InsertStatement] =		'  ,[' + c.[name] + '] = @' + REPLACE(c.[Name],'+','_')
	  ,[MergeUpdateStatement] = ',' + @MergeTarget + '.[' + c.[name] + '] = ' + @MergeSource+ '.[' + c.[name] + ']'
	  ,[SqlParameter] =			'    new SqlParameter(@"' + REPLACE(c.[Name],'+','_') + '",SqlDbType.' +
									CASE
										WHEN t.[Name] = 'int'
											THEN 'Int'
										WHEN t.[Name] = 'tinyint'
											THEN 'TinyInt'
										WHEN t.[Name] = 'decimal'
											THEN 'Decimal,' + CONVERT(VARCHAR(MAX),c.[precision])
										WHEN t.[Name] = 'bit'
											THEN 'Bit'
										WHEN t.[Name] = 'datetime'
											THEN 'DateTime'
										WHEN t.[Name] = 'char'
											THEN 'Char,' + CONVERT(VARCHAR(MAX),c.[max_length])
										WHEN t.[Name] = 'varchar'
											THEN 'VarChar,' + CONVERT(VARCHAR(MAX),c.[max_length])
										WHEN t.[Name] = 'nvarchar'
											THEN 'NVarChar,' + CONVERT(VARCHAR(MAX),c.[max_length])
										ELSE '' 
									END + '),'
		,[SqlValue] =			'sqlparam[' + CONVERT(VARCHAR(MAX), ROW_NUMBER() OVER(ORDER BY c.[column_id]) - 1) 
							  + '].Value =  // ' + c.[name]
FROM sys.columns as c
INNER JOIN sys.types as t ON c.[user_type_id] = t.[user_type_id]
WHERE c.[object_id] = OBJECT_ID(@TableName)
-- Comment line below to include identity column
AND c.[is_identity] != 1
ORDER BY c.[column_id] ASC
--ORDER BY c.[name] ASC
