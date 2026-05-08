import 'dart:async';

import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/data/datasources/trend_remote_datasource.dart';
import 'package:flexiback/features/trend/data/repositories/trend_repository_impl.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flexiback/features/trend/domain/usecases/get_full_data_usage_usecase.dart';
import 'package:flexiback/features/trend/domain/usecases/get_overview_usecase.dart';
import 'package:flutter/material.dart';

class TrendProvider extends ChangeNotifier {

  void disposeProvi() {
    _subscription?.cancel();
    overviewData = null;
    deviceOverviewList?.clear();
    fullData = null;
  }

  final getOverviewUsecase =
    GetOverviewUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));
  final getFullDataUsageUsecase =
    GetFullDataUsageUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));

  bool isLoading = false;
  String? error;

  Stream<List<OverviewEntity>>? _overviewStream;
  StreamSubscription<List<OverviewEntity>>? _subscription;

  Stream<List<OverviewEntity>>? get overviewStream => _overviewStream;
  
  OverviewEntity? overviewData;
  List<OverviewEntity>? deviceOverviewList;

  FullDataEntity? fullData;

  void getOverviewData(String userId) {
    error = null;
    isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _overviewStream = getOverviewUsecase.call(userId);
    _subscription = _overviewStream!.listen(
      (list) {
        deviceOverviewList = list;
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
    print("Getting..");

    try {
      fullData = await getFullDataUsageUsecase.call(userId, dateTime);
      print('FullData Summary: goodTime=${fullData?.goodTime}, badTime=${fullData?.badTime}, totalTime=${fullData?.totalTime}, date=${fullData?.dateTime}, dots=${fullData?.dotList.length}');
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

}
