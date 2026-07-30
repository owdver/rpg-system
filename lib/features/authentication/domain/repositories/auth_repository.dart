import '../models/user_profile.dart';

/// Abstract repository interface for authentication operations.
/// This follows the repository pattern for clean architecture.
abstract class AuthRepository {
  /// Gets the currently authenticated user, or null if not authenticated.
  Future<UserProfile?> getCurrentUser();

  /// Signs in with email and password.
  Future<UserProfile> signInWithEmail(String email, String password);

  /// Signs in with Google authentication.
  Future<UserProfile> signInWithGoogle();

  /// Signs up with email and password.
  Future<UserProfile> signUpWithEmail(
    String email,
    String password,
    String displayName,
  );

  /// Signs out the current user.
  Future<void> signOut();

  /// Updates the user profile.
  Future<UserProfile> updateProfile(UserProfile profile);

  /// Sends a password reset email.
  Future<void> sendPasswordReset(String email);

  /// Deletes the user account.
  Future<void> deleteAccount();
}
