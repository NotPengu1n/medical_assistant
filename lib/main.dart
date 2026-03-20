import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_data.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_screen.dart';
import 'package:medical_assistant/src/features/login/login_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';
import 'package:medical_assistant/src/network/kint_api_exception.dart';
import 'package:medical_assistant/src/app/splash_screen.dart';
import 'generated/l10n.dart';

void main() async {
  FlutterError.onError = errorHandler;

  await Hive.initFlutter();

  await CabinetsData.register();

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
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en"), Locale("ru")],
      locale: PlatformDispatcher.instance.locale,
      title: "null",
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash',
      routes: {
        AppNavigation.splashName : (context) => SplashScreen(),
        AppNavigation.loginName: (context) => LoginScreen(),
        AppNavigation.sessionName: (context) => SessionsScreen(),
        AppNavigation.cabinetsName: (context) => CabinetsScreen(),
      },
    );
  }
}
