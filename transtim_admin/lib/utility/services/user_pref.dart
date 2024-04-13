import 'package:get_storage/get_storage.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class UserPref {
  static final getStorage = GetStorage();

  static void setLoginDetails({required String adminId}) {
    getStorage.write(StringConstants.adminId, adminId);
  }

  static bool getIsLoggedIn() {
    try {
      String? isLoggedIn = getStorage.read(StringConstants.adminId);
      return isLoggedIn != null && isLoggedIn.trim().isNotEmpty;
    } catch (e) {
      CommonHelper.printDebugError(e, "UserPref line 21");
      return false;
    }
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
