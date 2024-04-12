using System.Net.Http;
using System.Web.Http; 
using static webapi_demo.Models.SavedDirections;

namespace webapi_demo.Controllers
{
    public class SavedDirectionController : ApiController
    {
        Models.SavedDirections savedDirection = new Models.SavedDirections();

        [HttpGet]
        public string getanydata()
        {
            return savedDirection.InvalidRequest();
        } 


        [HttpPost]
        [Route("api/SavedDirection/AddSavedDirection")]
        public HttpResponseMessage AddSavedDirection([FromBody] SavedDirectionsModel savedDirectionModel)
        {
            return Models.Helper.getResponse(savedDirection.AddSavedDirections(savedDirectionModel));
        }


        [HttpPost]
        [Route("api/SavedDirection/UpdateSavedDirection")]
        public HttpResponseMessage UpdateSavedDirection([FromBody] SavedDirectionsModel savedDirectionModel)
        {
            return Models.Helper.getResponse(savedDirection.UpdateSavedDirections(savedDirectionModel));
        }



        [HttpGet]
        [Route("api/SavedDirection/GetUserSavedDirection/{userId}")]
        public HttpResponseMessage GetUserSavedDirection(string userId)
        {
            return Models.Helper.getResponse(savedDirection.GetSavedDirectionsByUserId(userId));
        }

        [HttpGet]
        [Route("api/SavedDirection/DeleteSavedDirection/{userId}")]
        public HttpResponseMessage DeleteSavedDirection(string userId)
        {
            return Models.Helper.getResponse(savedDirection.DeleteSavedDirections(userId));
        }
         

    }
}
