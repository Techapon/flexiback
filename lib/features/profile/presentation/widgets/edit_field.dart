import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flexiback/shared/utils/text_uppercase.dart';
import 'package:flutter/material.dart';

class EditField extends StatefulWidget {

  final String hintText;
  final String? value;
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
  State<EditField> createState() => _EditFieldState();
}

class _EditFieldState extends State<EditField> {
  late TextEditingController feildController;

  @override
  void initState() {
    super.initState();
    feildController = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.grey1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: feildController,
        keyboardType: TextInputType.text,
        maxLines: widget.maxLine,
        maxLength: widget.maxLength ?? 15,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          counterText: widget.maxLength == null ? '' : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColor.grey3,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )
        ),
        onChanged: (value) {
          feildController.text = toFirstLetterUpper(value);
          widget.onChanged(value);
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