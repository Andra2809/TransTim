import '../utility/helper/common_helper.dart';

class Rating {
  String? ratingId, userId, ratingCount, dateTime, fullName;

  String? status;

  Rating({
    this.ratingId,
    this.userId,
    this.ratingCount,
    this.dateTime,
    this.fullName,
    this.status,
  });

  Rating.fromJson(Map<String, dynamic> json) {
    try {
      ratingId = json['ratingId'];
      userId = json['userId'];
      ratingCount = json['ratingCount'];
      dateTime = json['dateTime'];
      fullName = json['fullName'];
      status = json['api_status'];
    } catch (e) {
      CommonHelper.printDebugError(e, "Error parsing Rating");
    }
  }
}
