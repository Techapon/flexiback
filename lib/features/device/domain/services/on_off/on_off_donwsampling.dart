import 'package:flexiback/core/entities/dot_entity.dart';
import 'package:flexiback/features/device/data/models/fulldata_model.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';

class OnOffDonwsampling {
  
  static FullDataEntity? dowSampling(FullDataEntity fulldata) {
    final List<DotEntity> rawData = fulldata.dotList;
    
    if (rawData.isEmpty) return null;

    // เริ่มต้นด้วยจุดแรก
    final List<DotEntity> downsampledData = [rawData.first];

    for (int i = 1; i < rawData.length; i++) {
      final DotEntity currentDot = rawData[i];
      final DotEntity lastAddedDot = downsampledData.last;

      if (currentDot.status != lastAddedDot.status) {
        downsampledData.add(DotEntity(
          status: lastAddedDot.status,
          dateTime: currentDot.dateTime,
        ));
        
        downsampledData.add(currentDot);
      }
    }

    if (downsampledData.last.dateTime != rawData.last.dateTime) {
        downsampledData.add(rawData.last);
    }

    return FullDataEntity(
      goodTime: fulldata.goodTime, 
      badTime: fulldata.badTime, 
      dateTime: fulldata.dateTime, 
      dotList: downsampledData
    );
  }
}