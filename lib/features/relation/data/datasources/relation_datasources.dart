import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/profile/data/models/general_model.dart';
import 'package:flexiback/features/profile/data/models/profile_model.dart';
import 'package:flexiback/features/profile/data/models/therapist_model.dart';
import 'package:flexiback/features/profile/domain/entities/general_entity.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/profile/presentation/pages/therapist_edit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RelationDatasources {
  final supabase = Supabase.instance.client;

  Future<List<ProfileEntity>> getTargetUserList(Role targetRole) async {
    try {
      final response  = await supabase
        .from("profiles")
        .select()
        .eq("role", targetRole.entity);

      final responseModel = response.map(
        (targetUser) => ProfileModel.fromMap(targetUser)
      ).toList();

      // Role
      List<Map<String, dynamic>> roleResponse;
      
      switch (targetRole) {
        case (Role.General) :
          roleResponse = await supabase
            .from("general")
            .select();
          break;

        case (Role.Therapist) :
          roleResponse = await supabase
            .from("therapist")
            .select();
          break;
      }

      switch (targetRole) {
        case (Role.General) :
          return responseModel.map(
            (targetUser) {

              final roleMap = roleResponse.singleWhere(
                (eachRole) => eachRole["id"] == targetUser.id
              );
              
              return GeneralModel.fromMap(targetUser, roleMap).toEntity();
            }
          ).cast<GeneralEntity>().toList();

        case (Role.Therapist) :
          return responseModel.map(
            (targetUser) {

              final roleMap = roleResponse.singleWhere(
                (eachRole) => eachRole["id"] == targetUser.id
              );
              
              return TherapistModel.fromMap(targetUser, roleMap).toEntity();
            }
          ).cast<TherapistEntity>().toList();
      }

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }
}