import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_tim/utility/common_widgets/price_tag.dart';

import '../controller/ticket_summary_controller.dart';
import '../model/ticket.dart';
import '../utility/common_widgets/common_data_holder.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/constants/dimens_constants.dart';

class TicketSummaryScreen extends StatelessWidget {
  TicketSummaryScreen({super.key});

  final TicketSummaryController _controller =
      Get.put(TicketSummaryController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(title: const Text('Ticket Booking')),
      isBottomBarVisible: true,
      isLoginCompulsory: true,
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: CommonDataHolder(
              controller: _controller,
              dataList: _controller.ticketList,
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
    List<Ticket> tickets = _controller.ticketList.where((ticket) {
      String? ticketType = ticket.ticketType?.toLowerCase();
      return ticketType?.contains('ticket') ?? false;
    }).toList();
    List<Ticket> passes = _controller.ticketList.where((ticket) {
      String? ticketType = ticket.ticketType?.toLowerCase();
      return ticketType?.contains('pass') ?? false;
    }).toList();
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildSectionHeader("Tickets"),
          if (tickets.isNotEmpty) _buildTicketList(tickets),
          _buildSectionHeader("Passes"),
          if (passes.isNotEmpty) _buildTicketList(passes),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Text(
        title,
        style: TextStyle(fontSize: Get.textTheme.headlineMedium?.fontSize),
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets) {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return _ticketCard(tickets[index]);
        },
      ),
    );
  }

  Widget _ticketCard(Ticket ticket) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: DimenConstants.mixPadding),
              child: PriceTag(priceText: ticket.amount ?? 'Unknown'),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "▪ ${ticket.title ?? 'Unknown'}",
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ticket.description ?? '',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: Get.textTheme.labelSmall?.fontSize,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    constraints: BoxConstraints(minWidth: Get.width),
                    child: InkWell(
                      onTap: () {
                        _controller.onPressBookTickets(ticket: ticket);
                      },
                      child: const Text(
                        "Buy Tickets",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
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
