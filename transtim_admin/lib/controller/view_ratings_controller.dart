import 'package:get/get.dart';

import '../model/rating.dart';
import '../utility/constants/api_constants.dart';
import '../utility/services/api_provider.dart';

class ViewRatingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Rating> ratingList = <Rating>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    try {
      isLoading(true);
      ratingList.clear();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getAllUserAppRatings,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        ratingList.value = jsonResponse.map((e) {
          return Rating.fromJson(e);
        }).toList();
      }
    } catch (e) {
      ratingList.value = <Rating>[];
    } finally {
      isLoading(false);
    }
  }
}
