----Sample Dataset----
DECLARE @Vehicles TABLE(
[VehicleID] INT IDENTITY(1,1),
[Classification] NVARCHAR(50) NOT NULL,
[Make] NVARCHAR(100) NOT NULL,
[Model] NVARCHAR(100) NOT NULL,
[Year] INT NOT NULL,
[Color] NVARCHAR(100) NOT NULL,
[Trim] NVARCHAR(255) NULL,
[Mileage] INT NULL
)

INSERT INTO @Vehicles VALUES
('Car','Honda','Civic','2008','Red',NULL,80000),
('Car','Toyota','Tacoma','2016','White','TRD Off-Road',82000),
('Motorcycle','BMW','S1000RR','2022','Black','M',15000),
('Motorcycle','Yamaha','YZF-R1','2015','Red',NULL,9000),
('Motorcycle','Suzuki','DR-Z 400SM','2017','White',NULL,4000)

----Normalize Data----
--Declare EAV data structure (Entity, Attribute, Value)
DECLARE @InventoryEntity TABLE(
[InventoryEntityID] INT IDENTITY(1,1),
[InventoryEntityName] NVARCHAR(255) NOT NULL
)
DECLARE @InventoryAttribute TABLE(
[InventoryAttributeID] INT IDENTITY(1,1),
[InventoryEntityID] INT NOT NULL,
[SortOrder] INT NOT NULL,
[InventoryAttributeName] NVARCHAR(255) NOT NULL
)
DECLARE @InventoryValue TABLE(
[InventoryValueID] NVARCHAR(255) NOT NULL,
[InventoryEntityID] INT NOT NULL,
[InventoryAttributeID] INT NOT NULL,
[InventoryValue] NVARCHAR(500) NULL
)

--Insert Entity (Object)
INSERT INTO @InventoryEntity VALUES('Vehicle')

--Insert Attribute (Object fields)
DECLARE @InventoryEntityID INT = 
(
	SELECT TOP 1 [InventoryEntityID] 
	FROM @InventoryEntity
	WHERE [InventoryEntityName] = 'Vehicle'
)

INSERT INTO @InventoryAttribute VALUES
(@InventoryEntityID,1,'VehicleID'),
(@InventoryEntityID,2,'Classification'),
(@InventoryEntityID,3,'Make'),
(@InventoryEntityID,4,'Model'),
(@InventoryEntityID,5,'Year'),
(@InventoryEntityID,6,'Color'),
(@InventoryEntityID,7,'Trim'),
(@InventoryEntityID,8,'Mileage')

--Insert Values (Object data)
INSERT INTO @InventoryValue
SELECT [InventoryValueID] =		[ID]
	  ,[InventoryEntityID] =	ie.[InventoryEntityID]
	  ,[InventoryAttributeID] = ia.[InventoryAttributeID]
	  ,[InventoryValue]
FROM
(
	SELECT [ID] =				CONVERT(NVARCHAR(500),[VehicleID])
		  ,[VehicleID] =		CONVERT(NVARCHAR(500),[VehicleID])
		  ,[Classification] =	CONVERT(NVARCHAR(500),[Classification])
		  ,[Make] =				CONVERT(NVARCHAR(500),[Make])
		  ,[Model] =			CONVERT(NVARCHAR(500),[Model])
		  ,[Year] =				CONVERT(NVARCHAR(500),[Year])
		  ,[Color] =			CONVERT(NVARCHAR(500),[Color])
		  ,[Trim] =				CONVERT(NVARCHAR(500),[Trim])
		  ,[Mileage] =			CONVERT(NVARCHAR(500),[Mileage])
	FROM @Vehicles 
) as src
UNPIVOT
(
	[InventoryValue] FOR [InventoryAttribute] IN 
	([VehicleID],[Classification],[Make],[Model],[Year],[Color],[Trim],[Mileage])
) as unPvt
JOIN @InventoryAttribute as ia on unPvt.[InventoryAttribute] = ia.[InventoryAttributeName]
JOIN @InventoryEntity as ie on ia.[InventoryEntityID] = ie.[InventoryEntityID]
WHERE ie.[InventoryEntityName] = 'Vehicle'

----Dynamic Query----
--Declare Variables
DECLARE @VehicleCol NVARCHAR(MAX) = ''
DECLARE @VehicleColNull NVARCHAR(MAX) = ''

--Get Headers
DECLARE @Headers TABLE(
[Enum] INT IDENTITY(1,1),
[InventoryEntityID] INT NOT NULL,
[SortOrder] INT NOT NULL,
[Header] NVARCHAR(500) NULL
)

INSERT INTO @Headers
SELECT DISTINCT 
	 ia.[InventoryEntityID]
	,ia.[SortOrder]
	,ia.[InventoryAttributeName]
FROM @InventoryAttribute as ia
JOIN @InventoryEntity as ie on ia.[InventoryEntityID] = ie.[InventoryEntityID]
WHERE ie.[InventoryEntityName] = 'Vehicle'
ORDER BY ia.[SortOrder]

