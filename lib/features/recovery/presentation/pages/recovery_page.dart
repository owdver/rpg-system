import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Recovery page showing sleep, readiness, and recovery metrics.
class RecoveryPage extends ConsumerWidget {
  const RecoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'RECOVERY',
                  style: AppTypography.headingLarge.copyWith(letterSpacing: 2),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Overall readiness
                    const _ReadinessOverview(),
                    const SizedBox(height: AppSpacing.xxl),

                    // Sleep analysis
                    const _SleepSection(),
                    const SizedBox(height: AppSpacing.xxl),

                    // Recovery metrics
                    const _RecoveryMetricsSection(),
                    const SizedBox(height: AppSpacing.xxl),

                    // Recommendations
                    const _RecommendationsSection(),
                    const SizedBox(height: AppSpacing.huge),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadinessOverview extends StatelessWidget {
  const _ReadinessOverview();

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusXl,
      glowColor: AppColors.accentSuccess,
      glowIntensity: 0.3,
      enableScanline: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Text(
              'OVERALL READINESS',
              style: AppTypography.labelMedium.copyWith(
                letterSpacing: 2,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentSuccess.withOpacity(0.3),
                    AppColors.accentSuccess.withOpacity(0.0),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accentSuccess,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '87',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.accentSuccess,
                          ),
                        ),
                        Text(
                          'READY',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.accentSuccess,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Excellent condition for training',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.accentSuccess,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepSection extends StatelessWidget {
  const _SleepSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SLEEP ANALYSIS',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        HolographicContainer(
          borderRadius: AppSpacing.radiusLg,
          glowColor: AppColors.accentBlue,
          glowIntensity: 0.2,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SleepMetric(
                        label: 'Duration',
                        value: '7h 32m',
                        icon: Icons.bedtime,
                        color: AppColors.accentViolet,
                      ),
                    ),
                    Container(width: 1, height: 50, color: AppColors.borderSubtle),
                    Expanded(
                      child: _SleepMetric(
                        label: 'Quality',
                        value: 'Good',
                        icon: Icons.star,
                        color: AppColors.accentAmber,
                      ),
                    ),
                    Container(width: 1, height: 50, color: AppColors.borderSubtle),
                    Expanded(
                      child: _SleepMetric(
                        label: 'HRV',
                        value: '62ms',
                        icon: Icons.favorite,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    color: AppColors.surfaceGlass,
                  ),
                  child: CustomPaint(
                    painter: _SleepChartPainter(),
                    size: const Size(double.infinity, 60),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10:30 PM', style: AppTypography.labelSmall),
                    Text('Sleep', style: AppTypography.labelSmall),
                    Text('6:02 AM', style: AppTypography.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SleepMetric extends StatelessWidget {
  const _SleepMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTypography.numericMedium.copyWith(color: color)),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _SleepChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentBlue
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);
    
    // Create a sleep stage chart
    final stages = [
      (0.0, 0.4),
      (0.1, 0.6),
      (0.2, 0.2),
      (0.3, 0.1),
      (0.4, 0.5),
      (0.5, 0.3),
      (0.6, 0.8),
      (0.7, 0.6),
      (0.8, 0.4),
      (0.9, 0.5),
      (1.0, size.height),
    ];

    for (final stage in stages) {
      path.lineTo(size.width * stage.$1, size.height * stage.$2);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RecoveryMetricsSection extends StatelessWidget {
  const _RecoveryMetricsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOVERY METRICS',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Heart Rate',
                value: '58',
                unit: 'bpm',
                status: 'Optimal',
                color: AppColors.accentError,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _MetricCard(
                label: 'HRV',
                value: '62',
                unit: 'ms',
                status: 'Good',
                color: AppColors.accentCyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Resting HR',
                value: '52',
                unit: 'bpm',
                status: 'Excellent',
                color: AppColors.accentSuccess,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _MetricCard(
                label: 'Stress',
                value: 'Low',
                unit: '',
                status: 'Recovered',
                color: AppColors.accentViolet,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      borderRadius: AppSpacing.radiusMd,
      glowColor: color,
      glowIntensity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelSmall),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTypography.numericLarge.copyWith(color: color),
                ),
                if (unit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      unit,
                      style: AppTypography.labelSmall.copyWith(color: color),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color.withOpacity(0.2),
              ),
              child: Text(
                status,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SYSTEM RECOMMENDATION',
          style: AppTypography.labelMedium.copyWith(letterSpacing: 2),
        ),
        const SizedBox(height: AppSpacing.md),
        HolographicContainer(
          borderRadius: AppSpacing.radiusLg,
          glowColor: AppColors.accentAmber,
          glowIntensity: 0.2,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    color: AppColors.accentAmber.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.accentAmber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'High Intensity Approved',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.accentAmber,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Your recovery metrics indicate you are ready for a high-intensity training session today.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
