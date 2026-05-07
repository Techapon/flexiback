import 'dart:math';

import 'package:flexiback/core/entities/dot_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';

import '../../../../../core/enums/dot_status.dart';

/// ฟังก์ชันสำหรับ Generate ข้อมูลจำลอง
/// [hours] และ [minutes] จะถูกนำมารวมกันเป็นเวลาทั้งหมด
FullDataEntity generateMockDotData({int hours = 0, int minutes = 0,double gPer = .7}) {
  final List<DotEntity> dataList = [];
  final Random random = Random();
  
  // คำนวณจำนวนวินาทีทั้งหมด
  final int totalSeconds = (hours * 3600) + (minutes * 60);
  
  // เริ่มต้นจากเวลาปัจจุบันลบด้วยจำนวนเวลาที่จะ gen (เพื่อให้จบที่เวลาปัจจุบันพอดี)
  DateTime currentTime = DateTime.now().subtract(Duration(seconds: totalSeconds));
  
  DotStatus currentStatus = DotStatus.good;
  int remainingDuration = 0;

  for (int i = 0; i < totalSeconds; i++) {
    // Logic การเปลี่ยนสถานะ (State Persistence)
    if (remainingDuration <= 0) {
      // สุ่มสถานะใหม่ตามน้ำหนัก Good 70%, Bad 30%
      currentStatus = random.nextDouble() < gPer ? DotStatus.good : DotStatus.bad;
      
      if (currentStatus == DotStatus.good) {
        // Good: ต่อเนื่อง 30 - 300 วินาที
        remainingDuration = random.nextInt(271) + 30; 
      } else {
        // Bad: ต่อเนื่อง 5 - 30 วินาที (ตามที่กำหนดใหม่)
        remainingDuration = random.nextInt(26) + 5; 
      }
    }

    dataList.add(DotEntity(
      status: currentStatus,
      dateTime: currentTime,
    ));

    // เลื่อนเวลาไปทีละ 1 วินาที
    currentTime = currentTime.add(const Duration(seconds: 1));
    remainingDuration--;
  }

  int goodCount = dataList.where((e) => e.status == DotStatus.good).length;
  int badCount = dataList.where((e) => e.status == DotStatus.bad).length;



  _printSummary(dataList, hours, minutes);

  return FullDataEntity(
    goodTime: Duration(seconds: goodCount),
    badTime: Duration(seconds: badCount),
    dateTime: dataList.first.dateTime,
    dotList: dataList
  );
}

void _printSummary(List<DotEntity> list, int h, int m) {
  if (list.isEmpty) {
    print('No data generated.');
    return;
  }

  int goodCount = list.where((e) => e.status == DotStatus.good).length;
  int badCount = list.where((e) => e.status == DotStatus.bad).length;
  
  print('--- 📊 Generation Summary ---');
  print('Configured Duration: $h hours, $m minutes');
  print('Total Data Points  : ${list.length} seconds');
  print('Good Status (70%)  : $goodCount points (${((goodCount / list.length) * 100).toStringAsFixed(2)}%)');
  print('Bad Status  (30%)  : $badCount points (${((badCount / list.length) * 100).toStringAsFixed(2)}%)');
  print('Time Range         : ${list.first.dateTime} to ${list.last.dateTime}');
  print('-----------------------------\n');
}
