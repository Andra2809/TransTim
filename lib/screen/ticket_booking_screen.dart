import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import '../controller/ticket_booking_controller.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/constants/dimens_constants.dart';

class TicketBookingScreen extends StatelessWidget {
  TicketBookingScreen({super.key});

  final TicketBookingController _controller =
      Get.put(TicketBookingController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      appBar: AppBar(title: const Text('Ticket Booking')),
      body: Obx(() => _body()),
      isBottomBarVisible: true,
      isLoginCompulsory: true,
      bottomNavigationBar: _bottomButton(),
    );
  }

  Widget _bottomButton() {
    return Obx(
      () {
        return Visibility(
          visible: _controller.ticketArg.value != null,
          child: CustomButton(
            isWrapContent: true,
            margin: const EdgeInsets.all(DimenConstants.contentPadding),
            buttonText: "Pay",
            onButtonPressed: () => _controller.onPressButtonBookTickets(),
          ),
        );
      },
    );
  }

  Widget _body() {
    if (_controller.ticketArg.value == null) {
      return const Center(child: Text('No Booking available'));
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(DimenConstants.layoutPadding),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _passengerCount(),
                  _totalFareCount(),
                  _fakeCardWidget(),
                ],
              );
            }),
          ),
        ),
      );
    }
  }

  Widget _passengerCount() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Passenger: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.bodyLarge?.fontSize,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Get.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(DimenConstants.contentPadding),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DimenConstants.contentPadding),
                    bottomLeft: Radius.circular(DimenConstants.contentPadding),
                  ),
                ),
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: InkWell(
                  onTap: () => _controller.onTapSubtract(),
                  child: Icon(
                    Icons.remove_outlined,
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DimenConstants.contentPadding,
                  horizontal: DimenConstants.mixPadding,
                ),
                child: Text(
                  '${_controller.passengerCount.value}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.textTheme.titleMedium?.fontSize,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(DimenConstants.contentPadding),
                    bottomRight: Radius.circular(DimenConstants.contentPadding),
                  ),
                ),
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: InkWell(
                  onTap: () => _controller.onTapAdd(),
                  child: Icon(
                    Icons.add_outlined,
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalFareCount() {
    return Padding(
      padding: const EdgeInsets.only(
        top: DimenConstants.contentPadding,
        bottom: DimenConstants.contentPadding,
        right: DimenConstants.contentPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Total: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Get.textTheme.bodyLarge?.fontSize,
              ),
            ),
          ),
          Text(
            '${_controller.symbol} ${_controller.totalBookingFarePrice.value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.bodyLarge?.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fakeCardWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        CreditCardWidget(
          height: 200,
          cardNumber: _controller.cardNumber.value,
          expiryDate: _controller.expiryDate.value,
          cardHolderName: _controller.cardHolderName.value,
          cvvCode: _controller.cvvCode.value,
          labelValidThru: 'VALID\nTHRU',
          obscureCardNumber: true,
          obscureInitialCardNumber: false,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          isSwipeGestureEnabled: true,
          showBackView: _controller.isCvvFocussed.value,
          bankName: " ",
          cardBgColor: Colors.black,
          padding: DimenConstants.mixPadding,
          animationDuration: const Duration(milliseconds: 1000),
          frontCardBorder: Border.all(color: Colors.black),
          backCardBorder: Border.all(color: Colors.black),
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
          glassmorphismConfig: Glassmorphism(
            blurX: 7.0,
            blurY: 10.0,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.black.withOpacity(1),
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(1),
              ],
              stops: const <double>[0.6, 0.3, 0],
            ),
          ),
        ),
        CreditCardForm(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          formKey: _controller.formKey,
          obscureCvv: true,
          obscureNumber: true,
          cardNumber: _controller.cardNumber.value,
          cvvCode: _controller.cvvCode.value,
          cardHolderName: _controller.cardHolderName.value,
          expiryDate: _controller.expiryDate.value,
          onCreditCardModelChange: (CreditCardModel creditCardModel) {
            _controller.onCreditCardModelChange(
              creditCardModel: creditCardModel,
            );
          },
        ),
      ],
    );
  }
}
