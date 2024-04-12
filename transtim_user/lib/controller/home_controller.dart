import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/route_step.dart';
import '../model/saved_direction.dart';
import '../screen/rating_dialog_screen.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/map_helper/gps_utils.dart';
import '../utility/map_helper/map_utils.dart';
import '../utility/map_helper/poly_line_utils.dart';
import '../utility/map_helper/search_view.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class HomeController extends SuperController {
  RxBool isSelectLocationVisible = true.obs;
  RxBool isLoading = false.obs;
  RxBool isMapLoading = true.obs;
  RxBool isUserLoggedIn = false.obs;
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
    initObj();
  }

  @override
  Future<void> onResumed() async {
    if (UserPref.getIsRatingDone() != true && isUserLoggedIn.isFalse) {
      String userId = UserPref.getUserId().trim();
      isUserLoggedIn.value = !(userId == "-1" || userId == "0");
    }
    if (isUserLoggedIn.isTrue && UserPref.getIsRatingDone() != true) {
      DateTime? lastSavedDateTime = UserPref.getLastSavedDateTime();
      if (lastSavedDateTime == null) {
        UserPref.setLastSavedDateTime(lastSavedDateTime: DateTime.now());
      } else {
        await checkIfRatingDone();
        if (UserPref.getIsRatingDone() != true) {
          Duration duration = const Duration(minutes: 5);
          if (DateTime.now().difference(lastSavedDateTime) >= duration) {
            UserPref.setLastSavedDateTime(lastSavedDateTime: DateTime.now());
            while (Get.isDialogOpen == true) {
              Get.back();
            }
            Get.dialog(RatingDialogScreen()).then(
              (value) {
                UserPref.setLastSavedDateTime(
                  lastSavedDateTime: DateTime.now(),
                );
              },
            );
          }
        }
      }
    }
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

  SavedDirection? _createSavedDirectionObject() {
    SavedDirection? direction;
    try {
      String userId = UserPref.getUserId();
      bool isUserIdEmpty = userId == "-1" || userId == "0" || userId.isEmpty;
      if (!isUserIdEmpty &&
          startLatLng.value != null &&
          destinationLatLng.value != null) {
        direction = SavedDirection();
        direction.userId = UserPref.getUserId();
        direction.startLocation = etStartLocation.text.trim();
        direction.endLocation = etDestinationLocation.text.trim();
        direction.startLocationLatLng = MapUtils.latLngToString(
          latLng: startLatLng.value,
        );
        direction.endLocationLatLng = MapUtils.latLngToString(
          latLng: destinationLatLng.value,
        );
        direction.mode = selectedModeType.value;
        direction.travelMode = selectedTransitList.join("|");
        direction.dateTime = DateTimeUtils.currentDateTimeYMDHMS();
      }
    } catch (e) {
      direction = null;
      CommonHelper.printDebugError(e, "_createSavedDirectionObject");
    }
    return direction;
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

  void initObj() {
    String userId = UserPref.getUserId().trim();
    isUserLoggedIn.value = !(userId == "-1" || userId == "0");
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

  Future<void> checkIfRatingDone() async {
    try {
      String userId = UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getRating + userId,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        UserPref.setIsRatingDone(isRatingDone: true);
      }
    } catch (e) {
      Get.printError();
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      if (startLatLng.value == null) {
        await onTapHomeAddress();
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

  void cameraZoomIn(LatLng? latLng, double? zoomLength) {
    MapUtils.zoomInCamera(
      controller: googleMapController!,
      latLng: latLng,
      zoomLength: zoomLength,
    );
  }

  Future<void> _zoomCameraAndAddPolyLine() async {
    if (startLatLng.value != null) {
      cameraZoomIn(startLatLng.value, null);
      if (destinationLatLng.value != null) {
        routeStepList.value = await PolyLineUtils.getRouteDetails(
          origin: startLatLng.value,
          destination: destinationLatLng.value,
          travelMode: selectedModeType.value,
          selectedTransitModes: selectedTransitList,
        );

        if (routeStepList.isNotEmpty) {
          List<Polyline>? list = await PolyLineUtils.addPolyLines(
            origin: startLatLng.value!,
            routeSteps: routeStepList,
          );

          if (list.isNotEmpty) {
            polylineList.addAll(list);
            for (int i = 1; i < routeStepList.length; i++) {
              RouteStep step = routeStepList[i];
              RouteStep prevStep = routeStepList[i - 1];
              if (step.polylinePoints != null) {
                List<LatLng> decodedPoints = PolyLineUtils.decodePoly(
                  poly: step.polylinePoints!,
                );
                if (_shouldAddModeChangeMarker(prevStep, step)) {
                  Marker? marker = await MapUtils.addMarker(
                    latLng: decodedPoints.first,
                    title: step.instructions,
                    type: 'change',
                    snippet: _getModeDescription(step),
                  );
                  if (marker != null) markerList.add(marker);
                }
              }
            }
            cameraZoomIn(startLatLng.value, 12.0);
            if (isUserLoggedIn.isTrue) {
              ApiProvider.postMethod(
                url: ApiConstants.addHistory,
                obj: _createSavedDirectionObject()?.toJson(),
              );
            }
          } else {
            SnackBarUtils.errorSnackBar(message: 'No routes available');
          }
        } else {
          SnackBarUtils.errorSnackBar(message: 'No routes available');
        }
      }
    }
  }

  bool _shouldAddModeChangeMarker(RouteStep prevStep, RouteStep currentStep) {
    return prevStep.transitMode != currentStep.transitMode;
  }

  String _getModeDescription(RouteStep routeStep) {
    if (routeStep.transitMode != null) {
      return 'Transit Mode: ${routeStep.transitMode}';
    } else if (routeStep.vehicleMode != null) {
      return 'Vehicle Mode: ${routeStep.vehicleMode}';
    } else {
      return 'Travel Mode: ${routeStep.travelMode ?? ""}';
    }
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}
}
