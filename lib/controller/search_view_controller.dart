import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/suggestion_model.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/common_helper.dart';

class SearchViewController extends GetxController {
  late var placeList = <SuggestionModel>[].obs;
  var isLoading = false.obs;

  Future<dynamic> getPredictions(String input) async {
    var jsonResponse = [];
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String apiKey = StringConstants.googleMapApiKey;

    String sessionToken = const Uuid().v4();
    String request = '$baseURL?input=$input&key=$apiKey'
        '&sessiontoken=$sessionToken';
    Response response = await GetConnect().get(request);
    if (response.statusCode == 200) {
      Map data = response.body;
      for (int i = 0; i < data["predictions"].length; i++) {
        jsonResponse.add(data["predictions"][i]);
      }
    }
    return jsonResponse;
  }

  void getSuggestion(String input) async {
    try {
      isLoading(true);
      var jsonResponse = await getPredictions(input) as List;
      placeList.value = jsonResponse.map((e) {
        return SuggestionModel.fromJson(e);
      }).toList();
    } catch (e) {
      CommonHelper.printDebugError(e, "SearchViewController getSuggestion()");
    } finally {
      isLoading(false);
    }
  }
}