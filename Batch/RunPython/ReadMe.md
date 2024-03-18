Created By: Mike Lee
Created On: 2022-08-05
Description:
	This batch file allows Windows Scheduler to execute Python3 files.
	You may also open this in PowerShell to easily debug Python3 programs 
	without	the use of an IDE. Powershell does not close the terminal after
	completion so any outputs or errors will persist. The terminal can also
	be placed in a fixed location on your monitor for easy access.
	
Instructions:
	1. Place RunPython.bat in same the directory as the python file to run
	2. Verify the python file you want to run is named the same as the directory 
		or as "Program.py" (Case Sensitive)
	3. Right click inside the directory and click "Open PowerShell window here"
	4. Type in .\RunPython.bat
	
Note: 	
	To run again, navigate previous commands using the up and down arrow keys
	Type "clear" to clear terminal