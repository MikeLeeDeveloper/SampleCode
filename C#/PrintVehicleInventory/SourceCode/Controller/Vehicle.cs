using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using PrintVehicleInventory.Libraries;
using PrintVehicleInventory.Model;

namespace PrintVehicleInventory.Controller
{
    class Vehicle:IDisposable
    {
        #region "Variables"
        public MikeDBDataContext _mikeDBDataContext;
        #endregion

        #region "Methods"
        public void Dispose()
        {
            _mikeDBDataContext.Dispose();
            _mikeDBDataContext = null;
        }
        public Vehicle(string connString)
        {
            _mikeDBDataContext = new MikeDBDataContext(connString);
        }
        #endregion

        public List<VehicleDetails> GetOwnedVehicles() 
        {
            var result = new List<VehicleDetails>();

            try
            {
                var ownedVehicles = _mikeDBDataContext.OwnedVehicles.OrderBy(x => x.Category).ThenBy(x => x.Make).ThenBy(x => x.Model).ToList();

                if (ownedVehicles.Any())
                {
                    foreach (var v in ownedVehicles)
                    {
                        int modelYear = 0;
                        int mileage = 0;

                        result.Add(new VehicleDetails
                        {
                            InventoryNumber = v.InventoryNumber,
                            Category = v.Category,
                            SubCategory = v.SubCategory,
                            Make = v.Make,
                            Model = v.Model,
                            Year = Int32.TryParse(v.Year, out modelYear) ? modelYear : 0,
                            Color = v.Color,
                            Trim = v.Trim,
                            LastRecordedMileage = Int32.TryParse(v.Mileage, out mileage) ? mileage : 0,
                            Title = v.Title
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: \n" + ex + "\n\n");
                Thread.Sleep(5000);
            }

            return result;
        }
        public List<VehicleDetails> GetVehicleByUserID(int userID)
        {
            var result = new List<VehicleDetails>();

            try
            {
                var ownedVehicles = _mikeDBDataContext.GetVehicleDetailByUserID(userID).ToList();

                if (ownedVehicles.Any())
                {
                    ownedVehicles = ownedVehicles.OrderBy(x => x.Category).ThenBy(x => x.Make).ThenBy(x => x.Model).ToList();

                    foreach (var v in ownedVehicles)
                    {
                        int modelYear = 0;
                        int startingMileage = 0;
                        int lastRecordedMileage = 0;

                        result.Add(new VehicleDetails
                        {
                            Category = v.Category,
                            SubCategory = v.SubCategory,
                            Make = v.Make,
                            Model = v.Model,
                            Year = Int32.TryParse(v.Year, out modelYear) ? modelYear : 0,
                            Color = v.Color,
                            Trim = v.Trim,
                            StartingMileage = Int32.TryParse(v.StartingMileage, out startingMileage) ? startingMileage : 0,
                            LastRecordedMileage = Int32.TryParse(v.LastRecordedMileage, out lastRecordedMileage) ? lastRecordedMileage : 0,
                            Title = v.Title,
                            InPosession = v.InPosession.ToUpper() == "TRUE" ? true : false
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: \n" + ex + "\n\n");
                Thread.Sleep(5000);
            }

            return result;
        }

        public DataTable OwnedVehiclesToDataTable(List<VehicleDetails> sheet)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("InventoryNumber");
            dt.Columns.Add("Category");
            dt.Columns.Add("SubCategory");
            dt.Columns.Add("Make");
            dt.Columns.Add("Model");
            dt.Columns.Add("Year");
            dt.Columns.Add("Color");
            dt.Columns.Add("Trim");
            dt.Columns.Add("Mileage");
            dt.Columns.Add("Title");

            foreach (var r in sheet)
            {
                dt.Rows.Add(r.InventoryNumber, r.Category, r.SubCategory, r.Make, r.Model, r.Year, r.Color, r.Trim, r.LastRecordedMileage, r.Title);
            }

            return dt;
        }

        public DataTable UserVehicleToDataTable(List<VehicleDetails> sheet)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Category");
            dt.Columns.Add("SubCategory");
            dt.Columns.Add("Make");
            dt.Columns.Add("Model");
            dt.Columns.Add("Year");
            dt.Columns.Add("Color");
            dt.Columns.Add("Trim");
            dt.Columns.Add("StartingMileage");
            dt.Columns.Add("LastRecordedMileage");
            dt.Columns.Add("Title");
            dt.Columns.Add("InPosession");

            foreach (var r in sheet)
            {
                string inPosession = r.InPosession == true ? "True" : "False";

                dt.Rows.Add(r.Category, r.SubCategory, r.Make, r.Model, r.Year, r.Color, r.Trim, r.StartingMileage,r.LastRecordedMileage, r.Title, inPosession);
            }

            return dt;
        }
    }
}
