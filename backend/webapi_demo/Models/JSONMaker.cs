using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace webapi_demo.Models
{
    public class JSONMaker
    {
        public string Maker(DataSet Data)
        {
            string one = @"\";
            string two = "\"";
            string final = one + two;
            string JSON = "";
            try
            {
                int col = Data.Tables[0].Columns.Count;
                int row = Data.Tables[0].Rows.Count;
                JSON = "{ \"status\" : \"ok\",";
                JSON += "\"Data\" :[";
                for (int i = 0; i < row; i++)
                {
                    JSON += "{";
                    for (int j = 0; j < col; j++)
                    {
                        DataTable dt = Data.Tables[0];
                        DataColumn dc = dt.Columns[j];
                        string cellvalue = Data.Tables[0].Rows[i][j].ToString();
                        if (Data.Tables[0].Rows[i][j].ToString().Contains("\""))
                        {
                            cellvalue = cellvalue.Replace("\"", final);
                        }
                        JSON += " \"" + dc.ColumnName + "\" : \"" + cellvalue + "\",";
                    }
                    JSON = JSON.Remove(JSON.Length - 1);
                    JSON += "},";
                }
                JSON = JSON.Remove(JSON.Length - 1);
                JSON += "] }";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public string Maker1(DataTable Data)
        {
            string one = @"\";
            string two = "\"";
            string final = one + two;
            string JSON = "";
            try
            {
                int col = Data.Columns.Count;
                int row = Data.Rows.Count;
                JSON = "{ \"status\" : \"ok\",";
                JSON += "\"Data\" :[";
                for (int i = 0; i < row; i++)
                {
                    JSON += "{";
                    for (int j = 0; j < col; j++)
                    {
                        DataColumn dc = Data.Columns[j];
                        string cellvalue = Data.Rows[i][j].ToString();
                        if (cellvalue.Contains("\""))
                        {
                            cellvalue = cellvalue.Replace("\"", final);
                        }

                        JSON += " \"" + dc.ColumnName + "\" : \"" + cellvalue + "\",";
                    }
                    JSON = JSON.Remove(JSON.Length - 1);
                    JSON += "},";
                }
                JSON = JSON.Remove(JSON.Length - 1);
                JSON += "] }";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public string Maker_twosets(DataSet Data, DataSet Data1)
        {
            string JSON = "";
            try
            {
                int col = Data.Tables[0].Columns.Count;
                int row = Data.Tables[0].Rows.Count;
                JSON = "{ \"status\" : \"ok\",";
                JSON += "\"Data\" :[";
                for (int i = 0; i < row; i++)
                {
                    JSON += "{";
                    for (int j = 0; j < col; j++)
                    {
                        DataTable dt = Data.Tables[0];
                        DataColumn dc = dt.Columns[0];
                        JSON += " \"data" + j + "\" : \"" + Data.Tables[0].Rows[i][j] + "\",";
                    }
                    JSON = JSON.Remove(JSON.Length - 1);
                    JSON += "},";
                }
                JSON = JSON.Remove(JSON.Length - 1);
                JSON += "],";


                int col1 = Data1.Tables[0].Columns.Count;
                int row1 = Data1.Tables[0].Rows.Count;
                JSON += "\"Data1\" :[";
                for (int i = 0; i < row1; i++)
                {
                    JSON += "{";
                    for (int j = 0; j < col1; j++)
                    {
                        JSON += " \"data" + j + "\" : \"" + Data1.Tables[0].Rows[i][j] + "\",";
                    }
                    JSON = JSON.Remove(JSON.Length - 1);
                    JSON += "},";
                }
                JSON = JSON.Remove(JSON.Length - 1);
                JSON += "] }";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public string Singlevalue(string data)
        {
            string JSON = "";
            try
            {
                JSON = "{ \"status\" : \"" + data + "\" } ";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public string Error(string data)
        {
            string JSON = "";
            try
            {
                JSON = "{ \"status\": \"error\" , \"Data\": \"" + data + "\" }";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public string getArray(string[] names, string[] values, DataSet Data)
        {
            string one = @"\";
            string two = "\"";
            string final = one + two;
            string JSON = "";
            try
            {
                JSON += "{";
                for (int n = 0; n < names.Length; n++)
                {
                    JSON += "\"" + names[n] + "\" : \"" + values[n] + "\",";
                }
                JSON = JSON.Remove(JSON.Length - 1);

                if (Data != null)
                {
                    if (Data.Tables.Count > 0)
                    {
                        int col = Data.Tables[0].Columns.Count;
                        int row = Data.Tables[0].Rows.Count;

                        if (row > 0)
                        {
                            JSON += ",\"datastatus\" : \"yes\"";
                            JSON += ",\"Data\" :[";
                            for (int i = 0; i < row; i++)
                            {
                                JSON += "{";
                                for (int j = 0; j < col; j++)
                                {
                                    DataTable dt = Data.Tables[0];
                                    DataColumn dc = dt.Columns[j];
                                    string cellvalue = Data.Tables[0].Rows[i][j].ToString();
                                    if (Data.Tables[0].Rows[i][j].ToString().Contains("\""))
                                    {
                                        cellvalue = cellvalue.Replace("\"", final);
                                    }
                                    JSON += " \"" + dc.ColumnName + "\" : \"" + cellvalue + "\",";
                                }
                                JSON = JSON.Remove(JSON.Length - 1);
                                JSON += "},";
                            }
                            JSON = JSON.Remove(JSON.Length - 1);
                            JSON += "]";
                        }
                        else
                        {
                            JSON += ",\"datastatus\" : \"no\"";
                        }
                    }
                }
                JSON += "}";

            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public string getArray1(string[] names, string[] values, DataTable Data)
        {
            string one = @"\";
            string two = "\"";
            string final = one + two;
            string JSON = "";
            try
            {
                JSON += "{";
                for (int n = 0; n < names.Length; n++)
                {
                    JSON += "\"" + names[n] + "\" : \"" + values[n] + "\",";
                }
                JSON = JSON.Remove(JSON.Length - 1);

                if (Data != null)
                {
                    int col = Data.Columns.Count;
                    int row = Data.Rows.Count;

                    JSON += ",\"datastatus\" : \"yes\"";

                    if (row > 0)
                    {
                        JSON += ",\"Data\" :[";
                        for (int i = 0; i < row; i++)
                        {
                            JSON += "{";
                            for (int j = 0; j < col; j++)
                            {
                                string cellvalue = Data.Rows[i][j].ToString();
                                if (cellvalue.Contains("\""))
                                {
                                    cellvalue = cellvalue.Replace("\"", final);
                                }
                                JSON += " \"data" + j + "\" : \"" + cellvalue + "\",";
                            }
                            JSON = JSON.Remove(JSON.Length - 1);
                            JSON += "},";
                        }
                        JSON = JSON.Remove(JSON.Length - 1);
                        JSON += "]";
                    }
                    else
                    {
                        JSON += ",\"datastatus\" : \"no\"";
                    }
                }
                JSON += "}";

            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }

        public class MultipleData
        {
            private List<data> _Data = new List<data>();

            public List<data> Data
            {
                get { return _Data; }
                set { _Data = value; }
            }

            public class data
            {
                public string value { get; set; }
            }

        }


        public string Newmaker(string[] data,string[] keys)
        {
            string JSON = "";
            try
            {
                JSON = "{ \"status\" : \"" + data + "\" } ";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }


        public string SingleResponse(string data)
        {
            string JSON = "";
            try
            {
                JSON = "{ \"Response\" : \"" + data + "\" } ";
            }
            catch (Exception ep)
            {
                JSON = "Error";
            }
            return JSON;
        }
    }
}