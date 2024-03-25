class SavedDirection {
  String? directionId, userId, startLocation, endLocation;
  String? startLocationLatLng, endLocationLatLng;
  String? mode, travelMode, dateTime;
  String? status;

  SavedDirection({
    this.directionId,
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

  SavedDirection.fromJson(Map<String, dynamic> json) {
    directionId = json['directionId'];
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
    if (directionId != null) {
      data['directionId'] = directionId;
    }
    if (userId != null) {
      data['userId'] = userId;
    }
    if (startLocation != null) {
      data['startLocation'] = startLocation;
    }
    if (endLocation != null) {
      data['endLocation'] = endLocation;
    }
    if (startLocationLatLng != null) {
      data['startLocationLatLng'] = startLocationLatLng;
    }
    if (endLocationLatLng != null) {
      data['endLocationLatLng'] = endLocationLatLng;
    }
    if (mode != null) {
      data['mode'] = mode;
    }
    if (travelMode != null) {
      data['travelMode'] = travelMode;
    }
    if (dateTime != null) {
      data['dateTime'] = dateTime;
    }
    return data;
  }
}
