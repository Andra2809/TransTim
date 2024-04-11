import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../model/user_master.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/map_helper/gps_utils.dart';
import '../utility/map_helper/map_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class LoginController extends GetxController {
  RxBool isTest = false.obs;
  late TextEditingController etEmail;
  late TextEditingController etPassword;

  late FocusNode etEmailFocusNode;
  late FocusNode etPasswordFocusNode;

  Rxn<Position> position = Rxn<Position>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginController(this.isTest);

  @override
  Future<void> onInit() async {
    super.onInit();
    initUI();
    if (isTest.value != true) {
      position.value = await GpsUtils.getCurrentLocation();
    }
  }

  void initUI() {
    etEmail = TextEditingController();
    etPassword = TextEditingController();
    etEmailFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  void onTapSignUp() {
    Get.toNamed(RouteConstants.registrationScreen);
  }

  Future<void> onPressButtonLogin() async {
    if (isTest.value != true) {
      if (position.value != null) {
        formKey.currentState!.validate() ? login() : null;
      } else {
        position.value = await GpsUtils.getCurrentLocation();
        if (position.value != null) {
          formKey.currentState!.validate() ? login() : null;
        }
      }
    } else {
      formKey.currentState!.validate() ? login() : null;
    }
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
        url: ApiConstants.login,
        obj: createUserObject().toJson(),
      );
      CommonHelper.printDebug(jsonResponse);
      if (jsonResponse.isNotEmpty) {
        List<UserMaster> userMasterList = jsonResponse.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        if (userMasterList.isNotEmpty) {
          if (userMasterList.first.status == "ok" ||
              userMasterList.first.status == "true") {
            onLoginSuccess(userMasterList.first);
          } else {
            onLoginFailed("false");
          }
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

  void onLoginSuccess(UserMaster userMaster) async {
    UserPref.setLoginDetails(
      userId: userMaster.userId ?? "-1",
      userName: userMaster.fullName ?? "-1",
      contactNumber: userMaster.contactNumber ?? "-1",
      homeAddress: userMaster.homeAddress,
      workAddress: userMaster.workAddress,
      homeAddressLatLng: MapUtils.stringToLatLng(
        latLngString: userMaster.homeAddressLatLng,
      ),
      workAddressLatLng: MapUtils.stringToLatLng(
        latLngString: userMaster.workAddressLatLng,
      ),
    );
    Get.back(closeOverlays: true, canPop: true);
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
