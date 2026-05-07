import 'dart:io';

import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/core/exception/storage_exception/storage_error_mapper.dart';
import 'package:flexiback/core/exception/storage_exception/storage_failure.dart';
import 'package:flexiback/features/device/data/models/daily_progress_model.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/data/models/fulldata_model.dart';
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

      await supabase.from("device").upsert(setting.toMap(userId: userId));

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

  Future<void> uploadDeviceUsage(FulldataModel downsampedData) async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw ProfileFailure.sessionExpired();

      // Time usage
      await supabase
        .from("device_usage_times")
        .insert(downsampedData.toMapTime(user_id: userId));

      // Dots list
      final dotsMap = downsampedData.toMapDots(user_id: userId);
      await supabase
        .from("device_usage_dots")
        .insert(dotsMap); 


    } on PostgrestException catch(e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  // Daily Progress 
  Stream<List<DailyProgressModel>> getDailyProgress(String userId) {
    try {
      return supabase
        .from("daily_progress")
        .stream(primaryKey: ["id"])
        .eq("user_id", userId)
        .order("date_time", ascending: false)
        .handleError((error) {
          if (error is PostgrestException) {
            throw CoreFailure.databaseError(error.message);
          }
          throw CoreFailure.unknown(error.toString());
        }).map(
          (data) => data.map(
            (item) {
              return DailyProgressModel.fromMap(item);
            }  
          ).toList()
        );

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<void> addDailyProgress(DailyProgressModel dailyProgress, ImageEntity image) async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw ProfileFailure.sessionExpired();

      // 

      final String? imgUrl = await addNewImage(image);

      if (imgUrl != null) dailyProgress.img = imgUrl;

      await supabase
        .from("daily_progress")
        .insert(dailyProgress.toMap(userId));

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } on StorageFailure {
      rethrow; 
    } on CoreFailure {
      rethrow;
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  // Upload Image 
  Future<String?> addNewImage(ImageEntity? image) async {
    if (image == null) return null;

    try {
      final bytes = await image.file!.readAsBytes();

      final extension = switch (image.type) {
        'image/png'  => 'png',
        'image/webp' => 'webp',
      _            => 'jpg',
      };

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

      // upload
      await supabase.storage
        .from('daily_progress')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: image.type ?? 'image/jpeg'
          )
        );

      final url = supabase.storage.from('daily_progress').getPublicUrl(fileName);

      return url;
    }
    on StorageException catch (e) {
      throw StorageErrorMapper.fromStorageException(e);
    }
    on FileSystemException catch (e) {
      throw StorageErrorMapper.fromFileSystemException(e);
    }
    catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<void> deleteDailyProgress(String id) async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw ProfileFailure.sessionExpired();

      final response = await supabase
          .from("daily_progress")
          .select("image_src")
          .eq("id", id)
          .single();

      final String? imageUrl = response["image_src"];

      if (imageUrl != null) {
        await deleteImage(imageUrl);
      }

      // 3. Delete the record from database
      await supabase.from("daily_progress").delete().eq("id", id);
    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } on StorageFailure {
      rethrow;
    } on CoreFailure {
      rethrow;
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  // Upload Image 
  Future<void> deleteImage(String? oldImage) async {
    try {
      // remove old profile image
      if (oldImage != null) {
        final oldFileName = Uri.parse(oldImage).pathSegments.last;
        await supabase.storage
          .from('daily_progress')
          .remove([oldFileName]);
      }
    }
    on StorageException catch (e) {
      throw StorageErrorMapper.fromStorageException(e);
    }
    on FileSystemException catch (e) {
      throw StorageErrorMapper.fromFileSystemException(e);
    }
    catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

}