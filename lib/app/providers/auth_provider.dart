import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/domain/models/user_profile.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';

/// Authentication status enum.
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

/// Authentication state model.
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
    this.isLoading = false,
  });

  final AuthStatus status;
  final UserProfile? user;
  final String? error;
  final bool isLoading;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier for authentication state management.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  /// Initialize authentication state.
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  /// Sign in with email and password.
  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signInWithEmail(email, password);
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Sign in with Google.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signInWithGoogle();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Sign up with email and password.
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signUpWithEmail(
        email,
        password,
        displayName,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authRepository.signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update user profile.
  Future<bool> updateProfile(UserProfile profile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedProfile = await _authRepository.updateProfile(profile);
      state = AuthState(
        status: AuthStatus.authenticated,
        user: updatedProfile,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

/// Provider for the authentication repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provider for the auth state notifier.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Convenience provider for auth status.
final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authNotifierProvider).status;
});

/// Convenience provider for the current user.
final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authNotifierProvider).user;
});
