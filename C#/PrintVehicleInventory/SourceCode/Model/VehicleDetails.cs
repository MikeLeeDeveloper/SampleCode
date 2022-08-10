namespace PrintVehicleInventory.Model
{
    public class VehicleDetails
    {
        public int InventoryNumber { get; set; }
        public string Category { get; set; }
        public string SubCategory { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public int Year { get; set; }
        public string Color { get; set; }
        public string Trim { get; set; }
        public int StartingMileage { get; set; }
        public int LastRecordedMileage { get; set; }
        public string Title { get; set; }
        public bool InPosession { get; set; }
    }
}
