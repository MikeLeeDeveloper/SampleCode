@echo off
setlocal ENABLEDELAYEDEXPANSION
set tab= 

rem Change directory to FilesToRenameExtension
cd FilesToRenameExtension

rem Count distinct extensions
set /a enum=0

rem Loop all files in directory
for %%i in (*.*) do (
    rem Insert first extension
    if !enum!==0 (
        set dist[!enum!]=%%~xi
        set /a enum=enum+1
    ) else (
        rem Compare current extension against distinct list
        set /a isDuplicate=0

        for /f "tokens=2 delims==" %%d in ('set dist[') do (
            if %%~xi==%%d (
                set /a isDuplicate=1
            )
        )

        rem If not duplicate, insert extension
        if !isDuplicate!==0 (
            set dist[!enum!]=%%~xi
            set /a enum=enum+1
        )
    )
)

echo Extensions discovered:
for /f "tokens=2 delims==" %%d in ('set dist[') do (
	echo %tab% %%d
)

echo.

rem Prompt user for new file extension
set /p newExtension=What extension would you like to change these files to?: 

rem Sanitize user extension to have only one period at the front
set newExtension=.%newExtension:.=%

echo.

rem Rename file extensions
for /f "tokens=2 delims==" %%d in ('set dist[') do (
	ren *%%d *%newExtension%
    echo Extension %%d updated to %newExtension%
)

endlocal
timeout /t 5