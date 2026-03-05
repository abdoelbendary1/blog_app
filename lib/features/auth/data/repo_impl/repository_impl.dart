import 'package:blog_app/core/error/app_exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/source/auth_remote_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class RepositoryImpl implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  RepositoryImpl({required this.authRemoteDataSource});
  @override
  Future<Either<Failures, String>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userID = await authRemoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userID);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failures, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userID = await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return Right(userID);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
