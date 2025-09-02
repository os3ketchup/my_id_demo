# Project Structure Overview

## 📁 Complete Directory Structure

```
my_id/
├── 📄 README.md                           # Project overview and setup instructions
├── 📄 ARCHITECTURE.md                     # Detailed architecture documentation
├── 📄 PROJECT_STRUCTURE.md                # This file - visual structure guide
├── 📄 pubspec.yaml                        # Flutter dependencies and configuration
├── 📄 analysis_options.yaml               # Dart analyzer configuration
│
├── 📁 android/                            # Android platform-specific code
│   ├── 📁 app/                           # Android app module
│   │   ├── 📁 src/                       # Source code
│   │   │   ├── 📁 main/                  # Main source set
│   │   │   │   ├── 📁 kotlin/            # Kotlin source files
│   │   │   │   │   └── 📁 uz/mOS/my_id/  # Package structure
│   │   │   │   │       └── 📄 MainActivity.kt
│   │   │   │   ├── 📁 res/               # Android resources
│   │   │   │   └── 📄 AndroidManifest.xml
│   │   │   ├── 📁 debug/                 # Debug configuration
│   │   │   └── 📁 profile/               # Profile configuration
│   │   └── 📄 build.gradle.kts           # App-level build configuration
│   ├── 📄 build.gradle.kts               # Project-level build configuration
│   ├── 📄 gradle.properties              # Gradle properties
│   └── 📁 gradle/wrapper/                # Gradle wrapper
│
├── 📁 ios/                                # iOS platform-specific code
│   ├── 📁 Flutter/                       # Flutter iOS configuration
│   ├── 📁 Runner/                        # iOS app runner
│   │   ├── 📁 Assets.xcassets/           # iOS assets
│   │   ├── 📁 Base.lproj/                # Base localization
│   │   ├── 📄 AppDelegate.swift           # iOS app delegate
│   │   └── 📄 Info.plist                 # iOS app info
│   ├── 📁 Runner.xcodeproj/              # Xcode project
│   └── 📁 Runner.xcworkspace/            # Xcode workspace
│
├── 📁 lib/                                # Main Dart source code
│   ├── 📄 main.dart                      # Application entry point
│   ├── 📄 env.dart                       # Environment configuration
│   ├── 📄 env.g.dart                     # Generated environment file
│   │
│   ├── 📁 core/                          # Shared core components
│   │   ├── 📁 constants/                 # Application constants
│   │   │   └── 📄 app_constants.dart     # App-wide constants
│   │   ├── 📁 di/                        # Dependency injection
│   │   │   └── 📄 injection_container.dart # DI container setup
│   │   ├── 📁 errors/                    # Error handling
│   │   │   └── 📄 failures.dart          # Failure classes
│   │   └── 📁 network/                   # Network utilities
│   │       └── 📄 network_info.dart      # Network connectivity
│   │
│   └── 📁 features/                      # Feature-based modules
│       └── 📁 auth/                      # Authentication feature
│           ├── 📁 data/                  # Data layer
│           │   ├── 📁 datasources/       # Data sources
│           │   │   └── 📄 myid_data_source.dart # MyID API client
│           │   ├── 📁 models/            # Data models
│           │   │   ├── 📄 access_token_model.dart # Token response model
│           │   │   └── 📄 user_model.dart # User profile model
│           │   └── 📁 repositories/      # Repository implementations
│           │       └── 📄 auth_repository_impl.dart # Auth repo impl
│           │
│           ├── 📁 domain/                # Domain layer (business logic)
│           │   ├── 📁 entities/          # Business entities
│           │   │   └── 📄 user.dart      # User business entity
│           │   ├── 📁 repositories/      # Repository interfaces
│           │   │   └── 📄 auth_repository.dart # Auth repo interface
│           │   └── 📁 usecases/          # Business logic use cases
│           │       ├── 📄 get_access_token.dart # Get token use case
│           │       └── 📄 get_user_details.dart # Get user use case
│           │
│           └── 📁 presentation/          # Presentation layer (UI)
│               ├── 📁 bloc/              # State management
│               │   ├── 📄 auth_bloc.dart # Authentication bloc
│               │   ├── 📄 auth_event.dart # Authentication events
│               │   └── 📄 auth_state.dart # Authentication states
│               ├── 📁 pages/             # Screen widgets
│               │   ├── 📄 home_page.dart # Main auth screen
│               │   └── 📄 user_details_page.dart # User profile screen
│               └── 📁 widgets/           # Reusable UI components
│                   └── 📄 auth_button.dart # Custom auth button
│
├── 📁 test/                               # Test files
│   └── 📁 features/                      # Feature tests
│       └── 📁 auth/                      # Auth feature tests
│           └── 📁 domain/                # Domain layer tests
│               └── 📁 usecases/          # Use case tests
│                   └── 📄 get_access_token_test.dart # Token test
│
└── 📁 .gitignore                          # Git ignore patterns
```

