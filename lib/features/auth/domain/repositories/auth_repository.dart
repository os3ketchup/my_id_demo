import 'package:my_id/features/auth/domain/entities/user.dart';
import 'package:my_id/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> getAccessToken(String authorizationCode);
  Future<Either<Failure, User>> getUserDetails(String accessToken);
}
