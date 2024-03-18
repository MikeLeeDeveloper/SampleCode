-- This table variable represents a logging table inside your database
-- All records are to be inserted chronologically ascending
DECLARE @DoorStatus TABLE(
[DoorStatusID] INT IDENTITY(1,1),
[RoomName] VARCHAR(10) NOT NULL,
[DoorName] VARCHAR(10) NOT NULL,
[Status] VARCHAR(10) NOT NULL,
[CreatedDTS] DATETIME NOT NULL
)

-- Replace value expressions below with sample data from project
INSERT INTO @DoorStatus VALUES
('Room 1','Door 1','Open',GETUTCDATE()),						-- Replace me
('Room 1','Door 1','Closed',DATEADD(MINUTE, 5, GETUTCDATE()))	-- Replace me

-- Get room door pairs for looping
DECLARE @RoomDoorPairs TABLE(
[Enum] INT IDENTITY(1,1),
[RoomName] VARCHAR(10) NOT NULL,
[DoorName] VARCHAR(10) NOT NULL
)

INSERT INTO @RoomDoorPairs
SELECT DISTINCT [RoomName],[DoorName]
FROM @DoorStatus
ORDER BY [RoomName],[DoorName]

-- Set counter variables
DECLARE @Counter INT = 1
DECLARE @MaxRoomDoorPairs INT = (SELECT MAX(ENUM) FROM @RoomDoorPairs)

-- Results
DECLARE @Results TABLE(
[DoorStatusID] INT NOT NULL,
[RoomName] VARCHAR(10) NOT NULL,
[DoorName] VARCHAR(10) NOT NULL,
[Status] VARCHAR(10) NOT NULL,
[Durration] VARCHAR(255) NOT NULL,
[CreatedDTS] DATETIME NOT NULL
)

-- Loop room door pairs
WHILE @Counter <= @MaxRoomDoorPairs
BEGIN
	-- Get min and max DoorStatusID from room door pair
	DECLARE @MinDoorStatusID INT = 0
	DECLARE @MaxDoorStatusID INT = 0

	SELECT @MinDoorStatusID = MIN([DoorStatusID])
		  ,@MaxDoorStatusID = MAX([DoorStatusID])
	FROM @DoorStatus as ds
	JOIN @RoomDoorPairs as rdp on ds.[RoomName] = rdp.[RoomName] AND ds.[DoorName] = rdp.[DoorName]
	WHERE rdp.[Enum] = @Counter

	-- Working data
	DECLARE @RoomDoorStatus TABLE(
	[Enum] INT IDENTITY(1,1),
	[DoorStatusID] INT NOT NULL,
	[RoomName] VARCHAR(10) NOT NULL,
	[DoorName] VARCHAR(10) NOT NULL,
	[Status] VARCHAR(10) NOT NULL,
	[IsConsecutive] BIT NULL,
	[CreatedDTS] DATETIME NOT NULL
	)

	-- IsConsecutive checks to see if record is the first record for room door pair 
	-- or if the record is the last record for room door pair
	-- or if the status matches the previous status
	INSERT INTO @RoomDoorStatus
	SELECT ds.[DoorStatusID]
		  ,ds.[RoomName]
		  ,ds.[DoorName]
		  ,ds.[Status]
		  ,[IsConsecutive] = CASE 
								WHEN ds.[DoorStatusID] = @MinDoorStatusID OR ds.[DoorStatusID] = @MaxDoorStatusID 
									OR ds.[Status] <> LAG(ds.[Status],1) OVER (ORDER BY ds.[CreatedDTS])
									THEN 0 
								ELSE 1 END
		  ,ds.[CreatedDTS]
	FROM @DoorStatus as ds
	JOIN @RoomDoorPairs as rdp on ds.[RoomName] = rdp.[RoomName] AND ds.[DoorName] = rdp.[DoorName]
	WHERE rdp.[Enum] = @Counter
	ORDER BY ds.[CreatedDTS]

	--Remove consecutive records
	DELETE FROM @RoomDoorStatus
	WHERE [IsConsecutive] = 1

	--Get time difference
	INSERT INTO @Results
	SELECT [DoorStatusID]
		  ,[RoomName]
		  ,[DoorName]
		  ,[Status]
		  ,[Durration] = IIF(CONVERT(INT,ISNULL(DATEDIFF(HOUR,[CreatedDTS],[NextDTS]),0)) < 24,
							-- If duration is under 24 hours
							CONVERT(VARCHAR, DATEADD(SECOND, ISNULL(DATEDIFF(SECOND,[CreatedDTS],[NextDTS]),0), 0), 114),
							-- If duration is over 24 hours, interpolate in total hours (VARCHAR 114 excludes days)
							CONVERT(VARCHAR(255),ISNULL(DATEDIFF(HOUR,[CreatedDTS],[NextDTS]),0)) +
							SUBSTRING(
								CONVERT(VARCHAR, DATEADD(SECOND, ISNULL(DATEDIFF(SECOND,[CreatedDTS],[NextDTS]),0), 0), 114)
								,3
								,LEN(CONVERT(VARCHAR, DATEADD(SECOND, ISNULL(DATEDIFF(SECOND,[CreatedDTS],[NextDTS]),0), 0), 114)) - 2)
						)
	      ,[CreatedDTS]
	FROM 
	(
		SELECT [DoorStatusID]
			  ,[RoomName]
			  ,[DoorName]
			  ,[Status]
			  ,[IsConsecutive]
			  ,[CreatedDTS]
			  ,[NextDTS] = LEAD([CreatedDTS]) OVER (ORDER BY [CreatedDTS])
		FROM @RoomDoorStatus
	) as q

	-- Remove last record if status matches penultimate record
	DECLARE @SecondToLast INT = (
		SELECT TOP 1 [DoorStatusID]
		FROM @RoomDoorStatus
		WHERE [DoorStatusID] != @MaxDoorStatusID
		ORDER BY [DoorStatusID] DESC
	)

	IF (SELECT [Status] FROM @RoomDoorStatus WHERE [DoorStatusID] = @MaxDoorStatusID) = 
		(SELECT [Status] FROM @RoomDoorStatus WHERE [DoorStatusID] = @SecondToLast)
	BEGIN
		DELETE FROM @Results
		WHERE [DoorStatusID] = @MaxDoorStatusID
	END

	-- Clear working data, increment counter
	DELETE FROM @RoomDoorStatus
	SET @Counter += 1
END

-- Results
SELECT * FROM @Results
ORDER BY [RoomName],[DoorName],[CreatedDTS]