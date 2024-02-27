import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/registration_controller.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/common_widgets/hidden_text_field.dart';
import '../utility/constants/dimens_constants.dart';

// Defines the Registration Screen widget.
class RegistrationScreen extends StatelessWidget {
  // Instantiates the RegistrationController using GetX for state management.
  final RegistrationController _controller = Get.put(RegistrationController());

  // Constructor with an optional Key parameter.
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Common scaffold for consistent UI across the app.
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  // Builds the body of the registration screen.
  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _textFields(),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Creates text fields for user input.
  Widget _textFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          textEditingController: _controller.etName,
          hintText: "Name",
          prefixIcon: Icons.drive_file_rename_outline,
          currentFocusNode: _controller.etNameFocusNode,
          nextFocusNode: _controller.etContactNumberFocusNode,
          validatorFunction: (value) => value!.isEmpty ? 'Name Cannot Be Empty' : null,
        ),
        CustomTextField(
          textEditingController: _controller.etContactNumber,
          hintText: "Contact number",
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          currentFocusNode: _controller.etContactNumberFocusNode,
          nextFocusNode: _controller.etEmailIdFocusNode,
          validatorFunction: (value) => value!.isEmpty ? 'Contact Number Cannot Be Empty' : null,
        ),
        CustomTextField(
          textEditingController: _controller.etEmailId,
          hintText: "Email Id",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          currentFocusNode: _controller.etEmailIdFocusNode,
          allowedRegex: "[a-zA-Z0-9@.]",
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
        // Updated HiddenTextField with toggle visibility feature.
        CustomHiddenTextField(
          textEditingController: _controller.etPassword,
          hintText: "Password",
          prefixIcon: Icons.lock_outline,
          suffixIcon: Icons.visibility_off, // Toggle visibility icon.
          onSuffixIconPressed: _controller.togglePasswordVisibility, // Toggles password visibility.
          obscureText: _controller.isPasswordHidden.obs, // Obscure text based on controller state.
          currentFocusNode: _controller.etPasswordFocusNode,
          nextFocusNode: _controller.etPasswordFocusNode,
          validatorFunction: (value) => value!.isEmpty ? 'Password Cannot Be Empty' : null,
        ),
      ],
    );
  }

  // Defines the submit button widget.
  Widget _submitButton() {
    return CustomButton(
      buttonText: 'Register',
      onButtonPressed: () => _controller.onClickRegister(),
    );
  }
}
