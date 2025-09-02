import 'package:equatable/equatable.dart';

class AccessTokenModel extends Equatable {
  final String accessToken;
  final String tokenType;

  const AccessTokenModel({required this.accessToken, required this.tokenType});

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }

  @override
  List<Object> get props => [accessToken, tokenType];
}
