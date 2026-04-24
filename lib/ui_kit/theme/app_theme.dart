import 'package:flutter/material.dart';
import '../../core/branding/brand_theme.dart';
import 'brand_theme_adapter.dart';

ThemeData buildLightTheme(TextTheme baseTextTheme, BrandTheme brand) {
  final textTheme = AppTypography.create(baseTextTheme);

  final colorScheme = ColorScheme.light(
    primary: brand.primary,
    secondary: brand.secondary,
    background: brand.background,
    surface: brand.surface,
    error: brand.error,
  );

  return ThemeData(
    useMaterial3: brand.useMaterial3,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: brand.background,
    textTheme: textTheme,
    dividerColor: brand.divider,

    appBarTheme: AppBarTheme(
      backgroundColor: brand.background,
      foregroundColor: brand.textPrimary,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: brand.textPrimary),
      titleTextStyle: textTheme.titleMedium?.copyWith(color: brand.textPrimary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.25)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
