import 'package:flexiback/core/exception/auth_exception/auth_error_mapper.dart';
import 'package:flexiback/core/exception/auth_exception/auth_failure.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

      return UserModel(
        id: user.id,
        email: user.email!,
      );

    } 
    on AuthException  catch (e) {
      throw AuthErrorMapper.fromAuthException(e);
    } catch (_) {
      throw CoreFailure.network();
    }
  }

  Future<UserModel> signup(String email, String password) async {
    try {
      final respone = await supabase.auth.signUp(
        email: email,
        password: password
      );

      final user = respone.user;

      if (user == null) throw CoreFailure.unknown("Signup failed! User not found");

      if (user.identities != null && user.identities!.isEmpty) {
        throw AuthFailure.emailAlreadyInUse();
      }

      final userId = user.id;

      try {
        // insert profiles 
        await supabase.from("profiles").insert({
          "id" : userId,
          "role" : "general",
          "title" : null,
          "first_name" : null,
          "last_name" : null,
          "gender" : null,
          "age" : null,
          "number" : null,
          "img_src" : null,
        });

        //  insert patient
        await supabase.from("general").insert({
          "id" : userId,
          "weight" : null,
          "height" : null,
          "pmh" : null,
        });

      } on PostgrestException  catch(e) {
        // admin.deleteUser() requires service role key — sign out instead to clean up session
        await supabase.auth.signOut();
        print("1.---------------------------");
        print(e.message);
        throw CoreFailure.databaseError(e.message);
      }
    
      return UserModel(
        id: user.id,
        email: user.email!,
      );

    } on AuthFailure {
      rethrow;
    } on AuthException  catch (e) {
      throw AuthErrorMapper.fromAuthException(e);
    } catch (_) {
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