import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exception/profile/profile_failure.dart';
import '../models/device_setting_model.dart';

class DeviceRemoteDatasource {
  final supabase = Supabase.instance.client;

  Future<void> updateDevicSetting(DeviceSettingModel setting) async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw ProfileFailure.sessionExpired();

      await supabase.from("device").upsert(setting.toMap());

    } on PostgrestException catch(e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<DeviceSettingModel> getDevicSetting() async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw ProfileFailure.sessionExpired();

      final response = await supabase
        .from("device")
        .select()
        .eq("id", userId)
        .single();

      final deviceSettingModel = DeviceSettingModel.formMap(response);

      return deviceSettingModel;

    } on PostgrestException catch(e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }   
  }
}