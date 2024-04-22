import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:trans_tim/controller/login_controller.dart';
import 'package:trans_tim/controller/registration_controller.dart';
import 'package:trans_tim/screen/login_screen.dart';
import 'package:trans_tim/screen/registration_screen.dart';
import 'package:trans_tim/utility/common_widgets/custom_button.dart';

void main() {
  group('Registration Screen Tests', () {
    late RegistrationController registrationController;
    late RegistrationScreen registrationScreen;

    setUp(() {
      registrationController = RegistrationController();
      registrationScreen = RegistrationScreen();
      Get.put<RegistrationController>(registrationController);
    });

    tearDown(() {
      Get.delete<RegistrationController>();
    });

    testWidgets('Test Registration with valid data',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: registrationScreen));
      registrationController.initUI();
      registrationController.etName.text = 'John Doe';
      registrationController.etContactNumber.text = '1234567890';
      registrationController.etEmailId.text = 'john.doe@example.com';
      registrationController.etPassword.text = 'password';
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(registrationController.etName.text, isNotEmpty);
      expect(registrationController.etPassword.text, isNotEmpty);
      expect(
        GetUtils.isEmail(registrationController.etEmailId.text),
        isTrue,
      );
      expect(
        GetUtils.isPhoneNumber(registrationController.etContactNumber.text),
        isTrue,
      );
    });

    testWidgets('Test Registration with invalid data',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: registrationScreen));
      registrationController.initUI();
      registrationController.etName.text = 'John Doe';
      registrationController.etContactNumber.text = '1234567890';
      registrationController.etEmailId.text = '';
      registrationController.etPassword.text = 'password';
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(registrationController.etName.text, isNotEmpty);
      expect(registrationController.etPassword.text, isNotEmpty);
      expect(
        GetUtils.isEmail(registrationController.etEmailId.text),
        isTrue,
      );
      expect(
        GetUtils.isPhoneNumber(registrationController.etContactNumber.text),
        isTrue,
      );
    });
  });

  group('Login Screen Tests', () {
    late LoginScreen loginScreen;
    late LoginController loginController;

    setUp(() {
      loginController = Get.put(LoginController(true.obs));
      loginScreen = LoginScreen();
    });

    tearDown(() {
      Get.delete<LoginController>();
    });

    testWidgets('Test UI components', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: loginScreen));
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
    });

    testWidgets('Test Login with valid data', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: loginScreen));
      loginController.initUI();
      loginController.etEmail.text = 'john.doe@example.com';
      loginController.etPassword.text = 'password';
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(loginController.etPassword.text, isNotEmpty);
      expect(GetUtils.isEmail(loginController.etEmail.text), isTrue);
    });

    testWidgets('Test Login with in-valid data', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: loginScreen));
      loginController.initUI();
      loginController.etEmail.text = '';
      loginController.etPassword.text = 'password';
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(loginController.etPassword.text, isNotEmpty);
      expect(GetUtils.isEmail(loginController.etEmail.text), isFalse);
    });
  });
}
