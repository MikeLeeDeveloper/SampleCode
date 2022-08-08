import os
import Resources.FileHelper as fileHelper

#Variables
validExt = ['.csv','.xml','.json','.xls','.xlsx']	#Valid File Type
inDir = os.getcwd() + "\\" + "Input" + "\\"			#Input Directory
outDir = os.getcwd() + "\\" + "Output" + "\\"		#Output Directory

#Get all files from Input Directory
def getFiles():
	lstFiles = os.listdir(inDir)
	return lstFiles

#Get list of invalid files
def validateExtensions(lstFiles):
	invalidFiles = []

	for file in lstFiles:
		isValidExt = False		#Reset isValidExt

		#Compare each file to valid extensions
		for ext in validExt:
			if os.path.splitext(file)[1].lower() == ext:
				isValidExt = True

		#Append invalid files to list
		if isValidExt == False:
			invalidFiles.append(file)

	return invalidFiles

#Convert Input to DataFrame and Export to Output
def inputToOutputFile(fileName,fileType):
	exportFilePath = outDir + os.path.splitext(fileName)[0] + fileType

	dataFrame = fileHelper.fileToDataFrame(inDir + fileName)
	fileHelper.exportDataFrame(exportFilePath,dataFrame)