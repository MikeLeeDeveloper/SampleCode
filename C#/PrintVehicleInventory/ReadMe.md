Created By: Mike Lee<br />
Created On: 2022-08-09<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;This program demonstrates connecting to a local SQL Server database using<br />
&nbsp;&nbsp;&nbsp;&nbsp;LINQ, retrieving data with a view and stored procedure, and printing a report<br />
&nbsp;&nbsp;&nbsp;&nbsp;to an Excel sheet.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Install SQL Server 2019 or later onto your machine (Developer Edition)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://www.microsoft.com/en-us/sql-server/sql-server-downloads?rtc=1<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. Download SSMS<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16<br />
&nbsp;&nbsp;&nbsp;&nbsp;3. Create a local database with name of "." with Windows Authentication<br />
&nbsp;&nbsp;&nbsp;&nbsp;4. Navigate to Database directory and either:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4a. Open CreateMikeDB.sql and execute query<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4b. Restore MikeDB.bacpac<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. Right Click Databases<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. Click Import Data-Tier Application...<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. Introduction: Next<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. Import Settings:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Import from local disk (Find MikeDB.bacpac)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. Database Settings: Next<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6. Summary: Finish<br />
&nbsp;&nbsp;&nbsp;&nbsp;5. Once database has been added to you local "." Server:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. Navigate to SourceCode\bin\Debug<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. Execute PrintVehicleInventory.exe
<br /><br />
*Note:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Program will create file VehicleReport.xlsx in the SourceCode\bin\Debug\Export<br />
&nbsp;&nbsp;&nbsp;&nbsp;directory. Github doesn't allow .XLSX extensions to be displayed so I've also<br />
&nbsp;&nbsp;&nbsp;&nbsp;placed VehicleReport_OwnedVehicles.csv and VehicleReport_Jay_Leno.csv in the<br />
&nbsp;&nbsp;&nbsp;&nbsp;directory to represent the named sheets within VehicleReport.xlsx.<br />