import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';
import '../routes/route_constants.dart';
import '../services/user_pref.dart';
import 'custom_button.dart';

class CommonScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final bool? isBottomBarVisible;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget body;
  final bool? isLoginCompulsory;

  const CommonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.isBottomBarVisible,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.isLoginCompulsory,
  });

  @override
  Widget build(BuildContext context) {
    context.theme;

    bool isUserIdEmpty = false;
    if (isLoginCompulsory == true) {
      String userId = UserPref.getUserId();
      isUserIdEmpty = userId == "-1" || userId == "0" || userId.isEmpty;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: GestureDetector(
        child: isUserIdEmpty ? _loginToContinue() : body,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      ),
      bottomNavigationBar: isBottomBarVisible == true
          ? bottomNavigationBar == null
              ? _bottomBar()
              : !isUserIdEmpty
                  ? bottomNavigationBar
                  : null
          : null,
    );
  }

  Widget _loginToContinue() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You need to login to view this page',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.titleMedium?.fontSize,
            ),
          ),
          CustomButton(
            isWrapContent: true,
            width: Get.width / 3,
            margin: const EdgeInsets.all(DimenConstants.contentPadding),
            buttonText: "Login Now",
            onButtonPressed: () => Get.toNamed(RouteConstants.loginScreen),
          )
        ],
      ),
    );
  }

  Widget _bottomBar() {
    BottomNavigationBarController controller =
        Get.put(BottomNavigationBarController());
    return Obx(
      () {
        return BottomNavigationBar(
          useLegacyColorScheme: true,
          currentIndex: controller.selectedIndex.value,
          onTap: (value) => controller.onTapNavigationItem(value),
          selectedItemColor: Get.theme.colorScheme.primary,
          unselectedItemColor: Get.theme.colorScheme.onPrimaryContainer,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_location_alt_outlined),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online_outlined),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}

class BottomNavigationBarController extends GetxController {
  RxInt selectedIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    String currentRoute = Get.currentRoute;
    if (currentRoute == RouteConstants.viewAllSavedDirectionScreen) {
      selectedIndex.value = 0;
    } else if (currentRoute == RouteConstants.viewAllUserTicketScreen) {
      selectedIndex.value = 2;
    } else if (currentRoute == RouteConstants.profileScreen) {
      selectedIndex.value = 3;
    } else {
      selectedIndex.value = 1;
    }
  }

  void onTapNavigationItem(int value) {
    selectedIndex.value = value;
    if (value == 1) {
      Get.offAllNamed(RouteConstants.homeScreen);
    } else if (value == 2) {
      Get.offAllNamed(RouteConstants.viewAllUserTicketScreen);
    } else if (value == 0) {
      Get.offAllNamed(RouteConstants.viewAllSavedDirectionScreen);
    } else if (value == 3) {
      Get.offAllNamed(RouteConstants.profileScreen);
    } else {
      Get.to(() => CommonScaffold(body: Container(), isBottomBarVisible: true));
    }
  }
}
