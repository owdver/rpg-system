import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Health data types supported by the integration.
enum HealthDataType {
  steps,
  heartRate,
  restingHeartRate,
  hrv,
  sleep,
  calories,
  weight,
  workouts,
  activeEnergy,
  distance,
}

extension HealthDataTypeExtension on HealthDataType {
  String get label {
    switch (this) {
      case HealthDataType.steps:
        return 'Steps';
      case HealthDataType.heartRate:
        return 'Heart Rate';
      case HealthDataType.restingHeartRate:
        return 'Resting Heart Rate';
      case HealthDataType.hrv:
        return 'Heart Rate Variability';
      case HealthDataType.sleep:
        return 'Sleep';
      case HealthDataType.calories:
        return 'Calories';
      case HealthDataType.weight:
        return 'Weight';
      case HealthDataType.workouts:
        return 'Workouts';
      case HealthDataType.activeEnergy:
        return 'Active Energy';
      case HealthDataType.distance:
        return 'Distance';
    }
  }

  String get unit {
    switch (this) {
      case HealthDataType.steps:
        return 'steps';
      case HealthDataType.heartRate:
        return 'bpm';
      case HealthDataType.restingHeartRate:
        return 'bpm';
      case HealthDataType.hrv:
        return 'ms';
      case HealthDataType.sleep:
        return 'hours';
      case HealthDataType.calories:
        return 'kcal';
      case HealthDataType.weight:
        return 'kg';
      case HealthDataType.workouts:
        return 'sessions';
      case HealthDataType.activeEnergy:
        return 'kcal';
      case HealthDataType.distance:
        return 'km';
    }
  }
}

/// Health data point.
class HealthDataPoint {
  const HealthDataPoint({
    required this.type,
    required this.value,
    required this.timestamp,
    this.endTimestamp,
  });

  final HealthDataType type;
  final double value;
  final DateTime timestamp;
  final DateTime? endTimestamp;

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'endTimestamp': endTimestamp?.toIso8601String(),
      };

  factory HealthDataPoint.fromJson(Map<String, dynamic> json) {
    return HealthDataPoint(
      type: HealthDataType.values[json['type'] as int],
      value: (json['value'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      endTimestamp: json['endTimestamp'] != null
          ? DateTime.parse(json['endTimestamp'] as String)
          : null,
    );
  }
}

/// Health sync status.
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
  offline,
}

extension SyncStatusExtension on SyncStatus {
  String get label {
    switch (this) {
      case SyncStatus.idle:
        return 'Idle';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.success:
        return 'Synced';
      case SyncStatus.error:
        return 'Error';
      case SyncStatus.offline:
        return 'Offline';
    }
  }
}

/// Health integration state.
class HealthIntegrationState {
  const HealthIntegrationState({
    this.isConnected = false,
    this.platform = '',
    this.lastSync,
    this.syncStatus = SyncStatus.idle,
    this.lastError,
    this.permissions = const {},
    this.data = const {},
    this.pendingSync = false,
  });

  final bool isConnected;
  final String platform;
  final DateTime? lastSync;
  final SyncStatus syncStatus;
  final String? lastError;
  final Map<HealthDataType, bool> permissions;
  final Map<HealthDataType, List<HealthDataPoint>> data;
  final bool pendingSync;

  bool hasPermission(HealthDataType type) => permissions[type] ?? false;

  List<HealthDataPoint> getData(HealthDataType type) => data[type] ?? [];

