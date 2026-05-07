import 'dart:async';

import 'package:flexiback/features/trend/data/datasources/trend_remote_datasource.dart';
import 'package:flexiback/features/trend/data/repositories/trend_repository_impl.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flexiback/features/trend/domain/usecases/get_overview_usecase.dart';
import 'package:flutter/material.dart';

class TrendProvider extends ChangeNotifier {
  final getOverviewUsecase =
    GetOverviewUsecase(TrendRepositoryImpl(TrendRemoteDatasource()));

  bool isLoading = false;
  String? error;

  OverviewEntity? overviewData;
  List<OverviewEntity>? deviceOverviewList;
  Stream<List<OverviewEntity>>? _overviewStream;
  StreamSubscription<List<OverviewEntity>>? _subscription;

  Stream<List<OverviewEntity>>? get overviewStream => _overviewStream;

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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
