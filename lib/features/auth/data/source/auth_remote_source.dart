import 'package:blog_app/core/error/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<String> loginWithEmailAndPassword({
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
          final userID = response.user?.id ?? '';
          return userID;
        })
        .catchError((error) {
          throw ServerException(
            'Login failed. Please check your credentials and try again.',
          );
        });
  }

  @override
  Future<String> signUpWithEmailAndPassword({
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
    final userID = response.user?.id ?? '';
    return userID;
  }
}
