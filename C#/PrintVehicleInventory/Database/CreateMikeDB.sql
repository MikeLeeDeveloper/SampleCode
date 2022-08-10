USE [master]
GO

CREATE DATABASE [MikeDB]
GO

USE [MikeDB]
GO

----------TABLE----------
CREATE TABLE [dbo].[User](
[ID] INT IDENTITY(1,1),
[Email] NVARCHAR(255) NOT NULL,
[LastName] NVARCHAR(100) NOT NULL,
[FirstName] NVARCHAR(100) NOT NULL,
[IsActive] BIT NOT NULL,
[CreatedDTS] DATETIME NOT NULL,
PRIMARY KEY ([ID])
)

CREATE TABLE [dbo].[VehicleCategory](
[ID] INT IDENTITY(1,1),
[Name] NVARCHAR(255) NOT NULL,
PRIMARY KEY ([ID]),
UNIQUE([Name])
)

CREATE TABLE [dbo].[VehicleSubCategory](
[ID] INT IDENTITY(1,1),
[Name] NVARCHAR(255) NOT NULL,
PRIMARY KEY ([ID])
)

CREATE TABLE [dbo].[VehicleManufacturer](
[ID] INT IDENTITY(1,1),
[Name] NVARCHAR(255) NOT NULL,
[CountryOfOrigin] NVARCHAR(255) NOT NULL,
PRIMARY KEY ([ID]),
UNIQUE ([Name])
)

GO

CREATE TABLE [dbo].[VehicleModel](
[ID] INT IDENTITY(1,1),
[Name] NVARCHAR(255) NOT NULL,
[VehicleManufacturerID] INT NOT NULL,
[VehicleCategoryID] INT NOT NULL,
[VehicleSubCategoryID] INT NOT NULL,
PRIMARY KEY ([ID]),
CONSTRAINT UC_VehicleModel UNIQUE([Name],[VehicleManufacturerID]),
FOREIGN KEY ([VehicleSubCategoryID]) REFERENCES [dbo].[VehicleSubCategory]([ID]),
)

GO

CREATE TABLE [dbo].[VehicleInventory](
[ID] INT IDENTITY(1,1),
[VIN] NVARCHAR(17) NOT NULL,
[VehicleModelID] INT NOT NULL,
[CreatedDTS] DATETIME NULL,
PRIMARY KEY ([ID]),
CONSTRAINT UC_VehicleInventory UNIQUE([VIN]),
FOREIGN KEY ([VehicleModelID]) REFERENCES [dbo].[VehicleModel]([ID])
)

CREATE TABLE [dbo].[VehicleEntity](
[ID] INT IDENTITY(1,1),
[Name] NVARCHAR(255) NOT NULL,
[Description] NVARCHAR(255) NULL,
PRIMARY KEY ([ID])
)

GO

CREATE TABLE [dbo].[VehicleAttribute](
[ID] INT IDENTITY(1,1),
[VehicleEntityID] INT NOT NULL,
[Name] NVARCHAR(255) NOT NULL,
[SortOrder] INT NOT NULL,
[Description] NVARCHAR(255) NULL,
PRIMARY KEY ([ID]),
FOREIGN KEY ([VehicleEntityID]) REFERENCES [dbo].[VehicleEntity]([ID])
)

CREATE TABLE [dbo].[VehicleValue](
[ID] NVARCHAR(255) NOT NULL,
[VehicleEntityID] INT NOT NULL,
[VehicleAttributeID] INT NOT NULL,
[Value] NVARCHAR(1000) NOT NULL,
CONSTRAINT [PK_VehicleValue] PRIMARY KEY ([ID],[VehicleEntityID],[VehicleAttributeID])
)

GO

CREATE TABLE [dbo].[VehicleInventoryUser](
[ID] INT IDENTITY(1,1),
[UserID] INT NOT NULL,
[VehicleInventoryID] INT NOT NULL,
[IsOwner] BIT NOT NULL,
[CreatedDTS] DATETIME NOT NULL,
[ModifiedDTS] DATETIME NULL
PRIMARY KEY ([ID]),
CONSTRAINT UC_VehicleInventoryUser UNIQUE ([UserID],[VehicleInventoryID])
)

