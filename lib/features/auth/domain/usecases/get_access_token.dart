import 'package:dartz/dartz.dart';
import 'package:my_id/core/errors/failures.dart';
import 'package:my_id/features/auth/domain/repositories/auth_repository.dart';

class GetAccessToken {
  final AuthRepository repository;

  GetAccessToken(this.repository);

  Future<Either<Failure, String>> call(String authorizationCode) async {
    return await repository.getAccessToken(authorizationCode);
  }
}
