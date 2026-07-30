import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Achievement detail page.
class AchievementDetailPage extends StatelessWidget {
  const AchievementDetailPage({super.key, required this.achievementId});

  final String achievementId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'ACHIEVEMENT',
                      style: AppTypography.headingLarge.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HolographicContainer(
                        width: 160,
                        height: 160,
                        borderRadius: AppSpacing.radiusXl,
                        glowColor: AppColors.accentAmber,
                        glowIntensity: 0.4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                            color: AppColors.accentAmber.withOpacity(0.2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.emoji_events,
                              size: 80,
                              color: AppColors.accentAmber,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        'Achievement #$achievementId',
                        style: AppTypography.headingMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Achievement detail view',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
