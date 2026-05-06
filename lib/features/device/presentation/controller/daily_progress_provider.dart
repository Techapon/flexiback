import 'dart:async';
import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/features/device/data/datasources/device_remote_datasource.dart';
import 'package:flexiback/features/device/data/repositories/device_db_repository_impl.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/domain/usecases/add_daily_progress_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/delete_daily_progress_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/get_daily_progress_usecase.dart';
import 'package:flutter/material.dart';

class DailyProgressProvider extends ChangeNotifier {
  final addDailyProgressUsecase = 
    AddDailyProgressUsecase(DeviceDbRepositoryImpl(DeviceRemoteDatasource()));
  final getDailyProgressUsecase = 
    GetDailyProgressUsecase(DeviceDbRepositoryImpl(DeviceRemoteDatasource()));
  final deleteDailyProgressUsecase = 
    DeleteDailyProgressUsecase(DeviceDbRepositoryImpl(DeviceRemoteDatasource()));

  bool isLoading = false;
  String? error;

  List<DailyProgressEntity>? dailyProgressList;
  Stream<List<DailyProgressEntity>>? _dailyProgressStream;
  StreamSubscription<List<DailyProgressEntity>>? _subscription;

  Stream<List<DailyProgressEntity>>? get dailyStream => _dailyProgressStream;

  void getDailyProgress(String userId) {
    error = null;
    notifyListeners();

    _subscription?.cancel();
    _dailyProgressStream = getDailyProgressUsecase.call(userId);
    _subscription = _dailyProgressStream!.listen(
      (data) {
        dailyProgressList = data;
      },
      onError: (e) {
        error = e.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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

  Future<void> deleteDailyProgress(String id) async {
    error = null;

    isLoading = true;
    notifyListeners();
    try {
      await deleteDailyProgressUsecase.call(id);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}