class UserMaster {
  String? userId, fullName, emailId, password, contactNumber;
  String? homeAddress, homeAddressLatLng, workAddress, workAddressLatLng;
  String? newPassword, status;

  UserMaster({
    this.userId,
    this.fullName,
    this.emailId,
    this.password,
    this.contactNumber,
    this.homeAddress,
    this.homeAddressLatLng,
    this.workAddress,
    this.workAddressLatLng,
    this.newPassword,
    this.status,
  });

  UserMaster.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    emailId = json['emailId'];
    password = json['password'];
    contactNumber = json['contactNumber'];
    homeAddress = json['homeAddress'];
    homeAddressLatLng = json['homeAddressLatLng'];
    workAddress = json['workAddress'];
    workAddressLatLng = json['workAddressLatLng'];
    status = json['api_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data["userId"] = userId;
    }
    if (fullName != null) {
      data["fullName"] = fullName;
    }
    if (emailId != null) {
      data["emailId"] = emailId;
    }
    if (password != null) {
      data["password"] = password;
    }
    if (contactNumber != null) {
      data["contactNumber"] = contactNumber;
    }
    if (homeAddress != null) {
      data["homeAddress"] = homeAddress;
    }
    if (workAddress != null) {
      data["workAddress"] = workAddress;
    }
    if (homeAddressLatLng != null) {
      data["homeAddressLatLng"] = homeAddressLatLng;
    }
    if (workAddressLatLng != null) {
      data["workAddressLatLng"] = workAddressLatLng;
    }
    if (newPassword != null) {
      data["newPassword"] = newPassword;
    }
    return data;
  }
}
