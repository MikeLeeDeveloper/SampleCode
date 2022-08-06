@echo off
rem Batch file uses default Python3 install location, if command does not work
rem update directory to your install location

rem Update Pip
%USERPROFILE%/AppData/Local/Programs/Python/Python310/python.exe -m pip install --upgrade pip

rem Install Selenium using pip
%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install selenium