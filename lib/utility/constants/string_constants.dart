class StringConstants {
  static const String appName = "Trans Tim";
  static const String currencySymbol = "RON ";
  static String googleMapApiKey = "AIzaSyAhywGgq9Wijf3LMZOLVDAV8lQ8Buf5OK8";
  static int fareInKmMultiplyBy = 1;

  //ASSET
  static const String loadingLottie = 'asset/loading.json';
  static const String noResultLottie = 'asset/no_result.json';

  static const String boltLogo = 'asset/bolt_logo.png';
  static const String logo = 'asset/logo.png';
  static const String profile = 'asset/profile.png';
  static const String signIn = 'asset/sign_in.png';
  static const String loading = 'asset/loading_image.png';
  static const String error404 = 'asset/error404.png';
  static const String noImage = 'asset/no_image.jpeg';

  //PREF
  static const String userId = "userId";
  static const String userName = "userName";
  static const String contactNumber = "contactNumber";
  static const String homeAddress = "homeAddress";
  static const String homeAddressLatLng = "homeAddressLatLng";
  static const String workAddress = "workAddress";
  static const String workAddressLatLng = "workAddressLatLng";
  static const String lastSavedDateTime = "lastSavedDateTime";
  static const String isRatingDone = "isRatingDone";

  //DIRECTION_MODES
  static const String driving = "Driving";
  static const String walking = "Walking";
  static const String bicycling = "Cycling";
  static const String transit = "Transit";
  static const List<String> modeTypeList = [
    driving,
    walking,
    bicycling,
    transit
  ];

  static const String bus = "Bus";
  static const String subway = "Subway";
  static const String train = "Train";
  static const String tramAndLightRail = "Tram and light rail";
  static const List<String> transitList = [
    bus,
    subway,
    train,
    tramAndLightRail
  ];
}
