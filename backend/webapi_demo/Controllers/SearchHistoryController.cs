using System.Net.Http;
using System.Web.Http; 
using static webapi_demo.Models.SearchHistory;

namespace webapi_demo.Controllers
{
    public class SearchHistoryController : ApiController
    {
        Models.SearchHistory searchHistory = new Models.SearchHistory();

        [HttpGet]
        public string getanydata()
        {
            return searchHistory.InvalidRequest();
        } 


        [HttpPost]
        [Route("api/SearchHistory/AddSearchHistory")]
        public HttpResponseMessage AddSearchHistory([FromBody] SearchHistoryModel searchHistoryModel)
        {
            return Models.Helper.getResponse(searchHistory.AddSearchHistory(searchHistoryModel));
        }


        [HttpPost]
        [Route("api/SearchHistory/UpdateSearchHistory")]
        public HttpResponseMessage UpdateSearchHistory([FromBody] SearchHistoryModel searchHistoryModel)
        {
            return Models.Helper.getResponse(searchHistory.UpdateSearchHistory(searchHistoryModel));
        }



        [HttpGet]
        [Route("api/SearchHistory/GetUserSearchHistory/{userId}")]
        public HttpResponseMessage GetUserSearchHistory(string userId)
        {
            return Models.Helper.getResponse(searchHistory.GetSearchHistoryByUserId(userId));
        }

        [HttpGet]
        [Route("api/SearchHistory/DeleteSearchHistory/{userId}")]
        public HttpResponseMessage DeleteSearchHistory(string userId)
        {
            return Models.Helper.getResponse(searchHistory.DeleteSearchHistory(userId));
        }
         

    }
}
