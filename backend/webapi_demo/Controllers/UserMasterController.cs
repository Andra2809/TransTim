using System.Net.Http;
using System.Web.Http;
using static webapi_demo.Models.UserMaster;

namespace webapi_demo.Controllers
{
    public class UserMasterController : ApiController
    {
        Models.UserMaster userMaster = new Models.UserMaster();

        [HttpGet]
        public string getanydata()
        {
            return userMaster.InvalidRequest();
        }

        [HttpPost]
        [Route("api/User/Register")]
        public HttpResponseMessage Register([FromBody] UserMasterModel userMasterModel)
        {
            return Models.Helper.getResponse(userMaster.Register(userMasterModel));
        }


        [HttpPost]
        [Route("api/User/Login")]
        public HttpResponseMessage Login([FromBody] UserMasterModel userMasterModel)
        {
            return Models.Helper.getResponse(userMaster.Login(userMasterModel));
        }

        [HttpGet]
        [Route("api/User/GetUserProfile/{userId}")]
        public HttpResponseMessage GetProfileByUserId(string userId)
        {
            return Models.Helper.getResponse(userMaster.GetProfileByUserId(userId));
        }


        [HttpPost]
        [Route("api/User/ChangePassword")]
        public HttpResponseMessage ChangePassword([FromBody] UserMasterModel userMasterModel)
        {
            return Models.Helper.getResponse(userMaster.ChangePassword(userMasterModel));
        }

        [HttpPost]
        [Route("api/User/UpdateProfile")]
        public HttpResponseMessage UpdateProfile([FromBody] UserMasterModel userMasterModel)
        {
            return Models.Helper.getResponse(userMaster.UpdateProfile(userMasterModel));
        } 
    }
}
