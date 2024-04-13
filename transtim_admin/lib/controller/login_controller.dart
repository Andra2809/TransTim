import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_master.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class LoginController extends GetxController {
  late TextEditingController etEmail;
  late TextEditingController etPassword;

  late FocusNode etEmailFocusNode;
  late FocusNode etPasswordFocusNode;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    super.onInit();
    initUI();
  }

  void initUI() {
    etEmail = TextEditingController();
    etPassword = TextEditingController();
    etEmailFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  Future<void> onPressButtonLogin() async {
    formKey.currentState!.validate() ? login() : null;
  }

  UserMaster createUserObject() {
    UserMaster userMaster = UserMaster();
    userMaster.emailId = etEmail.text.toString().trim();
    userMaster.password = etPassword.text.toString().trim();
    return userMaster;
  }

  Future<void> login() async {
    try {
      CommonProgressBar.show();
      List<dynamic> jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.adminLogin,
        obj: createUserObject().toJson(),
      );
      CommonHelper.printDebug(jsonResponse);
      if (jsonResponse.isNotEmpty) {
        final Map<String, dynamic> userData = jsonResponse.first;
        final String? adminId = userData['adminId'];
        final String? status = userData['status'];
        if (status == "ok" || status == "true") {
          onLoginSuccess(adminId);
        } else {
          onLoginFailed("false");
        }
      } else {
        onLoginFailed(null);
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "LoginController login()");
      onLoginFailed(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onLoginSuccess(String? adminId) async {
    UserPref.setLoginDetails(adminId: adminId ?? "-1");
    Get.offAllNamed(RouteConstants.homeScreen);
  }

  void onLoginFailed(String? error) {
    if (error != null && error.toLowerCase().contains("false")) {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Invalid Username or Password",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong",
      );
    }
  }
}
