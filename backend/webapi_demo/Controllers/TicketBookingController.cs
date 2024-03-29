using System.Net.Http;
using System.Web.Http;
using static webapi_demo.Models.TicketBooking;

namespace webapi_demo.Controllers
{
    public class TicketBookingController : ApiController
    {
        Models.TicketBooking ticketBooking = new Models.TicketBooking();

        [HttpGet]
        public string getanydata()
        {
            return ticketBooking.InvalidRequest();
        }

        [HttpGet]
        [Route("api/TicketBooking/GetAllTickets/")]
        public HttpResponseMessage GetAllTickets()
        {
            return Models.Helper.getResponse(ticketBooking.GetAllTickets());
        }

        [HttpPost]
        [Route("api/TicketBooking/AddTicketBooking")]
        public HttpResponseMessage AddTicketBooking([FromBody] TicketBookingModel ticketBookingModel)
        {
            return Models.Helper.getResponse(ticketBooking.AddTicketBooking(ticketBookingModel));
        } 

        [HttpGet]
        [Route("api/TicketBooking/GetUserTicketBooking/{userId}")]
        public HttpResponseMessage GetUserTicketBooking(string userId)
        {
            return Models.Helper.getResponse(ticketBooking.GetTicketBookingByUserId(userId));
        }

        [HttpGet]
        [Route("api/TicketBooking/GetTicketBookingById/{ticketBookingId}")]
        public HttpResponseMessage GetTicketBookingById(string ticketBookingId)
        {
            return Models.Helper.getResponse(ticketBooking.GetTicketBookingByTicketId(ticketBookingId));
        }

    }
}
