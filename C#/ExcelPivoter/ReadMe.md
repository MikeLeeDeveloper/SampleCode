Created By: Mike Lee
Created On: 2021-04-17
Description:
	This program unpivots denormalized data (flat spreadsheets) into a more 
	normalized format to be used with data analytics engines and databases.
	Normalization also allows datasets to be more scalable without creating
	unused fields for every entry.

Instructions:
	1. Ensure all sheets have same number of headers in same order
	2. Convert file to Excel 97-2003 (XLS)
	3. Navigate to /Executable
	4. Put file into folder ImportExcelFile
	5. Run ExcelPivoter.exe (File Type: Application)
	6. Confirm Import all to one file. (Enter 'y')
	7. Enter number of static columns (For TestFile, enter 4)
	8. Recover pivoted CSV from folder ExportPivotedCSV