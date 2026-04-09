import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/theme/colors/app_color.dart';

class Custom_Dropdown extends StatefulWidget {
  final ValueNotifier<String?> valueListenable_title;
  final List<String> List_items;
  final Function(String) onChanged;
  const Custom_Dropdown({
    super.key, 
    required this.valueListenable_title, 
    required this.List_items,
    required this.onChanged
  });

  @override
  State<Custom_Dropdown> createState() => _Custom_DropdownState();
}

class _Custom_DropdownState extends State<Custom_Dropdown> {
  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        valueListenable: widget.valueListenable_title,
        items: widget.List_items
          .map((String item) => DropdownItem<String>(
                value: item,
                height: 40,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black1,
                  ),
                  overflow: TextOverflow.ellipsis,
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