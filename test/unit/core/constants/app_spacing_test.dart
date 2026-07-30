import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_system/core/constants/app_spacing.dart';

void main() {
  group('AppSpacing', () {
    test('base spacing values are defined and positive', () {
      expect(AppSpacing.xs, greaterThan(0));
      expect(AppSpacing.sm, greaterThan(0));
      expect(AppSpacing.md, greaterThan(0));
      expect(AppSpacing.lg, greaterThan(0));
      expect(AppSpacing.xl, greaterThan(0));
      expect(AppSpacing.xxl, greaterThan(0));
      expect(AppSpacing.xxxl, greaterThan(0));
    });

    test('spacing values follow a progression pattern', () {
      expect(AppSpacing.sm, greaterThan(AppSpacing.xs));
      expect(AppSpacing.md, greaterThan(AppSpacing.sm));
      expect(AppSpacing.lg, greaterThan(AppSpacing.md));
      expect(AppSpacing.xl, greaterThan(AppSpacing.lg));
      expect(AppSpacing.xxl, greaterThan(AppSpacing.xl));
      expect(AppSpacing.xxxl, greaterThan(AppSpacing.xxl));
    });

    test('radius values are defined and positive', () {
      expect(AppSpacing.radiusSm, greaterThan(0));
      expect(AppSpacing.radiusMd, greaterThan(0));
      expect(AppSpacing.radiusLg, greaterThan(0));
      expect(AppSpacing.radiusXl, greaterThan(0));
      expect(AppSpacing.radiusPill, greaterThan(0));
    });

    test('layout constants are defined', () {
      expect(AppSpacing.maxContentWidth, greaterThan(0));
      expect(AppSpacing.minTouchTarget, greaterThanOrEqualTo(48.0));
      expect(AppSpacing.buttonHeight, greaterThan(0));
      expect(AppSpacing.inputHeight, greaterThan(0));
    });
  });
}
