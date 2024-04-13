import 'package:get/get.dart';

import '../model/user_master.dart';
import '../utility/constants/api_constants.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';

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
}
