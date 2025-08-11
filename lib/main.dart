import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:my_id/env.dart';
import 'package:myid/enums.dart';
import 'package:myid/myid.dart';
import 'package:myid/myid_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

void main() {
  // Setup Dio with the logger interceptor
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

  // Initialize data source and repository
  final myIdDataSource = MyIdDataSource(dio);
  final authRepository = AuthRepositoryImpl(myIdDataSource);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: authRepository),
      child: MaterialApp(
        title: 'MyID App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}

// --------------------------- DOMAIN LAYER ---------------------------

// lib/domain/entities/user.dart
// This file defines the User entity, which represents the core
// business object in our application. It uses equatable for value comparison.

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String? middleName;

  const User({
    required this.firstName,
    required this.lastName,
    this.middleName,
  });

  @override
  List<Object?> get props => [firstName, lastName, middleName];
}

// lib/domain/repositories/auth_repository.dart
// This file defines the abstract contract for the authentication repository.
// It is an interface that the data layer will implement.

abstract class AuthRepository {
  Future<String> getAccessToken(String authorizationCode);

  Future<User> getUserDetails(String accessToken);
}

// --------------------------- DATA LAYER ---------------------------

// lib/data/datasources/myid_data_source.dart
// This file handles the communication with the external API using Dio.
// It is responsible for making the network calls and returning the raw data.

class MyIdDataSource {
  final Dio _dio;

  static const _accessTokenUrl = 'https://myid.uz/api/v1/oauth2/access-token';
  static const _userProfileUrl = 'https://myid.uz/api/v1/users/me';
  static final _clientId = Env.clientId;
  static final _clientSecret = Env.clientSecret;

  MyIdDataSource(this._dio);

  Future<AccessTokenModel> getAccessToken(String authorizationCode) async {
    try {
      final response = await _dio.post(
        _accessTokenUrl,
        data: {
          'grant_type': 'authorization_code',
          'code': authorizationCode,
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return AccessTokenModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get access token: ${e.message}');
    }
  }

  Future<UserModel> getUserDetails(String accessToken) async {
    try {
      final response = await _dio.get(
        _userProfileUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user details: ${e.message}');
    }
  }
}

// lib/data/models/access_token_model.dart
// This file defines the data model for the access token, which is
// a direct representation of the JSON response from the API.

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

// lib/data/models/user_model.dart
// This file defines the data model for the user profile, representing
// the JSON response from the API. It can also be mapped to the domain User entity.

class UserModel extends User {
  const UserModel({
    required super.firstName,
    required super.lastName,
    super.middleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['profile']['common_data']['first_name'].toString(),
      lastName: json['profile']['common_data']['last_name'].toString(),
      middleName: json['profile']['common_data']['middle_name'].toString(),
    );
  }
}

// lib/data/repositories/auth_repository_impl.dart
// This file is the concrete implementation of the AuthRepository interface.
// It acts as a bridge between the data source and the domain layer,
// translating data models into domain entities.

class AuthRepositoryImpl implements AuthRepository {
  final MyIdDataSource _myIdDataSource;

  AuthRepositoryImpl(this._myIdDataSource);

  @override
  Future<String> getAccessToken(String authorizationCode) async {
    try {
      final accessTokenModel = await _myIdDataSource.getAccessToken(
        authorizationCode,
      );
      return accessTokenModel.accessToken;
    } catch (e) {
      // Re-throw the exception to be handled by the presentation layer
      rethrow;
    }
  }

  @override
  Future<User> getUserDetails(String accessToken) async {
    try {
      final userModel = await _myIdDataSource.getUserDetails(accessToken);
      // Directly return the UserModel as it extends the User entity
      return userModel;
    } catch (e) {
      // Re-throw the exception to be handled by the presentation layer
      rethrow;
    }
  }
}

// --------------------------- PRESENTATION LAYER ---------------------------

// lib/presentation/bloc/auth_bloc.dart
// This file contains the AuthBloc, which manages the application state
// for the authentication process. It handles events and emits new states.

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
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
      // MyID SDK initialization from the provided code
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
      final accessToken = await authRepository.getAccessToken(
        event.authorizationCode,
      );
      add(FetchUserDetailsEvent(accessToken));
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
      final user = await authRepository.getUserDetails(event.accessToken);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

// lib/presentation/bloc/auth_event.dart
// This file defines the events that can be dispatched to the AuthBloc.
// Events are user actions or system events that trigger a state change.

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

// lib/presentation/bloc/auth_state.dart
// This file defines the possible states of the authentication flow.
// States represent the UI state at any given moment.

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// lib/presentation/pages/home_page.dart
// This file contains the initial UI widget that the user interacts with.
// It dispatches events and listens to state changes from the AuthBloc.

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onStartSdk(BuildContext context) {
    context.read<AuthBloc>().add(StartSdkEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyID Authentication')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserDetailsPage(user: state.user),
              ),
            );
          } else if (state is AuthError) {
            debugPrint("${state.message} bu xatolik");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is AuthLoading) const CircularProgressIndicator(),
                  if (state is! AuthLoading)
                    MaterialButton(
                      onPressed: () => _onStartSdk(context),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: const Text('Start SDK'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// lib/presentation/pages/user_details_page.dart
// This file displays the user's profile information after a successful
// authentication flow.

class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.firstName}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('First Name: ${user.firstName}'),
            Text('Last Name: ${user.lastName}'),
            Text('Middle Name: ${user.middleName ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
