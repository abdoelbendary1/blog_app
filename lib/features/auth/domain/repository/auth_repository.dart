import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failures, void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}
