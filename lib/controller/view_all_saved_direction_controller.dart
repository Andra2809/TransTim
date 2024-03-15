import 'package:get/get.dart';

import '../model/saved_direction.dart';
import '../utility/constants/api_constants.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ViewAllSavedDirectionController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<SavedDirection> savedDirectionList = <SavedDirection>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedDirection();
  }

  Future<void> fetchSavedDirection() async {
    try {
      isLoading(true);
      savedDirectionList.clear();
      String userId = UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getDirectionByUserId + userId,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        savedDirectionList.value = jsonResponse.map((e) {
          return SavedDirection.fromJson(e);
        }).toList();
      }
    } catch (e) {
      savedDirectionList.value = <SavedDirection>[];
    } finally {
      isLoading(false);
    }
  }
}