GO

----------VIEW----------
CREATE VIEW [dbo].[OwnedVehicles] AS

SELECT [InventoryNumber] = vi.[ID] 
	  ,[Category] = vc.[Name]
	  ,[SubCategory] = vsc.[Name]
	  ,[Make] = vma.[Name]
	  ,[Model] = vmo.[Name]
	  ,[Year]
	  ,[Color]
	  ,[Trim]
	  ,[Mileage] = [CurrentMileage]
	  ,[Title]
FROM [dbo].[VehicleInventoryUser] as viu
JOIN [dbo].[User] as u on viu.[UserID] = u.[ID]
JOIN [dbo].[VehicleInventory] as vi on viu.[VehicleInventoryID] = vi.[ID]
JOIN [dbo].[VehicleModel] as vmo on vi.[VehicleModelID] = vmo.[ID]
JOIN [dbo].[VehicleManufacturer] as vma on vmo.[VehicleManufacturerID] = vma.[ID]
JOIN [dbo].[VehicleCategory] as vc on vmo.[VehicleCategoryID] = vc.[ID]
JOIN [dbo].[VehicleSubCategory] as vsc on vmo.[VehicleSubCategoryID] = vsc.[ID]
LEFT OUTER JOIN
(
	SELECT [VIN],[Year],[Color],[Trim],[StartingMileage],[CurrentMileage],[Title]
	FROM
	(
		SELECT [ID] = vv.[ID]
		      ,[Attribute] = va.[Name]
			  ,[Value]
		FROM [dbo].[VehicleValue] as vv
		JOIN [dbo].[VehicleAttribute] as va on vv.[VehicleAttributeID] = va.[ID]
		JOIN [dbo].[VehicleEntity] as ve on va.[VehicleEntityID] = ve.[ID]
		WHERE ve.[Name] = 'Details'
	) as SourceTable
	PIVOT
	(
		MAX([Value]) FOR [Attribute] IN 
		([VIN],[Year],[Color],[Trim],[StartingMileage],[CurrentMileage],[Title])
	) as pvt
) as vd on vi.[VIN] = vd.[VIN]
WHERE viu.[IsOwner] = 1

GO

----------STOREDPROCEDURE----------
CREATE PROC [dbo].[GetVehicleDetailByUserID]
@UserID INT
AS

--Speed up pivot with larger dataset
DECLARE @OwnedVehicles TABLE(
[VIN] NVARCHAR(17)
)

INSERT INTO @OwnedVehicles
SELECT [VIN]
FROM [dbo].[VehicleInventoryUser] as viu
JOIN [dbo].[VehicleInventory] as vi on viu.[VehicleInventoryID]= vi.[ID]
WHERE viu.[UserID] = @UserID

SELECT [Category] = vc.[Name]
	  ,[SubCategory] = vsc.[Name]
	  ,[Make] = vma.[Name]
	  ,[Model] = vmo.[Name]
	  ,[Year]
	  ,[Color]
	  ,[Trim]
	  ,[StartingMileage] = [StartingMileage]
	  ,[LastRecordedMileage] = [CurrentMileage]
	  ,[Title]
	  ,[InPosession] = IIF(viu.[IsOwner] = 1, 'True','False')
