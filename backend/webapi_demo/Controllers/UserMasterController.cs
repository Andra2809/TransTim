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

    }
}
