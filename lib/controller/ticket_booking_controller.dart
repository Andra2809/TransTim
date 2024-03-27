import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // New import for formatting dates

import '../model/ticket.dart';
import '../model/ticket_booking.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/logs/logger.dart'; // New import for logging
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class TicketBookingController extends GetxController {
  RxList<TicketBooking> ticketBookingList = <TicketBooking>[].obs;
  Rxn<Ticket> ticketArg = Rxn();
  RxInt passengerCount = 1.obs;
  RxDouble totalBookingFarePrice = 0.0.obs;

  RxString symbol = StringConstants.currencySymbol.obs;
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocussed = false.obs;

  double totalFarePrice = 0.0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadArgs();
    setFarePriceListener();
    logBookingAttempt("Initialization");
  }

  void loadArgs() {
    ticketArg.value = Get.arguments;
    List<String>? parts = ticketArg.value?.amount?.split(' ');
    double? farePrice = double.tryParse(parts?.firstOrNull ?? '');
    totalFarePrice = farePrice ?? 0.0;
    if (parts != null && parts.length > 1) symbol.value = parts[1];
  }

  void setFarePriceListener() {
    totalBookingFarePrice.value = totalFarePrice * passengerCount.value;
    passengerCount.listen((p0) {
      totalBookingFarePrice.value = totalFarePrice * p0;
    });
  }

  void onTapAdd() {
    passengerCount.value++;
    logBookingAttempt("Increased passenger count");
  }

  void onTapSubtract() {
    if (passengerCount.value > 1) {
      passengerCount.value--;
      logBookingAttempt("Decreased passenger count");
    }
  }

  void onPressButtonBookTickets() {
    if (formKey.currentState!.validate()) {
      bookTicket();
    }
  }

  TicketBooking createTicketBookingObject() {
    return TicketBooking(
      ticketId: ticketArg.value?.ticketId,
      userId: UserPref.getUserId(),
      date: DateTimeUtils.currentDate(),
      time: DateTimeUtils.currentTime(),
      passengerCount: passengerCount.value.toString(),
      totalAmount: totalBookingFarePrice.toStringAsFixed(2),
    );
  }

  Future<void> bookTicket() async {
    logBookingAttempt("Attempting to book ticket");
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.addTicketBooking,
        obj: createTicketBookingObject().toJson(),
      ).then((response) {
        List<Ticket> ticketList = List<Ticket>.from(response.map(Ticket.fromJson));
        if (ticketList.isNotEmpty) {
          if (ticketList.first.status != null && ticketList.first.status != 'true') {
            onFailedResponse(ticketList.first.status.toString());
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
    logBookingAttempt("Success");
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Booked successfully",
    );
    Get.offNamedUntil(RouteConstants.homeScreen, (_) => false);
  }

  void onFailedResponse(String response) {
    logBookingAttempt("Failed: $response");
    SnackBarUtils.errorSnackBar(
      title: "Failed",
      message: "Something went wrong",
    );
  }

  void logBookingAttempt(String message) {
    // Implement a simple logger or use a logging package
    Logger.log("$message at ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}");
  }
}
