import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_id/core/errors/failures.dart';
import 'package:my_id/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_id/features/auth/domain/usecases/get_access_token.dart';

import 'get_access_token_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late GetAccessToken usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetAccessToken(mockAuthRepository);
  });

  const tAuthorizationCode = 'test_authorization_code';
  const tAccessToken = 'test_access_token';

  test(
    'should get access token from the repository',
    () async {
      // arrange
      when(mockAuthRepository.getAccessToken(tAuthorizationCode))
          .thenAnswer((_) async => const Right(tAccessToken));

      // act
      final result = await usecase(tAuthorizationCode);

      // assert
      expect(result, const Right(tAccessToken));
      verify(mockAuthRepository.getAccessToken(tAuthorizationCode));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return failure when repository call is unsuccessful',
    () async {
      // arrange
      when(mockAuthRepository.getAccessToken(tAuthorizationCode))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // act
      final result = await usecase(tAuthorizationCode);

      // assert
      expect(result, const Left(ServerFailure('Server error')));
      verify(mockAuthRepository.getAccessToken(tAuthorizationCode));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
