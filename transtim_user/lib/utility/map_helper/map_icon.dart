import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIcon {
  static BitmapDescriptor? restaurantIcon, nightClubIcon, shoppingMallIcon;
  static BitmapDescriptor? beachIcon, hospitalIcon, policeIcon;

  static Future<BitmapDescriptor> getBitmapDescriptor({
    required String? type,
  }) async {
    BitmapDescriptor? bitmapDescriptor;
    if (type == null) return BitmapDescriptor.defaultMarker;
    return bitmapDescriptor ?? BitmapDescriptor.defaultMarker;
  }
}
