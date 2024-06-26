import 'package:get/get.dart';
import 'package:trans_tim/utility/helper/date_time_utils.dart';

import '../model/ticket_booking.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ViewAllUserTicketController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<TicketBooking> ticketBookingList = <TicketBooking>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTicket();
  }

  DateTime? getExpireTime({required TicketBooking booking}) {
    try {
      int? expireInMinutes = int.tryParse(booking.expireInMinutes ?? '');
      if (expireInMinutes != null) {
        String stringDt = "${booking.date} ${booking.time}";
        DateTime? purchaseDt = DateTimeUtils.stringToDateTime(string: stringDt);
        return purchaseDt?.add(Duration(minutes: expireInMinutes));
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "getExpireTime");
    }
    return null;
  }

  Future<void> fetchTicket() async {
    try {
      isLoading(true);
      ticketBookingList.clear();
      String userId = UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getTicketBookingByUserId + userId,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        ticketBookingList.value = jsonResponse.map((e) {
          return TicketBooking.fromJson(e);
        }).toList();
      }
    } catch (e) {
      ticketBookingList.value = <TicketBooking>[];
    } finally {
      isLoading(false);
    }
  }
}
