// lib/ui_kit/theme/tokens.dart
import 'package:flutter/material.dart';
import 'brand_theme_adapter.dart';

/// Короткий доступ внутри компонентов:
/// AppT.c.primary, AppT.r.lg, AppT.s.md, AppT.sh.card
class AppT {
  AppT._();

  static final c = _Colors();
  static final r = _Radius();
  static final s = _Spacing();
  static final sh = _Shadows();
}

class _Colors {
  Color get primary => AppColors.primary;
  Color get primaryVariant => AppColors.primaryVariant;
  Color get secondary => AppColors.secondary;
  Color get accent => AppColors.accent;

  Color get background => AppColors.background;
  Color get surface => AppColors.surface;
  Color get surfaceVariant => AppColors.surfaceVariant;
  Color get mainActionBackground => AppColors.mainActionBackground;
  Color get secondaryActionBackground => AppColors.secondaryActionBackground;

  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textMuted => AppColors.textMuted;

  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => AppColors.error;
  Color get divider => AppColors.divider;

  Gradient get brandGradient => AppColors.brandGradient;
}

class _Radius {
  double get sm => AppRadius.sm;
  double get md => AppRadius.md;
  double get lg => AppRadius.lg;
  double get xl => AppRadius.xl;
}

class _Spacing {
  double get xs => AppSpacing.xs;
  double get sm => AppSpacing.sm;
  double get md => AppSpacing.md;
  double get lg => AppSpacing.lg;
  double get xl => AppSpacing.xl;
}

class _Shadows {
  BoxShadow get card => AppShadows.card;
  BoxShadow get button => AppShadows.button;
}
