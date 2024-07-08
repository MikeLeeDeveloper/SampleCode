DECLARE @Field NVARCHAR(MAX) = ''

SELECT   [TableName] = '[' + SCHEMA_NAME(t.[schema_id]) + '].[' + t.[name] + ']'
		,[ColumnName] = c.[name]
		,[SelectDistinct] = 'SELECT DISTINCT [' + c.[name] + '], [Count] = COUNT(*) FROM [' 
							+ SCHEMA_NAME(t.[schema_id]) + '].[' + t.[name] + '] '
							+ 'WHERE [' + c.[name] + '] != '''' AND [' + c.[name] + '] IS NOT NULL GROUP BY [' + c.[name] + ']'
FROM sys.columns as c
JOIN sys.tables as t ON c.[object_id] = t.[object_id]
WHERE c.[name] LIKE '%' + @Field + '%'
--AND c.[name] NOT LIKE '%%'
ORDER BY [TableName],[ColumnName]
