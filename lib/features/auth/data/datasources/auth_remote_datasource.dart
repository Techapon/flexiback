import 'package:flexiback/core/exception/auth_exception/auth_error_mapper.dart';
import 'package:flexiback/core/exception/auth_exception/auth_failure.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/auth/data/models/user_model.dart';
import 'package:flexiback/shared/entities/role_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/utils/get_role.dart';

class AuthRemoteDataSource {
  final supabase = Supabase.instance.client;

  Future<UserModel> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password
      );

      final user = res.user;

      if (user == null) throw CoreFailure.unknown("Login failed! User not found");

      late Map<String, dynamic> userProfile;
      try {
        userProfile = await supabase
          .from("profiles")
          .select()
          .eq("id", user.id)
          .single();
      } on PostgrestException catch(e) {
        throw CoreFailure.databaseError(e.message);
      }

      if (userProfile.isEmpty) {
        throw CoreFailure.unknown("User profile not found in database");
      }

      Role role = getRole(userProfile["role"]);

      return UserModel(
        id: user.id,
        email: user.email!,
        role: role
      );

    }
    on AuthException  catch (e) {
      throw AuthErrorMapper.fromAuthException(e);
    }
    on CoreFailure catch (e) {
      rethrow;
    }
    catch (_) {
      throw CoreFailure.network();
    }
  }

  Future<UserModel> signup(String email, String password, Role role) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password
      );

      final user = response.user;

      if (user == null) throw CoreFailure.unknown("Signup failed! User not found");

      if (user.identities != null && user.identities!.isEmpty) {
        throw AuthFailure.emailAlreadyInUse();
      }

      final userId = user.id;

      try {
        // insert profiles 
        await supabase.from("profiles").insert({
          "id" : userId,
          "role" : role.entity,
          "title" : null,
          "first_name" : null,
          "last_name" : null,
          "gender" : null,
          "age" : null,
          "number" : null,
          "img_src" : null,
        });

        // Insert Role
        if (role == Role.General) {
          await supabase.from(Role.General.entity).insert({
            "id" : userId,
            "weight" : null,
            "height" : null,
            "pmh" : null,
          });
        } else if (role == Role.Therapist) {
          await supabase.from(Role.Therapist.entity).insert({
            "id" : userId,
            "specialty" : null,
            "affiliation" : null,
            "institution" : null,
            "experience" : null,
          });
        }

      } on PostgrestException  catch(e) {
        await supabase.auth.signOut();
        throw CoreFailure.databaseError(e.message);
      }
    
      return UserModel(
        id: user.id,
        email: user.email!,
        role: role
      );

    } 
    on AuthException  catch (e) {
      throw AuthErrorMapper.fromAuthException(e);
    } 
    on CoreFailure {
      rethrow;
    } 
    catch (e) {
      throw CoreFailure.network();
    }
  }

  // Future<void> signout() async {
  //   try {
  //     await supabase.auth.signOut();
  //   } on AuthException  catch (e) {
  //     throw AuthErrorMapper.fromAuthException(e);
  //   } catch (_) {
  //     throw AuthFailure.network();
  //   }
  // }

  // Future<UserModel> getCurrentUser() async {
  //   try {
  //     final user = supabase.auth.currentUser;

  //     if (user == null) {
  //       throw AuthFailure.sessionExpired();
  //     }

  //     return UserModel(
  //       id: user.id,
  //       email: user.email!
  //     );

  //   } on AuthFailure {
  //     rethrow;
  //   } on AuthException catch (e) {
  //     throw AuthErrorMapper.fromAuthException(e);
  //   } catch (_) {
  //     throw AuthFailure.network();
  //   }
  // }

}