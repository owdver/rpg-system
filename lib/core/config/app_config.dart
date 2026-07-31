import 'package:flutter/foundation.dart';

/// Application configuration for different environments.
/// Configure these values based on your build environment.
abstract final class AppConfig {
  /// Whether this is a development build.
  static bool get isDevelopment => kDebugMode;

  /// Whether Firebase should be initialized.
  /// Set to false for development without Firebase.
  static bool get enableFirebase => !kDebugMode;

  /// Firebase configuration - replace with your values from Firebase Console.
  /// Get these from: Firebase Console > Project Settings > Your Apps > Web App
  static const String firebaseApiKey = 'YOUR_API_KEY';
  static const String firebaseProjectId = 'YOUR_PROJECT_ID';
  static const String firebaseAppId = 'YOUR_APP_ID';
  static const String firebaseMessagingSenderId = 'YOUR_SENDER_ID';
  static const String firebaseAuthDomain = 'YOUR_PROJECT.firebaseapp.com';
  static const String firebaseStorageBucket = 'YOUR_PROJECT.appspot.com';

  /// API endpoints (for future backend integration).
  static String get apiBaseUrl => isDevelopment
      ? 'http://localhost:8080/api'
      : 'https://api.yourproductionapp.com/api';

  /// Feature flags.
  static const bool enableHealthIntegration = true;
  static const bool enableAnalytics = !kDebugMode;
  static const bool enableCrashReporting = !kDebugMode;
}
