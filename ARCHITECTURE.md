# MyID Flutter App - Clean Architecture Documentation

## Overview

This Flutter application implements Clean Architecture principles with a feature-first approach. The app provides MyID authentication functionality using the official MyID SDK and follows best practices for maintainable, scalable, and testable code.

## Architecture Overview

The application follows Clean Architecture principles with three main layers:

1. **Domain Layer** - Business logic and entities
2. **Data Layer** - Data sources and repositories
3. **Presentation Layer** - UI components and state management

## Project Structure

```
lib/
├── core/                           # Shared components and utilities
│   ├── constants/                  # Application constants
│   ├── di/                        # Dependency injection
│   ├── errors/                    # Error handling
│   └── network/                   # Network utilities
├── features/                      # Feature-based modules
│   └── auth/                      # Authentication feature
│       ├── data/                  # Data layer for auth
│       │   ├── datasources/       # API data sources
│       │   ├── models/            # Data models
│       │   └── repositories/      # Repository implementations
│       ├── domain/                # Domain layer for auth
│       │   ├── entities/          # Business entities
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/         # Business logic use cases
│       └── presentation/          # Presentation layer for auth
│           ├── bloc/              # State management
│           ├── pages/             # Screen widgets
│           └── widgets/           # Reusable UI components
└── main.dart                      # Application entry point
```

## Layer Details

### 1. Domain Layer (`lib/features/auth/domain/`)

The domain layer contains the core business logic and is independent of external frameworks.

#### Entities
- **User** (`entities/user.dart`): Core business object representing a user with first name, last name, and optional middle name.

#### Repository Interfaces
- **AuthRepository** (`repositories/auth_repository.dart`): Abstract contract defining authentication operations.

#### Use Cases
- **GetAccessToken** (`usecases/get_access_token.dart`): Business logic for obtaining access tokens.
- **GetUserDetails** (`usecases/get_user_details.dart`): Business logic for fetching user information.

### 2. Data Layer (`lib/features/auth/data/`)

The data layer implements the repository interfaces and handles data operations.

#### Data Sources
- **MyIdDataSource** (`datasources/myid_data_source.dart`): Handles API communication with MyID services.

#### Models
- **AccessTokenModel** (`models/access_token_model.dart`): Data representation of access token responses.
- **UserModel** (`models/user_model.dart`): Data representation of user profile responses.

#### Repository Implementations
- **AuthRepositoryImpl** (`repositories/auth_repository_impl.dart`): Concrete implementation of the auth repository.

### 3. Presentation Layer (`lib/features/auth/presentation/`)

The presentation layer manages UI state and user interactions.

#### State Management (BLoC)
- **AuthBloc** (`bloc/auth_bloc.dart`): Manages authentication state and business logic coordination.
- **AuthEvent** (`bloc/auth_event.dart`): Defines events that can be dispatched to the bloc.
- **AuthState** (`bloc/auth_state.dart`): Defines the possible states of the authentication flow.

#### Pages
- **HomePage** (`pages/home_page.dart`): Main authentication screen with SDK start button.
- **UserDetailsPage** (`pages/user_details_page.dart`): Displays user information after successful authentication.

#### Widgets
- **AuthButton** (`widgets/auth_button.dart`): Reusable authentication button component.

## Core Components

### Dependency Injection (`lib/core/di/injection_container.dart`)

Uses GetIt for dependency injection, managing all dependencies in a centralized location:

- BLoC registration
- Use case registration
- Repository registration
- Data source registration
- External service configuration (Dio, PrettyDioLogger)

### Error Handling (`lib/core/errors/failures.dart`)

Implements a failure-based error handling system:

- **Failure**: Abstract base class for all failures
- **ServerFailure**: For server-related errors
- **NetworkFailure**: For network connectivity issues
- **AuthFailure**: For authentication-specific errors

### Constants (`lib/core/constants/app_constants.dart`)

Centralized application constants:

- API URLs
- App information
- Error messages

## Data Flow

1. **User Interaction**: User taps "Start SDK" button on HomePage
2. **Event Dispatch**: StartSdkEvent is dispatched to AuthBloc
3. **SDK Initialization**: MyID SDK is initialized with configuration
4. **Token Exchange**: Authorization code is exchanged for access token
5. **User Data Fetch**: User profile is fetched using the access token
6. **State Update**: UI is updated based on the new state
7. **Navigation**: User is navigated to UserDetailsPage on success

## Key Features

### MyID Integration
- OAuth 2.0 authorization code flow
- Secure token exchange
- User profile retrieval
- Production environment support

### State Management
- BLoC pattern for predictable state management
- Event-driven architecture
- Clear separation of concerns

### Error Handling
- Comprehensive error handling with failure objects
- User-friendly error messages
- Graceful degradation

### Dependency Injection
- Centralized dependency management
- Easy testing and mocking
- Loose coupling between components

## Testing Strategy

The architecture supports comprehensive testing:

- **Unit Tests**: Test use cases, repositories, and data sources in isolation
- **Widget Tests**: Test UI components
- **Integration Tests**: Test feature workflows
- **Mocking**: Easy mocking of dependencies for testing

## Getting Started

### Prerequisites
- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure environment variables in `lib/env.dart`
4. Run the application with `flutter run`

### Environment Configuration
Create a `lib/env.dart` file with your MyID credentials:

```dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'CLIENT_ID')
  static const String clientId = _Env.clientId;
  
  @EnviedField(varName: 'CLIENT_SECRET')
  static const String clientSecret = _Env.clientSecret;
  
  @EnviedField(varName: 'CLIENT_HASH_ID')
  static const String clientHashId = _Env.clientHashId;
  
  @EnviedField(varName: 'CLIENT_HASH')
  static const String clientHash = _Env.clientHash;
}
```

## Best Practices Implemented

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Inversion**: High-level modules don't depend on low-level modules
3. **Single Responsibility**: Each class has one reason to change
4. **Open/Closed Principle**: Open for extension, closed for modification
5. **Interface Segregation**: Clients depend only on interfaces they use
6. **Dependency Injection**: Dependencies are injected, not created

## Future Enhancements

1. **Local Storage**: Implement secure local storage for tokens
2. **Token Refresh**: Add automatic token refresh functionality
3. **Offline Support**: Implement offline-first architecture
4. **Analytics**: Add user behavior tracking
5. **Deep Linking**: Support deep linking for authentication flows
6. **Biometric Authentication**: Add biometric authentication support

## Contributing

When contributing to this project:

1. Follow the established architecture patterns
2. Add tests for new functionality
3. Update documentation for new features
4. Follow Flutter coding standards
5. Use meaningful commit messages

## Troubleshooting

### Common Issues

1. **SDK Initialization Failed**: Check environment variables and network connectivity
2. **Token Exchange Failed**: Verify client credentials and authorization code
3. **User Data Fetch Failed**: Ensure access token is valid and not expired

### Debug Mode
Enable debug logging by checking the console output for detailed error messages and API request/response logs.

## License

This project is proprietary and confidential. All rights reserved.

---

**Note**: This documentation should be updated whenever the architecture changes or new features are added to maintain clarity for other developers.
