@echo off
setlocal ENABLEDELAYEDEXPANSION

rem Get current directory name
for %%I in (.) do set directoryNameEx=%%~nxI.py

rem Compare all python files to current directory name
for %%I in (*.py) do (
	if !directoryNameEx!==%%I (
		rem If file matches directory name set executable
		set pythonEx=%%I
	) else (
		rem If file matches default start program Program.py
		if %%I==Program.py (
			set defaultEx=%%I
		)

		rem Alternate Option: Else set default to last executable
		rem set defaultEx=%%I
	)
)

rem If directory named python file not found, use default executable
if "!pythonEx!"=="" set pythonEx=!defaultEx!

if "!pythonEx!"=="" (
	echo Error: Executable must be named after the current directory or Program.py
) else (
	python3 !pythonEx!
	rem If python3 does not execute natively, use direct path to your python.exer executable
	rem %USERPROFILE%/AppData/Local/Programs/Python/Python310/python.exe !pythonEx!
)

endlocal
echo.
rem pause