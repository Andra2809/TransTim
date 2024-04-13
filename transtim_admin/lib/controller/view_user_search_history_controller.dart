import 'package:get/get.dart';

import '../model/search_history.dart';
import '../utility/constants/api_constants.dart';
import '../utility/services/api_provider.dart';

class ViewUserSearchHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxString userId = '-1'.obs;
  RxList<SearchHistory> searchHistoryList = <SearchHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = Get.arguments ?? "-1";
    fetchSearchHistory();
  }

  Future<void> fetchSearchHistory() async {
    try {
      isLoading(true);
      searchHistoryList.clear();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getSearchHistoryByUser + userId.value,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        searchHistoryList.value = jsonResponse.map((e) {
          return SearchHistory.fromJson(e);
        }).toList();
      }
    } catch (e) {
      searchHistoryList.value = <SearchHistory>[];
    } finally {
      isLoading(false);
    }
  }
}
