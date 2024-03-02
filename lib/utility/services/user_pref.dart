import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class UserPref {
  static final getStorage = GetStorage();

  static void setLoginDetails({
    required String userId,
    required String userName,
    required String contactNumber,
    required String? homeAddress,
    required String? workAddress,
    required LatLng? homeAddressLatLng,
    required LatLng? workAddressLatLng,
  }) {
    getStorage.write(StringConstants.userId, userId);
    getStorage.write(StringConstants.userName, userName);
    getStorage.write(StringConstants.contactNumber, contactNumber);
    setHomeAddress(address: homeAddress, latLng: homeAddressLatLng);
    setWorkAddress(address: workAddress, latLng: workAddressLatLng);
  }

  static void setUserName({required String userName}) {
    getStorage.write(StringConstants.userName, userName);
  }

  static void setContactNumber({required String contactNumber}) {
    getStorage.write(StringConstants.contactNumber, contactNumber);
  }

  static void setHomeAddress({
    required String? address,
    required LatLng? latLng,
  }) {
    if (address != null) {
      getStorage.write(StringConstants.homeAddress, address);
    }
    if (latLng != null) {
      getStorage.write(StringConstants.homeAddressLatLng, latLng);
    }
  }

  static void setWorkAddress({
    required String? address,
    required LatLng? latLng,
  }) {
    if (address != null) {
      getStorage.write(StringConstants.workAddress, address);
    }
    if (latLng != null) {
      getStorage.write(StringConstants.workAddressLatLng, latLng);
    }
  }

  static String getUserId() {
    try {
      return getStorage.read(StringConstants.userId) ?? "-1";
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 21");
      return "-1";
    }
  }

  static String getUserName() {
    try {
      return getStorage.read(StringConstants.userName) ?? "-1";
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 32");
      return "-1";
    }
  }

  static String getHomeAddress() {
    try {
      return getStorage.read(StringConstants.homeAddress) ?? "";
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref");
      return "";
    }
  }

  static String getWorkAddress() {
    try {
      return getStorage.read(StringConstants.workAddress) ?? "";
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref");
      return "";
    }
  }

  static LatLng? getHomeAddressLatLng() {
    try {
      return getStorage.read(StringConstants.homeAddressLatLng);
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref");
    }
    return null;
  }

  static LatLng? getWorkAddressLatLng() {
    try {
      return getStorage.read(StringConstants.workAddressLatLng);
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref");
    }
    return null;
  }

  static removeAllFromUserPref() async {
    try {
      await GetStorage.init();
      return await getStorage.erase();
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 40");
      return Future.error(e);
    }
  }
}
