import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/domain/models/models.dart';
import '../../../../core/domain/providers/providers.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Analytics Dashboard - Production analytics with interactive charts.
class AnalyticsDashboardPage extends ConsumerStatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  ConsumerState<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends ConsumerState<AnalyticsDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedRange = 1; // 0: 7d, 1: 30d, 2: 90d, 3: all

  final List<String> _rangeLabels = ['7 Days', '30 Days', '90 Days', 'All Time'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameEngineProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRangeSelector(),
                  const SizedBox(height: AppSpacing.md),
                  _buildOverviewCards(gameState),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTabBar(),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildXPChart(gameState),
                        _buildWorkoutChart(gameState),
                        _buildRecoveryChart(gameState),
                        _buildStatsChart(gameState),
                        _buildAchievementChart(gameState),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      backgroundColor: AppColors.backgroundPrimary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'ANALYTICS',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildRangeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(4, (index) {
          final isSelected = _selectedRange == index;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentCyan.withOpacity(0.2)
                      : AppColors.surfaceGlass,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentCyan
                        : AppColors.borderSubtle,
                    width: 1,
                  ),
                ),
                child: Text(
                  _rangeLabels[index],
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.accentCyan
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOverviewCards(GameState state) {
    return Row(
      children: [
        Expanded(
          child: _OverviewCard(
            title: 'Total XP',
            value: state.xpState.totalXP.toString(),
            icon: Icons.star,
            color: AppColors.accentAmber,
            trend: _calculateTrend(state.recentEvents, SystemEventType.xpEarned),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _OverviewCard(
            title: 'Workouts',
            value: state.workoutHistory.length.toString(),
            icon: Icons.fitness_center,
            color: AppColors.accentCyan,
            trend: _calculateTrend(state.recentEvents, SystemEventType.workoutFinished),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _OverviewCard(
            title: 'Level',
            value: state.xpState.level.toString(),
            icon: Icons.arrow_upward,
            color: AppColors.accentPurple,
            trend: _calculateTrend(state.recentEvents, SystemEventType.levelUp),
          ),
        ),
      ],
    );
  }

  double _calculateTrend(List<SystemEvent> events, SystemEventType type) {
    if (events.isEmpty) return 0;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    
    final recentCount = events.where(
      (e) => e.type == type && e.timestamp.isAfter(weekAgo)
    ).length;
    final olderCount = events.where(
      (e) => e.type == type && e.timestamp.isAfter(twoWeeksAgo) && e.timestamp.isBefore(weekAgo)
    ).length;
    
    if (olderCount == 0) return recentCount > 0 ? 1.0 : 0;
    return (recentCount - olderCount) / olderCount;
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.accentCyan,
        indicatorWeight: 2,
        labelColor: AppColors.accentCyan,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'XP'),
          Tab(text: 'WORKOUTS'),
          Tab(text: 'RECOVERY'),
          Tab(text: 'STATS'),
          Tab(text: 'PRs'),
        ],
      ),
    );
  }

  Widget _buildXPChart(GameState state) {
    final dataPoints = _generateXPDataPoints(state.recentEvents);
    
    return _ChartContainer(
      title: 'XP History',
      subtitle: 'Experience points earned over time',
      chart: _buildLineChart(dataPoints, AppColors.accentAmber),
      stats: [
        _StatItem('Total', _formatNumber(dataPoints.fold(0, (a, b) => a + b))),
        _StatItem('Average', _formatNumber(_average(dataPoints))),
        _StatItem('Peak', _formatNumber(dataPoints.isEmpty ? 0 : dataPoints.reduce((a, b) => a > b ? a : b))),
      ],
    );
  }

  Widget _buildWorkoutChart(GameState state) {
    final dataPoints = _generateWorkoutDataPoints(state.recentEvents);
    final totalWorkouts = state.workoutHistory.length;
    
    return _ChartContainer(
      title: 'Workout Frequency',
      subtitle: 'Workouts completed per period',
      chart: _buildBarChart(dataPoints, AppColors.accentCyan),
      stats: [
        _StatItem('Total', totalWorkouts.toString()),
        _StatItem('Streak', '${state.xpState.streakDays} days'),
        _StatItem('This Week', dataPoints.fold(0, (a, b) => a + b).toString()),
      ],
    );
  }

  Widget _buildRecoveryChart(GameState state) {
    final recoveryValue = state.recovery.readinessScore.toInt();
    final dataPoints = [recoveryValue, recoveryValue, recoveryValue, recoveryValue];
    
    return _ChartContainer(
      title: 'Recovery Trend',
      subtitle: 'Weekly recovery scores',
      chart: _buildAreaChart(dataPoints, AppColors.accentSuccess),
      stats: [
        _StatItem('Current', '$recoveryValue%'),
        _StatItem('Status', _getRecoveryStatus(recoveryValue)),
        _StatItem('Level', state.recovery.level.name),
      ],
    );
  }

  String _getRecoveryStatus(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Moderate';
    return 'Low';
  }

  Widget _buildStatsChart(GameState state) {
    return _ChartContainer(
      title: 'Stat Progression',
      subtitle: 'Capability improvements',
      chart: _buildRadarChart(state.userStats),
      stats: [
        _StatItem('Strength', state.userStats.strength.current.toStringAsFixed(0)),
        _StatItem('Endurance', state.userStats.endurance.current.toStringAsFixed(0)),
        _StatItem('Mobility', state.userStats.mobility.current.toStringAsFixed(0)),
        _StatItem('Recovery', state.userStats.recovery.current.toStringAsFixed(0)),
        _StatItem('Precision', state.userStats.precision.current.toStringAsFixed(0)),
      ],
    );
  }

  Widget _buildAchievementChart(GameState state) {
    final completed = state.achievements.unlockedCount;
    final total = state.achievements.achievements.length;
    final progress = total > 0 ? completed / total : 0.0;
    
    return _ChartContainer(
      title: 'Achievement Progress',
      subtitle: 'Unlocked vs total achievements',
      chart: _buildProgressChart(progress, completed, total),
      stats: [
        _StatItem('Unlocked', completed.toString()),
        _StatItem('Remaining', (total - completed).toString()),
        _StatItem('Rate', '${(progress * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildLineChart(List<int> data, Color color) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _LineChartPainter(data, color),
    );
  }

  Widget _buildBarChart(List<int> data, Color color) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _BarChartPainter(data, color),
    );
  }

  Widget _buildAreaChart(List<int> data, Color color) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _AreaChartPainter(data, color),
    );
  }

  Widget _buildRadarChart(UserStats stats) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _RadarChartPainter(stats),
    );
  }

  Widget _buildProgressChart(double progress, int completed, int total) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceGlass,
                  valueColor: AlwaysStoppedAnimation(AppColors.accentPurple),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '$completed / $total',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  List<int> _generateXPDataPoints(List<SystemEvent> events) {
    final now = DateTime.now();
    final days = _selectedRange == 0 ? 7 : _selectedRange == 1 ? 30 : _selectedRange == 2 ? 90 : 365;
    final startDate = now.subtract(Duration(days: days));
    
    final filteredEvents = events.where(
      (e) => e.type == SystemEventType.xpEarned && e.timestamp.isAfter(startDate)
    );
    
    final Map<String, int> dailyXP = {};
    for (final event in filteredEvents) {
      final key = '${event.timestamp.year}-${event.timestamp.month}-${event.timestamp.day}';
      final currentValue = dailyXP[key] ?? 0;
      final xpToAdd = (event.data?['xp'] as int?) ?? 0;
      dailyXP[key] = currentValue + xpToAdd;
    }
    
    return List.generate(
      days > 30 ? 12 : days,
      (i) {
        final date = startDate.add(Duration(days: (i * days / (_selectedRange == 0 ? 7 : _selectedRange == 1 ? 12 : 12)).floor()));
        final key = '${date.year}-${date.month}-${date.day}';
        return dailyXP[key] ?? 0;
      },
    );
  }

  List<int> _generateWorkoutDataPoints(List<SystemEvent> events) {
    final now = DateTime.now();
    final days = _selectedRange == 0 ? 7 : _selectedRange == 1 ? 30 : _selectedRange == 2 ? 90 : 365;
    final startDate = now.subtract(Duration(days: days));
    
    final filteredEvents = events.where(
      (e) => e.type == SystemEventType.workoutFinished && e.timestamp.isAfter(startDate)
    );
    
    final Map<String, int> dailyWorkouts = {};
    for (final event in filteredEvents) {
      final key = '${event.timestamp.year}-${event.timestamp.month}-${event.timestamp.day}';
      dailyWorkouts[key] = (dailyWorkouts[key] ?? 0) + 1;
    }
    
    return List.generate(
      days > 30 ? 12 : days,
      (i) {
        final date = startDate.add(Duration(days: (i * days / (_selectedRange == 0 ? 7 : _selectedRange == 1 ? 12 : 12)).floor()));
        final key = '${date.year}-${date.month}-${date.day}';
        return dailyWorkouts[key] ?? 0;
      },
    );
  }

  List<int> _generateRecoveryDataPoints(List<int> scores) {
    if (scores.isEmpty) return [0, 0, 0, 0];
    final result = <int>[];
    final step = (scores.length / 4).ceil();
    for (int i = 0; i < 4; i++) {
      if (i * step < scores.length) {
        result.add(scores[i * step]);
      }
    }
    while (result.length < 4) {
      result.add(result.lastOrNull ?? 0);
    }
    return result;
  }

  String _getRecoveryTrend(List<int> data) {
    if (data.length < 2) return 'Stable';
    final recent = data.last;
    final older = data.first;
    final diff = recent - older;
    if (diff > 10) return 'Improving';
    if (diff < -10) return 'Declining';
    return 'Stable';
  }

  int _average(List<int> data) {
    if (data.isEmpty) return 0;
    return data.reduce((a, b) => a + b) ~/ data.length;
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double trend;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trend != 0)
              Row(
                children: [
                  Icon(
                    trend > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: trend > 0 ? AppColors.accentSuccess : AppColors.accentError,
                    size: 12,
                  ),
                  Text(
                    '${(trend.abs() * 100).toInt()}%',
                    style: TextStyle(
                      color: trend > 0 ? AppColors.accentSuccess : AppColors.accentError,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
          ],
        ),
        ),
      ),
    );
  }
}

