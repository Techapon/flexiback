import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/features/device/data/datasources/device_remote_datasource.dart';
import 'package:flexiback/features/device/data/repositories/device_db_repository_impl.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/domain/usecases/add_daily_progress_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/get_daily_progress_usecase.dart';
import 'package:flutter/material.dart';

class DailyProgressProvider extends ChangeNotifier {
  final addDailyProgressUsecase = 
    AddDailyProgressUsecase(DeviceDbRepositoryImpl(DeviceRemoteDatasource()));
  final getDailyProgressUsecase = 
    GetDailyProgressUsecase(DeviceDbRepositoryImpl(DeviceRemoteDatasource()));

  bool isLoading = false;
  String? error;

  Stream<List<DailyProgressEntity>>? _dailyProgressStream;

  Stream<List<DailyProgressEntity>>? get dailyStream => _dailyProgressStream;

  Future<void> getDailyProgress(String userId) async {
    error = null;

    isLoading = true;
    notifyListeners();
    try {
      _dailyProgressStream =  getDailyProgressUsecase.call(userId);
      print("Stream is ${_dailyProgressStream == null}");
      final _sub = _dailyProgressStream?.listen((data) {
        print(data);
      });
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addDailyProgress(DailyProgressEntity dailyProgress,ImageEntity image) async {
    error = null;

    isLoading = true;
    notifyListeners();
    try {
      await addDailyProgressUsecase.call(dailyProgress, image);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
  


}