using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;

namespace ExcelPivoter
{
    class Program
    {
        static void Main(string[] args)
        {
            //Get Directory and Files
            //var parentDirectory = Directory.GetParent(Directory.GetCurrentDirectory());
            var parentDirectory = Directory.GetCurrentDirectory();
            var inputDirectory = parentDirectory + "\\ImportExcelFile\\";
            var exportDirectory = parentDirectory + "\\ExportPivotedCSV\\";
            var importFiles = Directory.GetFiles(inputDirectory);
            List<DataTable> dtList = new List<DataTable>();
            List<string> sheetNameList = new List<string>();


            Console.WriteLine("Starting Excel Pivoter");

            //User Error
            if (importFiles.Count() == 0)
            {
                Console.WriteLine("You forgot to input a file dum dum.");
                Thread.Sleep(5000);
            }
            //Currently only tested for single file
            else if (importFiles.Count() > 1)
            {
                Console.WriteLine("Please input only one file at a time.");
                Thread.Sleep(5000);
            }
            //Run
            else
            {
                //Loop files
                foreach (var file in importFiles)
                {
                    Console.WriteLine("Loading File: " + Path.GetFileName(file));
                    try
                    {
                        //Load all sheets in Excel Workbook into DataTables
                        HSSFWorkbook hssfwb;
                        using (FileStream fs = new FileStream(file, FileMode.Open, FileAccess.Read))
                        {
                            hssfwb = new HSSFWorkbook(fs);
                        }

                        //Loop Sheets
                        var sheetCount = hssfwb.NumberOfSheets;
                        Console.WriteLine("Sheets discovered: " + sheetCount);

                        for (int x = 0; x < sheetCount; x++)
                        {
                            var dt = new DataTable();
                            ISheet sheet = hssfwb.GetSheetAt(x);
                            System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
                            sheetNameList.Add(sheet.SheetName);

                            Console.WriteLine("\nSheet {0}: {1}", (x + 1), sheet.SheetName);

                            //Assign Headers
                            IRow headerRow = sheet.GetRow(0);
                            int cellCount = headerRow.LastCellNum;
                            for (int j = 0; j < cellCount; j++)
                            {
                                ICell cell = headerRow.GetCell(j);
                                string header = "\"" + cell.ToString().Trim().Replace("_", "").Replace("\"\"","\"").Replace("\"", "\"\"") + "\"";
                                dt.Columns.Add(header);
                                Console.WriteLine("    " + cell.ToString().Trim().Replace("_", ""));
                            }

                            //Populate Data
                            for (int i = (sheet.FirstRowNum + 1); i <= sheet.LastRowNum; i++)
                            {
                                IRow row = sheet.GetRow(i);
                                DataRow dataRow = dt.NewRow();

                                for (int j = row.FirstCellNum; j < cellCount; j++)
                                {
                                    if (row.GetCell(j) != null)
                                        dataRow[j] = "\"" + row.GetCell(j).ToString().Replace("\"\"", "\"").Replace("\"", "\"\"") + "\"";
                                }
                                dt.Rows.Add(dataRow);
                            }

                            dtList.Add(dt);
                        }

                        Console.WriteLine("Import successful!\n");

                        //Get Header Count
                        bool allSameHeader = true;
                        if (sheetCount > 1)
                        {
                            Console.WriteLine("Do all sheets have the same static headers? (y/n):");
                            string staticHeaders = Console.ReadLine().ToUpper().Trim();

                            if (staticHeaders == "Y" || staticHeaders == "YES")
                            {
                                allSameHeader = true;
                            }
                            else
                            {
                                allSameHeader = false;
                            }
                        }

                        bool oneFile = false;
                        Console.WriteLine("Import all to one file?");
                        string oneFileResponse = Console.ReadLine().ToUpper().Trim();

                        if (oneFileResponse == "Y" || oneFileResponse == "YES")
                        {
                            oneFile = true;
                        }
                        else
                        {
                            oneFile = false;
                        }

                        if (allSameHeader)
                        {
                            Console.WriteLine("How many static columns are there?:");
                            string readColumnNum = Console.ReadLine();

                            int parseInt;
                            bool isInt = Int32.TryParse(readColumnNum, out parseInt);

                            if (isInt)
                            {
                                Console.WriteLine();
                                int currentSheet = 0;
                                DataTable dtOneFilePivot = new DataTable();
                                bool firstSheet = true;

                                //Pivot each sheet
                                foreach (var ws in dtList)
                                {
                                    //Create new DataTable
                                    DataTable dtPivot = new DataTable();
                                    var wsColumns = ws.Columns;

                                    //Export to one File
                                    if (oneFile == true && firstSheet == true)
                                    {
                                        for (int x = 0; x < parseInt; x++)
                                        {
                                            dtOneFilePivot.Columns.Add(ws.Columns[x].ColumnName);
                                        }

                                        dtOneFilePivot.Columns.Add("\"Header\"");
                                        dtOneFilePivot.Columns.Add("\"Value\"");
                                        dtOneFilePivot.Columns.Add("\"SortOrder\"");

                                        firstSheet = false;
                                    }

                                    //Export to individual files
                                    if (oneFile == false)
                                    {
                                        for (int x = 0; x < parseInt; x++)
                                        {
                                            dtPivot.Columns.Add(ws.Columns[x].ColumnName);
                                        }

                                        dtPivot.Columns.Add("\"Header\"");
                                        dtPivot.Columns.Add("\"Value\"");
                                        dtPivot.Columns.Add("\"SortOrder\"");
                                    }                                 

                                    //Loop Rows
                                    foreach (DataRow row in ws.Rows)
                                    {
                                        List<string> staticColumns = new List<string>();
                                        int sortOrder = 1;

                                        for (int x = 0; x < wsColumns.Count; x++)
                                        {
                                            //Get PrimaryKey
                                            if (x < parseInt)
                                            {
                                                staticColumns.Add(row[x].ToString());
                                            }
                                            //Get Variables
                                            else
                                            {
                                                List<string> dataRowList = new List<string>();

                                                //Parse in static header
                                                foreach (var header in staticColumns)
                                                {
                                                    dataRowList.Add(header);
                                                }

                                                //Format date if value is date
                                                DateTime parseDate;
                                                string valueRaw = row[x].ToString().Trim();
                                                string valueParsed = DateTime.TryParse(valueRaw, out parseDate) ? parseDate.ToString("yyyy-MM-dd") : valueRaw;

                                                dataRowList.Add(wsColumns[x].ColumnName);   //Header
                                                dataRowList.Add(valueParsed); //Score
                                                dataRowList.Add("\"" + sortOrder + "\"");   //SortOrder

                                                if (oneFile == true)
                                                {
                                                    dtOneFilePivot.Rows.Add(dataRowList.ToArray());
                                                }
                                                else
                                                {
                                                    dtPivot.Rows.Add(dataRowList.ToArray());
                                                }                                               
                                                
                                                sortOrder++;
                                            }
                                        }
                                    }

                                    //Print Single Sheet
                                    if (dtPivot.Rows.Count > 0)
                                    {
                                        StringBuilder sb = new StringBuilder();

                                        IEnumerable<string> columnNames = dtPivot.Columns.Cast<DataColumn>().
                                                                          Select(column => column.ColumnName);
                                        sb.AppendLine(string.Join(",", columnNames));

                                        foreach (DataRow row in dtPivot.Rows)
                                        {
                                            IEnumerable<string> fields = row.ItemArray.Select(field => field.ToString());
                                            sb.AppendLine(string.Join(",", fields));
                                        }

                                        File.WriteAllText(exportDirectory + sheetNameList[currentSheet] + ".csv", sb.ToString());
                                        Console.WriteLine("Pivot Successful! :" + sheetNameList[currentSheet]);
                                    }

                                    currentSheet++;
                                }

                                //Print One File
                                if (dtOneFilePivot.Rows.Count > 0)
                                {
                                    StringBuilder sb = new StringBuilder();

                                    IEnumerable<string> columnNames = dtOneFilePivot.Columns.Cast<DataColumn>().
                                                                      Select(column => column.ColumnName);
                                    sb.AppendLine(string.Join(",", columnNames));

                                    foreach (DataRow row in dtOneFilePivot.Rows)
                                    {
                                        IEnumerable<string> fields = row.ItemArray.Select(field => field.ToString());
                                        sb.AppendLine(string.Join(",", fields));
                                    }

                                    File.WriteAllText(exportDirectory + Path.GetFileName(file) + ".csv", sb.ToString());
                                    Console.WriteLine("Pivot Successful! :" + Path.GetFileName(file));
                                }

                            }
                            else
                            {
                                Console.WriteLine("Common' now... {0} is not a number", readColumnNum);
                            }
                        }
                        else
                        {
                            Console.WriteLine("Program currently only supports same static header worksheets.");
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("\nError: Please send this error message to a developer.\n");
                        Console.WriteLine(ex);
                        Console.ReadLine();
                    }
                }
            }

            Console.WriteLine("\nExcel Pivoter Complete!" +
                "\nHave a wonderful day!");
            Thread.Sleep(5000);
        }
    }
}
