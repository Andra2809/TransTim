import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_dialog.dart';
import '../../utility/common_widgets/common_progress.dart';
import '../../utility/constants/api_constants.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/api_provider.dart';
import '../../utility/services/user_pref.dart';
import '../model/user_master.dart';

class ChangePasswordController extends GetxController {
  late TextEditingController etOldPassword;
  late TextEditingController etNewPassword;
  late TextEditingController etConfirmNewPassword;
  late FocusNode etOldPasswordFocusNode;
  late FocusNode etNewPasswordFocusNode;
  late FocusNode etConfirmNewPasswordFocusNode;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    etOldPassword = TextEditingController();
    etNewPassword = TextEditingController();
    etConfirmNewPassword = TextEditingController();

    etOldPasswordFocusNode = FocusNode();
    etNewPasswordFocusNode = FocusNode();
    etConfirmNewPasswordFocusNode = FocusNode();
  }

  Future<void> onConfirmChangePassword() async {
    try {
      changePassword();
    } catch (e) {
      onChangePasswordFailed(error: e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  Future<UserMaster> _createUserObject() async {
    UserMaster admin = UserMaster();
    admin.userId = await UserPref.getUserId();
    admin.password = etOldPassword.text.toString().trim();
    admin.newPassword = etNewPassword.text.toString().trim();
    return admin;
  }

  Future<void> changePassword() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.changePassword,
        obj: (await _createUserObject()).toJson(),
      ).then((response) {
        List userList = response.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        userList.isNotEmpty
            ? userList.first.status == 'ok' || userList.first.status == 'true'
                ? onChangePasswordSuccess()
                : onChangePasswordFailed(error: userList.first.status)
            : null;
      });
    } catch (e) {
      CommonHelper.printDebugError(e, "ChangePasswordController line 85");
      onChangePasswordFailed(error: e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onChangePasswordSuccess() {
    Get.back();
    Get.dialog(
      CommonDialog(
        title: "Success",
        contentWidget: const Text(
          "Password Changed Successfully,"
          "\n Need to login again!!!",
        ),
        positiveDialogBtnText: "Ok",
        onPositiveButtonClicked: () async {
          UserPref.removeAllFromUserPref();
          Get.offAndToNamed(RouteConstants.loginScreen);
        },
      ),
      barrierDismissible: false,
    );
  }

  void onChangePasswordFailed({String? error}) {
    CommonHelper.printDebugError(error, "ChangePasswordController line 111");
    Get.back();
    String onError = error ?? "";
    if (onError == "false") {
      Get.dialog(
        const CommonDialog(
          title: "Password Incorrect!!!",
          contentWidget: Text(
            "Enter Correct Password And"
            "\nTry Again Later",
          ),
          positiveDialogBtnText: "Ok",
        ),
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong. Please try again later'",
      );
    }
  }
}
