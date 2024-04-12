import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../controller/step_details_controller.dart';
import '../model/route_step.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/constants/string_constants.dart';

class StepDetailsScreen extends StatelessWidget {
  StepDetailsScreen({super.key});

  final StepDetailsController _controller = Get.put(StepDetailsController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(title: const Text('Route Steps')),
      body: _body(),
      isBottomBarVisible: true,
      bottomNavigationBar: Obx(() {
        return _controller.routeStepList.isEmpty
            ? const SizedBox.shrink()
            : _boltServiceCard();
      }),
    );
  }

  Widget _body() {
    if (_controller.routeStepList.isEmpty) {
      return const Center(child: Text('No routes available'));
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              margin: const EdgeInsets.all(DimenConstants.contentPadding),
              child: Column(
                children: [
                  Visibility(
                    visible: _controller.isTransitModeSelected.value,
                    child: _stepIcons(),
                  ),
                  _totalStepCard(
                    routeStep: _controller.totalRouteStepArg.value,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.routeStepList.length,
              itemBuilder: (context, index) {
                RouteStep? routeStep = _controller.routeStepList[index];
                return _showStepsDetails(routeStep: routeStep);
              },
            ),
            _bottomButton(),
          ],
        ),
      );
    }
  }

  Widget _bottomButton() {
    return Obx(
      () {
        return Row(
          children: [
            Visibility(
              visible: _controller.savedDirectionArg.value != null,
              child: Expanded(
                child: CustomButton(
                  isWrapContent: true,
                  margin: const EdgeInsets.all(DimenConstants.contentPadding),
                  buttonText: "Save Direction",
                  onButtonPressed: () {
                    _controller.onPressButtonSaveDirection();
                  },
                ),
              ),
            ),
            Visibility(
              visible: _controller.isTransitModeSelected.value,
              child: Expanded(
                child: CustomButton(
                  isWrapContent: true,
                  margin: const EdgeInsets.all(DimenConstants.contentPadding),
                  buttonText: "Buy Tickets",
                  onButtonPressed: () => _controller.onPressButtonBookTickets(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _boltServiceCard() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Ride service (Fastest)'),
                  Text(
                    "${_controller.totalDuration} |${_controller.getArrivalTime()}",
                  ),
                  Image.asset(StringConstants.boltLogo, height: 24),
                  const Text('Pickup in 3 min'),
                ],
              ),
            ),
            CustomButton(
              buttonText: 'Order',
              isWrapContent: true,
              width: Get.width * .25,
              foreGroundColor: Colors.lightGreen,
              primaryColor: Colors.lightGreen,
              buttonColor: Colors.lightGreen,
              textColor: Colors.white,
              onButtonPressed: () => _controller.onTapOrderBoltService(),
            )
          ],
        ),
      ),
    );
  }

  Widget _stepIcons() {
    return Container(
      constraints: BoxConstraints(minWidth: Get.width),
      margin: const EdgeInsets.only(top: DimenConstants.layoutPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: DimenConstants.layoutPadding,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _controller.routeStepList.map((element) {
            String? name = element.shortName?.trim();
            name = name != null && name.isNotEmpty ? " $name " : '';
            final backgroundColor = name.isNotEmpty
                ? _controller.getTransitColor(transitMode: element.transitMode)
                : null;

            return Row(
              children: [
                _controller.getModeIcon(false, element),
                Container(
                  color: backgroundColor,
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey,
                  size: 12,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _totalStepCard({required RouteStep? routeStep}) {
    return Container(
      constraints: BoxConstraints(minWidth: Get.width),
      padding: const EdgeInsets.symmetric(
        horizontal: DimenConstants.layoutPadding,
        vertical: DimenConstants.mixPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Arrival: ${routeStep?.arrivalStopName ?? ""}"),
          Text("Departure: ${routeStep?.departureStopName ?? ""}"),
          const SizedBox(height: DimenConstants.contentPadding),
          Text("Total Distance: ${routeStep?.totalDistance ?? ""}"),
          Text("Estimate Duration: ${routeStep?.totalDuration ?? ""}"),
        ],
      ),
    );
  }

  Widget _showStepsDetails({required RouteStep? routeStep}) {
    Color? bgCardColor = _controller.getTransitColor(
      transitMode: routeStep?.transitMode,
    );
    Color? textColor = bgCardColor != null ? Colors.white : null;
    String? name = routeStep?.shortName?.trim();
    name = name != null && name.isNotEmpty ? " $name " : '';
    return Card(
      color: bgCardColor,
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: ListTile(
          leading: Column(
            children: [
              _controller.getModeIcon(true, routeStep),
              Container(
                color: bgCardColor,
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: routeStep?.startTime != null,
                child: Text(
                  "${routeStep?.startTime} -- ${routeStep?.endTime}",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.textTheme.titleSmall?.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: DimenConstants.contentPadding),
              HtmlWidget(
                routeStep?.instructions ?? "",
                textStyle: TextStyle(color: textColor),
              ),
              const SizedBox(height: DimenConstants.contentPadding),
              Text(
                _controller.getModeDescription(routeStep),
                style: TextStyle(color: textColor),
              ),
              Text(
                "Distance: ${routeStep?.distance ?? ""}",
                style: TextStyle(color: textColor),
              ),
              Text(
                "Duration: ${routeStep?.duration ?? ""}",
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
