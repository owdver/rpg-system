/// Custom exceptions for the RPG System application.
sealed class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (Caused by: $cause)' : ''}';
}

/// Network-related exceptions.
final class NetworkException extends AppException {
  const NetworkException(
    super.message, [
    this.statusCode,
    super.cause,
  ]);

  final int? statusCode;
}

/// Authentication and authorization exceptions.
final class AuthException extends AppException {
  const AuthException(super.message, [super.cause]);

  static const invalidCredentials =
      AuthException('Invalid credentials provided');
  static const notAuthenticated = AuthException('User is not authenticated');
  static const sessionExpired = AuthException('Session has expired');
  static const permissionDenied = AuthException('Permission denied');
}

/// Data persistence and storage exceptions.
final class StorageException extends AppException {
  const StorageException(super.message, [super.cause]);

  static const readFailed = StorageException('Failed to read from storage');
  static const writeFailed = StorageException('Failed to write to storage');
  static const notFound = StorageException('Requested data not found');
  static const corrupted = StorageException('Data corruption detected');
}

/// Health data integration exceptions.
final class HealthIntegrationException extends AppException {
  const HealthIntegrationException(super.message, [super.cause]);

  static const notAvailable =
      HealthIntegrationException('Health integration not available');
  static const permissionDenied =
      HealthIntegrationException('Health data permission denied');
  static const syncFailed =
      HealthIntegrationException('Health data sync failed');
  static const incompatibleData =
      HealthIntegrationException('Incompatible health data format');
}

/// Sync and offline operation exceptions.
final class SyncException extends AppException {
  const SyncException(super.message, [super.cause]);

  static const conflictDetected =
      SyncException('Data conflict detected during sync');
  static const networkUnavailable =
      SyncException('Network unavailable for sync');
  static const queueFull = SyncException('Sync queue is full');
  static const invalidOperation = SyncException('Invalid sync operation');
}

/// Validation and business logic exceptions.
final class ValidationException extends AppException {
  const ValidationException(super.message, [super.cause, this.field]);

  final String? field;
}

/// Feature-specific exceptions.
final class MissionException extends AppException {
  const MissionException(super.message, [super.cause]);

  static const invalidState = MissionException('Invalid mission state');
  static const alreadyCompleted = MissionException('Mission already completed');
  static const expired = MissionException('Mission has expired');
}

final class WorkoutException extends AppException {
  const WorkoutException(super.message, [super.cause]);

  static const invalidExercise = WorkoutException('Invalid exercise specified');
  static const sessionNotActive = WorkoutException('No active workout session');
  static const trackerUnavailable =
      WorkoutException('Workout tracker unavailable');
}

final class RecoveryException extends AppException {
  const RecoveryException(super.message, [super.cause]);

  static const insufficientData =
      RecoveryException('Insufficient data for recovery calculation');
  static const invalidMetric = RecoveryException('Invalid recovery metric');
}

/// System-level exceptions.
final class SystemException extends AppException {
  const SystemException(super.message, [super.cause]);

  static const initializationFailed =
      SystemException('System initialization failed');
  static const serviceUnavailable =
      SystemException('Required service unavailable');
  static const configurationError = SystemException('Configuration error');
}
