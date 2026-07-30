import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance metrics collector.
class PerformanceMonitor {
  PerformanceMonitor._();
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final List<FrameMetrics> _frameMetrics = [];
  static const int _maxSamples = 120;

  /// Start a new monitoring session.
  void startSession() {
    _frameMetrics.clear();
    _log('Performance monitoring session started');
  }

  /// Record a frame's metrics.
  void recordFrame(Duration buildDuration, Duration rasterDuration) {
    if (_frameMetrics.length >= _maxSamples) {
      _frameMetrics.removeAt(0);
    }
    _frameMetrics.add(FrameMetrics(
      timestamp: DateTime.now(),
      buildDuration: buildDuration,
      rasterDuration: rasterDuration,
    ));
  }

  /// Get current FPS estimate.
  double get currentFps {
    if (_frameMetrics.isEmpty) return 0;
    final recent = _frameMetrics.last;
    final totalDuration = recent.buildDuration + recent.rasterDuration;
    if (totalDuration.inMicroseconds == 0) return 120;
    return 1000000 / totalDuration.inMicroseconds;
  }

  /// Get average FPS over the session.
  double get averageFps {
    if (_frameMetrics.isEmpty) return 0;
    double total = 0;
    for (final metric in _frameMetrics) {
      final totalDuration = metric.buildDuration + metric.rasterDuration;
      if (totalDuration.inMicroseconds > 0) {
        total += 1000000 / totalDuration.inMicroseconds;
      }
    }
    return total / _frameMetrics.length;
  }

  /// Get frame time statistics.
  FrameStats get stats {
    if (_frameMetrics.isEmpty) {
      return const FrameStats(
        avgBuildMs: 0,
        avgRasterMs: 0,
        avgFps: 0,
        minFps: 0,
        maxFps: 0,
        p95BuildMs: 0,
        p95RasterMs: 0,
      );
    }

    final buildTimes = _frameMetrics
        .map((m) => m.buildDuration.inMicroseconds / 1000)
        .toList()
      ..sort();
    final rasterTimes = _frameMetrics
        .map((m) => m.rasterDuration.inMicroseconds / 1000)
        .toList()
      ..sort();

    return FrameStats(
      avgBuildMs: buildTimes.reduce((a, b) => a + b) / buildTimes.length,
      avgRasterMs: rasterTimes.reduce((a, b) => a + b) / rasterTimes.length,
      avgFps: averageFps,
      minFps: _frameMetrics.isEmpty
          ? 0
          : _calculateFps(buildTimes.first + rasterTimes.first),
      maxFps: _frameMetrics.isEmpty
          ? 0
          : _calculateFps(buildTimes.last + rasterTimes.last),
      p95BuildMs: _percentile(buildTimes, 95),
      p95RasterMs: _percentile(rasterTimes, 95),
    );
  }

  double _calculateFps(double totalMs) {
    if (totalMs <= 0) return 120;
    return 1000 / totalMs;
  }

  double _percentile(List<double> sorted, int percentile) {
    if (sorted.isEmpty) return 0;
    final index = ((percentile / 100) * sorted.length).floor();
    return sorted[index.clamp(0, sorted.length - 1)];
  }

  /// Log session summary.
  void logSessionSummary() {
    final stats = this.stats;
    _log('''
Performance Session Summary:
  Average FPS: ${stats.avgFps.toStringAsFixed(1)}
  Min FPS: ${stats.minFps.toStringAsFixed(1)}
  Max FPS: ${stats.maxFps.toStringAsFixed(1)}
  Avg Build: ${stats.avgBuildMs.toStringAsFixed(2)}ms
  Avg Raster: ${stats.avgRasterMs.toStringAsFixed(2)}ms
  P95 Build: ${stats.p95BuildMs.toStringAsFixed(2)}ms
  P95 Raster: ${stats.p95RasterMs.toStringAsFixed(2)}ms
''');
  }

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'Performance');
    }
  }
}

/// Metrics for a single frame.
class FrameMetrics {
  final DateTime timestamp;
  final Duration buildDuration;
  final Duration rasterDuration;

  const FrameMetrics({
    required this.timestamp,
    required this.buildDuration,
    required this.rasterDuration,
  });
}

/// Aggregated frame statistics.
class FrameStats {
  final double avgBuildMs;
  final double avgRasterMs;
  final double avgFps;
  final double minFps;
  final double maxFps;
  final double p95BuildMs;
  final double p95RasterMs;

  const FrameStats({
    required this.avgBuildMs,
    required this.avgRasterMs,
    required this.avgFps,
    required this.minFps,
    required this.maxFps,
    required this.p95BuildMs,
    required this.p95RasterMs,
  });

  bool get isJanky => avgBuildMs > 16.67 || avgRasterMs > 16.67;
  bool get isTargetMet => avgFps >= 110;
}

/// Widget for monitoring build performance.
class PerformanceOverlay extends StatefulWidget {
  const PerformanceOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<PerformanceOverlay> createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension for checking if performance targets are met.
extension PerformanceTargetCheck on FrameStats {
  bool get meets60FpsTarget => avgFps >= 55;
  bool get meets90FpsTarget => avgFps >= 85;
  bool get meets120FpsTarget => avgFps >= 110;

  String get targetStatus {
    if (meets120FpsTarget) return '120 FPS Target: MET ✓';
    if (meets90FpsTarget) return '90 FPS Target: MET (120 FPS: ✗)';
    if (meets60FpsTarget) return '60 FPS Target: MET (90 FPS: ✗)';
    return 'Performance below 60 FPS target ✗';
  }
}
