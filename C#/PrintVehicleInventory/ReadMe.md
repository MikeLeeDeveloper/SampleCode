Created By: Mike Lee
Created On: 2022-08-09
Description:
	This program demonstrates connecting to a local SQL Server database using
	LINQ, retrieving data with a view and stored procedure, and printing a report
	to an Excel sheet.
	
Instructions:
	1. Install SQL Server 2019 or later onto your machine (Developer Edition)
		https://www.microsoft.com/en-us/sql-server/sql-server-downloads?rtc=1
	2. Download SSMS
		https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16
	3. Create a local database with name of "." with Windows Authentication
	4. Navigate to Database directory and either:
		4a. Open CreateMikeDB.sql and execute query
		4b. Restore MikeDB.bacpac
			1. Right Click Databases
			2. Click Import Data-Tier Application...
			3. Introduction: Next
			4. Import Settings:
				Import from local disk (Find MikeDB.bacpac)
			5. Database Settings: Next
			6. Summary: Finish
	5. Once database has been added to you local "." Server:
		1. Navigate to SourceCode\bin\Debug
		2. Execute PrintVehicleInventory.exe

*Note:
	Program will create file VehicleReport.xlsx in the SourceCode\bin\Debug\Export
	directory. Github doesn't allow .XLSX extensions to be displayed so I've also 
	placed VehicleReport_OwnedVehicles.csv and VehicleReport_Jay_Leno.csv in the 
	directory to represent the named sheets within VehicleReport.xlsx.