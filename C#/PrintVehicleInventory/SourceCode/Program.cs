using System.Collections.Generic;
using System.Linq;
using System.Configuration;
using PrintVehicleInventory.Controller;
using System.Data;
using System;
using System.Threading;

namespace PrintVehicleInventory
{
    class Program
    {
        static void Main(string[] args)
        {
            //Variables
            string mikeDbConnString = ConfigurationManager.ConnectionStrings["PrintVehicleInventory.Properties.Settings.MikeDBConnectionString"].ToString();
            var exportList = new List<DataTable>();
            var exportSheetName = new List<string>();

            try
            {

                Console.WriteLine("Connecting to database...");
                using (var v = new Vehicle(mikeDbConnString))
                {
                    //Get user details for Jay Leno
                    Console.WriteLine("Finding User...");
                    var u = new Controller.User(mikeDbConnString);
                    var user = u.GetUserByEmail("LenoJay@MikeDB.com");
                    u.Dispose();

                    //Get all users owned vehicles from view
                    Console.WriteLine("Finding all owned vehicles...");
                    var ownedVehicles = v.GetOwnedVehicles();

                    if (ownedVehicles.Any())
                    {
                        //Convert to DataTable to simplify exporting using NPOI
                        exportList.Add(v.OwnedVehiclesToDataTable(ownedVehicles));
                        exportSheetName.Add("OwnedVehicles");
                    }

                    if (user != null)
                    {
                        //Get single user's vehicles from StoredProcedure
                        Console.WriteLine("Finding user's vehicles...");
                        var userVehicles = v.GetVehicleByUserID(user.UserID);

                        if (userVehicles.Any())
                        {
                            //Convert to DataTable to simplify exporting using NPOI
                            exportList.Add(v.UserVehicleToDataTable(userVehicles));
                            exportSheetName.Add(user.LastName + "_" + user.FirstName);
                        }
                    }

                    if (exportList.Any())
                    {
                        //Print results to Excel
                        Console.WriteLine("Exporting to Excel");
                        var exportHelper = new ExportHelper();
                        exportHelper.WriteToExcel(exportList, exportSheetName);
                    }
                }

                Console.WriteLine("Program completed successfully!");
                Thread.Sleep(5000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Critical error: Program has failed at Main()");
                Thread.Sleep(5000);
            }
        }
    }
}
