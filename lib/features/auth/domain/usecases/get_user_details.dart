import 'package:dartz/dartz.dart';
import 'package:my_id/core/errors/failures.dart';
import 'package:my_id/features/auth/domain/entities/user.dart';
import 'package:my_id/features/auth/domain/repositories/auth_repository.dart';

class GetUserDetails {
  final AuthRepository repository;

  GetUserDetails(this.repository);

  Future<Either<Failure, User>> call(String accessToken) async {
    return await repository.getUserDetails(accessToken);
  }
}
