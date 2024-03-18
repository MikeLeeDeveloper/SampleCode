Created By: Mike Lee<br />
Created On: 2022-08-07<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Easily read CSV, XML, JSON, XLSX files and convert them to oneanother.<br />
&nbsp;&nbsp;&nbsp;&nbsp;Program can also read but not write XLS files.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Download and install Python3<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://www.python.org/downloads/<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. If first time running, under Resources directory run InstallResources.bat<br />
&nbsp;&nbsp;&nbsp;&nbsp;3. Place files into Input directory<br />
&nbsp;&nbsp;&nbsp;&nbsp;4. Run RunPython.bat<br />
&nbsp;&nbsp;&nbsp;&nbsp;5. Retrieve converted files from Output directory
<br /><br />	
Note:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Due to the variation in JSON formats, JSON files may not parse properly.<br />
&nbsp;&nbsp;&nbsp;&nbsp;Program has been set to use the "records" format. If your input file does<br />
&nbsp;&nbsp;&nbsp;&nbsp;not parse, you can try modifying the FileHelper.py file under the Resources<br />
&nbsp;&nbsp;&nbsp;&nbsp;directory and change the value for "jsonFormat" to one of the following:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;split<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;records<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;index<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;columns<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;values<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;table
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;Pandas library (data manipulation) will no longer support the xlwt library<br />
&nbsp;&nbsp;&nbsp;&nbsp;(writing XLS) in future updates. At the time of this program's creation, the<br />
&nbsp;&nbsp;&nbsp;&nbsp;library is still supported but the feature has been commented out.<br />
&nbsp;&nbsp;&nbsp;&nbsp;To enable feature:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. In InstallResources.bat under Resources directory, uncomment line 22<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install xlwt<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. In ConvertFile.py, comment out line 36<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#validExt.remove(".xls")<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. In FileHelper.py in under Resources directory, uncomment line 40,41<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;case ".xls":<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;data.to_excel(filePath, index=False)