class _ChartContainer extends StatelessWidget {
  const _ChartContainer({
    required this.title,
    required this.subtitle,
    required this.chart,
    required this.stats,
  });

  final String title;
  final String subtitle;
  final Widget chart;
  final List<_StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: stats.map((stat) => Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.md),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            stat.label,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            stat.value,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  _StatItem(this.label, this.value);
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(this.data, this.color);
  final List<int> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    if (maxVal == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final fillPath = Path();
    final step = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * step;
      final y = size.height - (data[i] / maxVal * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(path, paint);

    // Draw points
    for (int i = 0; i < data.length; i++) {
      final x = i * step;
      final y = size.height - (data[i] / maxVal * size.height);
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(this.data, this.color);
  final List<int> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    if (maxVal == 0) return;

    final barWidth = (size.width / data.length) * 0.7;
    final gap = (size.width / data.length) * 0.3;

    for (int i = 0; i < data.length; i++) {
      final x = i * (barWidth + gap) + gap / 2;
      final barHeight = (data[i] / maxVal) * size.height;
      final y = size.height - barHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(4),
      );

      canvas.drawRRect(
        rect,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _AreaChartPainter extends CustomPainter {
  _AreaChartPainter(this.data, this.color);
  final List<int> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    if (maxVal == 0) return;

    final path = Path();
    final step = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * step;
      final y = size.height - (data[i] / maxVal * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.1),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _RadarChartPainter extends CustomPainter {
  _RadarChartPainter(this.stats);
  final UserStats stats;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw grid circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * i / 3,
        Paint()
          ..color = AppColors.borderSubtle
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }

    // Stats values (normalized to 0-100)
    final values = [
      stats.strength.current / 100,
      stats.endurance.current / 100,
      stats.mobility.current / 100,
      stats.recovery.current / 100,
      stats.precision.current / 100,
    ];

    const angleStep = 3.14159 * 2 / 5;
    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final angle = -3.14159 / 2 + i * angleStep;
      final value = values[i].clamp(0.0, 1.0);
      final x = center.dx + radius * value * _cos(angle);
      final y = center.dy + radius * value * _sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accentCyan.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accentCyan
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double _cos(double x) {
  return 1 - x * x / 2 + x * x * x * x / 24 - x * x * x * x * x * x / 720;
}

double _sin(double x) {
  return x - x * x * x / 6 + x * x * x * x * x / 120 - x * x * x * x * x * x * x / 5040;
}
