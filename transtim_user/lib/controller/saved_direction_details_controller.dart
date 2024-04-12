import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/route_step.dart';
import '../model/saved_direction.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/map_helper/gps_utils.dart';
import '../utility/map_helper/map_utils.dart';
import '../utility/map_helper/poly_line_utils.dart';
import '../utility/routes/route_constants.dart';

class SavedDirectionDetailsController extends GetxController {
  RxBool isSelectLocationVisible = true.obs;
  RxBool isLoading = false.obs;
  RxBool isMapLoading = true.obs;
  Rxn<LatLng> startLatLng = Rxn();
  Rxn<LatLng> destinationLatLng = Rxn();

  Rxn<SavedDirection> savedDirectionArg = Rxn();
  RxList<Marker> markerList = <Marker>[].obs;
  RxList<RouteStep> routeStepList = <RouteStep>[].obs;
  RxList<Polyline> polylineList = <Polyline>[].obs;

  RxList<String> modeTypeList = StringConstants.modeTypeList.obs;
  Rxn<String> selectedModeType = Rxn(StringConstants.driving);

  RxBool isTransitModeVisible = false.obs;
  RxList<String> transitModeList = StringConstants.transitList.obs;
  RxList<String> selectedTransitList = StringConstants.transitList.obs;

  // RxList<String> selectedTransitList = <String>[StringConstants.bus].obs;

  GoogleMapController? googleMapController;
  LatLng emptyLocation = const LatLng(0.0, 0.0);
  final Completer<GoogleMapController> _controller = Completer();

  late TextEditingController etStartLocation;
  late TextEditingController etDestinationLocation;

  @override
  void onInit() {
    super.onInit();
    isMapLoading.value = true;
    GpsUtils.requestLocation();
    initUI();
    loadArguments();
  }

  Future<void> onMapCreated(GoogleMapController googleMapController) async {
    try {
      isMapLoading.value = false;
      _controller.complete(googleMapController);
      this.googleMapController = googleMapController;
      _placeMarkers();
    } catch (e) {
      CommonHelper.printDebugError(
          e, "SavedDirectionDetailsController onMapCreated()");
    }
  }

  void initUI() {
    etStartLocation = TextEditingController();
    etDestinationLocation = TextEditingController();
    selectedModeType.listen((p0) {
      isTransitModeVisible.value = p0 == StringConstants.transit ? true : false;
    });
  }

  void loadArguments() {
    savedDirectionArg.value = Get.arguments;
    if (savedDirectionArg.value != null) {
      SavedDirection savedDirection = savedDirectionArg.value!;
      startLatLng.value = MapUtils.stringToLatLng(
        latLngString: savedDirection.startLocationLatLng,
      );
      destinationLatLng.value = MapUtils.stringToLatLng(
        latLngString: savedDirection.endLocationLatLng,
      );
      etStartLocation.text = savedDirection.startLocation ?? '';
      etDestinationLocation.text = savedDirection.endLocation ?? '';
      selectedModeType.value = savedDirection.mode;
      selectedTransitList.value = savedDirection.travelMode?.split("|") ?? [];
    }
  }

  void onTapActionBarIcon() {
    isSelectLocationVisible.value = !isSelectLocationVisible.value;
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
      arguments: [selectedModeType.value, routeStepList, totalRouteStep, null],
    );
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
    if (latLng != emptyLocation) {
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
    if (startLatLng.value != emptyLocation) {
      cameraZoomIn(startLatLng.value, null);
      if (destinationLatLng.value != emptyLocation) {
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
          }
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
}
