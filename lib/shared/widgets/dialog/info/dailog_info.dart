import 'package:flexiback/core/utils/text_uppercase.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/colors/app_color.dart';

void showInfoDialog({
  required BuildContext context,
  String? title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor:  AppColor.base1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 250
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 48,
              left: 12,
              right: 12,
              bottom: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.blue1.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    LucideIcons.badgeInfo,
                    size: 55,
                    color: AppColor.blue1,
                  ),
                ),
          
                SizedBox(height: 24),
          
                Text(
                  "${ title != null ? toFirstLetterUpper(title) : 'Infomation!'}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          
                SizedBox(height: 6),
          
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
          
                SizedBox(height: 24),
          
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColor.blue1,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Understood!", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
          
              ],
            ),
          ),
        ),
      );
    },
  );

}