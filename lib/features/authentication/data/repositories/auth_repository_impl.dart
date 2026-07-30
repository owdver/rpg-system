import '../../domain/models/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using Firebase Authentication.
/// This is a placeholder implementation that would be connected to Firebase in production.
class AuthRepositoryImpl implements AuthRepository {
  UserProfile? _currentUser;

  @override
  Future<UserProfile?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<UserProfile> signInWithEmail(String email, String password) async {
    _currentUser = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
      level: 1,
      currentXp: 0,
      totalXp: 0,
      rank: 'Initiate',
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    _currentUser = UserProfile(
      id: 'user_google_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@gmail.com',
      displayName: 'Google User',
      level: 1,
      currentXp: 0,
      totalXp: 0,
      rank: 'Initiate',
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    _currentUser = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      level: 1,
      currentXp: 0,
      totalXp: 0,
      rank: 'Initiate',
      onboardingCompleted: false,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    _currentUser = profile;
    return _currentUser!;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    // Placeholder
  }

  @override
  Future<void> deleteAccount() async {
    _currentUser = null;
  }
}
