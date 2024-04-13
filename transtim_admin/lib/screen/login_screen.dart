import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/common_widgets/hidden_text_field.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/constants/string_constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(body: Center(child: _body()));
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _iconWidget(),
              _textFields(),
              _loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconWidget() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.mixPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome Back!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.textTheme.headlineSmall?.fontSize,
            ),
          ),
          const SizedBox(height: DimenConstants.layoutPadding),
          SizedBox(
            height: Get.height * 0.13,
            child: Image.asset(
              StringConstants.signIn,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: Get.textTheme.headlineSmall?.fontSize,
                      ),
                    ),
                    const SizedBox(width: DimenConstants.contentPadding),
                    Icon(
                      Icons.login,
                      size: Get.textTheme.headlineSmall?.fontSize,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _textFields() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Form(
        key: _controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              textEditingController: _controller.etEmail,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              currentFocusNode: _controller.etEmailFocusNode,
              nextFocusNode: _controller.etPasswordFocusNode,
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
            const SizedBox(height: DimenConstants.contentPadding),
            CustomHiddenTextField(
              textEditingController: _controller.etPassword,
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              currentFocusNode: _controller.etPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Password Cannot Be Empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return CustomButton(
      buttonText: "Sign In",
      onButtonPressed: () => {
        _controller.onPressButtonLogin(),
      },
    );
  }
}
