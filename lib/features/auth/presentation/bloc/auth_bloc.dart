import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_id/features/auth/domain/usecases/get_access_token.dart';
import 'package:my_id/features/auth/domain/usecases/get_user_details.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_state.dart';
import 'package:my_id/env.dart';
import 'package:myid/enums.dart';
import 'package:myid/myid.dart';
import 'package:myid/myid_config.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAccessToken getAccessToken;
  final GetUserDetails getUserDetails;

  AuthBloc({
    required this.getAccessToken,
    required this.getUserDetails,
  }) : super(AuthInitial()) {
    on<StartSdkEvent>(_onStartSdkEvent);
    on<GetAccessTokenEvent>(_onGetAccessTokenEvent);
    on<FetchUserDetailsEvent>(_onFetchUserDetailsEvent);
  }

  Future<void> _onStartSdkEvent(
    StartSdkEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final clientId = Env.clientId;
      final clientHashId = Env.clientHashId;
      final clientHash = Env.clientHash;
      
      final myIdResult = await MyIdClient.start(
        config: MyIdConfig(
          clientId: clientId,
          clientHash: clientHash,
          clientHashId: clientHashId,
          environment: MyIdEnvironment.PRODUCTION,
          entryType: MyIdEntryType.IDENTIFICATION,
        ),
        iosAppearance: const MyIdIOSAppearance(),
      );

      if (myIdResult.code != null) {
        add(GetAccessTokenEvent(myIdResult.code!));
      } else {
        emit(const AuthError('MyID SDK failed to return a code.'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGetAccessTokenEvent(
    GetAccessTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await getAccessToken(event.authorizationCode);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (accessToken) => add(FetchUserDetailsEvent(accessToken)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onFetchUserDetailsEvent(
    FetchUserDetailsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await getUserDetails(event.accessToken);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
