import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../screen/change_password_screen.dart';
import '../../screen/home_screen.dart';
import '../../screen/login_screen.dart';
import '../../screen/profile_screen.dart';
import '../../screen/registration_screen.dart';
import '../../screen/saved_direction_details_screen.dart';
import '../../screen/step_details_screen.dart';
import '../../screen/ticket_booking_screen.dart';
import '../../screen/ticket_summary_screen.dart';
import '../../screen/view_all_saved_direction_screen.dart';
import '../../screen/view_all_user_ticket_screen.dart';
import 'route_constants.dart';

class RouteScreens {
  static final routes = [
    GetPage(
      name: RouteConstants.registrationScreen,
      page: () => RegistrationScreen(),
    ),
    GetPage(
      name: RouteConstants.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: RouteConstants.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteConstants.profileScreen,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: RouteConstants.changePasswordScreen,
      page: () => ChangePasswordScreen(),
    ),
    GetPage(
      name: RouteConstants.stepDetailsScreen,
      page: () => StepDetailsScreen(),
    ),
    GetPage(
      name: RouteConstants.ticketSummaryScreen,
      page: () => TicketSummaryScreen(),
    ),
    GetPage(
      name: RouteConstants.ticketBookingScreen,
      page: () => TicketBookingScreen(),
    ),
    GetPage(
      name: RouteConstants.viewAllUserTicketScreen,
      page: () => ViewAllUserTicketScreen(),
    ),
    GetPage(
      name: RouteConstants.viewAllSavedDirectionScreen,
      page: () => ViewAllSavedDirectionScreen(),
    ),
    GetPage(
      name: RouteConstants.savedDirectionDetailsScreen,
      page: () => SavedDirectionDetailsScreen(),
    ),
  ];
}
