Created By: Mike Lee<br />
Created On: 2024-05-09<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;This PowerShell script downloads a list of .bak files from a source (Microsoft) and will restore it to<br /> 
&nbsp;&nbsp;&nbsp;&nbsp;the host machine's SQL Server instance. File will only download if it does not exist in Resources<br />
&nbsp;&nbsp;&nbsp;&nbsp;directory or if it was not downloaded today.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Open DownloadAndRestoreMSSQL_DB.ps1 in a text editor and update the following variables:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1a. <b>$SQL_ServerInstance</b>: Name of your Server<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1b. <b>$DB_DataPath</b>: Location for .mdf file<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1c. <b>$DB_DataPath</b>: Location for .ldf file<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1d. <b>$dbBackups</b>: .bak files you want to download<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. Verify Account name for SQL Server has access to Resource Directory<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2a. Open Sql Server Configuration Manager<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2a. Right click your SQL Server instance and select Properties<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2b. Under Log On, copy the Account Name<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="ReadMeImages/AccountName.png" alt="drawing" style="width:700px;"/><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2c. In project direcotry, right click the Resources directory and click Properties<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2d. Under Security, click Edit<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2e. From Permissions for Resources, click Add<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2f. From Select Users or Groups, paste the SQL Server Account Name and click Check Names<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="ReadMeImages/Resources.png" alt="drawing" style="width:700px;"/><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2g. If successful, name will update to user object. <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="ReadMeImages/VerifyAccountName.png" alt="drawing" style="width:700px;"/><br />