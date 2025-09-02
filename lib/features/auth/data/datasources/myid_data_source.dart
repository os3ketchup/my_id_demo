import 'package:dio/dio.dart';
import 'package:my_id/core/constants/app_constants.dart';
import 'package:my_id/features/auth/data/models/access_token_model.dart';
import 'package:my_id/features/auth/data/models/user_model.dart';
import 'package:my_id/env.dart';

abstract class MyIdDataSource {
  Future<AccessTokenModel> getAccessToken(String authorizationCode);
  Future<UserModel> getUserDetails(String accessToken);
}

class MyIdDataSourceImpl implements MyIdDataSource {
  final Dio _dio;

  MyIdDataSourceImpl(this._dio);

  @override
  Future<AccessTokenModel> getAccessToken(String authorizationCode) async {
    try {
      final response = await _dio.post(
        AppConstants.accessTokenUrl,
        data: {
          'grant_type': 'authorization_code',
          'code': authorizationCode,
          'client_id': Env.clientId,
          'client_secret': Env.clientSecret,
        },
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return AccessTokenModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${AppConstants.failedToGetToken}: ${e.message}');
    }
  }

  @override
  Future<UserModel> getUserDetails(String accessToken) async {
    try {
      final response = await _dio.get(
        AppConstants.userProfileUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${AppConstants.failedToGetUserDetails}: ${e.message}');
    }
  }
}
