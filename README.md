# MyID Flutter App

A Flutter application implementing MyID authentication using Clean Architecture principles and feature-first organization.

## 🏗️ Architecture

This project follows **Clean Architecture** with a **feature-first** approach, ensuring:

- **Separation of Concerns**: Clear boundaries between layers
- **Testability**: Easy to write unit and integration tests
- **Maintainability**: Code is organized and easy to understand
- **Scalability**: Easy to add new features without affecting existing code

### Architecture Layers

1. **Domain Layer** - Business logic and entities
2. **Data Layer** - Data sources and repositories  
3. **Presentation Layer** - UI components and state management

## 📁 Project Structure

```
lib/
├── core/                           # Shared components
│   ├── constants/                  # App constants
│   ├── di/                        # Dependency injection
│   ├── errors/                    # Error handling
│   └── network/                   # Network utilities
├── features/                      # Feature modules
│   └── auth/                      # Authentication feature
│       ├── data/                  # Data layer
│       ├── domain/                # Business logic
│       └── presentation/          # UI layer
└── main.dart                      # App entry point
```

## 🚀 Features

- **MyID Authentication**: OAuth 2.0 flow with MyID SDK
- **Clean State Management**: BLoC pattern for predictable state
- **Error Handling**: Comprehensive error handling with failure objects
- **Dependency Injection**: Centralized dependency management
- **Responsive UI**: Material Design with custom components

## 🛠️ Tech Stack

- **Flutter** - UI framework
- **BLoC** - State management
- **Dio** - HTTP client
- **GetIt** - Dependency injection
- **Equatable** - Value equality
- **MyID SDK** - Official MyID integration

## 📋 Prerequisites

- Flutter SDK 3.8.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- MyID developer account

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd my_id
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   Create a `.env` file in the root directory:
   ```
   CLIENT_ID=your_client_id
   CLIENT_SECRET=your_client_secret
   CLIENT_HASH_ID=your_client_hash_id
   CLIENT_HASH=your_client_hash
   ```

4. **Generate environment file**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

1. **Launch the app** - You'll see the main authentication screen
2. **Tap "Start SDK"** - This initiates the MyID authentication flow
3. **Complete authentication** - Follow the MyID SDK prompts
4. **View user details** - After successful authentication, view your profile

## 🧪 Testing

The project supports comprehensive testing:

```bash
# Run unit tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/domain/usecases/get_access_token_test.dart
```

## 📚 Documentation

- **[Architecture Documentation](ARCHITECTURE.md)** - Detailed architecture explanation
- **[API Documentation](https://myid.uz/docs)** - MyID API reference
- **[Flutter Documentation](https://docs.flutter.dev)** - Flutter framework docs

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Flutter coding standards
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new functionality

## 🐛 Troubleshooting

### Common Issues

- **SDK Initialization Failed**: Check environment variables and network
- **Token Exchange Failed**: Verify client credentials
- **Build Errors**: Ensure all dependencies are properly installed

### Debug Mode

Enable debug logging to see detailed API requests and responses in the console.

## 📄 License

This project is proprietary and confidential. All rights reserved.

## 📞 Support

For support and questions:

- **Project Issues**: Use GitHub Issues
- **MyID Support**: Contact MyID developer support
- **Flutter Help**: Check Flutter community resources

## 🔄 Changelog

### v1.0.0
- Initial release with Clean Architecture
- MyID authentication integration
- BLoC state management
- Comprehensive error handling

---

**Built with ❤️ using Flutter and Clean Architecture**
