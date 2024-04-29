import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/home_controller.dart';
import '../utility/common_widgets/custom_object_drop_down.dart';
import '../utility/common_widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      isBottomBarVisible: true,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [_actionWidget()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Get Details'),
        icon: const Icon(Icons.directions_outlined),
        onPressed: () => _controller.onPressGetDetails(),
      ),
      body: Obx(
        () => Stack(
          children: [
            _googleMap(),
            Visibility(
              visible: _controller.isSelectLocationVisible.value,
              child: SingleChildScrollView(child: _textFields()),
            ),
            _controller.isMapLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: DimenConstants.mixPadding),
      child: InkWell(
        onTap: () => _controller.onTapActionBarIcon(),
        child: const Icon(Icons.directions_outlined),
      ),
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
      onMapCreated: (GoogleMapController googleMapController) {
        _controller.onMapCreated(googleMapController);
      },
    );
  }

  Widget _textFields() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "Start Location",
                  prefixIcon: Icons.location_searching_outlined,
                  textEditingController: _controller.etStartLocation,
                  onTapField: () => _controller.onTapSearchCity(),
                  onTapPrefixIcon: () => _controller.onTapStartLocPrefixIcon(),
                ),
              ),
              _selectHomeOrAddressWidget(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "Destination",
                  prefixIcon: Icons.edit_location_alt_outlined,
                  textEditingController: _controller.etDestinationLocation,
                  onTapField: () {
                    _controller.onTapSearchCity(isDestination: true);
                  },
                ),
              ),
              _selectHomeOrAddressWidget(isDestination: true),
            ],
          ),
          CustomObjectDropDown<String>(
            hintText: 'Select Mode',
            prefixIcon: Icons.type_specimen_outlined,
            objectList: _controller.modeTypeList,
            selected: _controller.selectedModeType,
            displayTextFunction: (p0) => p0,
            objectsEqualFunction: (p0, p1) => p0 == p1,
            onChanged: (p0) => _controller.onModeTypeChange(type: p0),
          ),
          Visibility(
            visible: false,
            child: _transitModeList(),
          ),
          Padding(
            padding: const EdgeInsets.all(DimenConstants.contentPadding),
            child: Text(
              '* Click on direction icon on top right to hide/show this window',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: Get.textTheme.bodyMedium?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectHomeOrAddressWidget({bool? isDestination}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _controller.onTapHomeAddress(isDestination: isDestination);
          },
          child: const Padding(
            padding: EdgeInsets.all(DimenConstants.smallContentPadding),
            child: Icon(Icons.home_outlined),
          ),
        ),
        InkWell(
          onTap: () {
            _controller.onTapWorkAddress(isDestination: isDestination);
          },
          child: const Padding(
            padding: EdgeInsets.all(DimenConstants.smallContentPadding),
            child: Icon(Icons.work_outline),
          ),
        ),
      ],
    );
  }

  Widget _transitModeList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(DimenConstants.contentPadding),
          child: Text(
            'Transit modes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(DimenConstants.contentPadding),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.transitModeList.length,
            itemBuilder: (context, index) {
              String transit = _controller.transitModeList[index];
              return Row(
                children: [
                  Checkbox(
                    value: _controller.selectedTransitList.contains(transit),
                    onChanged: (value) {
                      _controller.onChangeTransitCheckBox(transit: transit);
                    },
                  ),
                  Expanded(child: Text(transit)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
