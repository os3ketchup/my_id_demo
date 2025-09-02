import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:my_id/core/network/network_info.dart';
import 'package:my_id/features/auth/data/datasources/myid_data_source.dart';
import 'package:my_id/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_id/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_id/features/auth/domain/usecases/get_access_token.dart';
import 'package:my_id/features/auth/domain/usecases/get_user_details.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getAccessToken: sl(),
      getUserDetails: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAccessToken(sl()));
  sl.registerLazySingleton(() => GetUserDetails(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<MyIdDataSource>(
    () => MyIdDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    return dio;
  });
}
