using System;
using System.Data.SqlClient;
using System.Data;
using System.Transactions;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace webapi_demo.Models
{
    public class TicketBooking
    {
        JSONMaker jm = new JSONMaker();

        public string InvalidRequest()
        {
            return jm.Singlevalue("Invalid Request");
        }

        public class TicketBookingModel
        {
            public string ticketBookingId { get; set; }
            public string ticketId { get; set; }
            public string userId { get; set; }
            public string date { get; set; }
            public string time { get; set; }
            public string passengerCount { get; set; }
            public string totalAmount { get; set; }
            public string description { get; set; }
        }

        public string GetAllTickets()
        {
            SqlConnection con = Database.getDB();
            string ans = "";

            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select * from [Ticket]", con);

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

        public string AddTicketBooking(TicketBookingModel ticketBookingsModel)
        {
            string ans = "";

            using (SqlConnection con = Database.getDB())
            {
                try
                {
                    string query = "Insert into [TicketBooking] (ticketId,userId, date, time, passengerCount, totalAmount) " +
                        "values (@ticketId,@userId, @date, @time, @passengerCount, @totalAmount);SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.Add("@ticketId", SqlDbType.VarChar).Value = ticketBookingsModel.ticketId;
                        cmd.Parameters.Add("@userId", SqlDbType.VarChar).Value = ticketBookingsModel.userId;
                        cmd.Parameters.Add("@date", SqlDbType.VarChar).Value = ticketBookingsModel.date;
                        cmd.Parameters.Add("@time", SqlDbType.VarChar).Value = ticketBookingsModel.time;
                        cmd.Parameters.Add("@passengerCount", SqlDbType.VarChar).Value = ticketBookingsModel.passengerCount;
                        cmd.Parameters.Add("@totalAmount", SqlDbType.VarChar).Value = ticketBookingsModel.totalAmount;

                        con.Open();
                        int ticketBookingId = Convert.ToInt32(cmd.ExecuteScalar());
                        con.Close();

                        ans = jm.Singlevalue("true");
                    }
                }
                catch (Exception e)
                {
                    ans = jm.Error(e.Message);
                }
            }

            return ans;
        }

    }
}
