import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';


/// Settings page with system preferences and integrations.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
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
                      'SETTINGS',
                      style: AppTypography.headingLarge.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  children: [
                    // Profile section
                    _SettingsSection(
                      title: 'PROFILE',
                      children: [
                        _SettingsTile(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your name and avatar',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.health_and_safety_outlined,
                          title: 'Health Integrations',
                          subtitle: 'Connect Apple Health or Health Connect',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Notifications section
                    _SettingsSection(
                      title: 'NOTIFICATIONS',
                      children: [
                        _SettingsToggle(
                          icon: Icons.notifications_outlined,
                          title: 'Mission Alerts',
                          subtitle: 'Get notified about new missions',
                          value: true,
                          onChanged: (value) {},
                        ),
                        _SettingsToggle(
                          icon: Icons.timer_outlined,
                          title: 'Recovery Reminders',
                          subtitle: 'Daily recovery status updates',
                          value: true,
                          onChanged: (value) {},
                        ),
                        _SettingsToggle(
                          icon: Icons.celebration_outlined,
                          title: 'Achievement Notifications',
                          subtitle: 'Celebrate your accomplishments',
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Display section
                    _SettingsSection(
                      title: 'DISPLAY',
                      children: [
                        _SettingsToggle(
                          icon: Icons.animation,
                          title: 'Animations',
                          subtitle: 'Enable holographic effects',
                          value: true,
                          onChanged: (value) {},
                        ),
                        _SettingsToggle(
                          icon: Icons.contrast,
                          title: 'High Contrast',
                          subtitle: 'Increase visual contrast',
                          value: false,
                          onChanged: (value) {},
                        ),
                        _SettingsToggle(
                          icon: Icons.vibration,
                          title: 'Haptic Feedback',
                          subtitle: 'Enable touch feedback',
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Privacy section
                    _SettingsSection(
                      title: 'PRIVACY & SECURITY',
                      children: [
                        _SettingsToggle(
                          icon: Icons.visibility_off_outlined,
                          title: 'Data Sharing',
                          subtitle: 'Share anonymized training data',
                          value: false,
                          onChanged: (value) {},
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'View our privacy practices',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          subtitle: 'View usage terms',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Data section
                    _SettingsSection(
                      title: 'DATA & STORAGE',
                      children: [
                        _SettingsTile(
                          icon: Icons.cloud_sync_outlined,
                          title: 'Sync Status',
                          subtitle: 'Last synced: 5 minutes ago',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.storage_outlined,
                          title: 'Clear Cache',
                          subtitle: 'Free up storage space',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.download_outlined,
                          title: 'Export Data',
                          subtitle: 'Download your training history',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // About section
                    _SettingsSection(
                      title: 'ABOUT',
                      children: [
                        _SettingsTile(
                          icon: Icons.info_outline,
                          title: 'Version',
                          subtitle: '1.0.0 (Build 1)',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.code,
                          title: 'Open Source Licenses',
                          subtitle: 'Third-party software',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Danger zone
                    _SettingsSection(
                      title: 'DANGER ZONE',
                      children: [
                        _SettingsTile(
                          icon: Icons.delete_forever_outlined,
                          title: 'Delete Account',
                          subtitle: 'Permanently remove your account',
                          isDestructive: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.huge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            letterSpacing: 2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            color: AppColors.surfaceGlass,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    color: AppColors.borderSubtle.withOpacity(0.5),
                    indent: AppSpacing.xxl + AppSpacing.md,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.accentError : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        color: isDestructive
                            ? AppColors.accentError
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(subtitle, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
