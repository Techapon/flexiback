import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Calendar extends StatelessWidget {
  final String userId;
  final DateTime first;
  final DateTime focus;
  final DateTime last;

  final List<DateTime?> usageDates;

  final Function(DateTime selectedDay,DateTime focusDay) ontap;
  const Calendar({
    super.key, 
    required this.userId, 
    required this.first, 
    required this.focus, 
    required this.last, 
    required this.usageDates, 
    required this.ontap
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: first,
      lastDay: last,
      focusedDay: focus,
    
      selectedDayPredicate: (day) {
        return usageDates.any((dayinList) => isSameDay(dayinList, day));
      },
    
      onDaySelected: (selectedDay, focusedDay) {
        ontap(selectedDay,focusedDay);
      },

      headerStyle: HeaderStyle(
        formatButtonVisible: false, 
        titleCentered: false,
        headerMargin: EdgeInsets.zero,
        titleTextStyle: TextStyle(color: AppColor.grey4, fontSize: 16, fontWeight: FontWeight.bold),
        leftChevronIcon: Icon(Icons.arrow_back_ios, color: AppColor.grey4, size: 14),
        rightChevronIcon: Icon(Icons.arrow_forward_ios, color: AppColor.grey4, size: 14),
        decoration: BoxDecoration(
          color: AppColor.base1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(color: AppColor.black1,fontWeight: FontWeight.bold,fontSize: 14),

        todayTextStyle: TextStyle(color: AppColor.black1,fontWeight: FontWeight.bold,fontSize: 14),
        todayDecoration: BoxDecoration(
          color: AppColor.main2.withOpacity(0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.main2,
            width: 1.5
          )
        ),
        selectedDecoration: BoxDecoration(
          color: AppColor.main2,
          borderRadius: BorderRadius.circular(8),
        ),

        weekendTextStyle:TextStyle(color: AppColor.black1,fontWeight: FontWeight.bold,fontSize: 14),
      ),

      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E('en_US').format(day).substring(0,1); 

          return Center(
            child: Text(
              text,
              style: TextStyle(
                color: AppColor.grey4,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}