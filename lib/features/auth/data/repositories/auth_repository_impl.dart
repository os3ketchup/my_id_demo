import 'package:dartz/dartz.dart';
import 'package:my_id/core/errors/failures.dart';
import 'package:my_id/features/auth/data/datasources/myid_data_source.dart';
import 'package:my_id/features/auth/domain/entities/user.dart';
import 'package:my_id/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MyIdDataSource _myIdDataSource;

  AuthRepositoryImpl(this._myIdDataSource);

  @override
  Future<Either<Failure, String>> getAccessToken(String authorizationCode) async {
    try {
      final accessTokenModel = await _myIdDataSource.getAccessToken(
        authorizationCode,
      );
      return Right(accessTokenModel.accessToken);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserDetails(String accessToken) async {
    try {
      final userModel = await _myIdDataSource.getUserDetails(accessToken);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