  HealthIntegrationState copyWith({
    bool? isConnected,
    String? platform,
    DateTime? lastSync,
    SyncStatus? syncStatus,
    String? lastError,
    Map<HealthDataType, bool>? permissions,
    Map<HealthDataType, List<HealthDataPoint>>? data,
    bool? pendingSync,
  }) {
    return HealthIntegrationState(
      isConnected: isConnected ?? this.isConnected,
      platform: platform ?? this.platform,
      lastSync: lastSync ?? this.lastSync,
      syncStatus: syncStatus ?? this.syncStatus,
      lastError: lastError,
      permissions: permissions ?? this.permissions,
      data: data ?? this.data,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toJson() => {
        'isConnected': isConnected,
        'platform': platform,
        'lastSync': lastSync?.toIso8601String(),
        'syncStatus': syncStatus.index,
        'lastError': lastError,
        'permissions': permissions.map((k, v) => MapEntry(k.index.toString(), v)),
        'pendingSync': pendingSync,
      };

  factory HealthIntegrationState.fromJson(Map<String, dynamic> json) {
    return HealthIntegrationState(
      isConnected: json['isConnected'] as bool? ?? false,
      platform: json['platform'] as String? ?? '',
      lastSync: json['lastSync'] != null
          ? DateTime.parse(json['lastSync'] as String)
          : null,
      syncStatus: SyncStatus.values[json['syncStatus'] as int? ?? 0],
      lastError: json['lastError'] as String?,
      permissions: (json['permissions'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(HealthDataType.values[int.parse(k)], v as bool)) ??
          {},
      pendingSync: json['pendingSync'] as bool? ?? false,
    );
  }
}

/// Health integration service for Health Connect and Apple HealthKit.
class HealthIntegrationService {
  HealthIntegrationService() : _state = const HealthIntegrationState();

  HealthIntegrationState _state;
  final _stateController = StreamController<HealthIntegrationState>.broadcast();
  Timer? _syncTimer;

  Stream<HealthIntegrationState> get stateStream => _stateController.stream;
  HealthIntegrationState get state => _state;

  /// Initialize the health integration.
  Future<bool> initialize() async {
    // In a real implementation, this would:
    // 1. Check if platform is Android (Health Connect) or iOS (HealthKit)
    // 2. Check if permissions are granted
    // 3. Connect to the health platform
    // 4. Start background sync

    _updateState(_state.copyWith(
      isConnected: true,
      platform: 'Health Connect', // or 'Apple HealthKit'
      syncStatus: SyncStatus.success,
      permissions: {
        for (final type in HealthDataType.values) type: true,
      },
    ));

    // Start background sync timer
    _startBackgroundSync();

    return true;
  }

  /// Request permissions for health data types.
  Future<bool> requestPermissions(List<HealthDataType> types) async {
    // In a real implementation, this would request permissions from Health Connect/HealthKit
    final newPermissions = Map<HealthDataType, bool>.from(_state.permissions);
    for (final type in types) {
      newPermissions[type] = true;
    }

    _updateState(_state.copyWith(permissions: newPermissions));
    return true;
  }

  /// Sync health data.
  Future<void> syncData() async {
    _updateState(_state.copyWith(syncStatus: SyncStatus.syncing));

    try {
      // In a real implementation, this would:
      // 1. Query Health Connect/HealthKit for data
      // 2. Process and store the data
      // 3. Update the game state

      // Simulate data sync
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate sample health data
      final newData = _generateSampleHealthData();

      _updateState(_state.copyWith(
        syncStatus: SyncStatus.success,
        lastSync: DateTime.now(),
        data: newData,
        pendingSync: false,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        syncStatus: SyncStatus.error,
        lastError: e.toString(),
      ));
    }
  }

  /// Force refresh data.
  Future<void> forceRefresh() async {
    await syncData();
  }

  /// Disconnect from health platform.
  Future<void> disconnect() async {
    _syncTimer?.cancel();
    _updateState(const HealthIntegrationState());
  }

  /// Get health data for a specific type.
  List<HealthDataPoint> getHealthData(HealthDataType type, {DateTime? since}) {
    final data = _state.data[type] ?? [];
    if (since == null) return data;
    return data.where((d) => d.timestamp.isAfter(since)).toList();
  }

  /// Convert health data to RecoveryMetrics.
  RecoveryMetrics toRecoveryMetrics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get sleep data
    final sleepData = getHealthData(HealthDataType.sleep, since: today.subtract(const Duration(hours: 12)));
    final totalSleep = sleepData.fold<double>(0, (sum, d) => sum + d.value);

    // Get HRV data
    final hrvData = getHealthData(HealthDataType.hrv, since: today);
    final avgHrv = hrvData.isNotEmpty ? hrvData.fold<double>(0, (sum, d) => sum + d.value) / hrvData.length : 0;

    // Get resting heart rate
    final hrData = getHealthData(HealthDataType.restingHeartRate, since: today);
    final restingHr = hrData.isNotEmpty ? hrData.last.value : 0;

    // Get steps
    final stepsData = getHealthData(HealthDataType.steps, since: today);
    final totalSteps = stepsData.fold<double>(0, (sum, d) => sum + d.value);

    return RecoveryMetrics(
      sleepHours: totalSleep,
      sleepQuality: totalSleep >= 7 ? 90 : (totalSleep >= 5 ? 70 : 50),
      hrvValue: avgHrv.round(),
      restingHeartRate: restingHr.round(),
      hydrationLevel: 80, // Would come from water tracking
      fatigueLevel: totalSteps < 5000 ? 60 : 30, // Simplified
      consecutiveTrainingDays: 0, // Would come from workout tracking
      stressLevel: 30, // Would come from HRV analysis
    );
  }

  void _startBackgroundSync() {
    // Sync every 30 minutes
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      syncData();
    });
  }

