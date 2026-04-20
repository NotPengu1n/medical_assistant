import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_assistant/core/branding/brand_theme_manager.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_data.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_screen.dart';
import 'package:medical_assistant/src/features/login/login_screen.dart';
import 'package:medical_assistant/src/features/rendered_services/rendered_services.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';
import 'package:medical_assistant/src/network/kint_api_exception.dart';
import 'package:medical_assistant/src/app/splash_screen.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';

void main() async {
  FlutterError.onError = errorHandler;

  await Hive.initFlutter();

  await CabinetsData.register();

  await BrandThemeManager.instance.restoreSavedTheme();

  runApp(const MedicalAssistant());
}

// Обработка ошибок
void errorHandler(dynamic error) {
  if (error is KintApiException) {}
}

// Создание приложения
class MedicalAssistant extends StatelessWidget {
  const MedicalAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      locale: PlatformDispatcher.instance.locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash',
      routes: AppNavigation.routes(),
    );
  }
}
