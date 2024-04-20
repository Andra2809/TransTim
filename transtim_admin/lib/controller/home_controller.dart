import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_master.dart';
import '../utility/common_widgets/common_dialog.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<UserMaster> userList = <UserMaster>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void onTapUserCard({required UserMaster user}) {
    Get.toNamed(RouteConstants.viewHistoryScreen, arguments: user.userId);
  }

  void onPressLogoutIcon() {
    Get.dialog(
      CommonDialog(
        title: "Logout",
        contentWidget: const Text("Are you sure you want to logout?"),
        negativeRedDialogBtnText: "Confirm",
        positiveDialogBtnText: "Back",
        onNegativeRedBtnClicked: () {
          Get.back();
          logout();
        },
      ),
    );
  }

  Future<void> fetchUser() async {
    try {
      isLoading(true);
      userList.clear();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getAllUser,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        userList.value = jsonResponse.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
      }
    } catch (e) {
      userList.value = <UserMaster>[];
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await UserPref.removeAllFromUserPref();
      Get.offAndToNamed(RouteConstants.loginScreen);
    } catch (e) {
      CommonHelper.printDebugError(e, "logout()");
    }
  }
}
