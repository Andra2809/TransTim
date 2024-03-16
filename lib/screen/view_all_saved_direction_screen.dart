import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_data_holder.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/view_all_saved_direction_controller.dart';
import '../model/saved_direction.dart';
import '../utility/common_widgets/common_scaffold.dart';

class ViewAllSavedDirectionScreen extends StatelessWidget {
  ViewAllSavedDirectionScreen({super.key});

  final ViewAllSavedDirectionController _controller =
      Get.put(ViewAllSavedDirectionController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      isBottomBarVisible: true,
      isLoginCompulsory: true,
      appBar: AppBar(
        title: const Text("Saved Directions"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: CommonDataHolder(
              controller: _controller,
              dataList: _controller.savedDirectionList,
              widget: _dataHolderWidget(),
              noResultText: "No Saved Direction found",
              onRefresh: () => _controller.fetchSavedDirection(),
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
        itemCount: _controller.savedDirectionList.length,
        itemBuilder: (context, index) {
          return _recentSavedDirectionCard(
              _controller.savedDirectionList[index]);
        },
      ),
    );
  }

  Widget _recentSavedDirectionCard(SavedDirection savedDirection) {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: InkWell(
        onTap: () => _controller.onTapSavedDirectionCard(
          savedDirection: savedDirection,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(DimenConstants.cardRadius),
        ),
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
                      "Date: ${savedDirection.dateTime ?? "--"}",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: DimenConstants.contentPadding),
                    Text(
                      "Start Location : ${savedDirection.startLocation ?? "--"}",
                    ),
                    const SizedBox(height: DimenConstants.contentPadding),
                    Text(
                      "Destination : ${savedDirection.endLocation ?? 0}",
                    ),
                    const SizedBox(height: DimenConstants.contentPadding),
                    Text("Mode : ${savedDirection.mode ?? 0}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
