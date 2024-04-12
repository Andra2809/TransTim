import 'package:get/get.dart';

import '../model/ticket.dart';
import '../utility/constants/api_constants.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';

class TicketSummaryController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Ticket> ticketList = <Ticket>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTicket();
  }

  void onPressBookTickets({required Ticket ticket}) {
    Get.toNamed(
      RouteConstants.ticketBookingScreen,
      arguments: ticket,
    );
  }

  Future<void> fetchTicket() async {
    try {
      isLoading(true);
      ticketList.clear();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.baseTicket,
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        ticketList.value = jsonResponse.map((e) {
          return Ticket.fromJson(e);
        }).toList();
      }
    } catch (e) {
      ticketList.value = <Ticket>[];
    } finally {
      isLoading(false);
    }
  }
}
