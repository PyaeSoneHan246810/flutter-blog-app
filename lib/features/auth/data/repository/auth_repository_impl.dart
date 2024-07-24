import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getFailureOrUser(
      () async => await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getFailureOrUser(
      () async => await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getFailureOrUser(
    Future<User> Function() func,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(message: Constants.noConnectionErrorMessage));
      }
      final user = await func();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    try {
      // if there is no internet connection
      if (!await connectionChecker.isConnected) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure(message: "User is not logged in"));
        }
        final user = UserModel(
          id: session.user.id,
          email: session.user.email ?? "",
          name: "",
        );
        return right(user);
      }
      // if there is internet connection
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure(message: "User is not logged in"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(message: Constants.noConnectionErrorMessage));
      }
      await authRemoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
