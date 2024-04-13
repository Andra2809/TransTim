import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../screen/home_screen.dart';
import '../../screen/login_screen.dart';
import '../../screen/view_user_search_history_screen.dart';
import 'route_constants.dart';

class RouteScreens {
  static final routes = [
    GetPage(
      name: RouteConstants.loginScreen,
      page: () => LoginScreen(),
    ),
 GetPage(
      name: RouteConstants.viewHistoryScreen,
      page: () => ViewUserSearchHistoryScreen(),
    ),
  ];
}
