using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using static webapi_demo.Models.JSONMaker;

namespace webapi_demo.Models
{
    public static class Helper
    {
        public static HttpResponseMessage getResponse(String s)
        {
            var response = new HttpResponseMessage();
            response.Content = new StringContent(s);
            response.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/json");
            return response;
        }

        public static string[] decodeJson(string s, string src)
        {
            string[] ans = null;
            MultipleData c2 = JsonConvert.DeserializeObject<MultipleData>(s);
            int c = c2.Data.Count;
            ans = new string[c];
            for (int i = 0; i < ans.Length; i++)
            {
                ans[i] = c2.Data[i].value;
            }

            return ans;
        }

        public static string getStringforIN(string[] s)
        {
            string ans = "";
            for (int i = 0; i < s.Length; i++)
            {
                ans += "'%" + s[i] + "%',";
            }
            ans = ans.Remove(ans.Length - 1);
            ans = "(" + ans + ")";
            return ans;
        }

        public static string getStringforLIKE(string[] s, string column)
        {
            string ans = "";
            for (int i = 0; i < s.Length; i++)
            {
                ans += " " + column + " LIKE '%" + s[i] + "%' OR";
            }
            ans = ans.Remove(ans.Length - 2);
            ans = "(" + ans + ")";
            return ans;
        }

        public static string getStringforLIKE_2cols(string[] s, string[] s1, string col1, string col2)
        {
            string ans = "";
            for (int i = 0; i < s.Length; i++)
            {
                ans += " (" + col1 + "= '" + s[i] + "' AND " + col2 + " LIKE '%" + s1[i] + "%') OR";
            }
            ans = ans.Remove(ans.Length - 2);
            ans = "(" + ans + ")";
            return ans;
        }

        public static string getStringforCASE(string col, string[] condition, string[] result, string def)
        {
            string ans = " CASE ";
            for (int i = 0; i < condition.Length; i++)
            {
                ans += " WHEN " + col + "=" + condition[i] + " THEN " + result[i];
            }
            ans += " ELSE " + def;
            ans += " END ";
            return ans;
        }

        public static bool checkforSQLInjections(string atchecker)
        {
            if (atchecker.Contains("convert") || atchecker.Contains("char(") || atchecker.Contains("SQL_") || atchecker.Contains("get_host_address") || atchecker.Contains("select") || atchecker.Contains("update") || atchecker.Contains("detete") || atchecker.Contains("dbname") || atchecker.Contains("version") || atchecker.Contains("1=1") || atchecker.Contains("'") || atchecker.Contains("%27"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static bool checkforSQLInjections_ignoreInverted(string atchecker)
        {
            if (atchecker.Contains("convert") || atchecker.Contains("char(") || atchecker.Contains("SQL_") || atchecker.Contains("get_host_address") || atchecker.Contains("select") || atchecker.Contains("update") || atchecker.Contains("detete") || atchecker.Contains("dbname") || atchecker.Contains("version") || atchecker.Contains("1=1") || atchecker.Contains("%27"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static string push_notification(string Title, string Mesg, string Token)
        {
            if (Token == "NA" || Token == "" || Token == "no")
            {
                return "";
            }

            string ans = "";
            try
            {
                string applicationID = "AAAAb3v1qZQ:APA91bF-_CycGPAFz6i3k-DC-cV9XGJUmhPTdXYlInzf7Xh2GmAInUyi2fmznEHBcRvc9Z6PIydlY1rpjyLQZwSPuOFIQKzKDA44ZOqLzzYIFk9jSX9l3SO364kcmV-tv5HIuSibNtlv";


                string senderId = "478821067156";

                string deviceId = Token;

                WebRequest tRequest = WebRequest.Create("https://fcm.googleapis.com/fcm/send");

                tRequest.Method = "post";

                tRequest.ContentType = "application/json";

                var data = new

                {
                    collapseKey = getRandomAlpha(),

                    to = deviceId,

                    notification = new

                    {

                        body = Mesg,

                        title = Title,

                        icon = "myicon",

                        click_action = "OPEN_ACTIVITY_1"

                    }
                };

                var serializer = new JavaScriptSerializer();

                var json = serializer.Serialize(data);

                Byte[] byteArray = Encoding.UTF8.GetBytes(json);

                tRequest.Headers.Add(string.Format("Authorization: key={0}", applicationID));

                tRequest.Headers.Add(string.Format("Sender: id={0}", senderId));

                tRequest.ContentLength = byteArray.Length;

                using (Stream dataStream = tRequest.GetRequestStream())
                {

                    dataStream.Write(byteArray, 0, byteArray.Length);

                    using (WebResponse tResponse = tRequest.GetResponse())
                    {

                        using (Stream dataStreamResponse = tResponse.GetResponseStream())
                        {

                            using (StreamReader tReader = new StreamReader(dataStreamResponse))
                            {

                                String sResponseFromServer = tReader.ReadToEnd();

                                ans = sResponseFromServer;
                                //{"status": "{"multicast_id":5015833947968800616,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1605869368217740%bb933c01bb933c01"}]}"}

                            }
                        }
                    }
                }
            }

            catch (Exception ex)
            {
                ans = ex.Message;
            }

            return ans;

        }

        public static string getRandomAlpha()
        {
            string ans = "";

            string[] alphabets = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
            string[] digits = new string[] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

            Random r = new Random();
            ans = alphabets[r.Next(alphabets.Length)];

            int a = r.Next(2);
            ans += a == 1 ? alphabets[r.Next(alphabets.Length)] : digits[r.Next(digits.Length)];

            a = r.Next(2);
            ans += a == 1 ? alphabets[r.Next(alphabets.Length)] : digits[r.Next(digits.Length)];

            a = r.Next(2);
            ans += a == 1 ? alphabets[r.Next(alphabets.Length)] : digits[r.Next(digits.Length)];

            a = r.Next(2);
            ans += a == 1 ? alphabets[r.Next(alphabets.Length)] : digits[r.Next(digits.Length)];

            a = r.Next(2);
            ans += a == 1 ? alphabets[r.Next(alphabets.Length)] : digits[r.Next(digits.Length)];

            return ans;
        }

        public static string SendSMS(string numbers, string message)
        {
            string ans = "";
            try
            {
                string result = "";
                string apikey = "Bu0XvbVJnqg-W7Fia4zQsVoXli5knihgskhubdqqwF";
                string sender = "NCRA";

                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
                ServicePointManager.DefaultConnectionLimit = 9999;

                string url = "https://api.txtlocal.com/send/?apikey=" + apikey + "&numbers=" + numbers + "&message=" + message + "&sender=" + sender;

                StreamWriter myWriter = null;
                HttpWebRequest objRequest = (HttpWebRequest)WebRequest.Create(url);

                objRequest.Method = "POST";
                objRequest.ContentLength = Encoding.UTF8.GetByteCount(url);
                objRequest.ContentType = "application/x-www-form-urlencoded";
                try
                {
                    myWriter = new StreamWriter(objRequest.GetRequestStream());
                    myWriter.Write(url);
                }
                catch (Exception ex)
                {
                    ans = "false";
                }

                finally
                {
                    myWriter.Close();
                }

                HttpWebResponse objResponse = (HttpWebResponse)objRequest.GetResponse();
                using (StreamReader sr = new StreamReader(objResponse.GetResponseStream()))
                {
                    result = sr.ReadToEnd();
                    sr.Close();
                }

                if (!result.Contains("\"status\":\"success\""))
                {
                    ans = "false";
                }
                else
                {
                    ans = "true";
                }

            }
            catch (Exception ex)
            {
                ans = "false";
            }

            return ans;
        }
    }
}