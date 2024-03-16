using System.Data.SqlClient;

namespace webapi_demo.Models
{
    public static class Database
    {
        public static SqlConnection getDB()
        {
            SqlConnection con = new SqlConnection(@"Data Source=SG2NWPLS19SQL-v09.mssql.shr.prod.sin2.secureserver.net;Initial Catalog=TransTim;Persist Security Info=True;User ID=TransTim;Password=8&bu39s4J");
            return con;
        }
    }
}