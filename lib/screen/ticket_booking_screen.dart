import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import '../controller/ticket_booking_controller.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/constants/dimens_constants.dart';

class TicketBookingScreen extends StatelessWidget {
  TicketBookingScreen({Key? key}) : super(key: key);

  final TicketBookingController _controller = Get.put(TicketBookingController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('Ticket Booking'),
      ),
      body: Obx(() => _buildBody()),
      isBottomBarVisible: true,
      isLoginCompulsory: true,
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBody() {
    return _controller.ticketArg.value == null
        ? const Center(child: Text('No Booking available'))
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(DimenConstants.layoutPadding),
              child: Column(
                children: [
                  _buildPassengerCounter(),
                  const SizedBox(height: DimenConstants.contentPadding),
                  _buildTotalFareDisplay(),
                  const SizedBox(height: DimenConstants.contentPadding),
                  _buildCreditCardInput(),
                ],
              ),
            ),
          );
  }

  Widget _buildPassengerCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCounterButton(Icons.remove, _controller.onTapSubtract),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DimenConstants.mixPadding),
          child: Obx(() => Text(
                '${_controller.passengerCount}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              )),
        ),
        _buildCounterButton(Icons.add, _controller.onTapAdd),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(DimenConstants.contentPadding),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildTotalFareDisplay() {
    return Obx(() => Text(
          'Total: ${_controller.symbol}${_controller.totalBookingFarePrice.value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildCreditCardInput() {
    return CreditCardWidget(
      cardNumber: _controller.cardNumber.value,
      expiryDate: _controller.expiryDate.value,
      cardHolderName: _controller.cardHolderName.value,
      cvvCode: _controller.cvvCode.value,
      showBackView: _controller.isCvvFocussed.value,
      onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
      // Add other styling and configurations as needed
    );
  }

  Widget _buildBottomButton() {
    return Visibility(
      visible: _controller.ticketArg.value != null,
      child: CustomButton(
        isWrapContent: true,
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        buttonText: "Pay",
        onButtonPressed: _controller.onPressButtonBookTickets,
      ),
    );
  }
}