  void _updateState(HealthIntegrationState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  void dispose() {
    _syncTimer?.cancel();
    _stateController.close();
  }

  Map<HealthDataType, List<HealthDataPoint>> _generateSampleHealthData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      HealthDataType.steps: [
        HealthDataPoint(type: HealthDataType.steps, value: 8547, timestamp: now),
      ],
      HealthDataType.heartRate: [
        HealthDataPoint(type: HealthDataType.heartRate, value: 72, timestamp: now),
        HealthDataPoint(type: HealthDataType.heartRate, value: 68, timestamp: now.subtract(const Duration(hours: 1))),
      ],
      HealthDataType.restingHeartRate: [
        HealthDataPoint(type: HealthDataType.restingHeartRate, value: 58, timestamp: now),
      ],
      HealthDataType.hrv: [
        HealthDataPoint(type: HealthDataType.hrv, value: 45, timestamp: now),
      ],
      HealthDataType.sleep: [
        HealthDataPoint(
          type: HealthDataType.sleep,
          value: 7.5,
          timestamp: today.subtract(const Duration(hours: 8)),
          endTimestamp: today,
        ),
      ],
      HealthDataType.calories: [
        HealthDataPoint(type: HealthDataType.calories, value: 2150, timestamp: now),
      ],
      HealthDataType.activeEnergy: [
        HealthDataPoint(type: HealthDataType.activeEnergy, value: 485, timestamp: now),
      ],
      HealthDataType.workouts: [
        HealthDataPoint(type: HealthDataType.workouts, value: 1, timestamp: today),
      ],
    };
  }
}

/// Provider for health integration service.
final healthIntegrationProvider = StateNotifierProvider<HealthIntegrationNotifier, HealthIntegrationState>((ref) {
  final service = HealthIntegrationService();
  ref.onDispose(() => service.dispose());
  return HealthIntegrationNotifier(service);
});

class HealthIntegrationNotifier extends StateNotifier<HealthIntegrationState> {
  HealthIntegrationNotifier(this._service) : super(_service.state) {
    _subscription = _service.stateStream.listen((state) {
      this.state = state;
    });
  }

  final HealthIntegrationService _service;
  late final StreamSubscription<HealthIntegrationState> _subscription;

  Future<bool> initialize() => _service.initialize();

  Future<bool> requestPermissions(List<HealthDataType> types) =>
      _service.requestPermissions(types);

  Future<void> syncData() => _service.syncData();

  Future<void> forceRefresh() => _service.forceRefresh();

  Future<void> disconnect() => _service.disconnect();

  RecoveryMetrics getRecoveryMetrics() => _service.toRecoveryMetrics();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
