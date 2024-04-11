import 'package:get/get.dart';

import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class RatingDialogController extends GetxController {
  RxBool isSubmitVisible = false.obs;
  RxDouble ratingCount = 0.0.obs;

  void onTapSubmit() {
    checkIfRatingDone();
  }

  void onTapNotNow() {
    Get.back();
  }

  void onTapBack() {
    isSubmitVisible.value = false;
  }

  void onRatingUpdate({required double ratingValue}) {
    ratingCount.value = ratingValue;
    isSubmitVisible.value = true;
  }

  Future<void> checkIfRatingDone() async {
    try {
      CommonProgressBar.show();
      String userId = UserPref.getUserId();
      Map<String, dynamic> ratingData = {
        'userId': userId,
        'ratingCount': ratingCount.value,
        'dateTime': DateTimeUtils.currentDateTimeYMDHMS(),
      };
      List<dynamic> jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.addRating,
        obj: ratingData,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        onSuccessResponse();
      } else {
        onFailedResponse();
      }
    } catch (e) {
      Get.printError();
      onFailedResponse();
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onSuccessResponse() {
    CommonProgressBar.hide();
    UserPref.setIsRatingDone(isRatingDone: true);
    while (Get.isDialogOpen == true) {
      Get.back();
    }
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: 'Thank you for rating our app!',
    );
  }

  void onFailedResponse() {
    SnackBarUtils.errorSnackBar(message: "Something went wrong");
  }
}
