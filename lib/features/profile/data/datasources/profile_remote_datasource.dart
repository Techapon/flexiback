import 'package:flexiback/core/exception/profile/profile_failure.dart';
import 'package:flexiback/features/profile/data/models/therapist_model.dart';
import 'package:flexiback/shared/entities/role_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exception/core_exception/core_error_failure.dart';
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
}