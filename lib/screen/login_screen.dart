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
  final LoginController _controller = Get.put(LoginController());

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Center(
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _iconWidget(),
            _textFields(),
            _loginButton(),
            _signUpPrompt(),
          ],
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
          Image.asset(
            StringConstants.signIn,
            height: Get.height * 0.13,
            fit: BoxFit.contain,
          ),
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
          children: [
            CustomTextField(
              textEditingController: _controller.etEmail,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              nextFocusNode: _controller.etPasswordFocusNode,
            ),
            const SizedBox(height: DimenConstants.contentPadding),
            Obx(() => CustomHiddenTextField(
                  textEditingController: _controller.etPassword,
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: _controller.isPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(_controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _controller.togglePasswordVisibility,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return CustomButton(
      buttonText: "Sign In",
      onButtonPressed: _controller.onPressButtonLogin,
    );
  }

  Widget _signUpPrompt() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: InkWell(
        onTap: _controller.onTapSignUp,
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
