class SearchHistory {
  String? historyId, userId, startLocation, endLocation;
  String? startLocationLatLng, endLocationLatLng;
  String? mode, travelMode, dateTime;
  String? status;

  SearchHistory({
    this.historyId,
    this.userId,
    this.startLocation,
    this.endLocation,
    this.startLocationLatLng,
    this.endLocationLatLng,
    this.mode,
    this.travelMode,
    this.dateTime,
    this.status,
  });

  SearchHistory.fromJson(Map<String, dynamic> json) {
    historyId = json['historyId'];
    userId = json['userId'];
    startLocation = json['startLocation'];
    endLocation = json['endLocation'];
    startLocationLatLng = json['startLocationLatLng'];
    endLocationLatLng = json['endLocationLatLng'];
    mode = json['mode'];
    travelMode = json['travelMode'];
    dateTime = json['dateTime'];
    status = json['api_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data['userId'] = userId;
    }
    return data;
  }
}
