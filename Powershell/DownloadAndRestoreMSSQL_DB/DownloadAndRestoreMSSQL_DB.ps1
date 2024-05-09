# App Settings
# ------------------------------
# Get today's date
$todayDate = (Get-Date).ToString("yyyy-MM-dd")
$DB_DataPath = "{{.mdf File Directory}}}"
$DB_LogPath = "{{.ldf File Directory}}}"
# ex.$DB_DataPath = "C:\Program Files\Microsoft SQL Server\MSSQL15.MIKEDB19\MSSQL\DATA\"
# ex.$DB_LogPath = "C:\Program Files\Microsoft SQL Server\MSSQL15.MIKEDB19\MSSQL\DATA\"


# Databases to download
$dbBackups = @(
    'https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2019.bak',
    'https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2017.bak'
)
# ------------------------------
# End App Settings

function RestoreDB_PowerShell($dbName, $dbFilePath){
    $relocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("${dbName}_data", "${DB_DataPath}${dbName}.mdf")
    $relocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("${dbName}_log", "${DB_DataPath}${dbName}.ldf")

    # Kill existing processes
    try{
        $sqlSServer = New-Object Microsoft.SqlServer.Management.Smo.Server $SQL_ServerInstance
        $sqlSServer.KillAllProcesses($dbName)
    }
    catch{
        # Kill process will fail if new install
    }

    # Restore database
    # Note: 2024-05-09 Restore will fail if logical filenames for data and log do not match 
    Restore-SqlDatabase -ServerInstance $SQL_ServerInstance `
    -Database $fileName.split(".")[0] -BackupFile $filePath `
    -ReplaceDatabase -RelocateFile @($relocateData, $relocateLog)
}
function RestoreDB_SQLCommand($dbName, $dbFilePath){
    $mdfFilePath = "${DB_DataPath}${dbName}.mdf"
    $ldfFilePath = "${DB_LogPath}${dbName}.ldf"

    $sql = @"
    -- If database exists, close existing connections
    BEGIN TRY
        ALTER DATABASE ${dbName}
        SET single_user 
        WITH rollback IMMEDIATE
    END TRY
    BEGIN CATCH
        -- If no Database just restore
    END CATCH

    -- Get Logical Names for .mdf and .ldf file
    DECLARE @fileList TABLE (
    [LogicalName]			NVARCHAR(128) NULL
    ,[PhysicalName]         NVARCHAR(260) NULL
    ,[Type]                 CHAR(1) NULL
    ,[FileGroupName]        NVARCHAR(128) NULL
    ,[Size]                 NUMERIC(20,0) NULL
    ,[MaxSize]              NUMERIC(20,0) NULL
    ,[FileID]               BIGINT NULL
    ,[CreateLSN]            NUMERIC(25,0) NULL
    ,[DropLSN]              NUMERIC(25,0) NULL
    ,[UniqueID]             UNIQUEIDENTIFIER NULL
    ,[ReadOnlyLSN]          NUMERIC(25,0) NULL
    ,[ReadWriteLSN]         NUMERIC(25,0) NULL
    ,[BackupSizeInBytes]    BIGINT NULL
    ,[SourceBlockSize]      INT NULL
    ,[FileGroupID]          INT NULL
    ,[LogGroupGUID]         UNIQUEIDENTIFIER NULL
    ,[DifferentialBaseLSN]  NUMERIC(25,0) NULL
    ,[DifferentialBaseGUID] UNIQUEIDENTIFIER NULL
    ,[IsReadOnly]           BIT NULL
    ,[IsPresent]            BIT NULL
    ,[TDEThumbprint]        VARBINARY(32) NULL
    ,[SnapshotURL]          NVARCHAR(360) NULL
    )

    INSERT INTO @fileList EXEC ('RESTORE FILELISTONLY FROM DISK = ''$dbFilePath''')
    DECLARE @dataFileName VARCHAR(MAX) = (SELECT [LogicalName] FROM @fileList WHERE [PhysicalName] LIKE '%.mdf')
    DECLARE @logFileName VARCHAR(MAX) = (SELECT [LogicalName] FROM @fileList WHERE [PhysicalName] LIKE '%.ldf')

    -- Restore Database
    RESTORE DATABASE ${dbName}
    FROM DISK = '${dbFilePath}'

    -- Replace existing DB, move Data and Log files to new host's path
    WITH REPLACE,
    MOVE @dataFileName TO '$mdfFilePath',
    MOVE @logFileName TO '$ldfFilePath'
"@

    # Execute SQL command
    Invoke-Sqlcmd $sql
}

# Download each database into target directory
foreach ($db in $dbBackups){
    # Get file name, file path, and check if file exists
    $fileName = $db.split("/")[-1]
    $dbName = $fileName.split(".")[0]
    $filePath = "${PWD}\Resources\${fileName}"
    $fileExists = Test-Path $filePath

    if (!$fileExists -Or !(Get-Item $filePath).LastWriteTime.ToString("yyyy-MM-dd").Equals($todayDate)){
        # Download file if it does not exist on disk or was not downloaded today
        echo "Downloading: ${fileName}"
        try {
            Invoke-WebRequest $db -OutFile $filePath
        }
        catch {
            # Invalid URL
            echo "Unable to download file. Invalid URL."
        }
        
        if(Test-Path $filePath){
            try {
                # Restore database
                echo "Restoring: ${dbName}"
                RestoreDB_SQLCommand $dbName $filePath
            }
            catch {
                # Restore failed
                echo "Database restore failed. An error occurred:"
                echo $_.ScriptStackTrace
            }
        }
    }
    else {
        # Did not download
        echo "File ${fileName} was skipped because it was already downloaded today."
    }
}