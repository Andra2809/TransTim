import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/route_step.dart';
import '../model/saved_direction.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/map_helper/gps_utils.dart';
import '../utility/map_helper/map_utils.dart';
import '../utility/map_helper/poly_line_utils.dart';
import '../utility/map_helper/search_view.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/user_pref.dart';

class HomeController extends GetxController {
  RxBool isSelectLocationVisible = true.obs;
  RxBool isLoading = false.obs;
  RxBool isMapLoading = true.obs;
  Rxn<LatLng> startLatLng = Rxn();
  Rxn<LatLng> destinationLatLng = Rxn();

  RxList<Marker> markerList = <Marker>[].obs;
  RxList<RouteStep> routeStepList = <RouteStep>[].obs;
  RxList<Polyline> polylineList = <Polyline>[].obs;

  RxList<String> modeTypeList = StringConstants.modeTypeList.obs;
  Rxn<String> selectedModeType = Rxn(StringConstants.driving);

  RxBool isTransitModeVisible = false.obs;
  RxList<String> transitModeList = StringConstants.transitList.obs;
  RxList<String> selectedTransitList = StringConstants.transitList.obs;

  RxList<String> selectedTransitList = <String>[StringConstants.bus].obs;

  GoogleMapController? googleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  late TextEditingController etStartLocation;
  late TextEditingController etDestinationLocation;

  @override
  void onInit() {
    super.onInit();
    isMapLoading.value = true;
    GpsUtils.requestLocation().then((value) => _fetchUserLocation());
    initUI();
    initListeners();
  }

  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    try {
      _controller.complete(googleMapController);
      this.googleMapController = googleMapController;
      await _fetchUserLocation();
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onMapCreated()");
    } finally {
      isMapLoading.value = false;
    }
  }


  void initUI() {
    etStartLocation = TextEditingController();
    etDestinationLocation = TextEditingController();
  }

  void initListeners() {
    startLatLng.listen((p0) => _placeMarkers());
    destinationLatLng.listen((p0) => _placeMarkers());
    selectedModeType.listen((p0) {
      isTransitModeVisible.value = p0 == StringConstants.transit ? true : false;
      if (isTransitModeVisible.value && selectedTransitList.isNotEmpty) {
        _placeMarkers();
      } else if (!isTransitModeVisible.value) {
        _placeMarkers();
      } else {
        SnackBarUtils.errorSnackBar(message: 'No transit mode selected');
      }
    });
  }

  void onTapActionBarIcon() {
    isSelectLocationVisible.value = !isSelectLocationVisible.value;
  }

  Future<void> onTapWorkAddress({bool? isDestination}) async {
    String address = UserPref.getWorkAddress();
    if (address.trim().isNotEmpty) {
      await onSearched(value: address, isDestination: isDestination);
    }
  }

  Future<void> onTapHomeAddress({bool? isDestination}) async {
    String address = UserPref.getHomeAddress();
    if (address.trim().isNotEmpty) {
      await onSearched(value: address, isDestination: isDestination);
    }
  }

  void onPressGetDetails() {
    RouteStep totalRouteStep = RouteStep();
    totalRouteStep.departureStopName = etStartLocation.text;
    totalRouteStep.arrivalStopName = etDestinationLocation.text;
    totalRouteStep.totalDuration = routeStepList.firstOrNull?.totalDuration;
    totalRouteStep.totalDistance = routeStepList.firstOrNull?.totalDistance;
    totalRouteStep.startLocation = startLatLng.value;
    totalRouteStep.endLocation = destinationLatLng.value;
    Get.toNamed(
      RouteConstants.stepDetailsScreen,
      arguments: [
        selectedModeType.value,
        routeStepList,
        totalRouteStep,
        _createSavedDirectionObject(),
      ],
    );
  }

  void onModeTypeChange({String? type}) {
    if (type != null) selectedModeType.value = type;
  }

  void onChangeTransitCheckBox({String? transit}) {
    if (transit != null) {
      if (selectedTransitList.contains(transit)) {
        selectedTransitList.remove(transit);
      } else {
        selectedTransitList.add(transit);
      }
    }
    if (selectedTransitList.isNotEmpty) {
      _placeMarkers();
    } else {
      SnackBarUtils.errorSnackBar(message: 'No transit mode selected');
    }
  }

  void onTapSearchCity({bool? isDestination}) {
    try {
      if (googleMapController != null) {
        showSearch(
          context: Get.context as BuildContext,
          delegate: SearchView(),
        ).then((value) {
          onSearched(value: value, isDestination: isDestination);
        });
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onTapSearchCity()");
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      if (startLatLng.value == null) {
        await onTapHomeAddress();
        await onTapWorkAddress(isDestination: true);
        if (startLatLng.value == null) {
          Position? position = await GpsUtils.getCurrentLocation();
          if (position != null) {
            startLatLng.value = LatLng(position.latitude, position.longitude);
            if (startLatLng.value != null) {
              String? address = await MapUtils.getAddressFromLatLng(
                latLng: startLatLng.value,
              );
              etStartLocation.text = address ?? "";
            }
          }
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController()");
    }
  }

  Future<void> onSearched({required String value, bool? isDestination}) async {
    try {
      List<Location> locationList = await locationFromAddress(value);
      Location location = locationList.first;
      LatLng latLng = LatLng(location.latitude, location.longitude);
      if (isDestination == true) {
        etDestinationLocation.text = value;
        destinationLatLng.value = latLng;
      } else {
        etStartLocation.text = value;
        startLatLng.value = latLng;
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "HomeController onSearched()");
    } finally {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _placeMarkers() {
    CommonProgressBar.show();
    markerList.clear();
    polylineList.clear();
    if (googleMapController != null) {
      _addMarker(startLatLng.value, "Starting Point");
      _addMarker(destinationLatLng.value, "Destination");
      _zoomCameraAndAddPolyLine();
    }
    CommonProgressBar.hide();
  }

  Future<void> _addMarker(LatLng? latLng, String title) async {
    if (latLng != null) {
      Marker? marker = await MapUtils.addMarker(latLng: latLng, title: title);
      marker != null ? markerList.add(marker) : null;
    }
  }

}
