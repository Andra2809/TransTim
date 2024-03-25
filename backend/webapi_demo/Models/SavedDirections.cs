using System;
using System.Data.SqlClient;
using System.Data;
using System.Web;

namespace webapi_demo.Models
{
    public class SavedDirections
    {
        JSONMaker jm = new JSONMaker();

        public string InvalidRequest()
        {
            return jm.Singlevalue("Invalid Request");
        }

        public class SavedDirectionsModel
        {
            public string directionId { get; set; }
            public string userId { get; set; }
            public string startLocation { get; set; }
            public string endLocation { get; set; }
            public string startLocationLatLng { get; set; }
            public string endLocationLatLng { get; set; }
            public string mode { get; set; }
            public string travelMode { get; set; }
            public string dateTime { get; set; }

        }

        public string AddSavedDirections(SavedDirectionsModel savedDirectionsModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                string query = "Insert into [SavedDirections] (userId,startLocation,endLocation," +
                    "startLocationLatLng,endLocationLatLng,mode,travelMode,dateTime) values " +
                    "(@userId,@startLocation,@endLocation,@startLocationLatLng," +
                    "@endLocationLatLng,@mode,@travelMode,@dateTime)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@userId", savedDirectionsModel.userId);
                cmd.Parameters.AddWithValue("@startLocation", savedDirectionsModel.startLocation);
                cmd.Parameters.AddWithValue("@endLocation", savedDirectionsModel.endLocation);
                cmd.Parameters.AddWithValue("@startLocationLatLng", savedDirectionsModel.startLocationLatLng);
                cmd.Parameters.AddWithValue("@endLocationLatLng", savedDirectionsModel.endLocationLatLng);
                cmd.Parameters.AddWithValue("@mode", savedDirectionsModel.mode);
                cmd.Parameters.AddWithValue("@travelMode", savedDirectionsModel.travelMode);
                cmd.Parameters.AddWithValue("@dateTime", savedDirectionsModel.dateTime);


                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                //true
                ans = jm.Singlevalue("true");
            }
            catch (Exception e)
            {
                con.Close();
                ans = jm.Error(e.Message);
            }

            return ans;
        }

        public string UpdateSavedDirections(SavedDirectionsModel savedDirectionsModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select * from [SavedDirections] " +
                   "where directionId=@directionId", con);
                da.SelectCommand.Parameters.AddWithValue("@directionId", savedDirectionsModel.directionId);
                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count > 0)
                {
                    string query = "Update [SavedDirections] set userId=@userId," +
                        "startLocation=@startLocation,endLocation=@endLocation," +
                        "startLocationLatLng=@startLocationLatLng,endLocationLatLng=@endLocationLatLng" +
                        "mode=@mode,travelMode=@travelMode" +
                        "dateTime=@dateTime where directionId = @directionId ";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@directionId", savedDirectionsModel.directionId);
                    cmd.Parameters.AddWithValue("@userId", savedDirectionsModel.userId);
                    cmd.Parameters.AddWithValue("@startLocation", savedDirectionsModel.startLocation);
                    cmd.Parameters.AddWithValue("@endLocation", savedDirectionsModel.endLocation);
                    cmd.Parameters.AddWithValue("@startLocationLatLng", savedDirectionsModel.startLocationLatLng);
                    cmd.Parameters.AddWithValue("@endLocationLatLng", savedDirectionsModel.endLocationLatLng);
                    cmd.Parameters.AddWithValue("@mode", savedDirectionsModel.mode);
                    cmd.Parameters.AddWithValue("@travelMode", savedDirectionsModel.travelMode);
                    cmd.Parameters.AddWithValue("@dateTime", savedDirectionsModel.dateTime);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    //true
                    ans = jm.Singlevalue("true");
                }
                else
                {
                    //true
                    ans = jm.Singlevalue("no");
                }
            }
            catch (Exception e)
            {
                con.Close();
                ans = jm.Error(e.Message);
            }

            return ans;
        }


        public string GetSavedDirectionsByUserId(String userId)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select * from [SavedDirections] " +
                    "where SavedDirections.userId = @userId ", con);
                da.SelectCommand.Parameters.AddWithValue("@userId", userId);

                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count > 0)
                {
                    //Already Exist
                    ans = jm.Maker(ds);
                }
                else
                {
                    ans = jm.Singlevalue("no");
                }
            }
            catch (Exception e)
            {
                con.Close();
                ans = jm.Error(e.Message);
            }

            return ans;
        }

        public string DeleteSavedDirections(string directionId)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select directionId  from " +
                    "[SavedDirections] where directionId = @directionId ", con);
                da.SelectCommand.Parameters.AddWithValue("@directionId ", directionId);
                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count == 0)
                {
                    //no
                    ans = jm.Singlevalue("no");
                }
                else
                {
                    string query = "DELETE FROM [SavedDirections] WHERE directionId  ='" + directionId + "'";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    //true
                    ans = jm.Singlevalue("true");
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
