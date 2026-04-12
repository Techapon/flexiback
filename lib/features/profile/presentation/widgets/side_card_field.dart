import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flexiback/shared/utils/text_uppercase.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SideCardField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final int maxLine;
  final String? value;
  final int? maxLength;
  final Function(String) onChanged;
  const SideCardField({
    super.key,
    required this.icon,
    required this.hintText,
    this.maxLine = 1,
    this.maxLength,
    required this.value,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.base1,
          border: Border.all(
            color: AppColor.grey2,
            width: 1.5
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 25,
                    color: AppColor.black1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColor.grey2,
                      width: 1.5
                    )
                  ),
                ),
                child: TextFormField(
                  initialValue: value,
                  keyboardType: TextInputType.text,
                  maxLines: maxLine,
                  maxLength: maxLength ?? 30,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: maxLength == null ? '' : null,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: AppColor.blue1,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                  onChanged: (value) {
                    onChanged(value);
                  },
                  style: TextStyle(
                    color: AppColor.blue1,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}