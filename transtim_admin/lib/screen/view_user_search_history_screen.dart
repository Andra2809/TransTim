import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_data_holder.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/view_user_search_history_controller.dart';
import '../model/search_history.dart';
import '../utility/common_widgets/common_scaffold.dart';

class ViewUserSearchHistoryScreen extends StatelessWidget {
  ViewUserSearchHistoryScreen({super.key});

  final ViewUserSearchHistoryController _controller =
      Get.put(ViewUserSearchHistoryController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      isBottomBarVisible: true,
      appBar: AppBar(
        title: const Text("Search History"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: CommonDataHolder(
              controller: _controller,
              dataList: _controller.searchHistoryList,
              widget: _dataHolderWidget(),
              noResultText: "No Search History found",
              onRefresh: () => _controller.fetchSearchHistory(),
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
        itemCount: _controller.searchHistoryList.length,
        itemBuilder: (context, index) {
          return _recentSearchHistoryCard(_controller.searchHistoryList[index]);
        },
      ),
    );
  }

  Widget _recentSearchHistoryCard(SearchHistory history) {
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
                    "Date: ${history.dateTime ?? "--"}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    "Start Location : ${history.startLocation ?? "--"}",
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    "Destination : ${history.endLocation ?? 0}",
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text("Mode : ${history.mode ?? 0}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
