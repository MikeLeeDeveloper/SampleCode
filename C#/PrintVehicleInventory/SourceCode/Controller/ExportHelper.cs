using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Threading;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;

namespace PrintVehicleInventory.Controller
{
    public class ExportHelper
    {
        public void WriteToExcel(List<DataTable> vehicleDetail, List<string> sheetName)
        {
            try
            {
                IWorkbook workbook = new XSSFWorkbook();

                for (int s = 0; s < vehicleDetail.Count; s++)
                {
                    ISheet result = workbook.CreateSheet(sheetName[s]);
                    DataTable dt = vehicleDetail[s];

                    //Make Headers
                    IRow headerRow = result.CreateRow(0);
                    for (int x = 0; x < dt.Columns.Count; x++)
                    {
                        headerRow.CreateCell(x).SetCellValue(dt.Columns[x].ColumnName);
                    }

                    //Make Rows
                    for (int r = 0; r < dt.Rows.Count; r++)
                    {
                        IRow row = result.CreateRow(r + 1);
                        for (int x = 0; x < dt.Columns.Count; x++)
                        {
                            row.CreateCell(x).SetCellValue(dt.Rows[r][x].ToString());
                        }
                    }
                }            

                using (FileStream stream = new FileStream(Directory.GetCurrentDirectory() + "\\Export\\VehicleReport.xlsx", FileMode.Create, FileAccess.Write))
                {
                    workbook.Write(stream);
                }

                workbook.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: \n" + ex + "\n\n");
                Thread.Sleep(5000);
            }
        }
    }
}
