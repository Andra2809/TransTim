using System;
using System.Data.SqlClient;
using System.Data;
using System.Web;

namespace webapi_demo.Models
{
    public class UserAppRating
    {
        JSONMaker jm = new JSONMaker();

        public string InvalidRequest()
        {
            return jm.Singlevalue("Invalid Request");
        }

        public class UserAppRatingModel
        {
            public string ratingId { get; set; }
            public string userId { get; set; }
            public string ratingCount { get; set; }
            public string dateTime { get; set; }

        }

        public string AddUserAppRating(UserAppRatingModel savedDirectionsModel)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                string query = "Insert into [UserAppRating] (userId,ratingCount,dateTime) values " +
                    "(@userId,@ratingCount,@dateTime)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@userId", savedDirectionsModel.userId);
                cmd.Parameters.AddWithValue("@ratingCount", savedDirectionsModel.ratingCount);
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


        public string GetUserAppRatingByUserId(String userId)
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT [UserAppRating].*," +
                    "AVG([UserAppRating].ratingCount) OVER() AS averageRating " +
                    "FROM[UserAppRating] WHERE[UserAppRating].userId = @userId; ", con);
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

        public string GetAllUserAppRating()
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select [UserAppRating].*," +
                    "AVG([UserAppRating].ratingCount) OVER() AS averageRating, " +
                    "UserMaster.fullName from [UserAppRating] " +
                    "LEFT JOIN UserMaster ON UserAppRating.userId = UserMaster.userId ", con); 

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


    }
}
