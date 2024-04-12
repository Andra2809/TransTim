import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../constants/dimens_constants.dart';
import '../helper/common_helper.dart';

class CustomDropDown extends StatelessWidget {
  final RxList<String> displayList;
  final String? labelText;
  final bool? isReadOnly;
  final IconData? prefixIcon, suffixIcon;
  final String? Function(String?)? validatorFunction;
  final Function(String?)? onValueChanged;
  final Rx<String> selected;

  const CustomDropDown({
    super.key,
    this.labelText,
    this.isReadOnly,
    this.prefixIcon,
    this.suffixIcon,
    required this.displayList,
    required this.selected,
    this.validatorFunction,
    this.onValueChanged,
  });

  bool checkForValueValidation() {
    try {
      for (String value in displayList) {
        if (selected.value == value) {
          return true;
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "CustomDropDownWidget line 39");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Obx(
      () {
        displayList.value = LinkedHashSet<String>.from(displayList).toList();
        try {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selected.value == '') focusNode.unfocus();
            if (!checkForValueValidation()) selected.value = '';
          });
        } catch (e) {
          CommonHelper.printDebugError(e, "CustomDropDownWidget line 56");
        }

        return Center(
          child: Container(
            margin: const EdgeInsets.all(DimenConstants.contentPadding),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              focusNode: focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: labelText,
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color:
                            Get.isDarkMode ? Colors.white : ColorConstants.dark,
                      )
                    : null,
                suffixIcon: suffixIcon != null
                    ? Icon(
                        suffixIcon,
                        color:
                            Get.isDarkMode ? Colors.white : ColorConstants.dark,
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(DimenConstants.cardRadius),
                  ),
                ),
              ),
              value: _selectedValue(),
              isDense: true,
              onChanged: isReadOnly != null && isReadOnly == true
                  ? null
                  : (value) => setSelected(value),
              validator: validatorFunction,
              items: displayList.map(
                (String? value) {
                  return DropdownMenuItem<String>(
                    value: dropDownValue(value),
                    child: Text(value ?? ""),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  String? _selectedValue() {
    try {
      return selected.value.isNotEmpty ? selected.value : null;
    } catch (e) {
      return null;
    }
  }

  String? dropDownValue(String? value) {
    try {
      return value!.isNotEmpty ? value : null;
    } catch (e) {
      return null;
    }
  }

  void setSelected(String? value) {
    try {
      if (value != null) {
        if (isReadOnly == null || isReadOnly != true) {
          selected.value = value;
          onValueChanged != null ? onValueChanged!(selected.value) : null;
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "CustomDropDownWidget line 134");
    }
  }
}
