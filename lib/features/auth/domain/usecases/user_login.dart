import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements UseCase<String, UserLoginParams> {
  AuthRepository authRepository;
  UserSignUp(this.authRepository);
  @override
  Future<Either<Failures, String>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  String email;
  String password;
  UserLoginParams({required this.email, required this.password});
}
