using System;
using System.Data.SqlClient;
using System.Data;
using System.Web;

namespace webapi_demo.Models
{
    public class SearchHistory
    {
        JSONMaker jm = new JSONMaker();

        public string InvalidRequest()
        {
            return jm.Singlevalue("Invalid Request");
        }

        public class SearchHistoryModel
        {
            public string historyId { get; set; }
            public string userId { get; set; }
            public string startLocation { get; set; }
            public string endLocation { get; set; }
            public string startLocationLatLng { get; set; }
            public string endLocationLatLng { get; set; }
            public string mode { get; set; }
            public string travelMode { get; set; }
            public string dateTime { get; set; }

        }

        public string AddSearchHistory(SearchHistoryModel savedDirectionsModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                string query = "Insert into [SearchHistory] (userId,startLocation,endLocation," +
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

        public string UpdateSearchHistory(SearchHistoryModel savedDirectionsModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select * from [SearchHistory] " +
                   "where historyId=@historyId", con);
                da.SelectCommand.Parameters.AddWithValue("@historyId", savedDirectionsModel.historyId);
                DataSet ds = new DataSet();
                da.Fill(ds);
                int count = ds.Tables[0].Rows.Count;
                if (count > 0)
                {
                    string query = "Update [SearchHistory] set userId=@userId," +
                        "startLocation=@startLocation,endLocation=@endLocation," +
                        "startLocationLatLng=@startLocationLatLng,endLocationLatLng=@endLocationLatLng" +
                        "mode=@mode,travelMode=@travelMode" +
                        "dateTime=@dateTime where historyId = @historyId ";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@historyId", savedDirectionsModel.historyId);
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


        public string GetSearchHistoryByUserId(String userId)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select * from [SearchHistory] " +
                    "where SearchHistory.userId = @userId ", con);
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

        public string DeleteSearchHistory(string historyId)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select historyId  from " +
                    "[SearchHistory] where historyId = @historyId ", con);
                da.SelectCommand.Parameters.AddWithValue("@historyId ", historyId);
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
                    string query = "DELETE FROM [SearchHistory] WHERE historyId  ='" + historyId + "'";
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