FROM [dbo].[VehicleInventoryUser] as viu
JOIN [dbo].[User] as u on viu.[UserID] = u.[ID]
JOIN [dbo].[VehicleInventory] as vi on viu.[VehicleInventoryID] = vi.[ID]
JOIN [dbo].[VehicleModel] as vmo on vi.[VehicleModelID] = vmo.[ID]
JOIN [dbo].[VehicleManufacturer] as vma on vmo.[VehicleManufacturerID] = vma.[ID]
JOIN [dbo].[VehicleCategory] as vc on vmo.[VehicleCategoryID] = vc.[ID]
JOIN [dbo].[VehicleSubCategory] as vsc on vmo.[VehicleSubCategoryID] = vsc.[ID]
LEFT OUTER JOIN
(
	SELECT [VIN],[Year],[Color],[Trim],[StartingMileage],[CurrentMileage],[Title]
	FROM
	(
		SELECT [ID] = vv.[ID]
		      ,[Attribute] = va.[Name]
			  ,[Value]
		FROM [dbo].[VehicleValue] as vv
		JOIN [dbo].[VehicleAttribute] as va on vv.[VehicleAttributeID] = va.[ID]
		JOIN [dbo].[VehicleEntity] as ve on va.[VehicleEntityID] = ve.[ID]
		JOIN @OwnedVehicles as ov on vv.[ID] = ov.[VIN]
		WHERE ve.[Name] = 'Details'
	) as SourceTable
	PIVOT
	(
		MAX([Value]) FOR [Attribute] IN 
		([VIN],[Year],[Color],[Trim],[StartingMileage],[CurrentMileage],[Title])
	) as pvt
) as vd on vi.[VIN] = vd.[VIN]
WHERE viu.[UserID] = @UserID

GO

----------DATA----------
--User
DECLARE @UserData TABLE(
[LastName] NVARCHAR(255) NOT NULL,
[FirstName] NVARCHAR(255) NOT NULL,
[IsActive] BIT NOT NULL,
[CreatedDTS] DATETIME NOT NULL
)

INSERT INTO @UserData VALUES
('Lee','Mike',1,GETUTCDATE()),
('Chan','Jackie',1,GETUTCDATE()),
('Presley','Elvis',1,GETUTCDATE()),
('Fitzgerald','Ella',1,GETUTCDATE()),
('Sinatra','Frank',1,GETUTCDATE()),
('Leno','Jay',1,GETUTCDATE()),
('Cruise','Tom',1,GETUTCDATE()),
('Gadot','Gal',1,GETUTCDATE()),
('Aniston','Jennifer',1,GETUTCDATE()),
('Wolfkill','Kiki',1,GETUTCDATE()),
('Sweeney','Tim',1,GETUTCDATE()),
('Musk','Elon',1,GETUTCDATE()),
('Bezos','Jeff',1,GETUTCDATE()),
('Gates','Bill',1,GETUTCDATE()),
('Jobs','Steve',1,GETUTCDATE()),
('Senna','Ayrton',1,GETUTCDATE()),
('Hamilton','Lewis',1,GETUTCDATE()),
('Rossi','Valentino',1,GETUTCDATE()),
('Marquez','Marc',1,GETUTCDATE()),
('Turing','Alan',1,GETUTCDATE())

MERGE INTO [dbo].[User] as u
USING
(
	SELECT [Email] = [LastName] + [FirstName] + '@MikeDB.com'
		  ,[LastName]
		  ,[FirstName]
		  ,[IsActive]
		  ,[CreatedDTS]
	FROM @UserData
) as d on u.[Email] = d.[Email]
WHEN NOT MATCHED THEN INSERT VALUES
([Email],[LastName],[FirstName],[IsActive],[CreatedDTS]);

--VehicleCategory
DECLARE @VehicleCategory TABLE(
[Name] NVARCHAR(255) NOT NULL
)

INSERT INTO @VehicleCategory VALUES
('Automobile'),
('Motorcycle'),
('Boat'),
('Airplane')

MERGE INTO [dbo].[VehicleCategory] as vc
USING
(
	SELECT [Name]
	FROM @VehicleCategory
) as d on vc.[Name] = d.[Name]
WHEN NOT MATCHED THEN INSERT VALUES
([Name]);

--VehicleSubCategory
DECLARE @SubCategory TABLE(
[Name] NVARCHAR(255) NOT NULL
)

INSERT INTO @SubCategory VALUES
('Coupe'),
('Sedan'),
('Hatchback'),
('Station Wagon'),
('Sport Utility Vehicle'),
('Minivan'),
('Van'),
('Pickup Truck'),
('Scooter'),
('Sport Bike'),
('Cruiser'),
('Touring'),
('Roadster')

MERGE INTO [dbo].[VehicleSubCategory] as vsc
USING
(
	SELECT [Name]
	FROM @SubCategory
) as d on vsc.[Name] = d.[Name]
WHEN NOT MATCHED THEN INSERT VALUES
([Name]);

