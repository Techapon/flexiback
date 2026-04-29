import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/profile/data/models/general_model.dart';
import 'package:flexiback/features/profile/data/models/profile_model.dart';
import 'package:flexiback/features/profile/data/models/therapist_model.dart';
import 'package:flexiback/features/profile/domain/entities/general_entity.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/profile/presentation/pages/therapist_edit.dart';
import 'package:flexiback/features/relation/data/models/relation_reqeuest_model.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RelationDatasources {
  final supabase = Supabase.instance.client;

  Future<List<ProfileEntity>> getTargetUserList(Role targetRole, {String? email}) async {
    try {
      var query = supabase
        .from("profiles")
        .select()
        .eq("role", targetRole.entity);
      
      if (email != null && email.isNotEmpty) {
        query = query.ilike("email", "%$email%");
      }
      
      final response = await query;

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

      return <ProfileEntity>[];

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<void> relationRequest(RelationReqeuestModel requestModel) async {
    try {
      final currentUser = supabase.auth.currentUser;
      final requesterId = currentUser?.id;

      if (requesterId == null) throw CoreFailure.unknown("User not authenticated");

      final existingRequest = await supabase
          .from("users_request")
          .select()
          .eq("requester_id", requesterId)
          .eq("recipient_id", requestModel.recipientId);

      if (existingRequest.isNotEmpty) {
        throw CoreFailure.unknown("Relation request already exists");
      }

      requestModel.requesterId = requesterId;

      await supabase.from("users_request").insert(requestModel.toMap());

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

  Future<List<RelationReqeuestEntity>> getSenderRequest() async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw CoreFailure.unknown("User not authenticated");

      final response = await supabase
          .from("users_request")
          .select()
          .eq("requester_id", userId);

      return response.map((request) => RelationReqeuestModel.fromMap(request).toEntity()).toList();

    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }

   Future<void> deleteRequest(String requestId) async {
    try {

      final response = await supabase
          .from("users_request")
          .delete()
          .eq("id", requestId);


    } on PostgrestException catch (e) {
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      throw CoreFailure.unknown(e.toString());
    }
  }
}