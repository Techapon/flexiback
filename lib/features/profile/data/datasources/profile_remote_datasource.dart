import 'dart:io';
import 'package:flexiback/shared/entities/image_entity.dart';
import 'package:mime/mime.dart';

import 'package:flexiback/core/exception/profile/profile_failure.dart';
import 'package:flexiback/features/profile/data/models/therapist_model.dart';
import 'package:flexiback/shared/entities/role_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exception/core_exception/core_error_failure.dart';
import '../../../../core/exception/storage_exception/storage_error_mapper.dart';
import '../../../../core/exception/storage_exception/storage_failure.dart';
import '../../domain/entities/general_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/therapist_entity.dart';
import '../models/general_model.dart';
import '../models/profile_model.dart';

class ProfileRemoteDatasource {
  final supabase = Supabase.instance.client;

  Future<ProfileEntity> getProfile() async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw ProfileFailure.sessionExpired();

      final response = await supabase.from("profiles").select().eq("id", userId).single();

      final email = currentUser?.email;
      final createdAt = currentUser?.createdAt;

      final profile = ProfileModel.fromMap(
        response,
        email!,
        DateTime.parse(createdAt!),
      );

      if (profile.role == Role.General.entity) {
        return getGeneral(profile);
      } else if (profile.role == Role.Therapist.entity) {
        return getTherapist(profile);
      }

      return profile;

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      print("unknown error : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }

  // Get Role data
  // --------------------------------------------------------------------

  Future<GeneralEntity> getGeneral(ProfileModel profileData) async {
    try {
      final response = await supabase
          .from(Role.General.entity)
          .select()
          .eq("id", profileData.id)
          .single();

      return GeneralModel.fromMap(profileData, response);

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      print("unknown error : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<TherapistEntity> getTherapist(ProfileModel profileData) async {
    try {
      final response = await supabase
          .from(Role.Therapist.entity)
          .select()
          .eq("id", profileData.id)
          .single();

      return TherapistModel.fromMap(profileData, response);

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      print("unknown error : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }

  // Update -------------------------------------------
  Future upadteProfile(ProfileEntity newProfile, ImageEntity? newImage,String? oldImage) async {
    try {
      
      final String? imgUrl = await uploadImg(newImage);

      final profileModel = ProfileModel.formEntity(newProfile);

      profileModel.img = imgUrl;

      await supabase
        .from("profiles")
        .update(profileModel.toMap())
        .eq("id", newProfile.id);
      
      if (profileModel.role == Role.General.entity) {
        final GeneralModel general = GeneralModel.fromEntity(newProfile as GeneralEntity);
        return updateGeneral(general);
      } else if (profileModel.role == Role.Therapist.entity) {
        final TherapistModel therapist = TherapistModel.fromEntity(newProfile as TherapistEntity);
        return updateTherapist(therapist);
      }

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } on StorageFailure {
      rethrow; 
    } on CoreFailure {
      rethrow;
    } catch (e) {
      print("unknown error : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future updateGeneral(GeneralModel generalNewProfile) async {
    try {
      await supabase
        .from("general")
        .update(generalNewProfile.toMapGeneral())
        .eq("id", generalNewProfile.id);
    }
    on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      print("unknown error : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future updateTherapist(TherapistModel therapistNewProfile) async {
    try {
      await supabase
        .from("therapist")
        .update(therapistNewProfile.toMapTherapist())
        .eq("id", therapistNewProfile.id);
    }
    on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      print("unknown error : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }

  // Upload Image Profile
  Future<String?> uploadImg(ImageEntity? imgFile) async {
    if (imgFile == null) return null;

    try {
      final bytes = await imgFile.file!.readAsBytes();

      final extension = switch (imgFile.type) {
        'image/png'  => 'png',
        'image/webp' => 'webp',
      _            => 'jpg',
      };

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

      await supabase.storage
        .from('profile')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(
            contentType: imgFile.type ?? 'image/jpeg'
          )
        );

      final url = supabase.storage.from('profile').getPublicUrl(fileName);

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
}