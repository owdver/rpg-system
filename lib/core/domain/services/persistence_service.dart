import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Keys for local storage.
class StorageKeys {
  static const xpState = 'xp_state';
  static const userStats = 'user_stats';
  static const progression = 'progression';
  static const missions = 'missions';
  static const activeMission = 'active_mission';
  static const workoutHistory = 'workout_history';
  static const recoveryState = 'recovery_state';
  static const achievements = 'achievements';
  static const eventHistory = 'event_history';
  static const userSettings = 'user_settings';
  static const lastSync = 'last_sync';
}

/// Simple persistence service using SharedPreferences-like interface.
/// In production, this would use Hive or SQLite for proper offline support.
class PersistenceService {
  final Map<String, dynamic> _storage = {};
  bool _initialized = false;

  static final PersistenceService _instance = PersistenceService._internal();
  factory PersistenceService() => _instance;
  PersistenceService._internal();

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    // In production, initialize Hive or SQLite here
    _initialized = true;
  }

  Future<void> save(String key, dynamic value) async {
    _storage[key] = value;
  }

  T? get<T>(String key) {
    return _storage[key] as T?;
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  Future<void> clear() async {
    _storage.clear();
  }

  // XP State
  Future<void> saveXPState(XPState state) async {
    await save(StorageKeys.xpState, state.toJson());
  }

  XPState? loadXPState() {
    final data = get<Map<String, dynamic>>(StorageKeys.xpState);
    return data != null ? XPState.fromJson(data) : null;
  }

  // User Stats
  Future<void> saveUserStats(UserStats stats) async {
    await save(StorageKeys.userStats, stats.toJson());
  }

  UserStats? loadUserStats() {
    final data = get<Map<String, dynamic>>(StorageKeys.userStats);
    return data != null ? UserStats.fromJson(data) : null;
  }

  // Progression State
  Future<void> saveProgression(ProgressionState state) async {
    await save(StorageKeys.progression, state.toJson());
  }

  ProgressionState? loadProgression() {
    final data = get<Map<String, dynamic>>(StorageKeys.progression);
    return data != null ? ProgressionState.fromJson(data) : null;
  }

  // Missions
  Future<void> saveMissions(List<Mission> missions) async {
    await save(StorageKeys.missions, missions.map((m) => m.toJson()).toList());
  }

  List<Mission> loadMissions() {
    final data = get<List<dynamic>>(StorageKeys.missions);
    return data
            ?.map((m) => Mission.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];
  }

  // Active Mission
  Future<void> saveActiveMission(Mission? mission) async {
    await save(StorageKeys.activeMission, mission?.toJson());
  }

  Mission? loadActiveMission() {
    final data = get<Map<String, dynamic>>(StorageKeys.activeMission);
    return data != null ? Mission.fromJson(data) : null;
  }

  // Workout History
  Future<void> saveWorkoutHistory(List<WorkoutSession> workouts) async {
    await save(
        StorageKeys.workoutHistory, workouts.map((w) => w.toJson()).toList());
  }

  List<WorkoutSession> loadWorkoutHistory() {
    final data = get<List<dynamic>>(StorageKeys.workoutHistory);
    return data
            ?.map((w) => WorkoutSession.fromJson(w as Map<String, dynamic>))
            .toList() ??
        [];
  }

  // Recovery State
  Future<void> saveRecoveryState(RecoveryState state) async {
    await save(StorageKeys.recoveryState, state.toJson());
  }

  RecoveryState? loadRecoveryState() {
    final data = get<Map<String, dynamic>>(StorageKeys.recoveryState);
    return data != null ? RecoveryState.fromJson(data) : null;
  }

  // Achievements
  Future<void> saveAchievements(AchievementState state) async {
    await save(StorageKeys.achievements, state.toJson());
  }

  AchievementState? loadAchievements() {
    final data = get<Map<String, dynamic>>(StorageKeys.achievements);
    return data != null ? AchievementState.fromJson(data) : null;
  }

  // Event History
  Future<void> saveEventHistory(List<SystemEvent> events) async {
    await save(
        StorageKeys.eventHistory, events.map((e) => e.toJson()).toList());
  }

  List<SystemEvent> loadEventHistory() {
    final data = get<List<dynamic>>(StorageKeys.eventHistory);
    return data
            ?.map((e) => SystemEvent.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  // Sync timestamp
  Future<void> saveLastSync(DateTime time) async {
    await save(StorageKeys.lastSync, time.toIso8601String());
  }

  DateTime? loadLastSync() {
    final data = get<String>(StorageKeys.lastSync);
    return data != null ? DateTime.parse(data) : null;
  }
}

/// Provider for persistence service.
final persistenceServiceProvider = Provider<PersistenceService>((ref) {
  return PersistenceService();
});
