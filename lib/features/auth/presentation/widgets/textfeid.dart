import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class Custom_Textfeild extends StatefulWidget {
  final String hint;
  final TextInputType type;
  final bool obscureText;

  final TextEditingController controller;
  final String? errorText;

  final IconData icon;

  const Custom_Textfeild({
    super.key, 
    required this.hint, 
    required this.type, 
    required this.obscureText,
    required this.controller,
    this.errorText,
    required this.icon,
  });

  @override
  State<Custom_Textfeild> createState() => _Custom_TextfeildState();
}

class _Custom_TextfeildState extends State<Custom_Textfeild> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feild
        TextFormField(
          controller: widget.controller,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.cream3,
          ),
          decoration: InputDecoration(
            
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 16,
              color: AppColor.cream2,
            ),
            filled: true,
            fillColor: AppColor.base1,
            contentPadding:  EdgeInsets.symmetric(
                horizontal: 16.0 * 1.5, vertical: 16.0),
        
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.errorText != null ? AppColor.error : AppColor.cream1,
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.errorText != null ? AppColor.error : AppColor.cream1,
                width: 3
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            //--------
        
            suffixIcon: widget.obscureText
            ? IconButton(
              highlightColor: Colors.transparent,
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColor.cream3,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,

            prefixIcon: Icon(
              widget.icon,
              size: 26,
              color: AppColor.cream3,
            )
            
          ),
          keyboardType: widget.type,
        
          obscureText: _isPasswordVisible ,
        ),

        // Error warnign
        widget.errorText != null 
        ? Text(
          widget.errorText ?? "",
          style: TextStyle(
            color: AppColor.error,
            fontSize: 12,
            height: 1.65
          ),
        ) 
        : SizedBox.shrink(),

      ],
    );
  }
}