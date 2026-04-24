import 'package:flutter/material.dart';
import '../../core/branding/brand_theme_manager.dart';
import '../../core/branding/brand_theme.dart';

BrandTheme get _brand => BrandThemeManager.instance.currentTheme!;

class AppColors {
  static Color get primary => _brand.primary;
  static Color get primaryVariant => _brand.primaryVariant;
  static Color get secondary => _brand.secondary;
  static Color get accent => _brand.accent;

  static Color get background => _brand.background;
  static Color get surface => _brand.surface;
  static Color get surfaceVariant => _brand.surfaceVariant;
  static Color get mainActionBackground => _brand.mainActionBackground;
  static Color get secondaryActionBackground => _brand.secondaryActionBackground;

  static Color get textPrimary => _brand.textPrimary;
  static Color get textSecondary => _brand.textSecondary;
  static Color get textMuted => _brand.textMuted;

  static Color get success => _brand.success;
  static Color get warning => _brand.warning;
  static Color get error => _brand.error;
  static Color get divider => _brand.divider;

  static Gradient get brandGradient => LinearGradient(
    colors: [_brand.gradientStart, _brand.gradientEnd],
  );
}

class AppRadius {
  static double get sm => _brand.radiusSmall;
  static double get md => _brand.radiusMedium;
  static double get lg => _brand.radiusLarge;
  static double get xl => _brand.radiusExtraLarge;
}

class AppSpacing {
  static double get xs => _brand.spacingXs;
  static double get sm => _brand.spacingSm;
  static double get md => _brand.spacingMd;
  static double get lg => _brand.spacingLg;
  static double get xl => _brand.spacingXl;
}

class AppShadows {
  static BoxShadow get card => BoxShadow(
    color: _brand.cardShadow.color,
    blurRadius: _brand.cardShadow.blurRadius,
    spreadRadius: _brand.cardShadow.spreadRadius,
    offset: _brand.cardShadow.offset,
  );

  static BoxShadow get button => BoxShadow(
    color: _brand.buttonShadow.color,
    blurRadius: _brand.buttonShadow.blurRadius,
    spreadRadius: _brand.buttonShadow.spreadRadius,
    offset: _brand.buttonShadow.offset,
  );
}

class AppTypography {
  /// Inter Tight для заголовков, Inter для тела — как в твоих FlutterFlow токенах.
  static TextTheme create(TextTheme base) {
    final cfg = _brand.typography;
    final scale = cfg.scale;

    const headlineFamily = 'Inter Tight';
    const bodyFamily = 'Inter';

    TextStyle? headline(TextStyle? s) {
      if (s == null) return null;
      return s.copyWith(
        fontFamily: headlineFamily,
        fontWeight: FontWeight.w600,
        fontSize: s.fontSize != null ? s.fontSize! * scale : null,
        color: AppColors.textPrimary,
      );
    }

    TextStyle? body(TextStyle? s) {
      if (s == null) return null;
      return s.copyWith(
        fontFamily: bodyFamily,
        fontWeight: FontWeight.w400,
        fontSize: s.fontSize != null ? s.fontSize! * scale : null,
        color: AppColors.textPrimary,
      );
    }

    TextStyle? label(TextStyle? s) {
      if (s == null) return null;
      return s.copyWith(
        fontFamily: bodyFamily,
        fontWeight: FontWeight.w400,
        fontSize: s.fontSize != null ? s.fontSize! * scale : null,
        color: AppColors.textSecondary,
      );
    }

    return base.copyWith(
      displayLarge: headline(base.displayLarge),
      displayMedium: headline(base.displayMedium),
      displaySmall: headline(base.displaySmall),

      headlineLarge: headline(base.headlineLarge),
      headlineMedium: headline(base.headlineMedium),
      headlineSmall: headline(base.headlineSmall),

      titleLarge: headline(base.titleLarge),
      titleMedium: headline(base.titleMedium),
      titleSmall: headline(base.titleSmall),

      bodyLarge: body(base.bodyLarge),
      bodyMedium: body(base.bodyMedium),
      bodySmall: body(base.bodySmall),

      labelLarge: label(base.labelLarge),
      labelMedium: label(base.labelMedium),
      labelSmall: label(base.labelSmall),
    );
  }
}
