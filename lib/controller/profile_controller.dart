import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../utility/common_widgets/common_progress.dart';
import '../../utility/constants/api_constants.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/api_provider.dart';
import '../../utility/services/user_pref.dart';
import '../model/user_master.dart';
import '../utility/common_widgets/common_dialog.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUserLoggedIn = false.obs;
  RxBool isEditingEnabled = false.obs;

  RxList<UserMaster> userList = <UserMaster>[].obs;

  late TextEditingController etName;
  late TextEditingController etEmailId;
  late TextEditingController etContactNumber;

  late FocusNode etNameFocusNode;
  late FocusNode etEmailIdFocusNode;
  late FocusNode etContactNumberFocusNode;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    super.onInit();
    initUI();
    initObj();
  }

  void initUI() {
    etName = TextEditingController();
    etEmailId = TextEditingController();
    etContactNumber = TextEditingController();

    etNameFocusNode = FocusNode();
    etEmailIdFocusNode = FocusNode();
    etContactNumberFocusNode = FocusNode();
  }

  void initObj() {
    String userId = UserPref.getUserId();
    isUserLoggedIn.value = !(userId == "-1" || userId == "0" || userId.isEmpty);
    if (isUserLoggedIn.value) fetchUserProfile();
  }

  void onPressEditIcon() {
    isEditingEnabled.value = !isEditingEnabled.value;
  }

  void onPressButtonSubmit() {
    isEditingEnabled.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
    formKey.currentState!.validate() ? updateUserProfile() : null;
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


  void onTapChangePassword() {
    Get.toNamed(RouteConstants.changePasswordScreen);
  }

  Future<void> logout() async {
    try {
      await UserPref.removeAllFromUserPref();
      Get.offAllNamed(RouteConstants.loginScreen);
    } catch (e) {
      CommonHelper.printDebugError(e, "logout()");
    }
  }

  void setDetailsToFields() {
    try {
      if (userList.isNotEmpty) {
        UserMaster user = userList.first;
        etName.text = user.fullName ?? "";
        etEmailId.text = user.emailId ?? "";
        etContactNumber.text = user.contactNumber ?? "";
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ProfileController setDetailsToFields()");
    }
  }


  Future<UserMaster> createUserObject() async {
    UserMaster user = UserMaster();
    user.userId = UserPref.getUserId();
    user.fullName = etName.text.toString().trim();
    user.emailId = etEmailId.text.toString().trim();
    user.contactNumber = etContactNumber.text.toString().trim();
    return user;
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);
      userList.clear();
      String userId = UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getProfile + userId,
      );
      userList.value = jsonResponse.map((e) {
        return UserMaster.fromJson(e);
      }).toList();
    } catch (e) {
      userList.value = <UserMaster>[];
    } finally {
      setDetailsToFields();
      isLoading(false);
    }
  }

  Future<void> updateUserProfile() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.updateProfile,
        obj: (await createUserObject()).toJson(),
      ).then((response) {
        List userList = response.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        userList.isNotEmpty
            ? userList.first.status == 'ok' || userList.first.status == 'true'
                ? onSuccessResponse()
                : onFailedResponse(status: userList.first.status)
            : null;
      });
    } catch (e) {
      onFailedResponse();
      CommonHelper.printDebugError(e, "ProfileController updateUserProfile()");
    } finally {
      CommonProgressBar.hide();
      fetchUserProfile();
    }
  }

  void onSuccessResponse() {
    CommonProgressBar.hide();
    UserPref.setUserName(userName: etName.text.trim());
    UserPref.setContactNumber(contactNumber: etContactNumber.text.trim());
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Profile updated successfully...",
    );
  }

  void onFailedResponse({String? status}) {
    if (status != null && status.contains('already')) {
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "Email Id already exist",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "Something went wrong",
      );
    }
  }
}
