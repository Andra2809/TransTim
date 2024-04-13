import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../model/user_master.dart';
import '../utility/common_widgets/common_data_holder.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/constants/dimens_constants.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      isBottomBarVisible: true,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height),
            child: CommonDataHolder(
              controller: _controller,
              dataList: _controller.userList,
              widget: _dataHolderWidget(),
              noResultText: "No User found",
              onRefresh: () => _controller.fetchUser(),
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
        itemCount: _controller.userList.length,
        itemBuilder: (context, index) {
          return _userCard(user: _controller.userList[index]);
        },
      ),
    );
  }

  Widget _userCard({required UserMaster user}) {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: InkWell(
        onTap: () => _controller.onTapUserCard(user: user),
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
                      user.fullName ?? "--",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: DimenConstants.contentPadding),
                    Text("Email Id: ${user.emailId ?? "--"}"),
                    const SizedBox(height: DimenConstants.contentPadding),
                    Text("Contact Number : ${user.contactNumber ?? "--"}"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onPrimary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(DimenConstants.cardRadius),
                    bottomRight: Radius.circular(DimenConstants.cardRadius),
                  ),
                ),
                child: const Center(
                  child: Text('🔍 Tap to view search history'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
