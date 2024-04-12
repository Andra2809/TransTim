import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/dimens_constants.dart';
import '../constants/string_constants.dart';

class CommonDataHolder extends StatelessWidget {
  final Widget widget;
  final RxList dataList;
  final dynamic controller;

  final Axis? scrollDirection;
  final String? noResultText;
  final bool? showNoResultFound, isRefreshEnabled;
  final Future<void> Function()? onRefresh;

  const CommonDataHolder({
    super.key,
    required this.controller,
    required this.dataList,
    required this.widget,
    this.noResultText,
    this.onRefresh,
    this.scrollDirection,
    this.showNoResultFound,
    this.isRefreshEnabled,
  });

  @override
  Widget build(BuildContext context) {
    if (isRefreshEnabled != null) {
      if (isRefreshEnabled! == false) {
        return _body();
      } else {
        return _onRefreshBody();
      }
    } else {
      return _onRefreshBody();
    }
  }

  Widget _onRefreshBody() {
    return SizedBox(
      height: Get.height,
      child: Center(
        child: RefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[Center(child: _body())],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    try {
      return Obx(
        () {
          if (controller.isLoading.value) {
            return SizedBox(
              height: Get.height / 1.5,
              child: Center(
                child: SizedBox(
                  height: Get.mediaQuery.size.height / 5,
                  child: Lottie.asset(
                    StringConstants.loadingLottie,
                    repeat: true,
                    errorBuilder: (context, error, stackTrace) {
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            );
          } else {
            if (dataList.isNotEmpty) {
              return widget;
            } else {
              if (showNoResultFound != null) {
                if (showNoResultFound! == true) {
                  return CustomNoResultScreen(noResultText: noResultText);
                } else {
                  return SizedBox(
                    height: Get.height,
                    child: widget,
                  );
                }
              } else {
                return CustomNoResultScreen(noResultText: noResultText);
              }
            }
          }
        },
      );
    } catch (e) {
      if (showNoResultFound != null) {
        if (showNoResultFound == false) {
          return SizedBox(
            height: Get.height,
            child: widget,
          );
        }
      }
      return CustomNoResultScreen(noResultText: noResultText);
    }
  }
}

class CustomNoResultScreen extends StatelessWidget {
  const CustomNoResultScreen({super.key, this.noResultText});
  final String? noResultText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height / 1.3,
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            verticalDirection: VerticalDirection.down,
            direction: Axis.vertical,
            spacing: DimenConstants.layoutPadding,
            runSpacing: DimenConstants.contentPadding,
            children: [
              Lottie.asset(
                StringConstants.noResultLottie,
                repeat: true,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.not_interested_outlined,
                    size: Get.width * .2,
                  );
                },
              ),
              Text(
                noResultText ?? "No Result Found",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
