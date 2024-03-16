using System;
using System.Data.SqlClient;
using System.Data;

namespace webapi_demo.Models
{
    public class UserMaster
    {
        JSONMaker jm = new JSONMaker();

        public string InvalidRequest()
        {
            return jm.Singlevalue("Invalid Request");
        }

        public class UserMasterModel
        {
            public string userId { get; set; }
            public string fullName { get; set; }
            public string emailId { get; set; }
            public string password { get; set; }
            public string contactNumber { get; set; }
            public string homeAddress { get; set; }
            public string workAddress { get; set; }
            public string homeAddressLatLng { get; set; }
            public string workAddressLatLng { get; set; }
            public string newPassword { get; set; } 


        }

        public string Register(UserMasterModel userMasterModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select emailId from [UserMaster] " +
                    "where LOWER(emailId) = LOWER(@emailId)", con);
                da.SelectCommand.Parameters.AddWithValue("@emailId", userMasterModel.emailId);

                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count > 0)
                {
                    //EmailId Already Exist
                    ans = jm.Singlevalue("already");
                    return ans;
                }
                else
                {
                    string query = "Insert into [UserMaster] " +
                        "(emailId,password,fullName,contactNumber) values " +
                        "(@emailId,@password,@fullName,@contactNumber)";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@emailId", userMasterModel.emailId);
                    cmd.Parameters.AddWithValue("@password", userMasterModel.password);
                    cmd.Parameters.AddWithValue("@fullName", userMasterModel.fullName);
                    cmd.Parameters.AddWithValue("@contactNumber", userMasterModel.contactNumber); 


                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();


                    //true
                    ans = jm.Singlevalue("true");
                }
            }
            catch (Exception e)
            {
                con.Close();
                ans = jm.Error(e.Message);
            }

            return ans;
        }

        public string Login(UserMasterModel userMasterModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("select UserMaster.userId," +
                    "fullName,emailId,contactNumber,homeAddress,workAddress,homeAddressLatLng,workAddressLatLng " +
                    "from UserMaster where LOWER(UserMaster.emailId) = LOWER(@emailId) " +
                    "AND UserMaster.password = @password", con);
                da.SelectCommand.Parameters.AddWithValue("@emailId", userMasterModel.emailId);
                da.SelectCommand.Parameters.AddWithValue("@password", userMasterModel.password);

                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count > 0)
                {
                    //true
                    ans = jm.Maker(ds);
                }
                else
                {
                    //false
                    ans = jm.Singlevalue("false");
                }
            }
            catch (Exception e)
            {
                ans = jm.Error(e.Message);
            }
            return ans;
        }

        public string GetProfileByUserId(String userId)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("select fullName," +
                    "emailId,contactNumber,homeAddress,workAddress,homeAddressLatLng,workAddressLatLng " +
                    "from UserMaster where UserMaster.userId = @userId", con);
                da.SelectCommand.Parameters.AddWithValue("@userId", userId);

                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count > 0)
                {
                    //true
                    ans = jm.Maker(ds);
                }
                else
                {
                    //false
                    ans = jm.Singlevalue("false");
                }
            }
            catch (Exception e)
            {
                ans = jm.Error(e.Message);
            }
            return ans;
        }


    }
}
