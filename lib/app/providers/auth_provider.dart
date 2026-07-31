import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/logger_service.dart';
import '../../features/authentication/domain/models/user_profile.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';

// Auth trace logger
final _trace = LoggerService.instance.getLogger('AuthProvider');

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
  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _trace.enter('AuthNotifier.new');
    _trace.exit('AuthNotifier.new');
  }

  final AuthRepository _authRepository;

  /// Initialize authentication state.
  Future<void> initialize() async {
    _trace.enter('AuthNotifier.initialize');
    state = state.copyWith(isLoading: true);

    try {
      _trace.debug('Getting current user from repository...');
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _trace.info('User authenticated: ${user.displayName}');
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        _trace.info('No authenticated user found');
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e, st) {
      _trace.failOperation('AuthNotifier.initialize', e, st);
      state = AuthState(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
    _trace.exit('AuthNotifier.initialize', state.status);
  }

  /// Sign in with email and password.
  Future<bool> signInWithEmail(String email, String password) async {
    _trace.enter('AuthNotifier.signInWithEmail', {'email': email});
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signInWithEmail(email, password);
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
      _trace.exit('AuthNotifier.signInWithEmail', true);
      return true;
    } catch (e, st) {
      _trace.failOperation('AuthNotifier.signInWithEmail', e, st);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _trace.exit('AuthNotifier.signInWithEmail', false);
      return false;
    }
  }

  /// Sign in with Google.
  Future<bool> signInWithGoogle() async {
    _trace.enter('AuthNotifier.signInWithGoogle');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRepository.signInWithGoogle();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );
      _trace.exit('AuthNotifier.signInWithGoogle', true);
      return true;
    } catch (e, st) {
      _trace.failOperation('AuthNotifier.signInWithGoogle', e, st);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _trace.exit('AuthNotifier.signInWithGoogle', false);
      return false;
    }
  }

  /// Sign up with email and password.
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    _trace.enter('AuthNotifier.signUpWithEmail', {'email': email, 'displayName': displayName});
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
      _trace.exit('AuthNotifier.signUpWithEmail', true);
      return true;
    } catch (e, st) {
      _trace.failOperation('AuthNotifier.signUpWithEmail', e, st);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _trace.exit('AuthNotifier.signUpWithEmail', false);
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    _trace.enter('AuthNotifier.signOut');
    state = state.copyWith(isLoading: true);

    try {
      await _authRepository.signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
      _trace.exit('AuthNotifier.signOut');
    } catch (e, st) {
      _trace.failOperation('AuthNotifier.signOut', e, st);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update user profile.
  Future<bool> updateProfile(UserProfile profile) async {
    _trace.enter('AuthNotifier.updateProfile');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedProfile = await _authRepository.updateProfile(profile);
      state = AuthState(
        status: AuthStatus.authenticated,
        user: updatedProfile,
      );
      _trace.exit('AuthNotifier.updateProfile', true);
      return true;
    } catch (e, st) {
      _trace.failOperation('AuthNotifier.updateProfile', e, st);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _trace.exit('AuthNotifier.updateProfile', false);
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
