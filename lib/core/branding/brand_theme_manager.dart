// lib/core/branding/brand_theme_manager.dart
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'brand_theme.dart';

class BrandThemeManager {
  BrandThemeManager._internal();
  static final BrandThemeManager instance = BrandThemeManager._internal();

  // =========================
  // v1 theme (existing)
  // =========================
  final ValueNotifier<BrandTheme?> _themeNotifier = ValueNotifier<BrandTheme?>(null);

  ValueListenable<BrandTheme?> get themeListenable => _themeNotifier;
  BrandTheme? get currentTheme => _themeNotifier.value;

  // =========================
  // v2 theme (new, parallel)
  // =========================
  final ValueNotifier<BrandTheme?> _themeNotifierV2 = ValueNotifier<BrandTheme?>(null);

  ValueListenable<BrandTheme?> get themeListenableV2 => _themeNotifierV2;
  BrandTheme? get currentThemeV2 => _themeNotifierV2.value;

  // =============================================================
  //  📌 ВАЖНО: гарантированное обновление темы
  //  Сбрасываем значение → выставляем новую тему
  // =============================================================
  void _emitTheme(BrandTheme theme) {
    _themeNotifier.value = null; // гарантированный rebuild
    _themeNotifier.value = theme;
  }

  void _emitThemeV2(BrandTheme theme) {
    _themeNotifierV2.value = null; // гарантированный rebuild
    _themeNotifierV2.value = theme;
  }

  // =============================================================
  //  📌 Основная загрузка темы (v1)
  // =============================================================
  Future<void> loadFromAssets(String name) async {
    debugPrint('🎨 Loading theme: $name');

    final path = 'assets/brands/$name/brand.json';

    try {
      final raw = await rootBundle.loadString(path);
      final theme = BrandTheme.fromJsonString(raw);
      _emitTheme(theme);
      return;
    } catch (e) {
      debugPrint('❌ Failed to load brand "$name": $e');
    }

    // -------------------------------------------------------------
    //  Fallback → base_theme
    // -------------------------------------------------------------
    try {
      debugPrint('➡️ Falling back to base_theme');
      final raw = await rootBundle.loadString('assets/brands/base_theme/brand.json');
      final theme = BrandTheme.fromJsonString(raw);
      _emitTheme(theme);
      return;
    } catch (e) {
      debugPrint('❌ Failed to load fallback base_theme: $e');
    }

    // -------------------------------------------------------------
    //  Если всё сломалось — оставляем null
    // -------------------------------------------------------------
    _themeNotifier.value = null;
  }

  // =============================================================
  //  📌 Основная загрузка темы (v2)
  // =============================================================
  Future<void> loadFromAssetsV2(String name) async {
    debugPrint('🎨 Loading V2 theme: $name');

    final path = 'assets/brands_v2/$name/brand.json';

    try {
      final raw = await rootBundle.loadString(path);
      final theme = BrandTheme.fromJsonString(raw);
      _emitThemeV2(theme);
      return;
    } catch (e) {
      debugPrint('❌ Failed to load V2 brand "$name": $e');
    }

    // -------------------------------------------------------------
    //  Fallback → base_theme (v2)
    // -------------------------------------------------------------
    try {
      debugPrint('➡️ Falling back to base_theme (V2)');
      final raw = await rootBundle.loadString('assets/brands_v2/base_theme/brand.json');
      final theme = BrandTheme.fromJsonString(raw);
      _emitThemeV2(theme);
      return;
    } catch (e) {
      debugPrint('❌ Failed to load V2 fallback base_theme: $e');
    }

    _themeNotifierV2.value = null;
  }

  // =============================================================
  //  📌 Восстановление темы при старте (v1)
  // =============================================================
  Future<void> restoreSavedTheme() async {
    final box = await Hive.openBox('settings');
    final savedName = box.get('active_brand', defaultValue: 'base_theme') as String;

    debugPrint('🔄 Restoring saved theme: $savedName');

    try {
      await loadFromAssets(savedName);
    } catch (e) {
      debugPrint('❌ restoreSavedTheme error: $e');
      await loadFromAssets('base_theme');
    }
  }

  // =============================================================
  //  📌 Восстановление темы при старте (v2)
  // =============================================================
  Future<void> restoreSavedThemeV2() async {
    final box = await Hive.openBox('settings');
    final savedName = box.get('active_brand_v2', defaultValue: 'base_theme') as String;

    debugPrint('🔄 Restoring saved V2 theme: $savedName');

    try {
      await loadFromAssetsV2(savedName);
    } catch (e) {
      debugPrint('❌ restoreSavedThemeV2 error: $e');
      await loadFromAssetsV2('base_theme');
    }
  }

  // =============================================================
  //  📌 Установка темы (например при сканировании QR-кода) (v1)
  // =============================================================
  Future<void> setCurrentBrand(String name) async {
    debugPrint('🔀 Switching theme to: $name');

    await loadFromAssets(name);

    final box = await Hive.openBox('settings');
    await box.put('active_brand', name);
  }

  // =============================================================
  //  📌 Установка темы (v2)
  // =============================================================
  Future<void> setCurrentBrandV2(String name) async {
    debugPrint('🔀 Switching V2 theme to: $name');

    await loadFromAssetsV2(name);

    final box = await Hive.openBox('settings');
    await box.put('active_brand_v2', name);
  }
}
