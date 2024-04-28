import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:trans_tim_admin/model/rating.dart';

import '../controller/view_ratings_controller.dart';
import '../utility/common_widgets/common_data_holder.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/constants/dimens_constants.dart';

class ViewRatingsScreen extends StatelessWidget {
  ViewRatingsScreen({super.key});

  final ViewRatingsController _controller = Get.put(ViewRatingsController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      isBottomBarVisible: true,
      appBar: AppBar(
        title: const Text("Ratings"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: Column(
              children: [
                _averageRatingCount(),
                Expanded(
                  child: CommonDataHolder(
                    controller: _controller,
                    dataList: _controller.ratingList,
                    widget: _dataHolderWidget(),
                    noResultText: "No Ratings found",
                    onRefresh: () => _controller.fetchRatings(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _averageRatingCount() {
    double averageRating = _calculateAverageRating();
    return Visibility(
      visible: _controller.ratingList.isNotEmpty,
      child: Card(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        elevation: DimenConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.cardRadius),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: Get.width),
          padding: const EdgeInsets.all(DimenConstants.layoutPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 64),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: DimenConstants.contentPadding,
                  ),
                  child: Column(
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: Get.textTheme.titleLarge?.fontSize,
                        ),
                      ),
                      const Text("Average Rating"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateAverageRating() {
    if (_controller.ratingList.isEmpty) {
      return 0.0;
    }
    double sum = 0.0;
    for (final rating in _controller.ratingList) {
      double ratingValue = double.tryParse(rating.ratingCount ?? '0') ?? 0.0;
      sum += ratingValue;
    }
    return sum / _controller.ratingList.length;
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _controller.ratingList.length,
        itemBuilder: (context, index) {
          return _ratingCard(rating: _controller.ratingList[index]);
        },
      ),
    );
  }

  Widget _ratingCard({required Rating rating}) {
    double ratingCount = double.tryParse(rating.ratingCount ?? "") ?? 0;
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Card(
        elevation: DimenConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.cardRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DimenConstants.contentPadding,
            horizontal: DimenConstants.layoutPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  rating.fullName ?? "--",
                  style: TextStyle(
                    fontSize: Get.textTheme.titleMedium?.fontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: RatingBar.builder(
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemSize: 18,
                  itemCount: 5,
                  initialRating: ratingCount,
                  itemPadding: const EdgeInsets.symmetric(
                    horizontal: DimenConstants.smallPadding,
                  ),
                  itemBuilder: (context, _) {
                    return const Icon(Icons.star, color: Colors.amber);
                  },
                  onRatingUpdate: (double value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
