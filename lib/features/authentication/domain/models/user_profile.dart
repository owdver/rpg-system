import 'package:equatable/equatable.dart';

/// Represents the user's profile and identity within the system.
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    this.displayName = '',
    this.avatarUrl = '',
    this.title = '',
    this.level = 1,
    this.currentXp = 0,
    this.totalXp = 0,
    this.rank = '',
    this.unlockedTitles = const [],
    this.equippedCosmetics = const [],
    this.preferences = const {},
    this.healthIntegration = const HealthIntegrationStatus(),
    this.onboardingCompleted = false,
    this.createdAt,
    this.lastActiveAt,
  });

  final String id;
  final String email;
  final String displayName;
  final String avatarUrl;
  final String title;
  final int level;
  final int currentXp;
  final int totalXp;
  final String rank;
  final List<String> unlockedTitles;
  final List<String> equippedCosmetics;
  final Map<String, dynamic> preferences;
  final HealthIntegrationStatus healthIntegration;
  final bool onboardingCompleted;
  final DateTime? createdAt;
  final DateTime? lastActiveAt;

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? title,
    int? level,
    int? currentXp,
    int? totalXp,
    String? rank,
    List<String>? unlockedTitles,
    List<String>? equippedCosmetics,
    Map<String, dynamic>? preferences,
    HealthIntegrationStatus? healthIntegration,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      title: title ?? this.title,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      totalXp: totalXp ?? this.totalXp,
      rank: rank ?? this.rank,
      unlockedTitles: unlockedTitles ?? this.unlockedTitles,
      equippedCosmetics: equippedCosmetics ?? this.equippedCosmetics,
      preferences: preferences ?? this.preferences,
      healthIntegration: healthIntegration ?? this.healthIntegration,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        title,
        level,
        currentXp,
        totalXp,
        rank,
        unlockedTitles,
        equippedCosmetics,
        preferences,
        healthIntegration,
        onboardingCompleted,
        createdAt,
        lastActiveAt,
      ];
}

/// Represents the status of health data integrations.
class HealthIntegrationStatus extends Equatable {
  const HealthIntegrationStatus({
    this.appleHealthConnected = false,
    this.healthConnectConnected = false,
    this.lastSyncAt,
    this.enabledDataTypes = const {},
  });

  final bool appleHealthConnected;
  final bool healthConnectConnected;
  final DateTime? lastSyncAt;
  final Map<String, bool> enabledDataTypes;

  @override
  List<Object?> get props => [
        appleHealthConnected,
        healthConnectConnected,
        lastSyncAt,
        enabledDataTypes,
      ];
}

/// User stats and capabilities.
class UserStats extends Equatable {
  const UserStats({
    this.totalWorkouts = 0,
    this.totalMinutes = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.averageRecovery = 0.0,
    this.statLevels = const {},
  });

  final int totalWorkouts;
  final int totalMinutes;
  final int currentStreak;
  final int longestStreak;
  final double averageRecovery;
  final Map<String, int> statLevels;

  @override
  List<Object?> get props => [
        totalWorkouts,
        totalMinutes,
        currentStreak,
        longestStreak,
        averageRecovery,
        statLevels,
      ];
}

/// Privacy settings for the user.
class PrivacySettings extends Equatable {
  const PrivacySettings({
    this.shareProgress = true,
    this.shareWorkouts = true,
    this.publicProfile = false,
    this.analyticsEnabled = true,
  });

  final bool shareProgress;
  final bool shareWorkouts;
  final bool publicProfile;
  final bool analyticsEnabled;

  @override
  List<Object?> get props => [
        shareProgress,
        shareWorkouts,
        publicProfile,
        analyticsEnabled,
      ];
}
