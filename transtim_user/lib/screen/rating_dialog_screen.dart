import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:trans_tim/controller/rating_dialog_controller.dart';

import '../utility/common_widgets/common_scaffold.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/constants/string_constants.dart';

class RatingDialogScreen extends StatelessWidget {
  RatingDialogScreen({super.key});

  final RatingDialogController _controller = Get.put(RatingDialogController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(DimenConstants.contentPadding),
            child: Image.asset(StringConstants.logo, height: 64),
          ),
          content: _content(),
          actions: _actions(),
        );
      }),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Column(
        children: [
          Text(
            'Enjoying ${StringConstants.appName}?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.titleLarge?.fontSize,
            ),
          ),
          Text(
            'Tap to rate it',
            style: TextStyle(
              fontSize: Get.textTheme.titleMedium?.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _actions() {
    return [
      Container(
        constraints: BoxConstraints(minWidth: Get.width),
        child: CupertinoDialogAction(
          isDefaultAction: true,
          child: RatingBar.builder(
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemSize: 24,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(
              horizontal: DimenConstants.smallContentPadding,
            ),
            itemBuilder: (context, _) {
              return const Icon(Icons.star, color: Colors.amber);
            },
            onRatingUpdate: (value) {
              _controller.onRatingUpdate(ratingValue: value);
            },
          ),
        ),
      ),
      Visibility(
        visible: _controller.ratingCount.value > 0,
        child: CupertinoDialogAction(
          isDefaultAction: true,
          child: InkWell(
            onTap: () => _controller.onTapSubmit(),
            child: const Text('Submit'),
          ),
        ),
      ),
      CupertinoDialogAction(
        child: InkWell(
          onTap: () => _controller.onTapNotNow(),
          child: Text(
            'Not Now',
            style: TextStyle(
              color: _controller.ratingCount.value > 0 ? Colors.red : null,
            ),
          ),
        ),
      ),
    ];
  }
}
