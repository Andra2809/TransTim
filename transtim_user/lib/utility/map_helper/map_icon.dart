import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIcon {
  static BitmapDescriptor? restaurantIcon, nightClubIcon, shoppingMallIcon;
  static BitmapDescriptor? beachIcon, hospitalIcon, policeIcon;

  static Future<BitmapDescriptor> getBitmapDescriptor({
    required String? type,
  }) async {
    BitmapDescriptor? bitmapDescriptor;
    if (type == null) return BitmapDescriptor.defaultMarker;
    // if (type.isCaseInsensitiveContainsAny(StringConstants.restaurants)) {
    //   if (restaurantIcon == null) await setRestaurantIcon();
    //   bitmapDescriptor = restaurantIcon;
    // } else if (type.isCaseInsensitiveContainsAny(StringConstants.nightClubs)) {
    //   if (nightClubIcon == null) await setNightClubIcon();
    //   bitmapDescriptor = nightClubIcon;
    // } else if (type.isCaseInsensitiveContainsAny(StringConstants.shopping)) {
    //   if (shoppingMallIcon == null) await setShoppingMallIcon();
    //   bitmapDescriptor = shoppingMallIcon;
    // } else if (type.isCaseInsensitiveContainsAny(StringConstants.beaches)) {
    //   if (beachIcon == null) await setBeachIcon();
    //   bitmapDescriptor = beachIcon;
    // } else if (type.isCaseInsensitiveContainsAny(StringConstants.hospitals)) {
    //   if (hospitalIcon == null) await setHospitalIcon();
    //   bitmapDescriptor = hospitalIcon;
    // } else if (type.isCaseInsensitiveContainsAny(StringConstants.police)) {
    //   if (policeIcon == null) await setPoliceIcon();
    //   bitmapDescriptor = policeIcon;
    // } else {
    //   bitmapDescriptor = BitmapDescriptor.defaultMarker;
    // }
    return bitmapDescriptor ?? BitmapDescriptor.defaultMarker;
  }
}