--Write Fields
SELECT @VehicleCol = ISNULL(@VehicleCol + ', ','''') + QUOTENAME([Header])
	  ,@VehicleColNull = ISNULL(@VehicleColNull + ', ','''') + QUOTENAME([Header]) + ' = ISNULL(' + QUOTENAME([Header]) + ', '''')'
FROM 
(
	SELECT *
	FROM @Headers
) as Headers
ORDER BY [Enum]

--Remove first quote
IF @VehicleCol != ''
BEGIN
	SET @VehicleCol = RIGHT(@VehicleCol, LEN(@VehicleCol) - 1)
	SET @VehicleColNull = RIGHT(@VehicleColNull, LEN(@VehicleColNull) - 1)
END

--Write Dynamic Query Statement
DECLARE @SQL NVARCHAR(MAX) = 
'
	/*	Note:	Since the scope of this exercise does not permit creating tables, the table variables 
				have been recreated within this SQL statement to have a working dataset.
				
				Please skip down to ----Results---- (line 223) to view dynamic query statement
	*/

	----Sample Dataset----
	DECLARE @Vehicles TABLE(
	[VehicleID] INT IDENTITY(1,1),
	[Classification] NVARCHAR(50) NOT NULL,
	[Make] NVARCHAR(100) NOT NULL,
	[Model] NVARCHAR(100) NOT NULL,
	[Year] INT NOT NULL,
	[Color] NVARCHAR(100) NOT NULL,
	[Trim] NVARCHAR(255) NULL,
	[Mileage] INT NULL
	)

	INSERT INTO @Vehicles VALUES
	(''Car'',''Honda'',''Civic'',''2008'',''Red'',NULL,80000),
	(''Car'',''Toyota'',''Tacoma'',''2016'',''White'',''TRD Off-Road'',82000),
	(''Motorcycle'',''BMW'',''S1000RR'',''2022'',''Black'',''M'',15000),
	(''Motorcycle'',''Yamaha'',''YZF-R1'',''2015'',''Red'',NULL,9000),
	(''Motorcycle'',''Suzuki'',''DR-Z 400SM'',''2017'',''White'',NULL,4000)

	----Normalize Data----
	--Declare EAV data structure (Entity, Attribute, Value)
	DECLARE @InventoryEntity TABLE(
	[InventoryEntityID] INT IDENTITY(1,1),
	[InventoryEntityName] NVARCHAR(255) NOT NULL
	)
	DECLARE @InventoryAttribute TABLE(
	[InventoryAttributeID] INT IDENTITY(1,1),
	[InventoryEntityID] INT NOT NULL,
	[SortOrder] INT NOT NULL,
	[InventoryAttributeName] NVARCHAR(255) NOT NULL
	)
	DECLARE @InventoryValue TABLE(
	[InventoryValueID] NVARCHAR(255) NOT NULL,
	[InventoryEntityID] INT NOT NULL,
	[InventoryAttributeID] INT NOT NULL,
	[InventoryValue] NVARCHAR(500) NULL
	)

	--Insert Entity (Object)
	INSERT INTO @InventoryEntity VALUES(''Vehicle'')
	DECLARE @InventoryEntityID INT = 
	(
		SELECT TOP 1 [InventoryEntityID] 
		FROM @InventoryEntity
		WHERE [InventoryEntityName] = ''Vehicle''
	)

	--Insert Attribute (Object features)
	INSERT INTO @InventoryAttribute VALUES
	(@InventoryEntityID,1,''VehicleID''),
	(@InventoryEntityID,2,''Classification''),
	(@InventoryEntityID,3,''Make''),
	(@InventoryEntityID,4,''Model''),
	(@InventoryEntityID,5,''Year''),
	(@InventoryEntityID,6,''Color''),
	(@InventoryEntityID,7,''Trim''),
	(@InventoryEntityID,8,''Mileage'')

	--Insert Values (Object data)
	INSERT INTO @InventoryValue
	SELECT [InventoryValueID] =		[ID]
		  ,[InventoryEntityID] =	ie.[InventoryEntityID]
		  ,[InventoryAttributeID] = ia.[InventoryAttributeID]
		  ,[InventoryValue]
	FROM
	(
		SELECT [ID] =				CONVERT(NVARCHAR(500),[VehicleID])
			  ,[VehicleID] =		CONVERT(NVARCHAR(500),[VehicleID])
			  ,[Classification] =	CONVERT(NVARCHAR(500),[Classification])
			  ,[Make] =				CONVERT(NVARCHAR(500),[Make])
			  ,[Model] =			CONVERT(NVARCHAR(500),[Model])
			  ,[Year] =				CONVERT(NVARCHAR(500),[Year])
			  ,[Color] =			CONVERT(NVARCHAR(500),[Color])
			  ,[Trim] =				CONVERT(NVARCHAR(500),[Trim])
			  ,[Mileage] =			CONVERT(NVARCHAR(500),[Mileage])
		FROM @Vehicles 
	) as src
	UNPIVOT
	(
		[InventoryValue] FOR [InventoryAttribute] IN 
		([VehicleID],[Classification],[Make],[Model],[Year],[Color],[Trim],[Mileage])
	) as unPvt
	JOIN @InventoryAttribute as ia on unPvt.[InventoryAttribute] = ia.[InventoryAttributeName]
	JOIN @InventoryEntity as ie on ia.[InventoryEntityID] = ie.[InventoryEntityID]
	WHERE ie.[InventoryEntityName] = ''Vehicle''

	----Results----
	SELECT ' + @VehicleColNull + '
	FROM
	(
		SELECT iv.[InventoryValueID]
			  ,ia.[InventoryAttributeName]
			  ,iv.[InventoryValue]
		FROM @InventoryValue as iv
		JOIN @InventoryAttribute as ia on iv.[InventoryAttributeID] = ia.[InventoryAttributeID]
		JOIN @InventoryEntity as ie on ia.[InventoryEntityID] = ie.[InventoryEntityID]
	) as src
	PIVOT
	(
		MAX([InventoryValue]) FOR [InventoryAttributeName] IN 
		(
			' + @VehicleCol + '
		)
	) as pvt
'

--Executables
SELECT * FROM @Vehicles			--Original Dataset
SELECT * FROM @InventoryValue	--Normalized Data
EXEC(@SQL)						--Dynamically Generated Query that pivots normalized data