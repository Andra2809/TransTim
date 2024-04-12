import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/common_widgets/common_dialog.dart';
import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/common_widgets/custom_button.dart';
import '../../utility/common_widgets/hidden_text_field.dart';
import '../../utility/constants/dimens_constants.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  final ChangePasswordController _controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SafeArea(child: _passwordChangeForm()),
    );
  }

  Widget _passwordChangeForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _passwordDetailsCard(),
        ],
      ),
    );
  }

  Widget _passwordDetailsCard() {
    return Card(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      elevation: DimenConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimenConstants.mainCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DimenConstants.layoutPadding),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              _oldPasswordField(),
              _newPasswordField(),
              _confirmNewPasswordField(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _oldPasswordField() {
    return CustomHiddenTextField(
      textEditingController: _controller.etOldPassword,
      hintText: "Old Password",
      prefixIcon: Icons.key_outlined,
      currentFocusNode: _controller.etOldPasswordFocusNode,
      nextFocusNode: _controller.etNewPasswordFocusNode,
      validatorFunction: _controller.validateOldPassword,
    );
  }

  Widget _newPasswordField() {
    return CustomHiddenTextField(
      textEditingController: _controller.etNewPassword,
      hintText: "New Password",
      prefixIcon: Icons.password_outlined,
      currentFocusNode: _controller.etNewPasswordFocusNode,
      nextFocusNode: _controller.etConfirmNewPasswordFocusNode,
      validatorFunction: _controller.validateNewPassword,
    );
  }

  Widget _confirmNewPasswordField() {
    return CustomHiddenTextField(
      textEditingController: _controller.etConfirmNewPassword,
      hintText: "Confirm New Password",
      prefixIcon: Icons.password_outlined,
      isObscureTextIconDisabled: true,
      currentFocusNode: _controller.etConfirmNewPasswordFocusNode,
      validatorFunction: _controller.validateConfirmPassword,
    );
  }

  Widget _submitButton() {
    return CustomButton(
      buttonText: "Submit",
      padding: const EdgeInsets.symmetric(vertical: DimenConstants.contentPadding),
      onButtonPressed: () => _controller.submitPasswordChange(),
    );
  }
}
