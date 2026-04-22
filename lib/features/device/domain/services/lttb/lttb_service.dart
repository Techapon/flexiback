import 'dart:math';

import 'package:flexiback/core/constants/flexiback.dart';
import 'package:flexiback/core/entities/dot_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';

class LTTB {
  static final int bucketSize = Flexiback.bucketSize; 

  static FullDataEntity? LTTBdownsamp(FullDataEntity rawData) {

    if (rawData.dotList.isEmpty) return null;

    // Raw Dots List
    final List<DotEntity> oldDotList = List.from(rawData.dotList);

    // Buckets
    List<List<DotEntity>> buckets = [];

    // define first and list
    final DotEntity firstDot = oldDotList.first;
    final DotEntity lastDot = oldDotList.last;

    // N
    final int N = (oldDotList.length / bucketSize).ceil();
    

    // remove the fisrt and last
    oldDotList.removeAt(0);
    oldDotList.removeLast();

    // Divie the buckets
    for (int i = 0; i < N; i++) {
      int startIndex = (i * bucketSize);
      int endIndex = min(((i + 1) * bucketSize), oldDotList.length);

      buckets.add(oldDotList.sublist(startIndex,endIndex));
    }
    
    // Dot Analyzes Lists
    List<DotEntity> dotDownsamped = [];

    // Add first Dot
    dotDownsamped.add(firstDot);

    // Triangle Method
    for (int i = 0; i < buckets.length; i++) {
      final DotEntity A = dotDownsamped[i]; // At first roll it will be firstDot
      final DotEntity C = (i + 1 < buckets.length)
        ? CAverageValue(buckets[i+1])
        : lastDot;

      // Waiting for the dot that make the most triangle area
      DotEntity B = buckets[i][0]; // default B value

      // The most Triangle area
      double maxArea = 0;

      for (int j = 0; j < buckets[i].length; j++) {
        // B = buckets[1][j];
        final eachDot = buckets[i][j];
        final double triangleArea = TriangleCalculate(A, eachDot, C);

        if (triangleArea > maxArea) {
          maxArea = triangleArea;
          B = eachDot;
        }
      }

      // Now we got Selected B
      dotDownsamped.add(B);
    }

    // Add the last Dot
    dotDownsamped.add(lastDot);

    // return finally Analyzed List
    return FullDataEntity(
      goodTime: rawData.goodTime,
      badTime: rawData.badTime,
      dotList: dotDownsamped
    );

  }

  // Calculate C Average
  static DotEntity CAverageValue(List<DotEntity> CBucket) {

    if (CBucket.length == 1) {
      return CBucket.first;
    }
    
    double avgValue = CBucket
      .map((dot) => dot.value)
      .reduce((a,b) => a + b) / CBucket.length;

    double avgTime = CBucket
      .map((dot) => dot.dateTime.microsecondsSinceEpoch)
      .reduce((a,b) => a + b) / CBucket.length;
    
    return DotEntity(
      value: avgValue,
      dateTime: DateTime.fromMillisecondsSinceEpoch(avgTime.round())
    );
  }

  // Calculate Tirangle Area
  static double TriangleCalculate(
    DotEntity A,
    DotEntity eachB,
    DotEntity C
  ) {

    // A
    final xA = A.value;
    final yA = A.dateTime.microsecondsSinceEpoch;

    // B
    final xB = eachB.value;
    final yB = eachB.dateTime.microsecondsSinceEpoch;

    // C
    final xC = C.value;
    final yC = C.dateTime.microsecondsSinceEpoch;

    // Calcualte
    final area = ((xA * (yB-yC)) + ( xB * (yC-yA)) + (xC * (yA-yB))).abs();

    return area;
  }
  
}