class ApiConstants {
  static const String baseUrl = "http://transtim.hostoise.com";

  static const String adminLogin = "$baseUrl/api/Admin/Login";
  static const String baseUser = "$baseUrl/api/Admin";
  static const String getAllUser = "$baseUser/GetAllUser/";

  static const String baseSearchHistory = "$baseUrl/api/SearchHistory";
  static const String getSearchHistoryByUser =
      "$baseSearchHistory/GetUserSearchHistory/";

  static const String baseTicket = "$baseUrl/api/TicketBooking";
  static const String getAllTickets = "$baseTicket/GetAllTickets";

  static const String baseRating = "$baseUrl/api/UserAppRating";
  static const String getAllUserAppRatings = "$baseRating/GetAllUserAppRating";
}
