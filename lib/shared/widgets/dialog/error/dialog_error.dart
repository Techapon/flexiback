import 'package:flutter/material.dart';

import '../../../theme/colors/app_color.dart';

void showErrorDialog({
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
                  color: AppColor.error.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 55,
                  color: AppColor.error,
                ),
              ),

              SizedBox(height: 24),

              Text(
                "Something went wrong",
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
                  backgroundColor: AppColor.error,
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