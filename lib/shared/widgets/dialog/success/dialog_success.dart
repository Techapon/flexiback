import 'package:flutter/material.dart';

import '../../../theme/colors/app_color.dart';

void showSuccessDialog({
  required BuildContext context,
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
                  color: AppColor.success.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 55,
                  color: AppColor.success,
                ),
              ),

              SizedBox(height: 24),

              Text(
                "Success!",
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
                  backgroundColor: AppColor.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
        
            ],
          ),
        ),
      );
    },
  );

}