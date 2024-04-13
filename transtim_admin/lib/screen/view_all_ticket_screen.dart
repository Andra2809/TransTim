import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_data_holder.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/view_all_ticket_controller.dart';
import '../model/ticket_booking.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/price_tag.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/date_time_utils.dart';

class ViewAllTicketScreen extends StatelessWidget {
  ViewAllTicketScreen({super.key});

  final ViewAllTicketController _controller =
      Get.put(ViewAllTicketController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      isBottomBarVisible: true,
      appBar: AppBar(
        title: const Text("Tickets"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: CommonDataHolder(
              controller: _controller,
              dataList: _controller.ticketBookingList,
              widget: _dataHolderWidget(),
              noResultText: "No Ticket found",
              onRefresh: () => _controller.fetchTicket(),
            ),
          );
        },
      ),
    );
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _controller.ticketBookingList.length,
        itemBuilder: (context, index) {
          return _recentTicketCard(_controller.ticketBookingList[index]);
        },
      ),
    );
  }

  Widget _recentTicketCard(TicketBooking ticketBooking) {
    String symbol = StringConstants.currencySymbol;
    List<String>? parts = ticketBooking.amount?.split(' ');
    String? farePrice = ticketBooking.totalAmount;
    if (parts != null && parts.length > 1) symbol = parts[1];
    DateTime? expireDt = _controller.getExpireTime(booking: ticketBooking);
    String? expireTime = DateTimeUtils.dateTimeToString(dateTime: expireDt);
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Card(
        elevation: DimenConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.cardRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(DimenConstants.layoutPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Purchase Date: ${ticketBooking.date ?? "--"} ${ticketBooking.time ?? "--"}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Visibility(
                    visible: expireDt != null,
                    child: Text(
                      "Expiry Date: $expireTime",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: expireDt != null
                            ? expireDt.isBefore(DateTime.now()) == true
                                ? Colors.red
                                : Colors.green
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  _ticketCard(ticketBooking),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text("Passenger : ${ticketBooking.passengerCount ?? 0}"),
                  Text("Total Amount : $symbol ${farePrice ?? 0}"),
                  Text("Type  : ${ticketBooking.ticketType ?? '--'}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard(TicketBooking ticketBooking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: DimenConstants.mixPadding),
              child: PriceTag(priceText: ticketBooking.amount ?? 'Unknown'),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "▪ ${ticketBooking.title ?? 'Unknown'}",
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ticketBooking.description ?? '',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Get.textTheme.labelSmall?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
