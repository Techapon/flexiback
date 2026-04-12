import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Auth_Btn extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onTap;
  const Auth_Btn({
    super.key, 
    required this.text, 
    required this.onTap, 
    required this.isLoading
  });

  @override
  State<Auth_Btn> createState() => _Auth_BtnState();
}

class _Auth_BtnState extends State<Auth_Btn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.main1,
            AppColor.main2,
            AppColor.main3,
            AppColor.main4,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FilledButton(
        onPressed: widget.onTap,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: widget.isLoading 
          ? SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ) 
          : SizedBox(
            height: 25,
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}