--VehicleManufacturer
DECLARE @Manufacturers TABLE(
[Name] NVARCHAR(255) NOT NULL,
[CountryOfOrigin] NVARCHAR(255) NOT NULL
)
INSERT INTO @Manufacturers VALUES
('Audi','Germany'),
('BMW','Germany'),
('Buick','USA'),
('Cadillac','USA'),
('Chevrolet','USA'),
('Chrysler','USA'),
('Dodge','USA'),
('Ferrari','Itally'),
('Ford','USA'),
('GM','USA'),
('GMC','USA'),
('Honda','Japan'),
('Hummer','USA'),
('Hyundai','South Korea'),
('Infiniti','Japan'),
('Isuzu','Japan'),
('Jaguar','United Kingdom'),
('Jeep','USA'),
('Kia','South Korea'),
('Lamborghini','Itally'),
('Land Rover','United Kingdom'),
('Lexus','Japan'),
('Lincoln','USA'),
('Lotus','United Kingdom'),
('Mazda','Japan'),
('Mercedes-Benz','Germany'),
('Mercury','USA'),
('Mitsubishi','Japan'),
('Nissan','Japan'),
('Oldsmobile','USA'),
('Peugeot','France'),
('Pontiac','USA'),
('Porsche','Germany'),
('Saab','Sweden'),
('Saturn','USA'),
('Subaru','Japan'),
('Suzuki','Japan'),
('Toyota','Japan'),
('Volkswagen','Germany'),
('Volvo','Sweden')

MERGE INTO [dbo].[VehicleManufacturer] as m
USING
(
	SELECT [Name],[CountryOfOrigin]
	FROM @Manufacturers
) as d on m.[Name] = d.[Name]
WHEN NOT MATCHED THEN INSERT VALUES
([Name],[CountryOfOrigin]);

GO

DECLARE @VehicleModel TABLE(
[Name] NVARCHAR(255) NOT NULL,
[VehicleManufacturerer] NVARCHAR(255) NOT NULL,
[VehicleCategory] NVARCHAR(255) NOT NULL,
[VehicleSubCategory] NVARCHAR(255) NOT NULL
)

INSERT INTO @VehicleModel VALUES
('Civic','Honda','Automobile','Sedan'),
('Accord','Honda','Automobile','Sedan'),
('S2000','Honda','Automobile','Roadster'),
('Ridgeline','Honda','Automobile','Pickup Truck'),
('Odyssey','Honda','Automobile','Minivan'),
('Corolla','Toyota','Automobile','Sedan'),
('Camry','Toyota','Automobile','Sedan'),
('Supra','Toyota','Automobile','Coupe'),
('Tacoma','Toyota','Automobile','Pickup Truck'),
('Sienna','Toyota','Automobile','Minivan'),
('Mustang','Ford','Automobile','Coupe'),
('Transit','Ford','Automobile','Van'),
('Crown Victoria','Ford','Automobile','Sedan'),
('F-150','Ford','Automobile','Pickup Truck'),
('Explorer','Ford','Automobile','Sport Utility Vehicle')

MERGE INTO [dbo].[VehicleModel] as vm
USING
(
	SELECT [Name] = m.[Name]
          ,[VehicleManufacturerID] = vmf.[ID]
		  ,[VehicleCategoryID] = vc.[ID]
          ,[VehicleSubCategoryID] = vsc.[ID]
	FROM @VehicleModel as m
	JOIN [dbo].[VehicleManufacturer] as vmf on m.[VehicleManufacturerer] = vmf.[Name]
	JOIN [dbo].[VehicleCategory] as vc on m.[VehicleCategory] = vc.[Name]
	JOIN [dbo].[VehicleSubCategory] as vsc on m.[VehicleSubCategory] = vsc.[Name]
) as d on vm.[Name] = d.[Name]
	  AND vm.[VehicleManufacturerID] = d.[VehicleManufacturerID]
WHEN NOT MATCHED THEN INSERT VALUES
([Name],[VehicleManufacturerID],[VehicleCategoryID],[VehicleSubCategoryID]);

