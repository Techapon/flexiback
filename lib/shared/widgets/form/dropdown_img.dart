import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flexiback/core/entities/image_text_entity.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/theme/colors/app_color.dart';

class CustomDropdownImage extends StatefulWidget {
  final ValueNotifier<String?> valueListenable_title;
  final List<ImageTextEntity> listItem;
  final Function(String) onChanged;
  const CustomDropdownImage({
    super.key, 
    required this.valueListenable_title, 
    required this.listItem,
    required this.onChanged
  });

  @override
  State<CustomDropdownImage> createState() => _CustomDropdownImageState();
}

class _CustomDropdownImageState extends State<CustomDropdownImage> {
  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        valueListenable: widget.valueListenable_title,
        items: widget.listItem
          .map((ImageTextEntity item) => DropdownItem<String>(
                value: item.text,
                height: 40,
                child: Row(
                  spacing: 8,
                  children: [
                    Image.asset(
                      "${item.path}",
                      height: 20,
                    ),
                    Text(
                      "${item.decorate}${item.text}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ))
          .toList(),
        onChanged: (value) {
          widget.valueListenable_title.value = value;
          widget.onChanged(value!);
        },
    
        // decorate
    
        buttonStyleData: ButtonStyleData(
          height: 45,
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: AppColor.base1,
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(
              color: AppColor.grey2,
              width: 1.5
            )
          ),
        ),
    
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.base1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.black1,
              width: 1.5
            )
          ),
          elevation: 8,
    
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.white),
            radius: Radius.circular(10),
          ),
        ),
    
        
    
        iconStyleData: IconStyleData(
          icon: Icon(LucideIcons.chevronDown, color: AppColor.black1),
        ),
      )
    );
  }
}