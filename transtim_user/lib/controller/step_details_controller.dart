import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/route_step.dart';
import '../model/saved_direction.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/map_helper/poly_line_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';

class StepDetailsController extends GetxController {
  RxList<RouteStep> routeStepList = <RouteStep>[].obs;
  RxList<RouteStep> drivingRouteStepList = <RouteStep>[].obs;
  Rxn<SavedDirection> savedDirectionArg = Rxn();
  Rxn<RouteStep> totalRouteStepArg = Rxn();
  RxString totalDuration = ''.obs;
  RxnString selectedModeType = RxnString();
  RxBool isTransitModeSelected = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedModeType.value = Get.arguments[0];
    isTransitModeSelected.value = Get.arguments[0] == StringConstants.transit;
    routeStepList.value = Get.arguments[1] ?? [];
    totalRouteStepArg.value = Get.arguments[2];
    savedDirectionArg.value = Get.arguments[3];

    _checkIfDrivingElseFetchDrivingData();
  }

  Future<void> onPressButtonSaveDirection() async {
    if (savedDirectionArg.value != null) {
      savedDirectionArg.value?.dateTime = DateTimeUtils.currentDateTimeYMDHMS();
      await savedDirection();
    }
  }

  void onPressButtonBookTickets() {
    Get.toNamed(RouteConstants.ticketSummaryScreen);
  }

  Future<void> onTapOrderBoltService() async {
    try {
      String appUrl = 'https://bolt.eu/';
      Uri appURI = Uri.parse(appUrl);
      await launchUrl(appURI, mode: LaunchMode.externalApplication);
    } catch (e) {
      SnackBarUtils.errorSnackBar(message: 'Failed to open application');
    }
  }

  Icon getModeIcon(bool? enableInstructionsIcon, RouteStep? routeStep) {
    String? transitMode = routeStep?.transitMode;
    String? travelMode = routeStep?.travelMode;
    String? vehicleMode = routeStep?.vehicleMode;
    String instructions =
        enableInstructionsIcon == true && routeStep?.instructions != null
            ? routeStep?.instructions ?? ''
            : '';
    if (_containsTurn(instructions, 'left')) {
      return const Icon(Icons.turn_left_outlined);
    } else if (_containsTurn(instructions, 'right')) {
      return const Icon(Icons.turn_right_outlined);
    } else if (_containsTurn(instructions, 'north')) {
      return const Icon(Icons.north);
    } else if (_containsTurn(instructions, 'south')) {
      return const Icon(Icons.south);
    } else if (_containsTurn(instructions, 'east')) {
      return const Icon(Icons.east);
    } else if (_containsTurn(instructions, 'west')) {
      return const Icon(Icons.west);
    } else if (_containsTurn(instructions, 'northwest')) {
      return const Icon(Icons.north_west);
    } else if (_containsTurn(instructions, 'northeast')) {
      return const Icon(Icons.north_east);
    } else if (_containsTurn(instructions, 'southwest')) {
      return const Icon(Icons.south_west);
    } else if (_containsTurn(instructions, 'southeast')) {
      return const Icon(Icons.south_east);
    } else if (transitMode != null) {
      switch (transitMode.toLowerCase()) {
        case 'bus':
          return const Icon(Icons.directions_bus_filled_outlined);
        case 'subway':
          return const Icon(Icons.subway_outlined);
        case 'train':
          return const Icon(Icons.train_outlined);
        case 'tram':
          return const Icon(Icons.tram_outlined);
        default:
          return const Icon(Icons.directions_transit);
      }
    } else if (travelMode != null) {
      switch (travelMode.toLowerCase()) {
        case 'driving':
          return const Icon(Icons.directions_car_outlined);
        case 'transit':
          return const Icon(Icons.directions_transit);
        case 'walking':
          return const Icon(Icons.directions_walk_outlined);
        case 'bicycling':
          return const Icon(Icons.directions_bike_rounded);
        default:
          return const Icon(Icons.directions_car_outlined);
      }
    } else if (vehicleMode != null) {
      switch (vehicleMode.toLowerCase()) {
        case 'car':
          return const Icon(Icons.directions_car_outlined);
        case 'bike':
          return const Icon(Icons.electric_bike_outlined);
        case 'cycling':
          return const Icon(Icons.directions_bike_outlined);
        default:
          return const Icon(Icons.directions_car_outlined);
      }
    } else {
      return const Icon(Icons.directions_car_outlined);
    }
  }

  bool _containsTurn(String instructions, String turn) {
    return instructions.toLowerCase().contains(turn.toLowerCase());
  }

  String getModeDescription(RouteStep? routeStep) {
    if (routeStep?.transitMode != null) {
      return 'Transit Mode: ${routeStep?.transitMode}';
    } else if (routeStep?.vehicleMode != null) {
      return 'Vehicle Mode: ${routeStep?.vehicleMode}';
    } else {
      return 'Travel Mode: ${routeStep?.travelMode ?? ""}';
    }
  }

  Color? getTransitColor({String? transitMode}) {
    switch (transitMode?.toLowerCase()) {
      case 'bus':
        return const Color.fromARGB(255, 0, 0, 255);
      case 'subway':
        return const Color.fromARGB(255, 255, 0, 0);
      case 'train':
        return Colors.yellow;
      case 'tram':
        return const Color.fromARGB(255, 255, 165, 0);
    }
    return null;
  }

  String getArrivalTime() {
    final currentTime = DateTime.now().add(const Duration(minutes: 3));
    return " Arrival time: ${DateFormat('HH:mm').format(currentTime)}";
  }

  Future<void> _checkIfDrivingElseFetchDrivingData() async {
    bool isDriving = selectedModeType.value == StringConstants.driving;
    if (isDriving) {
      drivingRouteStepList.value = routeStepList;
    } else {
      await _getDrivingRouteList();
    }
    RouteStep? step = drivingRouteStepList.firstOrNull;
    totalDuration.value = step?.totalDuration ?? '';
  }

  Future<void> savedDirection() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.addDirection,
        obj: savedDirectionArg.value?.toJson(),
      ).then((response) {
        List savedDirectionList = response.map((e) {
          return SavedDirection.fromJson(e);
        }).toList();
        if (savedDirectionList.isNotEmpty) {
          if ((savedDirectionList.first.status != null) &&
              savedDirectionList.first.status != 'true') {
            onFailedResponse(savedDirectionList.first.status.toString());
          } else {
            onSuccessResponse();
          }
        }
      });
    } catch (e) {
      onFailedResponse(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onSuccessResponse() {
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Saved successfully",
    );
    savedDirectionArg.value = null;
  }

  void onFailedResponse(String response) {
    SnackBarUtils.errorSnackBar(
      title: "Failed",
      message: "Something went wrong",
    );
  }

  Future<void> _getDrivingRouteList() async {
    LatLng? startLatLng = totalRouteStepArg.value?.startLocation;
    LatLng? destinationLatLng = totalRouteStepArg.value?.endLocation;
    if (startLatLng != null) {
      if (destinationLatLng != null) {
        drivingRouteStepList.value = await PolyLineUtils.getRouteDetails(
          origin: startLatLng,
          destination: destinationLatLng,
          travelMode: StringConstants.driving,
        );
      }
    }
  }
}
