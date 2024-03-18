import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/common_widgets/common_progress.dart';
import '../../utility/constants/api_constants.dart';
import '../../utility/helper/common_helper.dart';
import '../../utility/helper/snack_bar_utils.dart';
import '../../utility/routes/route_constants.dart';
import '../../utility/services/api_provider.dart';
import '../../utility/services/user_pref.dart';
import '../model/user_master.dart';
import '../utility/common_widgets/common_dialog.dart';
import '../utility/map_helper/map_utils.dart';
import '../utility/map_helper/search_view.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUserLoggedIn = false.obs;
  RxBool isEditingEnabled = false.obs;

  RxString workAddress = ''.obs;
  RxString homeAddress = ''.obs;
  RxnString homeAddressLatLng = RxnString();
  RxnString workAddressLatLng = RxnString();
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
    homeAddress.value = UserPref.getHomeAddress();
    workAddress.value = UserPref.getWorkAddress();
    homeAddressLatLng.value =
        MapUtils.latLngToString(latLng: UserPref.getHomeAddressLatLng());
    workAddressLatLng.value =
        MapUtils.latLngToString(latLng: UserPref.getWorkAddressLatLng());
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

  void onTapAddress({required String addressType}) {
    try {
      showSearch(
        context: Get.context as BuildContext,
        delegate: SearchView(),
      ).then((value) {
        onSearched(value: value, isWork: addressType == 'Work');
      });
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onTapSearchCity()");
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
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

  void onSearched({required String value, bool? isWork}) async {
    try {
      List<Location> locationList = await locationFromAddress(value);
      Location location = locationList.first;
      LatLng latLng = LatLng(location.latitude, location.longitude);
      if (isWork == true) {
        workAddress.value = value;
        workAddressLatLng.value = MapUtils.latLngToString(latLng: latLng);
        UserPref.setWorkAddress(address: value, latLng: latLng);
      } else {
        homeAddress.value = value;
        homeAddressLatLng.value = MapUtils.latLngToString(latLng: latLng);
        UserPref.setHomeAddress(address: value, latLng: latLng);
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onSearched()");
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<UserMaster> createUserObject() async {
    UserMaster user = UserMaster();
    user.userId = UserPref.getUserId();
    user.fullName = etName.text.toString().trim();
    user.emailId = etEmailId.text.toString().trim();
    user.contactNumber = etContactNumber.text.toString().trim();
    user.homeAddress = homeAddress.value.trim();
    user.workAddress = workAddress.value.trim();
    user.homeAddressLatLng = homeAddressLatLng.value?.trim();
    user.workAddressLatLng = workAddressLatLng.value?.trim();
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
