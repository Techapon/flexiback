import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/trend/data/models/overview_model.dart';
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
}
