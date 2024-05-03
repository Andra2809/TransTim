import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:trans_tim/utility/constants/string_constants.dart';

import '../model/ticket.dart';
import '../model/ticket_booking.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
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
    passengerCount.value = passengerCount.value + 1;
  }

  void onTapSubtract() {
    if (passengerCount.value > 1) {
      passengerCount.value = passengerCount.value - 1;
    }
  }

  void onCreditCardModelChange({required CreditCardModel creditCardModel}) {
    cardNumber.value = creditCardModel.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocussed.value = creditCardModel.isCvvFocused;
  }

  void onPressButtonBookTickets() {
    formKey.currentState!.validate() ? bookTicket() : null;
  }

  TicketBooking createTicketBookingObject() {
    TicketBooking ticketBooking = TicketBooking();
    ticketBooking.ticketId = ticketArg.value?.ticketId;
    ticketBooking.userId = UserPref.getUserId();
    ticketBooking.date = DateTimeUtils.currentDate();
    ticketBooking.time = DateTimeUtils.currentTime();
    ticketBooking.passengerCount = passengerCount.value.toString();
    ticketBooking.totalAmount = totalBookingFarePrice.toStringAsFixed(2);
    return ticketBooking;
  }

  Future<void> bookTicket() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.addTicketBooking,
        obj: createTicketBookingObject().toJson(),
      ).then((response) {
        List ticketList = response.map((e) {
          return Ticket.fromJson(e);
        }).toList();
        if (ticketList.isNotEmpty) {
          if ((ticketList.first.status != null) &&
              ticketList.first.status != 'true') {
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
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Booked successfully",
    );
    //Get.offNamedUntil(RouteConstants.homeScreen, (route) => false);
    //Get.offNamedUntil(RouteConstants.ticketSummaryScreen, (route) => false);
    Get.back(closeOverlays: true, canPop: true);
  }

  void onFailedResponse(String response) {
    SnackBarUtils.errorSnackBar(
      title: "Failed",
      message: "Something went wrong",
    );
  }
}
