class AppConstants {
  // API URLs
  static const String baseUrl = 'https://myid.uz/api/v1';
  static const String accessTokenUrl = '$baseUrl/oauth2/access-token';
  static const String userProfileUrl = '$baseUrl/users/me';
  
  // App Info
  static const String appTitle = 'MyID App';
  static const String appVersion = '1.0.0';
  
  // Error Messages
  static const String failedToGetToken = 'Failed to get access token';
  static const String failedToGetUserDetails = 'Failed to get user details';
  static const String sdkFailedMessage = 'MyID SDK failed to return a code.';
}
