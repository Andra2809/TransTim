using System.Net.Http;
using System.Web.Http;
using static webapi_demo.Models.UserAppRating;

namespace webapi_demo.Controllers
{
    public class UserAppRatingController : ApiController
    {
        Models.UserAppRating userAppRating = new Models.UserAppRating();

        [HttpGet]
        public string getanydata()
        {
            return userAppRating.InvalidRequest();
        }

        [HttpPost]
        [Route("api/UserAppRating/AddUserAppRating/")]
        public HttpResponseMessage AddUserAppRating(UserAppRatingModel userAppRatingModel)
        {
            return Models.Helper.getResponse(userAppRating.AddUserAppRating(userAppRatingModel));
        }
         

        [HttpGet]
        [Route("api/UserAppRating/GetUserAppRatingByUserId/{userId}")]
        public HttpResponseMessage GetUserAppRatingByUserId(string userId)
        {
            return Models.Helper.getResponse(userAppRating.GetUserAppRatingByUserId(userId));
        }

        [HttpGet]
        [Route("api/UserAppRating/GetAllUserAppRating/")]
        public HttpResponseMessage GetAllUserAppRating()
        {
            return Models.Helper.getResponse(userAppRating.GetAllUserAppRating());
        }

    }
}