## 🏗️ Architecture Layers Visualization

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │    Pages    │  │   Widgets   │  │        BLoC         │ │
│  │             │  │             │  │                     │ │
│  │ HomePage    │  │ AuthButton  │  │    AuthBloc         │ │
│  │ UserDetails │  │             │  │    AuthEvent        │ │
│  └─────────────┘  └─────────────┘  │    AuthState        │ │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Entities  │  │ Repositories│  │      Use Cases      │ │
│  │             │  │             │  │                     │ │
│  │    User     │  │AuthRepository│  │  GetAccessToken     │ │
│  │             │  │             │  │  GetUserDetails     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Data Sources│  │   Models    │  │   Repositories      │ │
│  │             │  │             │  │                     │ │
│  │MyIdDataSource│ │AccessToken  │  │ AuthRepositoryImpl │ │
│  │             │  │UserModel    │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      EXTERNAL                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │     API     │  │     SDK     │  │    Dependencies     │ │
│  │             │  │             │  │                     │ │
│  │   MyID API  │  │  MyID SDK   │  │ Dio, GetIt, BLoC    │ │
│  │             │  │             │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow Diagram

```
User Action → Event → BLoC → Use Case → Repository → Data Source → API
    ↓
UI Update ← State ← BLoC ← Use Case ← Repository ← Data Source ← API
```

## 📱 Feature Organization

### Authentication Feature (`lib/features/auth/`)

The authentication feature is organized into three layers:

1. **Domain Layer** - Contains business logic and rules
2. **Data Layer** - Handles data operations and external API calls
3. **Presentation Layer** - Manages UI state and user interactions

### Core Components (`lib/core/`)

Shared components used across multiple features:

- **Constants** - Application-wide constants and configuration
- **Dependency Injection** - Centralized dependency management
- **Error Handling** - Common error types and failure handling
- **Network** - Network connectivity and utilities

## 🧪 Testing Structure

```
test/
└── features/
    └── auth/
        ├── data/           # Data layer tests
        ├── domain/         # Domain layer tests
        └── presentation/   # Presentation layer tests
```

Each layer has corresponding test files to ensure:
- **Unit Tests** - Test individual components in isolation
- **Integration Tests** - Test component interactions
- **Widget Tests** - Test UI components
- **Mocking** - Easy dependency mocking for testing

## 🔧 Build Configuration

- **Android**: Gradle with Kotlin DSL
- **iOS**: Xcode project with Swift
- **Flutter**: Standard Flutter project structure
- **Dependencies**: Managed via pubspec.yaml

## 📦 Package Management

- **Flutter Packages**: Managed via pubspec.yaml
- **Native Dependencies**: Managed via platform-specific build files
- **Code Generation**: Build runner for generated files
- **Environment**: Envied for secure configuration management

---

This structure ensures:
✅ **Maintainability** - Clear separation of concerns
✅ **Testability** - Easy to write and run tests
✅ **Scalability** - Simple to add new features
✅ **Readability** - Clear organization and naming
✅ **Reusability** - Shared components across features
