import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/colors/app_color.dart' show AppColor;

class PillField<T> extends StatelessWidget {
  
  final String title;
  final T? value;
  final String? unit;
  final TextInputType keyboardType;
  final Function(T?) onChanged;
  const PillField({
    super.key, 
    required this.title,
    required this.value,
    required this.unit,  
    required this.keyboardType, 
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.grey2,
            width: 1.5
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),        
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.black1,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
        
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColor.grey2,
                    width: 1.5
                  ),
                ),
              ),
            
              child: IntrinsicWidth(
                child: Row(
                  spacing: 6,
                  children: [
                
                    Expanded(
                      child: TextFormField(
                        initialValue: value?.toString() ?? "",
                        keyboardType: keyboardType,

                        inputFormatters: [
                          keyboardType == TextInputType.number ? 
                            FilteringTextInputFormatter.digitsOnly : 
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "__",
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(
                            color: AppColor.grey3,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )
                        ),
                        onChanged: (value) {
                          if (T == int) {
                            onChanged(int.parse(value) as T?);
                          } else if (T == double) {
                            onChanged(double.parse(value) as T?);
                          }
                        },
                        style: TextStyle(
                          color: AppColor.black1,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )
                      ),
                    ),
                
                    unit != null ? Text(
                      unit!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.black1,
                        fontWeight: FontWeight.bold
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}