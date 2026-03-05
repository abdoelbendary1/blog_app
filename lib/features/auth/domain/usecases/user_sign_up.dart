import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements UseCase<String, UserSignUpParams> {
  AuthRepository authRepository;
  UserSignUp(this.authRepository);
  @override
  Future<Either<Failures, String>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  String name;
  String email;
  String password;
  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
