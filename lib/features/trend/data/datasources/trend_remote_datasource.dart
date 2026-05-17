import 'package:flexiback/core/enums/dot_status.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/core/models/dot_model.dart';
import 'package:flexiback/features/device/data/models/daily_progress_model.dart';
import 'package:flexiback/features/device/data/models/fulldata_model.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/data/models/overview_model.dart';
import 'package:flexiback/features/trend/data/models/therapy_session_trend_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrendRemoteDatasource {
  final supabase = Supabase.instance.client;

  Stream<List<OverviewModel>> getOverviewData(String userId) {
    return supabase
      .from("device_usage_times")
      .stream(primaryKey: ["date_time"])
      .eq("user_id", userId)
      .handleError((error) {
        if (error is PostgrestException) {
          throw CoreFailure.databaseError(error.message);
        }
        throw CoreFailure.unknown(error.toString());
      }).map(
        (data) => data.map(
          (item) => OverviewModel.fromMap(item)
        ).toList()
      );
  }

  Future<FullDataEntity> getFullDataUsage(String userId, DateTime dateTime) async {
    try {
      final startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day).toUtc().toIso8601String();
      final endOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59).toUtc().toIso8601String();

      final timeList = await supabase
        .from("device_usage_times")
        .select()
        .eq("user_id", userId)
        .gte("date_time", startOfDay)
        .lte("date_time", endOfDay);

      final dotsResponse = await supabase
        .from("device_usage_dots")
        .select()
        .eq("user_id", userId)
        .gte("date_time", startOfDay)
        .lte("date_time", endOfDay)
        .order("date_time", ascending: true);

      final totalGoodSeconds = (timeList as List).fold<int>(
        0,
        (sum, row) => sum + (row["good_time"] as num).toInt()
      );
      final totalBadSeconds = timeList.fold<int>(
        0,
        (sum, row) => sum + (row["bad_time"] as num).toInt()
      );

      final model = FulldataModel(
        goodTime: Duration(seconds: totalGoodSeconds),
        badTime: Duration(seconds: totalBadSeconds),
        dateTime: DateTime(dateTime.year, dateTime.month, dateTime.day),
        dotList: (dotsResponse as List).map((dot) {
          return DotModel(
            status: dot["status"] == "good" ? DotStatus.good : DotStatus.bad,
            dateTime: DateTime.parse(dot["date_time"]).toLocal(),
          );
        }).toList(),
      );

      return model.toEntity();
    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<List<DailyProgressModel>> getDailyProgress(String userId) async {
    try {
      final response = await supabase
        .from("daily_progress")
        .select()
        .eq("user_id", userId)
        .order("date_time", ascending: true);

      return (response as List).map((item) => DailyProgressModel.fromMap(item)).toList();
    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<List<TherapySessionTrendModel>> getTherapySessions(String userId) async {
    try {
      final response = await supabase
        .from("therapy_sessions")
        .select()
        .eq("user_id", userId)
        .order("created_at", ascending: true);

      return (response as List).map((item) => TherapySessionTrendModel.fromMap(item)).toList();
    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }
}
