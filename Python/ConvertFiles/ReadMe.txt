Created By: Mike Lee
Created On: 2022-08-07
Description:
	Easily read CSV, XML, JSON, XLSX files and convert them to oneanother.
	Program can also read but not write XLS files.
	
Instructions:
	1. If first time running, under Resources directory run InstallResources.bat
	2. Place files into Input directory
	3. Run RunPython.bat
	4. Retrieve converted files from Output directory
	
Note:
	Due to the variation in JSON formats, JSON files may not parse properly. 
	Program has been set to use the "records" format. If your input file does 
	not parse, you can try modifying the FileHelper.py file under the Resources
	directory and change the value for "jsonFormat" to one of the following:
		split
		records
		index
		columns
		values
		table
	
	Pandas library (data manipulation) will no longer support xlwt library in
	future updates. At the time of this program's creation, the library is still
	supported but the feature has been commented out. To enable feature:
		1. In InstallResources.bat under Resources directory, uncomment line 22
			%USERPROFILE%/AppData/Local/Programs/Python/Python310/Scripts/pip.exe install xlwt
		2. In ConvertFile.py, comment out line 36
			#validExt.remove(".xls")
		3. In FileHelper.py in under Resources directory, uncomment line 40,41
			case ".xls":
				data.to_excel(filePath, index=False)