import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/route_constants.dart';

class CommonScaffold extends StatelessWidget {
  final Color? backgroundColor;
  final bool? isBottomBarVisible;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget body;

  const CommonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.isBottomBarVisible,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    context.theme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: GestureDetector(
        child: body,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      ),
      bottomNavigationBar: isBottomBarVisible == true
          ? bottomNavigationBar ?? _bottomBar()
          : null,
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
              icon: Icon(Icons.book_online_outlined),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_outlined),
              label: 'Ratings',
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
    if (currentRoute == RouteConstants.viewAllTicketScreen) {
      selectedIndex.value = 0;
    } else if (currentRoute == RouteConstants.viewRatingsScreen) {
      selectedIndex.value = 2;
    } else {
      selectedIndex.value = 1;
    }
  }

  void onTapNavigationItem(int value) {
    selectedIndex.value = value;
    if (value == 1) {
      Get.offAllNamed(RouteConstants.homeScreen);
    } else if (value == 2) {
      Get.offAllNamed(RouteConstants.viewRatingsScreen);
    } else if (value == 0) {
      Get.offAllNamed(RouteConstants.viewAllTicketScreen);
    } else {
      Get.to(() => CommonScaffold(body: Container(), isBottomBarVisible: true));
    }
  }
}
