import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utils/text_uppercase.dart';
import '../controller/profile_provider.dart';

class EditBoxPart extends StatelessWidget {
  
  final Function(String) onChanged;
  final String title;
  final String? value;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool readOnly;
  const EditBoxPart({
    super.key, 
    required this.title, 
    required this.value, 
    required this.icon,
    required this.hint,
    required this.keyboardType,
    this.readOnly = false,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.grey1,
          borderRadius: BorderRadius.circular(6),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Icon(icon, color: AppColor.grey4),
            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColor.grey4,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                      )
                  ),
                  TextFormField(
                    initialValue: value,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: AppColor.grey3,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    ),
                    onChanged: (value) {
                      onChanged(value);
                    },
                    readOnly: readOnly,
                    style: TextStyle(
                      color: AppColor.black1,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }
}