--VehicleInventory
DECLARE @VehicleInventory TABLE(
[VIN] NVARCHAR(17) NOT NULL,
[VehicleModel] NVARCHAR(255) NOT NULL,
[CreatedDTS] DATETIME NULL
)

INSERT INTO @VehicleInventory VALUES
('JHAP21458S000667','Civic',GETUTCDATE()),
('JHAP21458S000668','S2000',GETUTCDATE()),
('JHAP21458S000669','Tacoma',GETUTCDATE()),
('JHAP21458S000633','Mustang',GETUTCDATE()),
('JHAP21458S000634','Sienna',GETUTCDATE()),
('JHAP21458S000635','F-150',GETUTCDATE()),
('JHAP21458S000655','Transit',GETUTCDATE()),
('JHAP21458S000666','S2000',GETUTCDATE()),
('JHAP21458S000611','Accord',GETUTCDATE()),
('JHAP21458S000622','Supra',GETUTCDATE())

MERGE INTO [dbo].[VehicleInventory] as vi
USING
(
	SELECT [VIN]
		  ,[VehicleModelID] = vm.[ID]
		  ,[CreatedDTS]
	FROM @VehicleInventory as i
	JOIN [dbo].[VehicleModel] as vm on i.[VehicleModel] = vm.[Name]
) as d on vi.[VIN] = d.[VIN]
WHEN NOT MATCHED THEN INSERT VALUES
([VIN],[VehicleModelID],[CreatedDTS]);

DECLARE @VehicleInventoryUser TABLE(
[VIN] NVARCHAR(17) NOT NULL,
[Email] NVARCHAR(255) NOT NULL,
[IsOwner] BIT NOT NULL,
[CreatedDTS] DATETIME NOT NULL,
[ModifiedDTS] DATETIME NULL
)

INSERT INTO @VehicleInventoryUser VALUES
('JHAP21458S000667','LenoJay@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000668','LenoJay@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000669','LenoJay@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000633','PresleyElvis@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000634','SinatraFrank@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000635','SinatraFrank@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000655','FitzgeraldElla@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000666','WolfkillKiki@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000611','TuringAlan@MikeDB.com',1,GETUTCDATE(),NULL),
('JHAP21458S000622','AnistonJennifer@MikeDB.com',1,GETUTCDATE(),NULL)

MERGE INTO [dbo].[VehicleInventoryUser] as viu
USING
(
	SELECT [UserID] = u.[ID]
		  ,[VehicleInventoryID] = vi.[ID]
		  ,[IsOwner] = iu.[IsOwner]
		  ,[CreatedDTS] = iu.[CreatedDTS]
		  ,[ModifiedDTS] = iu.[ModifiedDTS]
	From @VehicleInventoryUser AS iu
	JOIN [dbo].[VehicleInventory] as vi on iu.[VIN] = vi.[VIN]
	JOIN [dbo].[User] as u on iu.[Email] = u.[Email]
) as d on viu.[UserID] = d.[UserID] AND viu.[VehicleInventoryID] = d.[VehicleInventoryID]
WHEN NOT MATCHED THEN INSERT VALUES
([UserID],[VehicleInventoryID],[IsOwner],[CreatedDTS],[ModifiedDTS]);

--VehicleEntity
DECLARE @VehicleEntity TABLE(
[Name] NVARCHAR(255) NOT NULL,
[Description] NVARCHAR(500) NULL
)

INSERT INTO @VehicleEntity VALUES
('Details','General information about vehicle')

MERGE INTO [dbo].[VehicleEntity] as ve
USING
(
	SELECT [Name]
		  ,[Description]
	FROM @VehicleEntity
) as d on ve.[Name] = d.[Name]
WHEN NOT MATCHED THEN INSERT VALUES
([Name],[Description]);

GO

--VehicleAttribute
DECLARE @VehicleAttribute TABLE(
[VehicleEntity] NVARCHAR(255) NOT NULL,
[Name] NVARCHAR(255) NOT NULL,
[SortOrder] INT NOT NULL,
[Description] NVARCHAR(500) NULL
)

