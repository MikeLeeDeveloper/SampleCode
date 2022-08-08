@echo off
rem Batch file uses default Python3 install location, if command does not work
rem update directory to your install location

rem Update Pip
%USERPROFILE%/AppData/Local/Programs/Python/Python310/python.exe -m pip install --upgrade pip

rem Pandas for data manipulation and analytics
%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install pandas

rem Lxml for XML and HTML processing
%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install lxml

rem OpenPyXl for Read/Write xmlsx/xlsm/xltx/xltm
%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install openpyxl

rem xlrd for Read xls
%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install xlrd

rem xlwt for Write xls
rem xlwt is being removed from Pandas, use XLSX instead
rem %USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install xlwt