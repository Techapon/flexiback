import 'dart:async';

import 'package:flexiback/core/entities/calendar_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/data/datasources/trend_remote_datasource.dart';
import 'package:flexiback/features/trend/data/repositories/trend_repository_impl.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/trend/domain/usecases/get_daily_progress_trend_usecase.dart';
import 'package:flexiback/features/trend/domain/usecases/get_full_data_usage_usecase.dart';
import 'package:flexiback/features/trend/domain/usecases/get_overview_usecase.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/therapy_session_trend_entity.dart';
import '../../domain/service/charts/aggregate_device_usage_day.dart';
import '../../domain/usecases/get_therapy_sessions_usecase.dart';

class TrendProvider extends ChangeNotifier {

  void disposeProvi() {
    _subscription?.cancel();
    overviewData = null;
    deviceOverviewList?.clear();
    fullData = null;
    dailyProgressList?.clear();
    therapySessionList?.clear();
  }

  final getOverviewUsecase =
    GetOverviewUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));
  final getFullDataUsageUsecase =
    GetFullDataUsageUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));
  final getDailyProgressTrendUsecase =
    GetDailyProgressTrendUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));
  final getTherapySessionsUsecase =
    GetTherapySessionsUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));

  bool isLoading = false;
  String? error;

  Stream<List<OverviewEntity>>? _overviewStream;
  StreamSubscription<List<OverviewEntity>>? _subscription;

  Stream<List<OverviewEntity>>? get overviewStream => _overviewStream;
  
  OverviewEntity? overviewData;
  List<OverviewEntity>? deviceOverviewList;

  // Full data
  FullDataEntity? fullData;

  // Daily Progress
  List<DailyProgressEntity>? dailyProgressList;

  // Therapy Session
  List<TherapySessionTrendEntity>? therapySessionList;

  // calandar
  CalendarEntity? deviceUsageCalendar;

  void getOverviewData(String userId) {
    error = null;
    isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _overviewStream = getOverviewUsecase.call(userId);
    _subscription = _overviewStream!.listen(
      (list) {
        deviceUsageCalendar = CalendarEntity.fromUsageDates(list.map((item) => item.dateTime).toList());
        deviceUsageCalendar?.usageDates.sort((a, b) => a!.compareTo(b!));

        final List<OverviewEntity>?  rawDeviceOverview = list;
        rawDeviceOverview?.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
        deviceOverviewList = aggregateDeviceUsageDay(rawDeviceOverview ?? []);

        final totalGood = list.fold(
          0.0,
          (sum, e) => sum + (e.totalGoodTime ?? 0)
        );
        final totalBad = list.fold(
          0.0,
          (sum, e) => sum + (e.totalBadTime ?? 0)
        );

        overviewData = OverviewEntity.fromComputed(
          totalGoodTime: totalGood,
          totalBadTime: totalBad,
        );

        isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        error = e.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> getFullDataUsage(String userId, DateTime dateTime) async {
    // if (fullData != null) return;
    error = null;
    isLoading = true;
    notifyListeners();

    try {
      fullData = await getFullDataUsageUsecase.call(userId, dateTime);
      // print('FullData Summary: goodTime=${fullData?.goodTime}, badTime=${fullData?.badTime}, totalTime=${fullData?.totalTime}, date=${fullData?.dateTime}, dots=${fullData?.dotList.length}');
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getDailyProgress(String userId) async {
    error = null;
    isLoading = true;
    notifyListeners();

    try {
      dailyProgressList = await getDailyProgressTrendUsecase.call(userId);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getTherapySessions(String userId) async {
    error = null;
    isLoading = true;
    notifyListeners();

    try {
      therapySessionList = await getTherapySessionsUsecase.call(userId);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

}
