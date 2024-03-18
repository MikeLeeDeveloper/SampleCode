Created By: Mike Lee<br />
Created On: 2021-04-17<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;This program unpivots denormalized data (flat spreadsheets) into a more<br />
&nbsp;&nbsp;&nbsp;&nbsp;normalized format to be used with data analytics engines and databases.<br />
&nbsp;&nbsp;&nbsp;&nbsp;Normalization also allows datasets to be more scalable without creating<br />
&nbsp;&nbsp;&nbsp;&nbsp;unused fields for every entry.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Ensure all sheets have same number of headers in same order<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. Convert file to Excel 97-2003 (XLS)<br />
&nbsp;&nbsp;&nbsp;&nbsp;3. Navigate to /Executable<br />
&nbsp;&nbsp;&nbsp;&nbsp;4. Put file into folder ImportExcelFile<br />
&nbsp;&nbsp;&nbsp;&nbsp;5. Run ExcelPivoter.exe (File Type: Application)<br />
&nbsp;&nbsp;&nbsp;&nbsp;6. Confirm Import all to one file. (Enter 'y')<br />
&nbsp;&nbsp;&nbsp;&nbsp;7. Enter number of static columns (For TestFile, enter 4)<br />
&nbsp;&nbsp;&nbsp;&nbsp;8. Recover pivoted CSV from folder ExportPivotedCSV