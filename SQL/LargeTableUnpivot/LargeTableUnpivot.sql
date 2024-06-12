DECLARE @TableName NVARCHAR(MAX) = ''
DECLARE @SearchField NVARCHAR(MAX) = ''
DECLARE @SearchValue NVARCHAR(MAX) = ''

DECLARE @Col NVARCHAR(MAX)
DECLARE @ColNVarchar NVARCHAR(MAX)

-- Get Column Names
SELECT @Col = ISNULL(@Col + ', ','''') + QUOTENAME([Name])
	  ,@ColNVarchar = ISNULL(@ColNVarchar + ', ','''') 
			+ QUOTENAME([Name]) + ' = CONVERT(NVARCHAR(MAX),' 
			+ QUOTENAME([Name]) + ')'
FROM 
(
	SELECT [Name]
	FROM sys.columns 
	WHERE object_id = OBJECT_ID(@TableName)
) as Headers

--Remove first quote
IF @Col != ''
BEGIN
	SET @Col = RIGHT(@Col, LEN(@Col) - 1)
	SET @ColNVarchar = RIGHT(@ColNVarchar, LEN(@ColNVarchar) - 1)
END

-- Unpivot Table
DECLARE @SQL NVARCHAR(MAX) = '
SELECT [Table] = ''' + @TableName + ''' 
	  ,[' + @SearchField + '] = [ID]
	  ,[Attribute]
	  ,[Value]
FROM
(
	SELECT [ID] = [' + @SearchField + ']
		  ,' + @ColNVarchar + ' 
	FROM ' + @TableName +'
	WHERE [' + @SearchField + '] = ''' + @SearchValue + '''
) as Source
UNPIVOT
(
	[Value] FOR [Attribute] IN 
	(
		' + @Col + ' 
	)
) as unPVT
ORDER BY [Attribute] ASC
'

EXEC (@SQL)
