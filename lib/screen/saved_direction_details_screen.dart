import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/saved_direction_details_controller.dart';
import '../utility/common_widgets/custom_object_drop_down.dart';
import '../utility/common_widgets/custom_text_field.dart';

class SavedDirectionDetailsScreen extends StatelessWidget {
  SavedDirectionDetailsScreen({super.key});

  final SavedDirectionDetailsController _controller =
      Get.put(SavedDirectionDetailsController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Direction Details"),
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
            _controller.isMapLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Container(),
            _googleMap(),
            Visibility(
              visible: _controller.isSelectLocationVisible.value,
              child: SingleChildScrollView(child: _textFields()),
            ),
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
          CustomTextField(
            hintText: "Start Location",
            prefixIcon: Icons.location_searching_outlined,
            textEditingController: _controller.etStartLocation,
            readOnly: true,
          ),
          CustomTextField(
            hintText: "Destination",
            prefixIcon: Icons.edit_location_alt_outlined,
            textEditingController: _controller.etDestinationLocation,
            readOnly: true,
          ),
          CustomObjectDropDown<String>(
            hintText: 'Select Mode',
            prefixIcon: Icons.type_specimen_outlined,
            objectList: _controller.modeTypeList,
            selected: _controller.selectedModeType,
            displayTextFunction: (p0) => p0,
            objectsEqualFunction: (p0, p1) => p0 == p1,
            isReadOnly: true,
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
                    onChanged: (bool? value) {},
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
