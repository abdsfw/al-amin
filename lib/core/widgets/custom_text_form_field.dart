import 'package:alaminedu/core/utils/color_app.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle labelStyle;
  final IconData prefixIcon;

  final bool readOnly;
  final Function(String)? onChanged;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.labelStyle,
    required this.prefixIcon,
    required this.readOnly,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.kFifthColor,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            width: 0,
            color: Colors.black,
          ),
        ),
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }
}
