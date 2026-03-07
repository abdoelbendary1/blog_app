import 'package:blog_app/core/error/app_exceptions.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  
  Session? get currentUserSession => supabaseClient.auth.currentSession;
  SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return supabaseClient.auth
        .signInWithPassword(email: email, password: password)
        .then((response) {
      if (response.user == null) {
        throw ServerException(
          'Login failed. Please check your credentials and try again.',
        );
      }
      final user = response.user?.toJson();
      return UserModel.fromJson(user ?? {});
    }).catchError((error) {
      throw ServerException(
        'Login failed. Please check your credentials and try again.',
      );
    });
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    if (response.user == null) {
      throw ServerException('User not created. Please try again later.');
    }
    final user = response.user?.toJson();
    return UserModel.fromJson(user ?? {});
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from("profiles")
            .select()
            .eq("id", currentUserSession!.user.id);
        final user = UserModel.fromJson(userData.first).copyWith(email: currentUserSession!.user.email);
        return user;
      }
      return null;
    } catch (e) {
      throw ServerException(
          'Failed to retrieve current user. Please try again later.');
    }
  }
}
