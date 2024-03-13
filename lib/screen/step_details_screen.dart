import 'dart:math';
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
  StepDetailsScreen({Key? key}) : super(key: key);

  final StepDetailsController _controller = Get.put(StepDetailsController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(title: const Text('Route Steps')),
      body: _body(),
      isBottomBarVisible: true,
      bottomNavigationBar: Obx(() {
        return _controller.routeStepList.isEmpty ? const SizedBox.shrink() : _boltServiceCard();
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
                  _totalStepCard(routeStep: _controller.totalRouteStepArg.value),
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
    return Obx(() {
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
    });
  }

  Widget _boltServiceCard() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.mixPadding),
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
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    "${_controller.totalDuration} |${_controller.getArrivalTime()}",
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Image.asset(StringConstants.boltLogo, height: 34),
                  const SizedBox(height: DimenConstants.contentPadding),
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
            final backgroundColor = name.isNotEmpty ? _getRandomColor() : null;

            return Row(
              children: [
                _getModeIcon(false, element),
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
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: ListTile(
          leading: _getModeIcon(true, routeStep),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: routeStep?.startTime != null,
                child: Text(
                  "${routeStep?.startTime} -- ${routeStep?.endTime}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.textTheme.titleSmall?.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: DimenConstants.contentPadding),
              HtmlWidget(routeStep?.instructions ?? ""),
              const SizedBox(height: DimenConstants.contentPadding),
              Text(_getModeDescription(routeStep)),
              Text("Distance: ${routeStep?.distance ?? ""}"),
              Text("Duration: ${routeStep?.duration ?? ""}"),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getModeIcon(bool? enableInstructionsIcon, RouteStep? routeStep) {
    String? transitMode = routeStep?.transitMode;
    String? travelMode = routeStep?.travelMode;
    String? vehicleMode = routeStep?.vehicleMode;
    String instructions =
        enableInstructionsIcon == true && routeStep?.instructions != null
            ? routeStep?.instructions ?? ''
            : '';
    if (_containsTurn(instructions, 'left')) {
      return const Icon(Icons.turn_left_outlined);
    } else if (_containsTurn(instructions, 'right')) {
      return const Icon(Icons.turn_right_outlined);
    } else if (_containsTurn(instructions, 'north')) {
      return const Icon(Icons.north);
    } else if (_containsTurn(instructions, 'south')) {
      return const Icon(Icons.south);
    } else if (_containsTurn(instructions, 'east')) {
      return const Icon(Icons.east);
    } else if (_containsTurn(instructions, 'west')) {
      return const Icon(Icons.west);
    } else if (_containsTurn(instructions, 'northwest')) {
      return const Icon(Icons.north_west);
    } else if (_containsTurn(instructions, 'northeast')) {
      return const Icon(Icons.north_east);
    } else if (_containsTurn(instructions, 'southwest')) {
      return const Icon(Icons.south_west);
    } else if (_containsTurn(instructions, 'southeast')) {
      return const Icon(Icons.south_east);
    } else if (transitMode != null) {
      switch (transitMode.toLowerCase()) {
        case 'bus':
          return const Icon(Icons.directions_bus_filled_outlined);
        case 'subway':
          return const Icon(Icons.subway_outlined);
        case 'train':
          return const Icon(Icons.train_outlined);
        case 'tram':
          return const Icon(Icons.tram_outlined);
        default:
          return const Icon(Icons.directions_transit);
      }
    } else if (travelMode != null) {
      switch (travelMode.toLowerCase()) {
        case 'driving':
          return const Icon(Icons.directions_car_outlined);
        case 'transit':
          return const Icon(Icons.directions_transit);
        case 'walking':
          return const Icon(Icons.directions_walk_outlined);
        case 'bicycling':
          return const Icon(Icons.directions_bike_rounded);
        default:
          return const Icon(Icons.directions_car_outlined);
      }
    } else if (vehicleMode != null) {
      switch (vehicleMode.toLowerCase()) {
        case 'car':
          return const Icon(Icons.directions_car_outlined);
        case 'bike':
          return const Icon(Icons.electric_bike_outlined);
        case 'cycling':
          return const Icon(Icons.directions_bike_outlined);
        default:
          return const Icon(Icons.directions_car_outlined);
      }
    } else {
      return const Icon(Icons.directions_car_outlined);
    }
  }

  bool _containsTurn(String instructions, String turn) {
    return instructions.toLowerCase().contains(turn.toLowerCase());
  }

  String _getModeDescription(RouteStep? routeStep) {
    if (routeStep?.transitMode != null) {
      return 'Transit Mode: ${routeStep?.transitMode}';
    } else if (routeStep?.vehicleMode != null) {
      return 'Vehicle Mode: ${routeStep?.vehicleMode}';
    } else {
      return 'Travel Mode: ${routeStep?.travelMode ?? ""}';
    }
  }

  Color _getRandomColor() {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
