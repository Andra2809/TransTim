class ApiConstants {
  static const String baseUrl = "http://transtim.hostoise.com";

  static const String baseUser = "$baseUrl/api/User";
  static const String register = "$baseUser/Register";
  static const String login = "$baseUser/Login";
  static const String getProfile = "$baseUser/GetUserProfile/";
  static const String changePassword = "$baseUser/ChangePassword";
  static const String updateProfile = "$baseUser/UpdateProfile";

  static const String baseTicket = "$baseUrl/api/TicketBooking/GetAllTickets";
  static const String baseTicketBooking = "$baseUrl/api/TicketBooking";
  static const String addTicketBooking = "$baseTicketBooking/AddTicketBooking";
  static const String getTicketBookingByUserId =
      "$baseTicketBooking/GetUserTicketBooking/";
  static const String getTicketBookingById =
      "$baseTicketBooking/GetTicketBookingById/";

  static const String baseDirection = "$baseUrl/api/SavedDirection";
  static const String addDirection = "$baseDirection/AddSavedDirection";
  static const String updateDirection = "$baseDirection/UpdateSavedDirection";
  static const String deleteDirection = "$baseDirection/DeleteSavedDirection/";
  static const String getDirectionByUserId =
      "$baseDirection/GetUserSavedDirection/";

  static const String baseRatings = "$baseUrl/api/UserAppRating";
  static const String addRating = "$baseRatings/AddUserAppRating/";
  static const String getRating = "$baseRatings/GetUserAppRatingByUserId/";

  static const String baseHistory = "$baseUrl/api/SearchHistory";
  static const String addHistory = "$baseHistory/AddSearchHistory/";
}
