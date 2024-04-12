import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_master.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/services/api_provider.dart';

class RegistrationController extends GetxController {
  late TextEditingController etName;
  late TextEditingController etEmailId;
  late TextEditingController etPassword;
  late TextEditingController etContactNumber;

  late FocusNode etNameFocusNode;
  late FocusNode etEmailIdFocusNode;
  late FocusNode etPasswordFocusNode;
  late FocusNode etContactNumberFocusNode;

  late GlobalKey<FormState> formKey;

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    formKey = GlobalKey<FormState>();
    etName = TextEditingController();
    etEmailId = TextEditingController();
    etPassword = TextEditingController();
    etContactNumber = TextEditingController();

    etNameFocusNode = FocusNode();
    etEmailIdFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
    etContactNumberFocusNode = FocusNode();
  }

  void onClickRegister() {
    formKey.currentState!.validate() ? register() : null;
  }

  UserMaster createUserMasterObject() {
    UserMaster userMaster = UserMaster();
    userMaster.fullName = etName.text.toString().trim();
    userMaster.contactNumber = etContactNumber.text.toString().trim();
    userMaster.emailId = etEmailId.text.toString().trim();
    userMaster.password = etPassword.text.toString().trim();
    return userMaster;
  }

  Future<void> register() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.register,
        obj: createUserMasterObject().toJson(),
      ).then((response) {
        List userMasterList = response.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        if (userMasterList.isNotEmpty) {
          if ((userMasterList.first.status != null) &&
              userMasterList.first.status != 'true') {
            onFailedResponse(userMasterList.first.status.toString());
          } else {
            onSuccessResponse();
          }
        }
      });
    } catch (e) {
      onFailedResponse(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onSuccessResponse() {
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Registered successfully, Continue to login...",
    );
    if (Get.previousRoute.isNotEmpty) {
      Get.back(closeOverlays: true);
    }
  }

  void onFailedResponse(String response) {
    if (response.toLowerCase().contains('already')) {
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "User already exists",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "Something went wrong",
      );
    }
  }
}
