import os,json
import pandas as pd

jsonFormat = "records"

#Import File into DataFrame
def fileToDataFrame(filePath):
	fileType = os.path.splitext(filePath)[1].lower()

	match fileType:
		case ".csv":
			df = pd.read_csv(filePath)
		case ".json":
			df = pd.read_json(filePath, orient=jsonFormat)
		case ".xml":
			df = pd.read_xml(filePath)
		case ".xls":
			df = pd.read_excel(filePath)
		case ".xlsx":
			df = pd.read_excel(filePath)
		case default:
			print("Error: Unknown FileType")
			print(fileName)

	return df

#Export DataFrame into File
def exportDataFrame(filePath,data):
	fileType = os.path.splitext(filePath)[1].lower()

	match fileType:
		case ".csv":
			data.to_csv(filePath, index=False)
		case ".json":
			jsonObjects = data.to_json(orient=jsonFormat)
			with open(filePath, "w") as outFile:
				outFile.write(jsonObjects)
		case ".xml":
			data.to_xml(filePath, index=False)
		#case ".xls":
		#	data.to_excel(filePath, index=False)
		case ".xlsx":
			data.to_excel(filePath, index=False)
		case default:
			print("Error: Unknown FileType")