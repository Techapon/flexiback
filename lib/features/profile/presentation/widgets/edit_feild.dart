import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flexiback/shared/utils/text_uppercase.dart';
import 'package:flutter/material.dart';

class EditFeild extends StatelessWidget {

  final String hintText;
  final String value;
  final Function(String) onChanged;
  const EditFeild({
    super.key, 
    required this.value,
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
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
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