INSERT INTO @VehicleAttribute VALUES
('Details','VIN',1,NULL),
('Details','Year',2,NULL),
('Details','Color',3,NULL),
('Details','Trim',4,NULL),
('Details','StartingMileage',5,'Mileage when acquired'),
('Details','CurrentMileage',6,'Last known mileage'),
('Details','Title',7,'Clean or Salvaged')

MERGE INTO [dbo].[VehicleAttribute] as va
USING
(
	SELECT [VehicleEntityID] = ve.[ID]
		  ,[Name] = a.[Name]
		  ,[SortOrder]
		  ,[Description] = a.[Description]
	FROM @VehicleAttribute as a
	JOIN [dbo].[VehicleEntity] as ve on a.[VehicleEntity] = ve.[Name]
) as d on va.[VehicleEntityID] = d.[VehicleEntityID] AND va.[Name] = d.[Name]
WHEN NOT MATCHED THEN INSERT VALUES
([VehicleEntityID],[Name],[SortOrder],[Description]);

--VehicleValue
DECLARE @VehicleDetails TABLE(
[VIN] NVARCHAR(17) NOT NULL,
[Year] INT NOT NULL,
[Color] NVARCHAR(255) NOT NULL,
[Trim]  NVARCHAR(255) NOT NULL,
[StartingMileage] NVARCHAR(255) NOT NULL,
[CurrentMileage] NVARCHAR(255) NOT NULL,
[Title] NVARCHAR(255) NOT NULL
)

INSERT INTO @VehicleDetails VALUES
('JHAP21458S000667',2020,'Red','EX','16','2000','Clean'),
('JHAP21458S000668',2008,'Blue','','25000','85000','Clean'),
('JHAP21458S000669',2016,'White','TRD Off-Road','4','50000','Salvaged'),
('JHAP21458S000633',2022,'Yellow','','5','1000','Clean'),
('JHAP21458S000634',2020,'Red','','2000','2500','Clean'),
('JHAP21458S000635',2019,'Gray','Extended Range','1000','64000','Clean'),
('JHAP21458S000655',2017,'White','','6','37000','Clean'),
('JHAP21458S000666',2016,'White','','9','70000','Salvaged'),
('JHAP21458S000611',2018,'Gray','','12','84000','Clean'),
('JHAP21458S000622',2021,'Red','GR','1000','10000','Clean')

MERGE INTO [dbo].[VehicleValue] as vv
USING
(
	SELECT [ID] = unPvt.[ID]
		  ,[VehicleEntityID] = ve.[ID]
		  ,[VehicleAttributeID] = va.[ID]
		  ,[Value]
	FROM 
	(
		SELECT [ID] = [VIN]
			  ,[VIN] = CONVERT(NVARCHAR(MAX),[VIN])
			  ,[Year] = CONVERT(NVARCHAR(MAX),[Year])
			  ,[Color] = CONVERT(NVARCHAR(MAX),[Color])
			  ,[Trim] = CONVERT(NVARCHAR(MAX),[Trim])
			  ,[StartingMileage] = CONVERT(NVARCHAR(MAX),[StartingMileage])
			  ,[CurrentMileage] = CONVERT(NVARCHAR(MAX),[CurrentMileage])
			  ,[Title] = CONVERT(NVARCHAR(MAX),[Title])
		FROM @VehicleDetails
	) as SourceTable
	UNPIVOT
	(
		[Value] FOR [Attribute] IN 
		([VIN],[Year],[Color],[Trim],[StartingMileage],[CurrentMileage],[Title])
	) as unPvt
	JOIN [dbo].[VehicleAttribute] as va on unPvt.[Attribute] = va.[Name]
	JOIN [dbo].[VehicleEntity] as ve on va.[VehicleEntityID] = ve.[ID]
	WHERE ve.[Name] = 'Details'
) as d ON vv.[ID] = d.[ID] AND vv.[VehicleEntityID] = d.[VehicleEntityID] AND vv.[VehicleAttributeID] = d.[VehicleAttributeID]
WHEN NOT MATCHED THEN INSERT VALUES
([ID],[VehicleEntityID],[VehicleAttributeID],[Value]);