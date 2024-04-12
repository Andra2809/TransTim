import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadiusGeometry? radius;
  final Widget? iconWidget;
  final Color? textColor;
  final Color? buttonColor;
  final Color? foreGroundColor;
  final Color? primaryColor;
  final FocusNode? currentFocusNode;
  final bool? isWrapContent;
  final bool? isTransparentButton;
  final TextDirection? textDirection;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.radius,
    this.iconWidget,
    this.textColor,
    this.buttonColor,
    this.foreGroundColor,
    this.primaryColor,
    this.currentFocusNode,
    this.isWrapContent,
    this.isTransparentButton,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (isTransparentButton != null || isWrapContent != null) {
      if (isTransparentButton == true || isWrapContent == true) {
        return Container(
          margin: margin ?? const EdgeInsets.all(0.0),
          padding: padding ?? const EdgeInsets.all(0.0),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: width ?? Get.width,
              height: height ?? 50,
            ),
            child: _elevatedButton(),
          ),
        );
      }
    }
    return Container(
      margin: margin ?? const EdgeInsets.all(DimenConstants.contentPadding),
      padding: padding ?? const EdgeInsets.all(DimenConstants.layoutPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: width ?? Get.size.width * 0.8,
          height: 50,
        ),
        child: _elevatedButton(),
      ),
    );
  }

  Widget _elevatedButton() {
    return Directionality(
      textDirection: textDirection ?? TextDirection.ltr,
      child: buttonText.trim() == ""
          ? ElevatedButton(
              onPressed: onButtonPressed,
              style: ButtonStyle(
                elevation: isTransparentButton == true
                    ? MaterialStateProperty.all(0.0)
                    : null,
                backgroundColor: isTransparentButton == true
                    ? MaterialStateProperty.all(Colors.transparent)
                    : buttonColor != null
                        ? MaterialStateProperty.all(buttonColor)
                        : null,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: radius ??
                        (isTransparentButton == true
                            ? BorderRadius.zero
                            : BorderRadius.circular(DimenConstants.cardRadius)),
                    side: BorderSide(
                      color: isTransparentButton == true
                          ? primaryColor ?? Colors.transparent
                          : primaryColor ?? Get.theme.primaryColor,
                    ),
                  ),
                ),
              ),
              child: Center(child: iconWidget),
            )
          : ElevatedButton.icon(
              icon: iconWidget ?? const Text(""),
              focusNode: currentFocusNode,
              label: Center(
                child: Text(
                  buttonText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              style: ButtonStyle(
                elevation: isTransparentButton == true
                    ? MaterialStateProperty.all(0.0)
                    : null,
                backgroundColor: isTransparentButton == true
                    ? MaterialStateProperty.all(Colors.transparent)
                    : buttonColor != null
                        ? MaterialStateProperty.all(buttonColor)
                        : null,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: radius ??
                        (isTransparentButton == true
                            ? BorderRadius.zero
                            : BorderRadius.circular(DimenConstants.cardRadius)),
                    side: BorderSide(
                      color: isTransparentButton == true
                          ? primaryColor ?? Colors.transparent
                          : primaryColor ?? Get.theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              onPressed: onButtonPressed,
            ),
    );
  }
}
