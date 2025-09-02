import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class StartSdkEvent extends AuthEvent {}

class GetAccessTokenEvent extends AuthEvent {
  final String authorizationCode;

  const GetAccessTokenEvent(this.authorizationCode);

  @override
  List<Object> get props => [authorizationCode];
}

class FetchUserDetailsEvent extends AuthEvent {
  final String accessToken;

  const FetchUserDetailsEvent(this.accessToken);

  @override
  List<Object> get props => [accessToken];
}
