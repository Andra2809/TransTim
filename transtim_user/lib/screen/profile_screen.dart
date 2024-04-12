import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/common_widgets/custom_button.dart';
import '../../utility/common_widgets/custom_text_field.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Obx(
      () {
        return CommonScaffold(
          isBottomBarVisible: true,
          isLoginCompulsory: true,
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [_actionWidget()],
          ),
          body: Center(child: _body()),
        );
      },
    );
  }

  Widget _actionWidget() {
    return Row(
      children: [
        Visibility(
          visible: !_controller.isEditingEnabled.value &&
              _controller.isUserLoggedIn.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimenConstants.contentPadding,
            ),
            child: InkWell(
              onTap: () => _controller.onPressEditIcon(),
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _controller.isUserLoggedIn.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimenConstants.contentPadding,
            ),
            child: InkWell(
              onTap: () => _controller.onPressLogoutIcon(),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_textFields(), _addressFields(), _button()],
        ),
      ),
    );
  }

  Widget _textFields() {
    return Obx(
      () {
        return Form(
          key: _controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                textEditingController: _controller.etName,
                hintText: "Full Name",
                prefixIcon: Icons.edit_outlined,
                currentFocusNode: _controller.etNameFocusNode,
                readOnly: !_controller.isEditingEnabled.value,
                validatorFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Full Name Cannot Be Empty';
                  }
                  return null;
                },
              ),
              CustomTextField(
                textEditingController: _controller.etEmailId,
                hintText: "Email Id",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                suffixIcon: Icons.check_circle,
                suffixIconColor: Colors.green,
                readOnly: true,
                validatorFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Email Cannot Be Empty';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Enter Valid Email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                textEditingController: _controller.etContactNumber,
                hintText: "Contact Number",
                prefixIcon: Icons.call_outlined,
                currentFocusNode: _controller.etContactNumberFocusNode,
                validatorFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Contact Number Cannot Be Empty';
                  }
                  if (!GetUtils.isPhoneNumber(value)) {
                    return 'Enter Valid Contact Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: DimenConstants.contentPadding),
            ],
          ),
        );
      },
    );
  }

  Widget _addressFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Obx(() {
          return Column(
            children: [
              _addressFieldWidget(
                icon: Icons.home_outlined,
                title: 'Home',
                address: _controller.homeAddress.value,
              ),
              const Divider(),
              _addressFieldWidget(
                icon: Icons.work_outline,
                title: 'Work',
                address: _controller.workAddress.value,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _button() {
    return Column(
      children: [
        CustomButton(
          buttonText: "Submit",
          onButtonPressed: () => _controller.onPressButtonSubmit(),
        ),
        InkWell(
          onTap: () => _controller.onTapChangePassword(),
          child: const Padding(
            padding: EdgeInsets.all(DimenConstants.layoutPadding),
            child: Text(
              'CHANGE PASSWORD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _addressFieldWidget({
    required IconData icon,
    required String title,
    required String? address,
  }) {
    address = address ?? '';
    address = address.trim().isNotEmpty ? address : 'Tap to set';
    return InkWell(
      onTap: () => _controller.onTapAddress(addressType: title),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(DimenConstants.contentPadding),
            child: Icon(icon),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DimenConstants.contentPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Get.textTheme.titleMedium?.fontSize,
                    ),
                  ),
                  Text(address),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(DimenConstants.contentPadding),
            child: Icon(Icons.arrow_forward_ios_outlined, size: 12),
          ),
        ],
      ),
    );
  }
}
