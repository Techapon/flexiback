import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/theme/colors/app_color.dart' show AppColor;

class PillField<T> extends StatelessWidget {
  
  final String title;
  final T? value;
  final String? unit;
  final String? blank;
  final TextInputType keyboardType;
  final Function(T?) onChanged;

  final int? maxValueInt;
  final double? maxValueDouble;

  final int? minValueInt;
  final double? minValueDouble; 

  final bool? enable;
  const PillField({
    super.key, 
    required this.title,
    required this.value,
    required this.unit,  
    this.blank,
    required this.keyboardType, 
    required this.onChanged,

    this.maxValueInt,
    this.maxValueDouble,

    this.minValueInt,
    this.minValueDouble,

    this.enable
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enable != null && !enable! ? .5 : 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.grey2,
            width: 1.5
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
        
            Flexible(
              child: Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      if (blank == null)
                        Expanded(
                          child: TextFormField(
        
                            enabled: enable ?? true,
        
                            initialValue: value?.toString() ?? "",
                            keyboardType: keyboardType,
                            
                            inputFormatters: [
                              keyboardType == TextInputType.number 
                                ? FilteringTextInputFormatter.digitsOnly
                                : FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        
                              if (keyboardType == TextInputType.number && maxValueInt != null)
                                TextInputFormatter.withFunction((oldV,newV) {
                                  if (newV.text.isEmpty) return newV;
        
                                  final itnValue = int.tryParse(newV.text);
                                  if (itnValue != null && itnValue <= maxValueInt! && itnValue >= (minValueInt ?? 0)) {
                                    return newV;
                                  }
                                  return oldV;
                                }),
        
                              if (keyboardType == TextInputType.numberWithOptions(decimal: true) && maxValueDouble != null)
                                TextInputFormatter.withFunction((oldV,newV) {
                                  if (newV.text.isEmpty) return newV;
        
                                  if (newV.text.endsWith('.')) {
                                    if('.'.allMatches(newV.text).length > 1) {
                                      return oldV;
                                    }
                                    return newV;
                                  }
        
                                  final doubleValue = double.tryParse(newV.text);
                                  if (doubleValue != null && doubleValue <= maxValueDouble!  && doubleValue >= (minValueDouble ?? 0)) {
                                    return newV;
                                  }
                                  return oldV;
                                }),
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
                                onChanged(int.tryParse(value) as T?);
                              } else if (T == double) {
                                onChanged(double.tryParse(value) as T?);
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
                        blank == null ? unit! : blank!,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.black1,
                          fontWeight: FontWeight.bold
                        ),
                      ) : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}