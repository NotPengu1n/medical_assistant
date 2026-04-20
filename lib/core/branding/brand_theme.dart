// lib/core/branding/brand_theme.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class BrandShadowConfig {
  final Color color;
  final double blurRadius;
  final double spreadRadius;
  final Offset offset;

  const BrandShadowConfig({
    required this.color,
    required this.blurRadius,
    required this.spreadRadius,
    required this.offset,
  });

  factory BrandShadowConfig.fromJson(Map<String, dynamic> json) {
    Color parseColor(String value) {
      value = value.trim();
      if (value.startsWith('rgba')) {
        final match =
        RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([0-9.]+)\)').firstMatch(value);
        if (match != null) {
          final r = int.parse(match.group(1)!);
          final g = int.parse(match.group(2)!);
          final b = int.parse(match.group(3)!);
          final a = double.parse(match.group(4)!);
          return Color.fromRGBO(r, g, b, a);
        }
      }
      // hex #RRGGBB
      value = value.replaceAll('#', '');
      if (value.length == 6) value = 'FF$value';
      return Color(int.parse(value, radix: 16));
    }

    return BrandShadowConfig(
      color: parseColor(json['color'] as String),
      blurRadius: (json['blur'] as num).toDouble(),
      spreadRadius: (json['spread'] as num).toDouble(),
      offset: Offset(
        (json['offsetX'] as num).toDouble(),
        (json['offsetY'] as num).toDouble(),
      ),
    );
  }
}

class BrandTypographyConfig {
  final String fontFamily;
  final double scale;
  // Можно расширить weights при необходимости

  const BrandTypographyConfig({
    required this.fontFamily,
    required this.scale,
  });

  factory BrandTypographyConfig.fromJson(Map<String, dynamic> json) {
    return BrandTypographyConfig(
      fontFamily: json['fontFamily'] as String? ?? '',
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class BrandTheme {
  final String name;
  final String displayName;

  // Colors
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color mainActionBackground;
  final Color secondaryActionBackground;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color success;
  final Color warning;
  final Color error;
  final Color divider;

  final Color gradientStart;
  final Color gradientEnd;

  // Radius
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final double radiusExtraLarge;

  // Spacing
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double spacingXl;

  // Shadows
  final BrandShadowConfig cardShadow;
  final BrandShadowConfig buttonShadow;

  // Typography
  final BrandTypographyConfig typography;

  // Features / flags
  final bool useMaterial3;

  // Assets
  final String? logoAsset;
  final String? logoDarkAsset;

  const BrandTheme({
    required this.name,
    required this.displayName,
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.mainActionBackground,
    required this.secondaryActionBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.warning,
    required this.error,
    required this.divider,
    required this.gradientStart,
    required this.gradientEnd,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.radiusExtraLarge,
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.spacingXl,
    required this.cardShadow,
    required this.buttonShadow,
    required this.typography,
    required this.useMaterial3,
    required this.logoAsset,
    required this.logoDarkAsset,
  });

  factory BrandTheme.fromJson(Map<String, dynamic> json) {
    Color parseColor(String value) {
      value = value.trim();
      if (value.startsWith('rgba')) {
        final match =
        RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([0-9.]+)\)').firstMatch(value);
        if (match != null) {
          final r = int.parse(match.group(1)!);
          final g = int.parse(match.group(2)!);
          final b = int.parse(match.group(3)!);
          final a = double.parse(match.group(4)!);
          return Color.fromRGBO(r, g, b, a);
        }
      }
      value = value.replaceAll('#', '');
      if (value.length == 6) value = 'FF$value';
      return Color(int.parse(value, radix: 16));
    }

    final colors = json['colors'] as Map<String, dynamic>;
    final radius = json['radius'] as Map<String, dynamic>;
    final spacing = json['spacing'] as Map<String, dynamic>;
    final elevation = json['elevation'] as Map<String, dynamic>? ?? {};
    final shadows = json['shadows'] as Map<String, dynamic>;
    final typographyJson = json['typography'] as Map<String, dynamic>;
    final assets = json['assets'] as Map<String, dynamic>? ?? {};
    final gradient = colors['brandGradient'] as Map<String, dynamic>;

    return BrandTheme(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      primary: parseColor(colors['primary']),
      primaryVariant: parseColor(colors['primaryVariant']),
      secondary: parseColor(colors['secondary']),
      accent: parseColor(colors['accent']),
      background: parseColor(colors['background']),
      surface: parseColor(colors['surface']),
      surfaceVariant: parseColor(colors['surfaceVariant']),
      mainActionBackground: parseColor(colors['mainActionBackground']),
      secondaryActionBackground: parseColor(colors['secondaryActionBackground']),
      textPrimary: parseColor(colors['textPrimary']),
      textSecondary: parseColor(colors['textSecondary']),
      textMuted: parseColor(colors['textMuted']),
      success: parseColor(colors['success']),
      warning: parseColor(colors['warning']),
      error: parseColor(colors['error']),
      divider: parseColor(colors['divider']),
      gradientStart: parseColor(gradient['start']),
      gradientEnd: parseColor(gradient['end']),
      radiusSmall: (radius['small'] as num).toDouble(),
      radiusMedium: (radius['medium'] as num).toDouble(),
      radiusLarge: (radius['large'] as num).toDouble(),
      radiusExtraLarge: (radius['extraLarge'] as num).toDouble(),
      spacingXs: (spacing['xs'] as num).toDouble(),
      spacingSm: (spacing['sm'] as num).toDouble(),
      spacingMd: (spacing['md'] as num).toDouble(),
      spacingLg: (spacing['lg'] as num).toDouble(),
      spacingXl: (spacing['xl'] as num).toDouble(),
      cardShadow:
      BrandShadowConfig.fromJson(shadows['card'] as Map<String, dynamic>),
      buttonShadow:
      BrandShadowConfig.fromJson(shadows['button'] as Map<String, dynamic>),
      typography: BrandTypographyConfig.fromJson(typographyJson),
      useMaterial3:
      (json['features'] as Map<String, dynamic>?)?['useMaterial3'] as bool? ??
          true,
      logoAsset: assets['logo'] as String?,
      logoDarkAsset: assets['logoDark'] as String?,
    );
  }

  static BrandTheme fromJsonString(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return BrandTheme.fromJson(json);
  }
}
