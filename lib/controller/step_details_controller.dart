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
