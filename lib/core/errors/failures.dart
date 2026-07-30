import 'package:equatable/equatable.dart';
import 'exceptions.dart';

/// A type-safe result type for operations that can fail.
/// Inspired by functional programming patterns.
sealed class Result<T> extends Equatable {
  const Result();

  /// Returns true if this is a success result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result.
  bool get isFailure => this is Failure<T>;

  /// Maps the result to another type if success.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Success(transform(data)),
      Failure<T>(:final failureInfo) => Failure(failureInfo),
    };
  }

  /// Maps the result to another result if success.
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => transform(data),
      Failure<T>(:final failureInfo) => Failure(failureInfo),
    };
  }

  /// Gets the value or throws if failure.
  T getOrThrow() {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>(:final failureInfo) => throw failureInfo.exception,
    };
  }

  /// Gets the value or returns a default value.
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => defaultValue,
    };
  }

  /// Gets the value or computes a default value.
  T getOrCompute(T Function() compute) {
    return switch (this) {
      Success<T>(:final data) => data,
      Failure<T>() => compute(),
    };
  }

  /// Executes the appropriate callback based on the result.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure<T> failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Failure<T>(:final failureInfo) => onFailure(Failure(failureInfo)),
    };
  }

  /// Executes a callback if this is a success.
  void whenSuccess(void Function(T data) callback) {
    if (this case Success<T>(:final data)) {
      callback(data);
    }
  }

  /// Executes a callback if this is a failure.
  void whenFailure(void Function(Failure<T> failure) callback) {
    if (this case Failure<T>(:final failureInfo)) {
      callback(Failure(failureInfo));
    }
  }
}

/// Represents a successful result with associated data.
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

/// Represents a failed result with error information.
final class Failure<T> extends Result<T> {
  const Failure(this.failureInfo);

  final FailureInfo failureInfo;

  @override
  List<Object?> get props => [failureInfo];
}

/// Encapsulates failure information.
final class FailureInfo extends Equatable {
  const FailureInfo({
    required this.exception,
    this.context = const {},
    this.timestamp,
    this.recoverySuggestion,
  });

  final AppException exception;
  final Map<String, dynamic> context;
  final DateTime? timestamp;
  final String? recoverySuggestion;

  String get message => exception.message;

  @override
  List<Object?> get props =>
      [exception, context, timestamp, recoverySuggestion];

  /// Creates a FailureInfo from an AppException.
  static FailureInfo fromException(
    AppException exception, {
    Map<String, dynamic>? context,
    String? recoverySuggestion,
  }) {
    return FailureInfo(
      exception: exception,
      context: context ?? const {},
      timestamp: DateTime.now(),
      recoverySuggestion: recoverySuggestion,
    );
  }

  /// Creates a network failure.
  static FailureInfo network(String operation, {int? statusCode}) {
    return FailureInfo(
      exception: NetworkException(
        'Network error during $operation',
        statusCode,
      ),
      context: {'operation': operation, 'statusCode': statusCode},
      recoverySuggestion: 'Check your internet connection and try again.',
    );
  }

  /// Creates an auth failure.
  static FailureInfo auth(String message) {
    return FailureInfo(
      exception: AuthException(message),
      context: const {},
      recoverySuggestion: 'Please sign in again to continue.',
    );
  }

  /// Creates a storage failure.
  static FailureInfo storage(String operation) {
    return FailureInfo(
      exception: StorageException('Storage error during $operation'),
      context: {'operation': operation},
      recoverySuggestion:
          'Try clearing some storage space or restarting the app.',
    );
  }
}

/// Extension to convert exceptions to results.
extension ResultX<T> on T {
  Result<T> get asSuccess => Success(this);
}

extension ExceptionX on AppException {
  Result<T> asFailure<T>() => Failure(FailureInfo(exception: this));
}
