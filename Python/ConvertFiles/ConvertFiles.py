import time
import Resources.Helper as helper

#Get Files
lstFiles = helper.getFiles()

#Error if input directory empty
if len(lstFiles) == 0:
	print("Error: No files in drirectory")
	time.sleep(10)
#Files exist
else:	
	#Validate file extensions
	invalidFiles = helper.validateExtensions(lstFiles)

	#If invalid files discovered
	if len(invalidFiles) > 0:
		strFile = "files are " if len(invalidFiles) > 1 else "file is "
		print("The following " + strFile + "invalid:")

		for file in invalidFiles:
			print("  " + file)

		time.sleep(10)
	#Valid files
	else:
		isValidExt = False				#Valid extension flag

		#Display files
		print("Files Discovered:")
		for file in lstFiles:
			print("  " + file)

		#Get Valid Extensions
		validExt = helper.validExt
		validExt.remove(".xls")			#Read but can't print

		#Prompt user for new file type, loop if invalid
		while isValidExt == False:
			print()
			print("What would you like to convert these files to?")
			print("Options: .csv,.json,.xml,.xlsx")

			#Get input and sanitize
			outExt = "." + input().lower().replace(".","")

			#Validate response, break loop if valid
			for ext in validExt:
				if ext == outExt:
					isValidExt = True

			if isValidExt == False:
				print("Error: Invalid file type")

		#Convert File to DataFrame, Convert and Export to File
		for fileName in lstFiles:
			helper.inputToOutputFile(fileName,outExt)

		strFile = "files have " if len(lstFiles) > 1 else "file has "
		print()
		print("Your " + strFile + "been converted to: " + outExt)
		time.sleep(10)