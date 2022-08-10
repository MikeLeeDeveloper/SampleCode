using PrintVehicleInventory.Libraries;
using System;
using System.Linq;
using System.Threading;

namespace PrintVehicleInventory.Controller
{
    class User : IDisposable
    {
        #region "Variables"
        public MikeDBDataContext _mikeDBDataContext;
        #endregion

        #region "Methods"
        public void Dispose()
        {
            //_mikeDBDataContext.Dispose();
            //_mikeDBDataContext = null;
        }
        public User(string connString)
        {
            _mikeDBDataContext = new MikeDBDataContext(connString);
        }
        #endregion
        public Model.UserDetails GetUserByEmail(string eMail)
        {
            var result = new Model.UserDetails();

            try
            {
                var user = _mikeDBDataContext.Users
                    .Where(x => x.Email.ToLower().Trim() == eMail.ToLower().Trim())
                    .FirstOrDefault();

                if (user != null)
                {
                    result.UserID = user.ID;
                    result.Email = user.Email;
                    result.LastName = user.LastName;
                    result.FirstName = user.FirstName;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: \n" + ex + "\n\n");
                Thread.Sleep(5000);
            }

            return result;
        }
    }
}
