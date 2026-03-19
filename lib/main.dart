import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/src/features/login/login_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medical_assistant/src/network/kint_api_exception.dart';
import 'generated/l10n.dart';

void main() {
  FlutterError.onError = errorHandler;
  runApp(const MyApp());
}

// Обработка ошибок
void errorHandler(dynamic error) {
  if (error is KintApiException) {}
}

// Создание приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      //home: SessionsScreen(),
      home: LoginScreen()
    );
  }
}
