import 'package:code_chronicles/utils/color_constants.dart';
import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? titleFocusNode;
  final String hintText;
  const TitleField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.titleFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      maxLength: 70,
      textAlignVertical: TextAlignVertical.top,
      focusNode: titleFocusNode,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
