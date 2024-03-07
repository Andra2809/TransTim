import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/home_controller.dart';
import '../utility/common_widgets/custom_object_drop_down.dart';
import '../utility/common_widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      isBottomBarVisible: true,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          _actionWidget(),
          _themeToggleWidget(context), // Theme toggle button
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Get Details'),
        icon: const Icon(Icons.directions_outlined),
        onPressed: _controller.onPressGetDetails,
      ),
      body: Obx(() => Stack(
            children: [
              _googleMap(),
              Visibility(
                visible: _controller.isSelectLocationVisible.value,
                child: SingleChildScrollView(child: _textFields()),
              ),
              if (_controller.isMapLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          )),
    );
  }

  Widget _actionWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: DimenConstants.mixPadding),
      child: InkWell(
        onTap: _controller.onTapActionBarIcon,
        child: const Icon(Icons.directions_outlined),
      ),
    );
  }

  Widget _themeToggleWidget(BuildContext context) {
    // This widget allows users to toggle between light and dark themes.
    return IconButton(
      icon: const Icon(Icons.brightness_6),
      onPressed: () {
        Get.isDarkMode ? Get.changeTheme(ThemeData.light()) : Get.changeTheme(ThemeData.dark());
      },
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      mapToolbarEnabled: true,
      trafficEnabled: true,
      compassEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(_controller.markerList),
      polylines: Set<Polyline>.of(_controller.polylineList),
      initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
      onMapCreated: _controller.onMapCreated,
    );
  }

  Widget _textFields() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _locationRow("Start Location", false),
          _locationRow("Destination", true),
          CustomObjectDropDown<String>(
            hintText: 'Select Mode',
            prefixIcon: Icons.type_specimen_outlined,
            objectList: _controller.modeTypeList,
            selected: _controller.selectedModeType,
            displayTextFunction: (p0) => p0 ?? '',
            objectsEqualFunction: (p0, p1) => p0 == p1,
            onChanged: _controller.onModeTypeChange,
          ),
          Visibility(
            visible: false, // Keeping for potential future use
            child: _transitModeList(),
          ),
          _directionsText(),
        ],
      ),
    );
  }

  Widget _locationRow(String hintText, bool isDestination) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: hintText,
            prefixIcon: isDestination ? Icons.edit_location_alt_outlined : Icons.location_searching_outlined,
            textEditingController: isDestination ? _controller.etDestinationLocation : _controller.etStartLocation,
            onTapField: () => _controller.onTapSearchCity(isDestination: isDestination),
          ),
        ),
        _selectHomeOrAddressWidget(isDestination: isDestination),
      ],
    );
  }

  Widget _selectHomeOrAddressWidget({bool? isDestination}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconButton(Icons.home_outlined, () => _controller.onTapHomeAddress(isDestination: isDestination)),
        _iconButton(Icons.work_outline, () => _controller.onTapWorkAddress(isDestination: isDestination)),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(DimenConstants.smallContentPadding),
        child: Icon(icon),
      ),
    );
  }

  Widget _transitModeList() {
    // Existing implementation...
  }

  Widget _directionsText() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Text(
        '* Click on direction icon on top right to hide/show this window',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: Get.textTheme.bodyMedium?.fontSize,
        ),
      ),
    );
  }
}
