import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flexiback/shared/utils/text_uppercase.dart';
import 'package:flutter/material.dart';

class EditField extends StatelessWidget {

  final String hintText;
  final String value;
  final int maxLine;
  final int? maxLength;
  final Function(String) onChanged;
  const EditField({
    super.key, 
    required this.value,
    this.maxLine = 1,
    this.maxLength,
    required this.hintText,
    required this.onChanged
  });


  @override
  Widget build(BuildContext context) {
    TextEditingController feildController = TextEditingController(text: value);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.grey1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: feildController,
        keyboardType: TextInputType.text,
        maxLines: maxLine,
        maxLength: maxLength ?? 15,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          counterText: maxLength == null ? '' : null,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColor.grey3,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )
        ),
        onChanged: (value) {
          feildController.text = toFirstLetterUpper(value);
          onChanged(value);
        },
        style: TextStyle(
          color: AppColor.black1,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        )
      ),
    );
  }
}